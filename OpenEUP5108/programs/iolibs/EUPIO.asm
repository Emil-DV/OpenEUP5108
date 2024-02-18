# EUPIO.asm - I/O functions
# This assumes that Port0 is the keyboard input and Port1 is the output to the screen.

# getC - reads one character from Port0 into the B register and loops until not NULL
#        then puts the character into RAM at the location loaded into DR when called.
# Input: DR set to address of variable
D getC
  LB0             # Read from port0 into B
  JSN getC.r      # if not zero flag is set jmp to return
  JPS getC        # Jump back to read another character
D getC.r  
  SIB             # Store contents RAM[DR] = B
  RTL             # Return
  
# getString - reads characters into a string and echos to the terminal
# Input: DR set to address of string buffer
D getString
# Get a character
  LB0              # B = Port0       
  JSN getString.go # if(b) goto .go 
  JPS getString    # else goto .ga
D getString.go
  W0E 0x00         # Port0 = 0 = Ack read
# Check for Enter
  LAE 0x0A         # A=0A
  MAB              # B==0A (B=B-A) 
  JSN getString.c2 # if(B!=0A) goto .c2
  SIA              # CR hit, write a nul to end the line, A is 0 at this point 
  RTL              # return
# Check for BS
D getString.c2
  LAE 0x08         # A=08
  MAB              # B==08 
  JSN getString.oc # if(B!=08) goto .oc
  SIA              # DRAM(SP) = 0 BS hit, delete last character, A is 0 at this point
  DED              # Decrement DR
  W1B              # Echo character 
  JPS getString    # Get another character
# Anything else we add to the string
D getString.oc
  SIB              # Store character
  IND              # increment DR
  W1B              # Echo character
  JPS getString    # Get another character

  

# Prints the string pointed to by DR from ROM terminated with a NULL
D printROM        # The print function start location
  XDS             # Swap DR and SP to use SP increment hw
  TDS             # Use SP
D printROM.p
  LBF             # Load into B the value at ROM(DR)
  JSN printROM.n  # Jump over the return if the value is != 0
  TDS             # Use DR
  XDS             # Replace stack pointer
  RTL             # Read a 00 so return
D printROM.n      # The location of the label 'nextb'
  W1B             # Send the character out port 1
  INS             # Increment SP register w/ hardware
  JPS printROM.p  # Jump short to top of the loop
  
# Prints the string pointed to by DR from ROM/RAM terminated with a NULL
D printRAM        # The print function start location
  LBM             # Load into B the value at RAM(DR)
  JSN printRAM.n  # Jump over the return if the value is != 0
  RTL             # Read a 00 so return
D printRAM.n      # The location of the label 'nextb'
  W1B             # Send the character out port 1
  IND             # Increment DR register
  JPS printRAM    # Jump short to top of the loop
