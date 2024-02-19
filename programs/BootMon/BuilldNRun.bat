@echo off

SET BaseName=BootMON-EUP5108

rem Assemble the file and if it succeeds run the emulator
..\..\bin\eupasm.exe %BaseName%.asm 0x11  
IF %ERRORLEVEL% EQU 0 goto runit
pause
exit
:runit
rem Remove the 'R' at the end to bring up the emulator paused
..\..\bin\eupemu.exe %BaseName%.rom 100000000 R