#$----
#$## stdlibs/Math16.asm
#$     16-bit math library for add, subtract, multiply, and divide
#$     All functions take two pointer parameters pushed onto the stack
#$     before the call (SCR then SCD for each).
#$     First pushed = pA (first operand)
#$     Second pushed = pB (second operand, receives result)
#$
#$     Caller example:
#$       LDR varA
#$       SCR
#$       SCD
#$       LDR varB
#$       SCR
#$       SCD
#$       CAL Add16
#$       INS
#$       INS
#$       INS
#$       INS
#$
#$     Note: IND/INA/INB/POE corrupt the T register in this
#$     architecture. These functions use stack locals (DES/INS),
#$     POE+LTM to set T fresh, and XDS to store through pointers.
#$     XDS is not interrupt safe so IRQs are masked for the
#$     duration of each function.

#$
#$### | Add16
#$     *pB = *pA + *pB
#$     16-bit unsigned addition
D Add16
  IQM
  DES
  DES
  DES
  DES
  DES
  # Locals: SP+1=pB1lo SP+2=pBlo SP+3=pBhi SP+4=aHi SP+5=aLo
  # Params: SP+8=pB_D SP+9=pB_R SP+10=pA_D SP+11=pA_R

  # Phase 1: read *pA and pB pointer into locals (T/carry corruption OK)
  POE 10          # pA_D param
  LAM
  IND
  LBM
  LRB
  LDA
  LAM
  IND
  LBM
  POE 5           # aLo local
  SIA
  POE 4           # aHi local
  SIB
  POE 8           # pB_D param
  LAM
  IND
  LBM
  LRB
  LDA
  LAR
  LBD
  POE 3           # pBhi local
  SIB
  POE 2           # pBlo local
  SIA
  INA
  POE 1           # pB1lo local
  SIA

  # Phase 2: low byte add
  # Build DR=pB (two POEs, no IND, T will be set after)
  POE 3           # pBhi local
  LAM
  POE 2           # pBlo local
  LBM
  LRB
  LDA
  LAM
  LBA
  POE 5           # aLo local
  LTM
  LAB
  EAT
  # Save result+carry, store via XDS
  SCA
  JLC Add16.c
  LAZ
  JPL Add16.hb
D Add16.c
  LAO
D Add16.hb
  SCA
  # Stack +2: SP+1=carry SP+2=result SP+3=pB1lo ... SP+7=aLo
  POE 5           # pBhi local (+2)
  LAM
  POE 4           # pBlo local (+2)
  LBM
  LRB
  LDA
  XDS
  IND             # → carry on stack
  LBM
  IND             # → result on stack
  LAM
  XDS
  SIA
  # Popped 2 (result+carry), B=carry, stack back to locals

  # Phase 2b: high byte add
  # Compute aHi+carry into aHi local
  POE 4           # aHi local
  LAM
  EAB
  POE 4           # aHi local
  SIA
  # Build DR=pB+1, read *pB[1]
  POE 3           # pBhi local
  LAM
  POE 1           # pB1lo local
  LBM
  LRB
  LDA
  LAM
  LBA
  POE 4           # aHi local (now aHi+carry)
  LTM
  LAB
  EAT
  # Store via XDS (offsets +1 from SCA)
  SCA
  POE 4           # pBhi local (+1)
  LAM
  POE 2           # pB1lo local (+1)
  LBM
  LRB
  LDA
  XDS
  IND
  LAM
  XDS
  SIA
  INS
  INS
  INS
  INS
  INS
  IQU
  RTL

