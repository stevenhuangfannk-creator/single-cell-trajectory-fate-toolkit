# Monocle3 来源与方法卡 / Source card

查询：2026-10-19。本目录是第一轮审查材料，尚无新实现或方法运行。

| INSTALL_OK | INPUT_OK | RUN_OK | FIGURE_OK |
|---|---|---|---|
| NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED |

下列图件是官方功能/代表性输出登记，不是本轮生成结果。已有人体/疾病数据不自动满足输入假设；历史scTour证据见[资产审查](../../02_EXISTING_ASSETS_AUDIT.md)。

[完整结构化来源与解释边界](source.json)

论文：[**The single-cell transcriptional landscape of mammalian organogenesis**](https://doi.org/10.1038/s41586-019-0969-x)（Nature）。DOI `10.1038/s41586-019-0969-x`；[Crossref核验](https://api.crossref.org/works/10.1038%2Fs41586-019-0969-x)。

代码：[官方仓库](https://github.com/cole-trapnell-lab/monocle3)；截至日期SHA [`536f1033d6de7c957f26a1f403f81efbd825e0db`](https://github.com/cole-trapnell-lab/monocle3/commit/536f1033d6de7c957f26a1f403f81efbd825e0db)，commit时间 `2026-05-04T22:44:38Z`；[固定manifest](https://raw.githubusercontent.com/cole-trapnell-lab/monocle3/536f1033d6de7c957f26a1f403f81efbd825e0db/DESCRIPTION)。许可 **MIT + file LICENSE**。

官方入口：[Installation](https://cole-trapnell-lab.github.io/monocle3/docs/installation/)；[Getting started](https://cole-trapnell-lab.github.io/monocle3/docs/getting_started/)；[Trajectory tutorial](https://cole-trapnell-lab.github.io/monocle3/docs/trajectories/)；[Original article](https://pmc.ncbi.nlm.nih.gov/articles/PMC6434952/)。

版本注意：可核实正式GitHub release为v1.4.27（2026-05-05）；官方历史论文API与当前API不能混写。 官方安装页未与R4.6/BioC3.23同步更新；本轮不替用户决定环境迁移。

环境：固定SHA DESCRIPTION R>=4.0.0；安装页为最新功能推荐R>=4.4.1、BioC3.21、monocle3>=1.4.25。关键依赖：SingleCellExperiment、Biobase、BPCells（GitHub remote）、batchelor、HDF5Array、DelayedArray、igraph>=1.5.0、leidenbase>=0.1.25、uwot>=0.1.8、sf、spdep、Rcpp、speedglm（GitHub remote）。

- NeedsCompilation=yes；BPCells需要HDF5开发库，sf可能需要GDAL/GEOS/PROJ；具体包版本与OS决定源码构建要求。
- 官方安装页提及Mac Xcode与gfortran问题；Python/reticulate从monocle3>=0.2.0起不再是必需。
- BPCells磁盘矩阵保存应使用save_monocle_objects/load_monocle_objects，单独saveRDS可能遗失外部矩阵目录。
- 文档的R/BioC推荐组合与DESCRIPTION最低版本不同，均不是完整锁定环境，不能据此保证Windows或VS Code可运行。

输入：gene×cell绝对转录本/UMI counts；Matrix稀疏矩阵优先；cell_data_set(SingleCellExperiment派生)；cell_metadata行名=矩阵列名，gene_metadata行名=矩阵行名且含gene_short_name。保留既有注释、批次与时间信息；learn_graph的partition/UMAP和order_cells roots需记录。

主要输出：partition内principal_graph；根锚定pseudotime（根不可达时Inf）；graph_test或fit_models的基因关联/回归统计。

代表图：UMAP上principal graph并按注释/partition/pseudotime着色（plot_cells）；基因表达与轨迹或3D图（plot_cells, plot_cells_3d）。

教程与示例数据：

- [教程](https://cole-trapnell-lab.github.io/monocle3/docs/trajectories/)：Packer胚胎神经元subset的轨迹教程。
- [官方C. elegans L2表达及配套metadata](https://depts.washington.edu:/trapnell-lab/software/monocle3/celegans/data/cao_l2_expression.rds)：getting_started中的原始URL，保留官方冒号写法；本轮只读教程未请求RDS。规模：NOT_VERIFIED；不能将整份L2或胚胎数据称作轻量toy；获准后应明确选真实subset做小测试。数据类型 `REAL_PUBLIC_EXAMPLE`；获取/运行 `NOT_TESTED`。
  配套metadata：[文件1](https://depts.washington.edu:/trapnell-lab/software/monocle3/celegans/data/cao_l2_colData.rds)；[文件2](https://depts.washington.edu:/trapnell-lab/software/monocle3/celegans/data/cao_l2_rowData.rds)。

科学边界：

- partition可断开，每个需有效root；不要为得到连续树而擅自合并不相干细胞类型。
- pseudotime是图上相对距离，不是实测时间、速度或谱系追踪。
- UMAP/邻域/partition与根会影响结构；graph_test自相关不能证明TF调控或因果。

状态：`installation=NOT_TESTED; execution=NOT_TESTED; example_run=NOT_TESTED; real_data_analysis=NOT_TESTED`。
