#######################################################
# Test Function - a place for test code
# This is an example of an external source code addition
# to the EUP shell

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
  
  # Run the playing card test
  JPL testPlayingCards

# The playing cards test  
V tf.col
a 1
V tf.row
a 1
V tf.char
a 1
V tf.i
a 1

D testPlayingCards  
  LDR tf.i
  LAO
  SIA
  
  CAL docInitDeck
  LAE 16
  LBE 2
  CAL vtSetCursorPos

  LDR VTBLUEONWHT
  CAL printStr1E

  LDR docBack
  CAL printStr1E
  
  
D tf.docdo1  
  LDR tf.char
  LAZ
  SIA

  LDR tf.col
  LAE 24
  SIA
  LDR tf.row
  LAE 2
  SIA
  
D tf.docdo
  LDR tf.col
  LAM
  LDR tf.row
  LBM
  CAL vtSetCursorPos
  
  LDR tf.char
  LAM
  LDR docFullDeck
  EDA
  LAM
  CAL docDrawCard

  W2E 0x50		# Play a beep sound
  
  LDR tf.col
  LAM
  LBE 6
  EAB
  SIA
  
  LBE 48
  MBA
  JLN tf.docrc
  LDR tf.col
  LAE 24
  SIA
  LDR tf.row
  LAM
  INA
  SIA
  
  
D tf.docrc  
  LDR tf.char
  LAM
  INA
  SIA
  
  LBE 52
  MBA
  JLN tf.docdo  

  LDR VTREDONBLK
  CAL printStr1E

  LAE 2			#Starting col of LED prints
  LDR tf.i		#LED Number
  LBM
  TLB			#Multiply B by 4 via shifts
  TLB
  EAB
  LBE 20		#Starting row of LED prints
  CAL vtSetCursorPos
  
  LDR tf.i
  LAM
  CAL printLED
  LDR tf.i
  LAM
  INA
  SIA

  CAL docShuffleDeck
  CAL getCharB
  LAE 'q
  MAB
  JLN tf.docdo1 

D tf.loop  
  LAE 80
  CAL getRand
  INB
  LDR tf.col
  SIB

  LAE 25
  CAL getRand
  INB
  LDR tf.row
  SIB

  LAE 0xF0
  CAL getRand
  INB
  LAE 'ESC
  MAB
  JLN tf.pchar
  INB
D tf.pchar
  LDR tf.char
  SIB

  LDR tf.col  
  LAM
  LDR tf.row
  LBM  
  CAL vtSetCursorPos
  LDR tf.char
  LAM
  W1A

  LAZ
D tf.delay
  DEA
  NOP
  NOP
  NOP
  JLN tf.delay
  
  JPL tf.loop
  
  W1E 'LF
  LDR charRuler
  CAL printStr1E
 
  LDR VTREDONBLK  # Set Red on Black
  CAL printStr1E

# First we push the row and col for the top left of the box
  LAE 3           # Row = 3
  SCA
  LAE 7           # Col - vt100 Window is 1 based
  SCA
# These are the inner dimensions of the box
# not including the top/bottom or left/right of the frame
  LAE 12          # Width
  LBE 1           # height
  LDR DBLLineMatrix # Double line box matrix
  CAL DrawBox
  INS             # Remove the passed vars
  INS


D testFunc.xit
  RTL
  


