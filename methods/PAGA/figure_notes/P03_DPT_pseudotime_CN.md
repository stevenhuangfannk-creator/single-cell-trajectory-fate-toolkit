# DPT相对拟时序（PAGA）

![实际图](../figures/P03_DPT_pseudotime.png)

1. **图名与方法**：DPT相对拟时序；PAGA/Scanpy。
2. **官方来源**：[Paul15教程](https://scanpy.readthedocs.io/en/stable/tutorials/trajectories/paga-paul15.html)，[原论文](https://doi.org/10.1186/s13059-019-1663-x)。本图由本机生成，与全教程布局/分群改编见[指南](../README_CN.md)。
3. **实际数据与脚本**：2730个小鼠造血细胞；[输入校验](../results/input_provenance.json)，[计算](../scripts/02_PAGA_and_DPT.py)，[绘图](../scripts/03_Plot_and_Export.py)。[PDF](../figures/P03_DPT_pseudotime.pdf) / [SVG](../figures/P03_DPT_pseudotime.svg)。
4. **图形元素**：每点同P02；连续颜色是根到扩散结构的相对DPT，低值接近选定根，高值较远；颜色条无小时单位，坐标仍是UMAP。
5. **回答的问题**：在指定根和扩散图条件下如何排序？
6. **示例解读**：结合保存的根cell ID和分支注释解释早晚；同一DPT可包含不同分支。
7. **局限与误读**：DPT不是实验时间、潜能或命运概率。改变根会改变方向；细胞层QC相关不等于供者级因果。
8. **PI预设用途**：只在有起点依据且连续性稳健的局部Fibroblast结构比较动态程序，不预设State编号就是时间。 本轮未运行真实PI。

本次59个非有限DPT细胞以灰色显示，不属于色条的0值；其余2671个细胞具有有限排序。根位于8Mk，不能把该图直接称为从干细胞开始的成熟过程。
