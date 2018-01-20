#!/bin/bash

filename='project_2'

## cluster setup
#BSUB -J project_2
#BSUB -o project_2%J.out
#BSUB -q hpcintro
## set wall time hh:mm
#BSUB -W 40 
#BSUB -R "rusage[mem=2048MB] span[hosts=1]"
## set number of cores
#BSUB -n 24

##  load modules
module load studio


# keep idle threads spinning (needed to monitor idle times!)
export OMP_WAIT_POLICY=active


## print test environment
echo "CPU information"
lscpu

## declare an array variable
n_core=(1 2 4 8 12 16 20 24)
arr=(128 256)
max_iter=5000000;
d=0.0000000001;

## data dir
mkdir -p analysis
rm -rf analysis/*


echo "\nnow ready for performance tests\n"

echo "\nstart program_gauss_con\n"
for nn in "${arr[@]}"
do
	./program_gauss_con $nn $max_iter $d
	
done
echo "\nend program_gauss_con\n"

echo "\nstart program_jac_seq_con\n"
for nn in "${arr[@]}"
do
	./program_jac_seq_con $nn $max_iter $d
	
done
echo "\nend program_jac_seq_con\n"

## new make limit
max_iter=5000;
arr=(256 512 1024 2048)


##echo "\nstart program_gauss\n"
##for nn in "${arr[@]}"
##do
##	./program_gauss $nn $max_iter $d
##done
##echo "\nend program_gauss\n"

##echo "\nstart program_jac_seq\n"
##for nn in "${arr[@]}"
##do
##	./program_jac_seq $nn $max_iter $d
##done
##echo "\nend program_jac_seq\n"

echo "\nstart program_jac_mp\n"
for i in "${n_core[@]}"
do
	for nn in "${arr[@]}"
	do
		OMP_NUM_THREADS=$i ./program_jac_mp $nn $max_iter $d
	done
done
echo "\nend program_jac_mp\n"

echo "\nstart program_jac_mp_v2\n"
for i in "${n_core[@]}"
do
	for nn in "${arr[@]}"
	do
		OMP_NUM_THREADS=$i ./program_jac_mp_v2 $nn $max_iter $d
	done
done
echo "\nend program_jac_mp_v2\n"

echo "\nstart program_jac_mp_v3\n"
for i in "${n_core[@]}"
do
	for nn in "${arr[@]}"
	do
		OMP_NUM_THREADS=$i ./program_jac_mp_v3 $nn $max_iter $d
	done
done
echo "\nend program_jac_mp_v3\n"


## 
nn=1024;

echo "\nstart program_jac_mp_SP\n"
for i in "${n_core[@]}"
do
	OMP_NUM_THREADS=$i ./program_jac_mp $nn $max_iter $d
done
echo "\nend program_jac_mp_SP\n"

echo "\nstart program_jac_mp_v2_SP\n"
for i in "${n_core[@]}"
do
	OMP_NUM_THREADS=$i ./program_jac_mp_v2 $nn $max_iter $d
done
echo "\nend program_jac_mp_v2_SP\n"

echo "\nstart program_jac_mp_v3_SP\n"
for i in "${n_core[@]}"
do
	OMP_NUM_THREADS=$i ./program_jac_mp_v3 $nn $max_iter $d
done
echo "\nend program_jac_mp_v3_SP\n"

echo "\nstart program_mandel\n"
for i in "${n_core[@]}"
do
	OMP_NUM_THREADS=$i ./program_mandel $nn $max_iter
done
echo "\nend program_mandel\n"



echo "\nstart program_jac_mp_SP_non\n"
for i in "${n_core[@]}"
do
	OMP_NUM_THREADS=$i ./program_jac_mp_non $nn $max_iter $d
done
echo "\nend program_jac_mp_SP_non\n"

echo "\nstart program_jac_mp_v2_SP_non\n"
for i in "${n_core[@]}"
do
	OMP_NUM_THREADS=$i ./program_jac_mp_v2_non $nn $max_iter $d
done
echo "\nend program_jac_mp_v2_SP_non\n"

echo "\nstart program_jac_mp_v3_SP_non\n"
for i in "${n_core[@]}"
do
	OMP_NUM_THREADS=$i ./program_jac_mp_v3_non $nn $max_iter $d
done
echo "\nend program_jac_mp_v3_SP_non\n"

echo "\nstart program_mandel_non\n"
for i in "${n_core[@]}"
do
	OMP_NUM_THREADS=$i ./program_mandel_non $nn $max_iter
done
echo "\nend program_mandel_non\n"


arr=(256 512 1024 2048)
for nn in "${arr[@]}"
do
	echo "\nstart program_jac_mp_SP_$nn\n"
	for i in "${n_core[@]}"
	do
		OMP_NUM_THREADS=$i ./program_jac_mp $nn $max_iter $d
	done
	echo "\nend program_jac_mp_SP_$nn\n"

	echo "\nstart program_jac_mp_v2_SP_$nn\n"
	for i in "${n_core[@]}"
	do
		OMP_NUM_THREADS=$i ./program_jac_mp_v2 $nn $max_iter $d
	done
	echo "\nend program_jac_mp_v2_SP_$nn\n"

	echo "\nstart program_jac_mp_v3_SP_$nn\n"
	for i in "${n_core[@]}"
	do
		OMP_NUM_THREADS=$i ./program_jac_mp_v3 $nn $max_iter $d
	done
	echo "\nend program_jac_mp_v3_SP_$nn\n"
done


echo "\n end of performance tests\n"



## create data file
module load python3/3.6.0
module load matplotlib/2.0.2-python-3.6.2

b='.out'
c=$filename$LSB_JOBID$b
##python3 get_performance.py $c ./analysis/ program_gauss $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_gauss_con $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_v2 $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_v3 $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_SP $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_v2_SP $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_v3_SP $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_mandel $LSB_JOBID

python3 get_performance.py $c ./analysis/ program_jac_mp_SP_non $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_v2_SP_non $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_v3_SP_non $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_mandel_non $LSB_JOBID

##python3 get_performance.py $c ./analysis/ program_jac_seq $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_seq_con $LSB_JOBID


python3 get_performance.py $c ./analysis/ program_jac_mp_SP_256 $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_SP_512 $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_SP_1024 $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_SP_2048 $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_v2_SP_256 $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_v2_SP_512 $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_v2_SP_1024 $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_v2_SP_2048 $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_v3_SP_256 $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_v3_SP_512 $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_v3_SP_1024 $LSB_JOBID
python3 get_performance.py $c ./analysis/ program_jac_mp_v3_SP_2048 $LSB_JOBID


## 
python3 get_vis.py ./analysis/gaus_con.txt
python3 get_vis.py ./analysis/jac_con.txt


## delete
rm -rf ./analysis/gaus_con.txt
rm -rf ./analysis/jac_con.txt

rm -rf ./analysis/program_mandel_non_*.txt
rm -rf ./analysis/program_jac_mp_SP_256_*.txt
rm -rf ./analysis/program_jac_mp_SP_512_*.txt
rm -rf ./analysis/program_jac_mp_SP_1024_*.txt
rm -rf ./analysis/program_jac_mp_SP_2048_*.txt

rm -rf ./analysis/program_jac_mp_v2_SP_256_*.txt
rm -rf ./analysis/program_jac_mp_v2_SP_512_*.txt
rm -rf ./analysis/program_jac_mp_v2_SP_1024_*.txt
rm -rf ./analysis/program_jac_mp_v2_SP_2048_*.txt

rm -rf ./analysis/program_jac_mp_v3_SP_256_*.txt
rm -rf ./analysis/program_jac_mp_v3_SP_512_*.txt
rm -rf ./analysis/program_jac_mp_v3_SP_1024_*.txt
rm -rf ./analysis/program_jac_mp_v3_SP_2048_*.txt

rm -rf ./analysis/program_jac_mp_SP_non_*.txt
rm -rf ./analysis/program_jac_mp_v2_SP_non_*.txt
rm -rf ./analysis/program_jac_mp_v3_SP_non_*.txt


rm -rf ./analysis/program_jac_mp_SP_ncore_*.txt
rm -rf ./analysis/program_jac_mp_v2_SP_ncore_*.txt
rm -rf ./analysis/program_jac_mp_v3_SP_ncore_*.txt
