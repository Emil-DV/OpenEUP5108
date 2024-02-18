# Login.asm - Print the boot banner and PIN prompt
#             Get a PIN
#             Check for correct PIN and reject all
#             IF bad PIN ask again and again
#             ELSE allow admin access and print login Okay
#-----------------------------------------------------------------------
W main            # Write value of 'main' to byte 0,1 in ROM (reset vector) 
O 0x0008          # Set the APA to x0008 (just past vectors)

# String and other global constant data
I ..\libs\BootBanner.asm  # The boot banner strings

# C: char Prompt[] = "Enter PIN:";
D Prompt         
S Enter PIN:\0

# C: char WelcomeStr[] = "\fACCESS GRANTED!\nWelcome to EUP5108 Admin Mode...\n";
D WelcomeStr
S \f
L 1B
S [91m
S ACCESS GRANTED!\n
L 1B
S [0m

S Welcome to EUP5108 Admin Mode...\n\0

# C: char PINEntered[4];
A 0xFFF0
V PINEntered
a 4

# Start loading up code beginning with any included libs
O 0x2000             # Set the APA to 0x2000 (start of program code)
I ..\libs\EUPIO.asm  # Include the EUPIO.asm file to use those functions later

# C: void main(void) {
D main
# C: printROM(BootBanner);
  LDR BootBanner3x5  # Print the boot banner and PIN prompt
  CAL printROM
# C: do {
D main.do  
# C: printROM(Prompt);
  LDR Prompt
  CAL printROM
# C: getString(PINEntered);
  LDR PINEntered
  CAL getString
  W1E 0x0A
# C: NZero = checkPIN(PINEntered); // returns with NZero flag set if PIN is not correct.
  LDR PINEntered
  CAL checkPIN
# C: } while(NZero);
  JSN main.do
  
# // PINEntered is correct so print welcome message and halt
# C: printROM(WelcomeStr);
  LDR WelcomeStr
  CAL printROM

  HLT
  RST
# C: }



# C: bool checkPIN(PINEntered){  
D checkPIN
  LBH      #For now we just set the NZero flag - all codes fail
  RTL
# C: }  
  