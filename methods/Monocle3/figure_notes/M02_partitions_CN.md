# M02_partitions：分区结构

1. **图名和方法**：分区结构；Monocle3 1.4.27。
2. **官方来源**：[轨迹教程](https://cole-trapnell-lab.github.io/monocle3/docs/trajectories/)、[官方小数据NOTES](https://github.com/cole-trapnell-lab/monocle3/blob/v1.4.27/inst/extdata/worm_embryo/NOTES)、[方法论文](https://doi.org/10.1038/s41586-019-0969-x)。本图为本地计算。
3. **数据与脚本**：官方10,000×1,805小数据；[01输入](../scripts/01_Load_and_Check.R)、[02主图/根](../scripts/02_Learn_and_Order.R)、[03动态检验](../scripts/03_Dynamic_Genes.R)、[04导图](../scripts/04_Plot_and_Export.R)。来源/校验见全库数据登记。
4. **图形元素**：颜色标明3个partition，黑线各自在分区内；点仍为相同1805细胞。
5. **回答问题**：哪些群在当前邻域结构下断开，能否定义同一时间轴。
6. **本例解释**：三个分区需要独立根和解释，不能直接合并时间。
7. **科学局限与误读**：分区不是生物类型真值；不得因需要连续轨迹而强行连接。
8. **PI使用场景（仅设计）**：若PI三个状态跨分区，应先转做局部路径/状态差异。

![分区结构](../figures/M02_partitions.png)

[PDF](../figures/M02_partitions.pdf) · [SVG](../figures/M02_partitions.svg)。可编辑脚本、统计与真实日志均保留。
