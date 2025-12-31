#######################################################
## Merry Christmas
#######################################################
O 0x3000	# Start at the well known
A 0x1000
W mcStart

I ../stdlibs/syscall.asm
I ../stdlibs/UtilFunctions.asm
I ../stdlibs/StringLib.asm
I ../displaylibs/vt100.asm
I ../displaylibs/BoxDrawing.asm
I ../stdlibs/rand.asm

V itr
a 1

D trunkstr
S \e[93;43m\e
# ║###║ 
L BA 23 23 23 BA 
S \e[1A\e\e[5D\e\e[m\e\0

D branchcolor
S \e[32;42m\e\0

V branchlen
a 1
V branchcol
a 1
V branchrow
a 1

V decorationcnt
a 1
V decorationcol
a 1
D decorationcolor
S \e[94;42m\e\0
D decorationfg
S \e[93m\e\0\0
S \e[94m\e\0\0
S \e[95m\e\0\0
S \e[96m\e\0\0
S \e[91m\e\0\0

D decorations
L 2A E9 A8 93 95 40 30

D thecross
S \e[93;40m\e
# ═╬═
L CD CE CD
S \e[1B\e\e[2D\e
L BA 00

D drawCross
  LAE 38
  LBE 7
  CAL vtSetCursorPos
  LDR thecross
  CAL printStr1E
  RTL


D drawDecorations
  LDR itr
  LAE 12
  SIA
  LDR decorationcolor
  CAL printStr1E

D drawDecorations.lp  
  LDR branchlen
  LAM
  DEA
  DEA
  RRA
  LBE rr2rshift
  AAB
  LDR decorationcnt
  SIA
  LDR branchcol
  LAM
  INA
  LDR decorationcol
  SIA

D drawDecorations.llp
  LDR branchlen
  LAM
  DEA
  DEA
  CAL getRandEF  
  LDR decorationcol
  LAM
  EAB
  LDR branchrow
  LBM
  DEB
  CAL vtSetCursorPos
  LAE 5
  CAL getRandEF
  TLB
  TLB
  TLB
  LDR decorationfg
  EDB
  CAL printStr1E
  LAE 7
  CAL getRandEF
  LDR decorations
  EDB
  LAF
  W1A
  LAE 5
  CAL sleep
  LDR decorationcnt
  LAM
  DEA
  SIA
  JLN drawDecorations.llp
  LDR branchrow
  LAM
  DEA
  SIA
  LDR branchcol
  LAM
  INA
  SIA
  LDR branchlen
  LAM
  DEA
  DEA
  SIA
  LDR itr
  LAM
  DEA
  SIA
  JLN drawDecorations.lp
  RTL

D drawBranches
  LDR branchcolor
  CAL printStr1E
  LDR branchlen
  LAO
  SIA
  LDR branchcol
  LAE 39
  SIA
  LDR branchrow
  LAE 9
  SIA  
  LDR itr
  LAE 14
  SIA
D drawbranches.lp
  LDR branchcol
  LAM
  LDR branchrow
  LBM
  CAL vtSetCursorPos
  LDR branchlen
  LAM
  LBE 0xDB
  CAL repeatChar
  LAE 10
  CAL sleep
  LDR branchcol
  LAM
  DEA
  SIA
  LDR branchrow
  LAM
  INA
  SIA
  LDR branchlen
  LAM
  INA
  INA
  SIA
  LDR itr
  LAM
  DEA
  SIA
  JLN drawbranches.lp
  RTL

D drawTrunk  
  LAE 37
  LBE 25
  CAL vtSetCursorPos
  LDR itr
  LAE 15
  SIA
D drawTrunk.lp  
  LDR trunkstr
  CAL printStr1E
  LAE 25
  CAL sleep
  LDR itr
  LAM
  DEA
  SIA
  JLN drawTrunk.lp
  RTL

D merrystr
S \e[92;40m\e\e[6m\e
S Merry Christmas!\0

C mcStart.pcmd 5

#############################################
D mcStart
  LDR VTRST
  CAL printStr1E
  LDR VTCLR
  CAL printStr1E
  HLT
  POE mcStart.pcmd
  LAM
  IND
  LRM
  LDA
  CAL printStr1D

  CAL seedRandEF
  CAL drawTrunk
  CAL drawBranches
  CAL drawDecorations
  CAL drawCross
  LAE 10
  CAL sleep
  LAE 32
  LBE 3
  CAL vtSetCursorPos
  LDR merrystr
  CAL printStr1E
  LDR VTRST
  CAL printStr1E
  LDR VTHOME
  CAL printStr1E
  RTL



















