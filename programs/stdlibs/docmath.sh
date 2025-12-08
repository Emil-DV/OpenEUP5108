echo \# EUP5108 Math Library > MathLib.md

# Find #$ comments at the beginning of a line
# and echos them without the #$
grep '^#\$' 'Math.asm' | sed 's/^#\$//' >> MathLib.md
