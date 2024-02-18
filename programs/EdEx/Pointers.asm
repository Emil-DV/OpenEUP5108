W main
# The point of pointers in C

# To understand pointers one must first understand what
# a variable is:
# In a number of higher level languages such as Python & Java
# the implementation of a variable is more hidden but in C
# A variable is simply a location in RAM memory that is given a
# name and a size in bytes determined by its "type".

# This is an example of the kind of ram chips that are in modern 
# computers. These chips have a primary input number known as an
# ADDRESS and a primary output number known as DATA.  The size of 
# these numbers in bits varies from 8..64 depending on the size of
# the chip in Kilo, Mega, or Giga bytes.

# A Pointer in C is another type of variable, the size of the processor's
# address bus (16 bit in our case) 32 or 64 bits in modern PCs,
# that contains the ADDRESS of a different variable of the same
# type.


# C variable examples:
# char  AChar;
#  |     |-- The Name (only exists during compilation)
#  |-------- The type (size) char = 1 byte
   
# The compiler/assembler assigns a location in RAM
# This location is the variable's ADDRESS
# The compiler/assembler increases the next avaliable RAM
# address by the type's size.


# The main goal is to be able to access/change blocks of data 
# without moving them around in memory. e.g. Sorting and Searching


# int AInt;
#  |    |-- The Name (only exists during compilation)
#  |------- The type (size) int = 4 bytes (usually)

# In the EUP5108 our ADDRESS are two bytes in size.

# short AShort;
#  |    |-- The Name (only exists during compilation)
#  |------- The type (size) short = 2 bytes 

# The EUP assembler does these steps one at a time:
A 0x1110  # Start variable ADDRESSes at 0x1110
V AChar   # Create a Variable with the name 'AChar'
a 0x01    # Advance the Assembler's Data Address by 1

V AInt    # Creates AInt at 0x1111
a 0x04    # ADA += 4

V AShort  # Creates AShort at 0x1115
a 0x02    # ADA += 2

O 0x0010  # Start code at 0x0010 ROM ADDRESS
D main    # main = 0x0010

# To assign a value to a variable e.g.
# AChar = 0x45;
  LDR AChar # During assembly the ADDRESS (0x1110) of AChar
            # is loaded into the Data (pointer) Register.
  LAE 0x45  # Load into the A register the value 0x45
  SIA       # Store into RAM the value in A at the ADDRESS
            # Pointed to by the Data (pointer) Register.



# char *pointer2char;
V pointer2char  # Creates pointer2char at 0x1117
a 0x02          # ADA += 2

# pointer2char = &AChar;
  LDR AChar     # DR = 0x1110
  LAD           # Copy D (0x11) to A reg
  LBR           # Copy R (0x10) to B reg
  LDR pointer2char # LDR = 0x1117
  SIB           # Copy B (0x10) to the byte pointed to by DR
  IND           # Increment DR
  SIA           # Copy A (0x11) to the byte pointed to by DR

# *pointer2char = 0xAA
  LDR pointer2char # DR = 0x1117
  LBM           # Load low byte of pointer value to B
  IND           # DR++
  LAM           # Load high byte of pointer value to A
  LDA           # Move A into D
  LRB           # Move B into R
# Now DR holds the pointer to AChar (contents of pointer2char)
  LAE 0xAA      # Load 0xAA into A
  SIA           # Store 0xAA into location pointed to by DR
  
  


  HLT
