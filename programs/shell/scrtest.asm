#######################################################
# Screen Test Function - a place for test code
# This is an example of an external source code addition
# to the EUP shell

# Define the three command table entries
D scrtestCmd       # the command word
S Screen test\0     
D scrtestMsg       # the one line help message
S Screen test: Outputs a buffer to Port3\0

D scrtestFunc      # the function itself
  RTL
