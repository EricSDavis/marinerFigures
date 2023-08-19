## Required packages
library(mariner)

## Define path to Hi-C files
hicFiles <- "data/raw/hic/MEGA_K562_WT_inter.hic"

## Load 72 vs 0 hr diff loops
loops <- readRDS("data/diffLoops72vs0.rds")
loops <- interactions(loops)
GenomeInfoDb::seqlevelsStyle(loops) <- 'ENSEMBL'

## Pixel pileup
pixels <- pileupPixels(
  x=loops,
  files=hicFiles,
  binSize=10e3,
  buffer=5,
  removeShort=TRUE,
  minPairDist=0,
  normalize=TRUE
)

## Save pixel matrix
saveRDS(object=pixels, file="data/pixelPileup.rds")
