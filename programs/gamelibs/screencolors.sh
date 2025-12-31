#!/bin/bash

# Script to display examples of all VT100 (ANSI) foreground and background color codes
# Foreground: 30-37 (standard), 90-97 (bright)
# Background: 40-47 (standard), 100-107 (bright)

echo "VT100 Color Code Examples"
echo "-------------------------"
echo "Format: \e[FG;BGm Text \e[0m"
echo ""

# Loop through all foreground colors
for fg in {30..37} {90..97}; do
  echo "Foreground $fg:"
  # Loop through all background colors
  for bg in {40..47} {100..107}; do
    echo -e "\e[${fg};${bg}m FG $fg on BG $bg \e[0m"
  done
  echo ""
done

echo "All combinations displayed."
