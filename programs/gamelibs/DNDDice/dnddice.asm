#$ ## EUP Loadable binary header
#$ # Builds a binary file that can be loaded by the shell
#$
#$ # use "exe" as the second option to EUPASM
#$ e.g. EUPASM EUPexe.asm exe
#$ Resulting EUPexe.bin will be trimmed to the final size

# Shell data - loadable binaries must not stomp
# on the shell ROM or RAM
# Max ROM address: 0x2D10
# Max RAM address: 0x08E5
C EUPROMBASE 0x3000
C EUPRAMBASE 0x1000
O 0x3000  # Set the ROM Origin 
A 0x1000  # Set the RAM Origin
W dnddicemain    # Write the location of this EUP's main

# For now all functionality needed by the EUP exe
# will have to be included - Future versions will
# be able to get entry points from the shell
I ..\..\stdlibs\StringLib.asm
I ..\..\stdlibs\UtilFunctions.asm
I ..\..\stdlibs\BCDLib.asm
I ..\..\stdlibs\syscall.asm
I ..\..\stdlibs\time.asm
I ..\..\stdlibs\rand.asm
I ..\..\stdlibs\stdio.asm
I ..\..\displaylibs\vt100.asm
I ..\..\displaylibs\BigLED.asm
I ..\..\displaylibs\BoxDrawing.asm

D colortable
W VTREDONBLK
W VTREDONBLK
W VTGREENONBLK
W VTBLUEONBLK
W VTPURPONBLK
W VTYELLONBLK
W VTCYANONBLK
C colortable.cnt 5
V nxtColor
a 1




C bannermsg.row 7
C bannermsg.col 1
D bannermsg
S           Welcome to the EUP5108 Long Term Stress Test - Live Stream\n\n
S       This is a test to see how long the EUP5108 Emulator can run w/o error\n\n
S     During this test I will be "rolling" a set of DnD dice every 15 seconds\n\n
S     Twice an hour the pseudo random number generator will be re-seeded with\n
S                   truly random numbers from random.org\0

C nextroll.col 13
# same row as nextrollstr.row
V nextroll
a 1
V nextrollval
a 4

C nextrollstr.row 22
C nextrollstr.col 3
D nextrollstr
S Next Roll    seconds\0

C rollnumbcd.col 66 
# same row as nextrollstr.row
V rollnumbcd
a 8
C rollnumstr.col 60
# same row as nextrollstr.row
D rollnumstr
S Roll:\0 

C likesublinestr.row 23
C likesublinestr.col 27
D likesublinestr
S LIKE/SUB/Follow - It's FREE!\0

C uptimebcd.col 11
C uptimebcd.row 25
V uptimebcd
a 8

C uptimestr.col 3
# same row as uptimebcd.row
D uptimestr
S Uptime: \0

C seednumbcd.col 38
# same row as uptimebcd.row
V seednumbcd
a 8

C seednumstr.col 32
# same row as uptimebcd.row
D seednumstr
S Seed: \0

C reseedrolls.col 70
# same row as uptimebcd.row
V reseedrolls
a 1

C reseedstr.col 60
# same row as uptimebcd.row
D reseedstr
S Reseed in     rolls\0

D pickColor
  LDR nxtColor
  LBM
  TLB 
  LDR colortable
  EDB
  LAF
  IND
  LDF
  LRA
  CAL printStr1E
  LDR nxtColor
  LAM
  DEA
  SIA
  JLN pickColor.x
  LDR nxtColor
  LAE colortable.cnt
  SIA
D pickColor.x  
  RTL

D clrScreen
  LDR VTCLR
  CAL printStr1E  
  LDR VTHOME
  CAL printStr1E
  LDR VTWHTONBLK
  CAL printStr1E
  RTL

D drawscreen
  LAE bannermsg.col
  LBE bannermsg.row
  CAL vtSetCursorPos
  LDR bannermsg
  CAL printStr1E

  LAE nextrollstr.col
  LBE nextrollstr.row
  CAL vtSetCursorPos
  LDR nextrollstr
  CAL printStr1E
  
  LAE rollnumstr.col
  LBE nextrollstr.row
  CAL vtSetCursorPos
  LDR rollnumstr
  CAL printStr1E
  
  LAE likesublinestr.col
  LBE likesublinestr.row
  CAL vtSetCursorPos
  LDR likesublinestr
  CAL printStr1E
  
  LAE uptimestr.col
  LBE uptimebcd.row
  CAL vtSetCursorPos
  LDR uptimestr
  CAL printStr1E  
  
  LAE seednumstr.col
  LBE uptimebcd.row
  CAL vtSetCursorPos
  LDR seednumstr
  CAL printStr1E  
  
  LAE reseedstr.col
  LBE uptimebcd.row
  CAL vtSetCursorPos
  LDR reseedstr
  CAL printStr1E  
  
  RTL
  
