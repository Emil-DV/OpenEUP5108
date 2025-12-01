#######################################################
## EUP Invaders - EUP5108 Space Invaders clone
#######################################################

D eiBanner
S \e[10;34H\e
S ****************\e[16D\e\e[1B\e
S * EUP Invaders *\e[16D\e\e[1B\e
S ****************\0

V eiGameTick
a 1


# 6x2 Graphic Elements

C eiBulletSound 0x51
C eiBulletHitShield 0x30

D eiShield
# ▄████▄
# █▀▀▀▀█
L DC DB DB DB DB DC 00
L DB DF DF DF DF DB 00 00 00
C eiShield.size 16

#          1         2         3         4         5         6         7         8
# 123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
C eiBadGuyRowLen 0x45
C eiBadGuyRowsLen 0x8A 
D eiBadGuyRows
# «(Φ)»  «(Φ)»  «(Φ)»  «(Φ)»  «(Φ)»  «(Φ)»  «(Φ)»  «(Φ)»  «(Φ)»  «(Φ)»\0
L CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 20 20 
L CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 00
# ╘)Φ(╛  ╘)Φ(╛  ╘)Φ(╛  ╘)Φ(╛  ╘)Φ(╛  ╘)Φ(╛  ╘)Φ(╛  ╘)Φ(╛  ╘)Φ(╛  ╘)Φ(╛\0
L D4 29 E4 28 BE 20 20 D4 29 E4 28 BE 20 20 D4 29 E4 28 BE 20 20 D4 29 E4 28 BE 20 20 D4 29 E4 28 BE 20 20
L D4 29 E4 28 BE 20 20 D4 29 E4 28 BE 20 20 D4 29 E4 28 BE 20 20 D4 29 E4 28 BE 20 20 D4 29 E4 28 BE 00
D eiBadGuyRows2
# «(Φ)»  «(Φ)»  «(Φ)»  «(Φ)»  «(Φ)»  «(Φ)»  «(Φ)»  «(Φ)»  «(Φ)»  «(Φ)»\0
L CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 20 20 
L CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 20 20 CD 28 E4 29 CD 00
# ╒)Φ(╕  ╒)Φ(╕  ╒)Φ(╕  ╒)Φ(╕  ╒)Φ(╕  ╒)Φ(╕  ╒)Φ(╕  ╒)Φ(╕  ╒)Φ(╕  ╒)Φ(╕\0
L D5 29 E4 28 B8 20 20 D5 29 E4 28 B8 20 20 D5 29 E4 28 B8 20 20 D5 29 E4 28 B8 20 20 D5 29 E4 28 B8 20 20 
L D5 29 E4 28 B8 20 20 D5 29 E4 28 B8 20 20 D5 29 E4 28 B8 20 20 D5 29 E4 28 B8 20 20 D5 29 E4 28 B8 00

V eiBadGuyRowsD
a 0x45
V eiBadGuyRowsD1
a 0x45
V eiBadGuyRowsD2
a 0x45
V eiBadGuyRowsD3
a 0x45

V eiBadGuyRowEntry
a 1

D eiBadGuyRowTbl
W eiBadGuyRowsD
W eiBadGuyRowsD1
W eiBadGuyRowsD2
W eiBadGuyRowsD3


V eiBGBlockLen # default to strlen of constline
a 1
V eiBGLeft 
a 1
V eiBGRight
a 1

C eiShieldBlockLen 0x51
D eiShieldBlock
#      ████         ████         ████         ████         ████         ████      \n
#     ██████       ██████       ██████       ██████       ██████       ██████     \n
#     █    █       █    █       █    █       █    █       █    █       █    █     \0 
#L 20 20 20 20 20 DB DB DB DB 20 20 20 20 20 20 20 20 20 DB DB DB DB    
S      ____         ____         ____         ____         ____         ____      \n
S     ______       ______       ______       ______       ______       ______     \n
S     _    _       _    _       _    _       _    _       _    _       _    _     \0


V eiShieldBlockD
a 0xFF			# char eiShieldBlockD[255];



D eiBlockDegrade
# █▓▒░
L DB B2 B1 B0

D eiBullet
# °
L F8
C eiBullet1 0xF8

D eiBlasterPulse
# «∙∙
L AE F9 F9 20 00



D eiSpaceShip0
# =(Φ)=
L CD 28 E4 29 CD 00

D eiSpaceShip1
# ╘)Φ(╛
L 20 D4 29 E4 28 BE 00

D eiSpaceShip2
# ╒)Φ(╕
L 20 D5 29 E4 28 B8 00

D eiGoodGuyBlank
# <^>
S  <^> \0

D eiGoodGuy
# <ô>
L 20 3C 94 3E 20 00

D eiExplode
# \∙/
# ─ ─
# /∙\
L 5C F9 2F 
L C4 20 C4
L 2F F9 5C 00

V eiShotsFired
a 2

V eiShotsBCD
a BCDLib.strlen

V eiShotsOnTarget
a 2








