source('round3/00_Start.R',encoding='UTF-8')
suppressPackageStartupMessages({library(monocle3);library(slingshot);library(tradeSeq);library(SingleCellExperiment);library(Matrix)})
cdir<-init_module('combinations/Slingshot_tradeSeq_Monocle3')
aC<-readRDS(file.path(root,'methods/Monocle3/results/input_bundle.rds'))
# 从同一官方对象预先限定共同发育系统，不按结果挑细胞。
keepC<-aC$cells$cell.type %in% cfg3$common_types
xC<-aC$counts[,keepC];mC<-aC$cells[keepC,,drop=FALSE];gC<-aC$genes
stopifnot(ncol(xC)==650L,identical(colnames(xC),rownames(mC)),identical(rownames(xC),rownames(gC)))
saveRDS(list(counts=xC,cells=mC,genes=gC),file.path(cdir,'results/common_input.rds'))
write_tsv(data.frame(cell_id=colnames(xC),cell_type=mC$cell.type,collection_time=mC$time.point,embryo_time=mC$embryo.time,batch=mC$batch),file.path(cdir,'results/common_cells.tsv'))
print(table(mC$cell.type));cat('COMMON_INPUT_OK',dim(xC),'\n')
