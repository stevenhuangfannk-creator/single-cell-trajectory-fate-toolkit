# S04-L1：Slingshot 谱系1曲线归属权重

## 1. 图件与方法

分类：归属权重。方法：Slingshot 2.20.0。本轮真实生成，非官方截图。数据为官方模拟，不是患者数据。

![S04-L1：Slingshot 谱系1曲线归属权重](../figures/S04_Lineage1_curve_weight.png)

[PNG](../figures/S04_Lineage1_curve_weight.png) · [PDF](../figures/S04_Lineage1_curve_weight.pdf) · [SVG](../figures/S04_Lineage1_curve_weight.svg)

## 2. 论文和官方教程来源

[原论文](https://doi.org/10.1186/s12864-018-4772-0)；[BioC 3.23教程](https://bioconductor.org/packages/3.23/bioc/vignettes/slingshot/inst/doc/vignette.html)。官方拟合对象的slingCurveWeights默认输出；本项目新增逐谱系权重图。

## 3. 实际数据、脚本和运行证据

[输入坐标](../results/input_coordinates.tsv)、[输入来源与校验](../../../data_registry/Slingshot_example.json)，官方140×2坐标、5群。本地行号ID由01脚本生成。

[01输入](../scripts/01_Load_and_Check.R) → [02拟合](../scripts/02_Infer_Lineages_and_Curves.R) → [03绘图](../scripts/03_Plot_and_Export.R)。[完整运行记录](../logs/04_execution_record.json)退出码0；[最终版绘图记录](../logs/05_replot_record.json)证明独立重绘、模型hash不变。[统计表](../results/lineage_summary.tsv)、[时间](../results/pseudotime.tsv)、[权重](../results/curve_weights.tsv)可核对。

## 4. 图中元素

浅灰为低权重、蓝色为高权重；右侧色标0–1；黑线为谱系1。权重有限且0值也保留，不按阈值删除细胞。坐标为同一模拟空间。

## 5. 能回答的问题

哪些细胞参与谱系1曲线的拟合与归属？为什么早期共享区也可能对另一条曲线有高权重？

## 6. 本次结果如何解释

单谱系权重范围0–1。跨谱系行和范围1–2；32个细胞在两条曲线上均为1。共享区允许重复归属。

## 7. 科学局限和常见误读

这不是到达群5的概率；行和不要求为1，不应为做饼图而直接归一化并换名称。高权重也不证明方向或终末真实性。 本例只验证模拟输入的计算流程，不证明患者生物过程，也没有独立供者/实验重复可用于临床推断。

## 8. PI课题中的预设用途

用于诊断共享状态和谱系过渡，并作为tradeSeq的明确接口之一；不把它当State 1进入State 7的转化概率。 这是后续设计，本轮没有运行真实PI数据。见[PI专题](../../../case_studies/PI_Fibroblast_State_Reprogramming/README_CN.md)。
