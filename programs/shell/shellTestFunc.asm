#######################################################
# Test Function - a place for test code
# This is an example of an external source code addition
# to the EUP shell

I ../stdlibs/rand.asm # Bring in the random number lib
I ../stdlibs/tests/filefunctestsbody.asm

# Define the three command table entries
D testCmd       # the command word
S test\0     
D testMsg       # the one line help message
S test: Runs the latest test code\0

D testFunc      # the function itself
  # Run whatever test code there is
  LDR VTCLR
  CAL printStr1E
  LDR VTHOME
  CAL printStr1E
  
  CAL fftmain
  
  
  # Call both the seedRandEF (asm code)
  CAL seedRandEF
  HLT
  # And the seedRandMMIO (C version)
  CAL seedRandMMIO
  LDR EF.a
  HLT
  CAL TestRandStrDual
  CAL testRandScreen
  HLT
  NOP
  RTL
  
  
  
# const char Astr[] = {"Hello Ian!"}
D Astr  
S Hello Ian!\0 
D HelloIan
  # Clear the screen
  LDR VTCLR
  CAL printStr1E
  LDR VTHOME
  CAL printStr1E

  # for(char i=0;i<10;i++)
  LAZ   # Load A with 0
  SCA   # Store A on the stack this is our local i
D forloop.top # Label for the top of the loop 
  LTE 10   # Load the limit of 10 to T
  MTA      # T = T - A
  JLN forBegin # if A < 10 T is not zero so do the block 
  JPL forEnd   # A == 10 so exit
  
D forBegin # {
  LDR Astr # DR = Astr
  EDA      # DR = &Astr[i]
  LBF      # B = Astr[i]
  W1B      # print(B)
  # i++
  INA      # A++
  POE 1    # DR = &i (on stack)  
  SIA      # i = A  
  JPL forloop.top # Jump to top of the for
D forEnd   # }
  INS      # Increment the stack to delete i
  HLT
  NOP  
  RTL  
    
    

