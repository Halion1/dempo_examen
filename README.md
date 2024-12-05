# README del Examen de Dempo

Este examen consistió en procesar los archivos de salida de los 7 secuenciadores Oxford Nanopore, en formato `.fast5`, y alinearlos con la secuencia de referencia.

## 1. Archivos iniciales

### Archivos a alinear:

- `FAS72576_pass_0d9062c8_06b43263_0.fast5`
- `FAS72576_pass_0d9062c8_06b43263_1.fast5`
- `FAS72576_pass_0d9062c8_06b43263_2.fast5`
- `FAS72576_pass_0d9062c8_06b43263_3.fast5`
- `FAS72576_pass_0d9062c8_06b43263_4.fast5`
- `FAS72576_pass_0d9062c8_06b43263_5.fast5`
- `FAS72576_pass_0d9062c8_06b43263_6.fast5`

### Secuencia de referencia:

- `pFRT LacZEO Plasmid + Empty Vector.fa`

## 2. Pasos del flujo de trabajo

1. **Creación del entorno Mamba**: Configuración de un entorno en Mamba para instalar las bibliotecas necesarias para el proyecto.
2. **Conversión de multi-read `.fast5` a single-read `.fast5`**: Utilización de la herramienta `ont-fast5-api` para dividir los archivos multi-read en archivos single-read `.fast5` que puedan ser procesados en los siguientes pasos.
3. **Generación de archivos `.fastq` mediante Bonito**: Uso de `bonito` para convertir los archivos single-read `.fast5` en archivos `.fastq` para el alineamiento.
4. **Conversión de `.fastq` a `.fasta` con Seqtk**: Empleo de `seqtk` para transformar los archivos `.fastq` en `.fasta`, que posteriormente se alinean con la secuencia de referencia utilizando Clustal Omega.
5. **Alineamiento de secuencias con Clustal Omega**: Realización del alineamiento empleando la secuencia de referencia del archivo `pFRT LacZEO Plasmid + Empty Vector.fa`.

## 3. Dependencias clave

Este proyecto utilizó las siguientes dependencias principales:

- `ont-fast5-api`
- `python=3.11`
- `fast-ctc-decode`
- `clustalo`

La lista completa de dependencias está especificada en el archivo `.yml`.

## 4. Archivos incluidos

- **`dempotest_fullshellscript.sh`**: Contiene todos los pasos para reproducir los resultados, incluyendo la instalación de las bibliotecas y la configuración del entorno en Mamba.
- **`dempotest_script.sh`**: Script para el procesamiento de los datos y el código para el alineamiento.
- **`simplified_output.fasta`**: Archivo con las secuencias procesadas listas para alineamiento.
- **`aligned_clustalo.fasta` y `aligned_mafft.fasta`**: Ejemplos de los alineamientos finales obtenidos. Los alineamientos se realizaron con 5 secuencias y la secuencia de referencia, utilizando Clustal Omega y MAFFT respectivamente.

## 5. Recomendaciones

- **Escalabilidad**: Dado el gran volumen de secuencias (26,296), se recomienda realizar el alineamiento en un servidor, en la nube (por ejemplo, Amazon Web Services) o en un sistema de computación de alto rendimiento (HPC). Esto optimizará el tiempo computacional necesario para procesar los datos.
- **Workflows**: Si se utiliza un servidor externo, se sugiere implementar un sistema de gestión de flujos de trabajo como Snakemake o Nextflow para aprovechar de forma eficiente los recursos computacionales y gestionar los archivos de manera organizada.
- **Implementación del workflow**: Para realizar un despliegue eficiente del flujo de trabajo, sería ideal utilizar Docker.