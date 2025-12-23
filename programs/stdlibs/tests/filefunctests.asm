#$ ## filefunctests.asm
#$ # EUP Loadable binary 
#$ Built as a binary file that can be 
#$ loaded by the shell
#$
#$ # use "exe" as the second option to EUPASM
#$ e.g. EUPASM filefunctests.asm exe
#$ Resulting filefunctests will be trimmed to
#$ just the size of code

# Shell data - loadable binaries must not stomp
# on the shell ROM or RAM
# Shell Max ROM address: 0x1CB2
# Shell Max RAM address: 0x0983
O 0x3000  # Set the ROM Origin beyond EUPShell ROM
# Note that this is the location expected by the
# lp command
A 0x1000  # Set the RAM Origin beyond EUPShell RAM
W fftmain    # Write the location of this EUP's main

# For now all functionality needed by the EUP exe
# will have to be included - Future versions will
# be able to get entry points from the shell
I ..\StringLib.asm
I ..\UtilFunctions.asm
I ..\..\displaylibs\dispconsts.asm
I ..\stdio.asm
I ..\syscall.asm
I filefunctestsbody.asm

