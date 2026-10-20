# 第三轮统一入口；不调用或覆盖第二轮 Slingshot 运行脚本。
# VS Code：先设 options(toolkit.root='仓库路径', toolkit.library='独立包库')，再 source 本文件。
if(.Platform$OS.type=='windows' && !nzchar(Sys.getenv('PROCESSOR_ARCHITECTURE'))) Sys.setenv(PROCESSOR_ARCHITECTURE='AMD64')
Sys.setenv(OMP_NUM_THREADS='1',OPENBLAS_NUM_THREADS='1',MKL_NUM_THREADS='1')
options(stringsAsFactors=FALSE,timeout=120)
options(mc.cores=1L)
root <- getOption('toolkit.root',getwd())
if(!file.exists(file.path(root,'methods/tradeSeq/source.json'))) root <- file.path(root,'outputs/single-cell-trajectory-fate-toolkit')
root <- normalizePath(root,winslash='/',mustWork=TRUE)
lib <- getOption('toolkit.library',file.path(root,'../../work/runtime/R-trajectory/library'))
if(dir.exists(lib)) .libPaths(c(normalizePath(lib,winslash='/'),.Library))
if(requireNamespace('BiocParallel',quietly=TRUE)) BiocParallel::register(BiocParallel::SerialParam())
if(requireNamespace('future',quietly=TRUE)) future::plan(future::sequential)
if(requireNamespace('RhpcBLASctl',quietly=TRUE)) {RhpcBLASctl::blas_set_num_threads(1L);RhpcBLASctl::omp_set_num_threads(1L)}
# 参数集中：官方 tradeSeq 使用 6 个结点和 seed=7；不把结点当作生物学分叉。
cfg3 <- list(root=root,seed=7L,nknots=6L,fdr=0.05,npoints=100L,
             top_heatmap=30L,width=8,height=6,dpi=180,
             monocle_seed=20261019L,num_dim=20L,umap_neighbors=15L,
             graph_min_branch=10L,cores=1L,official_num_dim=50L,min_detected_cells=20L,
             common_hvg=2000L,common_fit_genes=300L,m06_min_detection=.2,
             lineage_weight_min=.5,late_fraction=.8,moran_cutoff=.1,
             early_knots=c(1L,2L),common_types=c('Neuroblast_ASG_AWA','ASG_AWA','ASG','AWA'))
set.seed(cfg3$seed)
init_module <- function(path) {
  out <- file.path(root,path)
  for(d in c('scripts','results','figures','logs','figure_notes','example_data')) dir.create(file.path(out,d),recursive=TRUE,showWarnings=FALSE)
  out
}
write_tsv <- function(x,path,row_names=FALSE) {
  if(row_names) x <- data.frame(gene=rownames(x),as.data.frame(x),check.names=FALSE)
  write.table(x,path,sep='\t',row.names=FALSE,quote=FALSE,na='NA')
}
# 同一绘图函数导出三种格式；重绘只读取小型拟合结果，不重新训练。
export_plot <- function(path,draw,width=cfg3$width,height=cfg3$height) {
  for(ext in c('png','pdf','svg')) {
    f <- paste0(path,'.',ext)
    if(ext=='png') png(f,width=width,height=height,units='in',res=cfg3$dpi,bg='white')
    if(ext=='pdf') pdf(f,width=width,height=height,bg='white',useDingbats=FALSE)
    if(ext=='svg') svg(f,width=width,height=height,bg='white')
    tryCatch(draw(),finally=dev.off())
  }
}
cat('Round3 project:',root,'; serial cores=',cfg3$cores,'\n')
