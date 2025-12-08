#$---- 
#$## stdlibs/rand.asm
#$     Library of function to get Pseudo-random numbers
V randSeed
a 1

D srand
#  CAL seedRandOrig
#  CAL seedRandMMIO
  CAL seedRandEF
  RTL
  
D rand
#  CAL getRandOrig
#  CAL getRandMMIO
  CAL getRandEF
  RTL

#$
#$### | seedRandOrig
#$     Seeds the random number function with the time msec lsb
D seedRandOrig
  LAO		# Load the RTCTrigger with 1 to get an update
  LDR RTCTrigger
  SIA		
  
  LDR RTCmSec   # get the location of the RTCmSec lsb fist (little endian)
  LAM		# Load into A
  LDR randSeed	# Location of randSeed
  SIA		# Store RTCmSec lsb into randSeed
  RTL
  
#$
#$### | getRandOrig
#$     Generates a random number using Simple Linear Congruential Generator for 8-bit values
#$     Where a = 85 & c = 25 - These numbers picked by Grok AI
#$     DR = randSeed * 85 + 25
#$     randSeed = R
#$     Called with A = Range of Numbers 0..255
#$     Returns random number in B in the range 0..A
D getRandOrig 
  SCA		# Store the A that was passed on Stack

  LDR randSeed  # Load the randSeed into A
  LAM 

  LBE 0x55      # 85 in decimal
  CAL MulBA	# do the multiply - result in DR

  LAE 0x19      # 25 in decimal
  EDA           # add the 25 to DR
  LBR           # Get R into B 
  RRB
  RRB
  RRB
  RRB

  LDR randSeed  # Store the new rand seed
  SIB		

  POE 1		# Load the passed A from stack
  LAM
  INA		# Add one for modulus operation
  CAL DivBA	# DivBA Divides B by A returns remainder
  		# in B providing a modulus operation
  		
  INS		# Increment SP to delete temp A  		
  RTL		# Return

#$
#$### | seedRandMMIO
#$     Generates a random number using Memory Mapped IO
#$     where the emulator uses the standard srand
D seedRandMMIO
  LDR PRNSeed
  LAO		# Load 1 into A and 
  SIA		# store it at PRNSeed to trigger srand
  RTL

#$
#$### | getRandMMIO
#$     Generates a random number using Memory Mapped IO
#$     where the emulator uses the standard rand
D getRandMMIO
  LDR PRNRange	# write A to the range to trigger
  SIA		# the emulator call to rand
  
  LDR PRNValue  # Get the new value into B
  LBM
  RTL		# Return 


# An Assembler is a String (symbol) to 
#    Number (address/value) substitution machine
# APA = Assembler Program Address (ROM)
# ADA = Assembler Data Address (RAM)
# V defines a symbol at the current ADA
# a Increases the ADA by some amount
# D defines a symbol at the current APA

# Define the data for the 
# Eternity Forest 8-Bit random 	
# number functions in RAM

# static unsigned char a,b,c,x;
V EF.a		# EF.a is now equal to 0x0643
a 1		#  reserve 1 byte for that Var
V EF.b		# EF.b is now equal to 0x0644
a 1		
V EF.c		# EF.c is now equal to 0x0645
a 1		
V EF.x		# EF.x is now equal to 0x0646
a 1		

C rr2rshift 0x7F # Mask to make rotate right into shift right

# init_rng(s1,s2,s3) 
# seedRandEF is now equal to 0x1425 (ROM)
D seedRandEF	
  HLT
  LAO		# Load A with 1
  LDR RTCTrigger # Load DR w/RTCTrigger (0x0006) RAM
  SIA		# Store the value of A at DR

# XOR new entropy into key state
# EF.a ^=s1;
  # Load s1 (seconds from RTC)
  LDR RTCmSec	# aka (0x000E) RAM
  DED		# decrement DR x2 to get last second
  DED
  LAM		# Load a with value at DR (RAM)
  # Load EF.a into B
  LDR EF.a	# aka (0x0643)
  LBM		# Load B with value at DR (EF.a)
  XBA		# B = B ^ A
  SIB           # save New value to EF.a
   
# EF.b ^=s2;
  # Load s2 (msec[0] from RTC)
  LDR RTCmSec
  LAM
  LDR EF.b
  LBM
  XBA
  SIB

# EF.c ^=s3;
  # Load s3 (msec[1] from RTC)
  LDR RTCmSec
  IND
  LAM
  LDR EF.c
  LBM
  XBA
  SIB

# EF.x++;
  # Increment EF.x
  LDR EF.x
  LAM
  INA
  SIA
  
# EF.a = (EF.a^EF.c^EF.x);
  LDR EF.a
  LAM
  LDR EF.c
  LBM
  LDR EF.x
  LTM
  XAB
  XAT
  LDR EF.a
  SIA
  
# EF.b = (EF.b+EF.a); # Where is the optimize
  LDR EF.b
  LBM
  LDR EF.a
  LAM
  EBA
  LDR EF.b
  SIB

# EF.c = (EF.c+(EF.b>>1)^EF.a);
  LDR EF.b
  LBM
  RRB		# Rotate Right != Shift Right
  LAE rr2rshift # Mask to get rid of upper bit
  ABA		# B = B and A
  LDR EF.c
  LAM
  EBA		# Addition
  LDR EF.a
  LAM
  XBA		# xor
  LDR EF.c
  SIB

  RTL

#unsigned char randomize()
D getRandEF
C getRandEF.range 1 # this is a "local" var on stack
  SCA		# Store the range on the stack (A) 
