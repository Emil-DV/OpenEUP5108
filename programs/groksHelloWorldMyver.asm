#My version of Grok's code
#Reset & IRQ Vectors
W main  # Reset to symbol main
W hwirq # HW IRQ to symbol hwirq
W irq1  # SW IRQ1 to symbol irq1
W irq2  # SW IRQ2 to symbol irq2
#Main program start
D main
  LDR str # Load DR with address of string (little endian)
D loop
  LBF     # B = ROM[DR] automatically sets flags
  JLN cont # If NZ (A != 0), jump to cont to output char
  JPL end  # Else (A == 0), jump to end
D cont
  W1B     # Output B to Port 1 (stdout)
  IND     # Increment DR (16-bit)
  JPL loop # Jump back unconditionally
D end
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
#Null-terminated string data
D str
S Hello World!\n\0


