# 第四轮执行进度与暂停点（2026-10-20）

**本轮部分完成，尚未达到三个新方法全部交付的验收标准。** 已完成Private仓库首次正式提交及PAGA官方小例。CytoTRACE2因非商业使用资格未确认暂停，CellRank严格遵循先前方法通过再开始下一方法的顺序，尚未启动。没有伪造潜能或命运概率图。

## GitHub实际发布

- 仓库：[stevenhuangfannk-creator/single-cell-trajectory-fate-toolkit](https://github.com/stevenhuangfannk-creator/single-cell-trajectory-fate-toolkit)
- 账号：stevenhuangfannk-creator（当前授权账号），分支main，Private经GitHub API实查为true。
- 第三轮首发commit：`99228954aa4872f97d6f844fae92396a31e94b91`，实际423个提交文件；推送后本地/远程SHA一致，未强制推送。
- 首发证据：[FIRST_PRIVATE_PUSH.json](FIRST_PRIVATE_PUSH.json)；后续PAGA提交的最终SHA/数量在工作区outputs的远程回执与聊天交付中记录，避免把提交自身SHA写进同一提交造成循环。
- 所有RDS、AnnData、环境、模型和安装缓存不入Git；小型派生统计和实际图件入库。历史路径/Private链接按本次Private授权保留；不包含真实PI或患者输入。

## 逐方法验收

| 方法 | INSTALL | INPUT | RUN | FIGURE | 中文教程 |
|---|---|---|---|---|---|
| PAGA | PASS，新venv内运行库修复 | PASS，官方2730×3451 | PASS，有记录改编 | PASS，4组12格式 | 完整指南+4图卡 |
| CytoTRACE2 | 未尝试，许可门槛 | 未下载 | BLOCKED，资格待确认 | NOT_RUN，无占位 | 仅官方卡/许可审查，完整运行指南未验收 |
| CellRank | 未尝试 | 未下载 | NOT_STARTED，顺序门槛 | NOT_RUN，无占位 | 仅第一轮来源卡，不冒充完整教程 |

PAGA的PASS限定本例和已记录环境，不宣称逐像素复刻完整官方教程。CytoTRACE2的BLOCKED不代表模型或安装已经失败；CellRank尚未进入安装，不应伪标为安装FAIL。

## PAGA实际成果与解释

官方Paul15输入10,297,693字节，SHA256为`6161984f758dd464992edc23f1a8ab89b2081600130c6aa93a1ab12b3ada5bfb`。实际2730细胞×3451提供基因；官方非log信息基因矩阵，不能据整数外观声称未经处理的全长原计数。预处理后999个选择基因；19群、58条非零无向连接，显示阈值0.03保留54边。边权不是p值或转化概率。

| 实际图件 | 学习入口 |
|---|---|
| P01 群体连接拓扑 | [PNG/PDF/SVG与8项解读](../../methods/PAGA/figure_notes/P01_population_topology_CN.md) |
| P02 PAGA初始化UMAP | [PNG/PDF/SVG与8项解读](../../methods/PAGA/figure_notes/P02_PAGA_initialized_UMAP_CN.md) |
| P03 DPT根条件排序 | [PNG/PDF/SVG与8项解读](../../methods/PAGA/figure_notes/P03_DPT_pseudotime_CN.md) |
| P04 四个标志表达 | [PNG/PDF/SVG与8项解读](../../methods/PAGA/figure_notes/P04_marker_expression_CN.md) |

DPT有限2671个，59个不可达保留非有限并在图中标灰，不填0；根采用官方默认索引840，cell ID W37022、注释8Mk，不能称已经验证的干祖起点。PAGA本身无方向，DPT是另一个根条件算法。PAGA群连接、Monocle3主图距离和Slingshot曲线分别估计不同对象；不能直接把边权、时间、曲线权重混为命运概率。

[完整指南](../../methods/PAGA/README_CN.md)记录输入/Seurat–AnnData准备、参数、序列脚本、DPT限制、常见错误、方法对照与PI预设。计算/绘图分开，正常运行复用内存对象，重绘不重算邻居。首次缺MSVCP140的真实失败保留；仅新建venv使用现有运行库，未安装系统组件或修改Numba源码。一次绘图figsize参数错误已修复，日志保留。没有改动旧scTour、RegVelo或其他科研仓库。

## 保护与可复现性

第三轮431项本地清单在本轮开始时全部校验一致；三方法与组合275个文件建立保护hash，最终再次核对。原脚本、日志、图件、指南以及AWA分支终点FAIL和预处理敏感性保留。第三轮最终数值表一致证据仍是第三轮记录，本轮未重新训练它们。

环境锁与日志见[独立环境](../../environments/round4/PAGA/README_CN.md)，图件格式/可视检查见[ARTIFACT_QA](../../methods/PAGA/logs/ARTIFACT_QA.json)。本轮为单线程串行CPU执行；输入设64MiB上限，实际约9.82MiB。未连续采样全程内存峰值，不报告虚构峰值RAM。新机器完整安装尚未独立复测。Git忽略规则和发布文件还会在本次提交前进行静态复查。

原root SHA256SUMS是本地Round3清单，现已存档于ROUND3_SHA256SUMS.txt；新的Git发布清单按规范化后的Git索引内容生成，不含被忽略的运行时/RDS。Private不等于可转Public；自写材料未选开源许可，第三方权利仍分别适用。

## PI预设应用与后续

[四轮PI设计](../../case_studies/PI_Fibroblast_State_Reprogramming/ROUND4_METHOD_DESIGN_CN.md)覆盖State1/6/7、供者重复、ECM合成/降解/重塑、Integrin–FAK–YAP/TAZ、炎症/修复及内皮环境。三层问题分开：PAGA连接、CytoTRACE2预测潜能、CellRank条件命运概率；预测潜能不等于真实去分化或炎症可塑性。只做教学设计，未运行真实PI。

下一步需先确认此次CytoTRACE2为非商业且不代表营利机构。符合许可后，按2280细胞官方Python鼠胰腺小例、单核CPU、独立NumPy<2环境继续；模型约157MB未压缩，源码/模型/输入不上传。完成潜能图/类别、检测基因数和深度混杂检查并独立验收后，再开始CellRank PseudotimeKernel小例。若用途不符合，暂停CytoTRACE2并由用户决定是否调整后续顺序。

许可依据见[Stanford条款审查](CYTOTRACE2_LICENSE_REVIEW_CN.md)；不是因安装权限重复索要批准，而是用途资格尚缺必要信息。未接受不明商业使用条件，未通过镜像/删许可绕过限制。
