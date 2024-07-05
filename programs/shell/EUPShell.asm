#######################################################
## The EUP Shell
#######################################################
W main      # Set reset vector to main
O 0010      # Start rom constants at 0x0010 ROM ADDRESS

###### Shell Globals ###################################
V CmdStr    # The command line entered
a FF
C CMDSTRMAX 0xFE
V CmdStrLen # The length of the command entered
a 1

V main.cmdlen   # The first word len = command 
a 1
V main.pCmdMap  # Temp cmd map pointer to the entry of interest
a 2

C sys.topline 6      # 1 based
C sys.cursorChar 0x5F
C sys.scrwidth 0x50

# include both libraries and command execution functions
I ..\stdlibs\StringLib.asm
I ..\stdlibs\Math.asm
I ..\stdlibs\UtilFunctions.asm
I ..\stdlibs\BCDLib.asm

I ..\displaylibs\vt100.asm
I ..\displaylibs\BigLED.asm
I ..\displaylibs\BoxDrawing.asm

I AsciiShelldon.asm
I externalincludes.asm

#######################################################
# Shell Constants
D shellPrompt
S S:\0

D unknownCmd
S  Unknown Command! - "?" for help\0

# A command map consists of a pointer to a command 
#   string (case sensitive)
# A pointer to the function for the command
# A pointer to the Help message for the command

# Built in single character commands
# help - show list of internal commands or the help string if
#        'help command' entered
D helpCmd
S ?\0
D helpMsg
S ?: This List of Commands\0

# Ascii Table - prints the ascii table from Space 0x20 to 0xFF
D asciiCmd
S a\0
D asciiMsg
S a: Prints the ascii table from Space 0x20 to 0xFF\0

# c: clear command clear the screen
D clearCmd
S c\0
D clearMsg
S c: Clears the screen\0

# v: echo a VT command by surrounding it with esc chars
D echoVTCmd
S v\0
D echoVTMsg
S v: Echos the string surrounding it with esc chars as a VT100 command\0


C cmdMapEntrySize 6 # char cmdMapEntrySize = sizeof(CmdMapentry);
D shellCmdMap      # struct CmdMapEntry {
W helpCmd          # short *CmdWord = helpCmd; 
W helpFunc         # short *CmdFunc = helpFunc;
W helpMsg          # short *CmdMsg = helpMsg;}

W asciiCmd
W PrintASCIITbl
W asciiMsg

W clearCmd
W clearFunc
W clearMsg

W DisplayHexValuesCmd
W DisplayHexValues
W DisplayHexValuesMsg

W echoVTCmd
W echoVT
W echoVTMsg



I externalcmds.asm

L 00 00  # this null indicates the end of the table

V oneWord
a 40

# While additional commands could be built-in keeping each
# program to a set of other files will be more flexible only
# the single letter commands are included here
#######################################################
D echoVT
  LDR CmdStr
  IND
  IND
  W1E 'ESC
  CAL printStr1D
  W1E 'ESC
  RTL

#######################################################
D clearFunc
  LDR VTCLR
  CAL printStr1E
  LDR VTHOME
  CAL printStr1E
  RTL
#######################################################

D helpHdr
S EUPShell Valid Commands\n
S -----------------------\n\0
#######################################################
D helpFunc
  # Run through the shell Cmd Map printing command strings
   # set the tmp var pCmdMap to the top of the Cmd map table
   
  LDR helpHdr
  CAL printStr1E
  
  LDR shellCmdMap
  LAR
  LBD
  LDR main.pCmdMap
  SIA
  IND
  SIB
  
D helpFunc.doall   # print commands
  LDR main.pCmdMap
  LAM
  IND
  LDM
  LRA
  LAF
  IND
  LBF
  OBA
  JLN helpFunc.domore
  # no more to print - exit
  RTL
  
D helpFunc.domore
  # print out the command names and advance the pointer
  LDR main.pCmdMap
  LAM
  IND
  LDM
  LRA
  # add 4 bytes to get to the help string for the command
  LAE 4
  EDA

  LAF
  IND
  LDF
  LRA
  
  CAL printStr1E
  W1E 'LF
  LDR main.pCmdMap
  LAM
  IND
  LDM
  LRA
  LAE cmdMapEntrySize
  EDA
  LAR
  LBD
  LDR main.pCmdMap
  SIA
  IND
  SIB
  JPL helpFunc.doall 

#######################################################
D main # The EUP shell provides a CLI framework for a EUP5108 based PC
  
  LDR VTRST       # Reset screen colors
  CAL printStr1E  
  LDR VTCLR       # Clear screen
  CAL printStr1E
  
  LDR ASCIIShelldon # Print shelldon
  CAL printStr1E    
  
D main.do         # Command loop
  LDR shellPrompt # Print prompt
  CAL printStr1E
  LAE CMDSTRMAX
  LDR CmdStr      # Get command from user
  CAL getLine
  W1E 'LF
  
  # save off the whole command string length
  LDR CmdStr
  CAL strlen
  LBA
  JLN main.proc
  JPL main.do
