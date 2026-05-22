# Assembly patterns

# Define a variable
V MyVar		# char MyVar;
a 1		# // 1 is the size of a char

# Read variable
  LDR MyVar	# // Set the pointer register DR to &MyVar
  LAM		# A = MyVar; // ie A = *DR
  
# Increment MyVar eg MyVar++;
  LDR MyVar	# // Set the pointer register DR to &MyVar
  LAM		# A = MyVar;
  INA		# A++;
  SIA		# MyVar = A;

# Define a function
D AFunc
  # Function instructions
  RTL # return;

# Call a function w/o params
  CAL AFunc
  
# Pass a parameter to a function on the stack
  LDR MyVar	# // Set the pointer register DR to &MyVar
  LAM		# A = MyVar;
  SCA		# Store A (MyVar) on the stack (SP--, *SP = A)
  CAL BFunc	# Call the function
  # Print the modified value returned
  POE 1		# DR = SP+1 (MyVar) on the stack
  LAM		# A = *DR
  W1A		# Write A to the screen
  INS		# Increment the stack to remove parameter
  
# Function with parameter on the stack
D BFunc		# eg BFunc(char AVar)
  POE 1		# DR = SP+1
  LAM		# A = MyVar
  # Do stuff with passed value
  LBE 2  	# B = 2
  EBA		# B = B + A
  POE 1		# DR = SP+1
  SIB		# MyVar (on stack) = B
  
# For loop eg  for(i=0;i<10;i++)  
  LAZ		# A = 0
  SCA		# Store A (i) on the stack (SP--, *SP = A)
D ForLoop  	# Label for the top of the loop
  # do loop body instructions
  POE 1		# DR = SP+1 (i) on the stack 
  LAM		# A = i
  INA		# A++
  SIA		# i = A
  LBE 10	# B = 10
  MBA		# B = B-A (i)
  JLN ForLoop	# If I != 10 goto ForLoop
  
  
  
