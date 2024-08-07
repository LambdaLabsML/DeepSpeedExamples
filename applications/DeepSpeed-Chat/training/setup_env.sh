#!/bin/bash

model="$1"
step="$2"


if [ "$model" = "opt-66b" ] && [ "$step" = "1" ]; then
    export SCRIPT_PATH=${PROJECT_PATH}/DeepSpeedExamples/applications/DeepSpeed-Chat/training/step1_supervised_finetuning
    export ZERO_STAGE=3
    export MODEL_PATH=facebook/opt-66b
    export MODEL_CACHE=${PROJECT_PATH}/.cache/huggingface/transformers/models--facebook--opt-66b/snapshots/7259969061237fe940036d22bea0fd349e4485e9
    export DATA_OUTPUT_PATH=${PROJECT_PATH}/.cache/data_files/opt-66b_step1
elif [ "$model" = "opt-13b" ] && [ "$step" = "1" ]; then
    export SCRIPT_PATH=${PROJECT_PATH}/DeepSpeedExamples/applications/DeepSpeed-Chat/training/step1_supervised_finetuning
    export ZERO_STAGE=3
    export MODEL_PATH=facebook/opt-13b
    export MODEL_CACHE=${PROJECT_PATH}/.cache/huggingface/transformers/models--facebook--opt-13b/snapshots/e515202d1e7750da62d245fbccb2723b9c1790f5
    export DATA_OUTPUT_PATH=${PROJECT_PATH}/.cache/data_files/opt-13b_step1
elif [ "$model" = "opt-13b" ] && [ "$step" = "3" ]; then
    export SCRIPT_PATH=${PROJECT_PATH}/DeepSpeedExamples/applications/DeepSpeed-Chat/training/step3_rlhf_finetuning
    export ACTOR_ZERO_STAGE=3
    export CRITIC_ZERO_STAGE=3
    export ACTOR_MODEL_CACHE=${PROJECT_PATH}/.cache/huggingface/transformers/models--facebook--opt-13b/snapshots/e515202d1e7750da62d245fbccb2723b9c1790f5
    export CRITIC_MODEL_CACHE=${PROJECT_PATH}/.cache/huggingface/transformers/models--facebook--opt-350m/snapshots/08ab08cc4b72ff5593870b5d527cf4230323703c
    export DATA_OUTPUT_PATH=${PROJECT_PATH}/.cache/data_files/opt-13b_step3
elif [ "$model" = "opt-350m" ] && [ "$step" = "2" ]; then
    export SCRIPT_PATH=${PROJECT_PATH}/DeepSpeedExamples/applications/DeepSpeed-Chat/training/step2_reward_model_finetuning
    export ZERO_STAGE=0
    export MODEL_PATH=facebook/opt-350m
    export MODEL_CACHE=${PROJECT_PATH}/.cache/huggingface/transformers/models--facebook--opt-350m/snapshots/08ab08cc4b72ff5593870b5d527cf4230323703c
    export DATA_OUTPUT_PATH=${PROJECT_PATH}/.cache/data_files/opt-350m_step2
elif [ "$model" = "opt-350m" ] && [ "$step" = "1" ]; then
    export SCRIPT_PATH=${PROJECT_PATH}/DeepSpeedExamples/applications/DeepSpeed-Chat/training/step1_supervised_finetuning
    export ZERO_STAGE=0
    export MODEL_PATH=facebook/opt-350m
    export MODEL_CACHE=${PROJECT_PATH}/.cache/huggingface/transformers/models--facebook--opt-350m/snapshots/08ab08cc4b72ff5593870b5d527cf4230323703c
    export DATA_OUTPUT_PATH=${PROJECT_PATH}/.cache/data_files/opt-350m_step1
elif [ "$model" = "opt-1.3b" ] && [ "$step" = "1" ]; then
    export SCRIPT_PATH=${PROJECT_PATH}/DeepSpeedExamples/applications/DeepSpeed-Chat/training/step1_supervised_finetuning
    export ZERO_STAGE=0
    export MODEL_PATH=facebook/opt-1.3b
    export MODEL_CACHE=${PROJECT_PATH}/.cache/huggingface/transformers/models--facebook--opt-1.3b/snapshots/8c7b10754972749675d22364c25c428b29face51
    export DATA_OUTPUT_PATH=${PROJECT_PATH}/.cache/data_files/opt-1.3b_step1
else
    echo "Invalid model or step"
    exit 1
fi