#x++;               // x is incremented every round 
#		    // and is not affected by any 
#		    // other variable
#a = (a^c^x);       // note the mix of addition and 
#		    // XOR
#b = (b+a);         // And the use of very few 
#		    // instructions
#c = (c+(b>>1)^a);  // the right shift is to ensure
#		    // that high-order bits from b 
#                   // can affect  
#return(c)          // low order bits of other 
#                   // variables
#}
# This is the same calculation as the done in 
# the seedRandEF function above
# EF.x++;
  # Increment EF.x
  LDR EF.x
  LAM
  INA
  SIA
  
# EF.a = (EF.a^EF.c^EF.x);
  LDR EF.a
  LAM
  LDR EF.c
  LBM
  LDR EF.x
  LTM
  XAB
  XAT
  LDR EF.a
  SIA
  
# EF.b = (EF.b+EF.a); # Where is the optimize
  LDR EF.b
  LBM
  LDR EF.a
  LAM
  EBA
  LDR EF.b
  SIB

# EF.c = (EF.c+(EF.b>>1)^EF.a);
  LDR EF.b
  LBM
  RRB		# Rotate Right != Shift Right
  LAE 0x7F	# Mask to get rid of upper bit
  ABA		# B = B AND A
  LDR EF.c
  LAM
  EBA		# Addition
  LDR EF.a
  LAM
  XBA		# xor
  LDR EF.c
  SIB		# EF.c is the new value
  POE getRandEF.range	# Load the stored range
  LAM
  CAL DivBA	# Get the modulus of B/A ret in B
  INS		# Clean up the stack
  RTL		# Return















#$
#$### | TestRandStr
#$     Generates a random number, converts it decimal
#$     and prints it to the screen
#$     hit 'q' to exit, any other key for next number
V TestRandStrStr
a 4

D TestRandStr
  LDR VTCLR		# Clear the screen
  CAL printStr1E

  CAL srand		# Seed the RNG
D TestRandStr.l		
  LAE 0xFE  		# Range = 0..255
  CAL rand		# Get the random number
  LDR TestRandStrStr	# Convert value to decimal string
  CAL itoa
  LDR TestRandStrStr	# Print the number
  CAL printStr1D
  W1E 'SP		# Add a space between them

  CAL getCharB		# Get a character
  LAE 'q		# compare to 'q'
  MAB
  JLN TestRandStr.l	# character != q so loop
  RTL			# otherwise exit

#$
#$### | TestRandStrDual
#$     Generates a random number using both randEF
#$     and randMMIO, converts them to decimal
#$     and prints them to the screen
#$     Both numbers should be the same each time
#$     hit 'q' to exit, any other key for next number
D TestRandStrDual
  LDR VTCLR		# Clear the screen
  CAL printStr1E

  CAL seedRandEF	# Seed the EF RNG
  CAL seedRandMMIO	# Seed the MMIO version
D TestRandStrDual.l		
  LAE 0xFE  		# Range = 0..255
  CAL getRandEF		# Get the random number fm EF
  LDR TestRandStrStr	# Convert value to decimal string
  CAL itoa
  LDR TestRandStrStr	# Print the number
  CAL printStr1D
  W1E 'SP		# Add a space between them

  LAE 0xFE  		# Range = 0..255
  CAL getRandMMIO	# Get the random number fm MMIO
  LDR TestRandStrStr	# Convert value to decimal string
  CAL itoa
  LDR TestRandStrStr	# Print the number
  CAL printStr1D
  W1E 'SP		# Add a space between them
  W1E 'SP		# Add another space between sets

  CAL getCharB		# Get a character
  LAE 'q		# compare to 'q'
  MAB
  JLN TestRandStrDual.l	# character != q so loop
  RTL			# otherwise exit

#$
#$### | testRandScreen
#$     Generates random character at random locations
V testRandScreen.row
a 1
V testRandScreen.col
a 1
V testRandScreen.char
a 1

D testRandScreen
  LAE 0xFE		# set tmp stack var for loop count
  SCA	
  CAL srand		# Seed random number generator from the clock
  
  LDR VTCLR		# Clear the screen
  CAL printStr1E
   
D testRandScreen.loop  
  # Get random col on screen
  LAE sys.scrwidth	# Load screen width (80)
  CAL rand		
  INB			# Inc B so range is 1..80
  LDR testRandScreen.col# store B in .col
  SIB
  
  # Get random row on screen
  LAE sys.scrheight	# Load screen height (25)
  CAL rand
  INB			# Increment B rang is 1..25
  LDR testRandScreen.row# store B in .row
  SIB
  
  # Get random character 
  LAE 0xDE		# Load range 0..221
  CAL rand		
  INB			# Adjust range to 1..222
  LAE 'SP		# Add 32 so range is now 33..254 (printable chars)
  EBA
  LDR testRandScreen.char# Store the character in .char
  SIB
  
  # Set cursor position to the random location
  LDR testRandScreen.col  
  LAM
  LDR testRandScreen.row
  LBM  
  CAL vtSetCursorPos

  # print the random character
  LDR testRandScreen.char
  LAM
  W1A
#  W1E 0xB0

  # Sleep for 1 "ticks"
  LAO
  CAL sleep
  
  POE 1			# Get loop count into B
  LBM
  DEB			# Decrement loop count
  SIB			# Store it back
  JLN testRandScreen.loop
  
  CAL getCharB		# Get character
  LAE 'q		# compare it to 'q'
  MAB
  JLN testRandScreen.r	# character != 'q' so repeat
  JPL testRandScreen.xit
D testRandScreen.r      # repeat setup of counter
  POE 1
  LAE 0xFF
  SIA
  CAL srand		# re-seed
  JPL testRandScreen.loop
D testRandScreen.xit  
  INS			# Remove tmp stack var
  RTL

  