D initreseedrolls
  LDR reseedrolls
  LAE 119
  SIA
  RTL  
  
D doRoll
  LDR rollnumbcd
  CAL BCDInc
  LAE rollnumbcd.col
  LBE nextrollstr.row
  CAL vtSetCursorPos
  LDR rollnumbcd
  CAL BCDPnt
  LDR reseedrolls
  LBM
  LDR nextrollval
  CAL itoa
  LAE reseedrolls.col 
  LBE uptimebcd.row
  CAL vtSetCursorPos
  LDR nextrollval
  CAL printStr1D
  CAL pickColor
  # do the dice rolling
  CAL rollD4
  CAL rollD6
  CAL rollD8
  CAL rollD10
  CAL rollD12  
  CAL rollD20
  CAL rollD100
  LDR VTGREENONBLK
  CAL printStr1E

  LDR reseedrolls
  LAM 
  DEA
  SIA
  JLN doRoll.ny
  # cal reseedfunc
  CAL seedRandEF	#todo: replace with reading from file
  CAL initreseedrolls
  LAE seednumbcd.col
  LBE uptimebcd.row
  CAL vtSetCursorPos
  LDR seednumbcd
  CAL BCDInc
  LDR seednumbcd
  CAL BCDPnt
D doRoll.ny  
  RTL

D initNextRoll
  LDR nextrollval
  IND
  IND
  IND
  LAZ
  SIA
  LDR nextroll
  LAE 15
  SIA
  RTL
  
D nextRollcheck
  LDR nextroll
  LAM
  DEA
  SIA
  LDR nextroll
  LBM
  LDR nextrollval
  CAL itoa
  LAE nextroll.col
  LBE nextrollstr.row
  CAL vtSetCursorPos
  LDR nextrollval
  IND
  CAL printStr1D
  LDR nextroll
  LBM
  JLN nextRollcheck.ny
  CAL doRoll
  CAL initNextRoll
D nextRollcheck.ny  
  RTL  
  


D dndsleep
  LAE 0x07
  CAL sleep  
  RTL

V prevsec
a 1

D inituptime
  LDR uptimebcd
  CAL BCDZro
  LDR RTCTrigger
  LAE 2
  SIA
  LDR RTCmSec
  DED
  DED
  LAM
  LDR prevsec
  SIA
  RTL

  
D updateuptime
  LDR RTCTrigger
  LAE 2
  SIA
  LDR RTCmSec
  DED
  DED
  LAM
  LDR prevsec
  LBM
  MBA
  JLN updateuptime.c
  RTL
  
D updateuptime.c
  LDR prevsec
  SIA
  LDR uptimebcd
  CAL BCDInc
  LAE uptimebcd.col
  LBE uptimebcd.row
  CAL vtSetCursorPos   
  LDR uptimebcd
  CAL BCDPnt
  
  # check on next roll
  CAL nextRollcheck
  RTL   

