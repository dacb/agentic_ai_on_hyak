# Getting started

## ssh into Hyak
```ssh klone.hyak.uw.edu```
Enter your password and TFA.

## Get an interactive session with a GPU node up
```
salloc -A escience -p gpu-a40 -N 1 -c 8 --mem=80G --time=4:00:00 --gpus=1
```

## Pull the vLLM container image into `vllm-openai_latest.sif`
```
mkdir /gscratch/escience/$USER/vllm-serve
cd /gscratch/escience/$USER/vllm-serve
export APPTAINER_CACHEDIR=/gscratch/escience/$USER/vllm-serve/tmp
apptainer pull docker://vllm/vllm-openai:latest
mkdir logs
mkdir .huggingface
```

## Launch vLLM in background being sure to mount gscratch
```
cd /gscratch/escience/$USER/vllm-serve
export HF_HOME=/gscratch/escience/$USER/vllm-serve/.huggingface

apptainer exec --nv --bind /gscratch/ vllm-openai_latest.sif \
  vllm serve Qwen/Qwen3-14B \
    --host 0.0.0.0 \
    --port 8000 \
    --dtype auto \
    --enable-auto-tool-choice \
    --tool-call-parser \
    --trust-remote-code \
    --download-dir $HF_HOME/hub \
    &> logs/vllm_interactive.log &
```

## Wait for the server to become ready, by tailing the log in follow mode (control-C to end):
```
tail -f logs/vllm_interactive.log
```

## Ending the session
Leave the interactive job will terminate the server.
```
exit
```

## To completely remove all vLLM-related files (container, models, caches, logs):
```
rm -rf /gscratch/escience/dacb/$USER/vllm-serve
```

--

## Install opencode
```
curl -fsSL https://opencode.ai/install | bash
```

## Setup opencode's config
```
cat << EOF
EOF
```

## Start opencode
```
export OPENAI_BASE_URL=http://localhost:8000/v1
export OPENAI_API_KEY=dummy # A dummy key is fine for local use
opencode --model vLLM/qwen3:14b
```
