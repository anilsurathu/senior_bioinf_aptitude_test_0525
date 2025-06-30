# Senior Bioinformatician Aptitude Test May 2025

## Solution
- Implemented the pipeline to run on Docker (Dockerfile included) using micromamba image. 
- Docker script handles installation of tools and dependencies in micromamba environment. 
- Install Docker engine: https://docs.docker.com/engine/install/
- On your local computer, create a run folder named *genome-assembly* and copy Dockerfile there and create two subfolders named *input* and *output*. 
- Place both fastq.gz files in *input* folder. 
- To build the Docker image, cd into the folder where Dockerfile is present and run the following command. This will build the container with necessary tools to run the pipeline. 
```
docker build -t genome-assembly-pipeline .
```
- To run the pipeline use the following command. Make sure to change input and output paths to match your set up. On my machine the run folder is located at *C:\genome-assembly*.
```
docker run -e FOR="SRR33608272_1.fastq.gz" -e REV="SRR33608272_2.fastq.gz" -v C:\genome-assembly\input:/genome_assembly/input -v C:\genome-assembly\output:/genome_assembly/output genome-assembly-pipeline
```
- Intermediate files and results will be saved to *output* folder. 
- I test this on Windows 11 using Docker Desktop. My *output* folder is commited to this repo as well as the Docker script. 
- Assembled contigs can be found in *output/megahit/final.contigs.fa*.
- Thank you for the opportunity and happy testing!

 > **Amendment** There was a mistake in the task below as you cannot make a forked repo private. Please clone this repo and create a new repo on your own GitHub account instead.
```
git clone --bare https://github.com/quadram-institute-bioscience/senior_bioinf_aptitude_test_0525.git
cd senior_bioinf_aptitude_test_0525
git push --mirror https://github.com/yourname/private-repo.git
```
 
This is the aptitude test for the position of Senior Bioinformatician at the Quadram Institute. Post number 1004878,
All rights reserved.
## Overview
A researcher has acquired some new sequencing data from an experiment looking into a viral genome.
The researcher has assembled genomes previously by [running a script](assembly-script.sh) on their own laptop.
They have requested help in converting their de novo assembly script to something that can be easily ran on the institute's Cloud or HPC services.
You can use as an example dataset the following sequencing run available on SRA : [SRR33608272](https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&acc=SRR33608272&display=metadata) 
## Task
You have until Midnight Friday 27th June to complete the following task.
1)	Clone this GitHub Repository with the analysis script and download the data.
3)	Make a private repo with this data.
4)	Convert the analysis script into a portable pipeline using whichever technologies you deem appropriate, such as:
- Virtual environments
- Containerisation
- Workflow managers
5)	Outline any steps required to setup and run the analysis e.g:
- Build docker/singularity container(s) from definition file(s)
- Install prerequisites
- Command to start analysis
6)	When you are finished, add Sam Haynes (@DimmestP) as a contributor to your repository who will test that your solution outputs the same files as the script. https://github.com/DimmestP
