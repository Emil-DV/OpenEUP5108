#-----------------------------------------------------------------------
W main            # Write value of 'main' to byte 0,1 in ROM (reset vector) 
O 0x0010          # Set the APA to x0008 (just past vectors)

O 0x0100
D HexTbl
S 0123456789ABCDEF

I .\libs\VTCodes.asm     # The VT100 codes for character position, color, etc.
I .\libs\EUPStr.asm
I .\libs\Math.asm
I .\libs\EUPIO.asm
I .\libs\BigLED.asm

# char TestIt;
V TestIt
a 1

# char LEDPos[8];
V LEDPos
a 8

# char LEDValsL[4];
V LEDValsL
a 4

# char LEDVarsR[4];
V LEDValsR
a 4


O 0x0400
D main
  # TestIt = 0xFF;
  LDR TestIt
  LAE 0xFF
  SIA

D main.do  
  # printf("%03d",TestIt);
  LRA                     # Value is loaded into Reg R (lower half of DR)
  CAL printDec            # Prints R as a decimal value
  W1E 0x20
  
  # TestIt--;
  LDR TestIt
  LAM
  DEA
  SIA
  
  # while(A != 0);
  JSN main.do 
  
  # printf("%03d",TestIt);
  LRA
  CAL printDec
  HLT
 
  CAL printCharTbl
   
  HLT
   
   
   
#  # LEDPos[0] = 10;
#  LDR LEDPos
#  LAE 0x0A
#  SIA 
#  
#  # LEDValsL[0] = 0;
#  LDR LEDValsL
#  LAE 0x00
#  SIA
#  
#  LDR LEDValsL
#  LAM
#  
#  CAL printLED
#  
#  HLT
  