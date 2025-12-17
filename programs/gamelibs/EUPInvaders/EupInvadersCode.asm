#######################################################
## EUP Invaders - EUP5108 Space Invaders clone
#######################################################
O 0x3000
A 0x1000
W eiStart

I ../../stdlibs/UtilFunctions.asm
I ../../stdlibs/StringLib.asm
I ../../displaylibs/vt100.asm
I ../../stdlibs/BCDLib.asm
I ../../displaylibs/BigLEDv2.asm
I ../../displaylibs/BoxDrawing.asm

I EupInvadersAssets.asm

V eiInit
a 1

D EupInvadersCmd
S ei\0
D EupInvadersMsg
S ei: Start the EUP Invaders Game\0

#######################################################
## eiStart - Init vars, show banner, then start
#######################################################
D eiStart
  # Init 2 byte stats to zero
  LDR eiShotsFired
  LAZ
  SIA
  IND
  SIA
  
  LDR eiShotsOnTarget
  LAZ
  SIA
  IND
  SIA

  # init game tick to zero
  LDR eiGameTick
  LAZ
  SIA

  # Copy the shield block from rom to ram
  LDR eiShieldBlock  #Push eiShieldBlock onto stack
  SCR
  SCD
  LDR eiShieldBlockD #Push eiShieldBlockD onto stack
  SCR
  SCD
  CAL strcpyconst    #Call strcopy from const
  INS # Clean up stack
  INS
  INS
  INS

  # Copy the shield block from rom to ram
  LDR eiBadGuyRows  #Push eiBadGuyRows onto stack
  SCR
  SCD
  LDR eiBadGuyRowsD #Push eiBadGuyRowsD onto stack
  SCR
  SCD
  LAE eiBadGuyRowsLen
  SCA
  CAL memcpyconst    #Call memcopy from const
  INS # Clean up stack
  INS
  INS
  INS
  INS

  LDR eiBadGuyRows2  #Push eiBadGuyRows onto stack
  SCR
  SCD
  LDR eiBadGuyRowsD2 #Push eiBadGuyRowsD onto stack
  SCR
  SCD
  LAE eiBadGuyRowsLen
  SCA
  CAL memcpyconst    #Call memcopy from const
  INS # Clean up stack
  INS
  INS
  INS
  INS

  # Clear the screen
  LDR VTCLR
  CAL printStr1E

  # Animate shields
  CAL ShieldBlockUp
  
  # draw banner
  LDR eiBanner
  CAL printStr1E
  
  # Init eiShotsBCD
  LDR eiShotsBCD
  CAL BCDZro
  
  # main game loop	
  CAL eiMainLoop
  RTL
  
  

#######################################################
## ShieldBlockUp - animates the appearance of the shields
#######################################################
D ShieldBlockUp

  CAL DrawShieldBlock
  W2E 0x10
  LDR eiShieldBlockD
  LAE '_
  LBE 0xB0
  CAL strreplace
  
  CAL DrawShieldBlock
  W2E 0x20
  LDR eiShieldBlockD
  LAE 0xB0
  LBE 0xB1
  CAL strreplace

  CAL DrawShieldBlock
  W2E 0x30
  LDR eiShieldBlockD
  LAE 0xB1
  LBE 0xB2
  CAL strreplace
  
  CAL DrawShieldBlock
  W2E 0x40
  LDR eiShieldBlockD
  LAE 0xB2
  LBE 0xDB
  CAL strreplace

  CAL DrawShieldBlock
  W2E 0x50

  RTL

#######################################################
## DrawShieldBlock
#######################################################
C ShieldBlockRow 0x16 
C ShieldBlockRowBase 0x18
D DrawShieldBlock
  LDR VTBLUEONBLK
  CAL printStr1E
  LBE ShieldBlockRow
  LAO
  CAL vtSetCursorPos
  LDR eiShieldBlockD
  CAL printStr1D 
  RTL
  
#######################################################
## DrawBullet
#######################################################
V BulletCol         # char BulletCol;
a 1
V BulletRow         # char BulletRow;
a 1

D DrawBullet
  LDR BulletRow
  LBM			# B = *BulletRow
  JLN DB.notz		# if(B) goto .notz
  JPL DB.rtl
  
