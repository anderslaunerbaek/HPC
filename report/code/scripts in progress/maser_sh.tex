#!/bin/bash

## cluster setup
#BSUB -J project_1
#BSUB -o project_1_%J.out
#BSUB -q hpcintro
## set wall time hh:mm
#BSUB -W 20
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
arr=(50 250 450 650 850 1050 1250 1450 160)

echo "\nnow ready for performance tests\n"

echo "\nstart matmult_nat\n"
for i in "${arr[@]}"
do
  matmult_c.gcc nat $i $i $i
done
echo "\nend matmult_nat\n"


echo "\nstart matmult_nmk\n"
for i in "${arr[@]}"
do
  matmult_c.gcc nat $i $i $i
done
echo "\nend matmult_nmk\n"



echo "\n end of performance tests\n"



## create data file
module load python3/3.6.0
python3 get_performance.py 'project_1_%J.out' './out/' 'matmult_nat'