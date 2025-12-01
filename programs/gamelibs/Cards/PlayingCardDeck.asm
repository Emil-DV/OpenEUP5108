########################################
### Playing Card Deck ##################
########################################

# A═══♥  ♥♦♣♠
# ║ A ║
# ║ ♥ ║
# ♥═══A

# 2───♥  3───♦
# │ 2 │  │ 3 │
# │ ♥ │  │ ♦ │
# ♥───2  ♦───3

# ╔╤╤╤╗           ╔╤╤╤╗     ╔╤╤╤╗
# ║╘╪╛║          3───♦║     ╔╤╤╤╗
# ║╒╪╕║          │ 3 │║     ╔╤╤╤╗
# ╚╧╧╧╝          │ ♦ │╝     ╔╤╤╤╗
#                ♦───3      ║╘╪╛║
# ░░░░░                     ║╒╪╕║
# ░+#+░                     ╚╧╧╧╝
# ░+#+░
# ░░░░░

V docFullDeck     # The working ram for a deck
a 0x34            # 52 bytes
##############################################
# InitDeck - initialize the deck with sequential values
D docInitDeck
  LDR docFullDeck
  LAO
D docID.do
  SIA
  IND
  INA
  LBE 53
  MBA
  JLN docID.do
  RTL

##############################################
# ShuffleDeck - Shuffle deck
D docShuffleDeck
  CAL srand		# Seed the Random Number generator from the clock
C docSD.i 3
  LAE 52		# i (stack) = 52
  SCA
C docSD.t 2		# t (stack) 
  DES
C docSD.r 1  		# r (stack)
  DES
  
D docSD.do		# Outer loop through all the possible cards
  POE docSD.i         	# A = i
  LAM
  CAL rand		# Get random value (0..i-1)
  POE docSD.r         	# store random value in B: r = B
  SIB

  LDR docFullDeck  	# DR = &fulldeck[B]
  EDB
  LBM			# B = fulldeck[B]
  POE docSD.t		# t (stack) = B
  SIB

  POE docSD.i      	# i (stack) = fulldeck[i-1]  
  LAM
  DEA			# A-- : i--
  
  LDR docFullDeck       # A = fulldeck[i-1]
  EDA
  LAM			
  
  SIB                   # fulldeck[i-1] = B
  
  POE docSD.r       	# B = r
  LBM
  
  LDR docFullDeck	# fulldeck[B] = A
  EDB
  SIA

  POE docSD.i    	# i--
  LAM
  DEA
  SIA

  JLN docSD.do    	# while i > 0
  
  INS			# Remove locals r,t,i before return
  INS
  INS
  RTL



##############################################
# DrawCard  Draws a card at current pos A=CardNum 
D docDrawCard
C docDC.ip 1
  DES
  DES
  
  LBE docIndexSize  # B=indexsize
  CAL MulBA         # R=B*A
  LAR               # A=R
  LDR docIndex      # DR=docIndex
  EDA               # DR+=A
  LAR
  LBD
  POE docDC.ip      # Store index pointer
  SIA
  IND
  SIB
  
  LRA               # replace it
  LDB               
  LBF               # Get color byte  
  
  JLN docDC.cnz
  LDR VTBLKONWHT    # 0 = black on white
  CAL printStr1E
  JPL docDC.drawface
  
D docDC.cnz
  LAE 1
  MAB
  JLN docDC.cn1
  LDR VTREDONWHT    # 1 = red on white
  CAL printStr1E
  JPL docDC.drawface

D docDC.cn1
  LDR VTBLUEONWHT   # >1 = blue on white
  CAL printStr1E

D docDC.drawface  
  POE docDC.ip      # DR = docDC.ip
  LAM
  IND
  LBM
  LRA
  LDB
  
  IND               # Skip color byte
  
  LAF               # DR = docFace
  IND
  LBF
  LRA
  LDB
  
  CAL printStr1E    # print face

  INS
  INS
  RTL
  
##############################################  
C docIndexSize 3 
D docIndex
L 02 
W docBack
L 01 
W docAH
L 01 
W docAD
L 00 
W docAC
L 00 
W docAS

