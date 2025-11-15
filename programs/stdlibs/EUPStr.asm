#$---- 
#$## stdlibs/EUPStr.asm String Functions
#$     A collection of older string functions

#$
#$### | printCharTbl
#$     Prints the characters 0xFE to 0
#$     and their hex values to the screen.
#$     Superseded by asciiCmd function in 
#$     shell/EUPShell.asm
D printCharTbl
  LAE 0xFE        # Load FE into A
D printCharTbl.do1  
  W1A             # Print the character
  W1E 'SP         # print space
  LBA             # copy A into B
  RRB             # Rotate Right 4x
  RRB             #   to put upper nibble into lower
  RRB
  RRB
  LTE 0x0F        # Load T with 0x0F to mask low nibble
  ABT             # B = B AND T to zero upper nibble
  LDR HexTbl      # Load the hex table address
  LRB             # Replace lower nibble of DR with B 
                  #   only works if HexTbl is located
  LBF             # Load hex letter to B
  W1B             # Print hex letter
  LBA             # Reload B with A  
  LTE 0x0F        # Reload T with mask
  ABT             # B = B AND T to zero upper nibble
  LDR HexTbl      # Load the hex table address
  LRB             # Replace lower nibble with B
  LBF             # Load hex letter to B
  W1B             # Print hex letter
  W1E 'SP         # Space for seperation
  DEA             # Dec A
  JSN printCharTbl.do1 # Loop for next A value
  W1E 'LBF        # End Loop
  RTL

#$
#$### | printDec
#$     Prints the value passed in R in Decimal
#$     Superseded by atoi function in 
#$     stdlibs/StringLib.asm
D printDec
  LDE 0x00
  LBE 0x64  #100
  CAL Div8
  LTE 0x30
  EAT
  W1A
  LDE 0x00
  LRB
  LBE 0x0A #10
  CAL Div8
  LTE 0x30
  EAT
  W1A
  EBT
  W1B
  RTL
