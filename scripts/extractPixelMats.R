## Extract matrices for the pixels
## used for differential loop analysis
library(mariner)

## Define path to Hi-C files
hicFiles <- "data/raw/hic/MEGA_K562_WT_inter.hic"

## Load 72 vs 0 hr diff loops
loops <- readRDS("data/diffLoops72vs0.rds")

## Define matrix regions
buffer <- 5
regions <- pixelsToMatrices(interactions(loops), buffer=buffer)

## Filter out short interactions
regions <- removeShortPairs(regions, padding=0)

## Harmonize seqlevels
GenomeInfoDb::seqlevelsStyle(regions) <- 'ENSEMBL'

## Extract matrices
## Remove h5 file if it exists
h5File <- "data/pixelMats.h5"
if (file.exists(h5File)) file.remove(h5File)
mats <- pullHicMatrices(
  x=regions,
  files=hicFiles,
  binSize=10e3,
  h5File=h5File,
  norm='KR',
  blockSize=1e7
)

## Save results
saveRDS(mats, file="data/pixelMats.rds")
