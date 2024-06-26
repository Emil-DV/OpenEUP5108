#######################################################
## EUP Invaders - EUP5108 Space Invaders clone
#######################################################
I EUPInvadersAssets.asm
V eiInit
a 1

D EupInvadersCmd
S ei\0
D EupInvadersMsg
S ei: Start the EUP Invaders Game\0


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
  LBM
  JLN DB.notz
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
  LDR BulletRow
  LAM
  SCA
  LDR BulletCol
  LAM
  SCA

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
  
D eiML.do           # do{
  
  LAE 0x10          # A = 1 ~ 37ms
  CAL sleep         # Sleep

  CAL DrawGoodGuy     
  CAL DrawBullet
  CAL DrawShieldBlock
  
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

