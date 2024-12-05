#!/usr/bin/env bash

conda create --name dempo_env

mamba activate dempo_env

# https://github.com/nanoporetech/ont_fast5_api
mamba install -c conda-forge ont-fast5-api

# Conviertir los archivos .fast5 de multi-read a single-read
multi_to_single_fast5 --input_path /Dempo/raw_fast5 \
--save_path /Dempo/single_fast5 \
--threads 4

pip install --upgrade pip

mamba install python=3.11

mamba install -c conda-forge edlib networkx "numpy<2" "pandas<3" pysam python-dateutil requests toml tqdm wheel python=3.11

pip install fast-ctc-decode

sudo apt install build-essential

sudo apt install zlib1g-dev

pip install mappy ont-remora

# https://github.com/nanoporetech/bonito
pip install ont-bonito

find /Dempo/single_fast5 -type f -name "*.fast5" -exec mv {} /Dempo/flattened_fast5/ \;

bonito basecaller dna_r10.4.1_e8.2_400bps_hac@v5.0.0 /Dempo/flattened_fast5 > /Dempo/output_fastq/output.fastq

sed -E 's/^>([^ ]+).*/>\1/' input.fasta > simplified_output.fasta

mamba install -c bioconda clustalo

awk '/^>/{print ">" $2; next}{print}' output.fasta > simplified_output.fasta

# https://github.com/GSLBiotech/clustal-omega
mamba install -c bioconda clustalo

clustalo -i output.fasta -t DNA --profile1 pFRT_LacZEO_Plasmid_Empty_Vector.fa -o aligned_output.fasta --outfmt fasta --threads 16
mafft --add simplified_output.fasta --reorder --thread 16 pFRT_LacZEO_Plasmid_Empty_Vector.fa > aligned_output.fasta