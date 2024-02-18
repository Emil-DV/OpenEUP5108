

















# Parameter Passing 2
W main

I UtilFunctions.asm
I StringLib.asm

D main

# Use the A and B registers to pass
# values to a Multiply function
V X               # Create Global Vars
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
