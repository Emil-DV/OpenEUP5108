## EUPStr.asm String Functions


## itoa(B=value,out DR=pStrValue)
D itoa
  # Greater than 199 -> write '2', inc DR
  # Greater than  99 -> write '1', inc DR
  #
  RTL

## Prints the characters and their hex values to the screen.
D printCharTbl
  LAE 0xFE        # Load FE into A
D printCharTbl.do1  
  W1A             # Print the character
  #W1E 0x20        # print space
  LBA             # copy A into B
  RRB             # Rotate Right 4x
  RRB             #   to put upper nibble into lower
  RRB
  RRB
  LTE 0x0F        # Load T with 0x0F to mask low nibble
  ABT             # B = B AND T to zero upper nibble
  LDR HexTbl      # Load the hex table address
  LRB             # Replace lower nibble of DR with B - only works if HexTbl is located
  LBF             # Load hex letter to B
  W1B             # Print hex letter
  LBA             # Reload B with A  
  LTE 0x0F        # Reload T with mask
  ABT             # B = B AND T to zero upper nibble
  LDR HexTbl      # Load the hex table address
  LRB             # Replace lower nibble with B
  LBF             # Load hex letter to B
  W1B             # Print hex letter
  W1E 0x20        
  DEA             # Dec A
  JSN printCharTbl.do1
  W1E 0x0A
  RTL

# printDec(R=val2print)
D printDec
  LDE 0x00
  LBE 0x64 #100
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





## strcpy - copy one string to another
##          Pass vars via the stack

## LDR Dest # Load the Dest pointer into DR
## SCR      # Put R onto the stack at current SP
## DES      # Decrement SP
## SCD      # Put D onto the stack 
## DES      # Decrement SP

## LDR Src  # Load the Source pointer into DR
## SCR      # Put R onto the stack at current SP
## DES      # Decrement SP
## SCD      # Put D onto the stack 
## DES      # Decrement SP

#D strcpy    # Src pointer is at SP+2 Dest @ SP+4
#  PDS       # Copy SP to DR
#  LTE 0x02  # Load 2 into T
#  EDT       # DR = DR + 2
#  
#  LAM       # Src high byte into A
#  IND       
#  LRM       # Src low byte into R
#  LDA       # Src high byte inot D
#  
#  LBM       # read Src[0] into B
#  
#  PDS       # Copy SP to DR
#  LTE 0x04  # Load 4 into T
#  EDT       # DR = DR + 4
#
#  LAM       # Dest high byte into A
#  IND       
#  LRM       # Dest low byte into R
#  LDA       # Dest high byte inot D
#  
#  SIB       # Write B to Dest[0]
#  
#  JSN strcpy.n  # check if we read a zero
#  DES       # Repair SP
#  DES
#  RTL
#
#D strcpy.n  
#  
#  INS
#  LDM
#
#  PDS       
#  LTE 0xFE  # Load -2 into T
#  EDT       # DR = DR -2
