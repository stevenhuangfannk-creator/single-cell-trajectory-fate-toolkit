# 组合设计只读来源审查 / Combination source review

日期：2026-10-19。结论：**NO_BLOCKING_FINDINGS（限本轮7方法对应的文档表述）**。

只读审查文件：

- `outputs/trajectory_fate_review_2026-10-19/04_COMBINATION_FEASIBILITY.md`
- `outputs/trajectory_fate_review_2026-10-19/06_FIRST_BATCH_AND_ACCEPTANCE.md`

依据本代理已核验的 `sources_trajectory.json/.md`、原作者文档及包manifest，不新增搜索、不编辑原文、不安装或运行。

| 检查项 | 结论与原文依据 |
|---|---|
| Slingshot weights是否被当作fate概率 | 没有。B模块明确使用lineage weights，D模块另行拟合Markov/absorbing fate；首批亦区分曲线/NA/权重与命运。 |
| Monocle3→tradeSeq是否假称直接适配 | 没有。B模块明确需另行定义各lineage的time和weights，并写明不能直接传CDS；Slingshot→tradeSeq列为最直接接口。 |
| PAGA方向与时间 | 正确区分群级连接与细胞伪时序；首批明确DPT另需root，PAGA不提供真实时间。未将默认PAGA无向连接当作命运转移。 |
| scTour time/潜能 | C模块仅将inferred time作动态排序参照，明确禁止把1−time自动命名为干性/潜能；A模块禁止为贴合预期自动反转方向。 |
| 首批官方模拟例 | 合理。Slingshot作者例140点×2维仅检验曲线/接口，750基因×300细胞模拟counts另作小规模表达模型原型；文件明确140坐标例不能充当counts。tradeSeq可先用自带真实subset，或明确标注的300细胞模拟链。 |
| 运行与科学状态 | 本轮均PROPOSED/NOT_TESTED；工程接口与模拟图件不被称为真实生物学验证，四个执行状态与边界文本已分开。 |

未发现需要阻止交付或要求修改的科学/接口表述。此结论仅是文档层面检查，不代表联合流程已适配、首批代码可运行或结果已验证。scTour历史资产的实际完整性不在这次两份文件的只读来源审查范围内。

不在本审查范围：其余方法的安装接口、CellRank具体实现、E/F的动力学/OT版本细节；由相应审查负责。本次没有把这些部分标为通过。
