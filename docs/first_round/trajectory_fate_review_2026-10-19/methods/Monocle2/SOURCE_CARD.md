# Monocle2 来源与方法卡 / Source card

查询：2026-10-19。本目录是第一轮审查材料，尚无新实现或方法运行。

| INSTALL_OK | INPUT_OK | RUN_OK | FIGURE_OK |
|---|---|---|---|
| NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED |

下列图件是官方功能/代表性输出登记，不是本轮生成结果。已有人体/疾病数据不自动满足输入假设；历史scTour证据见[资产审查](../../02_EXISTING_ASSETS_AUDIT.md)。

[完整结构化来源与解释边界](source.json)

论文：[**Reversed graph embedding resolves complex single-cell trajectories**](https://doi.org/10.1038/nmeth.4402)（Nature Methods）。DOI `10.1038/nmeth.4402`；[Crossref核验](https://api.crossref.org/works/10.1038%2Fnmeth.4402)。

代码：[官方仓库](https://github.com/cole-trapnell-lab/monocle-release)；截至日期SHA [`7df105006756801a305ff43321b26d289cd6e890`](https://github.com/cole-trapnell-lab/monocle-release/commit/7df105006756801a305ff43321b26d289cd6e890)，commit时间 `2019-01-04T21:39:40Z`；[固定manifest](https://raw.githubusercontent.com/cole-trapnell-lab/monocle-release/7df105006756801a305ff43321b26d289cd6e890/DESCRIPTION)。许可 **Artistic-2.0**。

官方入口：[Author documentation](https://cole-trapnell-lab.github.io/monocle-release/docs/)；[Bioconductor 3.23 monocle](https://bioconductor.org/packages/3.23/bioc/html/monocle.html)；[Author paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC5764547/)。

版本注意：官方旧GitHub固定SHA的DESCRIPTION是2.9.0，BioC3.23的monocle是2.40.0；不同来源必须分别记录，不能把旧repo称现行BioC发行。

环境：DESCRIPTION R>=2.10.0；旧README写R>=3.0；BioC3.23对应R4.6。关键依赖：Matrix>=1.2-6、Biobase、VGAM>=1.0-6、DDRTree>=0.1.4、igraph>=1.0.1、ggplot2、BiocGenerics、Rcpp>=0.12.0、HSMMSingleCell。

- 历史README仅确认Mac/Linux，Windows当时未测试；BioC3.23现在提供Windows及macOS二进制，二者不等价于本机测试通过。
- 源码依赖DDRTree/Rcpp等编译组件，旧igraph/Matrix接口与新R栈兼容性需独立环境验证。
- 建议按所选BioC/R配套固定依赖，不直接套用2017教程的biocLite指令。

输入：gene×cell表达矩阵；UMI counts或相对表达需选匹配的expressionFamily，不混用尺度；CellDataSet；phenoData和featureData名称与矩阵对齐，gene_short_name用于标签。已完成QC/归一化审查、已有细胞注释；显式ordering genes及有证据的root_state。

主要输出：DDRTree主树及细胞投影；Pseudotime、State与root选择记录；differentialGeneTest/BEAM表（按明确假设）。

代表图：轨迹树按注释/State/Pseudotime着色（plot_cell_trajectory）；基因沿伪时序曲线及分支热图（plot_genes_in_pseudotime, plot_genes_branched_heatmap）。

教程与示例数据：

- [教程](https://cole-trapnell-lab.github.io/monocle-release/docs/)：Tutorial: HSMM myoblast differentiation；reduceDimension/orderCells/BEAM。
- [HSMMSingleCell/HSMM官方示例](https://bioconductor.org/packages/3.23/data/experiment/html/HSMMSingleCell.html)：Bioconductor示例数据包；教程load_HSMM()入口。规模：教程用小规模HSMM；本轮未下载，未独立检查细胞数/文件大小。数据类型 `REAL_PUBLIC_EXAMPLE`；获取/运行 `NOT_TESTED`。

科学边界：

- DDRTree默认学习树结构，不能据其证明真实循环、汇聚或谱系亲缘。
- 根、ordering genes、降维和细胞选择改变伪时序；伪时序不等于采样小时。
- BEAM表达关联不等于直接调控或因果分支决定；不替代真实谱系/扰动验证。

状态：`installation=NOT_TESTED; execution=NOT_TESTED; example_run=NOT_TESTED; real_data_analysis=NOT_TESTED`。
