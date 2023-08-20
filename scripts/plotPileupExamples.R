## Example pileup plots
## pileupPixels
## pileupDomains
## pileupBoundaries

## Load required packages
library(mariner)
library(plotgardener)

## Import datasets for visualization
pixels <- readRDS("data/pixelPileup.rds")
domains <- readRDS("data/domainPileup.rds")
diffBoundaries <- readRDS("data/diffBoundaries.rds")

## Create plotgardener visualization
pageCreate(width=7, height=2.5)

## Define shared parameters
p <- pgParams(x=0.5, y=0.5, width=1.5, height=1.5)

## Set column layout
cols <- pageLayoutCol(x=p$x, width=p$width, space=0.5, n=3)

## Pixel pileup ----

## Visualize APA
pixelPlot <- plotMatrix(
  data=pixels, 
  params=p, 
  x=cols[1]
)

## Domain pileup ----

## Set the scale
domain_scale <- c(0, quantile(domains, 0.85))

## Visualize TADs
domainPlot <- plotMatrix(
  data=domains,
  params=p, 
  x=cols[2], 
  zrange=domain_scale
)

## Saddle plot ----

## Transform to log2 foldchange
diffBoundaries <- log2(diffBoundaries)

## Set the scale
max_value <- max(abs(diffBoundaries))
saddle_scale <- c(-max_value, max_value)

## Create a divergent color palette
colPal <- colorRampPalette(c('blue', 'white', 'red'))

## Visualize saddle plot
saddlePlot <- plotMatrix(
  data=diffBoundaries,
  params=p,
  x=cols[3],
  zrange=saddle_scale,
  palette=colPal
)
