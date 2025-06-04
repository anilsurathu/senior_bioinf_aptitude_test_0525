# Senior Bioinformatician Aptitude Test May 2025
This is the aptitude test for the position of Senior Bioinformatician at the Quadram Institute. Post number 1004878,
All rights reserved.
## Overview
A researcher has acquired some new sequencing data from an experiment looking into a viral genome.
The researcher has assembled genomes previously by [running a script](assembly-script.sh) on their own laptop.
They have requested help in converting their de novo assembly script to something that can be easily ran on the institute's Cloud or HPC services.
You can use as an example dataset the following sequencing run available on SRA : [SRR33608272](https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&acc=SRR33608272&display=metadata) 
## Task
You have until Midnight Friday 27th June to complete the following task.
1)	Fork this GitHub Repository with the analysis script and download the data.
3)	Make your fork private.
4)	Convert the analysis script into a portable pipeline using whichever technologies you deem appropriate, such as:
- Virtual environments
- Containerisation
- Workflow managers
5)	Outline any steps required to setup and run the analysis e.g:
- Build docker/singularity container(s) from definition file(s)
- Install prerequisites
- Command to start analysis
6)	When you are finished, add Sam Haynes (@DimmestP) as a contributor to your repository who will test that your solution outputs the same files as the script. https://github.com/DimmestP
