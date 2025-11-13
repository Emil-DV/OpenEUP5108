#!/bin/bash
# Find #$ comments at the beginning of a line and echos them without the #$
./findinfiles.sh -r -n '^#\$' '*.asm' | sed 's/^#\$//' > StockPrograms.txt

