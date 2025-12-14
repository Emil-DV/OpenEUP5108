#######################################################
# Test Function - a place for test code
# This is an example of an external source code addition
# to the EUP shell

I ../stdlibs/rand.asm # Bring in the random number lib

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
  
  
  # Clear the screen
  LDR VTCLR
  CAL printStr1E
  LDR VTHOME
  CAL printStr1E
  
  
# const char Astr[] = {"Hello Ian!"}
D Astr  
S Hello Ian!\0 
 
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

  #W2E 0x40		# Play a beep sound
  LAE 4
  CAL sleep
  
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


D testFunc.xit
  RTL
  


