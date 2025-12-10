@echo off

SET BaseName=%1

rem Assemble the file and if it succeeds run the emulator
eupasm.exe %BaseName%.asm 0x11  
IF %ERRORLEVEL% EQU 0 goto runit
pause
exit
:runit
rem Remove the 'R' at the end to bring up the emulator paused
eupemu.exe %BaseName%.rom 100000000 R