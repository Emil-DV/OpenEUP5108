#$---- 
#$## iolibs/EUP5208Lib.asm
#$    24x32 Gaming Pixel Display and LEDS
#$    Used in the Gaming view of the Logisim Gaming Model

D LEDTest.Table
L 11 22 33 44 55 66 77 88 99 EE

# C creates symbols with specific values to use as constants later
# Using a . in the symbol prevents it from being shown in the symbol
# table as these are used more like #defines and not function/var symbols
# The addresses of the LED
C LEDS.0 0x60
C LEDS.1 0x80
C LEDS.2 0xA0
C LEDS.3 0xC0

# Writing out this address to port 0 will clear the screen & LEDS
C Screen.Clear 0xE0


#$
#$### | CheckerTest
#$    Fills the screen with the AA/55 checkerboard pattern
##################################################################
D CheckerTest
  LAE 0x60            # Load total screen byte count
D CheckerTest.do
  DEA                 # A-- 
  W1A                 # ScreenAddr = A
  W0E 0x55            # ScreenData = 0x55
  DEA                 # A-- 
  W1A                 # ScreenAddr = A
  W0E 0xAA            # ScreenData = 0x55
  JSN CheckerTest.do  # If A!=0 loop 
  RTL                 # Return

#$
#$### | FillScreen 
#$    Fills the screen with all pixels on
##################################################################
D FillScreen
  LAE 0x20            # Load row max value into A
D FillScreen.do
  DEA                 # A--
  W1A                 # ScreenAddr = A
  W0E 0xFF            # ScreenData = FF
  LBE 0x20            # B = row max
  EBA                 # B = B+A  
  W1B                 # ScreenAddr = B
  W0E 0xFF            # ScreenData = FF
  LBE 0x40            # B = row max * 2
  EBA                 # B = B+A    
  W1B                 # ScreenAddr = B
  W0E 0xFF            # ScreenData = FF
  LBA                 # B = A
  JSN FillScreen.do   # if A!=0 loop
  RTL                 # Return

#$
#$### | TestLEDS
#$    Displays 99..00 in all of the LEDs
D TestLEDS
  LAE 0x0A            # Load total count of LED values
  LDR LEDTest.Table   # Load the base address of the LED Test Values
D TestLEDS.do
  LBF                 # B = ROM[DR]
  W1E LEDS.0          # ScreenAddr = LEDS.0
  W0B                 # ScreenData = B
  W1E LEDS.1          # ScreenAddr = LEDS.1
  W0B                 # ScreenData = B
  W1E LEDS.2          # ScreenAddr = LEDS.2
  W0B                 # ScreenData = B
  W1E LEDS.3          # ScreenAddr = LEDS.3
  W0B                 # ScreenData = B
  IND                 # DR++
  DEA                 # A--
  JSN TestLEDS.do
  RTL



  