# Benchmark DeepSpeed-Chat Training on Lambda Machines
## Docker based setup:

#### Step 0: Install nvidia-container-toolkit

Check that `nvidia-container-toolkit` is installed, e.g.
```
$ nvidia-container-toolkit --version
NVIDIA Container Runtime Hook version 1.17.8
```

If it is not installed, install and restart docker:
```
$ sudo apt-get update
$ sudo apt-get install -y nvidia-container-toolkit
$ sudo systemctl restart docker
```

Check that `nvidia` has been registered with the Docker daemon runtime by checking
that it appears in the docker Runtimes list
```
$ docker info | grep -i runtimes
Runtimes: io.containerd.runc.v2 nvidia runc
```

#### Step 1: Configure Environment

Create a .env file with your paths:

```
cat > .env << EOF
# HOST PATHS
HOST_CACHE_PATH=/srv/nfs/staging/.cache
HOST_REPO_PATH=/srv/nfs/staging/DeepSpeedExamples

# CONTAINER PATHS (inside Docker)
PROJECT_PATH=/workspace
EOF
```

Adjust HOST\_CACHE\_PATH and HOST\_REPO\_PATH to match your storage locations.  In particular, HOST\_REPO\_PATH
should point to the root of your cloned `DeepSpeedExamples` repo.  HOST\_CACHE\_PATH is the directory in which
training datasets will be stored.

#### Step 2: Build and Run Container

```
make build   # Build Docker image
make run     # Start container
make shell   # Enter container shell
```

Inside the container, you'll be at /workspace/DeepSpeedExamples/applications/DeepSpeed-Chat/training.

> [!TIP]
> Ensure that your user is a member of the docker group, e.g.
> ```
> $ groups
> ubuntu users admin docker
> ```
> If `docker` is not present, run
> ```
> $ sudo usermod -aG docker $USER
> ```
> and log out and back in.


#### Step 3: Run training

Prepare a directory of hostfiles to run batch training on. For example, if running on a single node with a single GPU, your directory
will contain a single file:
```
$ mkdir hostfiles/1node_1xN
$ echo "localhost slots=1" > hostfiles/1node_1xN/hostfile_1xN_batch1
```

Run the `run_batch.sh` script on the desired scripts.  For example, to train the opt-350 and opt-13b models, run

```
./run_batch.sh run_opt-350m_bs24_zero0 hostfiles/1node_1xN/ output/${USER}_1xN_opt-350m_bs24 3000
./run_batch.sh run_opt-13b_bs16_zero0 hostfiles/1node_1xN/ output/${USER}_1xN_opt-13b_bs16_zero0/ 600
```

> [!CAUTION]
> Training larger models like opt-13b on smaller clusters (like single A10 VMs) may be impossible or require significant reconfiguration.


## Usage (Non-docker based setup)

#### Step 1: Step up the envrionment

```
# Install dependencies (tested with Lambda stack CUDA12.2, pytorch 2.0.1)

pip install deepspeed==0.10.0 && \
sudo apt-get update && sudo apt-get install -y python3-pybind11 && \
wget https://raw.githubusercontent.com/LambdaLabsML/DeepSpeedExamples/master/applications/DeepSpeed-Chat/requirements_freeze.txt && \
xargs -a requirements_freeze.txt -I{} sh -c 'pip install --upgrade "{}" || echo "SKIPPED: {}"'
```

Note: you can blast this installtion across a cluster with the `install_dependencies.sh` script.
```
#./install_dependencies.sh <path-to-list-of-nodes.txt>
#./install_dependencies.sh ./hostfile/1node_1xN 
```

```
# add PROJECT_PATH=<you-path-to-project> to .deepspeed_env
# e.g. PROJECT_PATH=/home/ubuntu/shared
# this is for deepspeed to access the environment variable: https://www.deepspeed.ai/getting-started/#multi-node-environment-variables
source .deepspeed_env

# also run this so the environment variable is accessible by all the child processes or scripts started from this session
export PROJECT_PATH=<you-path-to-project>
```

The `$PROJECT_PATH` folder can be a mounted NFS (better) or on your local storage (which case you have to do step 2 and 3 on each compute node).

#### Step 2: Prepare the Code

```
cd ${PROJECT_PATH} && \
git clone https://github.com/LambdaLabsML/DeepSpeedExamples.git && \
cd DeepSpeedExamples/applications/DeepSpeed-Chat/training
```

#### Step 3: Prepare model and data