L 01 
W doc2H
L 01 
W doc2D
L 00 
W doc2C
L 00 
W doc2S

L 01 
W doc3H
L 01 
W doc3D
L 00 
W doc3C
L 00 
W doc3S

L 01 
W doc4H
L 01 
W doc4D
L 00 
W doc4C
L 00 
W doc4S

L 01 
W doc5H
L 01 
W doc5D
L 00 
W doc5C
L 00 
W doc5S

L 01 
W doc6H
L 01 
W doc6D
L 00 
W doc6C
L 00 
W doc6S

L 01 
W doc7H
L 01 
W doc7D
L 00 
W doc7C
L 00 
W doc7S

L 01 
W doc8H
L 01 
W doc8D
L 00 
W doc8C
L 00 
W doc8S

L 01 
W doc9H
L 01 
W doc9D
L 00 
W doc9C
L 00 
W doc9S

L 01 
W docTH
L 01 
W docTD
L 00 
W docTC
L 00 
W docTS

L 01 
W docJH
L 01 
W docJD
L 00 
W docJC
L 00 
W docJS

L 01 
W docQH
L 01 
W docQD
L 00 
W docQC
L 00 
W docQS

L 01 
W docKH
L 01 
W docKD
L 00 
W docKC
L 00 
W docKS
 

D docBack
# ╔  ╤  ╤  ╤  ╗  \e [  5  D  \e \e [  1  B  \e
L C9 D1 D1 D1 BB 1B 5B 35 44 1B 1B 5B 31 42 1B
# ║  ╘  ╪  ╛  ║ 
L BA D4 D8 BE BA 1B 5B 35 44 1B 1B 5B 31 42 1B
# ║  ╒  ╪  ╕  ║
L BA D5 D8 B8 BA 1B 5B 35 44 1B 1B 5B 31 42 1B
# ╚  ╧  ╧  ╧  ╝
L C8 CF CF CF BC 00
D docAH
# A  ─  ─  ─  ♥  \e [  5  D  \e \e [  1  B  \e
L 41 C4 C4 C4 03 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     A     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 41 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♥     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 03 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♥  ─  ─  ─  A  
L 03 C4 C4 C4 41 00
D docAD
# A  ─  ─  ─  ♦  \e [  5  D  \e \e [  1  B  \e
L 41 C4 C4 C4 04 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     A     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 41 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♦     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 04 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♦  ─  ─  ─  A  
L 04 C4 C4 C4 41 00
D docAC
# A  ─  ─  ─  ♣  \e [  5  D  \e \e [  1  B  \e
L 41 C4 C4 C4 05 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     A     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 41 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♣     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 05 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♣  ─  ─  ─  A  
L 05 C4 C4 C4 41 00
D docAS
# A  ─  ─  ─  ♠  \e [  5  D  \e \e [  1  B  \e
L 41 C4 C4 C4 06 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     A     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 41 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♠     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 06 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♠  ─  ─  ─  A  
L 06 C4 C4 C4 41 00

D doc2H
# 2  ─  ─  ─  ♥  \e [  5  D  \e \e [  1  B  \e
L 32 C4 C4 C4 03 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     2     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 32 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♥     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 03 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♥  ─  ─  ─  2  
L 03 C4 C4 C4 32 00
D doc2D
# 2  ─  ─  ─  ♦  \e [  5  D  \e \e [  1  B  \e
L 32 C4 C4 C4 04 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     2     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 32 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♦     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 04 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♦  ─  ─  ─  2  
L 04 C4 C4 C4 32 00
D doc2C
# 2  ─  ─  ─  ♣  \e [  5  D  \e \e [  1  B  \e
L 32 C4 C4 C4 05 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     2     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 32 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♣     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 05 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♣  ─  ─  ─  2  
L 05 C4 C4 C4 32 00
D doc2S
# 2  ─  ─  ─  ♠  \e [  5  D  \e \e [  1  B  \e
L 32 C4 C4 C4 06 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     2     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 32 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♠     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 06 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♠  ─  ─  ─  2  
L 06 C4 C4 C4 32 00

