#$ ## stdio.asm
#$ # A library to get to stdio functions through syscalls to the emulator
#$
#$ For our purposes stdio also includes the typical DOS commands 
#$ Syscall commands for the stdio                 syscallnum 13H
#$ ls|dir: Lists files and directories.           syscallCmd 00h
#$         ls|dir [optional path]
#$ cd: Changes the current directory.             syscallCmd 01h
#$     cd {path}
#$ md|mkdir: Makes (creates) a new directory.     syscallCmd 02h
#$           md|mkdir {path}
#$ cp|copy: Copies files.                         syscallCmd 03h
#$          cp {source file} {destination file}   
#$ rm|del: Deletes files.                         syscallCmd 04h
#$         rm|del {file to delete}                
#$ ren|mv: Renames files or directories.          syscallCmd 05h
#$         ren|mv {file to rename}
#$ chmod: Change file permissions (linux only)    syscallCmd 06h
#$        chmod {file to change} {permissions}
#$ pwd: Prints the current directory              syscallCmd 07h
#$ - base folder is OpenEUP5108/programs
#$ cat|type: Displays the contents of a text file syscallCmd 08h
#$           cat|type {source file}
#$
#$ while these are named after c stdio file functions they are
#$ implemented using the posix calls for portability
#$
#$ fopen {file path/name.ext} syscallRtn = file number
#$ syscallstdio.open
#$ fclose syscallParam = file number
#$ syscallstdio.close 
#$ fread syscallParam = max amount to read, syscallRtn = bytes read
#$ syscallstdio.read 
#$ fwrite syscallParam = amount to write
#$ syscallstdio.write 
#$ fseek syscallParam = location syscallParam2 = starting location
#$ syscallstdio.seek  
#$ fsize syscallParam = open file number
#$ syscallstdio.size  


D pwdCmd
S pwd\0
D pwdHelp
S pwd: prints the current directory\0

D invalidstr
S Invalid path\n\0


#$ pwd: prints the current directory
D stdioPwd
  # Setup the syscall area for the commands
  LAE syscallstdio
  LDR syscallNum
  SIA
  LAE syscallstdio.pwd
  LDR syscallCmd
  SIA
  LDR syscallmake
  SIA
D stdioPwd.wait  # should wait for syscallbusy to be 0
  LDR syscallbusy
  LBM
  JLN stdioPwd.wait
  LDR syscallRtn
  LBM
  JLN stdioPwd.err
  # call was successful so print the data from syscalldata
  LDR syscallData
  CAL printStr1D
D stdioPwd.err  
  W1E 'LF
  RTL



D cdcmd
S cd\0
D cdhelp
S cd: change directory\0  
#$ cd: change directory DR=directory string
D stdioCd
  SCR
  SCD
  # Setup the syscall area for the commands
  LAE syscallstdio
  LDR syscallNum
  SIA
  LAE syscallstdio.cd
  LDR syscallCmd
  SIA
  # copy the path passed in DR to the syscall data
  LDR syscallData
  SCR
  SCD
  CAL strcpy
  INS
  INS
  INS
  INS
  LDR syscallmake
  LAO
  SIA
D stdioCd.wait  # should wait for syscallbusy to be 0
  LDR syscallbusy
  LBM
  JLN stdioCd.wait
  HLT
  LDR syscallRtn
  LBM
  JLN stdioCd.err
  # call was successful so we print a nl
  W1E 'LF
  RTL
D stdioCd.err  
  LDR invalidstr
  CAL printStr1E
  RTL  

#$ fopen DR = file to open A = mode
#$ Mode = r read w write W read/write a append
#$ return A = file number | 0 for error
D fopen
  SCR
  SCD
  # Setup the syscall area for the commands
  LAE syscallstdio
  LDR syscallNum
  SIA
  LAE syscallstdio.open
  LDR syscallCmd
  SIA
  # copy the path passed in DR to the syscall data
  LDR syscallData
  SCR
  SCD
  CAL strcpy
  INS
  INS
  INS
  INS
  LDR syscallmake
  LAO
  SIA
D fopen.wait  # should wait for syscallbusy to be 0
  LDR syscallbusy
  LBM
  JLN fopen.wait
  LDR syscallRtn
  LBM
  JLN fopen.good
  # call was unsuccessful so we return zero
  LAZ
  RTL
D fopen.good  
  LAB # call successful return file number
  RTL

#$ fclose A = file number
#$ return A = 0 for succcess and any other value for error
D fclose
  # Setup the syscall area for the commands
  LDR syscallParam
  SIA
  LAE syscallstdio
  LDR syscallNum
  SIA
  LAE syscallstdio.close
  LDR syscallCmd
  SIA
  LDR syscallmake
  LAO
  SIA
D fclose.wait  # should wait for syscallbusy to be 0
  LDR syscallbusy
  LBM
  JLN fclose.wait
  LDR syscallRtn
  LAM
  RTL

#$ fread A = file number, B = amount DR = pDest
#$ return A = bytes read for succcess and 0 for error
D fread
#  SCR  #todo: make memcpy func to copy from syscallData to the passed DR
#  SCD
  # Setup the syscall area for the commands
  LDR syscallParam
  SIA
  LDR syscallParam2
  SIB
  LAE syscallstdio
  LDR syscallNum
  SIA
  LAE syscallstdio.read
  LDR syscallCmd
  SIA
  LDR syscallmake
  LAO
  SIA
D fread.wait  # should wait for syscallbusy to be 0
  LDR syscallbusy
  LBM
  JLN fread.wait
  LDR syscallRtn
  LBM
  JLN fread.good
  LAB
#  INS
#  INS
  RTL
  
D fread.good
  # todo: copy the data for now we just print it
  #LDR syscallData
  #CAL printStr1D
  LAB
  RTL




