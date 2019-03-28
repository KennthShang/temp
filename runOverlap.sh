#!/bin/bash
#$ -N run_Overlap
#$ -pe smp 6
#$ -l h_vmem=6G


mkdir index

samfile = ../result_mapped.sam
infile = splitted.fa
indexfile = index/IDX


overlap -S $samfile -x $indexfile -f infile -c 180 -o virus_recruit.fa