```
# Create cache directories
mkdir -p ${PROJECT_PATH}/.cache/huggingface/transformers
mkdir -p ${PROJECT_PATH}/.cache/huggingface/datasets

# prepare data for 3-steps finetuning for opt-13b and opt-350m
./cache_opt-13b.sh

# prepare opt-66b
./cache_opt-66b.sh

# need to edit the following config file (bug of huggingface model hub)
# ${PROJECT_PATH}/.cache/huggingface/transformers/models--facebook--opt-66b/snapshots/7259969061237fe940036d22bea0fd349e4485e9/config.json
"_name_or_path": "facebook/opt-66b"
```

The output will be saved in `${PROJECT_PATH}/.cache`

```
ubuntu@myhost:~/shared/.cache$ tree -L 2
.
├── data_files
│   ├── opt-13b_step1
│   ├── opt-13b_step3
│   ├── opt-350m_step2
│   └── opt-66b_step1
└── huggingface
    ├── datasets
    └── transformers
```

#### Step 4: Run training

Create a new folder `nodes` inside `DeepSpeedExamples/applications/DeepSpeed-Chat/training` and add a txt file of nodes to it. 
e.g. Assume you have a txt file (`nodes/4nodes.txt`) that contains the list of nodes like this:

```
hostname-001
hostname-002
hostname-003
hostname-004
```

Now you can customize `run_manual.sh` so the 
* `NODES` points to the correct txt filename (e.g. `4nodes` in the above example)
* `NSLOTS` is set to the correct number of GPU per node (8 or 1) 
* `for BATCH in 1` is set to the desired job size (number of nodes per job). e.g. 1 means a single node job, 2 means a distributed job with two nodes.

Then you can submit the benchmark with `./run_manual.sh`

Note: `run_manual.sh` mainly contains three steps, which can be executed step by step, as the explain below:

```
# Make hostfiles for deepspeed, each of them has 2 nodes (batchsize=2)
# The two output hostfiles are 
# hostfiles/4nodes_2xN/hostfile_2xN_batch0001
# hostfiles/4nodes_2xN/hostfile_2xN_batch0002
# Usage: python3 make_batch.py <nodes list> <output hostfile folder> <num of node per hostfile>
python3 make_batch.py nodes/4nodes.txt hostfiles/4nodes_2xN --batchsize 2

# Run run_opt-350m.sh with all the hostfiles in hostfiles/4nodes_2xN
# results will be saved to output/4nodes_2xN_opt-350m
# Jobs run in parallel and have a timeout limit (set to 300 seconds here)
# Usage:  ./run_batch.sh <training shell script> <hostfile folder> <output log file folder> <time out seconds>
./run_batch.sh run_opt-350m hostfiles/4nodes_2xN output/4nodes_2xN_opt-350m 300

# Evaluate result (success if Throughput: is no smaller than e.g. 600 samples/sec)
# Usage:  python3 eval_batch.py <log file folder> <csv file for compiled results> <successful throughput threshold>
python3 eval_batch.py output/4nodes_2xN_opt-350m results/4nodes_2xN_run_opt-350m.csv 600
```


# Notes

- We use epoch=2 for step1 training, despite it is was changed to epoch=16 in the current master branch. Our understanding is that epoch was set to 2 when the reference A100 results were released.

- OPT-66B Step 3 has some issues caused by recent deepspeed update. It eventually cause OOM if we follow the reference benchmark configuration. We will skip this step for this benchmark.

- open files limit will impact the scale of the distributed training, and to exactly what degree depends on the model. e.g. we couldn’t launch distributed training job beyond 32x nodes for opt-350m with the default `ulimit 1024` setting. This can be addressed by adding the following to /etc/security/limits.conf of the launching node:

```
* soft memlock 1000000
* hard memlock 1000000
* soft nofile 1000000
* hard nofile 1000000
# if you are root
root soft nproc 1000000
root hard nproc 1000000
root soft nofile 1000000
root hard nofile 1000000
```

You need to run `sudo sysctl -p` and log in again to reload the kernel setting so to apply the above changes.

- you may see a job is hanging with the first GPU at 0% utlization, and the rest at 100%. This sometimes happens if you kick off multiple jobs simultaneously on s _freshly new_ cluster. Possibly related to all the jobs are creating optimized kernel optimization and trying to write to the same optimized kernel to the same cached location (shared storage). To resolve this, always do a single job first on a new cluster, so the kernel can be cached for all later jobs to use.

