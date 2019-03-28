#!/bin/bash
#$ -N run_Bowtie
#$ -pe smp 6
#$ -l h_vmem=6G


infile = splitted.fa
bow_outfile = result.sam
sam_outfile = result_mapped.sam

bowtie2 -x ../index/IDX -f $infile --score-min L,0,-0.05 -t -p 4 -S $outfile
samtools view -F 4 $outfile >$sam_outfile