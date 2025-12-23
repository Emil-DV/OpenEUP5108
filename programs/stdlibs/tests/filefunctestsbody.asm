
V fileName
a 0xFA
V fileData
a 0xFA
V openMode
a 0xFA
V amtRead
a 1
V amt2do
a 1
V fileno
a 1

D getFileNameStr
S Enter the name of the file (blank to exit)\n\0

D getModeStr
S Enter mode (0:read 1:write 2:seek 3:read/write/truc 4:Write+append)\n\0

D invalidModeStr
S Invalid Mode!\n\0

D getDataStr
S Enter the data to write/append\n\0

D dataReadStr
S Data Read:\n\0

D filefunctestcompleteStr
S File Function Tests Complete\n\0

D fopenfailstr
S Unable to open file in given mode\n\0

D readerrstr
S \nEOF\n\0

D fftmain
  LDR getFileNameStr
  CAL printStr1E
  
  LDR fileName
  LAE 0xF9
  CAL getLine
  LDR fileName
  LBM
  JLN fftmain.gotname
  JPL fftmain.xit
  
D fftmain.gotname
  W1E 'LF
  W1E '(
  LDR fileName
  CAL printStr1D
  W1E ')
  W1E 'LF
  
  LDR getModeStr
  CAL printStr1E
  
  LDR openMode
  LAE 1
  CAL getLine
  W1E 'LF

  LDR openMode
  LAM
  LBE '0
  MBA
  JLN fftmain.!0
  CAL readtest
  JPL fftmain
D fftmain.!0
  LBE '1
  MBA
  JLN fftmain.!1
  CAL writetest
  JPL fftmain  
D fftmain.!1
  LBE '2
  MBA
  JLN fftmain.!2
  CAL seektest
  JPL fftmain  
D fftmain.!2
  LBE '3
  MBA
  JLN fftmain.!3
  CAL seektest
  JPL fftmain  
D fftmain.!3
  LBE '4
  MBA
  JLN fftmain.!4
  CAL writeappendtest
  JPL fftmain  
D fftmain.!4
  LDR invalidModeStr
  CAL printStr1E
  JPL fftmain
  
D fftmain.xit  
  LDR fileno
  LBM
  JLN fftmain.xit.cf
  JPL fftmain.xit.nf
D fftmain.xit.cf  
  CAL fclose
D fftmain.xit.nf  
  LDR filefunctestcompleteStr
  CAL printStr1E  
  RTL
  
  
D readInstructstr
S Reading file (m for more, !m to exit)\n\0
  
D readtest
  LDR readInstructstr
  CAL printStr1E
  
  LDR fileName
  LAE fileModeRead
  CAL fopen
  LDR fileno
  SIA
  LBA
  JLN readtest.opensuccess
  LDR fopenfailstr
  CAL printStr1E
  RTL
D readtest.opensuccess
  LDR fileno
  LAM
  LBE 250
  LDR fileData
  CAL fread
  LBA
  JLN readtest.someread
  LDR readerrstr
  CAL printStr1E
  JPL readtest.xit
D readtest.someread
  LDR amtRead
  SIA
  LDR syscallData
D readtest.printit  
  LAM
  W1A
  IND
  DEB
  JLN readtest.printit
  LDR amtRead
  LBM
  JLN readtest.more2read
  JPL readtest.xit
D readtest.more2read  
  CAL getCharB
  LAE 'm
  MAB
  JLN readtest.xit
  JPL readtest.opensuccess
D readtest.xit
  LDR fileno
  LAM
  CAL fclose
  LAZ
  LDR fileno
  SIA  
  W1E 'LF  
  RTL  




D writeerrstr
S Write Error\n\0
D writesuccessstr
S Data successfully written to file\n\0
  
D writetest
  LDR getDataStr
  CAL printStr1E
  LDR fileData
  LAE 0xF9
  CAL getLine
  W1E 'LF
  LDR fileData
  CAL strlen
  LDR amt2do
  SIA
  
  LDR fileName
  LAE fileModeWrite
  CAL fopen
  LDR fileno
  SIA
  LBA
  JLN writetest.opensuccess
  LDR fopenfailstr
  CAL printStr1E
  RTL
  
D writetest.opensuccess
  LDR fileno
  LAM
  LDR amt2do
  LBM
  LDR fileData
  CAL fwrite
  LBA
  JLN writetest.somewrite
  LDR writeerrstr
  CAL printStr1E
  JPL writetest.xit
  
D writetest.somewrite
  LDR writesuccessstr
  CAL printStr1E
D writetest.xit
  LDR fileno
  LBM
  JLN writetest.fileclose
  JPL writetest.xit.nfc
D writetest.fileclose
  LDR fileno
  LAM  
  CAL fclose
  LAZ
  LDR fileno
  SIA
D writetest.xit.nfc    
  W1E 'LF  
  RTL  

D readwritetest
  RTL

D readwritetrunctest
  RTL

D writeappendtest
  RTL
      

D seektestinsstr
S Seek Test Enter offset (HEX) - must be 4 chars\n\0
D seektestwencestr
S From wence (0 = SET, 1 = CUR, 2 = END)\n\0

V seekoffset
a 2
V offsetchars
a 5

D seektest
  LDR seektestinsstr
  CAL printStr1E
  LAE 4
  LDR offsetchars
  CAL getLine
  # Push the string of characters onto the stack
  LDR offsetchars
  SCR
  SCD
  LDR seekoffset
  SCR
  SCD
  CAL xtos
  INS	# clean up stack from call to xtos
  INS
  INS
  INS
  
  LDR fileName # open the file for read
  LAE fileModeRead
  CAL fopen
  LDR fileno
  SIA
  LBA
  JLN seektest.opensuccess
  LDR fopenfailstr
  CAL printStr1E
  RTL  
D seektest.opensuccess
  LDR fileno
  LAM
  LDR seekoffset
  LBM
  IND
  LDM
  LRB
  LBZ # seek set for now
  CAL fseek
  HLT
  RTL
  
  
  
  
  
  
  
  
  
  
  
