#!/bin/bash

# Define the output file
output_file="job_ib_write_bw.txt"

# Loop infinitely with a 30-second interval
while true; do
  # Run the command and append the output with a timestamp to the file
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  echo "Timestamp: $timestamp" >> "$output_file"
  ./cuda_device_check.py hostfiles/128nodes.txt | grep ib_write_bw >> "$output_file"
  
  # Sleep for 30 seconds
  sleep 30
done