D main.proc  
  LDR CmdStrLen
  SIA
    
  # setup strcpyDelim as a space to copy just the first word
  LDR strcpyDelim
  LAE 'SP
  SIA
  # put the src and then dst string pointers onto the stack
  LDR CmdStr
  SCR
  SCD
  LDR oneWord
  SCR
  SCD
  CAL strcpy
  INS
  INS
  INS
  INS

  # reset strcpyDelim to zero
  LDR strcpyDelim
  LAZ
  SIA
  
  # store the strlen of the command
  LDR oneWord
  CAL strlen
  LDR main.cmdlen
  SIA

  # set the tmp var pCmdMap to the top of the Cmd map table
  LDR shellCmdMap
  LAR
  LBD
  LDR main.pCmdMap
  SIA
  IND
  SIB
  
D main.mapsearch
  # check if we are at the end of the table
  LDR main.pCmdMap
  LAM
  IND
  LDM
  LRA
  LAF
  IND
  LBF
  OBA
  JLN main.chk4cmdmatch

  #  At this point we are at the end of the table w/o a match
  W1E '"
  LDR oneWord
  CAL printStr1D
  W1E '"
  LDR unknownCmd
  CAL printStr1E
  W1E 'LF
  JPL main.do
  
  # check for a match
D main.chk4cmdmatch  
  # Compare the oneword entered to the command string of this entry
  LDR main.pCmdMap    
  LAM
  IND
  LDM
  LRA
  LAF
  SCA
  IND
  LAF
  SCA
  LDR oneWord # First word entered
  SCR
  SCD
  CAL strcmpconst
  INS
  INS
  INS
  INS
  
  LAB
  LBA
  JLN main.cmdnext
  # This is a match so call the function pointer with A = cmdstr offset
  
  # load A with the command string length
  LDR main.cmdlen
  LAM

  # get the function pointer into DR
  LDR main.pCmdMap    
  LBM
  IND
  LDM
  LRB
  # skip the first two bytes (pCommand)
  IND
  IND
  # Load the next two bytes into DR
  LBF
  IND
  LDF
  LRB
  # Call the function pointer via code writes
  CAL callFNptr

  JPL main.do
  
D main.cmdnext

  LDR main.pCmdMap
  LAM
  IND
  LDM
  LRA
  LAE cmdMapEntrySize  # shellCmdMap[i]
  EDA
  LAR
  LBD
  LDR main.pCmdMap
  SIA
  IND
  SIB
  JPL main.mapsearch
  
#######################################################
D DisplayHexValuesCmd
S d\0
D DisplayHexValuesMsg
S d: Displays the string of hex values as characters\0

D DisplayHexValues  
C DHV.Temp 1  # char Temp;
C DHV.i 2
  DES
  DES

  #W1E 'LF
  
  POE DHV.Temp #Temp = 0;
  LAZ
  SIA
  
  POE DHV.i #i=1
  LAE 2
  SIA
  
  # set the command to upper case
  LDR CmdStr
  CAL toUpperStr

D DHV.loop
  POE DHV.i
  LAM

  LDR CmdStr
  EDA

  LBM 
  CAL isHexDigitB
  
  LTO
  MAT
  JLN DHV.xit
  TLB 
  TLB 
  TLB 
  TLB   
  POE DHV.Temp
  SIB
  
  POE DHV.i  # i++
  LAM
  INA
  SIA
  
  LDR CmdStr
  EDA

  LBM 
  CAL isHexDigitB
  LTO
  MAT
  JLN DHV.xit
  POE DHV.Temp
  LAM
  EBA
  SIB

  W1B # echo the character
  
  POE DHV.i  # i++
  LAM
  INA
  SIA
  
  JPL DHV.loop

D DHV.xit  
  W1E 'LF
  INS
  INS

  RTL
  
##########################################################  
D PlayHexValues
C PHV.Temp 1  # char Temp;
C PHV.i 2
  DES
  DES

  #W1E 'LF
  
  POE PHV.Temp #Temp = 0;
  LAZ
  SIA
  
  POE PHV.i #i=1
  LAO
  SIA
  
  # set the command to upper case
  LDR CmdStr
  CAL toUpperStr

D PHV.loop
  POE PHV.i
  LAM

  LDR CmdStr
  EDA

  LBM 
  CAL isHexDigitB
  
  LTO
  MAT
  JLN PHV.xit
  TLB 
  TLB 
  TLB 
  TLB   
  POE PHV.Temp
  SIB
  
  POE PHV.i  # i++
  LAM
  INA
  SIA
  
  LDR CmdStr
  EDA

  LBM 
  CAL isHexDigitB
  LTO
  MAT
  JLN PHV.xit
  POE PHV.Temp
  LAM
  EBA
  SIB

  W2B # echo the character to the sound port
  
  POE PHV.i  # i++
  LAM
  INA
  SIA
  
  JPL PHV.loop

D PHV.xit  
  W1E 'LF
  INS
  INS

  RTL
