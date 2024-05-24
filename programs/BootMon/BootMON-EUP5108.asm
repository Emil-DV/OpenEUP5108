#######################################################
## Boot Monitor for the EUP 5108 - primary test program
#######################################################

W main      # Set reset vector to main
W HWIRQFunc
W IRQ1Func
W IRQ2Func
O 0010      # Start rom constants at 0x0010 ROM ADDRESS

V CmdStr    # The command entered
a 42
C CMDSTRMAX 41
V CmdStrLen # The length of the command entered
a 1

C sys.topline 6      # 1 based
C sys.cursorChar 0x5F # _

I strings.asm
I bootbanner.asm

I ..\displaylibs\vt100.asm
I ..\displaylibs\BoxDrawing.asm
I ..\displaylibs\bigled.asm
I ..\stdlibs\stringlib.asm
I ..\stdlibs\math.asm
I ..\stdlibs\utilfunctions.asm
I ..\gamelibs\EUPOUTV2\EUPOUTv2.asm
I ..\gamelibs\EUPInvaders\EUPInvadersCode.asm
I ..\gamelibs\Cards\PlayingCardDeck.asm

#######################################################
D testFunc
  LDR VTCLR
  CAL printStr1E
  LDR VTHOME
  CAL printStr1E
V tf.col
a 1
V tf.row
a 1
V tf.char
a 1
V tf.i
a 1
  
  LDR tf.i
  LAO
  SIA
  
  CAL docInitDeck
  LAE 16
  LBE 2
  CAL vtSetCursorPos

  LDR VTBLUEONWHT
  CAL printStr1E

  LDR docBack
  CAL printStr1E
  
  
D tf.docdo1  
  LDR tf.char
  LAZ
  SIA

  LDR tf.col
  LAE 24
  SIA
  LDR tf.row
  LAE 2
  SIA
  
D tf.docdo
  LDR tf.col
  LAM
  LDR tf.row
  LBM
  CAL vtSetCursorPos
  
  LDR tf.char
  LAM
  LDR docFullDeck
  EDA
  LAM
  CAL docDrawCard

  W2E 0x50
  
  LDR tf.col
  LAM
  LBE 6
  EAB
  SIA
  
  LBE 48
  MBA
  JLN tf.docrc
  LDR tf.col
  LAE 24
  SIA
  LDR tf.row
  LAM
  INA
  SIA
  
  
D tf.docrc  
  LDR tf.char
  LAM
  INA
  SIA
  
  LBE 52
  MBA
  JLN tf.docdo  

  LDR VTREDONBLK
  CAL printStr1E

  LAE 12
  LDR tf.i
  LBM
  TLB
  TLB
  INB
  EAB
  LBE 20
  CAL vtSetCursorPos
  
  LDR tf.i
  LAM
  CAL printLED
  LDR tf.i
  LAM
  INA
  SIA

  CAL getCharB
  
  CAL docShuffleDeck
  JPL tf.docdo1 

  HLT
  NOP




D tf.loop  
  LAE 80
  CAL getRand
  INB
  LDR tf.col
  SIB

  LAE 25
  CAL getRand
  INB
  LDR tf.row
  SIB

  LAE 0xF0
  CAL getRand
  INB
  LAE 'ESC
  MAB
  JLN tf.pchar
  INB
D tf.pchar
  LDR tf.char
  SIB

  LDR tf.col  
  LAM
  LDR tf.row
  LBM  
  CAL vtSetCursorPos
  LDR tf.char
  LAM
  W1A

  LAZ
D tf.delay
  DEA
  NOP
  NOP
  NOP
  JLN tf.delay
  
  JPL tf.loop
  
  W1E 'LF
  LDR charRuler
  CAL printStr1E
 
  LDR VTREDONBLK  # Set Red on Black
  CAL printStr1E

# First we push the row and col for the top left of the box
  LAE 3           # Row = 3
  SCA
  LAE 7           # Col - vt100 Window is 1 based
  SCA
# These are the inner dimensions of the box
# not including the top/bottom or left/right of the frame
  LAE 12          # Width
  LBE 1           # height
  LDR DBLLineMatrix # Double line box matrix
  CAL DrawBox
  INS             # Remove the passed vars
  INS


