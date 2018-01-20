#!/bin/bash

filename='project3mat'

## cluster setup
#BSUB -J project3mat
#BSUB -o project3mat%J.out
#BSUB -q gpuv100
#BSUB -gpu "num=1:mode=exclusive_process:mps=yes"
## set wall time hh:mm
#BSUB -W 00:20 
#BSUB -R "rusage[mem=1024MB] span[hosts=1]"
## set number of cores
#BSUB -n 12

##  load modules
module load cuda/9.1
module load gcc/6.3.0

## data dirs
mkdir -p analysis/matmult
rm -rf analysis/matmult/*


## declare an array variable
arr=(32 64 128)
echo "arr=(${arr[*]})"

## part 2
echo "\nstart performance\n"
for i in "${arr[@]}"
do
    MATMULT_COMPARE=0 MFLOPS_MAX_IT=1 matmult_f.nvcc lib $i $i $i
    MATMULT_COMPARE=0 MFLOPS_MAX_IT=1 matmult_f.nvcc gpu1 $i $i $i
    MATMULT_COMPARE=0 MFLOPS_MAX_IT=1 matmult_f.nvcc gpu2 $i $i $i ## denne er ikke helt god
    MATMULT_COMPARE=0 MFLOPS_MAX_IT=1 matmult_f.nvcc gpu3 $i $i $i
    MATMULT_COMPARE=0 MFLOPS_MAX_IT=1 matmult_f.nvcc gpu4 $i $i $i
    MATMULT_COMPARE=0 MFLOPS_MAX_IT=1 matmult_f.nvcc gpu5 $i $i $i
    MATMULT_COMPARE=0 MFLOPS_MAX_IT=1 matmult_f.nvcc gpulib $i $i $i
done
echo "\nend performance\n"


## create data file
module load python3/3.6.0

c=$filename$LSB_JOBID'.out'
python3 get_performance.py $c ./analysis/matmult/ performance



## ## blocksize test
## M=10000
## N=10000
## K=10000
## blocksize_arr=(16 32 64 128 256 1024 2048)
## echo "blocksize_arr=(${blocksize_arr[*]})"
## echo "\nstart blocksize\n"
## for i in "${blocksize_arr[@]}"
## do
##     MATMULT_COMPARE=0 MFLOPS_MAX_IT=1 matmult_f.nvcc gpu3 $M $N $K $i
##     MATMULT_COMPARE=0 MFLOPS_MAX_IT=1 matmult_f.nvcc gpu4 $M $N $K $i
##     MATMULT_COMPARE=0 MFLOPS_MAX_IT=1 matmult_f.nvcc gpu5 $M $N $K $i
## done
## echo "\nend blocksize\n"



## ## part 3
## ## How much of the running time is used for CPU ↔ GPU transfers?
## echo "\nstart iomeasure\n"
## for i in "${arr[@]}"
## do
##     MATMULT_COMPARE=0 MFLOPS_MAX_IT=1 matmult_f.nvcc lib $i $i $i
##     MATMULT_COMPARE=0 MFLOPS_MAX_IT=1 matmult_f.nvcc gpu1 $i $i $i
##     MATMULT_COMPARE=0 MFLOPS_MAX_IT=1 matmult_f.nvcc gpu2 $i $i $i ## denne er ikke helt god
## done
## echo "\nend iomeasure\n"
