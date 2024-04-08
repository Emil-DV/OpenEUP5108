#######################################################
## EUP Invaders - EUP5108 Space Invaders clone
#######################################################

# 6x2 Graphic Elements

C eiBulletSound 0x51

D eiShield
# ▄████▄
# █▀▀▀▀█
L DC DB DB DB DB DC 00
L DB DF DF DF DF DB 00 00 00
C eiShield.size 10

#          1         2         3         4         5         6         7         8
# 123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.

D eiShieldBlock
#      ████         ████         ████         ████         ████         ████      \n
#     ██████       ██████       ██████       ██████       ██████       ██████     \n
#     █    █       █    █       █    █       █    █       █    █       █    █     \0 
#L 20 20 20 20 20 DB DB DB DB 20 20 20 20 20 20 20 20 20 DB DB DB DB    
S      ____         ____         ____         ____         ____         ____      \n
S     ______       ______       ______       ______       ______       ______     \n
S     _    _       _    _       _    _       _    _       _    _       _    _     \0


V eiShieldBlockD
a FF



D eiBlockDegrade
# █▓▒░
L DB B2 B1 B0

D eiBullet
# °
L F8
C eiBullet1 F8

D eiBlasterPulse
# «∙∙
L AE F9 F9 20 00



D eiSpaceShip0
# «(Φ)»
L AE 28 E8 29 AF 00

D eiSpaceShip1
# ╘)Φ(╛
L 20 D4 29 E8 28 BE 00

D eiSpaceShip2
# ╒)Φ(╕
L 20 D5 29 E8 28 B8 00

D eiGoodGuyBlank
# <^>
S  <^> \0

D eiGoodGuy
# <ô>
L 20 3C 93 3E 20 00

D eiExplode
# \∙/
# ─ ─
# /∙\
L 5C F9 2F 
L C4 20 C4
L 2F F9 5C 00

V eiShotsFired
a 2

V eiShotsOnTarget
a 2








