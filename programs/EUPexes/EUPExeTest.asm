#$ ## EUP Loadable binary header
#$ # Builds a binary file that can be loaded by the shell
#$
#$ # use "exe" as the second option to EUPASM
#$ e.g. EUPASM EUPexe.asm exe
#$ Resulting EUPexe.bin will be trimmed to the final size

# Shell data - loadable binaries must not stomp
# on the shell ROM or RAM
# Max ROM address: 0x2D10
# Max RAM address: 0x08E5
C EUPROMBASE 0x3000
C EUPRAMBASE 0x1000
O 0x3000  # Set the ROM Origin 
A 0x1000  # Set the RAM Origin
W main    # Write the location of this EUP's main

# For now all functionality needed by the EUP exe
# will have to be included - Future versions will
# be able to get entry points from the shell
I ..\stdlibs\StringLib.asm
I ..\stdlibs\UtilFunctions.asm

C sys.cursorChar %

D helloeupstr
S HelloWorld from the EUP exe main\0

D main
  LDR helloeupstr
  CAL printStr1E
  HLT
  RTL
  