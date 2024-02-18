# EUPOUT - A Breakout Clone for the EUP5108 & EUP5208 I/O Chip
######################################################################
W main
O 0x10

# The ball locations
D Ball.Table 
L C0 00 01
L A0 00 01
L 90 00 01
L 88 00 01
L 84 00 01
L 82 00 01
L 81 00 01
L 80 80 01
L 80 40 01
L 80 20 01
L 80 10 01
L 80 08 01
L 80 04 01
L 80 02 01
L 80 01 01
L 80 00 81
L 80 00 41
L 80 00 21
L 80 00 11
L 80 00 09
L 80 00 05
L 80 00 03

# The Large Paddle in each possible position
D LargePaddle.Table
L FF 00 01
L BF 80 01
L 9F C0 01
L 8F E0 01
L 87 F0 01
L 83 F8 01
L 81 FC 01
L 80 FE 01
L 80 7F 01
L 80 3F 81
L 80 1F C1
L 80 0F E1
L 80 07 F1
L 80 03 F9
L 80 01 FD
L 80 00 FF

# Vars
V ScoreBCD
a 0x02
V PaddleLoc
a 0x00


# Start of .text section
O 0x0100
I EUP5208Lib.asm

C ButtonMask.0  0x10
C ButtonMask.1  0x20
C ButtonMask.2  0x40
C ButtonMask.3  0x80
C Joystick.Mask 0x0F
C Paddle.RowL   0x1D
C Paddle.RowM   0x3D
C Paddle.RowR   0x5D

# Draw Paddle
D DrawPaddle
  LDR PaddleLoc
  LBM 
  LDR LargePaddle.Table
  EDB
  W1E Paddle.RowL
  LBF
  W0B 
  IND
  W1E Paddle.RowM
  LBF
  W0B 
  IND
  W1E Paddle.RowR
  LBF
  W0B 
  RTL  
  
  

# Read Joystick & Buttons
######################################################################
D ReadJoyButtons
  LB2                   # Get current value of joy & buttons
  W2E 0x00  
  LAE ButtonMask.0      # Check if it is button 0
  AAB                   # Add value and mask
  JSN ButtonHit.0       # if !=0 button is pressed
 
  LAE ButtonMask.1      # Check if it is button 1
  AAB                   # Add value and mask
  JSN ButtonHit.1       # if !=0 button is pressed
  
  RTL                   # No buttons hit so return

D ButtonHit.0
  LDR PaddleLoc         # PaddleLoc += 3
  LBM                   # B = *PaddleLoc
  LAE 0x06              # A = 3
  EBA                   # B = B + A
  SIB                   # *PaddleLoc = B
  RTL                   # Only one button can be pressed at a time
 
D ButtonHit.1
  LDR PaddleLoc         # PaddleLoc -= 3
  LBM                   # B = *PaddleLoc
  LAE 0x06              # A = 3
  MBA                   # B = B - A
  SIB                   # *PaddleLoc = B
  RTL                   # Only one button can be pressed at a time



# Draw the frame around the play area
######################################################################
D DrawGameFrame
  W1E 0x1F              # Bottom Line (net)
  W0E 0xFF
  W1E 0x3F
  W0E 0x00
  W1E 0x5F
  W0E 0xFF
  
  LAE 0x1E              # 30 inner lines
D DrawGameFrame.do
  W1A                   
  W0E 0x80              # Left wall
  LBE 0x40
  EBA
  W1B
  W0E 0x01              # Right wall
  LBA
  DEA                   # Stop just below the top line
  JSN DrawGameFrame.do

# Top Line
  W1E 0x00              
  W0E 0xFF
  W1E 0x20
  W0E 0xFF
  W1E 0x40
  W0E 0xFF
  RTL

# main entry point  
######################################################################  
D main
  # Clear Screen
  W1E Screen.Clear

  # Draw checker test
  #CAL CheckerTest
  
  # Full screen fill
  #CAL FillScreen  
  
  # LED test
  CAL TestLEDS  

  # Clear Screen
  W1E Screen.Clear

  # Draw the Game's frame - assumes clear screen
  CAL DrawGameFrame
  
  LTE 0x15
  LDR PaddleLoc
  SIT
  

D main.loop
  CAL ReadJoyButtons
  # Display the PaddleLoc on LEDS.0
  #LDR PaddleLoc
  #LBM 
  #W1E LEDS.0
  #W0B
  CAL DrawPaddle
  JPS main.loop
  