#Grok' prime sieve program
#Reset & IRQ Vectors
W main  # Reset to symbol main
W hwirq # HW IRQ to symbol hwirq
W irq1  # SW IRQ1 to symbol irq1
W irq2  # SW IRQ2 to symbol irq2
#Main program start
D main
  LDZ     # DR = 0x0000 (sieve base)
  LAZ     # A = 0
  PDS
  SCA
  INS     # RAM[0] = 0
  IND     # DR = 1
  PDS
  SCA
  INS     # RAM[1] = 0
  IND     # DR = 2
  LB1     # B = 1
  LBA     # A = 1
  LAH     # A = 0xFF
  DEA     # A = 0xFE
  LTA     # T = 0xFE
D init_loop
  PDS
  SCA
  INS     # RAM[DR] = 1
  IND     # DR++
  EDT     # T--
  LBT     # B = T (set NZ)
  JLN init_loop # if NZ, loop
#Sieve
  LB1     # B = 1
  LBA     # A = 1
  EAB     # A = 2
  LTA     # T = 2 (i = 2)
D outer_loop
  LDZ     # DR = 0
  CAL add_t_to_dr # DR = i
  PDS
  LAM     # A = RAM[DR]
  LBA     # B = A (set NZ)
  JLN do_mark # if prime, mark
  JPL inc_i   # else next i
D do_mark
  LTA     # A = i
  LBA     # B = A
  EAB     # A = i2
  LDZ     # DR = 0
  CAL add_a_to_dr # DR = i2
D inner_loop
  LAZ     # A = 0
  PDS
  SCA
  INS     # RAM[DR] = 0
  CAL add_t_to_dr # DR += i
  DXR     # swap DR
  LAD     # A = hi (now lo)
  DXR     # swap back
  LBA     # B = A (set NZ)
  JLZ inner_loop # if hi == 0, continue
D inc_i
  LTA     # A = T
  INA     # A++
  LTA     # T = A
  LTA     # A = T
  LBE 0x10 # B = 0x10
  MAB     # A -= 0x10
  JLR outer_loop # if borrow (T < 16), loop
#Output primes
  LDZ     # DR = 0
  LB1     # B = 1
  LBA     # A = 1
  EAB     # A = 2
  LTA     # T = 2
D out_loop
  LDZ     # DR = 0
  CAL add_t_to_dr # DR = T
  PDS
  LAM     # A = RAM[DR]
  LBA     # B = A (set NZ)
  JLN is_prime # if 1, print
  JPL next_out
D is_prime
  CAL print_number # print T
  LBE 0x20 # B = space
  LBA     # A = B
  W1A     # output space
D next_out
  LTA     # A = T
  INA     # A++
  LTA     # T = A
  LTA     # A = T
  LBA     # B = A (set NZ)
  JLZ out_done # if T == 0, done
  JPL out_loop
D out_done
  HLT     # Halt
#Simple halt for HW IRQ
D hwirq
  HLT
#Simple halt for SW IRQ1
D irq1
  HLT
#Simple halt for SW IRQ2
D irq2
  HLT
#Subroutines
D add_a_to_dr
  LTA     # T = A (preserve addend? wait, no, A is addend)
  LAD     # A = DR lo
  LBA     # B = A (lo)
  LTB     # B = T (addend)
  EAB     # A = lo + addend
  LDA     # DR lo = A
  JLC no_carry
  DXR     # swap
  LAD     # A = hi
  INA     # A++
  LDA     # hi = A
  DXR     # swap back
D no_carry
  RTL
D add_t_to_dr
  LTA     # A = T
  CAL add_a_to_dr
  RTL
D print_number
  LAZ     # A = 0 quot
  LBE 0x64 # B = 100
  D ph_loop
    MTB   # T -= 100
    JLR ph_add_back
    INA   # quot++
    JPL ph_loop
  D ph_add_back
    ETB   # T += 100
  LBA     # B = quot (hundreds digit)
  JLZ ph_zero
  LBE 0x30 # B = '0'
  EAB     # A = digit + '0'
  W1A     # output
  LB1     # B = 1 (flag)
  JPL push_flag
D ph_zero
  LBZ     # B = 0 (flag)
D push_flag
  SCB     # push flag to stack
D tens
  LAZ     # A = 0 quot
  LBE 0x0A # B = 10
  D pt_loop
    MTB   # T -= 10
    JLR pt_add_back
    INA   # quot++
    JPL pt_loop
  D pt_add_back
    ETB   # T += 10
  INS     # SP++ (for pop)
  LBM     # B = flag (pop)
  LBA     # temp = quot (tens digit)
  JLN print_tens # if quot != 0, print
  LBB     # set NZ on flag
  JLZ units # if flag == 0 and quot == 0, skip
D print_tens
  LBE 0x30 # B = '0'
  EAB     # A = digit + '0'
  W1A     # output
D units
  LTA     # A = T (units digit)
  LBE 0x30 # B = '0'
  EAB     # A += '0'
  W1A     # output
  RTL


