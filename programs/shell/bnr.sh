#!/bin/sh

../../bin/linux/EUPASM EUPShell.asm
if [ $? -ne 0 ]; then
  echo -n "Continue? (Y/n): "
  read answer

  # Check user's answer
  case $answer in
      [Yy]*|"") 
          # Run second command if user agrees or enters nothing (default to yes)
          ../../bin/linux/EUPEMU EUPShell.rom 20000000 R
          ;;
      *) 
          # If user says no or anything else, do nothing
          exit 1
          ;;
  esac
fi
../../bin/linux/EUPEMU EUPShell.rom 20000000 R

