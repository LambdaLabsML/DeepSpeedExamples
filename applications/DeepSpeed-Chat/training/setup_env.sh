#!/bin/bash

model="$1"
step="$2"


if [ "$model" = "opt-66b" ] && [ "$step" = "1" ]; then
    export SCRIPT_PATH=/home/ubuntu/shared/DeepSpeedExamples/applications/DeepSpeed-Chat/training/step1_supervised_finetuning
    export ZERO_STAGE=3
    export MODEL_PATH=facebook/opt-66b
    export MODEL_CACHE=/home/ubuntu/shared/.cache/huggingface/transformers/models--facebook--opt-66b/snapshots/7259969061237fe940036d22bea0fd349e4485e9
    export DATA_OUTPUT_PATH=/home/ubuntu/shared/.cache/data_files/opt-66b_step1
elif [ "$model" = "opt-13b" ] && [ "$step" = "1" ]; then
    export SCRIPT_PATH=/home/ubuntu/shared/DeepSpeedExamples/applications/DeepSpeed-Chat/training/step1_supervised_finetuning
    export ZERO_STAGE=3
    export MODEL_PATH=facebook/opt-13b
    export MODEL_CACHE=/home/ubuntu/shared/.cache/huggingface/transformers/models--facebook--opt-13b/snapshots/e515202d1e7750da62d245fbccb2723b9c1790f5
    export DATA_OUTPUT_PATH=/home/ubuntu/shared/.cache/data_files/opt-13b_step1
elif [ "$model" = "opt-13b" ] && [ "$step" = "3" ]; then
    export SCRIPT_PATH=/home/ubuntu/shared/DeepSpeedExamples/applications/DeepSpeed-Chat/training/step3_rlhf_finetuning
    export ACTOR_ZERO_STAGE=3
    export CRITIC_ZERO_STAGE=3
    export ACTOR_MODEL_CACHE=/home/ubuntu/shared/.cache/huggingface/transformers/models--facebook--opt-13b/snapshots/e515202d1e7750da62d245fbccb2723b9c1790f5
    export CRITIC_MODEL_CACHE=/home/ubuntu/shared/.cache/huggingface/transformers/models--facebook--opt-350m/snapshots/cb32f77e905cccbca1d970436fb0f5e6b58ee3c5
    export DATA_OUTPUT_PATH=/home/ubuntu/shared/.cache/data_files/opt-13b_step3
elif [ "$model" = "opt-350m" ] && [ "$step" = "2" ]; then
    export SCRIPT_PATH=/home/ubuntu/shared/DeepSpeedExamples/applications/DeepSpeed-Chat/training/step2_reward_model_finetuning
    export ZERO_STAGE=0
    export MODEL_PATH=facebook/opt-350m
    export MODEL_CACHE=/home/ubuntu/shared/.cache/huggingface/transformers/models--facebook--opt-350m/snapshots/cb32f77e905cccbca1d970436fb0f5e6b58ee3c5
    export DATA_OUTPUT_PATH=/home/ubuntu/shared/.cache/data_files/opt-350m_step2
else
    echo "Invalid model or step"
    exit 1
fi
