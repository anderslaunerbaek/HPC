#!/bin/bash
#BSUB -J sleeper
#BSUB -o sleeper_%J.out
###BSUB -e sleeper_%J.err
#BSUB -q hpcintro
#BSUB -W 2 -R "rusage[mem=512MB]"



echo "Just a minute ..."
sleep 60
