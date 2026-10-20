# S01：Slingshot 聚类层级最小生成树

## 1. 图件与方法

分类：轨迹。方法：Slingshot 2.20.0。本轮真实生成，非官方截图。数据为官方模拟，不是患者数据。

![S01：Slingshot 聚类层级最小生成树](../figures/S01_cluster_MST.png)

[PNG](../figures/S01_cluster_MST.png) · [PDF](../figures/S01_cluster_MST.pdf) · [SVG](../figures/S01_cluster_MST.svg)

## 2. 论文和官方教程来源

[原论文](https://doi.org/10.1186/s12864-018-4772-0)；[BioC 3.23教程](https://bioconductor.org/packages/3.23/bioc/vignettes/slingshot/inst/doc/vignette.html)。官方教程 sling_lines_unsup 段：getLineages(rd, cl, start.clus="1")。

## 3. 实际数据、脚本和运行证据

[输入坐标](../results/input_coordinates.tsv)、[输入来源与校验](../../../data_registry/Slingshot_example.json)，官方140×2坐标、5群。本地行号ID由01脚本生成。

[01输入](../scripts/01_Load_and_Check.R) → [02拟合](../scripts/02_Infer_Lineages_and_Curves.R) → [03绘图](../scripts/03_Plot_and_Export.R)。[完整运行记录](../logs/04_execution_record.json)退出码0；[最终版绘图记录](../logs/05_replot_record.json)证明独立重绘、模型hash不变。[统计表](../results/lineage_summary.tsv)、[时间](../results/pseudotime.tsv)、[权重](../results/curve_weights.tsv)可核对。

## 4. 图中元素

每点是一个官方模拟细胞；颜色是群1–5；横纵轴是模拟维度；黑色大点为群级节点，黑线为最小生成树骨架，没有速度箭头。

## 5. 能回答的问题

群级结构是否支持共享前段和两个末端？哪些群通过树的边相连？

## 6. 本次结果如何解释

五群大小36、36、24、22、22。以群1为起点，路径为1→2→3→5和1→2→3→4，群3是两条路径共享的分支区域。

## 7. 科学局限和常见误读

树会受聚类和拟合空间影响；一条边不说明细胞真实互相转化，边长不是真实时间，节点不是独立生物重复。 本例只验证模拟输入的计算流程，不证明患者生物过程，也没有独立供者/实验重复可用于临床推断。

## 8. PI课题中的预设用途

对State 1/6/7先检查邻域连续性与供者组成；可将群级骨架作候选结构图，不能预置1→6→7再用图证明它。 这是后续设计，本轮没有运行真实PI数据。见[PI专题](../../../case_studies/PI_Fibroblast_State_Reprogramming/README_CN.md)。
