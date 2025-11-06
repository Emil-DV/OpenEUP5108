#######################################################
## Util Functions

## printStr1E/D 
## getCharB
## isDigitB
## isHexDigitB
## DivBA
## printBHex

D charRuler
S          1         2         3         4         5         6         7         8\n
S 123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*\n\0


#######################################################
# callFNptr  This could be a better use of the CAS instruction
D callFNptr  # Calls the function stored in DR and returns
  #HLT
  NOP
  
  LAR                 # Store DR in BA
  LBD
  LDR callFNptr.call  # Get the pointer to the call instruction in ROM
  IND                 # Skip the CAL instruction itself
  SEA                 # Write the DR that was passed in
  IND
  SEB
D callFNptr.call # a manually entered CAL instruction
L 96 00 00            # Call the function pointer passed in
  RTL


#######################################################
# getRand       Gets a random number from the SFP
D getRand
  W2E 0xFE      # put in random num mode
  W2A           # A=random number range
  LB0
  W0E 0x00
  W2E 0xFC
  RTL
#######################################################
# incShort      Add one to the value stored at DR
D incShort
  LAM
  INA
  SIA
  JLC incShort.c
  RTL
  
D incShort.c
  IND
  LAM
  INA
  SIA
  
  RTL

#######################################################
D sleep       # A=loop count
  #HLT
D sleep.y     # do {
#  LDZ         #   DR = 0
  LRE 0xFF
  LDE 0x0F
#  LTO         #   T = 1
#  MDT         #   DR -= T
D sleep.x     #   do {
  DED         #     DR -= 1
  JLN sleep.x #   }while(DR != 0)
  DEA         #   A -= 1
  JLN sleep.y # }while(A != 0)
  #HLT
  RTL         # return

# One loop =  1044818 cycles
# Mhz      = 30000000 
#          ~ 35ms

#######################################################
D PrintASCIITbl
C PrintASCIITbl.i 1
  LAE 0x20              # Start at the space character
  SCA 

  W1E 'LF
D PrintASCIITbL.lp
  POE PrintASCIITbl.i      
  LBM
  LAZ
  MAB
  JLN PrintASCIITbL.lp1
  W1E 'LF
  INS
  RTL
D PrintASCIITbL.lp1
  CAL printBHex
  W1E 'SP
  W1B
  W1E 0xB3
  INB
  POE PrintASCIITbl.i
  SIB
  LAE 0x7F
  MAB
  JLN PrintASCIITbL.lp
  CAL printBHex
  W1E 'SP
  W1E 'SP
  W1E 0xB3
  INB
  POE PrintASCIITbl.i
  SIB
  JPL PrintASCIITbL.lp  



#######################################################

#I stringlib.asm

#######################################################
# stackDump: prints some lines of stack memory
# A = line count
D stackDump
  # Save the line count to DumpLines
  LDR DumpLines
  SIA
  # Left shift the line count to get the address difference
  RRA
  RRA
  RRA
  RRA
  
  LDZ             # Zero out DR
  MDA             # Subtract the line

  # Save DR to the DumpStart location 
  LAD
  LBR
  LDR DumpStart
  SIB
  IND
  SIA
 
  CAL DRamDump
  RTL

# End stackDump ---------------------------------------



#######################################################
## Print a string of characters to Port1 from EEPROM
## Takes advantage of the hardware increment in the SP  
## rather than adding 1 to DR each time                 
D printStr1E 
  IQM # Mask IRQs since we are using SP for other stuff
  XDS # swap(DR,SP)
  TDS # Toggle(DR/SP) 
D printStr1E.pb
  LBF # B=EROM(SP) 
  W1B # Port1=B 
  JLN printStr1E.kp # if(B) goto |kp 
  TDS # Toggle(DR/SP) 
  XDS # swap(DR,SP)
  IQU # unmask IRQs
  RTL # Return
D printStr1E.kp
  INS # SP++
  JPL printStr1E.pb

