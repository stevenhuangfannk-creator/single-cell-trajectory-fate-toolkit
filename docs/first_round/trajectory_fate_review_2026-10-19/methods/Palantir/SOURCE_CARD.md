# Palantir 来源与方法卡 / Source card

查询：2026-10-19。本目录是第一轮审查材料，尚无新实现或方法运行。

| INSTALL_OK | INPUT_OK | RUN_OK | FIGURE_OK |
|---|---|---|---|
| NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED |

下列图件是官方功能/代表性输出登记，不是本轮生成结果。已有人体/疾病数据不自动满足输入假设；历史scTour证据见[资产审查](../../02_EXISTING_ASSETS_AUDIT.md)。

[完整结构化来源与解释边界](source.json)

论文：[**Characterization of cell fate probabilities in single-cell data with Palantir**](https://doi.org/10.1038/s41587-019-0068-4)（Nature Biotechnology）。DOI `10.1038/s41587-019-0068-4`；[Crossref核验](https://api.crossref.org/works/10.1038%2Fs41587-019-0068-4)。

代码：[官方仓库](https://github.com/dpeerlab/Palantir)；截至日期SHA [`f819d5156c8f9a24238fd77fc6d45af16761edfc`](https://github.com/dpeerlab/Palantir/commit/f819d5156c8f9a24238fd77fc6d45af16761edfc)，commit时间 `2026-09-23T17:26:52Z`；[固定manifest](https://raw.githubusercontent.com/dpeerlab/Palantir/f819d5156c8f9a24238fd77fc6d45af16761edfc/pyproject.toml)。许可 **MIT**。

官方入口：[Documentation](https://palantir.readthedocs.io/en/latest/)；[Basic tutorial](https://palantir.readthedocs.io/en/latest/notebooks/Palantir_sample_notebook.html)；[Publisher paper](https://www.nature.com/articles/s41587-019-0068-4)。

版本注意：GitHub正式release1.4.5（2026-07-15），latest文档标题仍1.4.4；README1.4.6标future，不当已发行。 1.4.5变更随机数Generator/PCG64，官方说明精确数值会不同于旧版；需固定版本与seed。

环境：v1.4.5 pyproject Python>=3.9；最终可解环境还受Scanpy/Numba/JAX等依赖限制。关键依赖：scanpy>=1.6.0、mellon>=1.6.1、anndata>=0.8.0、ml_dtypes>=0.5.0、igraph>=0.11.8、scikit-learn、matplotlib>=3.8.0、numpy>=1.17.0、pandas>=0.22.0、scipy>=1.3、networkx>=2.1、joblib、可选gam: pygam；可选fcs: fcsparser。

- 主流程为CPU图/稀疏求解，无强制CUDA声明；具体Mellon/JAX及绘图依赖仍需目标平台测试。
- pyproject为OS Independent并列Linux；这不是本Windows环境已验证。
- 可选pygam的旧版与新SciPy兼容问题在README中有说明；不把可选趋势拟合当核心算法必需。

输入：经明确预处理的cell×gene表达/AnnData，以及PCA、diffusion/multiscale空间；AnnData推荐，或API支持的dataframe；需要有依据的early_cell，terminal可推断或指定。既有QC/注释/根与终末依据需保留，归一化/对数转换不能重复。

主要输出：root相关pseudotime；terminal fate/branch probabilities；differentiation entropy及gene trends（可选）。

代表图：embedding上pseudotime、entropy和各terminal概率（palantir.plot.plot_palantir_results）；分支概率对比和沿lineage基因趋势/趋势聚类（palantir.plot.plot_branch_selection, palantir.plot.plot_gene_trends）。

教程与示例数据：

- [教程](https://palantir.readthedocs.io/en/latest/notebooks/Palantir_sample_notebook.html)：4142细胞×16106基因的骨髓样例；原notebook亦在GitHub/notebooks。
- [marrow_sample_scseq_counts.h5ad](https://dp-lab-data-public.s3.amazonaws.com/palantir/marrow_sample_scseq_counts.h5ad)：作者教程直接链接，仅记录未GET数据。规模：教程显示4142×16106；文件大小未核实，不声称可瞬时运行。数据类型 `REAL_PUBLIC_EXAMPLE`；获取/运行 `NOT_TESTED`。

科学边界：

- 依赖分化过程的方向、起点、终末及表型流形/Markov假设，适用性须结合真实生物过程判断。
- fate概率是模型内吸收概率，不等于每个细胞将来命运的实验频率；entropy不是已校准万能干性。
- 图断裂、遗漏终末、root选择和密度影响概率；不自动消除批次和非分化混杂。

状态：`installation=NOT_TESTED; execution=NOT_TESTED; example_run=NOT_TESTED; real_data_analysis=NOT_TESTED`。
