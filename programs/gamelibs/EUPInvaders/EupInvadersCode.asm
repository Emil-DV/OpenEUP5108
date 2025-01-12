#######################################################
## EUP Invaders - EUP5108 Space Invaders clone
#######################################################
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
C ShieldBlockRow 16 
C ShieldBlockRowBase 18
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

  LDR BulletRow
  LBM
  DEB
  SIB
  
D DB.rtl
  RTL  


#######################################################
## DrawGoodGuy
#######################################################
V GoodGuyPOS
a 1
C GoodGuyRow 19

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
## eiMainLoop           # The main game loop
#######################################################
D eiMainLoop            
  
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

  LDR VTCLR
  CAL printStr1E

  LDR eiShieldBlock
  SCR
  SCD
  LDR eiShieldBlockD
  SCR
  SCD
  CAL strcpyconst
  INS
  INS
  INS
  INS

  CAL ShieldBlockUp

  LDR eiBanner
  CAL printStr1E
  
D eiML.do           # do{
  
  LAE 0x10          # A = 1 ~ 37ms
  CAL sleep         # Sleep

  CAL DrawGoodGuy     
  CAL DrawShieldBlock
  CAL DrawBullet
  CAL CheckForShieldBoom
  
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

  LAE 'p     
  MAB
  JLN eiML.do
  W1E 'ESC

  JPL eiML.do  

