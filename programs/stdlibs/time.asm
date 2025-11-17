#$---- 
#$## stdlibs/time.asm
#$     Date and Time functions
#$     The RTC is now a memory mapped device
#$     with the emulator printing the current
#$     date and local time to RAM at 0x00 
#$
#$     Set RTCZone for Local/GMT time first
#$     RTCZone = 1 : Local Time
#$     RTCZone = 2 : GMT Time
#$
#$     Pointer vars to the Date and Time
#$     strings are located in sys.asm
#$     
#$     V RTCDate = Date in "YYMMDD\0" format
#$     V RTCTime = Local time in "HHMMSS\0" format
#$     V RTCmSec = Two byte value of the current
#$               mSecond in binary

V RTCZone
a 1

#$
#$### | date
#$     Prints the current Date string
D dateCmd
S date\0
D dateCmdHelp
S date: Prints the current date from the RTC\0

D date
  LDR RTCZone	  # Copy zone value to RTCTrigger
  LAM
  LDR RTCTrigger
  SIA
  
  LDR RTCDate
  CAL printStr1D
  W1E 'LF
  RTL

#$
#$### | time
#$     Prints the current Date string
#$     A = 1 (local time)
#$     A = 2 (GMT time)	
D timeCmd
S time\0
D timeCmdHelp
S time: Prints the current time from the RTC\0

D time
  LDR RTCZone	  # Copy zone value to RTCTrigger
  LAM
  LDR RTCTrigger
  SIA

  LDR RTCTime
  CAL printStr1D
  W1E 'LF
  RTL
  
#$
#$### | datetime
#$     Prints the current date and time
#$     in the format YY/MM/DD HH:MM:SS
#$     A = 1 (local time)
#$     A = 2 (GMT time)	
D datetimeCmd
S datetime\0
D datetimeCmdHelp
S datetime: Prints the current date & time from the RTC\0

D datetime
  LDR RTCZone	# Copy zone value to RTCTrigger  
  LAM
  LDR RTCTrigger
  SIA

  LDR RTCDate	# Point to the date string from RTC
  LAM           # Load Year first digit
  W1A		# Print it
  IND		# DR++
  LAM		# Load Year second digit
  W1A		# Print it
  W1E 0x2F	# Print /
  IND		# DR++
  LAM		# Load Month first digit
  W1A		# Print it
  IND		# DR++
  LAM		# Load Month second digit
  W1A		# Print it
  W1E 0x2F	# Print /
  IND           # DR++
  LAM		# Load Day first digit
  W1A		# Print it
  IND		# DR++
  LAM		# Load Day second digit
  W1A		# Print it
  W1E 'SP	# Print space
  IND           # DR++
  IND		# DR++
  LAM           # Load Hour first digit
  W1A		# Print it
  IND		# DR++
  LAM		# Load Hour second digit
  W1A		# Print it
  W1E 0x3A	# Print :
  IND		# DR++
  LAM		# Load Minute first digit
  W1A		# Print it
  IND		# DR++
  LAM		# Load Minute second digit
  W1A		# Print it
  W1E 0x3A	# Print :
  IND           # DR++
  LAM		# Load Second first digit
  W1A		# Print it
  IND		# DR++
  LAM		# Load Second second digit
  W1A		# Print it
  W1E 'LF
  RTL
  
#$
#$### | bigtime
#$     Prints the current date time using BigLEDs
#$     YY/MM/DD
#$     HH:MM:SS in the center of the screen
#$     A = 1 (local time)
#$     A = 2 (GMT time)	
D bigtimeCmd
S bt\0
D bigtimeCmdHelp
S bigtime: Show the time in big LEDS\0
C btRow 2
C btCol 30
D bigtime
  CAL clearFunc
  LDR VTREDONBLK
  CAL printStr1E
D bigtime.l
  LDR RTCZone	# Copy zone value to RTCTrigger
  LAM
  LDR RTCTrigger
  SIA

  LBE btRow
  LAE 27
  CAL vtSetCursorPos
  LDR RTCTime	# Point to the date string from RTC
  LAM           # Load Year first digit
  LBE 0x30
  MAB
  CAL printLED
  LBE btRow
  LAE 31
  CAL vtSetCursorPos
  LDR RTCTime
  LBE 1
  EDB
  LAM
  CAL printLED

  LBE btRow
  LAE 37
  CAL vtSetCursorPos
  LDR RTCTime
  LBE 2
  EDB
  LAM
  CAL printLED
  LBE btRow
  LAE 41
  CAL vtSetCursorPos
  LDR RTCTime
  LBE 3
  EDB
  LAM
  CAL printLED

  LBE btRow
  LAE 47
  CAL vtSetCursorPos
  LDR RTCTime
  LBE 4
  EDB
  LAM
  CAL printLED
  LBE btRow
  LAE 51
  CAL vtSetCursorPos
  LDR RTCTime
  LBE 5
  EDB
  LAM
  CAL printLED
  # Print the colons (FE)
  LBE btRow
  LAE 35
  CAL vtSetCursorPos
  W1E 0xDC
  LBE btRow
  LAE 2
  EBA
  LAE 35
  CAL vtSetCursorPos
  W1E 0xDF

  LBE btRow
  LAE 45
  CAL vtSetCursorPos
  W1E 0xDC
  LBE btRow
  LAE 2
  EBA
  LAE 45
  CAL vtSetCursorPos
  W1E 0xDF

#$     Sleep a little since accessing the RTC in linux
#$     Takes quite a bit of time and doing it in a hard
#$     loop tanks the clock rate of the emulator
  LAE 0x0F
  CAL sleep
  LB0
  JSN bigtime.x
  JPL bigtime.l
D bigtime.x  
  LAZ
  W0A
  CAL clearFunc
  LDR VTWHTONBLK
  CAL printStr1E
  RTL




  
