# 根选择遵循官方“早期细胞投票最近主图节点”的思路，避免硬编码 Y_27。
# 每个分区独立选根；此策略只提供分析方向，不证明分区之间有共同祖先。
select_roots3 <- function(cds,preferred_cells=NULL) {
  part<-as.character(partitions(cds));names(part)<-colnames(cds)
  nearest<-cds@principal_graph_aux[['UMAP']]$pr_graph_cell_proj_closest_vertex
  nearest<-as.matrix(nearest[colnames(cds),,drop=FALSE])
  node_names<-igraph::V(principal_graph(cds)[['UMAP']])$name
  out<-lapply(sort(unique(part)),function(pp) {
    ids<-names(part)[part==pp];m<-as.data.frame(colData(cds)[ids,,drop=FALSE])
    if(!is.null(preferred_cells)) {
      early<-intersect(ids,preferred_cells)
      if(!length(early)) stop('STOP: partition without preferred progenitor cells: ',pp)
      rule<-'predefined progenitor cells'
    } else {
      # 仅按该小数据中存在的最早 embryo.time.bin 选细胞；不能借用大教程的 130-170 空分箱。
      b<-as.integer(m$embryo.time.bin);early<-ids[b==min(b,na.rm=TRUE)]
      rule<-paste('earliest nonempty embryo.time.bin',as.character(m$embryo.time.bin[which.min(b)]))
    }
    v<-names(which.max(table(as.character(nearest[early,1]))))
    # 官方 nearest 为主图节点的数值索引。
    node<-if(v %in% node_names) v else node_names[as.integer(v)]
    data.frame(partition=pp,root_node=node,root_candidate_cells=length(early),rule=rule)
  })
  do.call(rbind,out)
}
export_graph3 <- function(cds,out) {
  g<-principal_graph(cds)[['UMAP']];xy<-t(cds@principal_graph_aux[['UMAP']]$dp_mst)
  write_tsv(data.frame(node=rownames(xy),xy,degree=igraph::degree(g)),file.path(out,'results/graph_nodes.tsv'))
  write_tsv(igraph::as_data_frame(g,what='edges'),file.path(out,'results/graph_edges.tsv'))
}
