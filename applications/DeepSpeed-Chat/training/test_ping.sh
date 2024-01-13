#!/bin/bash

output_file="unreachable_hosts.txt"

# Check if the input file is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi


input_file="$1"

# Function to ping and check host
check_host() {
    local host=$1
    # Ping the host with a timeout of 5 seconds
    if ! ping -c 1 -W 5 "$host" &> /dev/null; then
        # If ping fails, append the host to the output file
        echo "$host" >> "$output_file"
    fi
}

# Read each line from the file and check the hosts
while IFS= read -r host; do
    check_host "$host" &
done < "$input_file"

# Wait for all background processes to complete
wait