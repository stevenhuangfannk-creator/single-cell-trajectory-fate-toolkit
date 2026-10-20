# M05_dynamic_gene_maps：图动态基因表达分布

1. **图名和方法**：图动态基因表达分布；Monocle3 1.4.27。
2. **官方来源**：[轨迹教程](https://cole-trapnell-lab.github.io/monocle3/docs/trajectories/)、[官方小数据NOTES](https://github.com/cole-trapnell-lab/monocle3/blob/v1.4.27/inst/extdata/worm_embryo/NOTES)、[方法论文](https://doi.org/10.1038/s41586-019-0969-x)。本图为本地计算。
3. **数据与脚本**：官方10,000×1,805小数据；[01输入](../scripts/01_Load_and_Check.R)、[02主图/根](../scripts/02_Learn_and_Order.R)、[03动态检验](../scripts/03_Dynamic_Genes.R)、[04导图](../scripts/04_Plot_and_Export.R)。来源/校验见全库数据登记。
4. **图形元素**：每面板一个基因，点色为% Max，即每基因最大显示表达的百分比；不叠加轨迹线以便看表达。
5. **回答问题**：哪些基因表达在图邻域有结构。
6. **本例解释**：前6基因按q值和Moran I选取；5921合格基因中3294个q<.05。
7. **科学局限与误读**：自相关可来自分支/类型差异，不能自动解释为单调动态或因果调控。
8. **PI使用场景（仅设计）**：预登记ECM/机械/炎症集合，结合供者与表达效应。

![图动态基因表达分布](../figures/M05_dynamic_gene_maps.png)

[PDF](../figures/M05_dynamic_gene_maps.pdf) · [SVG](../figures/M05_dynamic_gene_maps.svg)。可编辑脚本、统计与真实日志均保留。


本图基因名称对照：

| 稳定ID | 官方显示名 |
|---|---|
| WBGene00001951 | hlh-4 |
| WBGene00007604 | xbx-9 |
| WBGene00017326 | dmd-5 |
| WBGene00019975 | flp-34 |
| WBGene00015354 | snet-1 |
| WBGene00000457 | ceh-36 |

名称仅用于识别；功能与调控关系不能从基因名字或本图直接推定。
