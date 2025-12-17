#######################################################
## Box Drawing for the  EUP 5108
#######################################################

I BoxDrawingDigits.asm


C 'DBul 0xC9
C 'DBhb 0xCD
C 'DBur 0xBB
C 'DBvb 0xBA
C 'DBlr 0xBC
C 'DBll 0xC8


D DBLLineMatrix
# ╔═╗
L C9 CD BB
# ║ ║
L BA 20 BA
# ╚═╝
L C8 CD BC

D SNGLineMatrix
# ┌─┐
L DA C4 BF
# │ │
L B3 20 B3
# └─┘
L C0 C4 D9

D SDBLineMatrix
# ╒═╕
L D5 CD B8
# │ │
L B3 20 B3
# ╘═╛
L D4 CD BE

D BlankNMatrix
L 20 20 20
L 20 20 20
L 20 20 20

V DrawBoxFmDRAM
a 1

#######################################################
## Draw Box - A=Width B=Height DR=pBoxMatrix
##            Push Row, Col location on stack
#######################################################
D DrawBox
C DDB.Row   9     # Row on stack
C DDB.Col   8     # Col on stack
C DDB.i     5     # index
  DES             # stack space for index
C DDB.Width 4     # Width passed in A
  SCA             # push
C DDB.Height 3    # Height passed in B
  SCB             # push
C DDB.Matrix 1    # Matrix passed in DR
  SCR             # push
  SCD

  POE DDB.Col     # A = Col
  LAM             
  POE DDB.Row     # B = Row
  LBM
  POE DDB.i       # i = Row
  SIB
  CAL vtSetCursorPos

  POE DDB.Width   # A = Width  
  LAM

  LDR DrawBoxFmDRAM
  LBM
  JLN DrawBox.D

  POE DDB.Matrix  # DR = matrix
  LBM
  IND
  LRM
  LDB
  CAL DrawBoxLineE
  JPL DDB.lp
D DrawBox.D  
  POE DDB.Matrix  # DR = matrix
  LBM
  IND
  LRM
  LDB
  CAL DrawBoxLineD
  
D DDB.lp    
  # Row++ set cursor pos
  POE DDB.Col
  LAM
  POE DDB.i
  LBM
  INB
  SIB

  CAL vtSetCursorPos
  
  POE DDB.Width
  LAM

  LDR DrawBoxFmDRAM
  LBM
  JLN DrawBox.D2

  POE DDB.Matrix
  LBM
  IND
  LRM
  LDB
  LTE 0x03
  EDT
  CAL DrawBoxLineE
  JPL DrawBox.n
D DrawBox.D2
  POE DDB.Matrix
  LBM
  IND
  LRM
  LDB
  LTE 0x03
  EDT
  CAL DrawBoxLineD
D DrawBox.n
  POE DDB.Height
  LBM
  DEB
  SIB
  JLN DDB.lp

   # Row++ set cursor pos
  POE DDB.Col
  LAM
  POE DDB.i
  LBM
  INB
  SIB
  CAL vtSetCursorPos
  
  POE DDB.Width
  LAM

  LDR DrawBoxFmDRAM
  LBM
  JLN DrawBox.D3
  
  POE DDB.Matrix
  LBM
  IND
  LRM
  LDB
  LTE 0x06
  EDT
  CAL DrawBoxLineE
  JPL DrawBox.e

D DrawBox.D3
  POE DDB.Matrix
  LBM
  IND
  LRM
  LDB
  LTE 0x06
  EDT
  CAL DrawBoxLineD

D DrawBox.e
  INS
  INS
  INS
  INS
  INS

  RTL
  
#########################################  
# DrawBoxLineE DR=pMatrix A=width src in ROM
D DrawBoxLineE  
  LTF         # Get first byte from matrix
  W1T         # Print it
  IND         # DR++
D DBLE.lp      # Do
  LTF         # Get Middle byte
  W1T         # Print it
  DEA         # A--
  JLN DBLE.lp  # while A > 0
  IND         # DR++
  LTF         # Get last byte
  W1T         # Print it
  RTL     


#########################################  
# DrawBoxLineD DR=pMatrix A=width src in DRAM
D DrawBoxLineD  
  LTM         # Get first byte from matrix
  W1T         # Print it
  IND         # DR++
D DBL.lp      # Do
  LTM         # Get Middle byte
  W1T         # Print it
  DEA         # A--
  JLN DBL.lp  # while A > 0
  IND         # DR++
  LTM         # Get last byte
  W1T         # Print it
  RTL     

#######################################################
D BoxBannerStr
#  E  U  P  5  1  0  8  
L 0E 10 11 05 01 00 08 

D BoxBanner           # void BoxBanner(void) {
C BoxBanner.i 3
  DES
C BoxBanner.r 2       
  SCA
C BoxBanner.c 1       
  SCB
 
  POE BoxBanner.i       # i = 0
  LAE 0
  SIA
  
D BoxBanner.do 
  POE BoxBanner.i      # A = BoxBanner[i]
  LAM
  LDR BoxBannerStr
  EDA
  LAF

  # index to the digit
  LBE BoxDigitSize
  CAL MulBA
  LAR
  LDR BoxDigits
  EDA
  # Draw a 1x1 box
  LAO
  LBA
  CAL DrawBox

  POE BoxBanner.i      # A = BoxBanner[i]
  LAM
  TLA
  TLA
  TLA
  TLA
  LBE 0x11
  EAB
  W2A
  
  LAE 1
  CAL sleep


  # Adjust cursor to new pos
  POE BoxBanner.c
  LAM
  LBE 4
  EAB
  SIA

  POE BoxBanner.i     # i++ 
  LAM
  INA
  SIA
  
  LBE 7
  MBA
  JLN BoxBanner.do 
  
  INS
  INS
  INS
  RTL                 #}
#######################################################
D PrintBoxDigits  
C PrintBoxDigits.i 1        # char i [stack local]
  LAZ                 # A=0
  SCA                 # i=0 Push A on stack 
                        
D PrintBoxDigits.lp         # do{
  LBE BoxDigitSize    # B=array entry size
  CAL MulBA           # DR=B*A
  LAR                 # Only need the lsb (R)
  LDR BoxDigits       # Load Array base address
  EDA                 # DR+=A
  CAL printStr1E        
  
  CAL getCharB
  LDR VTU3
  CAL printStr1E
  
  POE PrintBoxDigits.i      # A=i
  LAM                   
  INA                 # A++
  SIA                 # i=A
  LBE BoxDigitCount   # B=digit count     
  MBA                 # B=B-A  
  JLN PrintBoxDigits.lp     # }while(BoxDigitCount-i != 0)
  
  INS                 # Clean up stack
  RTL



D DrawBoxTest  
  INS
# Test of the DrawBox function  
  LDR VTCLR		# Clear the screen
  CAL printStr1E

  LDR VTHOME		# Home the cursor
  CAL printStr1E
  
  LDR charRuler		# Print the ruler
  CAL printStr1E
 
  LDR VTREDONBLK  	# Set Red on Black
  CAL printStr1E

  # For the drawBox function we first push the row and col onto the stack for the top left of the box
  LAE 3          	# Row = 3
  SCA
  LAE 7         	# Col - vt100 Window is 1 based
  SCA
  # The inner dimensions of the box are passed in A (width) & B (height
  # not including the top/bottom or left/right of the frame
  LAE 12        	# Width
  LBE 3        		# height
  LDR DBLLineMatrix	# Double line box matrix
  CAL DrawBox		# Draw it
  INS		        # Remove the passed vars from the stack
  INS
  RTL
    
