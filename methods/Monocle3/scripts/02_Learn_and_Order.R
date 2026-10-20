source(file.path(root,'round3/monocle_helpers.R'),encoding='UTF-8')
set.seed(cfg3$monocle_seed)
# 沿用官方 extdata NOTES：50 PCs，按 batch 和背景RNA协变量对齐。
# 对齐改变表达结构，须配合未对齐敏感性分析；此处是官方工作流教学复现。
timingM<-system.time({
  cdsM<-preprocess_cds(cdsM,num_dim=cfg3$official_num_dim,method='PCA',norm_method='log')
  cdsM<-align_cds(cdsM,alignment_group='batch',
    residual_model_formula_str='~ bg.300.loading + bg.400.loading + bg.500.1.loading + bg.500.2.loading + bg.r17.loading + bg.b01.loading + bg.b02.loading')
  cdsM<-reduce_dimension(cdsM,umap.fast_sgd=FALSE,cores=cfg3$cores,umap.n_neighbors=cfg3$umap_neighbors)
  cdsM<-cluster_cells(cdsM,random_seed=cfg3$monocle_seed)
  cdsM<-learn_graph(cdsM,use_partition=TRUE,close_loop=FALSE,learn_graph_control=list(minimal_branch_len=cfg3$graph_min_branch))
  rootsM<-select_roots3(cdsM)
  cdsM<-order_cells(cdsM,root_pr_nodes=rootsM$root_node)
})
write_tsv(rootsM,file.path(mdir,'results/root_choices.tsv'))
ptM<-pseudotime(cdsM)
write_tsv(data.frame(cell_id=colnames(cdsM),cluster=clusters(cdsM),partition=partitions(cdsM),pseudotime=ptM,reducedDims(cdsM)$UMAP),file.path(mdir,'results/cell_trajectory.tsv'))
export_graph3(cdsM,mdir)
saveRDS(cdsM,file.path(mdir,'results/cds_trajectory.rds'))
cat('RUN graph nodes=',igraph::vcount(principal_graph(cdsM)[['UMAP']]),'partitions=',length(unique(partitions(cdsM))),'finite_pt=',sum(is.finite(ptM)),'\n');print(timingM)
writeLines(capture.output(list(config=cfg3,timing=timingM,roots=rootsM,session=sessionInfo())),file.path(mdir,'logs/parameters_session.txt'))
