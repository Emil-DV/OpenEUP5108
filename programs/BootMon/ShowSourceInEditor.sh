 #!/bin/bash

# Check if all three parameters are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <line_number> <filename> <window_id>"
    exit 1
fi

line_number=$1
filename=$2
window_id=$3

# Launch gedit at the specified line number in the file
gedit +$line_number "$filename" &

# Wait for a short period to ensure gedit starts
xdotool sleep 0.25 > /dev/null 2>&1

# Bring the window with the specified ID forward using xdotool
xdotool search --name "$window_id" windowactivate > /dev/null 2>&1


