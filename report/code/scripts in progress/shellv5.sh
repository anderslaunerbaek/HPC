#!/bin/bash

module load studio

export MFLOPS_MAX_IT=4

arr=(50 850 1600)

echo "\nnow ready for performance test\n"

echo "\nstart matmult_lib\n"
for i in "${arr[@]}"
do
    matmult_c.gcc lib $i $i $i
    collect -o test.lib.1.er -p on -S on -h dch -h dcm -h l2h -h l2m matmult_c.gcc lib $i $i $i
done
echo "\nend matmult_lib\n"

er_print -func test.lib.1.er > test.lib.1.txt
er_print -func test.lib.2.er > test.lib.2.txt
er_print -func test.lib.3.er > test.lib.3.txt


echo "\n end of performance test\n"


