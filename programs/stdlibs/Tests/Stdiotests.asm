#$ ## Stdiotests.asm
#$ # Testing the stdio lib

W main
O 0x10

I ..\sys2.asm
I ..\StringLib.asm
I ..\UtilFunctions.asm
I ..\stdio.asm

D hellostr
S This is the stdio library test file\n
S Loading EUPExeTest.bin\n\0

D goodbyestr
S Tests Complete\n\0
D pwdteststr
S Testing pwd\n\0

D cdteststr
S Testing cd\n\0
D cdupone
S ..\\..\0
D cdbasestr
S /home/eupthatsme/repos/OpenEUP5108/programs/EUPexes\0
D filetestread
S EUPExeTest.bin\0



V cmdstr
a 80

D main
  HLT
  LDR hellostr
  CAL printStr1E
  CAL dirtests
  CAL filetests
  
  
  
  
  LDR goodbyestr
  CAL printStr1E
  HLT
  NOP  


D fileteststr
S running file tests:\0

V openfileno
a 1

V amt2cpy
a 1

V cpydst
a 2

V cpysrc
a 2

D filetests
  #LDR fileteststr
  #CAL printStr1E
  # set base location
  LDR cpydst
  LAZ
  SIA
  IND
  LAE 0x30
  SIA
  
 
  # copy filename to cmdstr
  LDR filetestread
  SCR
  SCD
  LDR cmdstr
  SCR
  SCD
  CAL strcpyconst
  INS
  INS
  INS
  INS
  LDR cmdstr
  CAL fopen
  LDR openfileno
  SIA
  LBA
  JLN filetests.good
  LDR invalidstr
  CAL printStr1E
  RTL

D filetests.good
  LDR syscallData
  LAR
  LBD
  LDR cpysrc
  SIA
  IND
  SIB
  # read from the file
  LDR openfileno
  LAM
  LBH
  CAL fread
  LDR amt2cpy
  SIA
  LBA
  JLN filetests.cpy
  
  #close the file
  LDR openfileno
  LAM
  CAL fclose
  
  LRE 0x00
  LDE 0x30
  LAF
  IND
  LDF
  LRA
  CAL callFNptr
  RTL
  
  
D filetests.cpy
  #load src byte
  LDR cpysrc
  LAM
  IND
  LDM
  LRA
  LBM
  LDR cpydst
  LAM
  IND
  LDM
  LRA
  SEB
  # cpydst++
  IND
  LAR
  LBD
  LDR cpydst
  SIA
  IND
  SIB
  # cpysrc++
  LDR cpysrc
  LAM
  IND
  LDM
  LRA
  IND
  LAR
  LBD
  LDR cpysrc
  SIA
  IND
  SIB
  LDR amt2cpy
  LAM
  DEA
  SIA
  JLN filetests.cpy
  JPL filetests.good
  
  
  
  
  
  
  
D dirtests  
  LDR pwdteststr
  CAL printStr1E
  CAL stdioPwd
 
  LDR cdbasestr
  SCR
  SCD
  LDR cmdstr
  SCR
  SCD
  CAL strcpyconst
  INS
  INS
  INS
  INS
  LDR cmdstr
  CAL stdioCd
  CAL stdioPwd
  RTL
  
  

  
 
