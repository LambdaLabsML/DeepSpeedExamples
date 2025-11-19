#!/bin/bash

if [ $# -ne 4 ]; then
  echo "Usage: $0 <script_name> <hostfiles_folder_path> <output_folder_path> <timeout_seconds>"
  exit 1
fi

script_name="$1"
hostfiles_folder_path="$2"
output_folder_path="$3"
timeout_seconds="$4"

if [ ! -d "$hostfiles_folder_path" ]; then
  echo "Folder '$hostfiles_folder_path' does not exist."
  exit 1
fi

mkdir -p $output_folder_path

export PROJECT_PATH="/workspace"

# Iterate through hostfiles in the folder
for hostfile in "$hostfiles_folder_path"/hostfile_*; do
  if [ -f "$hostfile" ]; then
    # Extract the name without "hostfile_"
    filename=$(basename "$hostfile")
    job_name="${filename#hostfile_}"

    cmd_job="export USER="root" && cd ${PROJECT_PATH}/DeepSpeedExamples/applications/DeepSpeed-Chat/training && ./${script_name}.sh $job_name $hostfiles_folder_path/$filename $output_folder_path"

    # Submit the job to the running docker container
    timeout ${timeout_seconds}s docker exec deepspeed-training bash -c "$cmd_job" &
    echo "Job submitted for $hostfile"
  fi
  wait
done

# Wait for all background jobs to finish
wait

echo "All jobs finished."
