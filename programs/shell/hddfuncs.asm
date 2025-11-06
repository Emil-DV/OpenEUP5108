#######################################################
# Hard Drive Functions

# Define the three command table entries
D hddCmd       # the command word
S hdd\0     
D hddMsg       # hdd help message
S hdd: Hard Drive Test\n 
S      HDD Operation\n
S      Device select Port2 = 0xFF\n	
S      All cmds and data via Port3\n
S      System writes 0x0 for failure | file num (0x1..0xFF) for success\n
S      0x81 Open existing file (r) - writes file name bytes until NULL\n
S      0x82 Open new file (w) - writes file name bytes until NULL\n
S      0x83 Open new file (wn) - writes file name bytes until NULL\n
S      0x84 Open new file (a) - writes file name bytes until NULL\n
S      0x85 SeekSet - writes filenum & 2 bytes for location\n
S      0x86 SeekCur - writes filenum & 2 bytes for location\n
S      0x87 SeekEnd - writes filenum & 2 bytes for location\n
S      0x88 Read byte at current loc & increment - writes filenum\n
S      0x89 Write byte at current loc & increment - writes filenum\n
S      0x8A Close file - writes filenum\n\0


D hddHelp
S This is the HDD test function\n\0

D hddfunctests      # the function itself
  LDR hddHelp
  CAL printStr1E
  RTL
