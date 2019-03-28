#!/bin/bash
#$ -N run_build
#$ -pe smp 6
#$ -l h_vmem=6G


mkdir index

infile = splitted.fa
outfile = index/IDX


build -f $infile -o $outfile