D doc3H
# 3  ─  ─  ─  ♥  \e [  5  D  \e \e [  1  B  \e
L 33 C4 C4 C4 03 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     3     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 33 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♥     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 03 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♥  ─  ─  ─  3  
L 03 C4 C4 C4 33 00
D doc3D
# 3  ─  ─  ─  ♦  \e [  5  D  \e \e [  1  B  \e
L 33 C4 C4 C4 04 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     3     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 33 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♦     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 04 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♦  ─  ─  ─  3  
L 04 C4 C4 C4 33 00
D doc3C
# 3  ─  ─  ─  ♣  \e [  5  D  \e \e [  1  B  \e
L 33 C4 C4 C4 05 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     3     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 33 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♣     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 05 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♣  ─  ─  ─  3  
L 05 C4 C4 C4 33 00
D doc3S
# 3  ─  ─  ─  ♠  \e [  5  D  \e \e [  1  B  \e
L 33 C4 C4 C4 06 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     3     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 33 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♠     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 06 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♠  ─  ─  ─  3  
L 06 C4 C4 C4 33 00

D doc4H
# 4  ─  ─  ─  ♥  \e [  5  D  \e \e [  1  B  \e
L 34 C4 C4 C4 03 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     4     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 34 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♥     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 03 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♥  ─  ─  ─  4  
L 03 C4 C4 C4 34 00
D doc4D
# 4  ─  ─  ─  ♦  \e [  5  D  \e \e [  1  B  \e
L 34 C4 C4 C4 04 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     4     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 34 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♦     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 04 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♦  ─  ─  ─  4  
L 04 C4 C4 C4 34 00
D doc4C
# 4  ─  ─  ─  ♣  \e [  5  D  \e \e [  1  B  \e
L 34 C4 C4 C4 05 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     4     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 34 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♣     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 05 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♣  ─  ─  ─  4  
L 05 C4 C4 C4 34 00
D doc4S
# 4  ─  ─  ─  ♠  \e [  5  D  \e \e [  1  B  \e
L 34 C4 C4 C4 06 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     4     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 34 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♠     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 06 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♠  ─  ─  ─  4  
L 06 C4 C4 C4 34 00

D doc5H
# 5  ─  ─  ─  ♥  \e [  5  D  \e \e [  1  B  \e
L 35 C4 C4 C4 03 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     5     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 35 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♥     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 03 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♥  ─  ─  ─  5  
L 03 C4 C4 C4 35 00
D doc5D
# 5  ─  ─  ─  ♦  \e [  5  D  \e \e [  1  B  \e
L 35 C4 C4 C4 04 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     5     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 35 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♦     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 04 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♦  ─  ─  ─  5  
L 04 C4 C4 C4 35 00
D doc5C
# 5  ─  ─  ─  ♣  \e [  5  D  \e \e [  1  B  \e
L 35 C4 C4 C4 05 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     5     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 35 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♣     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 05 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♣  ─  ─  ─  5  
L 05 C4 C4 C4 35 00
D doc5S
# 5  ─  ─  ─  ♠  \e [  5  D  \e \e [  1  B  \e
L 35 C4 C4 C4 06 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     5     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 35 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♠     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 06 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♠  ─  ─  ─  5  
L 06 C4 C4 C4 35 00

D doc6H
# 6  ─  ─  ─  ♥  \e [  5  D  \e \e [  1  B  \e
L 36 C4 C4 C4 03 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     6     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 36 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♥     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 03 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♥  ─  ─  ─  6  
L 03 C4 C4 C4 36 00
D doc6D
# 6  ─  ─  ─  ♦  \e [  5  D  \e \e [  1  B  \e
L 36 C4 C4 C4 04 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     6     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 36 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♦     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 04 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♦  ─  ─  ─  6  
L 04 C4 C4 C4 36 00
D doc6C
# 6  ─  ─  ─  ♣  \e [  5  D  \e \e [  1  B  \e
L 36 C4 C4 C4 05 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     6     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 36 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♣     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 05 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♣  ─  ─  ─  6  
L 05 C4 C4 C4 36 00
D doc6S
# 6  ─  ─  ─  ♠  \e [  5  D  \e \e [  1  B  \e
L 36 C4 C4 C4 06 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     6     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 36 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♠     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 06 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♠  ─  ─  ─  6  
L 06 C4 C4 C4 36 00

