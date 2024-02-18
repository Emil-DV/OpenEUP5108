# BIG LED lib

# printLED(A=Value)
D printLED
#ESC [<n>G
  TLA         # Shift A left = *2
  LDR LEDTbl  # Load start of table 
  EDA         # Add offset to table
  
  LBM         # Load A with low byte LED entry
  IND         # DR++
  LDM         # Load D with high byte of LED Entry
  LRB         # Put low byte into R
  
  LAE 0x03
D printLED.loop  
  LBM
  W1B
  IND
  LBM
  W1B
  IND
  LBM
  W1B
  IND
  W1E VT_ESC
  W1E VT_[
  W1E 0x33
  W1E VT_CUB
  W1E VT_ESC
  W1E VT_[
  W1E 0x31
  W1E VT_CUD
  DEA
  JPS printLED.loop
  RTL
  

D LEDTbl
W LED0
W LED1
W LED2
W LED3
W LED4
W LED5
W LED6
W LED7
W LED8
W LED9
W LEDA
W LEDB
W LEDC
W LEDD
W LEDE
W LEDF
D LED0  
L C9 CD BB
L BA 20 BA
L C8 CD BC
D LED1  
L 20 20 BB
L 20 20 BA
L 20 20 BA
D LED2  
L 20 CD BB
L C9 CD BC
L C8 CD CD
D LED3  
L 20 CD BB
L 20 CD B9
L CD CD BC
D LED4  
L BA 20 BA
L C8 CD B9
L 20 20 BA
D LED5  
L C9 CD 20
L C8 CD BB
L CD CD BC
D LED6
L C9 CD 20
L CC CD BB
L C8 CD BC
D LED7
L CD CD BB
L 20 20 BA
L 20 20 BA
D LED8  
L C9 CD BB
L CC CD B9
L C8 CD BC
D LED9  
L C9 CD BB
L C8 CD B9
L 20 20 BA
D LEDA
L C9 CD BB
L CC CD B9
L BA 20 BA
D LEDB  
L BA 20 20
L CC CD BB
L C8 CD BC
D LEDC  
L C9 CD CD
L BA 20 20
L C8 CD CD
D LEDD  
L 20 20 BA
L C9 CD B9
L C8 CD BC
D LEDE  
L C9 CD CD
L CC CD 20
L C8 CD CD
D LEDF  
L C9 CD CD
L CC CD 20
L BA 20 20
