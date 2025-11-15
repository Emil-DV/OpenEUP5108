# String functions
# Stack based
# strcpyconst(dst,src:EEPROM)
# strcpy(dst,src)

# Register
# strlen in:DR=src, out:A=len

# Some useful constants
C 'LF 0x0A
C 'CR 0x0D
C 'BS 0x08
C 'SP 0x20
C NULL 0x00
C 'ESC 0x1B

I Math.asm #The math functions needed for some of the string functions

#####################################################################################
# strreplace in:DR=pStr in:A value to remove in:B value to place
#            runs through a null term string replacing A with B
D strreplace
C strreplace.pStr 3
  SCD
  SCR
C strreplace.r 2
  SCA
C strreplace.p 1
  SCB

D strreplace.do
  POE strreplace.pStr
  LAM
  IND
  LDM
  LRA

  LBM
  # check if we are at the end
  JLN strreplace.cont
  # B = NULL so exit
  INS
  INS
  INS
  INS
  RTL  
  
D strreplace.cont
  POE strreplace.r
  LAM
  MBA
  JLN strreplace.nxt  
  POE strreplace.p
  LBM
  POE strreplace.pStr
  LAM
  IND
  LDM
  LRA
  SIB
D strreplace.nxt 
  POE strreplace.pStr # pStr++
  LAM
  IND
  LDM
  LRA
  IND
  LAR
  LBD
  POE strreplace.pStr
  SIA
  IND
  SIB
  JPL strreplace.do


#####################################################################################
# itoa in:DR=dst[3] in:B
# useage: LDR Dst address B=value then call itoa
D itoa
C itoa.pout 2
  SCD
  SCR
C itoa.val 1
  SCB
# The hundredths
  LAE 0x64    
  CAL DivBA
  LAR
# pout[0] = A
  POE itoa.pout
  LBM
  IND
  LDM
  LRB
  SIA
# val-=hundredths
  LBE 0x64
  CAL MulBA
  LBR
  POE itoa.val
  LAM
  MAB
#  POE itoa.val
  SIA

# The tenths
  LBA
  LAE 0x0A    
  CAL DivBA
  LAR
# pout[1] = A
  POE itoa.pout
  LBM
  IND
  LDM
  LRB
  IND
  SIA

# val-=tenths
  LBA
  LAE 0x0A
  CAL MulBA
  LBR
  POE itoa.val
  LAM
  MAB
  POE itoa.val
  SIA

# The ones
# pout[2] = A
  POE itoa.pout
  LBM
  IND
  LDM
  LRB
  IND
  IND
  SIA
  
  POE itoa.pout
  LBM
  IND
  LDM
  LRB

  LAM
  LBE 0x30
  EAB
  SIA
  IND

  LAM
  LBE 0x30
  EAB
  SIA
  IND

  LAM
  LBE 0x30
  EAB
  SIA

  INS
  INS
  INS
  RTL

#####################################################################################
# strlen in:DR=src out:A=len : limit 255
# useage: LDR Src address then call strlen. A=len upon return
D strlen
  LAZ             #A = 0
D strlen.r  
  LBM             #B = DRAM[DR]
  JSN strlen.c    # if B != 0 jump
  RTL             # return
D strlen.c  
  INA             # A++
  IND             # DR++
  JPL strlen.r    # loop

#####################################################################################
# strlenc in:DR=src out:A=len : limit 255
# useage: LDR Src address then call strlen. A=len upon return
D strlenc
  LAZ             #A = 0
D strlenc.r  
  LBF             #B = DRAM[DR]
  JSN strlenc.c   # if B != 0 jump
  RTL             # return
D strlenc.c  
  INA             # A++
  IND             # DR++
  JPL strlenc.r   # loop

#####################################################################################
# toUpperStr in: DR = pointer to null terminated string
# useage: Characters pointed to by DR: 'a'..'z' becomes 'A'..'Z'
D toUpperStr
  LBM
  JLN toUpperStr.c
  RTL
