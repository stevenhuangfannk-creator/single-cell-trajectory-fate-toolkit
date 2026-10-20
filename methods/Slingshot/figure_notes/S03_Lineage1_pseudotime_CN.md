# S03-L1：Slingshot 谱系1拟时序

## 1. 图件与方法

分类：拟时序。方法：Slingshot 2.20.0。本轮真实生成，非官方截图。数据为官方模拟，不是患者数据。

![S03-L1：Slingshot 谱系1拟时序](../figures/S03_Lineage1_pseudotime.png)

[PNG](../figures/S03_Lineage1_pseudotime.png) · [PDF](../figures/S03_Lineage1_pseudotime.pdf) · [SVG](../figures/S03_Lineage1_pseudotime.svg)

## 2. 论文和官方教程来源

[原论文](https://doi.org/10.1186/s12864-018-4772-0)；[BioC 3.23教程](https://bioconductor.org/packages/3.23/bioc/vignettes/slingshot/inst/doc/vignette.html)。官方getLineages/getCurves对象；调用slingPseudotime，本项目新增逐谱系着色图。

## 3. 实际数据、脚本和运行证据

[输入坐标](../results/input_coordinates.tsv)、[输入来源与校验](../../../data_registry/Slingshot_example.json)，官方140×2坐标、5群。本地行号ID由01脚本生成。

[01输入](../scripts/01_Load_and_Check.R) → [02拟合](../scripts/02_Infer_Lineages_and_Curves.R) → [03绘图](../scripts/03_Plot_and_Export.R)。[完整运行记录](../logs/04_execution_record.json)退出码0；[最终版绘图记录](../logs/05_replot_record.json)证明独立重绘、模型hash不变。[统计表](../results/lineage_summary.tsv)、[时间](../results/pseudotime.tsv)、[权重](../results/curve_weights.tsv)可核对。

## 4. 图中元素

黑线仅为谱系1；颜色由紫到黄表示沿该曲线从小到大的相对弧长，右侧色标给出数值；灰色表示该谱系拟时序缺失。轴仍为模拟坐标。

## 5. 能回答的问题

在1→2→3→5这条路径内，哪些细胞相对靠前或靠后？哪些细胞不适合赋予这条路径的时间？

## 6. 本次结果如何解释

107个细胞有有限拟时序，33个为NA；范围0–15.045364。灰点仍保留在图中，没有被删除或填成0。

## 7. 科学局限和常见误读

数值不是天数；NA不是死亡或低质量；不能把谱系2的所有细胞硬塞进这条线，也不能以该范围推断分化速度。 本例只验证模拟输入的计算流程，不证明患者生物过程，也没有独立供者/实验重复可用于临床推断。

## 8. PI课题中的预设用途

在实际PI谱系通过结构检查后，可将ECM等程序沿该谱系展示；方向要独立预登记，供者和分支应分别报告。 这是后续设计，本轮没有运行真实PI数据。见[PI专题](../../../case_studies/PI_Fibroblast_State_Reprogramming/README_CN.md)。