D doc7H
# 7  ─  ─  ─  ♥  \e [  5  D  \e \e [  1  B  \e
L 37 C4 C4 C4 03 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     7     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 37 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♥     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 03 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♥  ─  ─  ─  7  
L 03 C4 C4 C4 37 00
D doc7D
# 7  ─  ─  ─  ♦  \e [  5  D  \e \e [  1  B  \e
L 37 C4 C4 C4 04 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     7     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 37 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♦     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 04 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♦  ─  ─  ─  7  
L 04 C4 C4 C4 37 00
D doc7C
# 7  ─  ─  ─  ♣  \e [  5  D  \e \e [  1  B  \e
L 37 C4 C4 C4 05 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     7     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 37 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♣     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 05 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♣  ─  ─  ─  7  
L 05 C4 C4 C4 37 00
D doc7S
# 7  ─  ─  ─  ♠  \e [  5  D  \e \e [  1  B  \e
L 37 C4 C4 C4 06 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     7     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 37 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♠     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 06 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♠  ─  ─  ─  7  
L 06 C4 C4 C4 37 00

D doc8H
# 8  ─  ─  ─  ♥  \e [  5  D  \e \e [  1  B  \e
L 38 C4 C4 C4 03 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     8     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 38 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♥     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 03 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♥  ─  ─  ─  8  
L 03 C4 C4 C4 38 00
D doc8D
# 8  ─  ─  ─  ♦  \e [  5  D  \e \e [  1  B  \e
L 38 C4 C4 C4 04 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     8     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 38 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♦     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 04 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♦  ─  ─  ─  8  
L 04 C4 C4 C4 38 00
D doc8C
# 8  ─  ─  ─  ♣  \e [  5  D  \e \e [  1  B  \e
L 38 C4 C4 C4 05 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     8     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 38 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♣     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 05 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♣  ─  ─  ─  8  
L 05 C4 C4 C4 38 00
D doc8S
# 8  ─  ─  ─  ♠  \e [  5  D  \e \e [  1  B  \e
L 38 C4 C4 C4 06 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     8     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 38 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♠     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 06 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♠  ─  ─  ─  8  
L 06 C4 C4 C4 38 00

D doc9H
# 9  ─  ─  ─  ♥  \e [  5  D  \e \e [  1  B  \e
L 39 C4 C4 C4 03 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     9     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 39 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♥     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 03 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♥  ─  ─  ─  9  
L 03 C4 C4 C4 39 00
D doc9D
# 9  ─  ─  ─  ♦  \e [  5  D  \e \e [  1  B  \e
L 39 C4 C4 C4 04 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     9     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 39 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♦     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 04 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♦  ─  ─  ─  9  
L 04 C4 C4 C4 39 00
D doc9C
# 9  ─  ─  ─  ♣  \e [  5  D  \e \e [  1  B  \e
L 39 C4 C4 C4 05 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     9     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 39 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♣     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 05 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♣  ─  ─  ─  9  
L 05 C4 C4 C4 39 00
D doc9S
# 9  ─  ─  ─  ♠  \e [  5  D  \e \e [  1  B  \e
L 39 C4 C4 C4 06 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     9     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 39 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♠     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 06 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♠  ─  ─  ─  9  
L 06 C4 C4 C4 39 00

