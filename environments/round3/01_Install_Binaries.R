# 显式调用才安装；不由00入口自动安装。使用本轮实际下载的精确版本与MD5。
source('round3/00_Start.R',encoding='UTF-8')
destlib<-getOption('toolkit.library',lib)
dir.create(destlib,recursive=TRUE,showWarnings=FALSE)
cache<-getOption('toolkit.install.cache',file.path(root,'../../work/round3/downloads'))
dir.create(cache,recursive=TRUE,showWarnings=FALSE)
tables<-c('round3_tradeSeq_downloads.csv','round3_Monocle3_downloads.csv','round3_BPCells_downloads.csv')
for(tab in tables) {
  z<-read.csv(file.path(root,'environments',tab))
  for(i in seq_len(nrow(z))) {
    ip<-installed.packages(lib.loc=c(destlib,.Library))
    if(z$package[i]%in%rownames(ip) && ip[z$package[i],'Version']==z$version[i]) next
    dest<-file.path(cache,basename(z$url[i]))
    if(!file.exists(dest)) {
      used<-sum(file.info(list.files(cache,recursive=TRUE,full.names=TRUE))$size,na.rm=TRUE)
      remain<-floor(1024^3-used);if(remain<1e6) stop('1 GiB cache guard reached')
      rc<-system2('curl.exe',c('-4','-L','--fail','--max-time','180','--max-filesize',as.character(remain),'-o',shQuote(dest),shQuote(z$url[i])))
      if(rc!=0) stop('Download failed; partial retained: ',dest)
    }
    stopifnot(unname(tools::md5sum(dest))==z$repository_md5[i])
    install.packages(dest,repos=NULL,type='win.binary',lib=destlib)
  }
}
cat('Pinned binary dependencies installed. Monocle3 and BPCells source builds are separate.\n')
