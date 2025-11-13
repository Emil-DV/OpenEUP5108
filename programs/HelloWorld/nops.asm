#$----
#$## HelloWorld/nops.asm
#$     This program does nothing except demonstrate the O assembler
#$     directive to put a long jump instruction near the end of ROM
#$
#$     Used to show the maximum possible tick rate of the emulator
# doing a whole lot of nothing
W Main            # Write value of 'main' to byte 0,1 in ROM (reset vector) 
O 0x0008          # Set the APA to x0008 (just past vectors)

D Main
  NOP
  
O 0xfff0
  JPL Main  
