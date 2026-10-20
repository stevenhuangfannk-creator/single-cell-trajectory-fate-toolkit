# S04-L2：Slingshot 谱系2曲线归属权重

## 1. 图件与方法

分类：归属权重。方法：Slingshot 2.20.0。本轮真实生成，非官方截图。数据为官方模拟，不是患者数据。

![S04-L2：Slingshot 谱系2曲线归属权重](../figures/S04_Lineage2_curve_weight.png)

[PNG](../figures/S04_Lineage2_curve_weight.png) · [PDF](../figures/S04_Lineage2_curve_weight.pdf) · [SVG](../figures/S04_Lineage2_curve_weight.svg)

## 2. 论文和官方教程来源

[原论文](https://doi.org/10.1186/s12864-018-4772-0)；[BioC 3.23教程](https://bioconductor.org/packages/3.23/bioc/vignettes/slingshot/inst/doc/vignette.html)。官方拟合对象的slingCurveWeights默认输出；本项目新增逐谱系权重图。

## 3. 实际数据、脚本和运行证据

[输入坐标](../results/input_coordinates.tsv)、[输入来源与校验](../../../data_registry/Slingshot_example.json)，官方140×2坐标、5群。本地行号ID由01脚本生成。

[01输入](../scripts/01_Load_and_Check.R) → [02拟合](../scripts/02_Infer_Lineages_and_Curves.R) → [03绘图](../scripts/03_Plot_and_Export.R)。[完整运行记录](../logs/04_execution_record.json)退出码0；[最终版绘图记录](../logs/05_replot_record.json)证明独立重绘、模型hash不变。[统计表](../results/lineage_summary.tsv)、[时间](../results/pseudotime.tsv)、[权重](../results/curve_weights.tsv)可核对。

## 4. 图中元素

灰→蓝表示谱系2归属权重由低到高，0–1色标；黑线为谱系2；坐标及细胞集合与其他五图相同。

## 5. 能回答的问题

谱系2的归属结构如何与谱系1分离？哪些细胞位于共享区或不同分支？

## 6. 本次结果如何解释

群4方向的细胞主要呈高谱系2权重，群5方向主要低；共享前段可同时对两个谱系高权重。两个权重面板需要一起看。

## 7. 科学局限和常见误读

不能把两幅图的颜色看成经过校准的两终末概率。拟合权重依赖当前聚类、空间、曲线及重分配设置。 本例只验证模拟输入的计算流程，不证明患者生物过程，也没有独立供者/实验重复可用于临床推断。

## 8. PI课题中的预设用途

可检查同一PI连续状态是否被过早硬分支；若两方法分支归属冲突，应报告差异并回查数据，而非按预期保留一个版本。 这是后续设计，本轮没有运行真实PI数据。见[PI专题](../../../case_studies/PI_Fibroblast_State_Reprogramming/README_CN.md)。
