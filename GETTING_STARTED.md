# Getting started

## ssh into Hyak
```ssh klone.hyak.uw.edu```
Enter your password and TFA.

## Get an interactive session with a GPU node up
```
salloc -A escience -p gpu-a40 -N 1 -c 8 --mem=40G --time=4:00:00 --gpus=1
```

## Install opencode
```
curl -fsSL https://opencode.ai/install | bash
```

## Setup the ollama base in an NVIDIA container
```
# move to gscratch for space
cd /gscratch/escience/$USER
# make a directory to hold everything
mkdir ollama
# change into the ollama directory
cd ollama
# make a directory to hold the downloaded models
mkdir models
# create a container definition file
cat << EOF
Bootstrap: docker
From: nvcr.io/nvidia/nvhpc:25.11-devel-cuda_multi-rockylinux8

%post
    # zstd
    curl -OL https://github.com/facebook/zstd/releases/download/v1.5.7/zstd-1.5.7.tar.gz
    tar -xvzf zstd-1.5.7.tar.gz
    cd zstd-1.5.7
    make
    cd ..
    # Ollama install
    curl -OL https://github.com/ollama/ollama/releases/download/v0.15.6/ollama-linux-amd64.tar.zst
    zstd-1.5.7/zstd -d ollama-linux-amd64.tar.zst
    tar -C /usr -xf ollama-linux-amd64.tar
EOF
# build the container, go get coffee
apptainer build ollama.sif ollama.def
```

## Start the Ollama container with a shell, note the nv is necessary to use the GPU
```
apptainer shell --nv --bind /gscratch/ ollama.sif
# start ollama with a larger default context length than 4k
OLLAMA_CONTEXT_LENGTH=64000 ollama serve&
# wait until output subsides
# move the ollama models to gscratch
ln -sf /gscratch/escience/$USER/ollama/models ~/.ollama/models
# pull some models
ollama pull qwen3:14b
ollama pull devstral
ollama pull gpt-oss
# add opencode to PATH
PATH=$PATH:~/.opencode/bin
# launch opencode with ollama config
ollama launch opencode --config
```