D DB.notz  
  LDR BulletRow
  LBM
  LDR BulletCol
  LAM
  
  CAL vtSetCursorPos # Set position
  W1E 0x20           # Erase old bullet
  
  LDR VTUPLEFT
  CAL printStr1E
      
  LDR VTYELLONBLK
  CAL printStr1E
  
  W1E eiBullet1

  LDR BulletRow	#
  LBM		# B = *BulletRow
  DEB		# B--
  SIB		# *BulletRow = B
  JLN DB.rtl	# if(BulletRow) return
 
  LDR BulletCol
  LAM  		# A = *BulletCol
  LBT		# B = 1
  CAL vtSetCursorPos # Set position
  
  W1E 0x20           # Erase old bullet

D DB.rtl
  RTL  


#######################################################
## DrawGoodGuy
#######################################################
V GoodGuyPOS
a 1
C GoodGuyRow 0x19

D DrawGoodGuy       # void DrawGoodGuy()
  LDR GoodGuyPOS    # B = GoodGuyPOS
  LBM
  JLN DGG.cont      # if(B != 0) goto DGG.cont
  # Initialize position as center
  LAE 38            # GoodGuyPOS = 38
  SIA
D DGG.cont
  LBE GoodGuyRow    # B = GoodGuyRow
  LDR GoodGuyPOS    # A = GoodGuyPOS
  LAM
  CAL vtSetCursorPos # Set position
  LDR VTPURPONBLK
  CAL printStr1E
  LDR BulletRow
  LBM
  JLN DGG.BulletAway
  LDR eiGoodGuy
  CAL printStr1E
  RTL
D DGG.BulletAway 
  LDR eiGoodGuyBlank
  CAL printStr1E
 
  RTL
#######################################################
## MoveGoodGuyLeft
#######################################################
D MoveGoodGuyLeft     # void MoveGoodGuyLeft()
#  HLT
  NOP
  
  LDR GoodGuyPOS      # GoodGuyPOS--
  LBM
  DEB
  SIB
  
  JLN MGGL.rtl        # if(GoodGuyPOS != 0) goto MGGL.rtl
  LAO                 # GoodGuyPOS = 1
  SIA

D MGGL.rtl
  RTL
  
#######################################################
## MoveGoodGuyRight
#######################################################
D MoveGoodGuyRight    # void MoveGoodGuyRight()
  LDR GoodGuyPOS      # GoodGuyPOS++
  LAM
  INA
  SIA
  LBE 77              #
  MBA                 #
  JLN MGGR.rtl        # if(GoodGuyPOS != 76)
  LAE 76              # GoodGuyPOS = 75
  SIA
D MGGR.rtl
  RTL
#######################################################
## goBoom
#######################################################
D GoBoom
  LDR BulletRow	#
  LAM		# A = *BulletRow
  SCA		# push A
  LDR BulletCol
  LAM		# A = *BulletCol
  DEA		# A--
  SCA		# push A

  LAO
  LBA
  LDR eiExplode
  CAL DrawBox
  W2E 0x60
  W2E 0x40
  LAO
  LBA
  LDR BlankNMatrix
  CAL DrawBox
  W2E 0x70
  W2E 0x23
  
  INS
  INS

  RTL
  
  
#######################################################
## CheckForNoBoom
#  Check if the last bullet stopped inside the logo
#  Row = 2..5 Col 26..52  
#######################################################
D CheckForNoBoom

  LDR BulletRow
  LBM
  LDE 3
  LRE 6
  CAL inRangeB
  LBA
  JLN CFB.nRow
  LAO
  RTL
  
D CFB.nRow
  LDR BulletCol
  LBM
  LDE 26
  LRE 52
  CAL inRangeB
  LBA
  JLN CFB.goboom
  LAO
  RTL
D CFB.goboom  
  LAZ
  RTL

#######################################################
## CheckForShieldBoom
#  Check if the last bullet might have hit a shield
#  Row = 2..5 Col 26..52  
#######################################################
D CheckForShieldBoom	# returns A=1 of not a hit

  LDR BulletRow		#
  LBM			# B = *BulletRow
  LDE ShieldBlockRow	  # D = const ShieldBlockRow
  LRE ShieldBlockRowBase  # R = const ShieldBlocRowBase
  CAL inRangeB		# A = inRangeB();	
  LBA			# B = A - sets flags
  JLN CFSB.nRow		# if(B) goto CFSB.nRow
  LAO			# A = 1
  RTL			# Return
  
