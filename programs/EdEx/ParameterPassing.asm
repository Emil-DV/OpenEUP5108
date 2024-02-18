

















# Parameter Passing - Register(s)
W main            # Writes the location of main to
                  # reset vector 0x00

I UtilFunctions.asm # Brings in Utilitity functions (I/O)
I StringLib.asm     # Brings in String manipulation functions

D main            # Our main program entry point

# Use the A and B registers to pass
# values to a Multiply function
  LAE 0xAB        # A = 0xAB
  LBE 0x03        # B = 0x03
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
