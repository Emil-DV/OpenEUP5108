# Super simple HelloWorld
W main		# Start at main

O 0010		# Skip to ROM address 0x10
D HelloStr	# String to print Symbol
S HelloWorld\0  # The string to print

O 0020		# Skip to ROM address 0x20
D main		# The main function
  LDR HelloStr	# Get the location of HelloStr into DR
D main.do  	# Loop symbol
  LBF		# Load character from DR into B
  JSN PrintIt	# If B != 0 jump to PrintIt
  JPS main.exit	# Read a 0 so jump to exit
D PrintIt	# PrintIt symbol
  W1B		# Print the character to port 1
  IND		# Increment DR to next character
  JPS main.do 	# Jump to Loop symbol
D main.exit	# Exit symbol
  HLT  		# Halt the program
