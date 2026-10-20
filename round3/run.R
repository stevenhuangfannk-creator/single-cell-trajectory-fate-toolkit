# 简单命令行入口：Rscript round3/run.R tradeSeq|Monocle3|combination [replot]
args3<-commandArgs(trailingOnly=TRUE)
if(length(args3)<1L) stop('Choose tradeSeq, Monocle3 or combination')
if(nzchar(Sys.getenv('TOOLKIT_LIBRARY'))) options(toolkit.library=Sys.getenv('TOOLKIT_LIBRARY'))
source('round3/00_Start.R',encoding='UTF-8')
paths3<-c(tradeSeq='methods/tradeSeq',Monocle3='methods/Monocle3',combination='combinations/Slingshot_tradeSeq_Monocle3')
if(!args3[1]%in%names(paths3)) stop('Unknown method')
replot3<-length(args3)>1L && args3[2]=='replot'
script3<-if(!replot3) 'run_example.R' else switch(args3[1],tradeSeq='03_Plot_and_Export.R',Monocle3='04_Plot_and_Export.R',combination='04_Plot_and_Export.R')
source(file.path(root,paths3[args3[1]],'scripts',script3),encoding='UTF-8')
