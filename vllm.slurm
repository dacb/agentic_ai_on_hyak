#!/bin/bash

# conda activate your appropriate environment first

# change job name as apropriate
#SBATCH --job-name=vllm_demo
#SBATCH --output=vllm_demo.log
# run time, change this as necessary
#SBATCH --time=48:00:00
# where should the job run?
#SBATCH --chdir=/gscratch/escience/dacb

# these likely won't need to be changed
#SBATCH --account=escience
#SBATCH --partition=gpu-a40

# nodes and tasks
#SBATCH --nodes=1
# CPUs
#SBATCH --cpus-per-task 8
# this is the number of GPUs
#SBATCH --gpus-per-node 1

# 80G is right to load models into the a40
#SBATCH --mem=80

# turn on e-email notifications
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dacb@uw.edu

#SBATCH --export=all

#module load cuda
# run the python script
cd /gscratch/escience/dacb
./vllm.bash
#while true; do
#    echo waiting 10 seconds before starting opencode link
#    sleep 10
#    ssh -N -R 8000:localhost:8576 dacb@dacb.ddns.net -p 3022
#done
