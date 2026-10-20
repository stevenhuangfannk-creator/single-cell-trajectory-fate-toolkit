# 02：先推断聚类层级谱系，再拟合同时主曲线；不依赖绘图调参。
# 改写自官方 vignette 的 sling_lines_unsup 和 curves 段。
# 起点1是官方模拟教学设定，不是由PI状态标签推导的方向。
stopifnot(exists('cfg'),exists('rd'),exists('cl'))
fit_started <- Sys.time()
lin1 <- getLineages(rd,cl,start.clus=cfg$start_cluster)
crv1 <- getCurves(lin1)
pt <- slingPseudotime(crv1)
weights <- slingCurveWeights(crv1)
lineages <- slingLineages(crv1)
stopifnot(nrow(pt)==nrow(rd),identical(dim(pt),dim(weights)),
          all(is.na(pt)|is.finite(pt)),all(is.finite(weights)),all(weights>=0),all(weights<=1+1e-8))
if (is.null(colnames(pt))) colnames(pt) <- paste0('Lineage',seq_len(ncol(pt)))
colnames(weights) <- colnames(pt)
lineage_table <- data.frame(lineage=colnames(pt),cluster_path=vapply(lineages,paste,collapse=' -> ',FUN.VALUE=''))
summary_table <- do.call(rbind,lapply(seq_len(ncol(pt)),function(j) {
 valid <- is.finite(pt[,j])
 data.frame(lineage=colnames(pt)[j],cells_total=nrow(pt),finite_pseudotime=sum(valid),
            missing_pseudotime=sum(!valid),minimum=min(pt[valid,j]),maximum=max(pt[valid,j]),
            weight_min=min(weights[,j]),weight_max=max(weights[,j]))
}))
write.table(data.frame(cell_id=rownames(rd),pt,check.names=FALSE),file.path(cfg$method_dir,'results','pseudotime.tsv'),sep='\t',row.names=FALSE,quote=FALSE,na='NA')
write.table(data.frame(cell_id=rownames(rd),weights,check.names=FALSE),file.path(cfg$method_dir,'results','curve_weights.tsv'),sep='\t',row.names=FALSE,quote=FALSE)
write.table(lineage_table,file.path(cfg$method_dir,'results','lineages.tsv'),sep='\t',row.names=FALSE,quote=FALSE)
write.table(summary_table,file.path(cfg$method_dir,'results','lineage_summary.tsv'),sep='\t',row.names=FALSE,quote=FALSE)
saveRDS(list(rd=rd,cl=cl,lin1=lin1,crv1=crv1,pt=pt,weights=weights,lineages=lineages,cfg=cfg),
        file.path(cfg$method_dir,'results','slingshot_fit.rds'))
writeLines(capture.output(sessionInfo()),file.path(cfg$method_dir,'logs','sessionInfo.txt'))
writeLines(capture.output(print(slingParams(crv1))),file.path(cfg$method_dir,'logs','fit_parameters.txt'))
cat('RUN_OK\n');print(lineage_table);print(summary_table)
cat('Fit elapsed seconds:',as.numeric(difftime(Sys.time(),fit_started,units='secs')),'\n')
