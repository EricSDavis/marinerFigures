#! /bin/bash

## Exit if any command fails
set -e

## Make directory for slurm logs
mkdir -p logs

## Load required modules
module load python/3.7.14

## Create and activate virtual environment with requirements
python3 -m venv env &&\
  source env/bin/activate &&\
  pip3 install snakemake

## Execute workflow
snakemake \
  --cluster "sbatch -J {rule} \
                    --mem={resources.mem} \
                    -t {resources.runtime} \
                    -o logs/{rule}_%j.out \
                    -e logs/{rule}_%j.out" \
  -j 100 \
  --rerun-incomplete