#######################################################
## Print a string of characters to Port1 from DRAM
## Takes advantage of the hardware increment in the SP  
## rather than adding 1 to DR each time                 
D printStr1D 
  IQM # mask IRQs
  XDS # swap(DR,SP)
  TDS # Toggle(DR/SP) 
D printStr1D.pb 
  LBM # B=DRAM(SP) 
  W1B # Port1=B 
  JSN printStr1D.kp #if(B) goto |kp 
  TDS # Toggle(DR/SP) 
  XDS # swap(DR,SP)
  IQU # unmask IRQs
  RTL # Return
D printStr1D.kp  
  INS # SP++
  JPL printStr1D.pb #goto |pb

#######################################################
## getCharB - read a byte from port0 into B and return when != 0
##           write 0 to port0 to indicate the value has been read
D getCharB
  LB0             # B = Port0       
  JSN getCharB.go  # if(b) ACK read and return
  JPL getCharB     # No character so loop
D getCharB.go
  W0E 0x00        # Port0 = 0  
  RTL             # Return

#######################################################
## isDigitB - check if the contents of B are >= '0' && < ':'
##            A set to 0/1 to indicates it is/not a digit
D isDigitB
# Check if the input is greater than '/' (one less than '0')
  LAE 0x2F        # '/
  MAB             # A=A-B
  JLR isDigitB.nd # if(B > A) Borrow flag is set so goto |nd
  JPL isDigitB.or # else goto |or
# Check if input is less than ':' (one more than '9')
D isDigitB.nd
  LAE 0x3A        # ':
  MAB             # A=A-B
  JLR isDigitB.or # if(B > A) goto |or
# Value is a digit so set A to one and return
  LAE 0x30        # Difference between '0' and 0x00
  MBA
  LAO
  RTL
# Value is not a digit so set A to zero & return
D isDigitB.or
  LAZ
  RTL
  
#######################################################
## inRangeB - check if the contents of B are > D &&  B <= R 
##            A set to 0/1 to indicates it is/not in range
D inRangeB
# Check if the input is greater than D
  LAD             # A=D
  MAB             # A=A-B
  JLR inRangeB.nd # if(B > A) Borrow flag is set so goto |nd
  JLN inRangeB.or
#  JPL inRangeB.nd # else goto |or
# Check if input is less than R+1
D inRangeB.nd
  LAR             # A=R
  MAB             # A=A-B
  JLR inRangeB.or # if(B > A) goto |or
# Value is in range so set A to one and return
  LAO
  RTL
# Value is not in range so set A to zero & return
D inRangeB.or
  LAZ
  RTL

#######################################################
## isHexDigitB - check if the contents of B are >= 'A' && < 'G'
##            A set to 0/1 to indicates it is/not a digit
##            B set to hex value of digit
D isHexDigitB
  CAL isDigitB
  # if A == 1 return
  LTO # T = 1
  MTA # T=T-A
  JLN isHexDigitB.ltrchk
  RTL

D isHexDigitB.ltrchk
# Check if the input is greater than '/' (one less than '0')
  LAE '@          
  MAB                # A=A-B
  JLR isHexDigitB.nd # if(B > A) Borrow flag is set so goto |nd
  JPL isHexDigitB.or # else goto |or
# Check if input is less than = 'F'
D isHexDigitB.nd
  LAE 'F
  MAB                # A=A-B
  JLR isHexDigitB.or # if(B > A) goto |or
# Value is a digit so set A to one and return
  LAE 0x37        # Difference between 'A' and 0x0A
  MBA #B -= A
  LAO
  RTL
# Value is not a digit so set A to zero & return
D isHexDigitB.or
  LAZ
  RTL

# #######################################################
# Expects the string of hex characters to be on the stack
# along with the address of the output
# 
D xtos
C xtos.str 5  #sp+5 = pString
C xtos.val 3  #sp+3 = pValue

 # HLT  # debug breakpoint 
 # NOP
  
