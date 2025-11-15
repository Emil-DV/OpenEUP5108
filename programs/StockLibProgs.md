# EUP5108 Stock Library and Program information
---- 
## BootMon/BootMON-EUP5108.asm
     Boot Monitor for the EUP 5108 
     primary program for low level tests
     Testing of interrupts, reading RAM/ROM directly
     Some overlap with the EUPShell
----
## displaylibs/BoxDrawingDigits.asm
     Contains the serif digits 0..9,A..F,U, & P 
     Originally meant for the EUP Banner on BootMon
     
     Superseded by BIGLed library that will contain
     all capital letters and digits

     Defines:
     C BoxDigitSize 0x09 - Nine characters per digit
     C BoxDigitCount 0x12 - 18 Characters in total
     D BoxDigits - The packed array of box digits

----
## displaylibs/vt100.asm - VT100 Escape Codes and API

     All codes begin with the Escape character 0x1B | \e then a string of 
     characters to set colors, cursor position, and options
     All codes must end with the Escape character 0x1B | \e

     Vt100 code constants [LDR {VT*}, CAL printStr1E]
         (not all code perform as expected)
     
     VTCLR - Clear the screen
     VTHOME - Sets the cursor to the top left of the client area (row 7)
     VTSCRUP - Moves the cursor up one line (row)
     VTSCRDWN - Moves the cursor down one line (row)
     VTBIGCHARS - Turns on BIG characters
     VTJUMBOCHARS - Turns on JUMBO characters
     VTHIDECURSOR - Hides the cursor
     VTUP - move cursor up one row
     VTU3 - move cursor up three rows
     VTDWN - move cursor down one row
     VTRIGHT - move cursor one to the right
     VTLEFT - move cursor one to the left
     VTUPLEFT - move cursor up one and to the left one
     VTCR - move to top left corner of the whole screen
     VTDTH - set double height letters top half
     VTDHBH - set double height letters bottom half
     VTSWSH - set single with single height letters
     VTDWSH - set double with single height letters
     VTREDONBLK - Sets red characters on black background
     VTREDONWHT - Sets red characters on white background
     VTBLUEONBLK - Sets blue characters on black background
     VTBLUEONWHT - Sets blue characters on white background
     VTBLKONWHT - Sets black characters on white background
     VTPURPONBLK - Sets purple characters on black background
     VTYELLONBLK - Sets yellow characters on black background
     VTREVERSE - Switches foreground and background colors
     VTRSTCOL - reset foreground and background colors
     VTRST - resets to standard text formating 

     VT.SETCURSORPOS - Template for Set Cursor Pos

     VT.GETCURSORPOS - Template for Get Cursor Pos

### | vtSetCursorPos - Sets the cursor positon
     Set A=col,B=row before calling

### | vtGetCursorPos (experimental)
     Gets the cursor positon: A=col,B=row
----
## HelloWorld/HelloWorld.asm 
     Print "Hello World!\n" then loops:
      Print Prompt "EUP>"
      Get a string of characters into StrIn buffer
      Print the string that was entered.          

     Program demos:
      Printing String constants, reading string from KB
      Use of all Assembler directives W,O,D,S,L,A,V,a,I,C
----
## IntroProgs/HelloEUPWorld.asm 
     Print "Hello EUP World!\n" and halts

     Program demos:
      Printing a String constant
---- 
## iolibs/EUP5208Lib.asm
    24x32 Gaming Pixel Display and LEDS
    Used in the Gaming view of the Logisim Gaming Model

### | CheckerTest
    Fills the screen with the AA/55 checkerboard pattern

### | FillScreen 
    Fills the screen with all pixels on

### | TestLEDS
    Displays 99..00 in all of the LEDs
----
## iolibs/EUPIO.asm - I/O functions

     This assumes that Port0 is the keyboard input and Port1 is the output
     to the screen.

### | getC - reads a character from Port0 into the B register 
      if B == 0 loop
      else acks character by writing 0 to Port0 and 
      returns with character in B

### | getString - Reads characters into a string 
     if char != 'LF echos to the terminal 
     until 'LF
     Backspace deletes previous character
     Input: DR set to address of string buffer
**Warning:**

     Does not check for buffer overflow
----
## PerfTest/nops.asm
     This program does nothing except demonstrate the O assembler
     directive to put a long jump instruction near the end of ROM

     Used to show the maximum possible tick rate of the emulator
---- 
## shell/EUPShell.asm
     The EUP Shell program for testing of other
     programs via extendable menu system

     externalincludes.asm
     contains the additional program entry points
     and command map constants

     externalcmds.asm
     contains the additional command map entries
      Command string (case sensitive)
      A pointer to the function for the command
      A pointer to the Help message for the command
     
---- 
## stdlibs/BCDLib.asm
     Library of functions for Binary Coded Decimal
     Strings

     Each BCD string is limited to and expected to 
     be this BCDLib.strlen in length including null
     Example:
     V HighScoreBCD
     a BCDLib.strlen 
       LDR HighScoreBCD
       CAL BCDZro

### | BCDec (Not yet implemented)
     Decrement the BCD string by 1 using single digit math
     DR = pBCDStr

### | BCDInc
     Increment the BCD string by 1 using single digit math
     DR = pBCDStr

### | BCDZro
     Zero out the BCD string to 0 with 0x0A 
     values to mark unused leading zeros
     Call this first to initialize the BCD string
     DR = pBCDStr

