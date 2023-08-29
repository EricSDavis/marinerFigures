## Examples of using different backgrounds
## for calculating loop enrichment
## aka scoring loops

## Load required packages
library(mariner)

## Load extracted matrices
mats <- readRDS("data/pixelMats.rds")

## Score loops with different selected
## backgrounds. Let's aggregate them, since
## we want to compare how the different 
## background methods calculate enrichment.
mat <- aggHicMatrices(mats)

## Since calcLoopEnrichment doesn't have a
## method for DelayedMatrix, enrichment
## will have to be calculated by hand

## Use the same foreground & function
fg <- selectCenterPixel(mhDist=1, buffer=5)
eFUN <- \(x, fg, bg) {
  median(x[fg$x] + 1) / median(x[bg$x] + 1)
}

## Default (top-left & bottom-right corners) ----
bg_tlbr <- selectTopLeft(n=4, buffer=5) +
  selectBottomRight(n=4, buffer=5)
tlbr <- eFUN(mat, fg, bg_tlbr)

## Top-right corner ----
bg_tr <- selectTopRight(n=4, buffer=5)
tr <- eFUN(mat, fg, bg_tr)

## Donut ----
bg_donut <- selectOuter(n=2, buffer=5)
donut <- eFUN(mat, fg, bg_donut)

## "plot" this to use for visualizing
## the different backgrounds
conn <- file("plots/loopScores.txt", open = "wt")
sink(conn, type = "output")
sink(conn, type = "message")

tlbr
cat("\n")
mariner:::.showMultiSelection(fg$x, bg_tlbr$x, buffer=5)

cat("\n----------------------------\n\n")

tr
cat("\n")
mariner:::.showMultiSelection(fg$x, bg_tr$x, buffer=5)

cat("\n----------------------------\n\n")

donut
cat("\n")
mariner:::.showMultiSelection(fg$x, bg_donut$x, buffer=5)

sink(type="message")
sink(type="output")
close(conn)
