# M04_embryo_time：已有胚胎时间注释

1. **图名和方法**：已有胚胎时间注释；Monocle3 1.4.27。
2. **官方来源**：[轨迹教程](https://cole-trapnell-lab.github.io/monocle3/docs/trajectories/)、[官方小数据NOTES](https://github.com/cole-trapnell-lab/monocle3/blob/v1.4.27/inst/extdata/worm_embryo/NOTES)、[方法论文](https://doi.org/10.1038/s41586-019-0969-x)。本图为本地计算。
3. **数据与脚本**：官方10,000×1,805小数据；[01输入](../scripts/01_Load_and_Check.R)、[02主图/根](../scripts/02_Learn_and_Order.R)、[03动态检验](../scripts/03_Dynamic_Genes.R)、[04导图](../scripts/04_Plot_and_Export.R)。来源/校验见全库数据登记。
4. **图形元素**：颜色为已有embryo.time，坐标与主图沿用同一结果。
5. **回答问题**：当前推断排序与已有阶段信息是否相容。
6. **本例解释**：早期分箱在不同分区不同；注释不等于单细胞连续实测时间。
7. **科学局限与误读**：表达推断的时间注释可能与轨迹证据相关，不能作为完全独立验证。
8. **PI使用场景（仅设计）**：PI/Healthy不是时间；若有临床或实验时间也要明确其单位。

![已有胚胎时间注释](../figures/M04_embryo_time.png)

[PDF](../figures/M04_embryo_time.pdf) · [SVG](../figures/M04_embryo_time.svg)。可编辑脚本、统计与真实日志均保留。