#$
#$### | Sub16
#$     *pB = *pB - *pA
#$     16-bit unsigned subtraction
D Sub16
  IQM
  DES
  DES
  DES
  DES
  DES
  # Locals: SP+1=pB1lo SP+2=pBlo SP+3=pBhi SP+4=aHi SP+5=aLo
  # Params: SP+8=pB_D SP+9=pB_R SP+10=pA_D SP+11=pA_R

  # Phase 1: read *pA and pB pointer into locals (T/carry corruption OK)
  POE 10          # pA_D param
  LAM
  IND
  LBM
  LRB
  LDA
  LAM
  IND
  LBM
  POE 5           # aLo local
  SIA
  POE 4           # aHi local
  SIB
  POE 8           # pB_D param
  LAM
  IND
  LBM
  LRB
  LDA
  LAR
  LBD
  POE 3           # pBhi local
  SIB
  POE 2           # pBlo local
  SIA
  INA
  POE 1           # pB1lo local
  SIA

  # Phase 2: low byte subtract
  POE 3           # pBhi local
  LAM
  POE 2           # pBlo local
  LBM
  LRB
  LDA
  LAM
  LBA
  POE 5           # aLo local
  LTM
  LAB
  LBT
  MAB
  # Save result+borrow, store via XDS
  SCA
  JLR Sub16.b
  LAZ
  JPL Sub16.hb
D Sub16.b
  LAO
D Sub16.hb
  SCA
  # Stack +2: SP+1=borrow SP+2=result SP+3=pB1lo ... SP+7=aLo
  POE 5           # pBhi local (+2)
  LAM
  POE 4           # pBlo local (+2)
  LBM
  LRB
  LDA
  XDS
  IND             # → borrow on stack
  LBM
  IND             # → result on stack
  LAM
  XDS
  SIA
  # Popped 2 (result+borrow), B=borrow, stack back to locals

  # Phase 2b: high byte subtract
  # Compute aHi+borrow into aHi local
  POE 4           # aHi local
  LAM
  EAB
  SIA
  # Build DR=pB+1, read *pB[1]
  POE 3           # pBhi local
  LAM
  POE 1           # pB1lo local
  LBM
  LRB
  LDA
  LAM
  LBA
  POE 4           # aHi local (now aHi+borrow)
  LTM
  LAB
  LBT
  MAB
  # Store via XDS (offsets +1 from SCA)
  SCA
  POE 4           # pBhi local (+1)
  LAM
  POE 2           # pB1lo local (+1)
  LBM
  LRB
  LDA
  XDS
  IND
  LAM
  XDS
  SIA
  INS
  INS
  INS
  INS
  INS
  IQU
  RTL

#$
#$### | Mul16
#$     *pB = *pA * *pB  (low 16 bits of product)
#$     Uses 8-bit partial products via MulBA
D Mul16
  IQM
  DES
  DES
  DES
  DES
  DES
  DES
  DES
  DES
  DES
  # Locals: SP+1=pB1lo SP+2=pBlo SP+3=pBhi SP+4=resHi SP+5=resLo
  #         SP+6=bHi SP+7=bLo SP+8=aHi SP+9=aLo
  # Params: SP+12=pB_D SP+13=pB_R SP+14=pA_D SP+15=pA_R

  # Phase 1: read all operand bytes into locals (T corruption OK)
  POE 14          # pA_D param
  LAM
  IND
  LBM
  LRB
  LDA
  LAM
  IND
  LBM
  POE 9           # aLo local
  SIA
  POE 8           # aHi local
  SIB
  POE 12          # pB_D param
  LAM
  IND
  LBM
  LRB
  LDA
  LAR
  LBD
  POE 3           # pBhi local
  SIB
  POE 2           # pBlo local
  SIA
  INA
  POE 1           # pB1lo local
  SIA
  POE 12          # pB_D param
  LAM
  IND
  LBM
  LRB
  LDA
  LAM
  IND
  LBM
  POE 7           # bLo local
  SIA
  POE 6           # bHi local
  SIB

  # Step 1: aLo * bLo -> base result
  POE 9           # aLo local
  LAM
  POE 7           # bLo local
  LBM
  CAL MulBA
  LAD
  LBR
  POE 5           # resLo local
  SIB
  POE 4           # resHi local
  SIA

  # Step 2: aHi * bLo -> add low byte of product to resHi
  POE 8           # aHi local
  LAM
  POE 7           # bLo local
  LBM
  CAL MulBA
  LAR
  POE 4           # resHi local
  LTM
  EAT
  SIA

  # Step 3: aLo * bHi -> add low byte of product to resHi
  POE 9           # aLo local
  LAM
  POE 6           # bHi local
  LBM
  CAL MulBA
  LAR
  POE 4           # resHi local
  LTM
  EAT
  SIA

  # Store resLo to *pB[0] via XDS
  POE 5           # resLo local
  LAM
  SCA
  # Stack +1
  POE 4           # pBhi local (+1)
  LAM
  POE 3           # pBlo local (+1)
  LBM
  LRB
  LDA
  XDS
  IND
  LAM
  XDS
  SIA

  # Store resHi to *pB[1] via XDS
  POE 4           # resHi local
  LAM
  SCA
  # Stack +1
  POE 4           # pBhi local (+1)
  LAM
  POE 2           # pB1lo local (+1)
  LBM
  LRB
  LDA
  XDS
  IND
  LAM
  XDS
  SIA
  INS
  INS
  INS
  INS
  INS
  INS
  INS
  INS
  INS
  IQU
  RTL

