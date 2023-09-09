#!/bin/python3
import subprocess
import sys
import asyncio

async def check_cuda_device(host):
    try:
        ssh_command = f'ssh {host} "nvidia-smi"'
        process = await asyncio.create_subprocess_shell(
            ssh_command,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
        )
        stdout, stderr = await process.communicate()
        stdout = stdout.decode('utf-8')  # Decode the output
        stderr = stderr.decode('utf-8')  # Decode the error

        if 'NVIDIA-SMI' in stdout:
            stdout = "\n".join(stdout.split("\n")[-8:])
            return f'CUDA device found on {host}:\n{stdout}'
        else:
            return f'No CUDA device found on {host}'
    except Exception as e:
        return f'Error checking CUDA device on {host}: {str(e)}'

async def main():
    if len(sys.argv) != 2:
        print("Usage: ./cuda_device_check_async.py <hostfile>")
        sys.exit(1)

    hostfile_path = sys.argv[1]

    try:
        with open(hostfile_path, 'r') as hostfile:
            hosts = [line.strip() for line in hostfile]
    except FileNotFoundError:
        print(f"Hostfile '{hostfile_path}' not found.")
        sys.exit(1)

    results = await asyncio.gather(*[check_cuda_device(host) for host in hosts])

    for result in results:
        print(result)

if __name__ == '__main__':
    asyncio.run(main())
0
