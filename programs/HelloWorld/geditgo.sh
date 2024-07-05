#!/bin/bash

# Check if two parameters are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <param1> <param2>"
    exit 1
fi

# Assign parameters to variables
param1="$1"
param2="$2"

# Launch the program with the parameters
gedit "$param1" "$param2"

