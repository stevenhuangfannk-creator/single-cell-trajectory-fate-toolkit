options(timeout=180)
if(.Platform$OS.type=='windows' && !nzchar(Sys.getenv('PROCESSOR_ARCHITECTURE')) && R.version$arch=='x86_64') Sys.setenv(PROCESSOR_ARCHITECTURE='AMD64')
workspace <- normalizePath(getwd(), winslash='/')
root <- file.path(workspace,'outputs','single-cell-trajectory-fate-toolkit')
lib <- file.path(workspace,'work','runtime','R-trajectory','library')
dir.create(lib, recursive=TRUE, showWarnings=FALSE)
.libPaths(c(lib, .Library))
repos <- c(BioCsoft='https://bioconductor.org/packages/3.23/bioc',
           CRAN='https://cloud.r-project.org')
cat('R=',R.version.string,'\nLibrary=',lib,'\n')
ap <- available.packages(contriburl=contrib.url(repos,type='win.binary'),type='win.binary')
targets <- c('slingshot','DelayedMatrixStats')
needed <- unique(c(targets, unlist(tools::package_dependencies(targets, db=ap,
                     which=c('Depends','Imports','LinkingTo'), recursive=TRUE))))
base <- installed.packages(lib.loc=.Library)[,'Package']
needed <- setdiff(needed,c('R',base))
stopifnot(all(needed %in% rownames(ap)))
manifest <- data.frame(package=needed,version=ap[needed,'Version'],
 url=paste0(ap[needed,'Repository'],'/',needed,'_',ap[needed,'Version'],'.zip'),
 repository_md5=ap[needed,'MD5sum'],bytes=NA_real_,local_md5=NA_character_,
 status='PLANNED',stringsAsFactors=FALSE)
manifest_file <- file.path(root,'environments','download_manifest.csv')
write.csv(manifest,manifest_file,row.names=FALSE)
cat('Required non-base packages:',nrow(manifest),'\n')
print(manifest[,c('package','version')],row.names=FALSE)
dl <- file.path(workspace,'work','downloads')
for(i in seq_len(nrow(manifest))) {
  files <- list.files(dl,full.names=TRUE,recursive=TRUE)
  used <- sum(file.info(files)$size,na.rm=TRUE)
  remaining <- floor(1024^3-used-20*1024^2)
  if(remaining <= 0) stop('Authorized download budget exhausted')
  dest <- file.path(dl,basename(manifest$url[i]))
  cat('DOWNLOAD',i,'/',nrow(manifest),manifest$url[i],'remaining=',remaining,'\n')
  if(!file.exists(dest)) {
    rc <- system2('curl.exe',c('-sS','-L','--fail','--max-time','180',
           '--max-filesize',as.character(remaining),'--output',shQuote(dest),shQuote(manifest$url[i])))
    if(rc!=0) stop('Download failed, retained partial file: ',dest,' rc=',rc)
  }
  manifest$bytes[i] <- file.info(dest)$size
  manifest$local_md5[i] <- unname(tools::md5sum(dest))
  if(!is.na(manifest$repository_md5[i]) && nzchar(manifest$repository_md5[i])) {
    if(tolower(manifest$local_md5[i]) != tolower(manifest$repository_md5[i])) stop('MD5 mismatch: ',dest)
  }
  manifest$status[i] <- 'DOWNLOADED_VERIFIED'
  write.csv(manifest,manifest_file,row.names=FALSE)
  current <- installed.packages(lib.loc=lib)
  if(!(manifest$package[i] %in% rownames(current)) || current[manifest$package[i],'Version'] != manifest$version[i]) install.packages(dest,repos=NULL,type='win.binary',lib=lib)
  manifest$status[i] <- 'INSTALLED'
  write.csv(manifest,manifest_file,row.names=FALSE)
  disk <- sum(file.info(list.files(file.path(workspace,'work','runtime'),recursive=TRUE,full.names=TRUE))$size,na.rm=TRUE)
  if(disk > 4*1024^3) stop('Authorized runtime disk budget exceeded')
}
library(slingshot)
cat('INSTALL_OK: slingshot ',as.character(packageVersion('slingshot')),'\n')
write.csv(as.data.frame(installed.packages(lib.loc=c(lib,.Library)))[,c('Package','Version','LibPath','Built')],
          file.path(root,'environments','R-installed-packages.csv'),row.names=FALSE)
writeLines(capture.output(sessionInfo()),file.path(root,'environments','sessionInfo-install.txt'))
