# EUP5108 Math Library
---- 
## stdlibs/Math.asm 
     Math library for mul and div functions

### | Div8
     DR=Dividend (16bit), B=Divisor (8bit)
     Divides DR by B returning Quotient in A &
     Remainder in B
     Also functions as a modulus operation

### | DivBA
     Divides B by A via multiple subtraction
     returning Quotient in DR and remainder in B
     Also functions as a modulus operation

### | MulBA
     Multiplies B by A via multiple addition
     returning the product in DR
