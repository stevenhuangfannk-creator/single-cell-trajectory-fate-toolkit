# 单细胞轨迹、潜能与命运方法库：第一轮审查 / First-round review

日期：**2026-10-19（Asia/Singapore）**。拟建项目：`single-cell-trajectory-fate-toolkit`。本目录是审查交付，**尚未创建该Git仓库、编写方法运行脚本、安装环境、下载示例数据或执行新分析**。六项审查已完成；进入下一轮前暂停，等待用户确认。

English summary: Source and asset review for a proposed reusable trajectory and fate toolkit. Fourteen methods have source cards, while all new installation, input, execution and figure checks remain NOT_TESTED. Existing scTour evidence is preserved with its original PARTIAL status.

## 六项交付 / Deliverables

| 用户要求 | 交付 | 实际范围 |
|---|---|---|
| 1. 官方来源登记 | [来源总表](01_OFFICIAL_SOURCES.md)、[CSV](OFFICIAL_METHOD_REGISTRY.csv)、[JSON](OFFICIAL_METHOD_REGISTRY.json) | 14方法，逐方法独立来源卡；论文、官方实现、版本、依赖、教程/数据地址、功能图件和限制 |
| 2. scTour资产审查 | [本地资产报告](02_EXISTING_ASSETS_AUDIT.md) | 7仓库状态、11正式模型历史证据、17组图、脚本/锁、失败与可复用接口 |
| 3. 仓库结构建议 | [目录与文件契约](03_REPOSITORY_PROPOSAL.md) | 独立库/扩展旧库/迁移三方案；推荐独立Private库并引用旧scTour |
| 4. 六组合可行性 | [A–F组合报告](04_COMBINATION_FEASIBILITY.md) | 科学问题、输入、步骤、图表、可组合/不成立推断及STOP/PIVOT |
| 5. 环境与优先级 | [环境/资源报告](05_ENVIRONMENT_AND_PRIORITY.md) | 当前R/Python/硬件、历史环境、依赖冲突与串行小例顺序 |
| 6. 首批方法与图件 | [首批建议/验收](06_FIRST_BATCH_AND_ACCEPTANCE.md)、[Gallery计划](gallery/README.md) | Slingshot→tradeSeq先行、PAGA第二小例；图件为计划，没有新分析图片 |

## 先看这些结论 / Main findings

1. **已有scTour资产充足，不应重建。** 当前库是 [single-cell-dynamics-perturbation](https://github.com/stevenhuangfannk-creator/single-cell-dynamics-perturbation)，本地 `main` / `c7b58d1` 干净；scTour有11个400-epoch正式模型的保存摘要/日志，17组PNG/PDF/SVG。A20/A90发育排序未通过、B1/B5局部错序、S2参数未核实，仍为 **PARTIAL**；本轮没有重载模型或重跑。
2. **新库先作独立方法/组合与Figure脚本工作区。** scTour先引用旧模块、锁与保存结果；RegVelo保持独立。现有Desktop/scriptsR和Research_OS有未提交工作，不碰、不迁移、不清理。
3. **不能用一个环境装完。** CellRank2.3.3要求Python≥3.12、NumPy≥2，CytoTRACE2 Python包要求NumPy<2；scTour/RegVelo及Cell2fate各有旧依赖。Monocle2、Slingshot、tradeSeq的GitHub旧版本与Bioconductor发行亦不一致。细节和原始声明见[各方法来源卡](01_OFFICIAL_SOURCES.md)。
4. **VECTOR候选已核实。** [Cell Reports2020论文](https://doi.org/10.1016/j.celrep.2020.108069)与[作者jumphone/Vector](https://github.com/jumphone/Vector)互相指向；不是未确认的第三方实现。但许可证、旧环境、小例可运行性没有通过，本轮不执行。
5. **方法尺度要分开。** scTour时间不等于潜能或剪接velocity；PAGA连接不等于命运概率；Palantir differentiation potential与CytoTRACE2 potency不同；CellRank自带CytoTRACEKernel不是CytoTRACE2。临床疾病分组不代替真实时间。
6. **F模块有明确兼容决策。** WOT不维护，CellRank `from_wot()`弃用；仍可显式传入couplings。历史版本冻结、分环境耦合文件、另加moscot三种方案在[组合报告F](04_COMBINATION_FEASIBILITY.md)列明，不自行替代。

CytoTRACE2采用Stanford非商业许可；FitDevo和VECTOR仓库许可未明确。来源登记允许引用不等于允许复制/公开再分发源码或数据。后续实际安装与代码复制前按相应条款处理，不凭GitHub可见就假定MIT/BSD。

## 关键本地位置 / Existing local assets

```text
scTour仓库：
C:/Users/13683/Documents/Codex/2026-10-12/files-pasted-by-the-user-codex/outputs/single-cell-dynamics-perturbation
scTour模块：上述仓库/modules/03_scTour
scTour历史大对象：
C:/Users/13683/Documents/Codex/2026-10-12/files-pasted-by-the-user-codex/work/sctour
环境锁：上述仓库/environments/sctour-lock.txt
```

确认版PI风格参考位于 `C:/Users/13683/Documents/ChatGPT/PI_Research/scripts/Step01_Data_Preparation/confirmed_plots/`。Main v3与StyleB v1分别使用不同已确认注释；两者本次hash与历史记录相同。未来借用参数/中文注释/预览/导出结构，不借此修改注释或细胞集合。现有scTour绘图为Agg CLI，交互式Figure脚本尚需另加薄层。

## 状态与自检 / Status and checks

本轮14方法的 `INSTALL_OK / INPUT_OK / RUN_OK / FIGURE_OK` 全部 **NOT_TESTED**；来源审查与历史资产审查完成，不等于新分析通过。`BIOLOGICAL_INTERPRETATION_LIMITS`逐方法保存文本，不能笼统标记“生物验证PASS”。新实现、正式分析、方法图件和环境锁的交付均留到获准的下一轮。

本地资产子审查复核29份小文件/日志及7仓库Git状态不变；本轮未读取大对象。本机约15.69 GiB RAM、即时空闲不足1 GiB；即使获准也先安排单方法官方小例，不能启动14方法并行。检索有GitHub限额/旧URL失败，均在[来源记录](evidence/SOURCE_RETRIEVAL_NOTES.md)保留，未伪报为运行错误。

最终文档、方法数量、状态字段、相对链接和既有资产保护核验见 [REVIEW_ACCEPTANCE.json](REVIEW_ACCEPTANCE.json)。这是交付一致性自检，方法运行验证仍为NOT_TESTED。

## 等待确认的下一步 / Pending next step

**建议：新建独立Private库，scTour先只读引用；首批仅准备Slingshot→tradeSeq官方小例的可编辑脚本与环境/数据清单，PAGA随后。** 具体安装、下载及小例执行范围以用户下一轮确认内容为准。仓库合并/迁移、环境重建、方法替代、真实科研分析及GitHub提交仍需相应确认；本轮到此暂停。
