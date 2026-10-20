# tradeSeq 来源与方法卡 / Source card

查询：2026-10-19。本目录是第一轮审查材料，尚无新实现或方法运行。

| INSTALL_OK | INPUT_OK | RUN_OK | FIGURE_OK |
|---|---|---|---|
| NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED |

下列图件是官方功能/代表性输出登记，不是本轮生成结果。已有人体/疾病数据不自动满足输入假设；历史scTour证据见[资产审查](../../docs/first_round/trajectory_fate_review_2026-10-19/02_EXISTING_ASSETS_AUDIT.md)。

[完整结构化来源与解释边界](source.json)

论文：[**Trajectory-based differential expression analysis for single-cell sequencing data**](https://doi.org/10.1038/s41467-020-14766-3)（Nature Communications）。DOI `10.1038/s41467-020-14766-3`；[Crossref核验](https://api.crossref.org/works/10.1038%2Fs41467-020-14766-3)。

代码：[官方仓库](https://github.com/statOmics/tradeSeq)；截至日期SHA [`02a9050674d8f0c0ebae8688fa9326dd76360d7d`](https://github.com/statOmics/tradeSeq/commit/02a9050674d8f0c0ebae8688fa9326dd76360d7d)，commit时间 `2025-06-17T14:45:33Z`；[固定manifest](https://raw.githubusercontent.com/statOmics/tradeSeq/02a9050674d8f0c0ebae8688fa9326dd76360d7d/DESCRIPTION)。许可 **MIT + file LICENSE**。

官方入口：[Bioconductor3.23](https://bioconductor.org/packages/3.23/bioc/html/tradeSeq.html)；[Workflow](https://statomics.github.io/tradeSeq/articles/tradeSeq.html)；[fitGAM details](https://statomics.github.io/tradeSeq/articles/fitGAM.html)；[Publisher paper](https://www.nature.com/articles/s41467-020-14766-3)。

版本注意：BioC3.23为1.26.0；GitHub master固定SHA DESCRIPTION仍1.13.12，GitHub release v0.99.46为2019旧发布，不能称当前版本。

环境：R>=3.6；BioC3.23发行栈为R4.6。关键依赖：mgcv、edgeR、SingleCellExperiment、SummarizedExperiment、slingshot、TrajectoryUtils、BiocParallel、Biobase、princurve、igraph、Matrix、ggplot2、matrixStats。

- BioC3.23提供Windows/macOS二进制；本机未测试。
- 每基因NB-GAM拟合可很耗时，完整基因组和多lineages不属默认小测试；应由用户确认运行规模。
- BiocParallel后端与Windows多进程策略需单独设定，不承诺fork行为可跨平台。

输入：gene×cell非负counts；NB模型需匹配计数尺度与offset/normalization；已有cell×lineage pseudotime与cellWeights，或Slingshot对象；可配协变量/condition design。明确上游轨迹及cell/gene顺序；本方法不重新决定root、分支或拓扑。

主要输出：逐基因NB-GAM模型、converged标记及拟合曲线；associationTest/startVsEndTest/diffEndTest/patternTest/earlyDETest统计；predictSmooth与基因模式聚类（可选）。

代表图：各lineage的基因表达平滑曲线（plotSmoothers）；低维空间基因counts与轨迹/knots（plotGeneCount）；evaluateK AIC与平滑表达模式热图（evaluateK, predictSmooth）。

教程与示例数据：

- [教程](https://statomics.github.io/tradeSeq/articles/tradeSeq.html)：随包提供的Paul15 subset countMatrix、crv、celltype。
- [countMatrix/crv/celltype随包例子](https://statomics.github.io/tradeSeq/articles/tradeSeq.html#load-data)：data(countMatrix,package='tradeSeq'); data(crv); data(celltype)，未加载。规模：真实Paul15筛选subset；教程拟合converged显示240基因，未下载独立复核全部维度。数据类型 `REAL_PUBLIC_EXAMPLE_SUBSET`；获取/运行 `NOT_TESTED`。

科学边界：

- 这是轨迹下游DE框架，不是新的轨迹推断方法；上游错误不会被自动修复。
- 统计结论依赖轨迹、knots、offset、convergence和检验对比；需保存失败基因，不能把NA当显著。
- p值/FDR不代表因果驱动，拟合条件于估计轨迹；普通逐细胞检验不能替代供者/生物重复设计。
- patternTest比较不同lineage等相对位置需慎重，伪时序尺度不必等同真实时间；多重检验和效应量需明确。

状态：`installation=NOT_TESTED; execution=NOT_TESTED; example_run=NOT_TESTED; real_data_analysis=NOT_TESTED`。
