# S02：Slingshot 同时主曲线

## 1. 图件与方法

分类：轨迹。方法：Slingshot 2.20.0。本轮真实生成，非官方截图。数据为官方模拟，不是患者数据。

![S02：Slingshot 同时主曲线](../figures/S02_principal_curves.png)

[PNG](../figures/S02_principal_curves.png) · [PDF](../figures/S02_principal_curves.pdf) · [SVG](../figures/S02_principal_curves.svg)

## 2. 论文和官方教程来源

[原论文](https://doi.org/10.1186/s12864-018-4772-0)；[BioC 3.23教程](https://bioconductor.org/packages/3.23/bioc/vignettes/slingshot/inst/doc/vignette.html)。官方教程 curves 段：getCurves(lin1)。本项目增加固定配色与三格式导出。

## 3. 实际数据、脚本和运行证据

[输入坐标](../results/input_coordinates.tsv)、[输入来源与校验](../../../data_registry/Slingshot_example.json)，官方140×2坐标、5群。本地行号ID由01脚本生成。

[01输入](../scripts/01_Load_and_Check.R) → [02拟合](../scripts/02_Infer_Lineages_and_Curves.R) → [03绘图](../scripts/03_Plot_and_Export.R)。[完整运行记录](../logs/04_execution_record.json)退出码0；[最终版绘图记录](../logs/05_replot_record.json)证明独立重绘、模型hash不变。[统计表](../results/lineage_summary.tsv)、[时间](../results/pseudotime.tsv)、[权重](../results/curve_weights.tsv)可核对。

## 4. 图中元素

点、坐标和颜色与S01相同；黑线是两条同时主曲线，不是群中心之间的直线，也不是观察到的运动轨迹。曲线在前段接近，在分支区分离。

## 5. 能回答的问题

细胞分布能否用共享早期段和两条光滑路径概括？群级骨架与细胞级平滑路径有何不同？

## 6. 本次结果如何解释

主曲线共享靠近群1/2的前段；随后一条延向群5，另一条延向群4。两条末端是算法在本模拟例中的几何结果。

## 7. 科学局限和常见误读

平滑外观不代表模型已做生物学验证；稀疏区域的曲线延伸容易被误读。不能由曲线远近推断转化速率或迁移。 本例只验证模拟输入的计算流程，不证明患者生物过程，也没有独立供者/实验重复可用于临床推断。

## 8. PI课题中的预设用途

可用于展示候选状态连续性；与Monocle3/scTour在同细胞和可信方向下对照，保留分歧并检查批次与稀缺中间状态。 这是后续设计，本轮没有运行真实PI数据。见[PI专题](../../../case_studies/PI_Fibroblast_State_Reprogramming/README_CN.md)。
