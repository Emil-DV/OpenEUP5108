# EUP5108 Stock Library and Program information
----
## displaylibs/BoxDrawingDigits.asm
     Contains the serif digits 0..9,A..F,U, & P 
     Originally meant for the EUP Banner on BootMon
     Superseded by BIGLed library

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

     VTCLR - Clear the screen
     VTHOME - Sets the cursor to the top left 
     VTSCRUP - Moves the cursor up one line (row)
     VTSCRDWN - Moves the cursor down one line (row)
     VTBIGCHARS - Turns on BIG characters
     VTJUMBOCHARS - Turns on JUMBO characters
     VTHIDECURSOR - Hides the cursor
     VTREDONBLK - Sets red characters on black background
     VTREDONWHT - Sets red characters on white background
     VTBLUEONBLK - Sets blue characters on black background
     VTBLUEONWHT - Sets blue characters on white background
     VTBLKONWHT - Sets black characters on white background
     VTPURPONBLK - Sets purple characters on black background
     VTYELLONBLK - Sets yellow characters on black background
     VTREVERSE - Switches foreground and background colors

     VT.SETCURSORPOS - Template for Set Cursor Pos

     VT.GETCURSORPOS - Template for Get Cursor Pos

### vtSetCursorPos - Sets the cursor positon: A=col,B=row

### vtGetCursorPos (experimental) - Gets the cursor positon: A=col,B=row
----
## iolibs/EUPIO.asm - I/O functions

     This assumes that Port0 is the keyboard input and Port1 is the output
     to the screen.

### getC - reads a character from Port0 into the B register 
      if B == 0 loop
      else acks character by writing 0 to Port0 and 
      returns with character in B

### getString - Reads characters into a string 
     if char != 'LF echos to the terminal 
     until 'LF
     Backspace deletes previous character
     Input: DR set to address of string buffer
**Warning:** does not check for buffer overflow
----
## HelloWorld.asm 
     Print "Hello World!\n" then loops:
      Print Prompt "EUP>"
      Get a string of characters into StrIn buffer
      Print the string that was entered.          

**Program demos:**

      Printing String constants, reading string from KB
      Use of all Assembler directives W,O,D,S,L,A,V,a,I,C
