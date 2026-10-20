# 图件计划与历史入口 / Gallery plan and existing evidence

**本轮没有生成任何新的科研图。** 此目录只列拟复现图件与已存在scTour入口，不能称新方法库Gallery已复现。

## 可先查看的历史scTour / Existing scTour

[旧库scTour图件目录](https://github.com/stevenhuangfannk-creator/single-cell-dynamics-perturbation/tree/main/modules/03_scTour/figures)和[原Gallery](https://github.com/stevenhuangfannk-creator/single-cell-dynamics-perturbation/blob/main/gallery/FIGURE_INDEX_CN.md)位于Private仓库，需原访问权限。没有复制到本轮交付，也不改变其历史PARTIAL状态。准确17组图、三格式文件与失败证据见[资产审查](../02_EXISTING_ASSETS_AUDIT.md)。

## 首批预期图 / Proposed figures

| 编号 | 方法 | 图件与问题 | 输入性质 | 本轮状态 |
|---|---|---|---|---|
| PLAN-S01 | Slingshot | MST与principal curves：能否恢复例子的分支结构 | 官方140点模拟低维例；没有表达counts | NOT_TESTED |
| PLAN-S02 | Slingshot | pseudotime渐变：每lineage顺序与NA如何 | 官方300细胞模拟counts流程 | NOT_TESTED |
| PLAN-T01 | tradeSeq | NB-GAM smoother：选定基因是否随time变化 | 官方counts+time+weights | NOT_TESTED |
| PLAN-T02 | tradeSeq | gene heatmap与收敛表：曲线程序与拟合质量 | 明确筛选和预先指定检验 | NOT_TESTED |
| PLAN-P01 | PAGA | 群级连接图：哪些群间有邻域拓扑支持 | 待批准的官方教程输入 | NOT_TESTED |
| PLAN-P02 | PAGA | embedding与DPT对照：拓扑/方向如何分开 | DPT需额外root，不是真实时间 | NOT_TESTED |

完整方法支持的代表图件在[14方法来源卡](../01_OFFICIAL_SOURCES.md)中逐一登记；A–F组合计划见[可行性报告](../04_COMBINATION_FEASIBILITY.md)。计划编号不冒充结果编号；只有实际运行、数值与视觉检查后，才能新增真实缩略图和 `FIGURE_OK=PASS`。

未来每图保留科学问题、源数据/版本与hash、方法脚本、固定/可调参数、数值小表、PNG/PDF/SVG、执行日期和限制。历史图和新图分开标日期/来源；参考图只解释布局，不作本轮计算证据。
