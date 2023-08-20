#!/usr/bin/env python3

rule all:
  input:
    "data/diffLoops72vs0.rds",
    "data/pixelMats.h5",
    "data/pixelMats.rds",
    "data/pixelPileup.rds",
    "data/domainPileup.rds",
    "data/diffBoundaries.rds",
    "plots/pileupPlotExamples.pdf"

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

## Create pixel pileup matrix
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

## Create domain pileup matrix
rule domainPileup:
  input:
    "data/raw/hic/MEGA_K562_WT_inter.hic",
	  "data/diffLoops72vs0.rds",
	  "scripts/pileupDomains.R"
  output:
	  "data/domainPileup.rds"
  resources:
    runtime='2h',
    mem='16GB'
  shell:
    """
    module load r/4.3.1;
    Rscript scripts/pileupDomains.R
    """

## Create diff boundary pileup matrix
rule boundaryPileup:
  input:
    "data/raw/hic/MEGA_K562_WT_0_inter.hic",
    "data/raw/hic/MEGA_K562_WT_4320_inter.hic",
    "data/diffLoops72vs0.rds",
    "scripts/pileupBoundaries.R"
  output:
	  "data/diffBoundaries.rds"
  resources:
    runtime='4h',
    mem='16GB'
  shell:
    """
    module load r/4.3.1;
    Rscript scripts/pileupBoundaries.R
    """

## Create pileup plot example figure
rule pileupPlotExample:
  input:
    "data/pixelPileup.rds",
    "data/domainPileup.rds",
    "data/diffBoundaries.rds"
  output:
    "plots/pileupPlotExamples.pdf"
  resources:
    runtime='1m',
    mem='2GB'
  shell:
    """
    module load r/4.3.1
    Rscript scripts/pileupPlotExamples.R
    """
