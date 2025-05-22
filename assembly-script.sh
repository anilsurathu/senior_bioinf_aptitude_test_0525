# Check quality of raw reads
# https://github.com/s-andrews/FastQC
# Output is a .html file
fastqc data/illumina_reads_R1.fastq
fastqc data/illumina_reads_R2.fastq

# Trim reads with poor basecalling scores
# https://github.com/FelixKrueger/TrimGalore
# Output is a .fastq file
trim-galore data/illumina_reads_R1.fastq
trim-galore data/illumina_reads_R2.fastq

# Assemble genome
# https://github.com/voutcn/megahit
# Output is .fa files for final and intemediate contigs
megahit -1 trimmed_reads_R1.fastq -2 trimmed_reads_R1.fastq -o out

# Create summary statistics for assembled genome
# https://telatin.github.io/seqfu2/
# Output is a .tsv file
seqfu stats final.contigs.fa
