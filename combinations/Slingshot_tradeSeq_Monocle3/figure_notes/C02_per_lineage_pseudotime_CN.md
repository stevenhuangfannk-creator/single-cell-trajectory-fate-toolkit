# C02_per_lineage_pseudotime：逐谱系同细胞时间对照

1. **图名/方法**：逐谱系同细胞时间对照；Slingshot + tradeSeq + Monocle3待验证研究流程。
2. **原始来源**：[官方神经元小数据](https://github.com/cole-trapnell-lab/monocle3/blob/v1.4.27/inst/extdata/worm_embryo/NOTES)、[tradeSeq教程](https://statomics.github.io/tradeSeq/articles/tradeSeq.html)、[Monocle3教程](https://cole-trapnell-lab.github.io/monocle3/docs/trajectories/)。组合图为本项目新计算，不是官方联合算法图。
3. **实际数据/脚本**：同650细胞、同10,000基因输入；[生成脚本](../scripts/04_Plot_and_Export.R)，统计和ID清单在results；来源/hash见全库登记，GO另有注释快照。
4. **元素解释**：每点同一细胞；两方法在同一有效细胞上各自0–1化，虚线为相等；颜色为注释。
5. **回答问题**：共同祖状态方向下排序是否一致。
6. **本例解释**：AWA rho约−0.011，ASG约0.760；未自动翻转方向。
7. **局限/误读**：相关不是方向真值；AWA终点未匹配，图仅是描述性排序诊断。
8. **PI中用法（仅设计）**：对1/6/7只在共同可比较路径上计算并分层供者。

![逐谱系同细胞时间对照](../figures/C02_per_lineage_pseudotime.png)

[PDF](../figures/C02_per_lineage_pseudotime.pdf) · [SVG](../figures/C02_per_lineage_pseudotime.svg)。主要流程和敏感性结果不相互替代。