#  LBE 4          # Row
#  LAE 8          # Col
#  CAL vtSetCursorPos
  
#  LDR strHelloWorld
#  CAL printStr1E
  
  #LAE 10
  #LBE 3
  #LDR SNGLineMatrix  
  #CAL DrawBox
  
  #LAE 22
  #LBE 1
  #LDR SDBLineMatrix
  #CAL DrawBox


  #CAL PrintBoxDigits
  
  RTL

# HWIRQ Function prototype
D HWIRQFunc  
  HLT
  NOP
  RTI
  
# INQ2 Function prototype
D IRQ2Func
  HLT
  NOP
  RTI
  
# INQ1 Function prints the boot banner
D IRQ1Func

C IRQ1Func.i 1        # Local on the stack
  DES
  
  LBE 'B               # Check if this is the boot banner command 
  MBA
  JLN IRQ1Func.next

  LAO
  CAL sleep
  
  #CAL ShieldsUp
  

C SpriteRow   09      # Row var
C SpriteStart 20      # Start col
C SpriteStop  25      # Stop Col
C SpriteDelay 03      # Delay between draws

  LDR VTREDONBLK
  CAL printStr1E
  # Print the boot banner
  LAE 2         # Push row
  SCA
  LBE 25        # Push col
  SCB
  LAE 27        # width
  LBE 4         # height
  LDR SDBLineMatrix
  CAL DrawBox
  INS
  INS
  
  LAE 1
  CAL sleep
  
  LAE 3
  LBE 26
  CAL BoxBanner  
  
  LBE 6
  LAE 30
  CAL vtSetCursorPos
  
  LDR BootBanner
  CAL printStr1E
  
  W1E 'LF
  
  
  
  
  

  # Sprite test
  POE IRQ1Func.i
  LAE SpriteStart
  SIA
  LBE SpriteRow
#  HLT
  NOP
  CAL vtSetCursorPos
  
D spritetest.loop 
  LDR VTBLUEONBLK
  CAL printStr1E
 
  POE IRQ1Func.i
  LAM
  INA
  SIA
  LBE SpriteStop
  MBA
  JLN IRQ1Func.c
  JPL IRQ1Func.ex
  
D IRQ1Func.c  
  LBE SpriteRow
#  HLT
  NOP

  CAL vtSetCursorPos

  LDR eiSpaceShip1
  CAL printStr1E
  
  W2E 0x21
    
  LAE SpriteDelay
  CAL sleep

  LDR VTREDONBLK
  CAL printStr1E
  
  LBE SpriteRow
  LAE SpriteStop
  LTE 4
  EAT
  CAL vtSetCursorPos
  W1E 0x95


  POE IRQ1Func.i
  LAM
  LBE SpriteRow
#  HLT
  NOP
  CAL vtSetCursorPos

  LDR VTBLUEONBLK
  CAL printStr1E

  LDR eiSpaceShip2
  CAL printStr1E
  
  W2E 0x12
  
  LAE SpriteDelay
  CAL sleep
  
  LDR VTREDONBLK
  CAL printStr1E
  
  LBE SpriteRow
  LAE SpriteStop
  LTE 4
  EAT
  CAL vtSetCursorPos
  W1E 0x93
  
  JPL spritetest.loop 
  
D IRQ1Func.ex
  LAE SpriteRow
  DEA
  LBE SpriteStop
  LTE 4
  EBT
  CAL vtSetCursorPos

  LDR VTREDONBLK
  CAL printStr1E

  LAE SpriteRow
  DEA
  SCA
  LAE SpriteStop
  SCA
  LAE 3
  LBE 1
  LDR eiExplode
  CAL DrawBox
  W2E 0x60
  W2E 0x40
  W2E 0x70
  W2E 0x23
  
  LAE 2
  CAL sleep

  LAE 3
  LBE 1
  LDR BlankNMatrix
  CAL DrawBox
    
  CAL eiMainLoop
    
    
  INS
  INS
  
  LDR VTRST
  CAL printStr1E
  LDR VTHOME
  CAL printStr1E


  INS
  RTI
  
D IRQ1Func.next  
#  HLT
  NOP
  
  LBE '*
  MBA
  JLN IRQ1Func.rti
  W1E '*
  W1E 'CR

D IRQ1Func.rti  
  INS
  RTI

