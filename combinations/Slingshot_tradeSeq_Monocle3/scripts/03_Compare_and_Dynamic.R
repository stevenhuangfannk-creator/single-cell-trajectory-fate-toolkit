stopifnot(identical(colnames(xC),rownames(slingReducedDim(ssC))),identical(colnames(xC),colnames(mcC)))
ptSC<-slingPseudotime(ssC);wSC<-slingCurveWeights(ssC);ptMC<-pseudotime(mcC)
# 各 Slingshot 谱系独立比较；不能把分叉后的两条时间折叠成一个全局时间。
scale01C<-function(x){z<-x;ok<-is.finite(x);r<-range(x[ok]);z[ok]<-(x[ok]-r[1])/diff(r);z}
comparisonC<-list();corrC<-list();linesC<-slingLineages(ssC)
for(j in seq_len(ncol(ptSC))) {
  ok<-is.finite(ptSC[,j])&is.finite(ptMC)&wSC[,j]>=cfg3$lineage_weight_min
  if(sum(ok)<10) next
  # 两种方法在同一组有效细胞上各自归一化；不翻转方向以提高相关性。
  ts<-rep(NA_real_,ncol(xC));tm<-ts;ts[ok]<-scale01C(ptSC[ok,j]);tm[ok]<-scale01C(ptMC[ok])
  comparisonC[[j]]<-data.frame(cell_id=colnames(xC),cell_type=mC$cell.type,lineage=colnames(ptSC)[j],valid=ok,slingshot_time=ptSC[,j],weight=wSC[,j],monocle_time=ptMC,ss_scaled=ts,mc_scaled=tm,difference=ts-tm)
  corrC[[j]]<-data.frame(lineage=colnames(ptSC)[j],terminal_cluster=tail(linesC[[j]],1),valid_cells=sum(ok),spearman=cor(ptSC[ok,j],ptMC[ok],method='spearman'),pearson_scaled=cor(ts[ok],tm[ok]),median_abs_scaled_difference=median(abs(ts[ok]-tm[ok])))
}
compareC<-do.call(rbind,comparisonC);corsC<-do.call(rbind,corrC)
write_tsv(compareC,file.path(cdir,'results/per_lineage_comparison.tsv'));write_tsv(corsC,file.path(cdir,'results/pseudotime_correlations.tsv'));print(corsC)
# 终点对照：用各谱系末20%细胞在 Monocle 主图叶节点的最近图距离分布评估。
# 这里只匹配计算终点，不把注释或叶节点当作已验证生物终末状态。
graphC<-principal_graph(mcC)[['UMAP']];leavesC<-names(igraph::degree(graphC))[igraph::degree(graphC)==1]
near_namesC<-as.character(nearC[,1]);near_namesC<-ifelse(near_namesC%in%igraph::V(graphC)$name,near_namesC,igraph::V(graphC)$name[as.integer(near_namesC)])
dmC<-igraph::distances(graphC,v=unique(near_namesC),to=leavesC)
closest_leafC<-setNames(apply(dmC,1,function(v){if(all(!is.finite(v)))NA_character_ else names(which.min(v))}),rownames(dmC))
mapC<-do.call(rbind,lapply(seq_len(ncol(ptSC)),function(j){valid<-is.finite(ptSC[,j])&wSC[,j]>=cfg3$lineage_weight_min;last<-valid & ptSC[,j]>=quantile(ptSC[valid,j],cfg3$late_fraction);tab<-table(closest_leafC[near_namesC[last]]);data.frame(lineage=colnames(ptSC)[j],terminal_cluster=tail(linesC[[j]],1),monocle_leaf=names(tab),late_cells=as.integer(tab))}))
write_tsv(mapC,file.path(cdir,'results/terminal_mapping.tsv'))
# 下游模型使用同一表达矩阵。300个基因的预先方差筛选是教学资源限制；不称全基因组发现。
genesDC<-head(names(sort(varC,decreasing=TRUE)),cfg3$common_fit_genes)
offC<-matrix(rep(log(libC),each=length(genesDC)),nrow=length(genesDC))
set.seed(7);BiocParallel::register(BiocParallel::SerialParam())
gamC<-fitGAM(counts=as.matrix(xC[genesDC,]),pseudotime=slingPseudotime(ssC,na=FALSE),cellWeights=wSC,nknots=cfg3$nknots,offset=offC,parallel=FALSE,verbose=FALSE)
saveRDS(gamC,file.path(cdir,'results/tradeSeq_fit.rds'))
ccC<-rowData(gamC)$tradeSeq$converged
write_tsv(data.frame(gene=rownames(gamC),converged=ccC),file.path(cdir,'results/tradeSeq_convergence.tsv'))
testsC<-list(association=associationTest(gamC,inverse='eigen'),startVsEnd=startVsEndTest(gamC),pattern=patternTest(gamC),diffEnd=diffEndTest(gamC),earlyDE_knots1_2=earlyDETest(gamC,knots=cfg3$early_knots))
for(nm in names(testsC)){z<-as.data.frame(testsC[[nm]]);ok<-ccC%in%TRUE & is.finite(z$pvalue);z$FDR_BH<-NA_real_;z$FDR_BH[ok]<-p.adjust(z$pvalue[ok],'BH',n=sum(ccC%in%TRUE));testsC[[nm]]<-z;write_tsv(z,file.path(cdir,paste0('results/tradeSeq_',nm,'.tsv')),TRUE)}
saveRDS(testsC,file.path(cdir,'results/tradeSeq_tests.rds'))
# 在同一共同细胞集上做 Monocle3 动态检验，供共同检验基因宇宙内的集合比较和功能分析。
eligibleC<-rownames(mcC)[Matrix::rowSums(counts(mcC)>0)>=cfg3$min_detected_cells]
gtC<-graph_test(mcC[eligibleC,],neighbor_graph='principal_graph',cores=cfg3$cores,verbose=FALSE)
write_tsv(gtC,file.path(cdir,'results/monocle3_graph_test.tsv'),TRUE);saveRDS(gtC,file.path(cdir,'results/monocle3_graph_test.rds'))
jointC<-intersect(rownames(testsC$association)[is.finite(testsC$association$FDR_BH)],rownames(gtC)[gtC$status=='OK' & is.finite(gtC$q_value)])
setTC<-jointC[testsC$association[jointC,'FDR_BH']<.05];setMC<-jointC[gtC[jointC,'q_value']<.05]
write_tsv(data.frame(joint_universe=length(jointC),tradeSeq_significant=length(setTC),monocle_significant=length(setMC),intersection=length(intersect(setTC,setMC)),union=length(union(setTC,setMC)),jaccard=length(intersect(setTC,setMC))/length(union(setTC,setMC))),file.path(cdir,'results/dynamic_gene_overlap.tsv'))
cat('COMPARISON_AND_DYNAMIC_OK\n')
