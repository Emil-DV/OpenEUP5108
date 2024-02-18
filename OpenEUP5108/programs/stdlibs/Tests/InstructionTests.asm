#######################################################
## Instruction Tests for the EUP 5108
#######################################################
W main      # Set reset vector to main
O 0010      # Start rom constants at 0x0010 ROM ADDRESS

A ABCD
V pVar
a 2

D main

  HLT
  NOP
  
  LAE 0x05
  LBE 0x07
  LTE 0x09
  LDR pVar
  
  EBA # B=B+A := 0x0C
  ETA # T=T+A := 0x0E

  ETB # T=T+B := 0x1A
  
  EAT # A=A+T := 0x1F
  EBT # B=B+T := 0x26
  MTA # T=T-A := 0xFB

  MTB # T=T-B := 0xD5 9A

  MBT # B=B-T := 51

  MBA # B=B-A := 32
  
  INA # A++
  INB # B++ 
  
  DEA # A--
  DEB # B--
  
  HLT