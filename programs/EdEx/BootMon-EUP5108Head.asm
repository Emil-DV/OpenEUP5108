v3.0 hex words addressed
##    00 02  02 03  04 05  06 07
##    Vector Table - *Little Endian*
##    main  irq() iq1() iq2()
0000: 00 01 50 00 00 00 00 00

## Prompt User for command
  |pu LDR Prompt
0008: 76 F0 1F
      CAL PrintStr1(DR)
000B: 96 00 0F 
      CAL B=getChar()
000E: 96 10 10
      W1B Port1=B
0011: D4 
      W1E Port1=0D
0012: D1 0D 

## Check if what was entered is a digit
      CAL isDigitB
0014: 96 20 10       
      JSN if(B) goto |id
0017: 82 2A    
  
# Character out of range
      W1E Port1 = '?
0024: D1 '?
      W1E Port1 = 0
0026: D2 00
      JPS goto |pu
0028: 80 08

## Character entered is >= '0' and <= '9'
## Write it out to the screen and get the next
  |id W1B Port1 = B 
002A: D4
      W1E Port1 = 0
002B: D2 00
      JPS goto |pu
002D: 80 08

## getLine(linebuf) test
  |pu W1E
002E: D1 '!      

## Prompt User for line
      LDR Prompt
0030: 76 F0 1F
      CAL PrintStr1E(DR)
0033: 96 00 0F 
      LDR DR=linebuf
0036: 76 00 01      
      CAL getLine(linebuf)
0039: 96 30 10
      W1E ack the line with a CR
003C: D1 0D
## Echo the line back to the user      
      LDR DR=linebuf
003E: 76 00 01    
      CAL PrintStr1D(DR)
0041: 96 10 0F 
      W1E Add a CR
0044: D1 0D
      JPS |pu
0046: 80 2E           
      
##    IRQh
      IQM Mask IRQs
0050: 55
      W1E Print "!nul"
0051: D1 '! D1 00
      LAO A=FF
0055: EB
  |pa W1E '[ '] 00
0056: D1 '[ D1 '] D1 00
      DEA A--
005C: B8
      JSN if(A) goto |pa
005D: 82 56
      IQU UnMask IRQs
005F: 44
      RTI Return from IRQ
0060: 95
