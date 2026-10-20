# 官方 graph_test：图上 Moran's I（莫兰空间自相关），不是基于真实时间的差异检验。
# 预先筛选“至少20个细胞检出”的基因；在所有合格基因上串行检验，而非挑显著基因后检验。
detectedM<-Matrix::rowSums(counts(cdsM)>0)
useM<-names(detectedM)[detectedM>=cfg3$min_detected_cells]
cat('graph_test genes:',length(useM),'of',nrow(cdsM),'\n')
timingGM<-system.time(gtM<-graph_test(cdsM[useM,],neighbor_graph='principal_graph',cores=cfg3$cores,verbose=FALSE))
write_tsv(gtM,file.path(mdir,'results/graph_test.tsv'),TRUE)
saveRDS(gtM,file.path(mdir,'results/graph_test.rds'))
write_tsv(data.frame(gene=rownames(cdsM),detected_cells=detectedM,tested=rownames(cdsM)%in%useM),file.path(mdir,'results/gene_test_universe.tsv'))
cat('graph_test status:');print(table(gtM$status,useNA='ifany'));cat('q<0.05',sum(gtM$q_value<.05,na.rm=TRUE),'\n');print(timingGM)
# 官方表达-拟时序图函数会拟合展示用的基因曲线；在分析阶段执行并保存，重绘不再拟合。
validM<-rownames(gtM)[gtM$status=='OK' & is.finite(gtM$q_value)]
topM<-head(validM[order(gtM[validM,'q_value'],-gtM[validM,'morans_I'])],6)
# 不把3个断开分区的时间合成同一表达曲线；用预定的AWA注释路径做描述展示。
pathM<-colnames(cdsM)[colData(cdsM)$cell.type %in% c('Neuroblast_ASG_AWA','ASG_AWA','AWA')]
path_partitionM<-names(which.max(table(partitions(cdsM)[pathM])))
pathM<-intersect(pathM,names(partitions(cdsM))[as.character(partitions(cdsM))==path_partitionM])
write_tsv(data.frame(cell_id=pathM,partition=as.character(partitions(cdsM)[pathM]),cell_type=colData(cdsM)[pathM,'cell.type']),file.path(mdir,'results/M06_display_cells.tsv'))
local_coverageM<-Matrix::rowMeans(counts(cdsM)[,pathM]>0)
local_candidatesM<-validM[gtM[validM,'q_value']<.05 & local_coverageM[validM]>=cfg3$m06_min_detection]
top_localM<-head(local_candidatesM[order(gtM[local_candidatesM,'q_value'],-gtM[local_candidatesM,'morans_I'])],6)
writeLines(top_localM,file.path(mdir,'logs/M06_figure_genes.txt'))
write_tsv(data.frame(gene=top_localM,local_detection_fraction=local_coverageM[top_localM]),file.path(mdir,'results/M06_gene_coverage.tsv'))
pseudotime_plotM<-plot_genes_in_pseudotime(cdsM[top_localM,pathM],color_cells_by='cell.type',min_expr=.1,ncol=2)
saveRDS(pseudotime_plotM,file.path(mdir,'results/pseudotime_gene_plot.rds'))