D CFSB.nRow
  LDR BulletRow		#
  LAM			# A = *BulletRow
  LBE ShieldBlockRow	# B = ShieldBlockRow
  MAB			# A -= B
  LBE eiShieldBlockLen  # B = eiShieldBlockLen
  CAL MulBA		# DR = B * A
  LBR 			# B = R 
  # do test for not zero
  LDR BulletCol		#
  LAM			# A = *BulletCol
  
  LDR eiShieldBlockD	# DR = eiShieldBlockD  
  EDB			# DR += B (for the row)
  EDA			# DR += A (for the col)
  DED			# DR-- cuz are cols start at one

  LBM 			# B = *DR (current bullet loc)
  LAE 0x20		# A = 20 [space]
  MAB			# A = A-B	
  JLN CFSB.!spc		# B != space
  RTL
  
D CFSB.!spc  
  # change the not space character
  LAE 0x20		# Load space into A
  SIA			# *DR = A
  LDR BulletRow		# set bullet row = 0
  LAZ
  SIA
  W2E eiBulletHitShield # play hit sound	
  RTL

#######################################################
## DrawBadGuys           # Draw the bad guys
#######################################################
D DrawBadGuys
C DBG.State

  LAE 7
  LBE 7
  CAL vtSetCursorPos

  LDR eiGameTick
  LBM
  LAE 0x04
  CAL DivBA		# B = eiGameTick%0x20
  JLN DBG.noInc
  LDR eiBadGuyRowEntry
  LAM
  INA
  INA
  SIA
  LBE 0x08
  MBA
  JLR DBG.Inc
  JPL DBG.noInc
D DBG.Inc
  LAZ 
  SIA
D DBG.noInc  
  LDR eiBadGuyRowEntry
  LAM
  LDR eiBadGuyRowTbl
  EDA
  LAF
  IND
  LDF
  LRA
  
  CAL printStr1D
  RTL
  
#######################################################
## eiMainLoop           # The main game loop
#######################################################
D eiMainLoop            
  
D eiML.do           # do{
  
  LAE 0x10          # A = 1 ~ 37ms
  CAL sleep         # Sleep

  LAE 44
  LBE 1
  CAL vtSetCursorPos
  LDR eiShotsBCD
  CAL BCDPnt

  CAL DrawGoodGuy     
  CAL DrawShieldBlock
  CAL DrawBadGuys
  CAL DrawBullet
  CAL CheckForShieldBoom
  
  # inc game tick
  LDR eiGameTick
  LAM
  INA
  SIA

  
  LB0               # Chk port 4 key
  
  JLN eiML.!0       # }while(B!=0);
  JPL eiML.do       # 
  
D eiML.!0           
  W0E 0             # Ack Key
  
  LAE 'a            # if(B != 'a')
  MAB               
  JLN eiML.!a       #   goto eiML.!a
  
  CAL MoveGoodGuyLeft # 'a':go left
  JPL eiML.do       # Get a key

D eiML.!a           
  LAE 'd            # if(B != 'd')
  MAB               
  JLN eiML.!d       #   goto eiML.!d

  CAL MoveGoodGuyRight # 'd':go right
  JPL eiML.do       # Get a key

D eiML.!d  
  LAE 'c            # if(B != 'c')
  MAB               
  JLN eiML.!c       #   goto eiML.!c

  LDR VTCLR
  CAL printStr1E
  JPL eiML.do

D eiML.!c  
  LAE 'q            # if(B != 'q')
  MAB               
  JLN eiML.!q       #   goto eiML.!q
  RTL

D eiML.!q
  LAE 'w            # if(B != 'w')
  MAB
  JLN eiML.!fire    #   goto eiML.!fire
  # The fire button has been pressed
  LDR eiShotsFired
  CAL incShort
  LDR eiShotsBCD
  CAL BCDInc
  
  CAL CheckForNoBoom
  LBA
  JLN eiML.!boom
  # Go boom 
  CAL GoBoom
  
  LDR eiShotsOnTarget
  CAL incShort
  
  
D eiML.!boom  
  LDR BulletRow
  LBM
  LDR BulletCol
  LAM
  CAL vtSetCursorPos
  W1E 0x20
  
  
  LDR BulletRow     # Set Bullet Row
  LAE GoodGuyRow
  SIA

  LDR GoodGuyPOS    # Set Bullet Col
  LAM               #  to Guy Position
  INA               # ++
  INA               # ++
  LDR BulletCol     
  SIA
  
  W2E eiBulletSound # Play Bullet sound

D eiML.!fire

  JPL eiML.do  

