#$----
#$## displaylibs/BoxDrawingDigits.asm
#$     Contains the serif digits 0..9,A..F,U, & P 
#$     Originally meant for the EUP Banner on BootMon
#$     
#$     Superseded by BIGLed library that will contain
#$     all capital letters and digits
#$
#$     Defines:
#$     C BoxDigitSize 0x09 - Nine characters per digit
#$     C BoxDigitCount 0x12 - 18 Characters in total
#$     D BoxDigits - The packed array of box digits
#$
#######################################################
C BoxDigitSize 0x09
C BoxDigitCount 0x12
D BoxDigits
# ╔═╗
L C9 CD BB 
# ║ ║
L BA 2F BA 
# ╚═╝
L C8 CD BC 

# BoxDigit1
#  ╖
L 20 B7 20 
#  ║
L 20 BA 20 
# ╘╩╛
L D4 CA BE 

# BoxDigit2
# ╒═╗
L D5 CD BB 
# ╔═╝
L C9 CD BC 
# ╚═╛
L C8 CD BE 

# BoxDigit3
# ╒═╗
L D5 CD BB 
#  ╞╣
L 20 C6 B9 
# ╘═╝
L D4 CD BC 

# BoxDigit4
# ╓ ╖
L D6 20 B7 
# ╚═╣
L C8 CD B9 
#   ╨
L 20 20 D0 

# BoxDigit5
# ╔═╕
L C9 CD B8 
# ╚═╗
L C8 CD BB 
# ╘═╝
L D4 CD BC 

# BoxDigit6
# ╔═╕
L C9 CD B8 
# ╠═╗
L CC CD BB 
# ╚═╝
L C8 CD BC 

# BoxDigit7
# ╒═╗
L D5 CD BB 
#   ║
L 20 20 BA 
#   ╨
L 20 20 D0 

# BoxDigit8
# ╔═╗
L C9 CD BB 
# ╠═╣
L CC CD B9 
# ╚═╝
L C8 CD BC 

# BoxDigit9
# ╔═╗
L C9 CD BB 
# ╚═╣
L C8 CD B9 
#   ╨
L 20 20 D0 

# BoxDigitA
# ╔═╗
L C9 CD BB 
# ╠═╣
L CC CD B9 
# ╨ ╨
L D0 20 D0 

# BoxDigitb
# ╓
L D6 20 20 
# ╠═╗
L CC CD BB 
# ╚═╝
L C8 CD BC 

# BoxDigitC
# ╔═╕
L C9 CD B8 
# ║  
L BA 20 20 
# ╚═╛
L C8 CD BE 

# BoxDigitd
#   ╖
L 20 20 B7 
# ╔═╣
L C9 CD B9 
# ╚═╝
L C8 CD BC 

#BoxDigitE
# ╔═╕
L C9 CD B8 
# ╠╡
L CC B5 20 
# ╚═╛
L C8 CD BE 

#BoxDigitF
# ╔═╕
L C9 CD B8 
# ╠╡
L CC B5 20 
# ╨  
L D0 20 20 

#BoxDigitU
# ╓ ╖
L D6 20 B7 
# ║ ║
L BA 20 BA 
# ╚═╝
L C8 CD BC 

#BoxDigitP
# ╔═╗
L C9 CD BB 
# ╠═╝
L CC CD BC 
# ╨  
L D0 20 20 
