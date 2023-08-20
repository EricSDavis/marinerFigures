## Load required packages
library(mariner)
library(data.table)

## Define path to 72 hour Hi-C file
hicFiles <- "data/raw/hic/MEGA_K562_WT_4320_inter.hic"

## Read in 72 hour TADS
tadFiles <- "data/raw/tads/MEGA_TAD_4320.bedpe"
tads <- 
  fread(tadFiles, skip=2) |>
  as_ginteractions(keep.extra.columns=FALSE)

## TODO: Replace loops with TADs
## Load 72 vs 0 hr diff loops
GenomeInfoDb::seqlevelsStyle(tads) <- 'ENSEMBL'

## Domain pileups
domains <- pileupDomains(
  x=tads, 
  files=hicFiles, 
  binSize=10e3,
  buffer=0.5, 
  ndim=c(100, 100)
)

## Save pixel matrix
saveRDS(object=domains, file="data/domainPileup.rds")
