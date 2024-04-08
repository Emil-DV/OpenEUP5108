################################################################
## BCD - Library of functions for Binary Coded Decimal Strings
################################################################

# Each BCD string is limited to and expected to be this length including null
C BCDLib.strlen 8  # Max 99999999

# BCDInc - Increment the string by 1
# BCDDec - Decrement the string by 1
# BCDZro - Zero out the BCD string
# BCDPnt - Print a BCD String 

################################################################
# BCDInc - Increment the BCD string by 1 using single digit math
D BCDInc
C BCDInc.pBCDStr 1          # Store pBCDStr
  SCD
  SCR
  
  # we start at the ones collumn
  POE BCDInc.pBCDStr        # Add strlen to pBCDStr
  LAM
  IND
  LDM
  LRA
  LAE BCDLib.strlen
  EDA
  DED
  LAR
  LBD
  POE BCDInc.pBCDStr        
  SIA
  IND
  SIB  

D BCDInc.do
  POE BCDInc.pBCDStr        # B = *pBCDStr
  LAM
  IND
  LDM
  LRA
  LBM
  INB
  LAE 0x0A
  MAB  
  JLN BCDInc.c
  LAZ
  SIA

  POE BCDInc.pBCDStr        # else pBCDStr--
  LAM
  IND
  LDM
  LRA
  DED
  LBM
  LAE 0x0A
  MAB
  JLN BCDInc.nz
  LAZ
  SIA
D BCDInc.nz
  LAR
  LBD
  POE BCDInc.pBCDStr        
  SIA
  IND
  SIB
  JPL BCDInc.do

D BCDInc.c    
  SIB
 
  INS
  INS
  RTL
  



################################################################
# BCDZro - Zero out the BCD string in:DR = pBCDStr
# The binary value 0x0A is used to mark unfilled leading spaces
D BCDZro 
  # Run backwards through the string
  LBE BCDLib.strlen
  DEB                   # A = BCDLib.strlen-1  
  EDB                   # DR += A
  
  LAZ                   # Store the Zero
  SIA  
  LAE 0x0A
  LBE BCDLib.strlen
  DEB
D BCDZro.do
  DED
  SIA
  DEB
  JLN BCDZro.do

  RTL

################################################################
# BCDPnt - Print a BCD String in:DR=pBCDStr
# The binary value 0x0A is used to mark unfilled leading spaces
D BCDPnt
C BCDPnt.pBCDStr 2          # Store pBCDStr
  SCD
  SCR
C BCDPnt.i 1                # Store BCDStr length
  LAE BCDLib.strlen
  SCA
  
D BCDPnt.do                 # Loop
  POE BCDPnt.pBCDStr        # B = *DR
  LAM
  IND
  LDM
  LRA
  LBM
  
  LAE 0x0A                  
  MAB
  JLN BCDPnt.show           # B != 0x0A?
D BCDPnt.nxt
  POE BCDPnt.pBCDStr        # else pBCDStr++
  LAM
  IND
  LDM
  LRA
  IND
  LAR
  LBD
  POE BCDPnt.pBCDStr        
  SIA
  IND
  SIB

  POE BCDPnt.i              # i--
  LBM
  DEB
  SIB
  JLN BCDPnt.do  

  INS
  INS
  INS
  RTL

D BCDPnt.show               # Print the digit
  LAE '0
  EAB
  W1A
  JPL BCDPnt.nxt  
  