# String is in big endian 0xABCD value is stored CDAB (little)
# *pString = ABCD
  POE xtos.str
  LAM # load msb into A
  IND # increment DR
  LBM # load lsb into b
  LRB # load R with lsb
  LDA # load D with msb
  
  LBM # gets the third character of the string
  CAL isHexDigitB  
  LTO # T=1
  MAT # A=A-T
  JLN xtos.ret  # A != 1 so it is not a valid hex digit
  
  # B contains the numerical value of the character
  # for the upper nibble of the msb
  TLB
  TLB
  TLB
  TLB
  
  POE xtos.val
  LAM # load msb into A
  IND # increment DR
  LTM # load lsb into T
  LRT # load R with lsb
  LDA # load D with msb
  IND
  SIB
  
  POE xtos.str
  LAM # load msb into A
  IND # increment DR
  LBM # load lsb into b
  LRB # load R with lsb
  LDA # load D with msb
  IND

  LBM # gets the forth character of the string
  CAL isHexDigitB  
  LTO # T=1
  MAT # A=A-T
  JLN xtos.ret  # A != 1 so it is not a valid hex digit

  # B contains the numerical value of the character
  # for the lower nibble of the msb
  POE xtos.val
  LAM # load msb into A
  IND # increment DR
  LTM # load lsb into T
  LRT # load R with lsb
  LDA # load D with msb
  IND # DR++
  LTM # T = *DR
  EBT # B = B+T
  SIB # store full byte
  
  POE xtos.str
  LAM # load msb into A
  IND # increment DR
  LBM # load lsb into b
  LRB # load R with lsb
  LDA # load D with msb
  IND
  IND
  LBM # gets the fifth character of the string
  CAL isHexDigitB  
  LTO # T=1
  MAT # A=A-T
  JLN xtos.ret  # A != 1 so it is not a valid hex digit
  
  # B contains the numerical value of the character
  # for the upper nibble of the msb
  TLB
  TLB
  TLB
  TLB
  
  POE xtos.val
  LAM # load msb into A
  IND # increment DR
  LTM # load lsb into T
  LRT # load R with lsb
  LDA # load D with msb
  SIB
  
  POE xtos.str
  LAM # load msb into A
  IND # increment DR
  LBM # load lsb into b
  LRB # load R with lsb
  LDA # load D with msb
  IND
  IND
  IND

  LBM # gets the sixth character of the string
  CAL isHexDigitB  
  LTO # T=1
  MAT # A=A-T
  JLN xtos.ret  # A != 1 so it is not a valid hex digit

  # B contains the numerical value of the character
  # for the lower nibble of the msb
  POE xtos.val
  LAM # load msb into A
  IND # increment DR
  LTM # load lsb into T
  LRT # load R with lsb
  LDA # load D with msb
  LTM # T = *DR
  EBT # B = B+T
  SIB # store full byte
 
  
D xtos.ret  
  RTL


# #######################################################
# # 1030: *getLine(DR=dst,A=max)
D getLine

C getLine.char 5
  DES
C getLine.pStr 3
  SCR
  SCD
C getLine.max 2
  SCA
C getLine.len 1
  LAZ
  SCA

D getLine.ga    
  W1E sys.cursorChar
  W1E 'BS
  # Get a character
D getLine.gac
  # print cursor
  LB0
  JLN getLine.go
  JPL getLine.gac

D getLine.go  
  W0E 0x00        # Ack read
  # Check for Enter
  LAE 0x0A
  MAB 
  JLN getLine.c2
D getLine.xit

  # CR hit, write a nul to end the line, A is 0 at this point
  POE getLine.pStr
  LBM
  IND
  LDM
  LRB
  SIA  
  W1E 0x20

  INS
  INS
  INS
  INS
  INS
  RTL

  # Check for BS
D getLine.c2
  LAE 0x08
  MAB
  JLN getLine.oc
  # BS hit, delete last character, A is 0 at this point
  POE getLine.len 
  LBM
  JLN getLine.nbol
  JPL getLine.ga

