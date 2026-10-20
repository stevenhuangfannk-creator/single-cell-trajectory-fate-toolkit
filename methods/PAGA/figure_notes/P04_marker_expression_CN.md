# 标志基因表达UMAP（PAGA）

![实际图](../figures/P04_marker_expression.png)

1. **图名与方法**：标志基因表达UMAP；PAGA/Scanpy。
2. **官方来源**：[Paul15教程](https://scanpy.readthedocs.io/en/stable/tutorials/trajectories/paga-paul15.html)，[原论文](https://doi.org/10.1186/s13059-019-1663-x)。本图由本机生成，与全教程布局/分群改编见[指南](../README_CN.md)。
3. **实际数据与脚本**：2730个小鼠造血细胞；[输入校验](../results/input_provenance.json)，[计算](../scripts/02_PAGA_and_DPT.py)，[绘图](../scripts/03_Plot_and_Export.py)。[PDF](../figures/P04_marker_expression.pdf) / [SVG](../figures/P04_marker_expression.svg)。
4. **图形元素**：四面板为Hba-a2、Elane、Irf8、Itga2b，每点一细胞；颜色为提供矩阵按细胞总量归一至1e4后log1p表达，各面板色标单独读取。坐标相同，不显示因果箭头。
5. **回答的问题**：官方群与已知造血标志是否相容？
6. **示例解读**：用红系/粒系/髓系/巨核相关标志核查注释与局部结构；低值也受检测影响。
7. **局限与误读**：标志关联不能证明谱系关系，提供面板不是全转录组；色标不同不能比较绝对丰度。
8. **PI预设用途**：真实PI另绘ECM、MMP/TIMP、整合素及炎症标志；先保证物种/ID/程序定义适合，不照搬造血基因。 本轮未运行真实PI。
