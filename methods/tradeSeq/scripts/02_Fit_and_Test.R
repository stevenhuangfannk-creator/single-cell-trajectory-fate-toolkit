# NB-GAM：负二项广义加性模型。单进程；保存收敛状态，失败基因不进入有效检验族。
register(SerialParam())
set.seed(cfg3$seed)
time3 <- system.time(fit3 <- fitGAM(counts=counts3,pseudotime=ptime3,cellWeights=weights3,
                                  nknots=cfg3$nknots,verbose=FALSE,parallel=FALSE,sce=TRUE))
saveRDS(fit3,file.path(tdir,'results/fitGAM.rds'))
conv3 <- rowData(fit3)$tradeSeq$converged
write_tsv(data.frame(gene=rownames(fit3),converged=conv3),file.path(tdir,'results/convergence.tsv'))
cat('MODEL convergence:');print(table(conv3,useNA='ifany'));print(time3)
tests3 <- list(association=associationTest,association_eigen_sensitivity=function(x) associationTest(x,inverse='eigen'),startVsEnd=startVsEndTest,pattern=patternTest,diffEnd=diffEndTest,
               earlyDE_knots1_2=function(x) earlyDETest(x,knots=cfg3$early_knots))
test_results3 <- list()
for(nm in names(tests3)) {
  cat('TEST',nm,'\n')
  z <- as.data.frame(tests3[[nm]](fit3))
  z$converged <- conv3[match(rownames(z),rownames(fit3))]
  valid <- z$converged %in% TRUE & is.finite(z$pvalue)
  # 校正族为预定的全部收敛基因；NA 留空，不把它们视为阴性或显著。
  z$FDR_BH <- NA_real_;z$FDR_BH[valid] <- p.adjust(z$pvalue[valid],method='BH',n=sum(conv3 %in% TRUE))
  z$significant_FDR05 <- !is.na(z$FDR_BH) & z$FDR_BH<cfg3$fdr
  test_results3[[nm]] <- z
  write_tsv(z,file.path(tdir,paste0('results/',nm,'.tsv')),TRUE)
}
saveRDS(test_results3,file.path(tdir,'results/tests.rds'))
sum3 <- do.call(rbind,lapply(names(test_results3),function(nm) {
  z<-test_results3[[nm]];data.frame(test=nm,genes=nrow(z),valid_p=sum(is.finite(z$FDR_BH)),significant=sum(z$significant_FDR05))
}))
write_tsv(sum3,file.path(tdir,'results/test_summary.tsv'));print(sum3)
writeLines(capture.output(list(parameters=cfg3,timing=time3,offset=metadata(fit3)$tradeSeq,session=sessionInfo())),file.path(tdir,'logs/model_parameters_session.txt'))
