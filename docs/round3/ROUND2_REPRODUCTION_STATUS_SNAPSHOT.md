> 历史状态快照：正文状态保留第二轮语境；本轮仅修正迁移后的相对链接。原始第二轮ZIP与SHA快照仍保留。

# 当前复现状态与后续批次

日期：2026-10-19。范围：用户已批准的本地Slingshot官方140点小例。**远程仓库未创建，真实PI数据未运行。**

| 方法/内容 | 当前实际状态 | 已交付与缺口 |
|---|---|---|
| Slingshot | INSTALL/INPUT/RUN/FIGURE均PASS | 完整中文指南、输入来源/校验、可编辑顺序脚本、实际日志/失败记录、统计表、阶段对象、6组18个图文件、逐图解释 |
| tradeSeq | NOT_TESTED | 第一轮官方来源卡及本轮B模块教程；下一批需核对Paul15随包输入、依赖和内存，再独立批准下载/安装与运行 |
| Monocle3 | NOT_TESTED | 来源卡、A模块及Windows/编译/数据规模门槛；不能先把大型官方输入称为最小小例 |
| PAGA、CellRank、CytoTRACE2等其余方法 | NOT_TESTED | 官方登记与选择矩阵；完整中文指南和真实图件逐方法扩展，没有空白README或占位图 |
| scTour历史结果 | PARTIAL，当前未重验 | 第一轮资产审查原样保存；旧路径当前不可访问；不重训、不冒用历史PASS |
| A–F组合 | DESIGN_NOT_RUN | 六份中文教程覆盖组合动机、附加问题、输入、顺序、可比量、一致性、冲突和论文图件；不宣称官方联合算法或已运行 |
| PI专题 | DESIGN_ONLY | State 1/6/7与ECM/机械转导/炎症修复/潜能命运/内皮互作的输入、图件、结论边界及STOP/PIVOT；无真实PI计算 |

结构化当前状态见 [CURRENT_METHOD_STATUS.csv](../../registry/CURRENT_METHOD_STATUS.csv)；第一轮来源表仍保留其历史NOT_TESTED，不将来源审查替代安装/运行结果。

## Slingshot验收证据

- 官方代码与本地改动：[指南](../../methods/Slingshot/README_CN.md)列明data_sling/sling_lines_unsup/curves来源；仅复现140点最小例，不声称整篇vignette或论文全部通过。
- 数据：[输入登记](../../data_registry/Slingshot_example.json)、原样随包rda、140行坐标/标签、许可与hash。
- 安装：[最终检查](../../methods/Slingshot/logs/00_install_final_exit.json)退出0；31个非基础包版本、URL和hash已保存。
- 运行：[完整执行](../../methods/Slingshot/logs/04_execution_record.json)退出0；2条路径、140细胞、时间/权重有效性检查与统计表。
- 绘图：[文件核验](../../methods/Slingshot/logs/artifact_checks.json)逐文件打开PNG/PDF/SVG；PDF逐页渲染、PNG/PDF视觉检查，SVG解析为矢量路径且无嵌入截图。
- 独立重绘：[05记录](../../methods/Slingshot/logs/05_replot_record.json)退出0、拟合文件hash不变；修改版式不重训。
- 可复现用户入口：[06记录](../../methods/Slingshot/logs/06_user_entry_verification.json)与带时间戳原始日志；再次完整运行后所有数值TSV hash一致。
- 解释：[六份逐图文档](../../gallery/README.md)明确坐标/权重/拟时序含义和PI预设用途；不把计算结果当生物学证明。

保留早期Windows locale、实际运行依赖缺失、cli退出异常与图形版式修复记录。最终通过不意味着早期失败没有发生。CLI_NO_THREAD试验未解决问题，未保留在最终配置。

## 后续逐方法验收

下一步顺序Slingshot（已完成）→tradeSeq→Monocle3，然后PAGA、CellRank、CytoTRACE2等。每次先登记官方数据和软件URL、字节/未知大小、许可、内存与磁盘计划，再在相应批准范围内执行。不能因首例批准就安装其他方法或运行PI。

tradeSeq优先随包countMatrix/crv/celltype，记录实际形状、全体拟合/失败基因与预指定检验；140点Slingshot坐标不能提供表达输入。Monocle3先找官方明确的小子集，若只能取得大型输入则说明规模，不能自行抽样后冒称官方完整例。

单方法都通过后，组合另验输入轴、尺度、方向/终末、共享先验与比较规则。不同方法相似只构成模型稳健性证据，不能代替供者级设计和相应实验。
