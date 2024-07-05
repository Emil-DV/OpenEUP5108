#!/bin/bash
# Usage: ShowSourceInEditor.sh [line num] [file name] [prog.rom]
# Launch gedit at the specified line number in the file
gedit +$1:0 "$2" & >/dev/null 2>&1

# Wait for a short period to ensure gedit starts
xdotool sleep 0.25 >/dev/null 2>&1

# Bring the window with the specified ID forward using xdotool
xdotool search --name "$3" windowactivate >/dev/null 2>&1


