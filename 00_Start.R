# 统一入口：在 VS Code R Interactive 中先运行本文件，再依次运行所选方法。
# 仅配置与检查；不自动安装，不运行模型，不读取大型对象。
# 可先 options(toolkit.root='项目绝对路径', toolkit.library='独立R包库路径')。
# 当前运行器缺少标准Windows架构变量，cli 3.6.6退出清理会读取空值。
# 仅在变量缺失且当前R确认为x86_64时补齐进程变量；不修改系统或用户环境。
if(.Platform$OS.type=='windows' && !nzchar(Sys.getenv('PROCESSOR_ARCHITECTURE'))) {
  if(R.version$arch!='x86_64') stop('请按实际进程架构配置PROCESSOR_ARCHITECTURE，不要猜测。')
  Sys.setenv(PROCESSOR_ARCHITECTURE='AMD64')
}
toolkit_root <- getOption('toolkit.root', getwd())
if (!file.exists(file.path(toolkit_root, 'methods', 'Slingshot', 'SOURCE_CARD.md'))) {
  candidate <- file.path(toolkit_root, 'outputs', 'single-cell-trajectory-fate-toolkit')
  if (file.exists(file.path(candidate,'methods','Slingshot','SOURCE_CARD.md'))) toolkit_root <- candidate
}
stopifnot(file.exists(file.path(toolkit_root,'methods','Slingshot','SOURCE_CARD.md')))
toolkit_root <- normalizePath(toolkit_root,winslash='/')
toolkit_library <- getOption('toolkit.library',file.path(toolkit_root,'..','..','work','runtime','R-trajectory','library'))
if (dir.exists(toolkit_library)) .libPaths(c(normalizePath(toolkit_library,winslash='/'),.Library))
cfg <- list(root=toolkit_root, method='Slingshot', seed=20261019L,
            start_cluster='1', width=7.2, height=5.5, dpi=220,
            font='sans', background='white', point_cex=0.85,
            cluster_colors=c('1'='#4477AA','2'='#EE6677','3'='#228833','4'='#CCBB44','5'='#66CCEE'),
            missing_color='#BDBDBD')
cfg$method_dir <- file.path(cfg$root,'methods',cfg$method)
for (d in c('results','logs','figures')) dir.create(file.path(cfg$method_dir,d),recursive=TRUE,showWarnings=FALSE)
set.seed(cfg$seed)
options(stringsAsFactors=FALSE)
cat('Project:',cfg$root,'\nMethod:',cfg$method,'\n')
cat('Run 01 -> 02 -> 03. No automatic installation.\n')
