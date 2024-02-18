# Is digit tests
W main            # Writes the location of main to
                  # reset vector 0x00

I UtilFunctions.asm # Brings in Utilitity functions (I/O)
I StringLib.asm     # Brings in String manipulation functions

D Prompt          # const char Prompt[]="IsDigitTests>"
S IsDigitTests>\0

V InputString     # char InputString[20]
a 20

V InputChar       # char InputChar
a 1

V InputCharVal    # char InputCharVal
a 1

V I               # char I // the itterator 
a 1


D main            # Our main program entry point

D main.loop  
  LDR Prompt
  CAL printStr1E




#######################################################
## getHexLine - get a line of hexdigits
## DR = pointer to destination string
## A = max length 
D getHexLine

# Local vars can also use the stack so long as it is cleaned
# up before return
  # Store DR onto the stack for later reference
  # This puts the destination at SP-2
C getHexLine.pDst 4
  SCR
  SCD
  # We also need space for the itterator I
C getHexLine.I 2
  SCA
  # And the InputChar
C getHexLine.InputChar 1
  DES
  
D getHexLine.nxtchar  
  # Get a character from the user and only print it if it is
  # a digit or hexdigit
  CAL getCharB
  POE getHexLine.InputChar
  SIB 
  
  LAE 'LF            # Is char 'LF
  MAB 
  JLN getHexLine.notdone   # they typed something else
  # done so put the zero at the end of the string
  POE getHexLine.I              
  LAM
  
  POE getHexLine.pDst    # getHexLine.pDst[I] = 0 
  LAZ
  SIA

  # Delete our temp vars from the stack
  INS
  INS
  INS
  INS
  RTL
  
D getHexLine.notdone
  
  CAL isDigitB
  LBA
  JLN getHexLine.isdigit
  
  POE getHexLine.InputChar
  LBM
  CAL isHexDigitB
  LBA
  JLN getHexLine.isdigit
  JPL getHexLine.nxtchar
  
D getHexLine.isdigit  
  
  POE getHexLine.InputChar
  LBM
  W1B                # echo character

  POE getHexLine.I   # I
  LAM

  POE getHexLine.pDst # InputString[I] = InputChar 
  EDA
  SIB

  DEA
  POE getHexLine.I    # I++
  SIA
  JLN getHexLine.nxtchar
  JPL getHexLine.nxtchar 
