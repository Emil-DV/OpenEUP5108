#!/bin/bash
# This file was produced by Grok
# Parse options
recursive=0
exact=0
nolines=0
while getopts "rcn" opt; do
  case $opt in
    r) recursive=1 ;;
    c) exact=1 ;;
    n) nolines=1 ;;
    *) echo "Usage: $0 [-r recursive] [-c close match] [-n no line #] search_string file_pattern"; exit 1 ;;
  esac
done
shift $((OPTIND-1))

# Check if exactly two parameters are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 [-r recursive] [-c close match] [-n no line #] search_string file_pattern"
    echo "Example: $0 -r -c 'hello' '*.txt'"
    exit 1
fi

search_string="$1"
file_pattern="$2"
grep_opts="-s"
# Build grep options
if [ $exact -eq 0 ]; then
    grep_opts="$grep_opts -w"
fi

if [ $nolines -eq 1 ]; then
    grep_opts="$grep_opts -h"
fi


if [ $recursive -eq 1 ]; then
    # Recursive search with sorted files
    find . -type f -name "$file_pattern" -printf '%P\n' | sort | while read -r file; do
        if [ -n "$file" ]; then
            grep $grep_opts "$search_string" "$file"
        fi
    done
else
    # Non-recursive search with sorted files
    find . -maxdepth 1 -type f -name "$file_pattern" -printf '%P\n' | sort | while read -r file; do
        if [ -n "$file" ]; then
            grep $grep_opts "$search_string" "$file"
        fi
    done
fi