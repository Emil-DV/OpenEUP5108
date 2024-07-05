# doing a whole lot of nothing
W Main            # Write value of 'main' to byte 0,1 in ROM (reset vector) 
O 0x0008          # Set the APA to x0008 (just past vectors)

D Main
  NOP
  
O 0xfff0
  JPL Main  
