#$---- 
#$##  stdlibs/sys.asm
#$     System constants and memory mapped I/O
#$
C sys.topline 6      # 1 based
C sys.cursorChar 0x5F
C sys.scrwidth 0x50

# The realtime clock resides at address 0x00..0x08
# and contains the clock in binary bytes in the format

# Year: years since 2000 - Year 2255 no problem for me
# Month: 1..12
# Day: 1..31
# Hour: 0..23   24 Hour format is just easier
# Minute: 0..59
# Second: 0..59
# msec (2 bytes) 0..999

# OR...

#$    The realtime clock resides at address 0x00..0x0F
#$    and contains the clock in two strings in the format
#$    YYMMDD\0HHMMSS\0
#$    With the YY being years since 2000 - it will have the year
#$    2100 problem - but I won't
#$
#$    Followed by the two byte value of the current mS in binary

# The reasoning here is that I am not likely to do datetime
# calculations and need it mostly for on screen display
# The mSec is a convient fast turn over value for seeding rand
A 00
V RTCDate  # Date string
a 0x06
V RTCTrigger # Set to 1 to get local, 2 for GMT
a 0x01
V RTCTime  # Time string
a 0x07
V RTCmSec  # mSec in short
a 0x02
A 0x100    # Move the ADA so all other vars start beyond 
           # The I/O memory map area

