## Math.asm Math library for mul and div
# #######################################################
# Div8(DR=Dividend, B=Divisor, out A=Quotient, out B=Remainder
D Div8
  LAE 0x00      # Clear the result
D Div8.loop     
  MDB           # Subtract devisor from dividend
  JSR Div8.xt   # if borrow then there are no more divisors in dividend
  JSN Div8.IQ   # if not zero then value remaining is >  0
  INA           # Add 1 to Quotient
  LBR           # put zero remainder into B
  RTL           # return
D Div8.xt
  LTR           # load what's left in R to T
  EBT           # Add T to B for remainder
  RTL           # Return
D Div8.IQ
  INA           # Add 1 to Quotient
  JPS Div8.loop
  
# #######################################################
# Integer divide by multiple subtraction B / A : DR=int div B=remainder

D DivBA           # Div B by A 
  LDZ             # Zero out DR
  MBA             # B = B - A
  JLR DivBA.done  # A > B : patch remainder
D DivBA.loop
  IND             # increment DR
  MBA             # B = B - A
  JSR DivBA.done  # B < 0 : patch remainder
  JLN DivBA.loop  # B > 0 : keep subtracting
  IND
  RTL             # B = 0 : return remainder 0
D DivBA.done  
  EBA             # B = B + A
  RTL             
  
# #######################################################
# Integer multiply by multiple addtion B * A : DR=result
D MulBA           # Multiply B x A 
  LTB             # T = B
  LDZ             # DR = 0
  LBT             # B = T This sets the ALU NZ flag
  JLN MulBA.more
  RTL
D MulBA.more  
  EDA             # DR = DR + A
  DEB             # B--
  JLN MulBA.more
  RTL             
    
