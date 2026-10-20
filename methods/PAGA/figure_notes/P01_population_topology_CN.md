# PAGA群体连接拓扑（PAGA）

![实际图](../figures/P01_population_topology.png)

1. **图名与方法**：PAGA群体连接拓扑；PAGA/Scanpy。
2. **官方来源**：[Paul15教程](https://scanpy.readthedocs.io/en/stable/tutorials/trajectories/paga-paul15.html)，[原论文](https://doi.org/10.1186/s13059-019-1663-x)。本图由本机生成，与全教程布局/分群改编见[指南](../README_CN.md)。
3. **实际数据与脚本**：2730个小鼠造血细胞；[输入校验](../results/input_provenance.json)，[计算](../scripts/02_PAGA_and_DPT.py)，[绘图](../scripts/03_Plot_and_Export.py)。[PDF](../figures/P01_population_topology.pdf) / [SVG](../figures/P01_population_topology.svg)。
4. **图形元素**：节点是官方群，大小随群细胞数变化；颜色区分群注释，文字标群名。线宽表示连接强度；显示阈值0.03仅控制绘图，无箭头。图形坐标来自群图布局，无生物单位。
5. **回答的问题**：哪些群在当前邻居图上相互连接？
6. **示例解读**：读取实际边表核查强弱连接；不要把整体布局左到右理解成成熟过程。
7. **局限与误读**：连接不是方向、转化概率或统计显著性；群划分和批次可改变边。
8. **PI预设用途**：检查State1/6/7之间是否存在跨供者稳健桥梁，再决定是否继续连续轨迹。 本轮未运行真实PI。
