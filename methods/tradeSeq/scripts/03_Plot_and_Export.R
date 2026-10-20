# 可独立重绘：本脚本不调用 fitGAM。
if(!exists('fit3') || !exists('counts3') || !exists('celltype')) {
  suppressPackageStartupMessages({library(tradeSeq);library(slingshot);library(SingleCellExperiment)})
  tdir<-init_module('methods/tradeSeq');a<-readRDS(file.path(tdir,'results/input_bundle.rds'))
  counts3<-a$counts;crv<-a$crv;rd3<-a$rd;ptime3<-a$pseudotime;weights3<-a$weights;celltype<-a$celltype
  fit3<-readRDS(file.path(tdir,'results/fitGAM.rds'));test_results3<-readRDS(file.path(tdir,'results/tests.rds'))
}
pick_gene <- function(test) { z<-test_results3[[test]];rownames(z)[order(z$FDR_BH,z$pvalue,-z$waldStat,rownames(z),na.last=TRUE)][1] }
gassoc<-pick_gene('association');gbranch<-pick_gene('pattern')
nP<-cfg3$npoints;p1<-seq_len(nP);p2<-nP+p1
cols3<-c('#0072B2','#D55E00')
export_plot(file.path(tdir,'figures/T01_official_trajectory'),function(){
  par(mar=c(4,4,3,1));cc<-as.integer(factor(celltype));palette(hcl.colors(length(unique(cc)),'Dark 3'))
  plot(rd3,col=cc,pch=16,cex=.45,xlab='Official UMAP 1',ylab='Official UMAP 2',main='Official Paul15 subset: supplied Slingshot curves')
  lines(crv,lwd=2,col='black');legend('topleft',legend=levels(factor(celltype)),col=seq_along(unique(cc)),pch=16,cex=.65,bty='n')
})
export_plot(file.path(tdir,'figures/T02_expression_smoothers'),function(){print(plotSmoothers(fit3,counts=counts3,gene=gassoc)+ggplot2::theme_bw()+ggplot2::labs(title=paste('Pseudotime-associated gene:',gassoc)))})
valid3<-test_results3$association
top3<-head(rownames(valid3)[order(valid3$FDR_BH,valid3$pvalue,-valid3$waldStat,rownames(valid3),na.last=TRUE)],cfg3$top_heatmap)
pred3<-predictSmooth(fit3,gene=top3,nPoints=cfg3$npoints,tidy=FALSE)
stopifnot(ncol(pred3)==cfg3$npoints*ncol(ptime3))
logpred3<-log1p(pred3);sd3<-apply(logpred3,1,sd);sd3[sd3==0]<-1
zpred3<-sweep(sweep(logpred3,1,rowMeans(logpred3),'-'),1,sd3,'/')
ord3<-hclust(dist(zpred3))$order
export_plot(file.path(tdir,'figures/T03_dynamic_gene_heatmap'),function(){
  layout(matrix(c(1,2),nrow=1),widths=c(9,1.3));par(mar=c(5,8,3,1));lim<-range(zpred3)
  image(seq_len(ncol(zpred3)),seq_len(nrow(zpred3)),t(zpred3[ord3,]),col=hcl.colors(100,'Blue-Red 3'),zlim=lim,axes=FALSE,xlab='Relative pseudotime in each lineage',ylab='',main='Top association genes: fitted expression z-score')
  axis(2,at=seq_len(nrow(zpred3)),labels=rownames(zpred3)[ord3],las=2,cex.axis=.65);axis(1,at=c(.15,.85,1.15,1.85)*nP,labels=c('L1 early','L1 late','L2 early','L2 late'),cex.axis=.8);abline(v=nP+.5,lwd=2)
  par(mar=c(5,1,3,3));yy<-seq(lim[1],lim[2],length.out=nP);image(c(0,1),yy,matrix(rep(yy,each=2),nrow=2),col=hcl.colors(100,'Blue-Red 3'),axes=FALSE,xlab='',ylab='');axis(4);mtext('z-score',side=3,cex=.75)
})
branchpred3<-predictSmooth(fit3,gene=gbranch,nPoints=cfg3$npoints,tidy=FALSE)
delta3<-log2((branchpred3[1,p1]+1)/(branchpred3[1,p2]+1))
# 用显式向量避免矩阵布局歧义。
export_plot(file.path(tdir,'figures/T04_lineage_pattern_difference'),function(){
  par(mfrow=c(1,2),mar=c(4,4,3,1));x<-seq(0,1,length.out=nP)
  matplot(x,cbind(branchpred3[1,p1],branchpred3[1,p2]),type='l',col=cols3,lty=1,lwd=2,xlab='Relative pseudotime within each lineage',ylab='Fitted mean',main=gbranch)
  legend('topleft',c('Lineage1','Lineage2'),col=cols3,lty=1,bty='n',cex=.8)
  plot(x,delta3,type='l',lwd=2,xlab='Relative pseudotime',ylab='log2((mu L1 + 1)/(mu L2 + 1))',main='Descriptive pattern difference');abline(h=0,lty=2)
},width=10)
export_plot(file.path(tdir,'figures/T05_test_summary'),function(){
  par(mar=c(9,4,3,1));s<-read.delim(file.path(tdir,'results/test_summary.tsv'));barplot(s$significant,names.arg=s$test,las=2,col='#4477AA',ylab='Number of genes',main='BH FDR < 0.05 within each test family')
})
write_tsv(data.frame(gene=rownames(pred3),pred3,check.names=FALSE),file.path(tdir,'results/smooth_grid.tsv'))
write_tsv(data.frame(relative_time=seq(0,1,length.out=nP),gene=gbranch,lineage1=branchpred3[1,p1],lineage2=branchpred3[1,p2],descriptive_log2_difference=delta3),file.path(tdir,'results/branch_curve_difference.tsv'))
writeLines(c(paste('association gene:',gassoc),paste('pattern gene:',gbranch),paste('heatmap genes:',paste(top3,collapse=','))),file.path(tdir,'logs/figure_genes.txt'))
cat('FIGURE export completed\n')
