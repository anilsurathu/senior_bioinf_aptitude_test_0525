#grab the micromamba base image
FROM mambaorg/micromamba:2.3.0 as conda_base

#using root to install dependencies
USER root

#install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    cmake \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    default-jre \
    unzip \
    procps \
    && rm -rf /var/lib/apt/lists/*

#switch to default micromamba user
USER $MAMBA_USER

#create conda env with necessary tools to run the pipeline
RUN micromamba create -n genome_assembly -c conda-forge -c bioconda \
    fastqc=0.12.1 \
    trim-galore=0.6.10 \
    megahit=1.2.9 \
    seqfu=1.20.3 \
    && micromamba clean --all --yes

#setting environment variables
ENV PATH="/opt/conda/envs/genome_assembly/bin:$PATH"
ENV MAMBA_ROOT_PREFIX="/opt/conda"

# Create working directories
WORKDIR /genome_assembly
RUN mkdir -p /genome_assembly/input /genome_assembly/output

# Create the assembly script
COPY <<EOF /genome_assembly/assembly-pipeline.sh
#!/bin/bash
set -e

#parameter expansion with default values
IN_DIR=\${IN_DIR:-"/genome_assembly/input"}
OUT_DIR=\${OUT_DIR:-"/genome_assembly/output"}
FOR=\${FOR:-"FILE_1.fastq.gz"}
REV=\${REV:-"FILE_2.fastq.gz"}

echo "Starting genome assembly:"
echo "Input directory: \$IN_DIR"
echo "Output directory: \$OUT_DIR"
echo "Forward reads: \$FOR"
echo "Reverse reads: \$REV"

#activate conda environment
eval "\$(micromamba shell hook --shell bash)"
micromamba activate genome_assembly

#check if input exist
if [[ ! -f "\$IN_DIR/\$FOR" ]]; then
    echo "Error: Forward reads file \$IN_DIR/\$FOR not found!"
    exit 1
fi

if [[ ! -f "\$IN_DIR/\$REV" ]]; then
    echo "Error: Reverse reads file \$IN_DIR/\$REV not found!"
    exit 1
fi

#run fastqc to perform QC
echo "Running FastQC quality control..."
mkdir -p \$OUT_DIR/fastqc
fastqc \$IN_DIR/\$FOR \$IN_DIR/\$REV -o \$OUT_DIR/fastqc

#trim reads using TrimGalore. 
echo "Trimming with TrimGalore..."
mkdir -p \$OUT_DIR/trimgalore
trim_galore --paired -o \$OUT_DIR/trimgalore \$IN_DIR/\$FOR \$IN_DIR/\$REV

#megahit assembly
echo "Assembling genome with MEGAHIT..."
echo "\$OUT_DIR/trimgalore/\${REV%%.*}_val_2.fq.gz"
megahit -1 \$OUT_DIR/trimgalore/\${FOR%%.*}_val_1.fq.gz -2 \$OUT_DIR/trimgalore/\${REV%%.*}_val_2.fq.gz -o \$OUT_DIR/megahit

# Create summary statistics for assembled genome
echo "assembly statistics..."
seqfu stats \$OUT_DIR/megahit/final.contigs.fa >> \$OUT_DIR/final_stats.tsv

echo "Pipeline completed successfully!"
echo "Results are available in: \$OUT_DIR"
EOF

USER root
#set exec perms on the script. 
RUN chmod +x /genome_assembly/assembly-pipeline.sh
USER $MAMBA_USER

#run pipeline script by default 
CMD ["/genome_assembly/assembly-pipeline.sh"]

# Metadata
# LABEL maintainer="Bioinformatics Pipeline"
# LABEL description="Docker container for genome assembly pipeline with FastQC, TrimGalore, MEGAHIT, and SeqFu"
# LABEL version="1.0"