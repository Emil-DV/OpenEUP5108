#######################################################
## EUP5108 HEAP
#######################################################

# Alloc is in parts
# free is in pages

# included at the bottom of the main program so as to
# use all remaining memory except the space reserved for 
# the stack

V _HEAPNEXT   # The next free location in heap
a 2
V _HEAPSTART  # Last used location in memory
A FF00        # Leave 256 bytes for the stack
V _HEAPEND    

########################################################
D HeapInit
  # Put the heap start address into the heap next var
  LDR _HEAPSTART
  LAD
  LBR
  LDR _HEAPNEXT
  SIB
  IND
  SIA
  RTL
  
########################################################
D HeapAlloc
  # Allocs limited to max size of 256 passed in A
  # returned in DR
  LBA              # Load A into B for quick zero check
  JSN HeapAlloc.c  # Non-zero size is good
  LDZ              # Zero size means zero dr and return
  RTL
D HeapAlloc.c
C HeapAlloc.ta 3  # Make space for local byte
  DES
  
C HeapAlloc.tp 1  # Make space for local word
  DES
  DES

  POE HeapAlloc.ta # Put A on the stack for now
  SIA              
  
  LDR _HEAPNEXT    # Put *_HEAPNEXT on the stack
  LAM
  IND
  LBM
  POE HeapAlloc.tp
  SIA
  IND
  SIB
# Put ta into T
  POE HeapAlloc.ta
  LTM
# Put *_HEAPNEXT into DR
  LRA
  LDB
# Add the size to DR
  EDT
# Store the new value into _HEAPNEXT
  LAR
  LBD
  LDR _HEAPNEXT
  SIA
  IND
  SIB

# Load DR with the old _HEAPNEXT from the stack  
  POE HeapAlloc.tp
  LAM
  IND
  LBM
  LRA
  LDB
# Clean up locals and return
  INS 
  INS
  INS
  RTL

    
  
  