D getLine.nbol  
  POE getLine.len 
  LBM
  DEB
  SIB

  # Decrement pStr
  POE getLine.pStr
  LAM
  IND
  LDM
  LRA
  DED
  LAZ # zero the character
  SIA
  LAR
  LBD
  POE getLine.pStr
  SIA
  IND
  SIB
  
  # Echo bs to port 1
  W1E 0x20
  W1E 'BS
  W1E 'BS 
  # Get another
  JPL getLine.ga 
  # Anything else we add to the string
D getLine.oc
  POE getLine.char
  SIB
  # check that len < max
  POE getLine.len
  LAM
  POE getLine.max
  LBM 
  MAB  
  JLN getLine.isspace
  JPL getLine.ga
  
D getLine.isspace  
  POE getLine.char
  LBM
  POE getLine.len
  LAM
  INA
  SIA

  # increment the pStr
  POE getLine.pStr
  LAM
  IND
  LDM
  LRA
  SIB # store char
  IND
  LAR
  LBD
  POE getLine.pStr
  SIA
  IND
  SIB
  
  # Check for 0xE0 - extended key code
  #LAE 0xE0
  #MAB
  #JLN getLine.oce
    
  #LB0
  #SCB 
  # increment the SP
  #INS # correct for auto SP-- of SC* commands
  #INS
  
  #W0E 0x00
  #JPL getLine.xit
  
D getLine.oce
  # Echo character to port 1
  POE getLine.char
  LBM
  W1B 
  # Get another
  JPL getLine.ga 



  
# #######################################################
D Nib2HexTbl
L 30 31 32 33 34 35 36 37 38 39 41 42 43 44 45 46
# #######################################################
D printBHex       # Print the value of B as a two character hex string
  LAE 0xF0        # mask for high nib
  AAB             # A=mask & B
  RRA             # Rotate Right x4
  RRA
  RRA
  RRA
  LDR Nib2HexTbl
  EDA             # index into the table
  LAF             # Load character from table
  W1A             # print character 
  LAE 0x0F        # mask for low nib
  AAB             # A = mask & B
  LDR Nib2HexTbl
  EDA             # index into the table
  LAF             # Load character from table
  W1A             # print character 
  W1E 0x00        # print null
  RTL

# #######################################################
# DumpRam - prints RAM memory in hex
# DR = Start address
#  A = count
# 
V DumpRam_start
a 2
V DumpRam_count
a 1

D DumpRam
  # Store DR into DumpRam.start
  LBD
  LTR
  LDR DumpRam_start
  SIT
  IND
  SIB
  
  # Store A into DumpRam.count
  LDR DumpRam_count
  SIA
  
  LBA
  JLN DumpRam.more
  RTL

D DumpRam.more
  # Load *DR into DR
  LDR DumpRam_start
  LAM       # A = DRAM[DR]
  IND       # DR++
  LDM       # D = DRAM[DR]
  LRA       # R = A

  # Read a bytes from memory and print it
  LBM
  CAL printBHex
  W1E 0x20
  
  # Increment DumpRam.start
  LDR DumpRam_start
  LAM       # A = DRAM[DR]
  IND       # DR++
  LDM       # D = DRAM[DR]
  LRA       # R = A
  IND
  LAR       # A = R
  LBD       # B = D
  LDR DumpRam_start
  SIA       # DumpRam.start[0] = A
  IND       # DR++
  SIB       # DumpRam.start[1] = B
  
  # Decrement DumpRam.count
  LDR DumpRam_count
  LBM
  DEB
  SIB
  JLN DumpRam.more 
  RTL
  
  
D DumpRamP
  # Store DR into DumpRam.start
  LBD
  LTR
  LDR DumpRam_start
  SIT
  IND
  SIB
  
  # Store A into DumpRam.count
  LDR DumpRam_count
  SIA
  
  LBA
  JLN DumpRamP.more
  RTL

