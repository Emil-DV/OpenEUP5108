#$---- 
#$##  stdlibs/sys.asm
#$     System constants and memory mapped I/O
#$
C sys.topline 6      # 1 based
C sys.cursorChar 0x5F
C sys.scrwidth 80
C sys.scrheight 25

# The realtime clock resides at address 0x00..0x08
# and contains the clock in binary bytes in the format

# Year: years since 2000 - Year 2299 no problem for me
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
# syscall 1Ah - only read is supported
A 00
V RTCDate  # Date string
a 0x06
V RTCTrigger # Set to 1 to get local, 2 for GMT
a 0x01
V RTCTime  # Time string
a 0x07
V RTCmSec  # mSec in short
a 0x02

A 0x020
# The random number generator resides after the clock
# and contains a range, seed, and produced values
V PRNSeed  # Normally 0x00 write a value to trigger
a 1	   # reseeding using the clock
V PRNRange # Normally 0x00 write a value to trigger
a 1
V PRNValue # The new value
a 1

A 0x100    # Move the ADA so all other vars start beyond 
           # The I/O memory map area

#$ Syscall (execute function on emulator's host)
#$ Syscall commands for the stdio                 syscallnum 13H
C syscallstdio 0x13
#$ ls|dir: Lists files and directories.           syscallCmd 00h
#$         ls|dir [optional path]
C syscallstdio.ls 0x00
#$ cd: Changes the current directory.             syscallCmd 01h
#$     cd {path}
C syscallstdio.cd 0x01
#$ md|mkdir: Makes (creates) a new directory.     syscallCmd 02h
#$           md|mkdir {path}
C syscallstdio.md 0x02
#$ cp|copy: Copies files.                         syscallCmd 03h
#$          cp {source file} {destination file}   
C syscallstdio.cp 0x03
#$ rm|del: Deletes files.                         syscallCmd 04h
#$         rm|del {file to delete}                
C syscallstdio.rm 0x04
#$ ren|mv: Renames files or directories.          syscallCmd 05h
#$         ren|mv {file to rename}
C syscallstdio.ren 0x05
#$ chmod: Change file permissions (linux only)    syscallCmd 06h
#$        chmod {file to change} {permissions}
C syscallstdio.chmod 0x06
#$ pwd: Prints the current directory              syscallCmd 07h
#$ - base folder is OpenEUP5108/programs
C syscallstdio.pwd 0x07
#$ cat|type: Displays the contents of a text file syscallCmd 08h
#$           cat|type {source file}
#$
#$ fopen {file path/name.ext} syscallRtn = file number
C syscallstdio.open 0x10
#$ fclose syscallParam = file number
C syscallstdio.close 0x11
#$ fread syscallParam = max amount to read, syscallRtn = bytes read
C syscallstdio.read 0x12
#$ fwrite syscallParam = amount to write
C syscallstdio.write 0x13
#$ fseek syscallParam = location syscallParam2 = starting location
C syscallstdio.seek 0x14
#$ fsize syscallParam = open file number
C syscallstdio.size 0x15

#$          
#$ For the purposes of file system access \ | / will be converted to host native version

V syscallbusy   #Check this flag to ensure any prior syscalls are finished
a 1             #for now all syscalls are blocking
V syscallmake   #Set this flag to make a syscall after setting up the call cmd,param,data
a 1
V syscallNum    #The syscall number a.k.a the class of command
a 1
V syscallRtn    #The return value of the syscall 00h = success
a 4
V syscallCmd    #The command to execute
a 4
V syscallParam  #The integer param if any
a 4
V syscallParam2 #The second integer param if any
a 1
V syscallData   #The long form data (src/dest paths, block to write or read)
a 0x400
C syscallDataSize 0x400

# Plan, set syscallnum, cmd, param, data as needed for the call then set syscallmake to 1
#       wait for syscallmake and syscallbusy to return to 0
#       read return value from syscallRtn and/or syscallData






           

