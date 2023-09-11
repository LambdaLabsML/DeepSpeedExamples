#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 <input_file> <process_name>"
  exit 1
fi

input_file="$1"
process_name="$2"

# Define the output file
output_file="monitor_${process_name}.txt"

# Loop infinitely with a 30-second interval
while true; do
  # Run the command and append the output with a timestamp to the file
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  echo "Timestamp: $timestamp" >> "$output_file"

  # Read each server from the input file using a for loop
  mapfile -t servers < "$input_file"
  for server in "${servers[@]}"; do
    {
      # Capture the result of pgrep. Use "true" to ensure a zero exit status.
      ssh_result=$(ssh -o BatchMode=yes -o ConnectTimeout=5 "$server" "pgrep $process_name || true" 2>/dev/null)
      
      # Check if ssh_result is not empty and append server to output_file
      if [[ -n "$ssh_result" ]]; then
        echo "$server" >> "$output_file"
      fi
    } &
  done
  wait  # Wait for all backgrounded tasks to finish

  # Sleep for 30 seconds
  sleep 30
done
