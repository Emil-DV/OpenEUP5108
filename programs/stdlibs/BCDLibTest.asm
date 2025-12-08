# Test function for the BCD code
D BCDTestCmd
S bcd\0

D BCDtestHelp
S bcd: Creates a BCD number and increments it as fast as possible\0

# testBCD Creates a BCD number and increments it as fast as possible 
D testBCD

V testBCD.bcd		# The BCD variable
a BCDLib.strlen

  LDR testBCD.bcd
  CAL BCDZro
  
  LDR VTCLR
  CAL printStr1E

D testBCD.gohere  	# do{
  W0E 0x00
  LDR VTHOME		# put the cursor at the top left
  CAL printStr1E

  LDR testBCD.bcd	# Print the BCD value
#  CAL BCDPnt		#	as characters
  CAL BCDPntLED 	# 	as BIGLEDs

  LDR testBCD.bcd	# testBCD.bcd++;
  CAL BCDInc
  
  LB0
  LAE 'q
  MBA
  JLN testBCD.gohere    # }while(B == 0);
  W0E 0x00
  RTL
#########################################################################
