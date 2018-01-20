#!/bin/bash
for(( i = 1000; i <= 400000; i+=10000));
do ./internal 2 $i; 
done