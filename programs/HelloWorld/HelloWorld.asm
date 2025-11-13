#$----
#$## HelloWorld.asm 
#$     Print "Hello World!\n" then loops:
#$      Print Prompt "EUP>"
#$      Get a string of characters into StrIn buffer
#$      Print the string that was entered.          
#$
#$     Program demos:
#$      Printing String constants, reading string from KB
#$      Use of all Assembler directives W,O,D,S,L,A,V,a,I,C
#-----------------------------------------------------------------------
W Main            # Write value of 'main' to byte 0,1 in ROM (reset vector) 
O 0008            # Set the APA to x0008 (just past vectors)

# String and other global constant data   char pStrHW[] = {"Hello World!\n\n"};
D pStrHW            # Defines pStr ar 0x0008
S Hello World!\n\0  # Writes Hello World!\n to ROM starting at current APA

D pStrHelp
S Enter a string of characters and I will echo them\n\n
S Hit F1 for help on emulator control keys\n\n
S If you have Notepad++ (windows) or gedit (linux)\n
S the emulator will use it to display\n
S source code while single stepping\n\n
S Hit ESC to exit - or close the window\n\n\0

D pPrompt         # Prompt string
S EUP>
L 00		  # Puts the value 00 (hex) into the next ROM location


# Global varibles in RAM 
A 0x100           # Set the starting address for Variables in RAM (rare)

V caStrIn         # caStrIn == 0xFFE0       char caStrIn[32];
a 0x20            # caStrIn[32]

# Start loading up code beginning with any included libs
O 0x1000	        # Set the APA to 0x0100 (start of program code)
			#   This is best done before all Constants least your 
			#   code over write them causing wonky operation
I ..\stdlibs\sys.asm    # System constants, screen top line, width, cursor char
I ..\iolibs\EUPIO.asm   # Include the EUPIO.asm file to use those functions later
I ..\stdlibs\StringLib.asm #Include the String Lib for string functions and consts
I ..\stdlibs\UtilFunctions.asm

C 'Enter 0x0A     # Defines a Constant to a numeric value ~ #define uses no
		  # memory as it only exists during assembly

# The Main function
D Main            # The location of 'void main()'

# printf("Hello World!\n\n");
  LDR pStrHW      # Load the value of 'pStrHW' into DR
  CAL printStr1E  # Call the print from ROM function

# Print the Help String
  LDR pStrHelp    # Load the value of 'pStrHelp' into DR
  CAL printStr1E  # Call the print from ROM function

# Loop getting a line of text from the kb and printing it
D GetLine&PrintIt # Loop of getting a string and printing it
  LDR pPrompt     # Print the prompt
  CAL printStr1E       

  LDR caStrIn     # Get a string and put it into caStrIn
  CAL getString
  W1E 0x0A        # Print Line Feed using the byte value
  
  LDR caStrIn     # Print the string we received
  CAL printStr1D  # call the print from RAM function
  W1E 'Enter      # Print Line Feed using the constant 'Enter
  
  JPL GetLine&PrintIt  # Loop back to the beginning
