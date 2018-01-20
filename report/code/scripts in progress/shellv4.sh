#!/bin/bash

module load studio

export MFLOPS_MAX_IT=4

arr=(50 850 1600)

echo "\nnow ready for performance test\n"

echo "\nstart matmult_blk\n"
for i in "${arr[@]}"
do
    matmult_c.gcc blk $i $i $i 36
    collect -o test.blk.opt.1.er -p on -S on -h dch -h dcm -h l2h -h l2m matmult_c.gcc blk $i $i $i 36
done
echo "\nend matmult_blk\n"

er_print -func test.blk.opt.1.er > test.blk.opt.1.txt


echo "\n end of performance test\n"


