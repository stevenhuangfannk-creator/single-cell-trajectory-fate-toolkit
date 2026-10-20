# Cell2fate 来源与方法卡 / Source card

查询：2026-10-19。本目录是第一轮审查材料，尚无新实现或方法运行。

| INSTALL_OK | INPUT_OK | RUN_OK | FIGURE_OK |
|---|---|---|---|
| NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED |

下列图件是官方功能/代表性输出登记，不是本轮生成结果。已有人体/疾病数据不自动满足输入假设；历史scTour证据见[资产审查](../../docs/first_round/trajectory_fate_review_2026-10-19/02_EXISTING_ASSETS_AUDIT.md)。

[完整结构化来源与解释边界](source.json)

论文：["Cell2fate infers RNA velocity modules to improve cell fate prediction"](https://doi.org/10.1038/s41592-025-02608-3)；[Crossref](https://api.crossref.org/works/10.1038/s41592-025-02608-3)。身份：RESOLVED_PRIMARY_PAPER_AND_OFFICIAL_CODE。

官方：[代码](https://github.com/BayraktarLab/cell2fate) / [官网或文档](https://cell2fate.readthedocs.io/en/latest/)。Bioconductor：官方安装渠道见下，未确认存在官方Bioconductor包。

固定默认分支SHA：`c03d1ca0bb963f550001c6070d4986a61ec8456a`；commit date：`2025-03-20T12:26:08Z`。GitHub release v1.0.0（2024-09-08）；当前固定SHA setup.cfg metadata version=0.01a。两个字段不同；PyPI /pypi/cell2fate/json返回404，不编造PyPI稳定版。 许可：Apache-2.0。 [许可原文](https://github.com/BayraktarLab/cell2fate/blob/main/LICENSE)。

教程：[官方PancreasWithCC完整教程](https://cell2fate.readthedocs.io/en/latest/notebooks/publication_figures/cell2fate_PancreasWithCC.html)；[官方安装说明](https://cell2fate.readthedocs.io/en/latest/installation.html)；[论文重现notebooks（README指向）](https://github.com/AlexanderAivazidis/cell2fate_notebooks)。

数据入口（未下载/未核bytes，不能据链接默认大下载）：
- [官方教程拼出的Pancreas_with_cc H5AD；只记录链接](https://cell2fate.cog.sanger.ac.uk/Pancreas_with_cc/Pancreas_with_cc_anndata.h5ad)；NOT_CONFIRMED_SMALL; 未对二进制URL作下载或大小探针。

依赖、OS与硬件：
- `documented_environment`：官方Python3.9独立conda环境；setup.cfg固定scvi-tools0.16.1、anndata0.8.0、torch1.11.0、NumPy1.23.5、SciPy1.8.0、Scanpy1.9.1、scVelo0.2.4、pandas1.4.2、JAX/JAXlib0.4.10、pyro-ppl>=1.8等。
- `os`：教程偏Linux/conda；Windows本轮NOT_TESTED，旧torch/JAX/scvi组合是否能在本机安装UNKNOWN。
- `hardware`：PyTorch/Pyro模型训练；README给新GPU/CUDA>10.2的torch/cu116替换提示，但会偏离setup pin，需要预先决定并测试，不自动覆盖环境。最低RAM/VRAM UNKNOWN。
- `compatibility`：与当前CellRank2.3.3的Python>=3.12/NumPy>=2及历史RegVelo环境均不宜混装。

输入：AnnData layers['spliced']/['unspliced']真实raw UMI计数；setup_anndata(...,spliced_label='spliced',unspliced_label='unspliced')；特征/细胞筛选、module数和训练参数需要框架预先确认，不能自动删除群或调参追求方向。

输出：模块化RNA velocity、逐cell模型时间；转录模块ON/OFF活动、基因负载及动力学参数；后验不确定性/模型QC对象。

代表图：velocity UMAP；module activation/time图；module summary statistics、基因拟合/后验QC。

边界：
- 模块与速度为动力学模型预测，不是实验TF因果或真正追踪。
- 它不是无S/U的表达拟时序替代品；仅有counts不准入。
- 官方教程含按cluster筛选操作，不可在用户真实数据上未经确认照抄。

官方安装参考（**未执行**）：官方conda Python3.9后pip install git+https://github.com/BayraktarLab/cell2fate；本轮未执行。

状态：**installation=NOT_TESTED / run=NOT_TESTED / real_analysis=NOT_RUN**。
