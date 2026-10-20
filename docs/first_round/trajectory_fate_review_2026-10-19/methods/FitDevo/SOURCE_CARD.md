# FitDevo 来源与方法卡 / Source card

查询：2026-10-19。本目录是第一轮审查材料，尚无新实现或方法运行。

| INSTALL_OK | INPUT_OK | RUN_OK | FIGURE_OK |
|---|---|---|---|
| NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED |

下列图件是官方功能/代表性输出登记，不是本轮生成结果。已有人体/疾病数据不自动满足输入假设；历史scTour证据见[资产审查](../../02_EXISTING_ASSETS_AUDIT.md)。

[完整结构化来源与解释边界](source.json)

论文：["FitDevo: accurate inference of single-cell developmental potential using sample-specific gene weight"](https://doi.org/10.1093/bib/bbac293)；[Crossref](https://api.crossref.org/works/10.1093/bib/bbac293)。身份：RESOLVED_PRIMARY_PAPER_AND_OFFICIAL_CODE。

官方：[代码](https://github.com/jumphone/FitDevo) / [官网或文档](https://github.com/jumphone/FitDevo)。Bioconductor：官方安装渠道见下，未确认存在官方Bioconductor包。

固定默认分支SHA：`0c757e609489867e83f32f6571ebcfce704c3124`；commit date：`2024-04-07T03:06:59Z`。GitHub release v1.2.1（2023-11-28）；README更新列表最后写v1.2.0，区分release与文档文字。 许可：UNKNOWN。
GitHub metadata license=null，/license 404，root无LICENSE；不能自动视为MIT/BSD。

教程：[官方DP及DPF两例](https://github.com/jumphone/FitDevo#demos)；[官方Seurat5兼容脚本](https://github.com/jumphone/FitDevo/blob/main/fitdevo_seurat5.R)。

数据入口（未下载/未核bytes，不能据链接默认大下载）：
- [官方testing目录，Demo1使用1.rds](https://sourceforge.net/projects/fitdevo/files/testing/)；逐文件bytes/细胞数未核实，尚未认定为小样本。
- [方法必需的BGW权重（不是待分析细胞数据）](https://github.com/jumphone/FitDevo/blob/main/BGW.rds)；作为方法资产记录。

依赖、OS与硬件：
- `r`：R>=4.0.0、Seurat v4、qlcMatrix0.9.7；官方另供fitdevo_seurat5.R；DPF额外igraph、stringr。
- `os`：官方未给完整OS测试矩阵；Windows/macOS/Linux本轮NOT_TESTED。
- `hardware`：CPU/R矩阵/PCA流程，RAM随基因×细胞规模增长；官方没有可靠最低RAM/VRAM声明，本轮不造预算。

输入：未scaled的gene×cell表达矩阵MAT、官方BGW；raw可NORM=TRUE，已Seurat LogNormalize则NORM=FALSE；DPF另需逐cell匹配的已有2D坐标VEC；PCNUM为SSGW计算参数。

输出：逐细胞developmental potential向量DP；可选fitdevo.field DPF网格/箭头与VALUE/POINT.COL。

代表图：原UMAP按DP着色；已有嵌入上的DPF箭头/势场。

边界：
- DP/DPF不是RNA速度；无S/U也不产生RNA动力学证据。
- DP排序不是小时/疾病分期，DPF箭头是模型构造。
- Seurat v4/v5脚本需显式选择，不能假设旧slot代码直接兼容Seurat5；未知许可保留。

官方安装参考（**未执行**）：source官方fitdevo.R或fitdevo_seurat5.R并读取BGW；并非经验证的Bioconductor包安装（未执行）。

状态：**installation=NOT_TESTED / run=NOT_TESTED / real_analysis=NOT_RUN**。
