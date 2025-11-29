#$---- 
#$## shell/EUPShell.asm
#$     The EUP Shell program for testing of other
#$     programs via extendable menu system
#######################################################
W main      # Set reset vector to main
O 0010      # Start rom constants at 0x0010 ROM ADDRESS

I ..\stdlibs\sys.asm # Always include sys.asm before any
                     # other vars are declared
                     
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

# include both libraries and command execution functions
I ..\stdlibs\StringLib.asm
#I ..\stdlibs\Math.asm
I ..\stdlibs\UtilFunctions.asm
I ..\stdlibs\BCDLib.asm
I ..\stdlibs\time.asm

I ..\displaylibs\vt100.asm
I ..\displaylibs\BigLED.asm
I ..\displaylibs\BoxDrawing.asm

I AsciiShelldon.asm

#$
#$     externalincludes.asm
#$     contains the additional program entry points
#$     and command map constants

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
D shellCmdMap       # struct CmdMapEntry {
W helpCmd           # short *CmdWord = helpCmd; 
W helpFunc          # short *CmdFunc = helpFunc;
W helpMsg           # short *CmdMsg = helpMsg;}

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

W zoneCMD
W setZone
W zoneCMDHelp

W dateCmd
W date
W dateCmdHelp

W timeCmd
W time
W timeCmdHelp

W datetimeCmd
W datetime
W datetimeCmdHelp

W bigtimeCmd
W bigtime
W bigtimeCmdHelp

#$
#$     externalcmds.asm
#$     contains the additional command map entries
#$      Command string (case sensitive)
#$      A pointer to the function for the command
#$      A pointer to the Help message for the command
#$     

I externalcmds.asm #external commands

L 00 00  # this null indicates the end of the table

V oneWord
a 40

D zoneCMD
S z\0
D zoneCMDHelp
S z: Set time zone local (1) GMT (2) RTC off (0)\0
#######################################################
D setZone
  LDR CmdStr
  IND
  IND
  LAM
  LBE '0
  MAB
  LDR RTCZone
  SIA
  RTL


# While additional commands could be built-in keeping 
# each program to a set of other files will be more 
# flexible only the single letter commands are 
# included here
#######################################################
D echoVT
  LDR CmdStr #Get CmdStr[0]
  IND #DR++ Skip command letter
  IND #DR++ Skip space
  W1E 'ESC #Send VT esc
  CAL printStr1D #print the string
  W1E 'ESC #Send ending VT esc
  RTL

#######################################################
D clearFunc
  LDR VTCLR
  CAL printStr1E #Print the VTCLR string
  LDR VTHOME
  CAL printStr1E #Print the VTHOME string
  RTL
#######################################################

D helpHdr
S EUPShell Valid Commands\n
S -----------------------\n\0

#######################################################
D helpFunc #Define helpFunc
  # Run through the shell Cmd Map printing command strings

  # set the tmp var pCmdMap to the top of the Cmd map table
  LDR helpHdr
  CAL printStr1E #print the rom string at helpHdr

  # Load the temp var main.pCmdMap with the location of
  # the command map in rom  
  LDR shellCmdMap #DR = *shellCmdMap (rom loc)
  LAR #A = R
  LBD #B = D
  LDR main.pCmdMap #DR = *main.pCmdMap (ram loc)
  SIA # *DR = a
  IND # DR++
  SIB # *DR = b
  
D helpFunc.doall   # print commands
  #First check the exit condition of 00 00
  LDR main.pCmdMap 
  LAM #Load A with byte at *DR (ram)
  IND #Increment DR
  LDM #Load D with byte at *DR (ram)
  LRA #Load R with A
  LAF #Load A with byte at *DR (rom)
  IND #DR++
  LBF #Load B with byte at *DR (rom)
  OBA #B = B ored with A
  JLN helpFunc.domore #If any bits are set then they weren't 00 00
  # no more to print - exit
  RTL #Otherwise return
  
