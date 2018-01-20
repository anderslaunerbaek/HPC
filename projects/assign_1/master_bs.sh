#!/bin/bash

filename='project_1'

## cluster setup
#BSUB -J project_1
#BSUB -o project_1%J.out
#BSUB -q hpcintro
## set wall time hh:mm
#BSUB -W 2:00 
#BSUB -R "rusage[mem=2048MB]"
## set number of cores
#BSUB -n 1

##  load modules
module load gcc
## module load studio

## print test environment
echo "CPU information"
lscpu

## declare an array variable
arr=(30 35 40 41 42 43 44 45 46 47 48 49 50 60 90 95 100 105 110 120 130 135 140 145 150 1000 1100 1110 1120 1130 1140 1150 1160 1200 1300 1400 1500 1600)
echo "arr=(${arr[*]})"

echo "\nnow ready for performance tests\n"


##
echo "\nstart matmult_blk_1500\n"
for i in "${arr[@]}"
do
  matmult_c.gcc blk 1500 1500 1500 $i
done
echo "\nend matmult_blk_1500\n"

echo "\n end of performance tests\n"

## create data file
module load python3/3.6.0
b='.out'
c=$filename$LSB_JOBID$b


python3 get_performance.py $c ./out/ matmult_blk_1500 $LSB_JOBID

