# OpenEUP5108
## A Retro 8-bit, Scratch-built, Minimalist, Micro-controller
---
**This distro contains the EUP5108 Assembler, Emulator, and all source roms, documentation, and example code necessary for the user to write, run, and debug programs for the EUP5108!**
  
Check out [doc/EUP5108UserGuide.pdf](https://github.com/Emil-DV/OpenEUP5108/blob/main/doc/EUP5108UsersGuide.pdf) for detailed information about the operation, instruction set, and micro-coded architecture of the EUP5108
  
Our editor of choice is [Notepad++](https://notepad-plus-plus.org/), with it installed, Halting the Emulator will bring up the source code on the current line being executed and then grab the focus
  
To add the EUP51_ASM custom language syntax file place the file [Notepad++ files\EUP5108 Language Highlighting.xml](https://github.com/Emil-DV/OpenEUP5108/blob/main/Notepad%2B%2B%20files/EUP5108%20Language%20Highlighting.xml) into your NP++ "userDefineLangs" folder located here: "\Users\username\AppData\Roaming\Notepad++\userDefineLangs"
  
To use the custom language syntax highlighting, open an EUP5108 .asm file and select "Language|EUP51_ASM" from the main menu. NP++ should remember the selection the next time the file is loaded
  
For a full set of explainer videos be sure to look through the [EUP5108 playlist](https://www.youtube.com/playlist?list=PLutzSUqCeqd2JNwKN7Za1qZU8AJ8HDwoR), Like, Subscribe, and Hit the Bell Icon for notifications of new videos and live streams
  
If you would like to help further the development of this project consider supporting us on [Pateron](https://www.patreon.com/eunumpluribus)

### Quick Start 

- [ ] Clone this Repo or Download the .zip and unzip it to a good location
- [ ] Navigate to your OpenEUP5108\programs\HelloWorld folder
- [ ] Double click on the BuildNRun.bat file  
      The Assembler will be invoked to build HelloWorld.asm and its included files  
      Once complete the Emulator will be invoked to run the HelloWorld.rom output of the assembler  
- [ ] For the full 1990's 80 column x 25 line experience set the Emulator window (cmd.exe) properties thusly
      ![img/cmd.exe_ Properties.png](https://github.com/Emil-DV/OpenEUP5108/blob/main/img/cmd.exe_%20Properties.png)

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
+---EdEx  
|       BootMon-EUP5108Head.asm  
|       EUPASMSyntaxFile  
|       EUPWOZMon.asm  
|       hellotest.asm  
|       Login.asm  
|       noob2cpu  
|       ParameterPassing.asm  
|       ParameterPassing2.asm  
|       ParameterPassing3.asm  
|       Pointers.asm  
|       subtractionmagic  
|       testme.asm  
|  
+---gamelibs  
|   +---Cards  
|   |       PlayingCardDeck.asm  
|   |  
|   +---EUPInvaders  
|   |       EupInvadersAssets.asm  
|   |       EupInvadersCode.asm  
|   |  
|   +---EUPOutV1  
|   |       EUPOut.asm  
|   |  
|   \---EUPOutV2  
|           EUPOUTv2.asm  
|  
+---HelloWorld  
|       HelloWorld.asm  
|  
+---iolibs  
|       EUP5208Lib.asm  
|       EUPIO.asm  
|  
\---stdlibs  
    |   ASCIITbl.asm  
    |   eupheap.asm  
    |   EUPStr.asm  
    |   Math.asm  
    |   StringLib.asm  
    |   UtilFunctions.asm  
    |  
    \---Tests  
            eupheaptests.asm  
            InstructionTests.asm  
            IsDigitTests.asm  
            StringLibTest.asm  
