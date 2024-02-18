

















# Parameter Passing 3
W main

I UtilFunctions.asm
I StringLib.asm

D main

# Use the A and B registers to pass
# values to a Multiply function
V X
a 1
V Y
a 1
  LDR X
  LAE 0xAB        # X = 0xAB
  SIA
  
  LDR Y
  LAE 0x0C        # Y = 0x0C
  SIA
  
  LDR X           # read X into A
  LAM
  LDR Y           # read Y into B
  LBM
  
  CAL MulBA
# The Result of MulBA is in the DR register
# Save it in a variable
V Product
a 2
  LBR             # B = R
  LAD             # A = D
  LDR Product     # Load Variable address into DR
  SIB             # Store B
  IND             # Increment the DR address
  SIA             # Store A

# Print the whole formula
  LDR X
  LBM
  CAL printBHex
  W1E 'x
  LDR Y
  LBM
  CAL printBHex
  W1E '=
  
# Now we can print the result
  LDR Product     # Load Variable address into DR
  IND             # Increment DR
  LBM             # B = DRAM[DR]
  CAL printBHex   # Print High Byte

  LDR Product     # Load Variable address into DR
  LBM             # B = DRAM[DR]
  CAL printBHex   # Print Low Byte
  
  W1E 0x0A
  
  HLT
  
# Print out the last page of RAM where the stack is located
# The DRamDump function reads from two Global Variables
# DumpStart - the starting address in RAM
# DumpLines - The number of lines (16 bytes) to dump
C LASTRAMLINE FFF0

  LDR LASTRAMLINE   # Load the 16 bit constant to DR
  LAD               # A = D
  LBR               # B = R
  LDR DumpStart     # Load address of DumpStart
  SIB               # Store B (LSB)
  IND               # Increment DR
  SIA               # Store A (MSB)
  
  LDR DumpLines     # Load address of DumpLines
  LTO               # T = one
  SIT               # Save 1 into DumpLines
  
  CAL DRamDump      # Call the DRamDump function
  
  
  HLT
  JPL StrCpyTest

# Since we only have one 16 Bit data pointer register
# and two 8bit registers (T is used internally INC/DEC/CAL
# instructions)

# In order to accomplish a copy of data from one location
# to another we have to pass at least two 16 bit values

# The use of globals for temporary data working areas is 
# wasteful. The reuse of the same memory for different 
# functions can lead to confusion and overlap

# Introducing the "STACK"
# The stack (so nammed because the last item Pushed on is 
# the first item Popped off - a.k.a. LIFO)

# Consists of a dedicated 16 bit data poiner register SP
# Is initialized at startup to the last location in RAM
# Grows downward toward the first location in RAM
# Our programs on the other hand start a location 0 and 
# grow up

# If ever the twain shall meet there will be hell to pay.

# To pass a value on the stack it is simply a matter of 
# putting the value you want into a register and using
# one of the SC* instructions.

# String Copy from ROM value to RAM using the stack

# The ROM string
D ROMString
S This is the string that is in ROM\n\0

D RP
S ROM: \0

D AP
S RAM: \0

V RAMString
a 40

D StrCpyTest
# Load the location of the ROMString onto the stack
  LDR ROMString     # First the location into DR
  SCR               # Store R-LSB little endian
  SCD               # Store D-MSB - SC* increments SP
  
# Load the location of the RAMString onto the stack
  LDR RAMString
  SCR
  SCD
  
  HLT
  TDS
  TDS
# Call the String Copy Constant function  
  CAL strcpyconst
  
  INS                # One stack increment for each
  INS                # byte we put on the stack
  INS
  INS
  
# Print the line from ROM
  LDR RP
  CAL printStr1E
  
  LDR ROMString
  CAL printStr1E
  
# Print the line from RAM
  LDR AP
  CAL printStr1E
  
  LDR RAMString
  CAL printStr1D
  
  HLT
  
# Change the second to the last character to 'A'
# so that it it "This is the string that is in RAM"
# RAMString[31] = 'A'  
  LDR RAMString
  LAE 0x1F       # the 31th character
  EDA            # do the pointer addition
  LAE 'A
  SIA
  
  LDR RAMString
  CAL printStr1D
  
  HLT