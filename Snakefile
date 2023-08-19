#!/usr/bin/env python3

rule all:
  input:
    "data/diffLoops72vs0.rds",
    "data/pixelMats.h5",
    "data/pixelMats.rds",
    "data/pixelPileup.rds"

## Differential loops between 0 and 72 hours
rule findDiffLoops:
  input:
    "data/raw/loops/mergedLoops.txt",
    "scripts/findDiffLoops.R"
  output:
    "data/diffLoops72vs0.rds"
  resources:
    runtime='10m',
    mem='8GB'
  shell:
    """
    module load r/4.3.1;
    Rscript scripts/findDiffLoops.R
    """

## Extract pixel matrices
rule extractPixelMats:
  input:
    "data/raw/hic/MEGA_K562_WT_inter.hic",
	  "data/diffLoops72vs0.rds",
	  "scripts/extractPixelMats.R"
  output:
    "data/pixelMats.h5",
    "data/pixelMats.rds"
  resources:
    runtime='1h',
    mem='4GB'
  shell:
    """
    module load r/4.3.1;
    Rscript scripts/extractPixelMats.R
    """

## Create pileup matrix
rule pixelPileup:
  input:
    "data/raw/hic/MEGA_K562_WT_inter.hic",
	  "data/diffLoops72vs0.rds",
	  "scripts/pileupPixels.R"
  output:
	  "data/pixelPileup.rds"
  resources:
    runtime='1h',
    mem='16GB'
  shell:
    """
    module load r/4.3.1;
    Rscript scripts/pileupPixels.R
    """
