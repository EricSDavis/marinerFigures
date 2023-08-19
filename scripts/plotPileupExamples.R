## Example pileup plots
## pileupPixels
## pileupDomains
## pileupBoundaries

## p=0.05, lfc=1.5

## Required packages
library(mariner)

## Load matrices
mats <- readRDS("data/pixelMats.rds")

## Aggregate matrices
mat <- aggHicMatrices(mats)

## Visualize APA (pileupPixels)
plotMatrix(mat)