D toUpperStr.c
  CAL toUpperB
  SIB
  IND
  JPL toUpperStr
  
#####################################################################################
# toUpperB in/out:B
# useage: Characters in B 'a'..'z' becomes 'A'..'Z'
D toUpperB  
  LAE '`
  MAB
  JLR toUpperB.nd   # Borrow Set == B > '`
  JPL toUpperB.rtl  # Borrow !set == B <= '`
D toUpperB.nd
  LAE '{
  MAB
  JLR toUpperB.rtl  # Borrow Set == B > '{
  LAE 0x20          # in range a..z so add 0x20
  MBA
D toUpperB.rtl  
  RTL

#####################################################################################
# memcpyconst dst,src - copy from src to dst byte wise until a null is reached
# useage: Push Src address then dst address then length byte then call memcpyconst (src is ROM)
D memcpyconst
C memcpyc.src 7
C memcpyc.dst 5
C memcpyc.len 3
  
# check if the length is zero
  POE memcpyc.len
  LBM
  JLN memcpyconst.more
  RTL

D memcpyconst.more  
# B = Src[0];
# Load DR with address of Src which is SP+6
  POE memcpyc.src  # DR = SP+6
# DR = *DR
  LAM       # A = DRAM[DR]
  DED       # DR--
  LDM       # D = DRAM[DR]
  LRA       # R = A

# Loads into B set the zero flag 
  LBF       # B = EEPROM[DR]

# Load DR with the address of Dst which is expected at SP+4
  POE memcpyc.dst  # DR = SP+4
  LAM       # A = DRAM[DR]
  DED       # DR--
  LDM       # D = DRAM[DR]
  LRA       # R = A

# Store the value from Src into Dst
  SIB       # DRAM[DR] = B

# increment DR (aka Dst)
  IND       # DR++

# Store new value of dst
  LAR       # A = R
  LBD       # B = D
  POE memcpyc.dst  # DR = SP+4
  SIA       # DRAM[DR] = A
  DED       # DR--
  SIB       # DRAM[DR] = B
 
# Load DR with address of Src which is SP+6
  POE memcpyc.src  # DR = SP+6

# Load DR with Src
  LAM       # A = DRAM[DR]
  DED       # DR--
  LDM       # D = DRAM[DR]
  LRA       # R = A

# increment Src
  IND       # DR++

#store new value
  LAR       # A = R
  LBD       # B = D
  POE memcpyc.src  # DR = SP+6
  SIA       # DRAM[DR] = A
  DED       # DR--
  SIB       # DRAM[DR] = B

# load value of length and decrement 
  POE memcpyc.len
  LAM
  DEA
  SIA
    
# Loop
  JPL memcpyconst

  
  

#####################################################################################
# strcpyconst dst,src - copy from src to dst byte wise until a null is reached
# useage: Push Src address then dst address then call strcpyconst (src is ROM)
D strcpyconst
# B = Src[0];
# Load DR with address of Src which is SP+6
C strcpy.src 6
  POE strcpy.src  # DR = SP+6
# DR = *DR
  LAM       # A = DRAM[DR]
  DED       # DR--
  LDM       # D = DRAM[DR]
  LRA       # R = A

# Loads into B set the zero flag 
  LBF       # B = EEPROM[DR]

# check if null, jump to continue
  JLN strcpyconst.cont

# Load DR with the address of Dst which is expected at SP+4
C strcpy.dst 4
  POE strcpy.dst  # DR = SP+4
  LAM       # A = DRAM[DR]
  DED       # DR--
  LDM       # D = DRAM[DR]
  LRA       # R = A

# Store the null at the end of the strcpy
  SIB       # DRAM[DR] = B
  RTL       # return
 
