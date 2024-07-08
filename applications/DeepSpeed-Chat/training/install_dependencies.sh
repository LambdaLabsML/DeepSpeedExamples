#!/bin/bash

# Check if the input file is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi


input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Error: Input file '$input_file' does not exist."
  exit 1
fi

while IFS= read -r hostname || [ -n "$hostname" ]; do
  if [ -n "$hostname" ]; then
    echo "Processing $hostname"
    ssh "$hostname" "pip install deepspeed==0.14.4 && sudo apt-get update && sudo apt-get install -y python3-pybind11 && sudo apt-get install -y pdsh && [ ! -f /usr/bin/python ] && sudo ln -s /usr/bin/python3 /usr/bin/python; wget https://raw.githubusercontent.com/LambdaLabsML/DeepSpeedExamples/master/applications/DeepSpeed-Chat/requirements_freeze.txt && pip install --upgrade -r requirements_freeze.txt && rm requirements_freeze.txt" &
  fi
done < "$input_file"
