#!/usr/bin/env bash

# Creando todos los directorios a usar en el proyecto
mkdir -p Dempo/raw_fast5 Dempo/single_fast5 Dempo/flattened_fast5 Dempo/output_fastq

# 1. Conviertir los archivos .fast5 de multi-read a single-read
multi_to_single_fast5 --input_path /Dempo/raw_fast5 \
--save_path /Dempo/single_fast5 \
--threads 4

# 2. Aplanar la estructura de directorios de archivos .fast5
find /Dempo/single_fast5 -type f -name "*.fast5" -exec mv {} /Dempo/flattened_fast5/ \;

# 3. Basecall a los archivos single-read .fast5 para generar archivos .fastq
bonito basecaller dna_r10.4.1_e8.2_400bps_hac@v5.0.0 /Dempo/flattened_fast5 > /Dempo/output_fastq/output.fastq

# 4. Convertir de .fastq a .fasta
seqtk seq -A output.fastq > output.fasta

# 5. Simplificar los headers de las secuencias fasta
sed -E 's/^>([^ ]+).*/>\1/' input.fasta > simplified_output.fasta

# 6. Alinear las secuencias a la secuencia madre 
clustalo -i output.fasta -t DNA --profile1 pFRT_LacZEO_Plasmid_Empty_Vector.fa -o aligned_output.fasta --outfmt fasta --threads 16
mafft --add simplified_output.fasta --reorder --thread 16 pFRT_LacZEO_Plasmid_Empty_Vector.fa > aligned_output.fasta