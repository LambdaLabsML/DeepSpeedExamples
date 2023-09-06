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

```
# The address and ip in hostfiles/hostfile match your own use case
# log file will be saved to the output folder


# Benchmark opt-13b training with a single node
# See hostfiles/hostfile_1xN_batch1 for an example
./run_opt-13b.sh 1xN_batch1 <name-hostfile-for-single-node>


# Benchmark opt-66b training with eight nodes
# See hostfiles/hostfile_8xN_batch1 for an example
./run_opt-66b.sh 8xN_batch1 <name-hostfile-for-eight-node>
```

# Notes

- We use epoch=2 for step1 training, despite it is was changed to epoch=16 in the current master branch. Our understanding is that epoch was set to 2 when the reference A100 results were released.

- OPT-66B Step 3 has some issues caused by recent deepspeed update. It eventually cause OOM if we follow the reference benchmark configuration. We will skip this step for this benchmark.
