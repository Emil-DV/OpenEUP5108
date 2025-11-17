# BIG LED lib - A bit more wonky then I'd like but good for now.

# printLED(A=Value)
D printLED
C printLED.val 4
  SCA
C printLED.pLED 2
  DES
  DES
C printLED.i 1
  LBE 3
  SCB
  
  POE printLED.val
  LAM
  # we could do a range check to ensure it is 0..F
  # or we just blank out the upper nibble
  LBE 0x0F
  AAB

  TLA         # Shift A left = *2
  LDR LEDTbl  # Load start of table 
  EDA         # Add offset to table
  LAF         # Lsb of LED location
  IND         
  LBF         # msb of led locaiton
  POE printLED.pLED #pLED = *DR
  SIA
  IND
  SIB
  
D printLED.loop  
  POE printLED.pLED
  LAM         # Load A with low byte LED entry
  IND         # DR++
  LDM         # Load D with high byte of LED Entry
  LRA         # Put low byte into R
  CAL printStr1E # Print the line of the font
  
  POE printLED.pLED # Add 4 to *pLED
  LAM
  IND
  LDM
  LRA
  
  LAE 4       
  EDA
  LAR
  LBD
  POE printLED.pLED
  SIA
  IND
  SIB
  
  LDR BigLEDnl   
  CAL printStr1E # Print the "nl" that positions the cursor
  
  POE printLED.i # i--
  LAM
  DEA
  SIA
  JLN printLED.loop #while(i>0)
  
D printLED.xt  
  INS
  INS
  INS
  INS
  RTL
  
D BigLEDnl
S \e[3D\e\e[1B\e\0

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
L C9 CD BB 00
L BA 20 BA 00
L C8 CD BC 00
D LED1  
L 20 BB 20 00
L 20 BA 20 00
L D4 CA BE 00
D LED2  
L D5 CD BB 00
L C9 CD BC 00
L C8 CD CD 00
D LED3  
L 20 CD BB 00
L 20 CD B9 00
L D4 CD BC 00
D LED4  
L D2 20 D2 00
L C8 CD B9 00
L 20 20 D0 00
D LED5  
L C9 CD B8 00
L C8 CD BB 00
L CD CD BC 00
D LED6
L C9 CD B8 00
L CC CD BB 00
L C8 CD BC 00
D LED7
L CD BB 20 00
L 20 BA 20 00
L 20 D0 20 00
D LED8  
L C9 CD BB 00
L CC CD B9 00
L C8 CD BC 00
D LED9  
L C9 CD BB 00
L C8 CD B9 00
L 20 20 D0 00
D LEDA
L C9 CD BB 00
L CC CD B9 00
L D0 20 D0 00
D LEDB  
L D2 20 20 00
L CC CD BB 00
L C8 CD BC 00
D LEDC  
L C9 CD CD 00
L BA 20 20 00
L C8 CD CD 00
D LEDD  
L 20 20 D2 00
L C9 CD B9 00
L C8 CD BC 00
D LEDE  
L C9 CD CD 00
L CC CD 20 00
L C8 CD CD 00
D LEDF  
L C9 CD CD 00
L CC CD 20 00
L D0 20 20 00
