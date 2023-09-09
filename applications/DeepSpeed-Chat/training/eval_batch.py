import os
import csv
import re
import argparse

# Function to extract hostname, throughput, and success/fail from a log file
def extract_info_from_log(log_file, threshold):
    hostnames = []
    throughput = None
    status = None

    with open(log_file, 'r') as file:
        lines = file.readlines()

    for line in lines:
        if "slots=" in line:
            hostname = line.strip().split()[0]
            hostnames.append(hostname)
        elif "Throughput:" in line:
            match = re.search(r'Throughput: (\d+\.\d+) samples/sec', line)
            if match:
                throughput = float(match.group(1))
                status = "Success" if throughput >= threshold else "Fail"
                break

    # Combine hostnames into a comma-separated string
    hostname_str = ', '.join(hostnames)

    # If throughput was not found, mark as Fail with -1 throughput
    if throughput is None:
        throughput = -1
        status = "Fail"

    return hostname_str, throughput, status

# Parse command-line arguments
parser = argparse.ArgumentParser(description="Parse log files and save results to a CSV file.")
parser.add_argument("log_folder", help="Path to the folder containing log files.")
parser.add_argument("output_csv", help="Path to the output CSV file.")
parser.add_argument("threshold", type=float, help="Threshold for success/fail.")
args = parser.parse_args()

# List to store results
results = []

# Iterate over log files in the folder
log_files = sorted(os.listdir(args.log_folder))

for filename in log_files:
    if filename.endswith(".log"):
        log_file = os.path.join(args.log_folder, filename)
        hostnames, throughput, status = extract_info_from_log(log_file, args.threshold)
        results.append((hostnames, throughput, status))


# Create the parent directory if it does not exist
output_dir = os.path.dirname(args.output_csv)
os.makedirs(output_dir, exist_ok=True)

# Write results to a CSV file
with open(args.output_csv, 'w', newline='') as csv_file:
    csv_writer = csv.writer(csv_file)
    csv_writer.writerow(['Hostnames', 'Throughput (samples/sec)', 'Status'])
    csv_writer.writerows(results)

print("CSV file has been created with the extracted information.")