D helpFunc.domore
  # print out the command names and advance the pointer
  LDR main.pCmdMap
  LAM #Load A with byte at *DR (ram)
  IND #DR++
  LDM #Load D with byte at *DR (ram)
  LRA #R = A
  # add 4 bytes to get to the help string for the command
  LAE 4 #A = 4
  EDA #DR = DR+A
  # Load pointer to help string into DR
  LAF #Load A with byte at *DR (rom)
  IND #DR++
  LDF #Load D with byte at *DR (rom)
  LRA #R = A
  # print the help string + \n
  CAL printStr1E
  W1E 'LF
  # Increment main.pCmdMap by cmdMapEntrySize
  LDR main.pCmdMap
  LAM #Load A with byte at *DR (ram)
  IND #DR++
  LDM #Load D with byte at *DR (ram)
  LRA #R = A
  LAE cmdMapEntrySize #Load A with cmdMapEntrySize
  EDA #DR += A
  LAR #A = R
  LBD #B = D
  LDR main.pCmdMap #DR = main.pCmdMap
  SIA #Store A at *DR (ram)
  IND #DR++
  SIB #Store B at *DR (ram)
  JPL helpFunc.doall #Loop

#######################################################
D main # The EUP shell provides a CLI framework for a 
       # EUP5108 based PC
  
  HLT
  
  NOP
  
  HLT
  
  LDR VTRST       # Reset screen colors
  CAL printStr1E  
  LDR VTCLR       # Clear screen
  CAL printStr1E
  
  HLT
  
  LDR ASCIIShelldon # Print shelldon
  CAL printStr1E    
  
  LDR RTCZone     # Set the RTCZone for local
  LAO
  SIA
  
D main.do         # Command loop
  
  LDR shellPrompt # Print prompt
  CAL printStr1E
  LAE CMDSTRMAX   # Max length of command string
  LDR CmdStr      # DR = CmdString (ram)
  CAL getLine     # Get command from user
  W1E 'LF         # print \n
  
  # save off the whole command string length
  LDR CmdStr
  CAL strlen
  LBA             # B = A return from strlen(CmdStr)
  JLN main.proc   # if nonzero flag set jump to main.proc
  JPL main.do     # else loop for next command
  
  #Process the command entered
D main.proc  
  LDR CmdStrLen
  SIA             # CmdStrLen = A 
    
  # setup strcpyDelim as a space to copy just the first word
  LDR strcpyDelim
  LAE 'SP
  SIA             # strcpyDelim = ' '  
  # put the src and then dst string pointers onto the stack
  LDR CmdStr      # DR = CmdStr
  SCR             # Push R onto stack
  SCD             # Push D onto stack
  LDR oneWord     # DR = oneWord
  SCR             # Push R onto stack
  SCD             # Push D onto stack
  CAL strcpy      # Call strcpy (stops at first ' ')
  INS		  # Clean up stack oneWord MSB
  INS		  # Clean up stack oneWord LSB
  INS		  # Clean up stack CmdStr MSB
  INS		  # Clean up stack CmdStr LSB

  # reset strcpyDelim to zero
  LDR strcpyDelim
  LAZ #A = 0
  SIA             # strcpyDelim = 0		  	
  
  # store the strlen of the command
  LDR oneWord
  CAL strlen     # A = strlen(oneWord)
  LDR main.cmdlen
  SIA            # main.cmdLen = A

  # set the tmp var pCmdMap to the top of the Cmd map table
  LDR shellCmdMap    # DR = shellCmdMap (rom)
  LAR # A = R
  LBD # B = D
  LDR main.pCmdMap   # DR = main.pCmdMap (ram)
  SIA # *DR = A
  IND # DR++
  SIB # *DR = B
  
D main.mapsearch
  # check if we are at the end of the table
  LDR main.pCmdMap # DR = main.pCmdMap (ram)
  LAM # A = *DR (ram)
  IND # DR++
  LDM # D = *DR (ram)
  LRA # R = A
  # DR now = *main.pCmdMap
  LAF # A = *DR (rom)
  IND # DR++
  LBF # B = *DR (rom)
  OBA # B = B | A
  JLN main.chk4cmdmatch # if nonzero flag set then we are not 
                        # at the end of the table so check for
                        # a match

  #  Else we are at the end of the table w/o a match
  #  Print "{oneWord}" Unknown Command! - "?" for help\n 
  W1E '"
  LDR oneWord
  CAL printStr1D
  W1E '"
  LDR unknownCmd
  CAL printStr1E
  W1E 'LF
  # Loop back to the top
  JPL main.do
  
  # check for a command that matches oneWord
