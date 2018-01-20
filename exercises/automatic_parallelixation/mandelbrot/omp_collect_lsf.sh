#!/bin/bash
# 02614 - High-Performance Computing, January 2018
# 
# batch script to run collect on a decidated server in the hpcintro
# queue
#
# Author: Bernd Dammann <bd@cc.dtu.dk>
#
# Note: to get more cores, change the n value below to the
#       number of cores you want to use.  Later on, use the
#       $LSB_DJOB_NUMPROC variable to use this number, e.g. in
#       export OMP_NUM_THREADS=$LSB_DJOB_NUMPROC
#
#BSUB -J collector
#BSUB -q hpcintro
#BSUB -n 4
#BSUB -W 15


module load studio

# define the executable here
#
EXECUTABLE=./c/mandelbrot

# define any command line options for your executable here
# EXECOPTS=

# set some OpenMP variables here
#
# no. of threads
export OMP_NUM_THREADS=$LSB_DJOB_NUMPROC
#
# keep idle threads spinning (needed to monitor idle times!)
export OMP_WAIT_POLICY=active
#
# if you use a runtime schedule, define it below
# export OMP_SCHEDULE=


# experiment name 
#
JID=${LSB_JOBID}
EXPOUT="$LSB_JOBNAME.${JID}.er"

# start the collect command with the above settings
collect -o $EXPOUT ./$EXECUTABLE $EXECOPTS
