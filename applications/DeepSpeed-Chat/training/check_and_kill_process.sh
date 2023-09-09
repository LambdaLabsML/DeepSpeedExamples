#!/bin/bash

# Check if the input file is provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 <input_file> <process_name>"
  exit 1
fi


input_file="$1"
process_name="$2"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Error: Input file '$input_file' does not exist."
  exit 1
fi

while IFS= read -r hostname || [ -n "$hostname" ]; do
  if [ -n "$hostname" ]; then
    echo "Sending 'sudo pkill ${process_name}' to $hostname"
    ssh "$hostname" "sudo pkill ${process_name}" &
  fi
done < "$input_file"
