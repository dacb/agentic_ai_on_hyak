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
export APPTAINER_CACHEDIR=/gscratch/escience/$USER/vllm-serve/tmp
apptainer pull docker://vllm/vllm-openai:latest
```

## Launch vLLM in background
```
cd /gscratch/escience/$USER/vllm-serve
export HF_HOME=/gscratch/escience/$USER/vllm-serve/.huggingface

apptainer exec --nv vllm-openai_latest.sif \
  vllm serve Qwen/Qwen3-14B \
    --host 0.0.0.0 \
    --port 8000 \
    --dtype auto \
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

## Start the container with a shell, note the nv is necessary to use the GPU
```
apptainer shell --nv --bind /gscratch/ nvidia.sif
# add opencode and uv to PATH
PATH=$PATH:~/.opencode/bin
```
