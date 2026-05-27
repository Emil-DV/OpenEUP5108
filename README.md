# OpenEUP5108
## A Retro 8-bit, Scratch-built, Minimalist, Micro-controller
---
**This distro contains the EUP5108 Assembler, Emulator, and all source roms, documentation, and example code necessary for the user to write, run, and debug programs for the EUP5108!**

The source for the Assembler & Emulator is not yet stable and is thus in a private distro for now

For the Open Source purist, the Assembler and Emulator can be thought of as the engine that runs the EUP5108 shell program, games, and other Open Source examples in programs folder
  
### New Features

**Memory-Mapped I/O (MMIO)** — The emulator now supports MMIO for interacting with host services directly from EUP5108 programs:

| Address | Size | Access | Description |
|---------|------|--------|-------------|
| 0x00–0x0F | 16 | R | Real-time clock (date/time strings + milliseconds) |
| 0x14 | 1 | W | Screenshot trigger — write non-zero to capture the emulator terminal as a PNG |
| 0x20–0x22 | 3 | R/W | Pseudo-random number generator (seed, range, value) |

The screenshot trigger is available now on Linux. Windows support is coming soon.

**16-bit Math Library** — Add, Subtract, Multiply, and Divide operations for 16-bit values. See [programs/stdlibs/Math16.asm](programs/stdlibs/Math16.asm).

See [doc/EUPEMU-feature-requests.md](doc/EUPEMU-feature-requests.md) for the full MMIO roadmap and [programs/stdlibs/sys.asm](programs/stdlibs/sys.asm) for the variable definitions.

---

Check out [doc/EUP5108UserGuide.pdf](https://github.com/Emil-DV/OpenEUP5108/blob/main/doc/EUP5108UsersGuide.pdf) for detailed information about the operation, instruction set, and micro-coded architecture of the EUP5108
  
Our editor of choice is [Notepad++](https://notepad-plus-plus.org/), with it installed, Halting the Emulator will bring up the source code on the current line being executed and then grab the focus
  
To add the EUP51_ASM custom language syntax file place the file [Notepad++ files\EUP5108 Language Highlighting.xml](https://github.com/Emil-DV/OpenEUP5108/blob/main/Notepad%2B%2B%20files/EUP5108%20Language%20Highlighting.xml) into your NP++ "userDefineLangs" folder located here: "\Users\username\AppData\Roaming\Notepad++\userDefineLangs"
  
To use the custom language syntax highlighting, open an EUP5108 .asm file and select "Language|EUP51_ASM" from the main menu. NP++ should remember the selection the next time the file is loaded

Refer to the user's guide for information on using OpenEUP5108 on Linux
  
For a full set of explainer videos be sure to look through the [EUP5108 playlist](https://www.youtube.com/playlist?list=PLutzSUqCeqd2JNwKN7Za1qZU8AJ8HDwoR), Like, Subscribe, and Hit the Bell Icon for notifications of new videos and live streams
  
If you would like to help further the development of this project consider supporting us on [Pateron](https://www.patreon.com/eunumpluribus)

### Quick Start 

- [ ] Clone this Repo or Download the .zip and unzip it to a good location
- [ ] Add the OpenEUP5108\bin location to your path (OpenEUP5108/bin/linux) on Linux
- [ ] Navigate to your OpenEUP5108\programs\HelloWorld folder in a command prompt window 
- [ ] Enter the command "eupbnr HelloWorld"  
      The Assembler will be invoked to build HelloWorld.asm and its included files  
      Once complete the Emulator will be invoked to run the HelloWorld.rom output of the assembler  
- [ ] For the full 1990's 80 column x 25 line experience set the Emulator window (cmd.exe) properties thusly
      ![img/cmd.exe_ Properties.png](https://github.com/Emil-DV/OpenEUP5108/blob/main/img/cmd.exe_%20Properties.png)

