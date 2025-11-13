#!/bin/bash
filename=StockLibProgs.txt
echo EUP5108 Stock Library and Program information > $filename
# Find #$ comments at the beginning of a line and echos them without the #$
./findinfiles.sh -r -n '^#\$' '*.asm' | sed 's/^#\$//' >> $filename

