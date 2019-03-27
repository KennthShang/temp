#!/bin/bash -x
# Overlap parameter used for the final assembly. This is the only argument
# to the script
OL=75

# The number of threads to use
CPU=2

# To save memory, we index $D reads at a time then merge the indices together
D=4000000

# Correction k-mer value
CORRECTION_K=41

# The minimum k-mer coverage for the filter step. Each 27-mer
# in the reads must be seen at least this many times
COV_FILTER=2

# Overlap parameter used for FM-merge. This value must be no greater than the minimum
# overlap value you wish to try for the assembly step.
MOL=55

# Parameter for the small repeat resolution algorithm
R=10

# The number of pairs required to link two contigs into a scaffold
MIN_PAIRS=5

# The minimum length of contigs to include in a scaffold
MIN_LENGTH=200

# Distance estimate tolerance when resolving scaffold sequences
SCAFFOLD_TOLERANCE=1

# Turn off collapsing bubbles around indels
MAX_GAP_DIFF=0

# File name
FILE_NAME="../L8_trim30_pe.fastq" 

# Preprocess the data to remove ambiguous basecalls
sga preprocess --pe-mode 0 -o reads.pp.fastq $1
# Build the index that will be used for error correction
sga index -a ropebwt -t $CPU --no-reverse reads.pp.fastq

# Perform k-mer based error correction.
# The k-mer cutoff parameter is learned automatically.
sga correct -k $CORRECTION_K --learn -x 2 -t $CPU -o reads.ec.fastq reads.pp.fastq


# rebuild the index for the reads after correction
sga index -a ropebwt -t $CPU reads.ec.fastq

# Remove exact-match duplicates and reads with low-frequency k-mers
sga filter -x 2 -t $CPU -o reads.ec.f.fastq --homopolymer-check --low-complexity-check reads.ec.fastq

# Merge simple, unbranched chains of vertices
sga fm-merge -m $MOL -t $CPU -o merged.fa reads.ec.f.fastq

# Build an index of the merged sequences
sga index -d 1000000 merged.fa

# Remove any substrings that were generated from the merge process
sga rmdup -t $CPU -o rmdup.fa merged.fa

# Compute the structure of the string graph
sga overlap -m $MOL -t $CPU rmdup.fa