D DumpRamP.more
  # Load *DR into DR
  LDR DumpRam_start
  LAM       # A = DRAM[DR]
  IND       # DR++
  LDM       # D = DRAM[DR]
  LRA       # R = A

  # Read a bytes from memory and print it
  LBM
  JLN DumpRamP.nz
  W1E 0x2E            # value was zero so print '.'
  JPL DumpRamP.next
  
D DumpRamP.nz 
  LAE 0x1F
  MAB
  JLR DumpRamP.ip
  W1E 0x2E            # value is < 32  print '.'
  JPL DumpRamP.next
  
D DumpRamP.ip  
#  LAE 0x80
#  MAB
#  JLR DumpRamP.inp
  W1B                 # value is >= 32 < 0x80 so print it
#  JPL DumpRamP.next
#D DumpRamP.inp
#  W1E 0x2E            # Value is > 0x80 so print '.'
  
D DumpRamP.next
  
  # Increment DumpRam.start
  LDR DumpRam_start
  LAM       # A = DRAM[DR]
  IND       # DR++
  LDM       # D = DRAM[DR]
  LRA       # R = A
  IND
  LAR       # A = R
  LBD       # B = D
  LDR DumpRam_start
  SIA       # DumpRam.start[0] = A
  IND       # DR++
  SIB       # DumpRam.start[1] = B
  
  # Decrement DumpRam.count
  LDR DumpRam_count
  LBM
  DEB
  SIB
  JLN DumpRamP.more 
  RTL  

# #######################################################
V DumpStart
a 2
V DumpLines
a 1

D DRamDumpHeader
S DRAM:00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F 0123456789ABEDEF\n\0

  
D DRamDump
  POE 0x00
  LDR DRamDumpHeader
  CAL printStr1E

  LAE 0x45
  LBE '-
  CAL repeatChar
  W1E 0x0A

D DRamDump.more
  LDR DumpStart  
  LAM       # A = DRAM[DR]
  IND       # DR++
  LDM       # D = DRAM[DR]
  LRA       # R = A
  LBD 
  CAL printBHex
  
  LDR DumpStart
  LAM       # A = DRAM[DR]
  IND       # DR++
  LDM       # D = DRAM[DR]
  LRA       # R = A
  LBR
  CAL printBHex
    
  W1E 0x3A
  
  LDR DumpStart
  LAM       # A = DRAM[DR]
  IND       # DR++
  LDM       # D = DRAM[DR]
  LRA       # R = A
  
  LAE 0x10
  CAL DumpRam
  
  LDR DumpStart
  LAM       # A = DRAM[DR]
  IND       # DR++
  LDM       # D = DRAM[DR]
  LRA       # R = A
  
  LAE 0x10
  CAL DumpRamP

  W1E 0x0A
  
  LDR DumpStart
  LAM       # A = DRAM[DR]
  IND       # DR++
  LDM       # D = DRAM[DR]
  LRA       # R = A

  LAE 0x10
  EDA
  LAD
  LBR
  LDR DumpStart
  SIB
  IND
  SIA
  
  LDR DumpLines
  LBM
  DEB
  SIB
  JLN DRamDump.more
  
  RTL
  
  
  
  
  
  
  

















# #######################################################
# # 10A0: *TestScreenWidth()      
#       HLT / NOP for debug
# 01A0: 00
#       LDR Nib2HexTbl
# 01A1: 71 1E 00
#       LAE  i = 8
# 01A4: 31 08
#   |il LBE  j = 10
# 01A6: 41 0A
#   |jl LRB R=j 
# 01A8: 64
#       W1F Port1=EROM[DR]
# 01A9: D2
#       DEB j--
# 01AA: B9
#       JSN if(j) goto |jl 
# 01AB: 82 88
#       DEA i--
# 01AD: B8
#       JSN if(i) goto |il
# 01AE: 82 86
#       W1E Port1=00
# 01B0: D1 00 
#       RTL return
# 01B2: 97 