D strcpyconst.cont
# Load DR with the address of Dst which is expected at SP+4
  POE strcpy.dst  # DR = SP+4
  LAM       # A = DRAM[DR]
  DED       # DR--
  LDM       # D = DRAM[DR]
  LRA       # R = A

# Store the value from Src into Dst
  SIB       # DRAM[DR] = B

# increment DR (aka Dst)
  IND       # DR++

# Store new value of dst
  LAR       # A = R
  LBD       # B = D
  POE strcpy.dst  # DR = SP+4
  SIA       # DRAM[DR] = A
  DED       # DR--
  SIB       # DRAM[DR] = B
 
# Load DR with address of Src which is SP+6
  POE strcpy.src  # DR = SP+6

# Load DR with Src
  LAM       # A = DRAM[DR]
  DED       # DR--
  LDM       # D = DRAM[DR]
  LRA       # R = A

# increment Src
  IND       # DR++

#store new value
  LAR       # A = R
  LBD       # B = D
  POE strcpy.src  # DR = SP+6
  SIA       # DRAM[DR] = A
  DED       # DR--
  SIB       # DRAM[DR] = B
# Loop
  JPL strcpyconst

V strcpyDelim # Set this to 0x20 to copy the first word
a 1
#####################################################################################
# strcpy dst,src - copy from src to dst byte wise until a null is reached
# useage: Push Src address then dst address then call strcpy (src & dst are in DRAM)
D strcpy
# B = Src[0];
# Load DR with address of Src which is SP+6
  POE strcpy.src  # DR = SP +6

# Load two bytes pointed to by DR into DR
  LAM       # A = DRAM[DR]
  DED       # DR--
  LDM       # D = DRAM[DR]
  LRA       # R = A

# Loads into B set the zero flag 
  LBM       # B = DRAM[DR]

# check if null, jump to continue
  JLN strcpy.cont
D strcpy.xit
# Load DR with the address of Dst which is expected at SP+4
  POE strcpy.dst  # DR = SP + 4
  LAM       # A = DRAM[DR]
  DED       # DR--
  LDM       # D = DRAM[DR]
  LRA       # R = A
# Store the null at the end of the strcpy
  SIB       # DRAM[DR] = B
  RTL       # return
 
D strcpy.cont
  LDR strcpyDelim
  LAM
  MAB
  JLN strcpy.cont2
  LBZ
  JPL strcpy.xit
  
D strcpy.cont2  
# Load DR with the address of Dst which is expected at SP+4
  POE strcpy.dst  # DR = SP + 4
  LAM       # A = DRAM[DR]
  DED       # DR--
  LDM       # D = DRAM[DR]
  LRA       # R = A

# Store the value from Src into Dst
  SIB       # DRAM[DR] = B

# increment DR (aka Dst)
  IND       # DR++

# Store new value of dst
  LAR       # A = R
  LBD       # B = D
  POE strcpy.dst  # DR = SP + 4
  SIA       # DRAM[DR] = A
  DED       # DR--
  SIB       # DRAM[DR] = B
 
# Load DR with address of Src which is SP+6
  POE strcpy.src  # DR = SP + 6

# Load DR with Src
  LAM       # A = DRAM[DR]
  DED       # DR--
  LDM       # D = DRAM[DR]
  LRA       # R = A

# increment Src
  IND       # DR++

#store new value
  LAR       # A = R
  LBD       # B = D
  POE strcpy.src  # DR = SP + 6
  SIA       # DRAM[DR] = A
  DED       # DR--
  SIB       # DRAM[DR] = B
# Loop
  JPL strcpy