C dieboxes.row 16
C D4.col 3
C D6.col 11
C D8.col 19
C D10.col 29
C D12.col 41
C D20.col 53
C D100.col 66
D Dielbls
S D4\e[6C\e
S D6\e[6C\e
S D8\e[10C\e
S D10\e[9C\e
S D12\e[9C\e
S D20\e[12C\e
S D-%\0

D rollD4
  LAE 4
  SCA
D rollD4.l  
  LAE 10
  CAL sleep
  LAE D4.col
  INA
  LBE dieboxes.row
  INB
  CAL vtSetCursorPos
  LAE 4
  CAL getRandEF
  INB
  LAB
  CAL printLED
  POE 1
  LAM
  DEA
  SIA
  JLN rollD4.l
  INS
  RTL

D rollD6
  LAE 6
  SCA
D rollD6.l  
  LAE 10
  CAL sleep
  LAE D6.col
  INA
  LBE dieboxes.row
  INB
  CAL vtSetCursorPos
  LAE 6
  CAL getRandEF
  INB
  LAB
  CAL printLED
  POE 1
  LAM
  DEA
  SIA
  JLN rollD6.l
  INS
  RTL
  
D rollD8
  LAE 8
  SCA
D rollD8.l  
  LAE 5
  CAL sleep
  LAE D8.col
  INA
  LBE dieboxes.row
  INB
  CAL vtSetCursorPos
  LAE 8
  CAL getRandEF
  INB
  LAB
  CAL printLED
  POE 1
  LAM
  DEA
  SIA
  JLN rollD8.l
  INS
  RTL  


D rollD10
  LAE 10
  SCA
D rollD10.l  
  LAE 5
  CAL sleep
  LAE D10.col
  INA
  LBE dieboxes.row
  INB
  CAL vtSetCursorPos
  LAE 10
  CAL getRandEF
  INB
  LDR nextrollval
  CAL itoa
  LDR nextrollval
  IND
  LAM
  CAL printLED
  LAE D10.col
  LBE 5
  EAB
  LBE dieboxes.row
  INB
  CAL vtSetCursorPos
  LDR nextrollval
  IND
  IND
  LAM
  CAL printLED
  
  POE 1
  LAM
  DEA
  SIA
  JLN rollD10.l
  INS
  RTL  

D rollD12
  LAE 12
  SCA
D rollD12.l  
  LAE 5
  CAL sleep
  LAE D12.col
  INA
  LBE dieboxes.row
  INB
  CAL vtSetCursorPos
  LAE 10
  CAL getRandEF
  INB
  LDR nextrollval
  CAL itoa
  LDR nextrollval
  IND
  LAM
  CAL printLED
  LAE D12.col
  LBE 5
  EAB
  LBE dieboxes.row
  INB
  CAL vtSetCursorPos
  LDR nextrollval
  IND
  IND
  LAM
  CAL printLED
  
  POE 1
  LAM
  DEA
  SIA
  JLN rollD12.l
  INS
  RTL  

D rollD20
  LAE 20
  SCA
D rollD20.l  
  LAE 5
  CAL sleep
  LAE D20.col
  INA
  LBE dieboxes.row
  INB
  CAL vtSetCursorPos
  LAE 20
  CAL getRandEF
  INB
  LDR nextrollval
  CAL itoa
  LDR nextrollval
  IND
  LAM
  CAL printLED
  LAE D20.col
  LBE 5
  EAB
  LBE dieboxes.row
  INB
  CAL vtSetCursorPos
  LDR nextrollval
  IND
  IND
  LAM
  CAL printLED
  
  POE 1
  LAM
  DEA
  SIA
  JLN rollD20.l
  INS
  RTL  

D rollD100
  LAE 100
  SCA
D rollD100.l  
  LAE 1
  CAL sleep
  LAE D100.col
  INA
  LBE dieboxes.row
  INB
  CAL vtSetCursorPos
  LAE 100
  CAL getRandEF
  INB
  LDR nextrollval
  CAL itoa
  LDR nextrollval
  LAM
  CAL printLED
  LAE D100.col
  LBE 5
  EAB
  LBE dieboxes.row
  INB
  CAL vtSetCursorPos
  LDR nextrollval
  IND
  LAM
  CAL printLED
  LAE D100.col
  LBE 9
  EAB
  LBE dieboxes.row
  INB
  CAL vtSetCursorPos
  LDR nextrollval
  IND
  IND
  LAM
  CAL printLED
 
  POE 1
  LAM
  DEA
  SIA
  JLN rollD100.l
  INS
  RTL  



D drawdieboxes
  LAE dieboxes.row
  SCA
  LAE D4.col
  SCA
  LAE 3
  LBE 3
  LDR SNGLineMatrix
  CAL DrawBox  
  INS
  LAE D6.col
  SCA
  LAE 3
  LBE 3
  LDR SNGLineMatrix
  CAL DrawBox  
  INS
  LAE D8.col
  SCA
  LAE 3
  LBE 3
  LDR SNGLineMatrix
  CAL DrawBox  
  INS
  LAE D10.col
  SCA
  LAE 7
  LBE 3
  LDR SNGLineMatrix
  CAL DrawBox  
  INS
  LAE D12.col
  SCA
  LAE 7
  LBE 3
  LDR SNGLineMatrix
  CAL DrawBox  
  INS
  LAE D20.col
  SCA
  LAE 7
  LBE 3
  LDR SNGLineMatrix
  CAL DrawBox  
  INS
  LAE D100.col
  SCA
  LAE 11
  LBE 3
  LDR SNGLineMatrix
  CAL DrawBox  
  INS
  INS
  
  LBE dieboxes.row
  LAE D4.col
  INA
  CAL vtSetCursorPos
  LDR Dielbls
  CAL printStr1E
  RTL



D dnddicemain
  CAL seedRandEF
  LDR nxtColor
  LAE colortable.cnt
  SIA
  CAL clrScreen
  CAL drawscreen
  CAL inituptime
  LDR nextroll
  LAE 1
  SIA
  LDR RTCZone
  LAE 2
  SIA
  LDR rollnumbcd
  CAL BCDZro
  LDR seednumbcd
  CAL BCDZro
  LDR reseedrolls
  LAE 1
  SIA
  CAL drawdieboxes
D dnddicemain.loop
  CAL dndsleep
  
  LDR VTBLUEONBLK
  CAL printStr1E
  CAL bigtimeDate

  LDR VTREDONBLK
  CAL printStr1E
  CAL bigtimeColons
  CAL bigtimetime
  
  LDR VTGREENONBLK
  CAL printStr1E
  CAL bigtimeGMT
  



  CAL updateuptime
  JPL dnddicemain.loop
  

  RTL
  