### | BCDPnt
     Print the BCD String using characters
     DR=pBCDStr

### | BCDPntLED
     Print the BCD String using BIGLEDs
     DR=pBCDStr
---- 
## stdlibs/EUPStr.asm String Functions
     A collection of older string functions

### | printCharTbl
     Prints the characters 0xFE to 0
     and their hex values to the screen.
     Superseded by asciiCmd function in 
     shell/EUPShell.asm

### | printDec
     Prints the value passed in R in Decimal
     Superseded by atoi function in 
     stdlibs/StringLib.asm
## stdlibs/Math.asm 
     Math library for mul and div functions

### | Div8
     DR=Dividend (16bit), B=Divisor (8bit)
     Divides DR by B returning Quotient in A &
     Remainder in B
     Also functions as a modulus operation

### | DivBA
     Divides B by A via multiple subtraction
     returning Quotient in DR and remainder in B
     Also functions as a modulus operation

### | MulBA
     Multiplies B by A via multiple addition
     returning the product in DR
---- 
## stdlibs/StringLib.asm
     Contiains string manipulation functions
     somewhat simular to their C versions

### | strreplace
     Runs through the string pointed to by DR
     replacing characters matching A with
     the character in B

### | itoa
     Converts the value in B to a decimal string pointed
     to by DR - does not include NULL terminated

### | strlen (RAM)
     Calculates the lenth of the string pointed
     to by DR by looking for the NULL terminator

     Returns the result in A (max 255)

### | strlenc (ROM)
     Calculates the lenth of the string pointed 
     to by DR by looking for the NULL terminator

     Returns the result in A (max 255)

### | toUpperStr
     Converts all letters in the string pointed
     to by DR

     Characters 'a'..'z' becomes 'A'..'Z' others
     are left unchanged

### | toUpperB 
     Converts the letter in B to uppercase

     Characters 'a'..'z' becomes 'A'..'Z' others
     are left unchanged

### | memcpyconst 
     Copies bytes from src (ROM) to dst (RAM)
     until a null is read or the max len is reached

     Push the src pointer, dst pointer, and 
     len (max 255) onto the stack in that order 
     before calling
    

### | strcpyconst 
     Copies bytes from string (ROM) to string (RAM)
     until a null is read

     Push the src pointer, dst pointer, onto the
     stack in that order before calling

### | strcpy
     Copies bytes from string (RAM) to string (RAM)
     until a null or strcpyDelim is read

     Push the src pointer, dst pointer, onto the
     stack in that order before calling
     
     The Global strcpyDelim can be set to 0x20 (space)
     to copy the first word from the string

### | strcmpconst 
     Compares the bytes from src (ROM) to dst (RAM)
     until a null or mis-match is reached

     Push the src pointer, dst pointer, 
     onto the stack in that order before calling
    

### | repeatChar
     Prints the character in B, A times
     A = character count
     B = character to print

### | atol (experimental)
    Converts the characters in the string pointed to by DR
    into a two byte value returning it in DR
    Assumes string passed has only '0'..'9' in it
---- 
## stdlibs/UtilFunctions.asm
     As set of utility functions for various operations

### | callFNptr
     Calls the function stored in DR and returns
     Done via writes to the ROM (cludge)
     This functionality could be a better use of
     the CAS instruction

### | getRand
     Gets a random number from the 
     Special Function Port and puts it in B

### | incShort
     Add one to the 16bit value stored at DR
     i.e. (*DR)++;

### | sleep
     Delay loop where A is the number of times
     DR is decremented to 0 from 0x0FFF
     One decrement loop = 1044818 cycles
     At 20Mhz that equates to ~52ms

### | PrintASCIITbL
     Prints the ASCII table for values 0x20..0xFF

### | stackDump
     Prints out lines of stack memory
     where A = line count

### | printStr1E
     Print a string of characters to Port1 from EEPROM
     Takes advantage of the hardware increment in the SP  
     rather than adding 1 to DR each time                 

### | printStr1D
     Print a string of characters to Port1 from RAM
     Takes advantage of the hardware increment in the SP  
     rather than adding 1 to DR each time                 

### | getCharB 
     Reads a byte from port0 (stdin) into B 
     returns when B != 0 otherwise loops
     writes 0 to port0 to indicate the value has been read

### | isDigitB 
     Checks if the contents of B are >= '0' && < ':'
     A is set to 0/1 to indicates that B is|is not a digit

### | inRangeB
     Checks if the contents of B are > D &&  B <= R 
     A set to 0/1 to indicates B is|is not in range

### | isHexDigitB
     Checks if the contents of B are >= 'A' && < 'G'
     A set to 0/1 to indicates it is|is not a hex digit
     B set to hex value of digit

### | xtos
     Expects a big endian string of hex characters e.g. ABCD 
     to be on the stack along with the address of the output

### | getLine
     Gets characters from the input and puts them 
     into the string pointed to by DR
     limited to the count in A

### | printBHex
      Prints the value in B as a two character hex string

### | DumpRam
     Dumps RAM values as HEX starting at the global DumpRam_start
     limited to the number in the global DumpRam_count
     (Should really revisit this)

### | DumpRamP
     Dumps RAM values as Characters 
     starting at DR for A bytes  

### | DRamDump  
     Prints DumpLines lines of RAM starting at DumpStart  
     in the traditional table of HEX and character values
