# F：WOT——真实时间序列状态转移

**状态：DESIGN_NOT_RUN / RUN_OK=NOT_TESTED / FIGURE_OK=NOT_TESTED。** 本轮未运行组合，也未使用真实PI数据。

## 1. 为什么采用这个模块？

WOT以真实时间相邻样本为约束，用最优传输估计群体质量耦合；相较静态拟时序，它引入了实验时间和增长假设。OT指最优传输。

## 2. 比单时间点多解决什么？

估计不同采样时间的祖先/后代或状态流；不是追踪同一细胞。两个时间点只支持该段耦合，不提供中间时间实测轨迹。CellRank RealTimeKernel为后续接口，不是WOT运行的必要前置。

## 3. 需要什么输入？

有单位的真实时间、同实验设计的表达空间、样本/供者/批次、各时间细胞覆盖、增殖/死亡估计及假设。PI/Healthy、疾病严重度、供者序号都不是真实时间。

## 4. 按照什么顺序运行？

核对时间设计与相邻样本可比性→固定WOT历史环境与依赖→逐相邻时间求耦合→检查边际/增长/轴/空行→保存原质量→汇总状态流；需要时再显式传coupling给CellRank并验证行归一化及时间内转移。

## 5. 哪些量可以比较？

可比较状态流在增长、正则化和抽样设定下的敏感性，时间与拟时序可对照。原始coupling与行归一化转移矩阵不等价，不能丢掉质量后只报告概率行和。

## 6. 怎样判断一致？

检查时间/批次是否完全混杂、细胞ID轴、非负、边际残差、质量变化及空行警告。当前接口可能填补空行；填补后行和1不表示原输入有效。参数稳健性也不能验证真实谱系。

## 7. 冲突与版本如何处理？

WOT不维护，CellRank from_wot已弃用。后续选择冻结兼容旧版本，或WOT独立环境输出coupling再显式适配新CellRank；不自行替换moscot。STOP于无真实时间、样本不可比或适配失败；PIVOT为状态比较与设计缺口报告。

## 8. 最终论文图件与边界

时间/采样设计图、运输热图、状态流量/桑基图（Sankey）、祖先后代分布及增长/正则化敏感性。Sankey是汇总模型流量，不是观察到每个细胞真的走过某条路径。

## 官方来源与执行证据

官方论文、代码及教程链接见[14方法来源表](../../registry/OFFICIAL_METHOD_REGISTRY.csv)和对应方法SOURCE_CARD。原始可行性设计见[第一轮六组合报告](../../docs/first_round/trajectory_fate_review_2026-10-19/04_COMBINATION_FEASIBILITY.md)。[数据契约](../../docs/DATA_CONTRACT_CN.md)约束输入交换。新增脚本必须先有单方法真实运行证据，不能把本教程文字当作组合通过。

[RealTimeKernel官方接口](https://cellrank.readthedocs.io/en/stable/api/_autosummary/kernels/cellrank.kernels.RealTimeKernel.html)。
