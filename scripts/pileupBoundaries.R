## Load required packages
library(mariner)

## Define path to Hi-C files
## comparing 72 vs 0 hrs
hicFiles <- c(
  "data/raw/hic/MEGA_K562_WT_0_inter.hic",
  "data/raw/hic/MEGA_K562_WT_4320_inter.hic"
)

## Load 72 vs 0 hr diff loops
loops <- readRDS("data/diffLoops72vs0.rds")
loops <- interactions(loops)
GenomeInfoDb::seqlevelsStyle(loops) <- 'ENSEMBL'

## Identify gained (72 vs 0 hr) boundaries
gained <- loops[which(loops$log2FoldChange >= log2(1.5) & loops$padj <= 0.05)]

## Domain pileups
gained_ctr <- pileupBoundaries(
  x=gained,
  files=hicFiles[1],
  binSize=10e3,
  normalize=TRUE
)
gained_trt <- pileupBoundaries(
  x=gained,
  files=hicFiles[2],
  binSize=10e3,
  normalize=TRUE
)

## Divide matrices
diffBoundaries <- gained_trt/gained_ctr

## Save pixel matrix
saveRDS(object=diffBoundaries, file="data/diffBoundaries.rds")
