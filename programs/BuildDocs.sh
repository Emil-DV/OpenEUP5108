#!/bin/bash
filename=readme.md
# md code usage
# use
# #$**Warning** for important notes

# At the top of each file
# #$---- 
# #$## {path and filename relative to programs folder} - {short description}

# #$     {for each line of long description and consts and/or Vars }

# #$
# #$### | { for function names} - {short description}

# Internal Global Consts & Vars should follow the pattern
# {libAbrvConstName} or {libAbrv.VarName}

# Internal labels and local vars should follow the pattern
# {func.label} or {func.VarName}

# The asssembler does not output label location with . in them

echo \# EUP5108 Stock Library and Program Documentation > $filename
# Find #$ comments at the beginning of a line and echos them without the #$
findinfiles -r -n '^#\$' '*.asm' | sed 's/^#\$//' >> $filename

