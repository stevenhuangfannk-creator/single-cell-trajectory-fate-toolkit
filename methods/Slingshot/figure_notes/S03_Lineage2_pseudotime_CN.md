# S03-L2：Slingshot 谱系2拟时序

## 1. 图件与方法

分类：拟时序。方法：Slingshot 2.20.0。本轮真实生成，非官方截图。数据为官方模拟，不是患者数据。

![S03-L2：Slingshot 谱系2拟时序](../figures/S03_Lineage2_pseudotime.png)

[PNG](../figures/S03_Lineage2_pseudotime.png) · [PDF](../figures/S03_Lineage2_pseudotime.pdf) · [SVG](../figures/S03_Lineage2_pseudotime.svg)

## 2. 论文和官方教程来源

[原论文](https://doi.org/10.1186/s12864-018-4772-0)；[BioC 3.23教程](https://bioconductor.org/packages/3.23/bioc/vignettes/slingshot/inst/doc/vignette.html)。官方getLineages/getCurves对象；调用slingPseudotime，本项目新增逐谱系着色图。

## 3. 实际数据、脚本和运行证据

[输入坐标](../results/input_coordinates.tsv)、[输入来源与校验](../../../data_registry/Slingshot_example.json)，官方140×2坐标、5群。本地行号ID由01脚本生成。

[01输入](../scripts/01_Load_and_Check.R) → [02拟合](../scripts/02_Infer_Lineages_and_Curves.R) → [03绘图](../scripts/03_Plot_and_Export.R)。[完整运行记录](../logs/04_execution_record.json)退出码0；[最终版绘图记录](../logs/05_replot_record.json)证明独立重绘、模型hash不变。[统计表](../results/lineage_summary.tsv)、[时间](../results/pseudotime.tsv)、[权重](../results/curve_weights.tsv)可核对。

## 4. 图中元素

黑线为谱系2；紫到黄是该谱系相对弧长，灰点为当前谱系NA；坐标不是时间。它和S03-L1使用同一批140个点与同一空间。

## 5. 能回答的问题

在1→2→3→4内，哪些细胞有可解释的相对顺序？与谱系1共享哪些早期细胞？

## 6. 本次结果如何解释

108个细胞有有限拟时序，32个NA，范围0–15.126327。两条谱系共有75个细胞具有有限时间；它们的两个值不能直接平均成全局时间。

## 7. 科学局限和常见误读

相近的最大值不证明两个分支发生得同样快。不同谱系的相对位置不等于实测同一时间点。 本例只验证模拟输入的计算流程，不证明患者生物过程，也没有独立供者/实验重复可用于临床推断。

## 8. PI课题中的预设用途

适合并列展示候选修复/炎症分支的状态顺序，但两种功能标签需由真实表达与外部证据确定，不能从图形上下位置命名。 这是后续设计，本轮没有运行真实PI数据。见[PI专题](../../../case_studies/PI_Fibroblast_State_Reprogramming/README_CN.md)。
