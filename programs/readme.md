### Example Source Code Tree

| File | Description |
| ----------- | ----------- |
programs | Base folder
+---BootMon|The primary application with shell functions   
BootBanner.asm|The Boot Banners - several to choose from  
BootMON-EUP5108.asm|The upper level source file for the application - contains main  
Strings.asm | Set of display strings, the prompt, and help messages  
+---displaylibs | Onscreen drawing libraries  
BigLED.asm | Set of 3x3 character "LED" hex numbers  
BoxDrawing.asm | Set of 3x3 box drawing matrices for single and dbl line boxes   
BoxDrawingDigits.asm | Set of 3x3 Hex digits drawn using extentend box drawing characters  
vt100.asm | Set of vt100 commands for control of cursor position, fg/bg character color, etc.  
+---EdEx | A collection of source files (some pre assembler) and notes for instructional videos using the EUP5108
BootMon-EUP5108Head.asm  
EUPASMSyntaxFile  
EUPWOZMon.asm  
hellotest.asm  
Login.asm  
noob2cpu  
ParameterPassing.asm  
ParameterPassing2.asm  
ParameterPassing3.asm  
Pointers.asm  
subtractionmagic  
testme.asm  
+---gamelibs | The games collection - gaming resources and code  
+---Cards | Standard Playing card games  
PlayingCardDeck.asm | Set of card graphics along with shuffle code  
+---EUPInvaders | Space Invaders clone
EupInvadersAssets.asm | The graphical assets
EupInvadersCode.asm | The game's code  
+---EUPOutV1  
EUPOut.asm | Breakout clone for the EUP5208 Graphics chip - for logisim
+---EUPOutV2  
EUPOUTv2.asm | Breakout clone for the vt100 Terminal
+---HelloWorld | The helloworld project
HelloWorld.asm 
+---iolibs | Libs that allow for access to I/O devices
EUP5208Lib.asm | An external graphics chip done in logisim
EUPIO.asm | Basic I/O with commented source
+---stdlibs  
ASCIITbl.asm | Prints the ascii table of characters 0x20..0xFF
eupheap.asm  | Heap library - all alloc no free
EUPStr.asm | String manipulation
Math.asm  | Math functions like MUL and DIV
StringLib.asm | More String manipulaiton
UtilFunctions.asm | Catchall for new features before they are organized
+---Tests | Set of test code for the various libraries
eupheaptests.asm  
InstructionTests.asm  
IsDigitTests.asm  
StringLibTest.asm  
