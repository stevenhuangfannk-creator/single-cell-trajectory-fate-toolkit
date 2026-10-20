# WOT 来源与方法卡 / Source card

查询：2026-10-19。本目录是第一轮审查材料，尚无新实现或方法运行。

| INSTALL_OK | INPUT_OK | RUN_OK | FIGURE_OK |
|---|---|---|---|
| NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED |

下列图件是官方功能/代表性输出登记，不是本轮生成结果。已有人体/疾病数据不自动满足输入假设；历史scTour证据见[资产审查](../../02_EXISTING_ASSETS_AUDIT.md)。

[完整结构化来源与解释边界](source.json)

论文：["Optimal-Transport Analysis of Single-Cell Gene Expression Identifies Developmental Trajectories in Reprogramming"](https://doi.org/10.1016/j.cell.2019.01.006)；[Crossref](https://api.crossref.org/works/10.1016/j.cell.2019.01.006)。身份：RESOLVED_PRIMARY_PAPER_AND_OFFICIAL_CODE。

官方：[代码](https://github.com/broadinstitute/wot) / [官网或文档](https://broadinstitute.github.io/wot/)。Bioconductor：官方安装渠道见下，未确认存在官方Bioconductor包。

固定默认分支SHA：`ca5e94f05699997b01cf5ae13383f9810f0613f6`；commit date：`2021-03-31T15:27:28Z`。 许可：BSD-3-Clause。 [许可原文](https://github.com/broadinstitute/wot/blob/master/LICENSE)。

教程：[官方8个notebook及CLI教程](https://broadinstitute.github.io/wot/tutorial/)；[官方notebooks源码](https://github.com/broadinstitute/wot/tree/master/notebooks)。

数据入口（未下载/未核bytes，不能据链接默认大下载）：
- [教程input data与precomputed transport maps链接位于此页](https://broadinstitute.github.io/wot/tutorial/)；NOT_CONFIRMED_SMALL：教程39时间点/18天，input zip/maps zip bytes未查，不默认下载全量。

依赖、OS与硬件：
- `python`：PyPI1.0.8.post2（2020-08-24），requires_python>=3；setup.py依赖numpy/pandas/h5py/anndata/scikit-learn/scipy/matplotlib/POT，未充分限定现代版本，不能由宽下限宣称新栈兼容。
- `os`：历史setup classifiers包含Windows/macOS/Linux及Python3.5/3.6，本轮均NOT_TESTED。
- `hardware`：OT成本/耦合可按源×目标细胞增长；CPU/RAM预算须按timepoint sizes预估，最低RAM未知。官方FLE作图例另用Java，非OT核心强制依赖。
- `maintenance`：官方CellRank2.3 stable将WOT标unmaintained；WOT默认分支最近commit为2021-03-31。

输入：真实采样time-course；expression与cell_days逐cell ID匹配，至少可比较的多个时间点；growth/proliferation/apoptosis rates及定义；教程log-normalized TPM与局部PCA cost；把疾病组别/拟时序直接冒充实验采样day。

输出：相邻真实时间点间OT transport maps（descendant mass）；ancestor/descendant trajectories、fate matrices；可选interpolation/trajectory gene trends。

代表图：temporal transport map热图/流图；ancestor/descendant/fate可视化；随真实时间的trajectory gene trends。

边界：
- transport mass不是原始行归一化概率；growth与采样/成本/正则化假设影响结果。
- 横断面静态组不能给出真实时间耦合；模型最优耦合不是观测细胞谱系。
- CellRank.from_wot since2.2 deprecated，3.0将移除；保留WOT需冻结兼容环境或显式couplings。moscot是需另行确认的方法变化，本轮不替换。

官方安装参考（**未执行**）：pip install wot或官方environment.yml（仅记录，未执行）。

状态：**installation=NOT_TESTED / run=NOT_TESTED / real_analysis=NOT_RUN**。
