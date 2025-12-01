W main
O 0x10  # Start rom constants at 0x0010 ROM ADDRESS

# ROM Values
# String Value in ROM
# const char ConstStr[] = "Test me\n\0";
D ConstStr
S Test me\n\0

D EEPROMStr
S From EEPROM: \0

D DRAMStr
S From   DRAM: \0

D SrcLenPrompt
S Strlen Src = \0

D DstLenPrompt
S Strlen Dst = \0

# RAM Variables 
V RAM_START
# Destination string for testing
# char Dst[17];
V Dst
a 0x17

# Source string for testing
# char Src[32];
V Src
a 0x20

# Result var for strlen test
# char StrLenValue;
V StrLenValue
a 1

I StringLib.asm
I UtilFunctions.asm

D Banner
S String Library Tests:\n\0

D Prompt
S EUP:>\0

V CharTyped             # The character entered
a 1 

V BisDigit              # Var to hold return value 
a 1

D IsADigit
S  is a Digit :) \n\0
D IsNotADigit
S  is NOT a Digit :( \n\0

##############################################################################################################
# isDigitTest - get a character and test if it is a digit 0..9
#
D isDigitTest
  LDR Prompt            # Load the prompt
  CAL printStr1E        # And print it out
  CAL getCharB          # Get a character from Port 1 (stdin) into B
  LDR CharTyped         # Put it into storage
  SIB 
  CAL isDigitB          # Check if it is a digit 0..9 inclusive
  LDR BisDigit          # else it is so set BisDigit flag to 1
  SIA                   # Set BisDigit to A (results)

D isDigitTest.rsts 
  LDR CharTyped         # Load up the Char Typed
  LBM 
  W1E 0x27
  W1B                   # Char Typed  
  W1E 0x27  
  W1E 0x20              # Space
  CAL printBHex         # Print char in hex
  
  LDR BisDigit          # Load up the B is Digit flag
  LBM 
  JSN isDigitTest.Yes   # Jump to is a digit

  LDR IsNotADigit       # else print not a digit
  CAL printStr1E
  RTL                   # return
D isDigitTest.Yes  
  LDR IsADigit          # print is a digit
  CAL printStr1E
  RTL                   # return


## Goal: printf("%02X divided by %02X is %02X remainder %02X \n"...)
## Easy: printf("%02X/%02=%02Xr%02X\n")
#D DivByMsg
#S Divided by \0
#D Div
#DString Library Tests:\n\0

V Val1
a 1

V Val2
a 1

V Product
a 2

V Quotient 
a 1

V Remainder
a 1


D DivTest
  # DR=int, B = remainder
  # Print the message
  LDR Product
  LBM 
  CAL printBHex
  W1E 0x2F  # /
  LDR Val1
  LBM
  CAL printBHex
  W1E 0x3D  # =

  # Load Dividend into B
  LDR Product
  LBM

  # Load Divisor into A 
  LDR Val1
  LAM
  HLT
  CAL DivBA             # Call the Divide B by A function
  LAR                   # Load A with lsb of DR aka R register
  LDR Quotient          # Load DR with address of Quotient
  SIA                   # Save the integer portion
  LDR Remainder         # Load DR with address of Remainder
  SIB                   # Save off the remainder

  LDR Quotient
  LBM 
  CAL printBHex
  W1E 0x72
  LDR Remainder
  LBM
  CAL printBHex
  W1E 0x0D
   
  RTL



D MulTest
  LDR Val1
  LBE 0x05          # B = 0x05
  SIB
  CAL printBHex     

  W1E 0x2A          # '*'

  LDR Val2
  LBE 0x37          # B = 0x37
  SIB
  CAL printBHex     

  W1E 0x3D          # '='
  
  LDR Val1
  LAM 
  LDR Val2
  LBM
  CAL MulBA         # DR = B * A
  LAR               # A = R
  LBD               # B = D
  LDR Product       # DR = *Product
  SIA               # DR[0] = A
  IND               # DR++
  SIB               # DR[1] = B  

  LDR Product       # DR = *Product
  IND               # DR++
  LBM               # B = DR[1]
  CAL printBHex
  LDR Product
  LBM               # B = DR[0]
  CAL printBHex
  
  RTL
  
  
  
  
  

##############################################################################################################
##############################################################################################################
##############################################################################################################

V Cmd
a 0x20

D main

  LDR Banner            # printStr1E(Banner)
  SCD
  SCR
  CAL printStr1E        
  
D main.lp               # Do - Begining of command loop 
  LDR Prompt            # printStr1E(Prompt)
  CAL printStr1E        
  
  LDR Cmd               # getLine(Cmd) get a line of characters from the user
  CAL getLine    

  W1E 0x0A              # print \n
  
  LDR Cmd               # B = Cmd[0] Get the first char of the command into B
  LBM
  
  # Check the first character of the command
  LAE 'n                # A = 'n'
  MAB                   # A = A - B
  JSN main.!n           # A != 0 then B != 'n' 
  CAL newfunc           # Call function for 'n'   
  JPL main.lp           # Loop back to the top
D main.!n               # Label for next test
  
  LAE '?                # A = '?'
  MAB                   # A = A - B
  JSN main.!?           # A != 0 then B != '?' 
  CAL helpFunc          # Call function for '?'   
  JPL main.lp           # Loop back to the top
D main.!?               # Label for next test
 
  LAE 't                # A = 't'
  MAB                   # A = A - B
  JSN main.!t           # A != 0 then B != 't' 
  CAL tstStrCpys        # Call function for 't'   
  JPL main.lp           # Loop back to the top
D main.!t               # Label for next test

  LAE 's                # A = 's'
  MAB                   # A = A - B
  JLN main.!s           # A != 0 then B != 's' 
  LAO                   # Set A to one
  CAL stackDump         # Call function for 's'   
  JPL main.lp           # Loop back to the top
D main.!s               # Label for next test

  LAE 'c                # A = 's'
  MAB                   # A = A - B
  JLN main.!c           # A != 0 then B != 's' 
  W1E 0xFF
  JPL main.lp           # Loop back to the top
D main.!c               # Label for next test



  W1E 0x0A
  
  # Unknown command do what?
  LDR Cmd
  CAL printStr1D
  W1E '?
  W1E '?
  W1E 0x0A
  
  
  JPL main.lp           # while(1)



## Template #########################################################################
## FunctionName: Purpose
## Function specific Vars and Consts 
# D Consts
# S|L
# V Function Vars
# a size

# D FunctionName
#   function body
# RTL Return
# End FunctionName ----------------------------------------------------------------- 

####################################################################################
# newfunc: prints a message and returns
D NewFuncHit
S New Func Hit!\n\0
  
D newfunc
  LDR NewFuncHit
  CAL printStr1E
  RTL
# End newfunc ---------------------------------------------------------------------- 

####################################################################################
# helpFunc: prints a message and returns
D HelpFuncMessage
S No Help Here!\n\0
  
D helpFunc
  LDR HelpFuncMessage
  CAL printStr1E
  RTL
# End helpFunc ---------------------------------------------------------------------- 

  CAL MulTest
  W1E 0x0A
  
  LDR Product
  LTE 0x0C
  EDT
  LTR
  LDR Product
  SIT 

  CAL DivTest

  W1E 0x0A
  
#   
#   LBE 0xFF  
# D printBHexTestLoop  
#   CAL printBHex
#   DEB
#   LAE 0x10
#   
#   W1E 0x20
#   JLN printBHexTestLoop
#   CAL printBHex
  
D tstStrCpys  
  
  LDR RAM_START
  LAD
  LBR
  LDR DumpStart
  SIB
  IND
  SIA

  LDR DumpLines
  LAE 0x05
  SIA
  
  CAL DRamDump

# In order to pass more/larger vars than the registers allow we will have to "pass them on the stack"
# To put a word address on the stack
  LDR ConstStr  # load 16 bit address into DR
  SCR           # Put R on the stack
  SCD           # Put D on the stack

# Do the same for the Dst address
  LDR Src       # load 16 bit address into DR
  SCR           # Put R on the stack
  SCD           # Put D on the stack

# Now the two values are on the stack so when we call the function per usual
  CAL strcpyconst #(Src, ConstStr)

# In order to not burn up stack space we will now "delete" those previous items 
# off the stack by decrementing SP
  XDS           # SWAP DR/SP
  LTE 0x04      # The two vars that we passed were 2 bytes each for a total of 4
  EDT           # Add the space used for vars
  XDS           # SWAP DR/SP

  LDR RAM_START
  LAD
  LBR
  LDR DumpStart
  SIB
  IND
  SIA

  LDR DumpLines
  LAE 0x05
  SIA
  
  CAL DRamDump



# In order to pass more/larger vars than the registers allow we will have to "pass them on the stack"
# To put a word address on the stack
  LDR Src       # load 16 bit address into DR
  SCR           # Put R on the stack
  SCD           # Put D on the stack

# Do the same for the Dst address
  LDR Dst       # load 16 bit address into DR
  SCR           # Put R on the stack
  SCD           # Put D on the stack
  
# Now the two values are on the stack so when we call the function per usual
  CAL strcpy # (Dst, Src)

# In order to not burn up stack space we will now "delete" those previous items 
# off the stack by decrementing SP
  INS           # The two vars that we passed were 2 bytes each for a total of 4
  INS           # Increment the stack 4 times
  INS      
  INS

  
# Print out the constant, the src, and the dst  
# Passing by registers does not require stack manipulation
  LDR EEPROMStr
  CAL printStr1E
  
  LDR ConstStr
  CAL printStr1E

  LDR DRAMStr
  CAL printStr1E
  
  LDR Src
  CAL printStr1D

  LDR DRAMStr
  CAL printStr1E
  
  LDR Dst
  CAL printStr1D

  # DumpStart = RAM_START
  LDR RAM_START
  LAD
  LBR
  LDR DumpStart
  SIB
  IND
  SIA

  # DumpLines = 0x05
  LDR DumpLines
  LTE 0x05
  SIT
  
  CAL DRamDump
  
  RTL

  



