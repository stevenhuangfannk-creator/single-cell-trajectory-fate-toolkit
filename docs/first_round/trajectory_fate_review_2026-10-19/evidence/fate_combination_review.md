# C–F组合与环境只读复核 / Fate combination review

日期：2026-10-19。范围：交付目录 `outputs/trajectory_fate_review_2026-10-19/` 的 `04_COMBINATION_FEASIBILITY.md` C–F及 `05_ENVIRONMENT_AND_PRIORITY.md`，对照已保存官方源卡。没有扩展检索、安装、导入科研包、下载数据、运行模型或修改交付文件。

**结论：未发现阻断第一轮只读交付的问题。组合均为CONDITIONAL、运行NOT_TESTED，关键方法边界总体准确。建议交付前完成以下3处具体措辞修正。**

| 位置 | 重要修正 | 理由 |
|---|---|---|
| `04_COMBINATION_FEASIBILITY.md:80` | 明写“Cell2fate要求 `layers['spliced']` 与 `layers['unspliced']` 的真实 **raw UMI counts**；其模型训练与后验结果独立保存”，替换“Cell2fate的预训练/训练”。 | 官方教程明确raw UMI，不能把归一化moments或普通表达当作输入；本次核查未建立官方预训练checkpoint流程，“预训练/训练”会暗示未经核实的能力。 |
| `04_COMBINATION_FEASIBILITY.md:48` | 在泛称“各官方要求的表达尺度”后明确“CytoTRACE2用未log的raw counts或CPM/TPM；FitDevo用未scaled表达，raw时NORM=TRUE、已LogNormalize时NORM=FALSE”。 | 当前“不要统一log”方向正确，但输入契约应写出相反尺度要求，避免用户仅阅读组合文档时误把同一log矩阵交给二者。两方法源卡已正确。 |
| `05_ENVIRONMENT_AND_PRIORITY.md:30` | 明列“CytoTRACE2 Python1.1.0.4要求NumPy<2，不能与CellRank2.3.3的NumPy≥2共环境；若选R接口另审Seurat/Matrix”。 | 现表已建议独立potency环境，01来源总表也写出冲突，但此环境表没有列出确定的互斥约束，宜保持自包含。 |

## 已核实正确的关键内容 / Confirmed boundaries

- D模块正确区分PseudotimeKernel与RNA velocity：拟时序/kNN可构造方向核，但不是实验时间；fate以kernel/terminal为条件，共用同一ordering不能当独立验证。
- E模块正确拒绝普通expression伪造S/U、拒绝拿scVelo moments充当另一模型raw counts；Cell2fate→CellRank层名/尺度适配保持NOT_TESTED。上述第1项是进一步收紧输入说明。
- C模块和01来源表正确区分CytoTRACE2与CellRank自带CytoTRACEKernel，未把潜能或1−scTour time自动称为干性/真实时间。CytoTRACE2未log输入与非商业许可在来源卡已准确。
- VECTOR在05行34、59保留2020论文/作者repo的候选身份核对、R3.6.1/Seurat3与LICENSE UNKNOWN；同时把“候选符合用户原意”的确认和“运行通过”分开，当前HOLD运行正确。
- F模块正确要求真实采样时间、可比较的时间对及growth/OT假设；保留transport mass与行归一化transition两种对象，未混同为原始概率。
- F模块准确说明from_wot自2.2弃用、计划3.0移除、WOT不维护，并保留历史冻结、显式couplings、另增moscot三个待选分支，没有擅自替换方法。
- 05正确将当前CellRank2.3.3（Python≥3.12/NumPy≥2）与历史scTour/RegVelo、Cell2fate旧锁栈隔离；Cell2fate tag1.0.0与metadata0.01a没有混称。4GiB为项目建议预算，未冒称官方最低需求。

本复核针对文档一致性和接口设计，不能提升任何方法的INSTALL_OK、INPUT_OK、RUN_OK或FIGURE_OK。所有实际安装与科学计算仍需后续明确授权。