#####################################################################################
# strcmpconst dst,src - compares src to dst byte wise until a mismatch is reached
# useage: Push Src address then Var address then call strcmpconst (src is ROM)
D strcmpconst
C strcmpconst.Src 7
C strcmpconst.Dst 5
C strcmpconst.tmp 1       # tmp = zero
  LAZ
  SCA
  
  POE strcmpconst.Src     # *Src
  LAM
  DED
  LDM
  LRA
  CAL strlenc             # get length
  POE strcmpconst.tmp     # tmp = strlenc(*Src)
  SIA
  POE strcmpconst.Dst     # *Dst
  LAM
  DED
  LDM
  LRA
  CAL strlen              # get length
  POE strcmpconst.tmp     # A = strlen(*Dst)
  LBM
  MAB
  JLN strcmpconst.diff    # if A != tmp goto diff

D strcmpconst.do
# B = Src[0];
# Load DR with address of Src which is SP+6
  POE strcmpconst.Src  # DR = SP+6

# Read the two bytes located at stack address into DR
  LAM       # A = DRAM[DR]
  DED       # DR--
  LDM       # D = DRAM[DR]
  LRA       # R = A

# Loads into B set the zero flag 
  LBF       # B = EEPROM[DR]

# check if null, jump to continue
  JLN strcmpconst.cont
  INS
  RTL       # return
 
D strcmpconst.cont
# Load DR with the address of Var which is expected at SP+4
  POE strcmpconst.Dst  # DR = SP+4
  LAM       # A = DRAM[DR]
  DED       # DR--
  LDM       # D = DRAM[DR]
  LRA       # R = A

# Read a value from Var into A
  LAM       # A = DRAM[DR]

  MAB       # Subtract B from A
  JLN strcmpconst.diff
  
# increment DR (aka Var)
  IND       # DR++

# Store new value of Var
  LAR       # A = R
  LBD       # B = D
  POE strcmpconst.Dst  # DR = SP+4
  SIA       # DRAM[DR] = A
  DED       # DR--
  SIB       # DRAM[DR] = B
 
# Load DR with address of Src which is SP+6
  POE strcmpconst.Src  # DR = SP+6

# Load DR with Src
  LAM       # A = DRAM[DR]
  DED       # DR--
  LDM       # D = DRAM[DR]
  LRA       # R = A

# increment Src
  IND       # DR++

#store new value
  LAR       # A = R
  LBD       # B = D
  POE strcmpconst.Src  # DR = SP+6
  SIA       # DRAM[DR] = A
  DED       # DR--
  SIB       # DRAM[DR] = B
# Loop
  JPL strcmpconst.do

D strcmpconst.diff
  INS
  LBE 1
  RTL
  

#######################################################
# repeatChar: prints a character A times
# A = character count
# B = character to print
D repeatChar
  W1B             # Output the character
  DEA             # Decrement A
  JLN repeatChar
  RTL

    
  

#######################################################
# atol(&DR) convert the characters pointed to with DR
#           into a two byte and put the results into DR
#           Assumes string passed has only '0'..'9'
D atol
  HLT                 # Nop for debug
C atol.src  4         # Local copy of string address
  SCR                 # Put contents of DR on stack
  SCD
C atol.lVal 2         # Local accumulator
  LAZ                 # A = 0
  SCA                 # lVar = 0
  SCA         

  LBM                 # B=DR[0]
  JLN atol.nxt        # not a null
# at end of string 
D atol.xit
# put lVal into DR
  POE atol.lVal       # DR = SP-2
  LAM                 # A = DRAM[DR]
  IND                 # DR++
  LDM                 # D = DRAM[DR]
  LRA                 # R = A
# clean up stack  
  INS
  INS
  INS
  INS
  
  RTL
  
D atol.nxt
  LAE '0
  MBA                 # B=B-A //subtract '0 from the first character
#  LAE A = 10
#  MAB A = A - B //if B is > 10 then it should have been A..F so subtract more
#  JSB if borrow then B > 10 goto |sm
#  JPS goto |sv
#  d sm
#  LAE A = 7
#  MBA B=B-A // subtract an additional 7 and A..F should be 0A..0F
#  d sv
#  SIB DR[0]=B-A
#  RTL Return


#  32
#  01
#  233
