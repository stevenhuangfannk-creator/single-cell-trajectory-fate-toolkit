# 六大组合模块中文教程

状态：DESIGN_NOT_RUN。这些是基于官方方法接口设计、尚待验证的研究工作流，不是官方联合算法。当前只有Slingshot单方法通过，其余单方法和组合尚未执行。每页覆盖八个教学问题，保留第一轮设计的科学边界。

- [A：Monocle3 + Slingshot + scTour——结构与状态连续性](A_Trajectory_Consensus/README_CN.md)

- [B：Slingshot + tradeSeq + GSEA——动态基因与功能程序](B_Dynamic_Gene_Programs/README_CN.md)

- [C：CytoTRACE2 + scTour——预测潜能与拟时序对照](C_Cell_Potency/README_CN.md)

- [D：CellRank + Palantir——命运概率与候选终末](D_Cell_Fate/README_CN.md)

- [E：scVelo + CellRank——RNA动力学到命运模型](E_RNA_Velocity/README_CN.md)

- [F：WOT——真实时间序列状态转移](F_Real_Time_Transition/README_CN.md)


共同验收：冻结细胞与基因轴、输入hash、版本、根/终末、尺度与排除规则；保存原生对象/小表再比较；说明方法共享输入和先验导致的相关性。结果冲突原样保留，不以多数投票宣称生物学真值。供者数与细胞数分开，论文图件中的预测、关联和实验验证用语分开。


## 第三轮新增：实际同数据验证

[Slingshot + tradeSeq + Monocle3](Slingshot_tradeSeq_Monocle3/README_CN.md) 已在650个共同细胞上运行并单独验收，出现AWA排序/终点冲突。它是新的研究工作流示范，未调用scTour，也未完成原B设计的全基因组GSEA，不能据此将原A–F整体改为PASS。
