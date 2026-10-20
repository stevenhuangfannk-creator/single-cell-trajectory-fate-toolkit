Sys.setenv(PROCESSOR_ARCHITECTURE='AMD64',OMP_NUM_THREADS='1',MAKEFLAGS='-j1')
options(timeout=90);.libPaths(c(file.path(getwd(),'work/runtime/R-trajectory/library'),.Library))
ap<-available.packages(contriburl=contrib.url(c(BioC='https://bioconductor.org/packages/3.23/bioc',CRAN='https://cloud.r-project.org'),type='win.binary'),type='win.binary')
d<-read.dcf('work/round3/src/BPCells-0.3.1/r/DESCRIPTION')
deps<-unique(trimws(gsub('\\s*\\(.*?\\)','',unlist(strsplit(paste(d[1,c('Depends','Imports','LinkingTo')],collapse=','),',')))))
targets<-setdiff(deps,c('R','BPCells'))
needed<-unique(c(targets,unlist(tools::package_dependencies(targets,db=ap,which=c('Depends','Imports','LinkingTo'),recursive=TRUE))))
needed<-setdiff(needed,c('R',rownames(installed.packages())))
stopifnot(all(needed %in% rownames(ap)))
m<-data.frame(package=needed,version=ap[needed,'Version'],url=paste0(ap[needed,'Repository'],'/',needed,'_',ap[needed,'Version'],'.zip'),repository_md5=ap[needed,'MD5sum'],bytes=NA_real_,md5='',status='PLANNED')
mf<-'outputs/single-cell-trajectory-fate-toolkit/environments/round3_BPCells_downloads.csv';write.csv(m,mf,row.names=FALSE)
print(m[,1:2]);flush.console()
for(i in seq_len(nrow(m))) {
  dest<-file.path('work/round3/downloads',basename(m$url[i]));cat('DOWNLOAD',i,'/',nrow(m),m$package[i],'\n');flush.console()
  if(!file.exists(dest)) {
    used<-sum(file.info(list.files('work/round3',full.names=TRUE,recursive=TRUE))$size,na.rm=TRUE)
    rc<-system2('curl.exe',c('-4','-sS','-L','--fail','--retry','1','--max-time','90','--max-filesize',as.character(floor(1024^3-used)),'--output',shQuote(dest),shQuote(m$url[i])))
    if(rc!=0) stop('DOWNLOAD_FAIL ',m$package[i])
  }
  m$bytes[i]<-file.info(dest)$size;m$md5[i]<-unname(tools::md5sum(dest));stopifnot(is.na(m$repository_md5[i])||m$md5[i]==m$repository_md5[i])
  install.packages(dest,repos=NULL,type='win.binary',lib=.libPaths()[1]);m$status[i]<-'INSTALLED';write.csv(m,mf,row.names=FALSE)
}
cat('BINARY_DEPENDENCIES_OK\n')

