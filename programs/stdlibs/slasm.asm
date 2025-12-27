#          My message to you          #  
#=====================================#
O 0x3000	# Start at the 
A 0x1000	# well known Addresses
W PrintMsg	# Function address

D Msg		# The message in HEX
L 49 20 03       
L 20 55 00 

D PrintMsg	  # void PrintMsg(){
  LDR Msg	  # DR = *Msg
D PrintMsg.do     # do {
  LAF		  # A = *Msg (ROM)
  W1A		  # Write port 1 A
  IND		  # DR++
  LBA		  # B = A
  JLN PrintMsg.do # } while(B != 0) 
  RTL		  # return }

#             I ♥ U 		      #	
#   GENX OG's
#   Code in HEX
#   -----------
#   08 30 49 20
#   03 20 55 00
#   76 02 30 32
#   D3 BE 43 92
#   0B 30 97 00

