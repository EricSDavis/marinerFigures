## Example pileup plots
## pileupPixels
## pileupDomains
## pileupBoundaries

## p=0.05, lfc=1.5

## Required packages
library(mariner)
library(data.table)

## Read in loops
## Suppress warning about row names
loops <- 
  fread("data/raw/loops/mergedLoops.txt", drop=1) |>
  as_ginteractions() |>
  suppressWarnings()

## Do differential analysis

