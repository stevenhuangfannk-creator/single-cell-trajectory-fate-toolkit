# 显式安装入口：仅在用户选择的独立包库安装已验收的固定二进制包。
# 从项目根目录运行；不更新全局包，不安装Suggests，不下载R本身。
# 可先 options(toolkit.library='独立包库路径', toolkit.download_dir='软件缓存路径')。
root <- normalizePath(getwd(),winslash='/')
stopifnot(file.exists('environments/download_manifest.csv'))
if(getRversion() < '4.6' || getRversion() >= '4.7' || .Platform$OS.type!='windows') {
  stop('此清单针对Windows R4.6二进制；其他平台请重新解析与验证，不混用。')
}
if(!nzchar(Sys.getenv('PROCESSOR_ARCHITECTURE')) && R.version$arch=='x86_64') Sys.setenv(PROCESSOR_ARCHITECTURE='AMD64')
lib <- getOption('toolkit.library',file.path(root,'work','runtime','R-trajectory','library'))
dl <- getOption('toolkit.download_dir',file.path(root,'work','downloads'))
dir.create(lib,recursive=TRUE,showWarnings=FALSE)
dir.create(dl,recursive=TRUE,showWarnings=FALSE)
.libPaths(c(lib,.Library))
m <- read.csv('environments/download_manifest.csv',stringsAsFactors=FALSE)
for(i in seq_len(nrow(m))) {
  p <- file.path(dl,basename(m$url[i]))
  left <- floor(1024^3-sum(file.info(list.files(dl,full.names=TRUE,recursive=TRUE))$size,na.rm=TRUE))
  if(left<=0) stop('下载缓存达到1GiB，停止。R安装文件等其他下载也应计入批准总额。')
  if(!file.exists(p)) {
    rc <- system2('curl.exe',c('-sS','-L','--fail','--max-time','180','--max-filesize',left,
                   '--output',shQuote(p),shQuote(m$url[i])))
    if(rc!=0) stop('下载失败：',m$package[i])
  }
  # 与本次已归档清单比对；该MD5是本地固定文件校验值，并非仓库签名。
  if(tolower(unname(tools::md5sum(p)))!=tolower(m$local_md5[i])) stop('固定文件校验不一致：',m$package[i])
  install.packages(p,repos=NULL,type='win.binary',lib=lib)
}
library(slingshot)
stopifnot(as.character(packageVersion('slingshot'))=='2.20.0')
cat('INSTALL_OK\n');sessionInfo()
