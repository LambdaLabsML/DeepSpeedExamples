import pandas as pd
import argparse


parser = argparse.ArgumentParser(description="Compute the mean throughput from a CSV file.")
parser.add_argument("input_csv", help="Path to the CSV file.")
args = parser.parse_args()

# Read the CSV file
data = pd.read_csv(args.input_csv)

# Filter the rows where "Status" is "Success"
success_data = data[data["Status"] == "Success"]

# Ensure that the "Throughput (samples/sec)" column exists
if "Throughput (samples/sec)" in success_data.columns:
    # Compute the mean of the "Throughput (samples/sec)" column for "Success" status
    mean_throughput = success_data["Throughput (samples/sec)"].mean()

    print(f"Mean Throughput (samples/sec) for 'Success' status: {mean_throughput:.2f}")
else:
    print("The column 'Throughput (samples/sec)' does not exist in the CSV.")