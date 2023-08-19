## Calculate differential loops between
## 0 and 72 hours of treatment w/PMA

## Required packages
library(mariner)
library(data.table)
library(InteractionSet)
library(DESeq2)
library(DelayedArray)

## Read in loops that already have
## counts and suppress warning about row names
loops <- 
  fread("data/raw/loops/mergedLoops.txt", drop=1) |>
  as_ginteractions() |>
  suppressWarnings()

## Separate out count matrix and
## sum techreps for each biorep
cnts <- 
  mcols(loops) |>
  tidyr::as_tibble() |>
  dplyr::select(tidyr::ends_with(".hic")) |>
  dplyr::mutate(loopName=paste0("loop_", dplyr::row_number())) |>
  tidyr::pivot_longer(cols=tidyr::ends_with(".hic")) |>
  tidyr::separate(col=name,
                  into=c("proj", "cell", "genotype", "treat",
                         "time", "biorep", "techrep", "suffix"),
                  sep="_",
                  remove=FALSE) |>
  dplyr::select(loopName, name, time, biorep, techrep, value) |>
  dplyr::group_by(loopName, time, biorep) |>
  dplyr::summarise(count = sum(value)) |>
  dplyr::mutate(name=paste("MEGA", time, biorep, sep="_")) |>
  tidyr::pivot_wider( id_cols=loopName, names_from=name, values_from=count) |>
  dplyr::arrange(as.numeric(gsub("loop_", "", loopName))) |>
  dplyr::ungroup() |>
  dplyr::select(tidyr::starts_with("MEGA"))

## Filter out loops with a median less than 5 counts
keep <- which(rowMedians(as.matrix(cnts), na.rm=TRUE) >= 5)
cnts <- cnts[keep,]
loops <- loops[keep,]

## Generate colData
colData <- 
  colnames(cnts) |>
  strsplit("_") |>
  do.call(what=rbind, args=_) |>
  as.data.frame() |>
  `colnames<-`(value=c("proj", "time", "replicate")) |>
  dplyr::select(time, replicate)

## Coerce all columns to factors
colData[] <- lapply(colData, factor)

## Do differential analysis
dds <- DESeqDataSetFromMatrix(
  countData=cnts,
  colData=colData,
  design=~replicate+time
)
dds <- DESeq(dds)

## Apply shrinkage and get results
res <- lfcShrink(dds, coef="time_4320_vs_0", type="apeglm")

## Store results in InteractionMatrix
imat <- InteractionMatrix(
  interactions=loops,
  assays=list(
    counts=DelayedArray(as.matrix(cnts))
  ),
  colData=as(colData, "DataFrame"),
  metadata=list()
)

## Add differential results
rowData(imat) <- res

## Gained/lost
# imat[which(res$log2FoldChange >= log2(1.5) & res$padj <= 0.05)]
# imat[which(res$log2FoldChange <= -log2(1.5) & res$padj <= 0.05)]

## Save object
saveRDS(object=imat, file="data/diffLoops72vs0.rds")
