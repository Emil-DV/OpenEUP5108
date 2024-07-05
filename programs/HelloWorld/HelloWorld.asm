# HelloWorld.asm - Print "Hello World!\n" then loop:
#                  Print Prompt "EUP>"
#                  Get a string of characters into StrIn buffer
#                  Print the string that was entered.          
#-----------------------------------------------------------------------
W Main            # Write value of 'main' to byte 0,1 in ROM (reset vector) 
O 0x0008          # Set the APA to x0008 (just past vectors)

# String and other global constant data   char pStrHW[] = {"Hello World!\n\n"};
D pStrHW          # Defines pStr as x0008
S Hello World!\n  # Writes Hello World! to ROM starting at current APA
L 0A 00           # Write \n and 00 (null to end the string)

D pStrHelp
S Enter a string of characters and I will echo them\n\n
S Hit F1 for help on emulator control keys\n\n
S If you have Notepad++ the emulator will use it to display\nsource code while single stepping\n\n
S Hit ESC x2 to exit - or close window\n\n\0

D pPrompt         # Prompt string
S EUP>
L 00


# Global varibles in RAM 
A 0xFFE0          # Set the starting address for Variables

V caStrIn         # caStrIn == 0xFFE0       char caStrIn[32];
a 0x20            # caStrIn[32]

# Start loading up code beginning with any included libs
O 0x0100          # Set the APA to 0x0100 (start of program code)
I ..\iolibs\EUPIO.asm  # Include the EUPIO.asm file to use those functions later

# The Main function
D Main            # The location of 'void main()'

# printf("Hello World!\n\n");
  LDR pStrHW      # Load the value of 'pStrHW' into DR
  CAL printROM    # Call the print ROM function

  HLT
  
# Print the Help String
  LDR pStrHelp    # Load the value of 'pStrHelp' into DR
  CAL printROM    # Call the print ROM function

# Loop getting a line of text from the kb and printing it
D GetLine&PrintIt # Loop of getting a string and printing it
  LDR pPrompt     # Print the prompt
  CAL printROM       
  
  LDR caStrIn     # Get a string and put it into caStrIn
  CAL getString
  W1E 0x0A        # Print cr
  
  LDR caStrIn     # Print the string we received
  CAL printRAM
  W1E 0x0A        # Print cr
  
  JPS GetLine&PrintIt  # Loop back to the beginning
