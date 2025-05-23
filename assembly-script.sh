IN_DIR="PATH/TO/MY/DIRECTORY"
OUT_DIR="$IN_DIR/OUTPUT"
FOR="FILE_1.fastq.gz"
REV="FILE_2.fastq.gz"

# Check quality of raw reads
# https://github.com/s-andrews/FastQC
# Output is a .html file
mkdir -p $OUT_DIR/1.FastQC
fastqc $FOR $REV -o $OUT_DIR/1.FastQC

# Trim reads with poor basecalling scores
# https://github.com/FelixKrueger/TrimGalore
# Output is a .fastq file
trim_galore --paired -o $OUT_DIR/2.trimmed-reads $FOR $REV

# Assemble genome
# https://github.com/voutcn/megahit
# Output is .fa files for final and intemediate contigs
megahit -1 $OUT_DIR/2.trimmed-reads/${FOR%%.*}_val_1.fq.gz -2 $OUT_DIR/2.trimmed-reads/${REV%%.*}_val_2.fq.gz -o $OUT_DIR/3.assemblies

# Create summary statistics for assembled genome
# https://telatin.github.io/seqfu2/
# Output is a .tsv file
seqfu stats $OUT_DIR/3.assemblies/final.contigs.fa >> $OUT_DIR/final_stats.tsv
