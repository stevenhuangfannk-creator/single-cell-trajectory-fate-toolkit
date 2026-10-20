# 先 source('round3/00_Start.R')。官方表达矩阵与轨迹来自同一随包例子。
suppressPackageStartupMessages({library(tradeSeq);library(slingshot);library(SingleCellExperiment);library(BiocParallel)})
tdir <- init_module('methods/tradeSeq')
data('countMatrix',package='tradeSeq');data('crv',package='tradeSeq');data('celltype',package='tradeSeq')
counts3 <- as.matrix(countMatrix)
ptime3 <- slingPseudotime(crv,na=FALSE)
weights3 <- slingCurveWeights(crv)
rd3 <- slingReducedDim(crv)
stopifnot(identical(colnames(counts3),rownames(rd3)),identical(colnames(counts3),rownames(ptime3)),
          identical(rownames(ptime3),rownames(weights3)),!anyDuplicated(colnames(counts3)),
          all(is.finite(counts3)),all(counts3>=0),all(counts3==round(counts3)),
          all(is.finite(ptime3)),all(is.finite(weights3)),all(weights3>=0),all(rowSums(weights3)>0))
cat('INPUT_OK genes=',nrow(counts3),'cells=',ncol(counts3),'lineages=',ncol(ptime3),'\n')
print(table(celltype));print(slingLineages(crv))
saveRDS(list(counts=counts3,crv=crv,celltype=celltype,pseudotime=ptime3,weights=weights3,rd=rd3),file.path(tdir,'results/input_bundle.rds'))
write_tsv(data.frame(cell_id=colnames(counts3),celltype=celltype,rd3,ptime3,weights3,check.names=FALSE),file.path(tdir,'results/cell_inputs.tsv'))
write_tsv(data.frame(gene=rownames(counts3),total_counts=rowSums(counts3),detected_cells=rowSums(counts3>0)),file.path(tdir,'results/gene_inputs.tsv'))
writeLines(capture.output(list(dim=dim(counts3),lineages=slingLineages(crv),parameters=slingParams(crv))),file.path(tdir,'logs/input_audit.txt'))