#$
#$### | Div16
#$     *pB = *pB / *pA  (unsigned integer division)
#$     Remainder is discarded
#$     Uses repeated subtraction
D Div16
  IQM
  DES
  DES
  DES
  DES
  DES
  DES
  DES
  DES
  DES
  # Locals: SP+1=pB1lo SP+2=pBlo SP+3=pBhi SP+4=qHi SP+5=qLo
  #         SP+6=bHi SP+7=bLo SP+8=aHi SP+9=aLo
  # Params: SP+12=pB_D SP+13=pB_R SP+14=pA_D SP+15=pA_R

  # Phase 1: read operands into locals (T corruption OK)
  POE 14          # pA_D param
  LAM
  IND
  LBM
  LRB
  LDA
  LAM
  IND
  LBM
  POE 9           # aLo local
  SIA
  POE 8           # aHi local
  SIB
  POE 12          # pB_D param
  LAM
  IND
  LBM
  LRB
  LDA
  LAR
  LBD
  POE 3           # pBhi local
  SIB
  POE 2           # pBlo local
  SIA
  INA
  POE 1           # pB1lo local
  SIA
  POE 12          # pB_D param
  LAM
  IND
  LBM
  LRB
  LDA
  LAM
  IND
  LBM
  POE 7           # bLo local
  SIA
  POE 6           # bHi local
  SIB
  # Init quotient = 0
  LAZ
  POE 5           # qLo local
  SIA
  POE 4           # qHi local
  SIA

D Div16.loop
  # Subtract low bytes: bLo -= aLo
  POE 9           # aLo local
  LBM
  POE 7           # bLo local
  LAM
  MAB
  SIA
  # Save borrow
  JLR Div16.lb
  LAZ
  JPL Div16.hs
D Div16.lb
  LAO
D Div16.hs
  # Subtract high: bHi -= (aHi + borrow)
  POE 8           # aHi local
  LBM
  EAB
  JLC Div16.done
  LBA
  POE 6           # bHi local
  LAM
  MAB
  SIA
  JLR Div16.done
  # Increment quotient (16-bit)
  POE 5           # qLo local
  LAM
  LTE 0x01
  EAT
  SIA
  JLC Div16.qhi
  JPL Div16.loop
D Div16.qhi
  POE 4           # qHi local
  LAM
  LTE 0x01
  EAT
  SIA
  JPL Div16.loop

D Div16.done
  # Store qLo to *pB[0] via XDS
  POE 5           # qLo local
  LAM
  SCA
  # Stack +1
  POE 4           # pBhi local (+1)
  LAM
  POE 3           # pBlo local (+1)
  LBM
  LRB
  LDA
  XDS
  IND
  LAM
  XDS
  SIA

  # Store qHi to *pB[1] via XDS
  POE 4           # qHi local
  LAM
  SCA
  # Stack +1
  POE 4           # pBhi local (+1)
  LAM
  POE 2           # pB1lo local (+1)
  LBM
  LRB
  LDA
  XDS
  IND
  LAM
  XDS
  SIA
  INS
  INS
  INS
  INS
  INS
  INS
  INS
  INS
  INS
  IQU
  RTL