D docTH
# T  ─  ─  ─  ♥  \e [  5  D  \e \e [  1  B  \e
L 54 C4 C4 C4 03 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     T     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 54 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♥     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 03 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♥  ─  ─  ─  T  
L 03 C4 C4 C4 54 00
D docTD
# T  ─  ─  ─  ♦  \e [  5  D  \e \e [  1  B  \e
L 54 C4 C4 C4 04 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     T     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 54 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♦     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 04 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♦  ─  ─  ─  T  
L 04 C4 C4 C4 54 00
D docTC
# T  ─  ─  ─  ♣  \e [  5  D  \e \e [  1  B  \e
L 54 C4 C4 C4 05 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     T     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 54 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♣     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 05 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♣  ─  ─  ─  T  
L 05 C4 C4 C4 54 00
D docTS
# T  ─  ─  ─  ♠  \e [  5  D  \e \e [  1  B  \e
L 54 C4 C4 C4 06 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     T     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 54 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♠     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 06 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♠  ─  ─  ─  T  
L 06 C4 C4 C4 54 00

D docJH
# J  ─  ─  ─  ♥  \e [  5  D  \e \e [  1  B  \e
L 4A C4 C4 C4 03 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     J     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 4A 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♥     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 03 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♥  ─  ─  ─  J  
L 03 C4 C4 C4 4A 00
D docJD
# J  ─  ─  ─  ♦  \e [  5  D  \e \e [  1  B  \e
L 4A C4 C4 C4 04 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     J     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 4A 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♦     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 04 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♦  ─  ─  ─  J  
L 04 C4 C4 C4 4A 00
D docJC
# J  ─  ─  ─  ♣  \e [  5  D  \e \e [  1  B  \e
L 4A C4 C4 C4 05 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     J     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 4A 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♣     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 05 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♣  ─  ─  ─  J  
L 05 C4 C4 C4 4A 00
D docJS
# J  ─  ─  ─  ♠  \e [  5  D  \e \e [  1  B  \e
L 4A C4 C4 C4 06 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     J     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 4A 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♠     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 06 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♠  ─  ─  ─  J  
L 06 C4 C4 C4 4A 00

D docQH
# Q  ─  ─  ─  ♥  \e [  5  D  \e \e [  1  B  \e
L 51 C4 C4 C4 03 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     Q     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 51 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♥     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 03 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♥  ─  ─  ─  Q  
L 03 C4 C4 C4 51 00
D docQD
# Q  ─  ─  ─  ♦  \e [  5  D  \e \e [  1  B  \e
L 51 C4 C4 C4 04 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     Q     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 51 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♦     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 04 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♦  ─  ─  ─  Q  
L 04 C4 C4 C4 51 00
D docQC
# Q  ─  ─  ─  ♣  \e [  5  D  \e \e [  1  B  \e
L 51 C4 C4 C4 05 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     Q     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 51 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♣     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 05 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♣  ─  ─  ─  Q  
L 05 C4 C4 C4 51 00
D docQS
# Q  ─  ─  ─  ♠  \e [  5  D  \e \e [  1  B  \e
L 51 C4 C4 C4 06 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     Q     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 51 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♠     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 06 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♠  ─  ─  ─  Q  
L 06 C4 C4 C4 51 00

D docKH
# K  ─  ─  ─  ♥  \e [  5  D  \e \e [  1  B  \e
L 4B C4 C4 C4 03 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     K     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 4B 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♥     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 03 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♥  ─  ─  ─  K  
L 03 C4 C4 C4 4B 00
D docKD
# K  ─  ─  ─  ♦  \e [  5  D  \e \e [  1  B  \e
L 4B C4 C4 C4 04 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     K     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 4B 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♦     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 04 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♦  ─  ─  ─  K  
L 04 C4 C4 C4 4B 00
D docKC
# K  ─  ─  ─  ♣  \e [  5  D  \e \e [  1  B  \e
L 4B C4 C4 C4 05 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     K     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 4B 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♣     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 05 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♣  ─  ─  ─  K  
L 05 C4 C4 C4 4B 00
D docKS
# K  ─  ─  ─  ♠  \e [  5  D  \e \e [  1  B  \e
L 4B C4 C4 C4 06 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     K     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 4B 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# │     ♠     │  \e [  5  D  \e \e [  1  B  \e
L B3 20 06 20 B3 1B 5B 35 44 1B 1B 5B 31 42 1B
# ♠  ─  ─  ─  K  
L 06 C4 C4 C4 4B 00

