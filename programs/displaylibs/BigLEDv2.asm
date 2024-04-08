# BIG LED lib - A bit more wonky then I'd like but good for now.
# printLED(A=Value)
D printLED
C printLED.val 4
  SCA
C printLED.pLED 2
  DES
  DES
C printLED.i 1
  LBE 5
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
  
  LAE 5      
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
S \e[4D\e\e[1B\e\0

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
L 20 FE FE 20 00
L DB 20 20 DB 00
L 20 20 20 20 00
L DB 20 20 DB 00
L 20 FE FE 20 00
D LED1  
L 20 20 20 20 00
L 20 20 20 DB 00
L 20 20 20 20 00
L 20 20 20 DB 00
L 20 20 20 20 00
D LED2  
L 20 FE FE 20 00
L 20 20 20 DB 00
L 20 FE FE 20 00
L DB 20 20 20 00
L 20 FE FE 20 00
D LED3  
L 20 FE FE 20 00
L 20 20 20 DB 00
L 20 FE FE 20 00
L 20 20 20 DB 00
L 20 FE FE 20 00
D LED4  
L 20 20 20 20 00
L DB 20 20 DB 00
L 20 FE FE 20 00
L 20 20 20 DB 00
L 20 20 20 20 00
D LED5  
L 20 FE FE 20 00
L DB 20 20 20 00
L 20 FE FE 20 00
L 20 20 20 DB 00
L 20 FE FE 20 00
D LED6
L 20 FE FE 20 00
L DB 20 20 20 00
L 20 FE FE 20 00
L DB 20 20 DB 00
L 20 FE FE 20 00
D LED7
L 20 FE FE 20 00
L 20 20 20 DB 00
L 20 20 20 20 00
L 20 20 20 DB 00
L 20 20 20 20 00
D LED8  
L 20 FE FE 20 00
L DB 20 20 DB 00
L 20 FE FE 20 00
L DB 20 20 DB 00
L 20 FE FE 20 00
D LED9  
L 20 FE FE 20 00
L DB 20 20 DB 00
L 20 FE FE 20 00
L 20 20 20 DB 00
L 20 20 20 20 00
D LEDA
L 20 FE FE 20 00
L DB 20 20 DB 00
L 20 FE FE 20 00
L DB 20 20 DB 00
L 20 20 20 20 00
D LEDB  
L 20 20 20 20 00
L DB 20 20 DB 00
L 20 FE FE 20 00
L DB 20 20 DB 00
L 20 FE FE 20 00
D LEDC  
L 20 FE FE 20 00
L DB 20 20 DB 00
L 20 20 20 20 00
L DB 20 20 DB 00
L 20 FE FE 20 00
D LEDD  
L 20 20 20 20 00
L 20 20 20 DB 00
L 20 FE FE 20 00
L DB 20 20 DB 00
L 20 FE FE 20 00
D LEDE  
L 20 FE FE 20 00
L DB 20 20 20 00
L 20 FE FE 20 00
L DB 20 20 DB 00
L 20 FE FE 20 00
D LEDF  
L 20 FE FE 20 00
L DB 20 20 20 00
L 20 FE FE 20 00
L DB 20 20 DB 00
L 20 20 20 20 00


#d 20fefe200ade2020dd0a20fefe200ade2020dd0a20fefe200a


#  20 FE FE 20 00
#  DB 20 20 DB 00
#  20 FE FE 20 00
#  DB 20 20 DB 00
#  20 FE FE 20 00