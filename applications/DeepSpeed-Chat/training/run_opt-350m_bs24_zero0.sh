#!/bin/bash
# --- GPU arch (auto-detect) ---
GPU_ARCH=$(nvidia-smi --query-gpu=compute_cap --format=csv,noheader | head -1)
export TORCH_CUDA_ARCH_LIST="${GPU_ARCH}"

# --- Shared extension cache directory ---
export TORCH_EXTENSIONS_DIR="/root/.cache/torch_extensions"

# --- CUDA toolkit location ---
export CUDA_HOME="/usr/local/cuda"
export PATH="${CUDA_HOME}/bin:${PATH}"
export LD_LIBRARY_PATH="${CUDA_HOME}/lib64:${LD_LIBRARY_PATH:-}"

# --- Build behavior ---
export MAX_JOBS=1          # safer on multi-rank builds
export DS_BUILD_VERBOSE=1  # show build logs for first compile

# --- Optional NCCL/diagnostics helpers ---
export NCCL_DEBUG=INFO
export TORCH_NCCL_ASYNC_ERROR_HANDLING=1
JOB_NAME=${1:-"1xN"}
HOSTFILE_NAME=${2:-""}
OUTPUT_PATH=${3:-"output"}

# Step 1
MODEL_NAME=opt-350m
STEP_NAME=1

NAME_LOG=${OUTPUT_PATH}/${MODEL_NAME}_${STEP_NAME}_${JOB_NAME}.log
cat $HOSTFILE_NAME | tee $NAME_LOG
echo >> $NAME_LOG

first_line=$(head -n 1 "$HOSTFILE_NAME")
master_addr=$(echo "$first_line" | awk '{print $1}')

deepspeed_path="deepspeed"

source ./setup_env.sh $MODEL_NAME $STEP_NAME && \
PROJECT_PATH=${PROJECT_PATH} $deepspeed_path --hostfile=$HOSTFILE_NAME --master_addr $master_addr $SCRIPT_PATH/main.py \
   --data_path Dahoas/rm-static Dahoas/full-hh-rlhf \
   --data_split 2,4,4 \
   --data_output_path $DATA_OUTPUT_PATH \
   --model_name_or_path $MODEL_PATH \
   --per_device_train_batch_size 24 \
   --per_device_eval_batch_size 4 \
   --max_seq_len 512 \
   --learning_rate 1e-10 \
   --weight_decay 0.1 \
   --disable_dropout \
   --gradient_accumulation_steps 1 \
   --lr_scheduler_type cosine \
   --seed 1234 \
   --zero_stage 0 \
   --deepspeed \
   --num_warmup_steps 10 \
   --num_train_epochs 10 \
   --max_steps 1000 2>&1 | tee -a $NAME_LOG
