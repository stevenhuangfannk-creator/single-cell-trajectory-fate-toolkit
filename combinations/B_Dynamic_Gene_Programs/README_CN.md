# B：Slingshot + tradeSeq + GSEA——动态基因与功能程序

**状态：DESIGN_NOT_RUN / RUN_OK=NOT_TESTED / FIGURE_OK=NOT_TESTED。** 本轮未运行组合，也未使用真实PI数据。

## 1. 为什么组合？

Slingshot定义路径与顺序，tradeSeq检验沿路径变化的计数模型，GSEA将有明确对比的基因排序解释为功能程序。GSEA为基因集富集分析；不是在轨迹图上涂一个基因分数就完成统计。

## 2. 比单方法多解决什么？

将“状态如何排列”推进到“哪些表达变化、哪些程序与变化相关”。动态表达仍条件于估计轨迹，不识别因果驱动。官方140点例没有基因计数，不能作为本模块表达输入。

## 3. 需要什么输入？

同轴gene×cell原始计数、cell×lineage拟时序与曲线权重、基因ID/物种、归一化/offset（偏移项）依据、供者批次设计；另固定基因集版本、排序对比和可检测背景。整合值或取对数值不能直接替代负二项计数。

## 4. 按照什么顺序运行？

先通过Slingshot与tradeSeq各自官方例；真实应用先冻结轨迹，再验证少量基因的模型接口、结点选择和收敛，预登记association/start-end/branch等检验；保存全部基因的统计、效应量、NA与收敛。之后定义有方向的全基因排序，最后GSEA并检查基因覆盖和多重检验。

## 5. 哪些量可以比较？

可比较同谱系拟合曲线、指定对比的效应方向、基因程序及同基因集的富集结果。Monocle3 graph_test自相关p值与tradeSeq的p值不是同一检验；不同谱系的相对时间位置也非实测同时间。关联检验无符号p值不能充当上下调排序。

## 6. 怎样判断一致？

检查代表基因曲线、效应方向与覆盖，再比较程序在供者/合理参数下是否稳定。FDR指错误发现率；检验族、未收敛基因和排序背景完整报告。GSEA只分析截断显著基因表会损坏背景，不能这样验证一致。

## 7. 冲突怎样解释？

先查时间/权重轴错位、结点、低表达、计数尺度、模型未收敛和分支对比定义，再查基因集版本与多对一映射。STOP于上游路径不稳或大量不收敛；PIVOT为描述性曲线/程序，并标明尚无供者级推断。

## 8. 最终论文图件与边界

基因平滑曲线、结点/模型诊断、gene×pseudotime热图、程序趋势、GSEA富集曲线和NES图；NES为标准化富集分数。热图逐行标准化要声明。程序富集是关联，不能凭单细胞显著性证明疾病机制或供者级差异。

## 官方来源与执行证据

官方论文、代码及教程链接见[14方法来源表](../../registry/OFFICIAL_METHOD_REGISTRY.csv)和对应方法SOURCE_CARD。原始可行性设计见[第一轮六组合报告](../../docs/first_round/trajectory_fate_review_2026-10-19/04_COMBINATION_FEASIBILITY.md)。[数据契约](../../docs/DATA_CONTRACT_CN.md)约束输入交换。新增脚本必须先有单方法真实运行证据，不能把本教程文字当作组合通过。

[tradeSeq官方工作流](https://statomics.github.io/tradeSeq/articles/tradeSeq.html)；[GSEA输入说明](https://docs.gsea-msigdb.org/GSEA/GSEA_and_RNA-Seq/)。
