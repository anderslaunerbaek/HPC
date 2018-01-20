#!/bin/bash

filename='project3pos'

## cluster setup
#BSUB -J project3pos
#BSUB -o project3pos%J.out
#BSUB -q gpuv100
#BSUB -gpu "num=2:mode=exclusive_process:mps=yes"
## set wall time hh:mm
#BSUB -W 00:25 
#BSUB -R "rusage[mem=1024MB] span[hosts=1]"
## set number of cores
#BSUB -n 12

##  load modules
module load cuda/9.1
module load gcc/6.3.0

## data dirs
mkdir -p analysis/pos
rm -rf analysis/pos/*

N=2048
max_iter=1000
echo "\nstart performance_pos\n"
cd ./CPU/
OMP_NUM_THREADS=12 jac_cpu $N $max_iter
cd ./..
cd ./GPU/
jac_gpu1 $N $max_iter
jac_gpu2 $N $max_iter
jac_gpu3 $N $max_iter
cd ./..
echo "\nend performance_pos\n"

## create data file
module load python3/3.6.0

c=$filename$LSB_JOBID'.out'
python3 get_performance_pos.py $c ./analysis/matmult/ performance_pos

## module load matplotlib/2.0.2-python-3.6.2
## python3 get_vis.py ./../analysis/pos/jac_cpu.txt 
## python3 get_vis.py ./../analysis/pos/jac_gpu1.txt 
## python3 get_vis.py ./../analysis/pos/jac_gpu2.txt 
## python3 get_vis.py ./../analysis/pos/jac_gpu3.txt 
