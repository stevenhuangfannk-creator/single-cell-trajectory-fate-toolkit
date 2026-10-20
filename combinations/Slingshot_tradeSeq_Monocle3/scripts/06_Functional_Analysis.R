# GO（Gene Ontology，基因本体）BP（biological process，生物过程）过度富集。
# 本例是 Monocle 图动态基因的条件 ORA，不是带方向的GSEA，也不是PI通路证明。
source('round3/00_Start.R',encoding='UTF-8')
cdir<-init_module('combinations/Slingshot_tradeSeq_Monocle3')
gtF<-read.delim(file.path(cdir,'results/monocle3_graph_test.tsv'),check.names=FALSE)
annF<-read.delim(file.path(cdir,'example_data/worm_GO_BP_membership.tsv'))
testedF<-gtF$gene[gtF$status=='OK' & is.finite(gtF$q_value)]
bgF<-intersect(testedF,unique(annF$gene_id))
selectedF<-intersect(gtF$gene[gtF$status=='OK' & is.finite(gtF$q_value) & gtF$q_value<.05 & gtF$morans_I>cfg3$moran_cutoff],bgF)
write_tsv(data.frame(gene=sort(testedF),GO_annotated=sort(testedF)%in%bgF,selected=sort(testedF)%in%selectedF),file.path(cdir,'results/GO_background_and_selected.tsv'))
cat('GO background tested=',length(testedF),'annotated=',length(bgF),'selected=',length(selectedF),'\n')
if(length(selectedF)<20L) stop('NOT_APPLICABLE: insufficient annotated selected genes; do not fabricate enrichment')
setsF<-split(annF$gene_id,annF$GO_ID);setsF<-lapply(setsF,function(x) intersect(unique(x),bgF))
setsF<-setsF[lengths(setsF)>=10L & lengths(setsF)<=500L]
oraF<-do.call(rbind,lapply(names(setsF),function(id){s<-setsF[[id]];k<-length(intersect(s,selectedF));M<-length(bgF);K<-length(s);N<-length(selectedF);data.frame(GO_ID=id,term=annF$term[match(id,annF$GO_ID)],background=M,selected=N,set_size=K,overlap=k,fold_enrichment=(k/N)/(K/M),pvalue=phyper(k-1,K,M-K,N,lower.tail=FALSE),overlap_genes=paste(sort(intersect(s,selectedF)),collapse=';'))}))
oraF$FDR_BH<-p.adjust(oraF$pvalue,'BH');oraF<-oraF[order(oraF$FDR_BH,oraF$pvalue,-oraF$overlap),]
write_tsv(oraF,file.path(cdir,'results/GO_BP_ORA.tsv'))
write_tsv(data.frame(tested=length(testedF),annotated_background=length(bgF),selected=length(selectedF),terms_tested=nrow(oraF),significant=sum(oraF$FDR_BH<.05)),file.path(cdir,'results/GO_summary.tsv'))
export_plot(file.path(cdir,'figures/C07_GO_dynamic_programs'),function(){
  z<-head(oraF,12);par(mar=c(5,24,3,2));vv<-rev(-log10(pmax(z$FDR_BH,1e-300)));labs<-rev(substr(z$term,1,65))
  barplot(vv,names.arg=labs,horiz=TRUE,las=1,col=rev(ifelse(z$FDR_BH<.05,'#0072B2','grey70')),cex.names=.72,xlab='-log10 BH FDR (all eligible GO terms)',main='C. elegans graph-dynamic genes: GO BP ORA');abline(v=-log10(.05),lty=2)
},width=12,height=7)
cat('FUNCTIONAL_ORA_OK terms=',nrow(oraF),'significant=',sum(oraF$FDR_BH<.05),'\n')
