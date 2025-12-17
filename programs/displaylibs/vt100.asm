#$----
#$## displaylibs/vt100.asm - VT100 Escape Codes and API
#$
#$     All codes begin with the Escape character 0x1B | \e then a string of 
#$     characters to set colors, cursor position, and options
#$     All codes must end with the Escape character 0x1B | \e
#$
#$     Vt100 code constants [LDR {VT*}, CAL printStr1E]
#$         (not all code perform as expected)
#$     
I dispconsts.asm

#$     VTCLR - Clear the screen
D VTCLR
S \e[2J\e\0

#$     VTHOME - Sets the cursor to the top left of the client area (row 7)
D VTHOME
S \e[7;1H\e\0

#$     VTSCRUP - Moves the cursor up one line (row)
D VTSCRUP
S \eD\e\0

#$     VTSCRDWN - Moves the cursor down one line (row)
D VTSCRDWN
S \eM\e\0

#$     VTBLDCHARS - Turns on Bold characters
D VTBLDCHARS
S \e[1m\e\0

#$     VTBOFFCHARS - Turns off Bold characters
D VTBOFFCHARS
S \e[22m\e\0


#$     VTITACHARS - Turns on Italic characters
D VTITACHARS
S \e[3m\e\0

#$     VTITOFFCHARS - Turns off Italic characters
D VTITOFFCHARS
S \e[23m\e\0

#$     VTBLINKCHARS - Turns on Blinking characters
D VTBLINKCHARS
S \e[6m\e\0

#$     VTBLOFFCHARS - Turns off Blinking characters
D VTBLOFFCHARS
S \e[25m\e\0


#$     VTHIDECURSOR - Hides the cursor
D VTHIDECURSOR
S \e[?25l\e\0

#$     VTUP - move cursor up one row
D VTUP
S \e[1A\e\0

#$     VTU3 - move cursor up three rows
D VTU3
S \e[3A\e\0

#$     VTDWN - move cursor down one row
D VTDWN
S \e[1B\e\0

#$     VTRIGHT - move cursor one to the right
D VTRIGHT
S \e[1C\e\0

#$     VTLEFT - move cursor one to the left
D VTLEFT
S \e[1D\e\0

#$     VTUPLEFT - move cursor up one and to the left one
D VTUPLEFT
S \e[1A\e\e[1D\e\0

#$     VTCR - move to top left corner of the whole screen
D VTCR
S \e[1H\e\0

#$     VTREDONBLK - Sets red characters on black background
D VTREDONBLK
S \e[31;40m\e\0

#$     VTREDONWHT - Sets red characters on white background
D VTREDONWHT
S \e[31;47m\e\0

#$     VTBLUEONBLK - Sets blue characters on black background
D VTBLUEONBLK
S \e[34;40m\e\0

#$     VTBLUEONWHT - Sets blue characters on white background
D VTBLUEONWHT
S \e[34;47m\e\0

#$     VTBLKONWHT - Sets black characters on white background
D VTBLKONWHT
S \e[30;47m\e\0

#$     VTWHTONBLK - Sets white characters on black background
D VTWHTONBLK
S \e[37;40m\e\0

#$     VTPURPONBLK - Sets purple characters on black background
D VTPURPONBLK
S \e[35;40m\e\0

#$     VTYELLONBLK - Sets yellow characters on black background
D VTYELLONBLK
S \e[33;40m\e\0

#$     VTREVERSE - Switches foreground and background colors
D VTREVERSE
S \e[7m\e\0

#$     VTRSTCOL - reset foreground and background colors
D VTRSTCOL
S \e[39;49m\e\0

#$     VTRST - resets to standard text formating 
D VTRST
S \e[m\e\0

#$
#$     VT.SETCURSORPOS - Template for Set Cursor Pos
D VT.SETCURSORPOS 
S \e[000;000f\e\0
#$
#$     VT.GETCURSORPOS - Template for Get Cursor Pos
D VT.GETCURSORPOS 
S \e[6n\e\0

V vtTEMP.str    # char vtTemp.str[32]
a 0x20

V vtRow.str     # char vtRow.str[4]
a 4

V vtCol.str     # char vtCol.str[4]
a 4

#$
#$### | vtSetCursorPos - Sets the cursor positon
#$     Set A=col,B=row before calling
D vtSetCursorPos            # void vtSetCursorPos {
C vtSetCursorPos.c 2        # c = A
  SCA
C vtSetCursorPos.r 1        # r = B
  SCB
  
  LDR VT.SETCURSORPOS        # Push src on stack
  SCR
  SCD
  LDR vtTEMP.str            # Push dst on stack
  SCR
  SCD
  CAL strcpyconst
  INS
  INS
  INS
  INS
  
  # Load the r value
  POE vtSetCursorPos.r
  LBM
  LTE sys.topline       # Add the top row so I don't have to
  EBT
  
  #Add 2 to vtTEMP.str to get to the row pos
  LDR vtTEMP.str
  LTE 2
  EDT
  CAL itoa 
 
  # Load the c value
  POE vtSetCursorPos.c
  LBM
  
  #Add 6 to vtTEMP.str to get to the col pos
  LDR vtTEMP.str
  LTE 6
  EDT
  CAL itoa 
  
  LDR vtTEMP.str
  CAL printStr1D
  
  INS
  INS
  RTL

D spacestr
L 20 20 20 00

#$
#$### | vtGetCursorPos (experimental)
#$     Gets the cursor positon: A=col,B=row
D vtGetCursorPos            # void vtGetCursorPos(){

  HLT
  NOP
  
  LDR spacestr
  SCR
  SCD
  LDR vtRow.str
  SCR
  SCD
  CAL strcpyconst
  INS
  INS
  LDR vtCol.str
  SCR
  SCD
  CAL strcpyconst
  INS
  INS
  INS
  INS

  LDR VT.GETCURSORPOS        # printf(VTGETCURSORPOS);
  CAL printStr1E
  # Terminal should return
  # \e[n;mR
  LDR vtRow.str             # DR = vtTEMP.str;
  LAE 3
  EDA
  CAL getCharB              # Throw away [            
D vtGetCursorPos.w          # while(getChar != "R")
  CAL getCharB              
  LAE 'R
  MAB
  JLN vtGetCursorPos.gm
  # Got R so that is the end
  DED
  LAZ
  SIA
  
  HLT
  NOP
  
  # convert n & m and put them in A & B
  # for now print the return
  LDR vtRow.str
  CAL printStr1D
  W1E 'LF
  LDR vtCol.str
  CAL printStr1D
  W1E 'LF
  
  RTL

D vtGetCursorPos.gm
  LAE ';
  MAB
  JLN vtGetCursorPos.nsc
  LDR vtCol.str
  LAE 3
  EDA
  JPL vtGetCursorPos.w
  
D vtGetCursorPos.nsc  
  SIB
  DED
  JPL vtGetCursorPos.w

