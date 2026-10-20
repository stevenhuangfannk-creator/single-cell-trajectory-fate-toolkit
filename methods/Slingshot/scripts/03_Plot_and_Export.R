# 03：独立绘图。重启R后只需00和本文件，不重跑模型。
# 白底、固定坐标、三格式。图内文字用英文，中文逐图解释见figure_notes。
stopifnot(exists('cfg'))
if (!exists('crv1')) {
  fit <- readRDS(file.path(cfg$method_dir,'results','slingshot_fit.rds'))
  for(nm in c('rd','cl','lin1','crv1','pt','weights','lineages')) assign(nm,fit[[nm]])
}
if(!requireNamespace('slingshot',quietly=TRUE)) stop('需要原拟合环境中的slingshot。')
library(slingshot)
cluster_col <- cfg$cluster_colors[as.character(cl)]
if(anyNA(cluster_col)) stop('新增群缺少配色，请在00集中配置。')
draw_base <- function(colors=cluster_col,main='',subtitle='') {
  par(mar=c(5.5,4.2,3.1,1.1),bg='white',family=cfg$font)
  plot(rd,col=colors,pch=16,cex=cfg$point_cex,asp=1,
       xlab='Simulated dimension 1',ylab='Simulated dimension 2',main=main,sub=subtitle)
}
draw_cluster_legend <- function() legend('topleft',legend=paste('Cluster',sort(unique(cl))),
  col=cfg$cluster_colors[as.character(sort(unique(cl)))],pch=16,bty='n',cex=0.8)
export_figure <- function(stem,draw,width=cfg$width,height=cfg$height) {
  for(fmt in c('png','pdf','svg')) {
    path <- file.path(cfg$method_dir,'figures',paste0(stem,'.',fmt))
    if(fmt=='png') png(path,width=width,height=height,units='in',res=cfg$dpi,bg='white')
    if(fmt=='pdf') pdf(path,width=width,height=height,bg='white',family='Helvetica',useDingbats=FALSE)
    if(fmt=='svg') svg(path,width=width,height=height,bg='white',family='sans')
    tryCatch(draw(),finally=dev.off())
    stopifnot(file.info(path)$size>1000)
    cat('EXPORTED',basename(path),file.info(path)$size,'bytes\n')
  }
}
draw_S01 <- function() {
  draw_base(main='S01 | Cluster-level minimum spanning tree')
  lines(SlingshotDataSet(lin1),lwd=2.4,col='#333333')
  draw_cluster_legend()
}
draw_S02 <- function() {
  draw_base(main='S02 | Simultaneous principal curves')
  lines(SlingshotDataSet(crv1),lwd=2.4,col='#333333')
  draw_cluster_legend()
}
# 连续色标单独占一格，避免挤占散点或截断图例。
draw_continuous <- function(values,j,title,limits,label,palette,missing_label='cells without lineage pseudotime') {
  par(mfrow=c(1,1));layout(matrix(c(1,2),nrow=1),widths=c(6,1))
  ok <- is.finite(values)
  index <- rep(NA_integer_,length(values))
  index[ok] <- pmax(1L,pmin(100L,1L+floor(99*(values[ok]-limits[1])/diff(limits))))
  colors <- rep(cfg$missing_color,length(values));colors[ok] <- palette[index[ok]]
  draw_base(colors=colors,main=title,subtitle=paste(sum(!ok),missing_label))
  cv <- slingCurves(crv1)[[j]]
  lines(cv$s[cv$ord,,drop=FALSE],col='#333333',lwd=2)
  par(mar=c(5.5,0.5,3.1,4),bg='white')
  plot.new();plot.window(xlim=c(0,1),ylim=limits)
  y <- seq(limits[1],limits[2],length.out=101)
  rect(0.1,y[-101],0.48,y[-1],col=palette,border=NA)
  axis(4,at=pretty(limits,n=5),las=1,cex.axis=0.8)
  mtext(label,side=4,line=2.7,cex=0.85)
  layout(1)
}
export_figure('S01_cluster_MST',draw_S01)
export_figure('S02_principal_curves',draw_S02)
for(j in seq_len(ncol(pt))) {
  local({ jj <- j
    export_figure(paste0('S03_',colnames(pt)[jj],'_pseudotime'),function()
      draw_continuous(pt[,jj],jj,paste('S03 |',colnames(pt)[jj],'pseudotime'),
                      range(pt[,jj],na.rm=TRUE),'Relative pseudotime',hcl.colors(100,'Viridis')))
    export_figure(paste0('S04_',colnames(pt)[jj],'_curve_weight'),function() {
      draw_continuous(weights[,jj],jj,paste('S04 |',colnames(pt)[jj],'curve weight'),
                      c(0,1),'Curve assignment weight',colorRampPalette(c('#D9D9D9','#56B4E9','#0072B2'))(100),'cells with missing curve weight')
    })
  })
}
cat('FIGURE_FILES_CREATED; visual verification remains a separate check.\n')
