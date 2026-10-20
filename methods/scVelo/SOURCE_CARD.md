# scVelo 来源与方法卡 / Source card

查询：2026-10-19。本目录是第一轮审查材料，尚无新实现或方法运行。

| INSTALL_OK | INPUT_OK | RUN_OK | FIGURE_OK |
|---|---|---|---|
| NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED |

下列图件是官方功能/代表性输出登记，不是本轮生成结果。已有人体/疾病数据不自动满足输入假设；历史scTour证据见[资产审查](../../docs/first_round/trajectory_fate_review_2026-10-19/02_EXISTING_ASSETS_AUDIT.md)。

[完整结构化来源与解释边界](source.json)

论文：["Generalizing RNA velocity to transient cell states through dynamical modeling"](https://doi.org/10.1038/s41587-020-0591-3)；[Crossref](https://api.crossref.org/works/10.1038/s41587-020-0591-3)。身份：RESOLVED_PRIMARY_PAPER_AND_OFFICIAL_CODE。

官方：[代码](https://github.com/theislab/scvelo) / [官网或文档](https://scvelo.readthedocs.io/en/stable/)。Bioconductor：官方安装渠道见下，未确认存在官方Bioconductor包。

固定默认分支SHA：`f63c0e70596ced2f1bee8cf07e8ab66037cf86b2`；commit date：`2026-02-25T16:21:48Z`。 许可：BSD-3-Clause。 [许可原文](https://github.com/theislab/scvelo/blob/main/LICENSE)。

教程：[Getting Started / stochastic](https://scvelo.readthedocs.io/en/stable/getting_started.html)；[Dynamical modeling](https://scvelo.readthedocs.io/en/stable/DynamicalModeling.html)。

数据入口（未下载/未核bytes，不能据链接默认大下载）：
- [官方pancreas H5AD API](https://scvelo.readthedocs.io/en/stable/scvelo.datasets.pancreas.html)；BYTES_NOT_VERIFIED。
- [明确模拟原型入口，不能当真实数据](https://scvelo.readthedocs.io/en/stable/scvelo.datasets.simulation.html)；作为方法资产记录。

依赖、OS与硬件：
- `python`：0.3.4: Python>=3.8；AnnData>=0.7.5、Scanpy>=1.5、loompy>=2.0.12、Numba>=0.41、NumPy>=1.17、SciPy>=1.4.1、scikit-learn>=0.21.2、matplotlib>=3.3；依赖下限不是已解析锁文件。
- `os`：本轮Windows/macOS/Linux均NOT_TESTED；Python包依赖还须按选定解释器解算。
- `hardware`：常规CPU；recover_dynamics按基因拟合可多核且耗时，RAM随cells/genes/neighbors增长。无官方统一GPU/最低RAM要求，本轮不运行。

输入：真实spliced/unspliced层、名称对齐的AnnData；适用的邻域/moments预处理；steady-state/stochastic与dynamical区分；dynamical需recover_dynamics，再velocity(mode='dynamical')。

输出：gene-space velocity及graph；dynamical kinetic参数/fit_t/latent time（依模式）；confidence、phase portrait及embedding投影。

代表图：原UMAP velocity stream/grid/arrows；基因spliced–unspliced相图；latent time和velocity confidence。

边界：
- 普通expression不能伪造S/U，integrated矩阵不能充当剪接计数。
- velocity图是模型估计和降维投影，latent time不是小时或疾病病程；反向/信号弱/模型假设失配须保留。
- stochastic已算不等于dynamical已算；不为箭头方向调整真实标签/细胞集合。

官方安装参考（**未执行**）：pip install scvelo（仅官方入口记录，未执行）。

状态：**installation=NOT_TESTED / run=NOT_TESTED / real_analysis=NOT_RUN**。
