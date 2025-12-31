#$ ## Syscall.asm
#$  Used by loadable programs to be able to access
#$  the syscall area by duplicating the necessary
#$  Values from sys.asm

#A 00
C RTCDate 0 # Date string
#a 0x06
C RTCTrigger 6 # Set to 1 to get local, 2 for GMT
#a 0x01
C RTCTime 7 # Time string
#a 0x07
C RTCmSec 14 # mSec in short
#a 0x02

# The random number generator resides after the clock
# and contains a range, seed, and produced values
V PRNSeed 0x020 # Normally 0x00 write a value to trigger
C PRNRange 0x021 # Normally 0x00 write a value to trigger
C PRNValue 0x022 # The new value


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
#$ fseek syscallParam = fileno, location = syscallParam2, whence = syscallData
C syscallstdio.seek 0x14
C syscallstdio.seek.seek_set 0  # Seek from beginning of file.
C syscallstdio.seek.seek_cur 1  # Seek from current position.  
C syscallstdio.seek.seek_end 2	# Seek from end of file.  
#$ fsize syscallParam = open file number
C syscallstdio.size 0x15

#$          
#$ For the purposes of file system access \ | / will be converted to host native version

C syscallbusy 0x100  #Check this flag to ensure any prior syscalls are finished
C syscallmake 0x101  #Set this flag to make a syscall after setting up the call cmd,param,data
C syscallNum 0x102  #The syscall number a.k.a the class of command
C syscallRtn 0x103  #The return value of the syscall 00h = success
C syscallCmd 0x107  #The command to execute
C syscallParam 0x10B #The integer param if any
C syscallParam2 0x10F #The second integer param if any
C syscallData 0x110  #The long form data (src/dest paths, block to write or read)

