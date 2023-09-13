# Benchmark DeepSpeed-Chat Training on Lambda Machines

## Usage

#### Step 1: Step up the envrionment

```
# Install dependencies (tested with Lambda stack CUDA12.2, pytorch 2.0.1)

pip install deepspeed==0.10.0 && \
sudo apt-get update && sudo apt-get install -y python3-pybind11 && \
wget https://raw.githubusercontent.com/LambdaLabsML/DeepSpeedExamples/master/applications/DeepSpeed-Chat/requirements_freeze.txt && \
pip install --upgrade -r requirements_freeze.txt && \
rm requirements_freeze.txt
```

#### Step 2: Prepare the Code

```
cd shared && \
git clone https://github.com/LambdaLabsML/DeepSpeedExamples.git
```

We have modified the training scripts ([1](https://github.com/LambdaLabsML/DeepSpeedExamples/blob/master/applications/DeepSpeed-Chat/training/step1_supervised_finetuning/main.py), [2](https://github.com/LambdaLabsML/DeepSpeedExamples/blob/master/applications/DeepSpeed-Chat/training/step2_reward_model_finetuning/main.py), [3](https://github.com/LambdaLabsML/DeepSpeedExamples/blob/master/applications/DeepSpeed-Chat/training/step3_rlhf_finetuning/main.py)) to cache the model and data into `/home/ubuntu/shared` folder, where the `shared` folder can be a mounted NFS or on your local storage.

```
# Make sure the cache folder exists
mkdir -p /home/ubuntu/shared/.cache/huggingface/transformers
mkdir -p /home/ubuntu/shared/.cache/huggingface/datasets
```

#### Step 3: Prepare model and data

```
cd DeepSpeedExamples/applications/DeepSpeed-Chat/training

# prepare opt-350m
./cache_opt-350m.sh

# prepare opt-13b
./cache_opt-13b.sh

# prepare opt-66b
./cache_opt-66b.sh
```

The output will be saved in `/home/ubuntu/shared/.cache`

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

Assume you have a txt file (`nodes/4nodes.txt`) that contains the list of nodes like this:

```
hostname-001
hostname-002
hostname-003
hostname-004
```

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
    * soft nofile 40960
    * hard nofile 81920
```

