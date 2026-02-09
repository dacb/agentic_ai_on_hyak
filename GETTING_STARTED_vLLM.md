# Getting started

## ssh into Hyak
```ssh klone.hyak.uw.edu```
Enter your password and TFA.

## Get an interactive session with a GPU node up
```
salloc -A escience -p gpu-a40 -N 1 -c 8 --mem=80G --time=4:00:00 --gpus=1
```

## Install uv
```
curl -LsSf https://astral.sh/uv/install.sh | bash
```

## Install opencode
```
curl -fsSL https://opencode.ai/install | bash
```

## Setup the base NVIDIA container
```
# move to gscratch for space
cd /gscratch/escience/$USER
cat << EOF > nvidia.def
Bootstrap: docker
From: nvcr.io/nvidia/nvhpc:25.11-devel-cuda_multi-rockylinux8

%post
    # placehoder, this does nothing
    ls
EOF
# build the container, go get coffee
apptainer build nvidia.sif nvidia.def
```

## Start the container with a shell, note the nv is necessary to use the GPU
```
apptainer shell --nv --bind /gscratch/ nvidia.sif
# add opencode and uv to PATH
PATH=$PATH:~/.opencode/bin
source ~/.local/bin/env
# make a directory to hold the work
mkdir agentic_ai
cd agentic_ai
uv venv --python 3.12 --seed
source .venv/bin/activate
uv pip install vllm --torch-backend=auto
```

## To use opencode, start the container, set the path, and launch it
Make sure you already have `ollama serve running`
```
apptainer shell --nv --bind /gscratch/ ollama.sif
# OLLAMA_CONTEXT_LENGTH=64000 ollama serve&
PATH=$PATH:~/.opencode/bin
ollama launch opencode
```
