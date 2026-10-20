# Slingshot 来源与方法卡 / Source card

查询：2026-10-19。本目录是第一轮审查材料，尚无新实现或方法运行。

| INSTALL_OK | INPUT_OK | RUN_OK | FIGURE_OK |
|---|---|---|---|
| NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED |

下列图件是官方功能/代表性输出登记，不是本轮生成结果。已有人体/疾病数据不自动满足输入假设；历史scTour证据见[资产审查](../../docs/first_round/trajectory_fate_review_2026-10-19/02_EXISTING_ASSETS_AUDIT.md)。

[完整结构化来源与解释边界](source.json)

论文：[**Slingshot: cell lineage and pseudotime inference for single-cell transcriptomics**](https://doi.org/10.1186/s12864-018-4772-0)（BMC Genomics）。DOI `10.1186/s12864-018-4772-0`；[Crossref核验](https://api.crossref.org/works/10.1186%2Fs12864-018-4772-0)。

代码：[官方仓库](https://github.com/kstreet13/slingshot)；截至日期SHA [`3fa552f37148a24a9ef4f7bb5ec00e594a39d8cf`](https://github.com/kstreet13/slingshot/commit/3fa552f37148a24a9ef4f7bb5ec00e594a39d8cf)，commit时间 `2023-03-29T19:36:15Z`；[固定manifest](https://raw.githubusercontent.com/kstreet13/slingshot/3fa552f37148a24a9ef4f7bb5ec00e594a39d8cf/DESCRIPTION)。许可 **Artistic-2.0**。

官方入口：[Bioconductor 3.23](https://bioconductor.org/packages/3.23/bioc/html/slingshot.html)；[Release vignette](https://bioconductor.org/packages/3.23/bioc/vignettes/slingshot/inst/doc/vignette.html)；[Original paper record](https://pubmed.ncbi.nlm.nih.gov/29914354/)。

版本注意：GitHub main固定SHA DESCRIPTION为2.7.0（2023），BioC3.23为2.20.0；README提到的Python实现不替代本次审查的官方R包。

环境：R>=4.0；BioC3.23对应R4.6。关键依赖：princurve>=2.0.4、TrajectoryUtils、igraph、matrixStats、S4Vectors、SingleCellExperiment、SummarizedExperiment。

- BioC提供Windows/macOS二进制；本机兼容性未测试。
- 算法在已有低维矩阵上运行，不需要GPU；上游降维/聚类软件不属于其最小输入。
- 源码编译依赖及R/BioC版本需配套；不要将GitHub旧DESCRIPTION版本当最新BioC。

输入：cell×dimension低维坐标（如已有PCA）；cluster labels与行顺序对应；SingleCellExperiment或低维矩阵+聚类标签。复用已确认embedding/cluster；start.clus和end.clus可结合科学依据指定。

主要输出：cluster-level MST及lineage cluster序列；同时principal curves；cell×lineage pseudotime与curve weights。

代表图：低维散点叠加MST与lineage曲线（plot, lines(SlingshotDataSet)）；按lineage pseudotime着色及沿轨迹表达图（slingPseudotime, slingCurveWeights）。

教程与示例数据：

- [教程](https://bioconductor.org/packages/3.23/bioc/vignettes/slingshot/inst/doc/vignette.html)：官方140点分叉示例与300细胞模拟counts示例（均明确是模拟）。
- [slingshotExample](https://bioconductor.org/packages/3.23/bioc/vignettes/slingshot/inst/doc/vignette.html#datasets)：data("slingshotExample")；示例rd为140×2，cl长140。规模：官方小型接口/画图例子；模拟数据不作为真实科学结果。数据类型 `AUTHOR_SIMULATED_EXAMPLE`；获取/运行 `NOT_TESTED`。

科学边界：

- 对已有聚类与降维依赖明显；稀少/缺失中间状态可能改变MST。
- 主要为树样分化及分叉的光滑lineages，不应宣称已证明循环或汇聚谱系。
- curve weights是曲线归属权重，不是经实验校准的命运概率；pseudotime不是时间或因果证据。

状态：`installation=NOT_TESTED; execution=NOT_TESTED; example_run=NOT_TESTED; real_data_analysis=NOT_TESTED`。
