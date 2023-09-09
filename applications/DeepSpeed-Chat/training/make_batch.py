#!/bin/python3
import os
import argparse
import sys

def save_batches(batches, batchsize, output_directory, append):
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)

    for i, batch in enumerate(batches):
        batchsize = len(batch)
        output_file = os.path.join(output_directory, f"hostfile_{batchsize}xN_batch{(i + 1):04}")

        if os.path.exists(output_file):
            print(f"File '{output_file}' already exists. Exiting to avoid overwriting.")
            sys.exit(1)

        with open(output_file, 'w') as file:
            for j in range(len(batch)):
                batch[j] += " "
                batch[j] += append
            file.writelines("\n".join(batch))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Split input file into batches and save them to output directory.")
    parser.add_argument("input_file", help="Path to the input file")
    parser.add_argument("output_directory", help="Path to the output directory")
    parser.add_argument("--append", default="slots=8", help="Path to the output directory")
    parser.add_argument("--batchsize", type=int, default=64, help="Batch size (default: 64)")
    parser.add_argument("-f", "--force", action="store_true", help="Force overwrite if the output file exists.")
    
    args = parser.parse_args()

    input_file = args.input_file
    output_directory = args.output_directory
    batchsize = args.batchsize
    append = args.append

    with open(input_file, 'r') as file:
        file_contents = file.readlines()
        nodes = [c.strip() for c in file_contents]

    batches = []

    for i in range(0, len(nodes), batchsize):
        if i + batchsize <= len(nodes):
            batch = nodes[i:i + batchsize]
            batches.append(batch)

    save_batches(batches, batchsize, output_directory, append)

