#!/bin/bash
#$ -N run_build
#$ -l h_vmem=6G


mkdir index

infile = splitted.fa
outfile = index/IDX


build -f $infile -o $outfile