D main.chk4cmdmatch  
  # Compare the oneword entered to the command string of this entry
  LDR main.pCmdMap    # DR = main.pCmdMap
  LAM # A = *DR (ram)
  IND # DR++
  LDM # D = *DR (ram)
  LRA # R = A
  LAF # A = *DR
  SCA # *SP = A (sp--) Push A onto Stack
  IND # DR++
  LAF # A = *DR
  SCA # *SP = A (sp--) Push A onto Stack

  # Now the command string from the command map is on the stack
  LDR oneWord # First word entered
  SCR # Push R onto stack
  SCD # Push D onto stack
  CAL strcmpconst # Call strcmp(oneWord [ram] to command map command [rom])
  INS # clean up stack oneWord MSB
  INS # clean up stack oneWord LSB
  INS # clean up stack CmdMap command MSB
  INS # clean up stack CmdMap command LSB
  
  LAB # Load B (return from strcmpconst) into A
  LBA # Load B with A - to set flags
  JLN main.cmdnext #if nonzero flag set so check next one
  
  # This is a match so call the function pointer with A = cmdstr offset
  # load A with the command string length
  LDR main.cmdlen # DR = &main.cmdlen
  LAM # A = main.cmdLen

  # get the function pointer into DR
  LDR main.pCmdMap # DR = main.pCmdMap (ram)  
  LBM #B = *DR (ram)
  IND #DR++
  LDM #D = *DR (ram)
  LRB #R = B
  # DR now = main.pCmdMap
  # skip the first two bytes (pCommand)
  IND
  IND
  # Load the next two bytes into DR
  LBF #B = *DR (rom)
  IND #DR++
  LDF #D = *DR (rom)
  LRB #R = B
  # Call the function pointer via writes to rom
  CAL callFNptr

  JPL main.do
  
D main.cmdnext

  LDR main.pCmdMap #DR = &main.pCmdMap 
  LAM # A = *DR (ram)
  IND # DR++
  LDM # D = *DR (ram)
  LRA # R = A
  LAE cmdMapEntrySize  # size of one entry
  EDA # DR += A
  LAR # A = R
  LBD # B = D
  LDR main.pCmdMap #DR = &main.pCmdMap
  SIA # *DR = A
  IND # DR++
  SIB # *DR = B
  JPL main.mapsearch
  
#######################################################
D DisplayHexValuesCmd
S d\0
D DisplayHexValuesMsg
S d: Displays the string of hex values as characters\0

D DisplayHexValues  
C DHV.Temp 1  # char Temp;
C DHV.i 2
  DES         # make space on the stack for locals
  DES

  #W1E 'LF
  
  POE DHV.Temp #DR = SP + DHV.Temp (1) 
  LAZ # A = 0
  SIA # *DR = A (ram)
  
  POE DHV.i #DR = SP + DHV.i (2)
  LAE 2 # A = 2
  SIA # *DR = A
  
  # set the command to upper case
  LDR CmdStr
  CAL toUpperStr

D DHV.loop
  POE DHV.i #DR = SP + 2 (local i)
  LAM #A = *DR

  LDR CmdStr #DR = CmdStr[0]
  EDA #DR += i

  LBM #B = *DR (CmdStr[i])
  CAL isHexDigitB #Returns in A 0/1 is a hex digit
                  #the numeric value 0..15 is returned in B
                  #of a character '0'..'9' or 'A'..'F'
  
  LTO #T = 0
  MAT #A = A - T
  JLN DHV.xit # if nz flag set it is not a hex digit
  TLB 
  TLB 
  TLB 
  TLB #B << 4  
  POE DHV.Temp #DR = SP+1 (local Temp)
  SIB #*DR = B

  #i++
  POE DHV.i  #DR = SP+1 (local var i on stack)
  LAM        #A = *DR
  INA        #A++
  SIA        #*DR = A
  
  #B = CmdStr[i]
  LDR CmdStr #DR = &CmdStr[0]
  EDA        #DR+=A : &CmdStr[i]
  LBM        #B = *DR : CmdStr[i]
  
  CAL isHexDigitB
  LTO #T = 0
  MAT #A = A - T
  JLN DHV.xit #if nz set, not a hex digit, exit
  POE DHV.Temp #DR = SP+1 (local Temp)
  LAM #A = *DR (upper nibble of hex digit)
  EBA #B = B+A
  SIB #*DR = B

  W1B # echo the character
  
  # i++
  POE DHV.i  #DR = SP+2 (local i)
  LAM #A = *DR
  INA #A++
  SIA #*DR = A
  
  JPL DHV.loop #Loop for next hex pair

D DHV.xit  #Line is done or there was a non-hex digit
  W1E 'LF  #print \n
  INS      #Clean up stack
  INS      #Clean up stack

  RTL #Return
  
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

