#######################################################
## EUPHeap Tests
#######################################################
W main      # Set reset vector to main
O 0010      # Start rom constants at 0x0010 ROM ADDRESS

I stringlib.asm
I utilfunctions.asm

D main
# Init heap
  CAL HeapInit
  
  
C NumBytes 20
V pByteArray
a 2
V i
a 1
  
  # Alloc NumBytes
  LAE NumBytes
  CAL HeapAlloc

  # Put returned address into pByteArray
  LAR
  LBD
  LDR pByteArray
  SIA
  IND
  SIB
  
  # Get pByteArray into DR
  LDR pByteArray
  LAM
  IND
  LBM
  LRA
  LDB
  # Load A with NumBytes
  LAE NumBytes
  LBE 'A
D main.ll  
  SIB            # *pByteArray[0] = B
  INB  
  IND            # pByteArray++
  DEA            # A--
  JSN main.ll    # while A > 0
  
  # Get pByteArray into DR
  LDR pByteArray
  LAM
  IND
  LBM
  LRA
  LDB
  # Print out the contents of pByteArray
  CAL printStr1D 


  HLT




A 1000 # force start address for testing
# added at the bottom it is above all other RAM vars
I eupheap.asm