#######################################################
## main - the main entery point
#######################################################
D main 
  LAE 'B
  LDR IRQ1Func.rti
  LBE 5
  MBA
  IQ1         # Call software IRQ for banner
  
  # Prompt User for command
D main.pu  
  LDR Prompt
  CAL printStr1E
  
# Get a command line from the user
  LAE CMDSTRMAX
  LDR CmdStr
  CAL getLine
  W1E 'LF
  LDR CmdStr        # Get the command line length
  CAL strlen
  LDR CmdStrLen
  SIA #save A in *CmdStrLen
  W1E NULL
  
  # Get first character from command into B
  LDR CmdStr
  LBM
  # switch(B){
  # Check if the user entered '? for help function
  LAE '?
  MAB
  JLN main.n0       # case ?:
  CAL HelpFunction
  JPL main.pu       # break;
  
  # Check if the user entered 't for testScreenWidth function
D main.n0
  LAE 't
  MAB
  JLN main.n1       # case t:
  CAL testFunc
  JPL main.pu       # break;

  # Check if the user entered 'm for memory function
D main.n1
  LAE 'm
  MAB
  JLN main.n2
  CAL memoryFunc
  JPL main.pu

  # Check if the user entered 'c for clear screen function
D main.n2
  LAE 'c
  MAB 
  JLN main.n3
  LDR VTCLR
  CAL printStr1E
  LDR VTHOME
  CAL printStr1E
  JPL main.pu

  # Check if the user entered 'g for the EUPOUT game
D main.n3
  LAE 'g
  MAB 
  JLN main.n4
  CAL EUPOUT
  JPL main.pu

  # Check if the user entered 'v to echo a VT escape code
D main.n4
  LAE 'v
  MAB 
  JLN main.n5
  CAL echoVT
  JPL main.pu

  # Check if the user entered 'a to print the ASCII table
D main.n5
  LAE 'a
  MAB 
  JLN main.na
  CAL PrintASCIITbl
  JPL main.pu

  # Check if the user entered 'd to convert the entered hex values
D main.na
  LAE 'd
  MAB 
  JLN main.nd
  CAL DisplayHexValues
  JPL main.pu

  # Check if the user entered 's to play sound values
D main.nd
  LAE 's
  MAB 
  JLN main.nF
  CAL PlayHexValues
  JPL main.pu


  # Command not found, print ?? and get another command
D main.nF
  LDR CmdStr
  CAL toUpperStr
  LDR CmdStr
  CAL printStr1D
  W1E '?
  W1E 0x0A
  JPL main.pu

#######################################################
D echoVT
  W1E 'ESC
  LDR CmdStr
  IND
  CAL printStr1D
  W1E 'ESC
  RTL

#######################################################
D HelpFunction
  LDR HelpMessage          
  CAL printStr1E
  
  # Show the memory command format
  LDR MemoryHelp
  CAL printStr1E
  W1E 'CR
  LAE 'B
  
  RTL

#######################################################
D memoryFunc  
# check if we are _r_ eading memory
  LDR CmdStr
  IND
  
  LAE 'r  
  LBM #B=CmdStr[1]
  MAB #A=A-B
  JLN memoryFunc.mf          #   if A!=B goto |mf

# check for command length
# len "mrNNNN" = 6
# Check for length of 6
  # A = CmdStrLen
  LDR CmdStrLen
  LAM
  LBE 0x06
  MAB #A=A-B
  JLN memoryFunc.mf          #  if A!=B goto |mf

  # Reset DumpStart to zero
  LDR DumpStart
  LAZ
  SIA
  IND
  SIA

  # The xtos function that converts 4 hex characters 
  # to a two byte value
  # Push pStr
  LDR CmdStr
  LTE 0x02
  EDT
  SCR
  SCD
  # Push pVal
  LDR DumpStart
  SCR
  SCD
  CAL xtos
  
  # SP += 4 
  INS
  INS
  INS
  INS
  
  # if A != 0 conversion worked
  # 
  POE 0x00
  
  # DumpLines = 1
  LDR DumpLines
  LAE 0x04
  SIA
  CAL DRamDump

D memoryFunc.mf
  RTL 


D tstString
S This is a test\n\0


#######################################################
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
  LAO
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
  