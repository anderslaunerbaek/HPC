#!/bin/bash

filename='project3'

## cluster setup
#BSUB -J project3
#BSUB -o project3%J.out
#BSUB -q gpuv100
#BSUB -gpu "num=2:mode=exclusive_process:mps=yes"
## set wall time hh:mm
#BSUB -W 00:20 
#BSUB -R "rusage[mem=4096MB] span[hosts=1]"
## set number of cores
#BSUB -n 12



##  load modules
module load cuda/9.1
module load gcc/6.3.0



N=4000
M=4000

echo "Naive"
./naive/matvec $M $N

sleep 5

echo "cuBLAS"
./cuBLAS/matvec $M $N

sleep 5

echo "Naive split"
./naive_split/matvec $M $N
