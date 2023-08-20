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

## Begin visualization
pdf("plots/pileupPlotExamples.pdf", width=6, height=2.5)

## Create plotgardener visualization
pageCreate(width=6, height=2.5, showGuides=FALSE)

## Define shared parameters
p <- pgParams(x=0.5, y=0.5, width=1.5, height=1.5, space=0.1)

## Set column layout
cols <- pageLayoutCol(x=p$x, width=p$width, space=p$space*2.5, n=3)

## Pixel pileup ----

## Visualize APA
pixelPlot <- plotMatrix(
  data=pixels, 
  params=p, 
  x=cols[1]
)

## Heatmap legend
annoHeatmapLegend(
  plot=pixelPlot,
  orientation='h',
  x=cols[1],
  y=p$y + p$height + p$space,
  width=p$width,
  height=p$space,
  fontcolor='black'
)

## Legend title
plotText(
  label="counts per interaction",
  x=as.numeric(cols[1]) + p$width/2,
  y=p$y + p$height + p$space*3,
  fontsize=9
)

## Plot title
plotText(
  label="pileupPixels()",
  params=p,
  x=as.numeric(cols[1]) + p$width/2,
  y=p$y-p$space*2
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

## Heatmap legend
annoHeatmapLegend(
  plot=domainPlot,
  orientation='h',
  x=cols[2],
  y=p$y + p$height + p$space,
  width=p$width,
  height=p$space,
  fontcolor='black'
)

## Legend title
plotText(
  label="scaled counts",
  x=as.numeric(cols[2]) + p$width/2,
  y=p$y + p$height + p$space*3,
  fontsize=9
)

## Plot title
plotText(
  label="pileupDomains()",
  params=p,
  x=as.numeric(cols[2]) + p$width/2,
  y=p$y-p$space*2
)

## Saddle plot ----

## Transform to log2 foldchange
diffBoundaries <- log2(diffBoundaries)

## Set the scale
max_value <- max(abs(diffBoundaries))
saddle_scale <- c(-max_value, max_value)
# saddle_scale <- range(diffBoundaries)

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

## Heatmap legend
annoHeatmapLegend(
  plot=saddlePlot,
  orientation='h',
  x=cols[3],
  y=p$y + p$height + p$space,
  width=p$width,
  height=p$space,
  fontcolor='black'
)

## Legend title
plotText(
  label="log2(gained/lost)",
  x=as.numeric(cols[3]) + p$width/2,
  y=p$y + p$height + p$space*3,
  fontsize=9
)

## Plot title
plotText(
  label="pileupBoundaries()",
  params=p,
  x=as.numeric(cols[3]) + p$width/2,
  y=p$y-p$space*2
)

## End visualization
dev.off()