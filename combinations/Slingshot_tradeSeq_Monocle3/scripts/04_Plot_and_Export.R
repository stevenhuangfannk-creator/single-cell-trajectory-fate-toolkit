if(!exists('ssC')) {
  source('round3/00_Start.R',encoding='UTF-8');suppressPackageStartupMessages({library(monocle3);library(slingshot);library(tradeSeq)})
  cdir<-init_module('combinations/Slingshot_tradeSeq_Monocle3');aC<-readRDS(file.path(cdir,'results/common_input.rds'));xC<-aC$counts;mC<-aC$cells;gC<-aC$genes
  ssC<-readRDS(file.path(cdir,'results/slingshot_fit.rds'));mcC<-readRDS(file.path(cdir,'results/monocle3_fit.rds'));gamC<-readRDS(file.path(cdir,'results/tradeSeq_fit.rds'));testsC<-readRDS(file.path(cdir,'results/tradeSeq_tests.rds'))
  compareC<-read.delim(file.path(cdir,'results/per_lineage_comparison.tsv'));corsC<-read.delim(file.path(cdir,'results/pseudotime_correlations.tsv'));gtC<-readRDS(file.path(cdir,'results/monocle3_graph_test.rds'))
}
colsC<-setNames(c('#4477AA','#EE6677','#228833','#AA3377'),sort(unique(mC$cell.type)))
# 左图为独立 PCA 的投影，右图为 Monocle UMAP；坐标不作形状优劣比较。
export_plot(file.path(cdir,'figures/C01_independent_trajectory_comparison'),function(){
  par(mfrow=c(1,2),mar=c(4,4,3,1));xy<-slingReducedDim(ssC)
  plot(xy[,1:2],col=colsC[mC$cell.type],pch=16,cex=.55,xlab='Slingshot PCA 1',ylab='PCA 2',main='Slingshot: independent PCA + curves')
  for(cv in slingCurves(ssC)) lines(cv$s[cv$ord,1:2],lwd=2,col='black')
  legend('topleft',names(colsC),col=colsC,pch=16,cex=.6,bty='n')
  xy<-reducedDims(mcC)$UMAP;plot(xy,col=colsC[mC$cell.type],pch=16,cex=.55,xlab='Monocle3 UMAP 1',ylab='UMAP 2',main='Monocle3: independent graph')
  g<-principal_graph(mcC)[['UMAP']];v<-t(mcC@principal_graph_aux[['UMAP']]$dp_mst);ed<-igraph::as_edgelist(g);segments(v[ed[,1],1],v[ed[,1],2],v[ed[,2],1],v[ed[,2],2],lwd=1.5)
},width=12,height=5.8)
export_plot(file.path(cdir,'figures/C02_per_lineage_pseudotime'),function(){
  par(mfrow=c(1,nrow(corsC)),mar=c(4,4,3,1))
  for(lin in corsC$lineage){z<-subset(compareC,lineage==lin & valid);rho<-corsC$spearman[corsC$lineage==lin];plot(z$ss_scaled,z$mc_scaled,pch=16,cex=.6,col=colsC[z$cell_type],xlab='Slingshot relative pseudotime',ylab='Monocle3 relative pseudotime',main=paste0(lin,': Spearman rho=',round(rho,3)));abline(0,1,lty=2,col='grey40')}
},width=10,height=5.5)
export_plot(file.path(cdir,'figures/C03_pseudotime_difference'),function(){
  par(mar=c(8,4,3,1));z<-subset(compareC,valid);groups<-interaction(z$lineage,z$cell_type,drop=TRUE);boxplot(z$difference~groups,las=2,outline=FALSE,col='#88CCEE',ylab='Slingshot minus Monocle3 relative time',main='Same-cell differences within each lineage');abline(h=0,lty=2)
},width=11,height=6)
z<-testsC$pattern;geneBC<-rownames(z)[order(z$FDR_BH,z$pvalue,-z$waldStat,na.last=TRUE)][1]
export_plot(file.path(cdir,'figures/C04_tradeSeq_lineage_smoothers'),function() print(plotSmoothers(gamC,counts=as.matrix(xC[rownames(gamC),]),gene=geneBC)+ggplot2::theme_bw()+ggplot2::ggtitle(paste('Same-data lineage patterns:',gC[geneBC,'gene_short_name']))))
z<-testsC$association;genesHC<-head(rownames(z)[order(z$FDR_BH,z$pvalue,-z$waldStat,na.last=TRUE)],30)
smoothC<-predictSmooth(gamC,gene=genesHC,nPoints=cfg3$npoints,tidy=FALSE);matC<-t(scale(t(log1p(smoothC))));matC[!is.finite(matC)]<-0
export_plot(file.path(cdir,'figures/C05_dynamic_gene_heatmap'),function(){
  layout(matrix(c(1,2),nrow=1),widths=c(9,1.2));par(mar=c(5,8,3,1));o<-hclust(dist(matC))$order;lim<-range(matC)
  image(seq_len(ncol(matC)),seq_len(nrow(matC)),t(matC[o,]),axes=FALSE,col=hcl.colors(100,'Blue-Red 3'),zlim=lim,xlab='100 equally spaced points within each lineage',ylab='',main='Same-data tradeSeq fitted expression: row z-score');axis(2,at=seq_len(nrow(matC)),labels=gC[rownames(matC)[o],'gene_short_name'],las=2,cex.axis=.65);axis(1,at=seq(cfg3$npoints/2,ncol(matC),by=cfg3$npoints),labels=paste0('Lineage',seq_len(ncol(matC)/cfg3$npoints)));abline(v=seq(cfg3$npoints+.5,ncol(matC),by=cfg3$npoints),lwd=2)
  par(mar=c(5,1,3,3));yy<-seq(lim[1],lim[2],length.out=100);image(c(0,1),yy,matrix(rep(yy,each=2),nrow=2),axes=FALSE,col=hcl.colors(100,'Blue-Red 3'),xlab='',ylab='');axis(4);mtext('z-score',side=3,cex=.75)
},width=10,height=7)
export_plot(file.path(cdir,'figures/C06_joint_gene_test_comparison'),function(){
  a<-testsC$association;ids<-intersect(rownames(a)[is.finite(a$FDR_BH)],rownames(gtC)[gtC$status=='OK'&is.finite(gtC$q_value)])
  par(mar=c(5,5,3,1));plot(gtC[ids,'morans_I'],-log10(pmax(a[ids,'FDR_BH'],1e-300)),pch=16,col=ifelse(gtC[ids,'q_value']<.05,'#0072B2','grey70'),cex=.6,xlab="Monocle3 Moran's I",ylab='-log10 tradeSeq association FDR',main='Jointly tested genes: different hypotheses');abline(h=-log10(.05),lty=2);legend('topleft',c('Monocle q < 0.05','Monocle q >= 0.05'),col=c('#0072B2','grey70'),pch=16,bty='n',cex=.8)
})
writeLines(c(paste('smoother gene:',geneBC,gC[geneBC,'gene_short_name']),paste('heatmap IDs:',paste(genesHC,collapse=','))),file.path(cdir,'logs/figure_genes.txt'))
write_tsv(data.frame(gene=rownames(smoothC),smoothC,check.names=FALSE),file.path(cdir,'results/tradeSeq_smooth_grid.tsv'))
cat('COMBINATION_FIGURE_OK\n')
