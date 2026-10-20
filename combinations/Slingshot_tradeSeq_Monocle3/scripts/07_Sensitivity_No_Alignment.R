# 原主要结果出现 AWA 排序/终点冲突后追加的敏感性分析。保留主结果，不按相关性择优。
source('round3/00_Start.R',encoding='UTF-8')
suppressPackageStartupMessages({library(monocle3);library(slingshot)})
cdir<-init_module('combinations/Slingshot_tradeSeq_Monocle3')
sensdir<-file.path(cdir,'sensitivity_no_alignment');for(d in c('results','figures','logs')) dir.create(file.path(sensdir,d),recursive=TRUE,showWarnings=FALSE)
aS<-readRDS(file.path(cdir,'results/common_input.rds'));ssS<-readRDS(file.path(cdir,'results/slingshot_fit.rds'))
cdsS<-new_cell_data_set(aS$counts,cell_metadata=aS$cells,gene_metadata=aS$genes)
set.seed(cfg3$monocle_seed)
cdsS<-preprocess_cds(cdsS,num_dim=cfg3$num_dim)
# 唯一计划改变：省略 align_cds。UMAP、聚类、主图、根选择规则沿用主流程。
cdsS<-reduce_dimension(cdsS,umap.fast_sgd=FALSE,cores=cfg3$cores,umap.n_neighbors=cfg3$umap_neighbors)
cdsS<-cluster_cells(cdsS,random_seed=cfg3$monocle_seed)
cdsS<-learn_graph(cdsS,use_partition=TRUE,close_loop=FALSE,learn_graph_control=list(minimal_branch_len=cfg3$graph_min_branch))
partsS<-partitions(cdsS);progsS<-colnames(cdsS)[aS$cells$cell.type=='Neuroblast_ASG_AWA']
nearS<-as.matrix(cdsS@principal_graph_aux[['UMAP']]$pr_graph_cell_proj_closest_vertex[colnames(cdsS),,drop=FALSE]);namesS<-igraph::V(principal_graph(cdsS)[['UMAP']])$name
rootsS<-do.call(rbind,lapply(unique(as.character(partsS[progsS])),function(pp){ids<-intersect(names(partsS)[as.character(partsS)==pp],progsS);v<-names(which.max(table(as.character(nearS[ids,1]))));data.frame(partition=pp,root_node=if(v%in%namesS)v else namesS[as.integer(v)],progenitor_cells=length(ids))}))
cdsS<-order_cells(cdsS,root_pr_nodes=rootsS$root_node)
ptSS<-slingPseudotime(ssS);wwS<-slingCurveWeights(ssS);ptMS<-pseudotime(cdsS)
corsS<-do.call(rbind,lapply(seq_len(ncol(ptSS)),function(j){ok<-is.finite(ptSS[,j])&is.finite(ptMS)&wwS[,j]>=cfg3$lineage_weight_min;data.frame(lineage=colnames(ptSS)[j],valid_cells=sum(ok),spearman=cor(ptSS[ok,j],ptMS[ok],method='spearman'),pipeline='Monocle3_without_alignment')}))
write_tsv(corsS,file.path(sensdir,'results/correlations.tsv'));write_tsv(rootsS,file.path(sensdir,'results/roots.tsv'))
write_tsv(data.frame(cell_id=colnames(cdsS),partition=partsS,pseudotime=ptMS,reducedDims(cdsS)$UMAP),file.path(sensdir,'results/pseudotime.tsv'))
saveRDS(cdsS,file.path(sensdir,'results/monocle3_fit.rds'))
export_plot(file.path(sensdir,'figures/C08_no_alignment_sensitivity'),function()print(plot_cells(cdsS,color_cells_by='pseudotime',label_cell_groups=FALSE,label_leaves=FALSE,label_branch_points=FALSE)+ggplot2::theme_bw()+ggplot2::ggtitle('Sensitivity only: Monocle3 without alignment')))
print(corsS);cat('SENSITIVITY_ONLY; not a replacement for the primary pipeline\n')
