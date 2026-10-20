# 官方方法来源登记 / Official method registry

查询：2026-10-19。14方法分别有来源卡与结构化记录；主论文题名/DOI均已由Crossref核对。版本是观察值，尚未选定安装版本；GitHub开发SHA、release、Bioconductor发行和PyPI分别记录，不能混称相同版本。

**本轮 INSTALL_OK、INPUT_OK、RUN_OK、FIGURE_OK 均为 NOT_TESTED。** 此表登记官方能力和预期图件，未生成新科研图。数据仅登记URL，未下载或校验bytes/hash。

[完整CSV](OFFICIAL_METHOD_REGISTRY.csv) · [结构化JSON](OFFICIAL_METHOD_REGISTRY.json)

| 方法来源卡 | 官方代码 | 主论文DOI | 可核实版本（未安装） | 许可 |
|---|---|---|---|---|
| [Monocle2](methods/Monocle2/SOURCE_CARD.md) | [官方仓库](https://github.com/cole-trapnell-lab/monocle-release) | [10.1038/nmeth.4402](https://doi.org/10.1038/nmeth.4402) | BioC 3.23 / 2.40.0 | Artistic-2.0 |
| [Monocle3](methods/Monocle3/SOURCE_CARD.md) | [官方仓库](https://github.com/cole-trapnell-lab/monocle3) | [10.1038/s41586-019-0969-x](https://doi.org/10.1038/s41586-019-0969-x) | v1.4.27 | MIT + file LICENSE |
| [Slingshot](methods/Slingshot/SOURCE_CARD.md) | [官方仓库](https://github.com/kstreet13/slingshot) | [10.1186/s12864-018-4772-0](https://doi.org/10.1186/s12864-018-4772-0) | BioC 3.23 / 2.20.0 | Artistic-2.0 |
| [PAGA](methods/PAGA/SOURCE_CARD.md) | [官方仓库](https://github.com/scverse/scanpy) | [10.1186/s13059-019-1663-x](https://doi.org/10.1186/s13059-019-1663-x) | 1.12.4 | BSD-3-Clause |
| [Palantir](methods/Palantir/SOURCE_CARD.md) | [官方仓库](https://github.com/dpeerlab/Palantir) | [10.1038/s41587-019-0068-4](https://doi.org/10.1038/s41587-019-0068-4) | v1.4.5 | MIT |
| [scTour](methods/scTour/SOURCE_CARD.md) | [官方仓库](https://github.com/LiQian-XC/sctour) | [10.1186/s13059-023-02988-9](https://doi.org/10.1186/s13059-023-02988-9) | 1.0.0 | MIT |
| [tradeSeq](methods/tradeSeq/SOURCE_CARD.md) | [官方仓库](https://github.com/statOmics/tradeSeq) | [10.1038/s41467-020-14766-3](https://doi.org/10.1038/s41467-020-14766-3) | BioC 3.23 / 1.26.0 | MIT + file LICENSE |
| [CytoTRACE2](methods/CytoTRACE2/SOURCE_CARD.md) | [官方仓库](https://github.com/digitalcytometry/cytotrace2) | [10.1038/s41592-025-02857-2](https://doi.org/10.1038/s41592-025-02857-2) | R 1.1.0 / Python 1.1.0.4 | STANFORD NON-COMMERCIAL SOFTWARE LICENSE AGREEMENT |
| [FitDevo](methods/FitDevo/SOURCE_CARD.md) | [官方仓库](https://github.com/jumphone/FitDevo) | [10.1093/bib/bbac293](https://doi.org/10.1093/bib/bbac293) | v1.2.1 | UNKNOWN |
| [CellRank](methods/CellRank/SOURCE_CARD.md) | [官方仓库](https://github.com/scverse/cellrank) | [10.1038/s41592-024-02303-9](https://doi.org/10.1038/s41592-024-02303-9) | 2.3.3 | BSD-3-Clause |
| [scVelo](methods/scVelo/SOURCE_CARD.md) | [官方仓库](https://github.com/theislab/scvelo) | [10.1038/s41587-020-0591-3](https://doi.org/10.1038/s41587-020-0591-3) | 0.3.4 | BSD-3-Clause |
| [Cell2fate](methods/Cell2fate/SOURCE_CARD.md) | [官方仓库](https://github.com/BayraktarLab/cell2fate) | [10.1038/s41592-025-02608-3](https://doi.org/10.1038/s41592-025-02608-3) | tag v1.0.0 / metadata 0.01a | Apache-2.0 |
| [WOT](methods/WOT/SOURCE_CARD.md) | [官方仓库](https://github.com/broadinstitute/wot) | [10.1016/j.cell.2019.01.006](https://doi.org/10.1016/j.cell.2019.01.006) | 1.0.8.post2 | BSD-3-Clause |
| [VECTOR](methods/VECTOR/SOURCE_CARD.md) | [官方仓库](https://github.com/jumphone/Vector) | [10.1016/j.celrep.2020.108069](https://doi.org/10.1016/j.celrep.2020.108069) | VECTOR0.0.3（不是已核验release tag） | UNKNOWN |

## 需要保留的差异 / Material caveats

- Monocle2、Slingshot、tradeSeq的旧作者GitHub版本与现行Bioconductor版本不同；后续先明确复现目标，不自动安装默认分支。
- Monocle3安装页的推荐R/Bioc与DESCRIPTION最低版本不同，不能把最低版本当可运行环境锁。
- PAGA现行实现位于Scanpy；`theislab/paga`是原论文补充实现/复现资产，两者来源角色有区别。
- CellRank当前2.3.3与CytoTRACE2 Python1.1.0.4分别要求NumPy≥2和<2，不放同环境。CellRank的CytoTRACEKernel是原CytoTRACE的重实现，不是CytoTRACE2。
- Cell2fate release、源码metadata版本不一致；官方仓库固定旧依赖，PyPI同名查询404，不能靠猜包名安装。
- CytoTRACE2为Stanford非商业软件许可；FitDevo和VECTOR未找到明确仓库许可，不能假定允许再分发官方源码。
- VECTOR候选已以Cell Reports2020论文与作者jumphone/Vector相互核实；这与用户确认意指、许可证或实际可运行性不同。本轮不运行。
- WOT已不维护；CellRank from_wot弃用，F模块按三种兼容选项等待决策。

## 检索和错误边界 / Evidence limits

本轮是来源/工程可行性审查，不声称系统综述或完整API枚举。学术搜索MCP未挂载，使用Crossref公开API、论文、作者GitHub/官网和Bioconductor；保留主源记录和失败说明。GitHub限额、部分旧文档URL不可达，不等于方法运行失败。未执行方法，所以没有可报告的本轮运行成功/失败日志。

[检索协议](evidence/SEARCH_PROTOCOL.md) · [来源检索说明](evidence/SOURCE_RETRIEVAL_NOTES.md)
