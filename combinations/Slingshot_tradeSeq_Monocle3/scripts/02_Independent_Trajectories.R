# Slingshot：独立 log 标准化、变异基因选择和 PCA；不使用 Monocle3 的主图或拟时序。
set.seed(cfg3$monocle_seed)
libC<-Matrix::colSums(xC);logC<-log1p(t(t(xC)/libC)*median(libC))
varC<-Matrix::rowMeans(logC^2)-Matrix::rowMeans(logC)^2
hvC<-head(names(sort(varC,decreasing=TRUE)),cfg3$common_hvg)
pcaC<-irlba::prcomp_irlba(t(logC[hvC,]),n=cfg3$num_dim,center=TRUE,scale.=FALSE)
# prcomp_irlba 返回的 scores 在本环境丢失行名；按已核实的输入行顺序恢复ID，不按位置猜测另一对象。
stopifnot(identical(rownames(t(logC[hvC,])),colnames(xC)),nrow(pcaC$x)==ncol(xC))
rownames(pcaC$x)<-colnames(xC)
ssC<-slingshot(pcaC$x,clusterLabels=mC$cell.type,start.clus='Neuroblast_ASG_AWA')
saveRDS(ssC,file.path(cdir,'results/slingshot_fit.rds'))
print(slingLineages(ssC))
writeLines(capture.output(slingLineages(ssC)),file.path(cdir,'logs/slingshot_lineages.txt'))
write_tsv(data.frame(cell_id=colnames(xC),slingPseudotime(ssC),check.names=FALSE),file.path(cdir,'results/slingshot_pseudotime.tsv'))
write_tsv(data.frame(cell_id=colnames(xC),slingCurveWeights(ssC),check.names=FALSE),file.path(cdir,'results/slingshot_weights.tsv'))
# Monocle3：从相同 counts 新建对象并独立处理；沿用官方批次/背景校正流程。
mcC<-new_cell_data_set(xC,cell_metadata=mC,gene_metadata=gC)
set.seed(cfg3$monocle_seed)
mcC<-preprocess_cds(mcC,num_dim=cfg3$num_dim)
mcC<-align_cds(mcC,alignment_group='batch',residual_model_formula_str='~ bg.300.loading + bg.400.loading + bg.500.1.loading + bg.500.2.loading + bg.r17.loading + bg.b01.loading + bg.b02.loading')
mcC<-reduce_dimension(mcC,umap.fast_sgd=FALSE,cores=cfg3$cores,umap.n_neighbors=cfg3$umap_neighbors)
mcC<-cluster_cells(mcC,random_seed=cfg3$monocle_seed)
mcC<-learn_graph(mcC,use_partition=TRUE,close_loop=FALSE,learn_graph_control=list(minimal_branch_len=cfg3$graph_min_branch))
source(file.path(root,'round3/monocle_helpers.R'),encoding='UTF-8')
# 只给含预设早期祖细胞的分区选根；其他分区保留 Inf，不强行连通。
partC<-partitions(mcC);progC<-colnames(mcC)[mC$cell.type=='Neuroblast_ASG_AWA']
root_partsC<-unique(as.character(partC[progC]))
nearC<-as.matrix(mcC@principal_graph_aux[['UMAP']]$pr_graph_cell_proj_closest_vertex[colnames(mcC),,drop=FALSE])
vnamesC<-igraph::V(principal_graph(mcC)[['UMAP']])$name
rootsC<-do.call(rbind,lapply(root_partsC,function(pp){ids<-intersect(names(partC)[as.character(partC)==pp],progC);v<-names(which.max(table(as.character(nearC[ids,1]))));node<-if(v %in% vnamesC)v else vnamesC[as.integer(v)];data.frame(partition=pp,root_node=node,progenitor_cells=length(ids))}))
mcC<-order_cells(mcC,root_pr_nodes=rootsC$root_node)
saveRDS(mcC,file.path(cdir,'results/monocle3_fit.rds'))
write_tsv(rootsC,file.path(cdir,'results/monocle3_roots.tsv'));export_graph3(mcC,cdir)
write_tsv(data.frame(cell_id=colnames(mcC),partition=partitions(mcC),pseudotime=pseudotime(mcC),reducedDims(mcC)$UMAP),file.path(cdir,'results/monocle3_pseudotime.tsv'))
writeLines(capture.output(list(config=cfg3,Slingshot_PCs=cfg3$num_dim,HV_genes=hvC,Monocle_partitions=table(partitions(mcC)),roots=rootsC,session=sessionInfo())),file.path(cdir,'logs/model_parameters_session.txt'))
cat('INDEPENDENT_TRAJECTORIES_OK\n')
