#!/usr/bin/bash -l
#SBATCH --job-name=mx_nonpareil
#SBATCH --output=joblogs/job_%j_%x_%a.out
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --account=root
#SBATCH --partition=zen3,zen5,zen3x,zen5x,gpu-a10
#SBATCH --qos=fastq
#SBATCH --time=0-00:10:00
#SBATCH --array=0-1020

# Exit on first error and if any variables are unset
set -euo pipefail

output_dir="output/"

# Run a script for all files in a folder
FILES=(fastq/*.fastq)

input_file="${FILES[$SLURM_ARRAY_TASK_ID]}"
sampleid="$(basename "$input_file" | cut -d. -f1)"
mkdir -p "${output_dir}/${sampleid}"

apptainer run \
  -B /projects \
  docker://quay.io/biocontainers/nonpareil:3.5.5--r44h077b44d_2 \
  nonpareil \
  -s "$input_file" \
  -T kmer \
  -f fastq \
  -b "${output_dir}/${sampleid}/${sampleid}" \
  -t "$(nproc)"
