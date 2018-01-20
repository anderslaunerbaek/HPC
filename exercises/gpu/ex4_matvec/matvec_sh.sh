#!/bin/bash


N=7000
M=7000

echo "Naive"
./naive/matvec $M $N

sleep 5

echo "cuBLAS"
./cuBLAS/matvec $M $N

sleep 5

echo "Naive split"
./naive_split/matvec $M $N
