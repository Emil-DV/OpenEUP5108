#!/bin/bash
# run_emu.sh - Launch EUPEMU in xterm with fifo stdin for automated control
#
# Usage: ./run_emu.sh <rom_file> [tick_rate] [wait_seconds]
#   rom_file     - path to .rom file (required)
#   tick_rate    - emulator tick rate (default: 20000000)
#   wait_seconds - seconds to wait before screenshot (default: 5)
#
# Sends a space to resume past getCharB pause points.
# Captures screenshot to the rom file's directory.
# Rename .gmp before running to prevent gedit popup.

ROM="${1:?Usage: $0 <rom_file> [tick_rate] [wait_seconds]}"
RATE="${2:-20000000}"
WAIT="${3:-5}"

ROMDIR="$(dirname "$(realpath "$ROM")")"
ROMBASE="$(basename "$ROM")"
TOOLS="$(dirname "$(realpath "$0")")"
FIFO="/tmp/emu_input_$$"
GMP="${ROM%.rom}.gmp"
GMP_BAK="${GMP}.bak"

# Rename .gmp to prevent gedit popup
if [ -f "$GMP" ]; then
    mv "$GMP" "$GMP_BAK"
    echo "Renamed $GMP"
fi

# Create fifo for stdin
rm -f "$FIFO"
mkfifo "$FIFO"

# Launch emulator in xterm
xterm -hold -fa "Monospace" -fs 12 -geometry 80x32 \
    -bg black -fg white -title "$ROMBASE" \
    -e bash -c "cd '$ROMDIR' && '$ROMDIR/../../bin/linux/EUPEMU' '$ROMBASE' $RATE R < '$FIFO'" &
XTERM_PID=$!
echo "Launched xterm (pid $XTERM_PID)"

sleep 2

# Send space to resume past getCharB
echo -n " " > "$FIFO" &
echo "Space sent"

sleep "$WAIT"

# Take screenshot
"$TOOLS/screencap" -t "$ROMBASE" "$ROMDIR"

# Cleanup
rm -f "$FIFO"
if [ -f "$GMP_BAK" ]; then
    mv "$GMP_BAK" "$GMP"
    echo "Restored $GMP"
fi

kill "$XTERM_PID" 2>/dev/null
echo "Done"
