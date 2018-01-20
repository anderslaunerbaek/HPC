#!/bin/bash

filename='project_1'

## cluster setup
#BSUB -J project_1
#BSUB -o project_1%J.out
#BSUB -q hpcintro
## set wall time hh:mm
#BSUB -W 5:30 
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
arr=(8 12 16 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 180 200 240 280 350 450 550 700 900 1100 1300 1500 1700 1900 2200)
echo "arr=(${arr[*]})"

echo "\nnow ready for performance tests\n"

echo "\nstart matmult_nat\n"
for i in "${arr[@]}"
do
  matmult_c.gcc nat $i $i $i
done
echo "\nend matmult_nat\n"

echo "\nstart matmult_lib\n"
for i in "${arr[@]}"
do
  matmult_c.gcc lib $i $i $i
done
echo "\nend matmult_lib\n"



## 
echo "\nstart matmult_nmk\n"
for i in "${arr[@]}"
do
  matmult_c.gcc nmk $i $i $i
done
echo "\nend matmult_nmk\n"

echo "\nstart matmult_mnk\n"
for i in "${arr[@]}"
do
  matmult_c.gcc mnk $i $i $i
done
echo "\nend matmult_mnk\n"

echo "\nstart matmult_mkn\n"
for i in "${arr[@]}"
do
  matmult_c.gcc mkn $i $i $i
done
echo "\nend matmult_mkn\n"

echo "\nstart matmult_nkm\n"
for i in "${arr[@]}"
do
  matmult_c.gcc nkm $i $i $i
done
echo "\nend matmult_nkm\n"

echo "\nstart matmult_kmn\n"
for i in "${arr[@]}"
do
  matmult_c.gcc kmn $i $i $i
done
echo "\nend matmult_kmn\n"

echo "\nstart matmult_knm\n"
for i in "${arr[@]}"
do
  matmult_c.gcc knm $i $i $i
done
echo "\nend matmult_knm\n"

##
echo "\nstart matmult_blk_36\n"
for i in "${arr[@]}"
do
  matmult_c.gcc blk $i $i $i 36
done
echo "\nend matmult_blk_36\n"

echo "\nstart matmult_blk_103\n"
for i in "${arr[@]}"
do
  matmult_c.gcc blk $i $i $i 103
done
echo "\nend matmult_blk_103\n"

echo "\nstart matmult_blk_1103\n"
for i in "${arr[@]}"
do
  matmult_c.gcc blk $i $i $i 1103
done
echo "\nend matmult_blk_1103\n"


echo "\n end of performance tests\n"

## create data file
module load python3/3.6.0
b='.out'
c=$filename$LSB_JOBID$b
python3 get_performance.py $c ./out/ matmult_nat $LSB_JOBID
python3 get_performance.py $c ./out/ matmult_lib $LSB_JOBID

python3 get_performance.py $c ./out/ matmult_mnk $LSB_JOBID
python3 get_performance.py $c ./out/ matmult_mkn $LSB_JOBID
python3 get_performance.py $c ./out/ matmult_nkm $LSB_JOBID
python3 get_performance.py $c ./out/ matmult_kmn $LSB_JOBID
python3 get_performance.py $c ./out/ matmult_knm $LSB_JOBID
python3 get_performance.py $c ./out/ matmult_nmk $LSB_JOBID

python3 get_performance.py $c ./out/ matmult_blk_36 $LSB_JOBID
python3 get_performance.py $c ./out/ matmult_blk_103 $LSB_JOBID
python3 get_performance.py $c ./out/ matmult_blk_1103 $LSB_JOBID


