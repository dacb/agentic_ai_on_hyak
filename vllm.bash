#!/bin/bash

cd /gscratch/escience/$USER/vllm-serve
export HF_HOME=/gscratch/escience/$USER/vllm-serve/.huggingface

# choose a model
export MODEL=ibm-granite/granite-4.0-h-tiny
export TOOL_CALL_PARSER=hermes
export MODEL=Qwen/Qwen3-14B
export TOOL_CALL_PARSER=hermes
export MODEL=openai/gpt-oss-20b
export TOOL_CALL_PARSER=openai

apptainer exec --nv --bind /gscratch/ vllm-openai_latest.sif \
	vllm serve $MODEL \
	--host 0.0.0.0 \
	--port 8000 \
	--dtype auto \
	--enable-auto-tool-choice \
	--tool-call-parser $TOOL_CALL_PARSER \
	--trust-remote-code \
	--download-dir $HF_HOME/hub \
	&> logs/vllm_interactive.log &
