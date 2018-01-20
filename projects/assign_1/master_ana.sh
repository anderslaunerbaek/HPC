#!/bin/bash

filename='project_1'

## cluster setup
#BSUB -J project_1
#BSUB -o project_1%J.out
#BSUB -q hpcintro
## set wall time hh:mm
#BSUB -W 10:30 
#BSUB -R "rusage[mem=2048MB]"
## set number of cores
#BSUB -n 1

##  load modules
module load gcc
module load studio
module load python3/3.6.0
## module load studio

## print test environment
echo "CPU information"
lscpu


## delete pre analysis
rm -fr analysis/*

export MFLOPS_MAX_IT=10

arr=(50 850 1600)

echo "\nnow ready for performance test\n"
echo "matmult_c.gcc nat"
for i in "${arr[@]}"
do
    collect -o ./analysis/test.nat.1.er -p on -S on -h dch -h dcm -h l2h -h l2m matmult_c.gcc nat $i $i $i
done
er_print -func ./analysis/test.nat.1.er > ./analysis_out/test.nat.1.$LSB_JOBID.txt
er_print -func ./analysis/test.nat.2.er > ./analysis_out/test.nat.2.$LSB_JOBID.txt
er_print -func ./analysis/test.nat.3.er > ./analysis_out/test.nat.3.$LSB_JOBID.txt
python3 get_analysis.py ./analysis_out/test.nat $LSB_JOBID matmult_nat 3

echo "matmult_c.gcc lib"
for i in "${arr[@]}"
do
    collect -o ./analysis/test.lib.1.er -p on -S on -h dch -h dcm -h l2h -h l2m matmult_c.gcc lib $i $i $i
done
er_print -func ./analysis/test.lib.1.er > ./analysis_out/test.lib.1.$LSB_JOBID.txt
er_print -func ./analysis/test.lib.2.er > ./analysis_out/test.lib.2.$LSB_JOBID.txt
er_print -func ./analysis/test.lib.3.er > ./analysis_out/test.lib.3.$LSB_JOBID.txt
python3 get_analysis.py ./analysis_out/test.lib $LSB_JOBID matmult_lib 3

echo "matmult_c.gcc blk36"
for i in "${arr[@]}"
do
    collect -o ./analysis/test.blk36.1.er -p on -S on -h dch -h dcm -h l2h -h l2m matmult_c.gcc blk $i $i $i 36
done
er_print -func ./analysis/test.blk36.1.er > ./analysis_out/test.blk36.1.$LSB_JOBID.txt
er_print -func ./analysis/test.blk36.2.er > ./analysis_out/test.blk36.2.$LSB_JOBID.txt
er_print -func ./analysis/test.blk36.3.er > ./analysis_out/test.blk36.3.$LSB_JOBID.txt
python3 get_analysis.py ./analysis_out/test.blk36 $LSB_JOBID matmult_blk 3

echo "matmult_c.gcc blk103"
for i in "${arr[@]}"
do
    collect -o ./analysis/test.blk103.1.er -p on -S on -h dch -h dcm -h l2h -h l2m matmult_c.gcc blk $i $i $i 103
done
er_print -func ./analysis/test.blk103.1.er > ./analysis_out/test.blk103.1.$LSB_JOBID.txt
er_print -func ./analysis/test.blk103.2.er > ./analysis_out/test.blk103.2.$LSB_JOBID.txt
er_print -func ./analysis/test.blk103.3.er > ./analysis_out/test.blk103.3.$LSB_JOBID.txt
python3 get_analysis.py ./analysis_out/test.blk103 $LSB_JOBID matmult_blk 3

echo "matmult_c.gcc blk1103"
for i in "${arr[@]}"
do
    collect -o ./analysis/test.blk1103.1.er -p on -S on -h dch -h dcm -h l2h -h l2m matmult_c.gcc blk $i $i $i 1103
done
er_print -func ./analysis/test.blk1103.1.er > ./analysis_out/test.blk1103.1.$LSB_JOBID.txt
er_print -func ./analysis/test.blk1103.2.er > ./analysis_out/test.blk1103.2.$LSB_JOBID.txt
er_print -func ./analysis/test.blk1103.3.er > ./analysis_out/test.blk1103.3.$LSB_JOBID.txt
python3 get_analysis.py ./analysis_out/test.blk1103 $LSB_JOBID matmult_blk 3

## permutations
echo "matmult_c.gcc mkn"
for i in "${arr[@]}"
do
    collect -o ./analysis/test.mkn.1.er -p on -S on -h dch -h dcm -h l2h -h l2m matmult_c.gcc mkn $i $i $i
done
er_print -func ./analysis/test.mkn.1.er > ./analysis_out/test.mkn.1.$LSB_JOBID.txt
er_print -func ./analysis/test.mkn.2.er > ./analysis_out/test.mkn.2.$LSB_JOBID.txt
er_print -func ./analysis/test.mkn.3.er > ./analysis_out/test.mkn.3.$LSB_JOBID.txt
python3 get_analysis.py ./analysis_out/test.mkn $LSB_JOBID matmult_mkn 3

echo "matmult_c.gcc nmk"
for i in "${arr[@]}"
do
    collect -o ./analysis/test.nmk.1.er -p on -S on -h dch -h dcm -h l2h -h l2m matmult_c.gcc nmk $i $i $i
done
er_print -func ./analysis/test.nmk.1.er > ./analysis_out/test.nmk.1.$LSB_JOBID.txt
er_print -func ./analysis/test.nmk.2.er > ./analysis_out/test.nmk.2.$LSB_JOBID.txt
er_print -func ./analysis/test.nmk.3.er > ./analysis_out/test.nmk.3.$LSB_JOBID.txt
python3 get_analysis.py ./analysis_out/test.nmk $LSB_JOBID matmult_nmk 3

echo "matmult_c.gcc nkm"
for i in "${arr[@]}"
do
    collect -o ./analysis/test.nkm.1.er -p on -S on -h dch -h dcm -h l2h -h l2m matmult_c.gcc nkm $i $i $i
done
er_print -func ./analysis/test.nkm.1.er > ./analysis_out/test.nkm.1.$LSB_JOBID.txt
er_print -func ./analysis/test.nkm.2.er > ./analysis_out/test.nkm.2.$LSB_JOBID.txt
er_print -func ./analysis/test.nkm.3.er > ./analysis_out/test.nkm.3.$LSB_JOBID.txt
python3 get_analysis.py ./analysis_out/test.nkm $LSB_JOBID matmult_nkm 3

echo "matmult_c.gcc mnk"
for i in "${arr[@]}"
do
    collect -o ./analysis/test.mnk.1.er -p on -S on -h dch -h dcm -h l2h -h l2m matmult_c.gcc mnk $i $i $i
done
er_print -func ./analysis/test.mnk.1.er > ./analysis_out/test.mnk.1.$LSB_JOBID.txt
er_print -func ./analysis/test.mnk.2.er > ./analysis_out/test.mnk.2.$LSB_JOBID.txt
er_print -func ./analysis/test.mnk.3.er > ./analysis_out/test.mnk.3.$LSB_JOBID.txt
python3 get_analysis.py ./analysis_out/test.mnk $LSB_JOBID matmult_mnk 3

echo "matmult_c.gcc knm"
for i in "${arr[@]}"
do
    collect -o ./analysis/test.knm.1.er -p on -S on -h dch -h dcm -h l2h -h l2m matmult_c.gcc knm $i $i $i
done
er_print -func ./analysis/test.knm.1.er > ./analysis_out/test.knm.1.$LSB_JOBID.txt
er_print -func ./analysis/test.knm.2.er > ./analysis_out/test.knm.2.$LSB_JOBID.txt
er_print -func ./analysis/test.knm.3.er > ./analysis_out/test.knm.3.$LSB_JOBID.txt
python3 get_analysis.py ./analysis_out/test.knm $LSB_JOBID matmult_knm 3

echo "matmult_c.gcc kmn"
for i in "${arr[@]}"
do
    collect -o ./analysis/test.kmn.1.er -p on -S on -h dch -h dcm -h l2h -h l2m matmult_c.gcc kmn $i $i $i
done
er_print -func ./analysis/test.kmn.1.er > ./analysis_out/test.kmn.1.$LSB_JOBID.txt
er_print -func ./analysis/test.kmn.2.er > ./analysis_out/test.kmn.2.$LSB_JOBID.txt
er_print -func ./analysis/test.kmn.3.er > ./analysis_out/test.kmn.3.$LSB_JOBID.txt
python3 get_analysis.py ./analysis_out/test.kmn $LSB_JOBID matmult_kmn 3


## delete pre analysis
rm -fr analysis/*
echo "\n end of performance test\n"

