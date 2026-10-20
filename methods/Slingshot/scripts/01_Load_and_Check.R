# 01：读取官方随包模拟例并核对输入；本例没有基因计数，不是患者数据。
# 来源：BioC 3.23 slingshot vignette 的 data_sling 段。
stopifnot(exists('cfg'))
if (!requireNamespace('slingshot',quietly=TRUE)) stop('缺少 slingshot；请先按独立环境安装说明安装，不要在此自动安装。')
library(slingshot)
data('slingshotExample',package='slingshot')
rd <- slingshotExample$rd
cl <- slingshotExample$cl
stopifnot(is.matrix(rd),is.numeric(rd),nrow(rd)==length(cl),all(is.finite(rd)),!anyNA(cl))
# 官方例没有稳定barcode：只新增本地行号ID，不改变坐标、顺序或群标签。
cell_id <- sprintf('official_sim_%03d',seq_len(nrow(rd)))
stopifnot(!anyDuplicated(cell_id),ncol(rd)==2L)
rownames(rd) <- cell_id
names(cl) <- cell_id
input_table <- data.frame(cell_id=cell_id,dimension_1=rd[,1],dimension_2=rd[,2],cluster=as.character(cl))
write.table(input_table,file.path(cfg$method_dir,'results','input_coordinates.tsv'),sep='\t',row.names=FALSE,quote=FALSE)
write.table(as.data.frame(table(cluster=cl)),file.path(cfg$method_dir,'results','cluster_sizes.tsv'),sep='\t',row.names=FALSE,quote=FALSE)
input_check <- data.frame(metric=c('cells','dimensions','clusters','finite_coordinates','duplicate_cell_ids'),
 value=c(nrow(rd),ncol(rd),length(unique(cl)),sum(is.finite(rd)),anyDuplicated(cell_id)))
write.table(input_check,file.path(cfg$method_dir,'results','input_check.tsv'),sep='\t',row.names=FALSE,quote=FALSE)
saveRDS(list(rd=rd,cl=cl,cell_id=cell_id),file.path(cfg$method_dir,'results','checked_input.rds'))
cat('INPUT_OK\n');print(input_check);print(table(cl))
