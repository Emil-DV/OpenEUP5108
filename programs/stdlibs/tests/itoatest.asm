
V itoateststr
a 8
D itoateststre
S 000:\0

D itoaTest
  LBZ
  SCB
D itoaTest.testr    
  LDR itoateststre        # Push src on stack
  SCR
  SCD
  LDR itoateststre        # Push dst on stack
  SCR
  SCD
  CAL strcpyconst
  INS
  INS
  INS
  INS

  POE 1
  LBM
  LDR tfteststr
  CAL itoa
  LDR tfteststr
  CAL printStr1D
  POE 1
  LBM
  INB
  SIB
  JLN itoaTest.testr 
  INS 
  RTL
