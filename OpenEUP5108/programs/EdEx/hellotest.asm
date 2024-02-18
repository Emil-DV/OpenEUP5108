# My own EUP5108 Assembly Language for
# My own virtual 8-bit processor

W main           # Set program start to "main"

D hello          # Define a constant named 'hello'
S I'm Emil\0     # Fill that constant with 'I'm Emil\0'

I StringLib.asm      # Bring in the string functions
I UtilFunctions.asm  # Bring in the string printing 
                     # functions

D main           # Our program start
  LDR hello      # Load the address of 'hello' into the 
                 # Data Register
  CAL printStr1E # Call the print String to port 1 (stdout)
                 # from ROM function
  HLT            # Halt
  
# "BIOS!?... BIOS!?...We don't have no stink'n BIOS!"