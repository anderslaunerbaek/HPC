#!/bin/bash
# 02614 - High-Performance Computing, January 2018
#
# Author: Anders <s160159@student.dtu.dk>
#
# Note: 
#
##BSUB -J collector
##BSUB -q hpcintro
##BSUB -n 4
##BSUB -W 15

## load modules 
module load studio

# define the executable here
EXECUTABLE=mandelbrot

# define any command line options for your executable here
# EXECOPTS=

# set some OpenMP variables here
#
# no. of threads
## export OMP_NUM_THREADS=$LSB_DJOB_NUMPROC
#
# keep idle threads spinning (needed to monitor idle times!)
export OMP_WAIT_POLICY=active
#
# if you use a runtime schedule, define it below
# export OMP_SCHEDULE=


### experiment name 
##JID=${LSB_JOBID}
##EXPOUT="$LSB_JOBNAME.${JID}.er"

### start the collect command with the above settings
##collect -o $EXPOUT ./$EXECUTABLE $EXECOPTS

OMP_NUM_THREADS=1 ./mandelbrot
OMP_NUM_THREADS=2 ./mandelbrot
OMP_NUM_THREADS=3 ./mandelbrot
OMP_NUM_THREADS=4 ./mandelbrot
OMP_NUM_THREADS=5 ./mandelbrot
OMP_NUM_THREADS=6 ./mandelbrot
OMP_NUM_THREADS=7 ./mandelbrot
OMP_NUM_THREADS=8 ./mandelbrot

OMP_NUM_THREADS=12 ./mandelbrot
OMP_NUM_THREADS=16 ./mandelbrot
OMP_NUM_THREADS=20 ./mandelbrot
