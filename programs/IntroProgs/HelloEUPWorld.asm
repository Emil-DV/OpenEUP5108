# HelloEUPWorld.asm - Prints "Hello EUP World!\n"
#-----------------------------------------------------------------------
W main            # Write value of 'main' to byte 0,1 in ROM (reset vector) 
O 0010            # Set the APA to 0010 (just past interrupt vectors)

C sys.cursorChar 0x5F

I ..\stdlibs\Math.asm	          # Brings in the Math Functions
I ..\stdlibs\StringLib.asm	  # Brings in the String Functions
I ..\stdlibs\UtilFunctions.asm    # Brings in the Print Functions

D WelcomeStr		# Define string const: C: char WelcomeStr = "Hello EUP World!\n"
S Hello EUP World!\n\0  # Quotes not needed but null terminator is

D main			# Define start function: C: void main()
  LDR WelcomeStr	# Load the starting point of the string into DR
  CAL printStr1E	# Call the print string from ROM to port 1
  HLT			# Stop the program

