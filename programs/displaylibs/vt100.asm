#######################################################
## VT100 Escape Codes and API
#######################################################

# All codes begin with the Escape character 0x1B
# then a string of characters to set colors 
# cursor position and other things
## VT100 Codes

C VT_ESC 0x1B
C VT_[   0x5B

C VT_CHA 0x47
C VT_CUB 0x44
C VT_CUD 0x42  

D VTCLR
S \e[2J\e\0

D VTHOME
S \e[7;1H\e\0

D VTSCRUP
S \eD\e\0

D VTSCRDWN
S \eM\e\0

D VTBIGCHARS
S \e[3m\e\0

D VTJUMBOCHARS
S \e[6m\e\0

D VTHIDECURSOR
S \e[?25l\e\0

D VTUP
S \e[1A\e\0

D VTU3
S \e[3A\e\0

D VTDWN
S \e[1B\e\0

D VTRIGHT
S \e[1C\e\0

D VTLEFT
S \e[1D\e\0

D VTUPLEFT
S \e[1A\e\e[1D\e\0

D VTCR
S \e[1H\e\0

D VTDTH
L 1B 5B 23 33 1B 00

D VTDHBH
L 1B 5B 23 34 1B 00

D VTSWSH
L 1B 5B 23 35 1B 00

D VTDWSH
L 1B 5B 23 36 1B 00

D VTREDONBLK
S \e[31;40m\e\0

D VTREDONWHT
S \e[31;47m\e\0

D VTBLUEONBLK
S \e[34;40m\e\0

D VTBLUEONWHT
S \e[34;47m\e\0

D VTBLKONWHT
S \e[30;47m\e\0

D VTPURPONBLK
S \e[35;40m\e\0

D VTYELLONBLK
S \e[33;40m\e\0

D VTREVERSE
S \e[7m\e\0

D VTRSTCOL
S \e[39;49m\e\0

D VTRST
S \e[m\e\0

D VTSETCURSORPOS 
S \e[000;000f\e\0

D VTGETCURSORPOS 
S \e[6n\e\0


V vtTEMP.str    # char vtTemp.str[20]
a 20

V vtRow.str     # char vtRow.str[4]
a 4

V vtCol.str     # char vtCol.str[4]
a 4


#######################################################
# Sets the cursor positon: A=col,B=row
D vtSetCursorPos            # void vtSetCursorPos {
C vtSetCursorPos.c 2        # c = A
  SCA
C vtSetCursorPos.r 1        # r = B
  SCB
  
  LDR VTSETCURSORPOS        # Push src on stack
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
  
  #Add 2 to vtTEMP.str to get to the row pos
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

#######################################################
# Gets the cursor positon: A=col,B=row
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

  LDR VTGETCURSORPOS        # printf(VTGETCURSORPOS);
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



















