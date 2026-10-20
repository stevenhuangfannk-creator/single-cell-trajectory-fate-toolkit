if(!exists('cdsM')) {
  suppressPackageStartupMessages(library(monocle3));mdir<-init_module('methods/Monocle3')
  cdsM<-readRDS(file.path(mdir,'results/cds_trajectory.rds'));gtM<-readRDS(file.path(mdir,'results/graph_test.rds'))
}
bpM<-function(color) plot_cells(cdsM,color_cells_by=color,label_cell_groups=FALSE,label_leaves=FALSE,label_branch_points=FALSE)+ggplot2::theme_bw()
export_plot(file.path(mdir,'figures/M01_celltypes_principal_graph'),function() print(bpM('cell.type')+ggplot2::ggtitle('Official neuron subset: learned principal graph')))
export_plot(file.path(mdir,'figures/M02_partitions'),function() print(bpM('partition')+ggplot2::ggtitle('Partitions: independently connected communities')))
export_plot(file.path(mdir,'figures/M03_rooted_pseudotime'),function() print(bpM('pseudotime')+ggplot2::ggtitle('Root-anchored graph pseudotime')))
export_plot(file.path(mdir,'figures/M04_embryo_time'),function() print(bpM('embryo.time')+ggplot2::ggtitle('Provided embryo-time annotation (not lineage tracing)')))
validM<-rownames(gtM)[gtM$status=='OK' & is.finite(gtM$q_value)]
topM<-head(validM[order(gtM[validM,'q_value'],-gtM[validM,'morans_I'])],6)
export_plot(file.path(mdir,'figures/M05_dynamic_gene_maps'),function() print(plot_cells(cdsM,genes=topM,show_trajectory_graph=FALSE,label_cell_groups=FALSE)+ggplot2::theme_bw()),width=10,height=7)
pseudotime_plotM<-readRDS(file.path(mdir,'results/pseudotime_gene_plot.rds'))
export_plot(file.path(mdir,'figures/M06_gene_expression_pseudotime'),function() print(pseudotime_plotM+ggplot2::theme_bw()),width=10,height=8)
writeLines(topM,file.path(mdir,'logs/figure_genes.txt'))
cat('FIGURE Monocle3 completed\n')
