# HelloEUPWorld.asm - Prints "Hello EUP World!\n"
#-----------------------------------------------------------------------
W main          # Write value of 'main' to byte 0,1 in ROM (reset vector) 
O 0010          # Set the APA to 0010 (just past interrupt vectors)
                # All constants and code start here

C sys.cursorChar 0x5F   #C: #define sys.cursorChar 0x5F

                # I is the same as C's #include
I ..\stdlibs\Math.asm             # Brings in the Math Functions
I ..\stdlibs\StringLib.asm	  # Brings in the String Functions
I ..\stdlibs\UtilFunctions.asm    # Brings in the Print Functions

D WelcomeStr		# Define string constant in ROM: 
                        #  C: const char WelcomeStr[] = "Hello EUP World!\n"

S Hello EUP World!\n\0  # Quotes not needed but null terminator is
                        # Special character escape sequences 
                        #  \b=8 \f=0xFF \n=10 \r=13 \t=9 \0=0 \e=27 

D main          # Define start function: C: void main()
                # Most function take parameters from the registers
                # C: printf("%s",WelcomeStr);
  LDR WelcomeStr	# Load the starting point of the string into DR
  CAL printStr1E	# Call print string from ROM to port 1

  HLT			# Stop the program




