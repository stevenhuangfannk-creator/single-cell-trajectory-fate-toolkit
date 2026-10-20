# 命令行入口：在项目根目录执行 Rscript --vanilla methods/Slingshot/scripts/run_example.R。
# VS Code建议逐段运行00、01、02、03，便于学习；本文件不负责安装。
options(warn=1)
if(.Platform$OS.type=='windows') Sys.setlocale('LC_ALL','English_United States.utf8')
cat('START_UTC',format(Sys.time(),tz='UTC',usetz=TRUE),'\n')
source('00_Start.R',encoding='UTF-8')
for(f in c('01_Load_and_Check.R','02_Infer_Lineages_and_Curves.R','03_Plot_and_Export.R')) {
  cat('\nSTEP',f,'\n')
  source(file.path(cfg$method_dir,'scripts',f),encoding='UTF-8')
}
cat('END_UTC',format(Sys.time(),tz='UTC',usetz=TRUE),'\n')
