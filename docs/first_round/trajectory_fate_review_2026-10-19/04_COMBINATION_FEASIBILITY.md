# 六个组合模块可行性 / Combination feasibility

日期：2026-10-19。以下为依据官方方法接口提出的**组合设计**，不是官方联合算法或已验证流水线。A–F均未实施、未运行；`RUN_OK / FIGURE_OK = NOT_TESTED`。

| 模块 | 技术可行性 | 优先级 | 主要门槛 |
|---|---|---|---|
| A Trajectory Consensus | CONDITIONAL | 高，分方法验证后 | 相同细胞、可信根与谱系、保留拓扑分歧 |
| B Dynamic Gene Programs | CONDITIONAL；Slingshot→tradeSeq接口最直接 | 高 | 原始counts、lineage weights、NB-GAM收敛与重复设计 |
| C Cell Potency | CONDITIONAL；scTour是时间参照 | 中 | 模型物种/输入覆盖、方向和潜能定义不同 |
| D Cell Fate | CONDITIONAL | 高 | 有依据的方向/终末，避免同一先验的循环验证 |
| E RNA Velocity | CONDITIONAL | 中后 | 真实剪接计数、不同模型独立预处理、可信速度 |
| F Real-Time Transition | CONDITIONAL且版本接口有风险 | 后置 | 真实实验时间、OT与增长假设、WOT兼容路线确认 |

## A. Trajectory Consensus / 轨迹比较

**问题与场景：** 同一谱系是否支持连续状态、分支和一致排序？用于区分稳健结构与方法/参数依赖，不能仅因四种方法都画出线就认定真实轨迹。

**输入与前提：** 已QC的同一细胞集合、counts及各方法需要的表达尺度、原标签/供者/批次、固定展示坐标、独立生物依据的root/早期状态。不同方法可使用各自规定的拟合空间，不能为视觉一致强制替换官方降维。

**步骤：** 先分别复现Monocle3、Slingshot、PAGA，scTour先引用现有部分复现记录。冻结共同细胞；比较图连通性与分支，再在可匹配lineage内对齐方向、比较排序，最后审查root、邻域和供者影响。保留不连通细胞和每方法NA，不强行给全部细胞补一条时间。

**图表：** 固定UMAP上四方法并列图、原生拓扑/曲线、lineage内rank散点/相关矩阵、分支对应表、unreachable细胞表、参数/供者分层差异表。统计表明确比较细胞数和NA排除规则。

**可组合：** Monocle3图、Slingshot lineage、PAGA群级连接和scTour时间可作为不同视角。PAGA连接强度与细胞拟时序不是同一个输出。**不成立：** 全局平均不同分支的pseudotime；自动反转scTour以贴合预期；以方法多数投票当谱系追踪或疾病进展证据。

**STOP：** 谱系混杂、root无依据、批次主导、断连或方向冲突。**PIVOT：** 保留表达状态/邻域比较和方法不一致图；请用户确认是否限定已注释谱系，而不是自行删细胞。

## B. Dynamic Gene Programs / 动态基因程序

**问题与场景：** 哪些基因随已支持的轨迹变化，哪些曲线在lineage间不同？随后才讨论通路程序。Slingshot→tradeSeq是首选验证链；Monocle3→tradeSeq需要额外定义各lineage的time和weights，不是直接传CDS即可。

**输入：** genes×cells原始counts及size-factor/offset依据、cells×lineages的pseudotime和weights、基因/细胞ID、批次/供者等设计变量、固定版本的物种匹配基因集。表达整合矩阵不当作NB原始计数。Monocle3 `graph_test` 与tradeSeq的轨迹检验分别命名，不混成同一个p值。

**步骤：** 单方法确认轨迹→少量基因验证NB-GAM/knots和收敛→预先指定association/branch contrast→保存效应、检验和FDR→按拟合曲线聚类成程序→选择已定义对比的全基因rank做GSEA；GSVA为适用尺度的表达作基因集评分，另做其统计比较。不能把无方向的association p值直接称为上/下调排序。

**图表：** 基因拟合曲线及不确定性、gene×pseudotime热图、程序代表曲线、lineage差异表、收敛表、GSEA enrichment/NES图、GSVA通路趋势。每一图说明rank或score的定义；模型只用少量基因时不可标完整动态基因筛查。

**可组合：** 共享细胞和counts，保留方法自己的time/weight。**不成立：** 将所有细胞当独立生物重复、将单细胞p值解释为供者级疾病差异；将GSEA与GSVA分数直接合并；对只有显著基因的截断表做全基因GSEA。

**STOP：** counts尺度不明、权重/时间错位、缺少分支支持、拟合大量不收敛或对比无方向。**PIVOT：** 描述性基因/通路曲线；供者级检验须独立设计和用户确认，不擅自替代为另一方法。

方法依据：[tradeSeq论文](https://doi.org/10.1038/s41467-020-14766-3)、[GSVA官方vignette](https://bioconductor.org/packages/release/bioc/vignettes/GSVA/inst/doc/GSVA.html)、[GSEA输入与Preranked说明](https://docs.gsea-msigdb.org/GSEA/GSEA_and_RNA-Seq/)。

## C. Cell Potency / 细胞潜能

**问题与场景：** 表达支持何种分化潜能，是否与轨迹方向相容？CytoTRACE2与FitDevo分别估计潜能/分化能力相关量；scTour的inferred time只作动态排序参照，不能把 `1 − time` 自动命名为干性或潜能。

**输入：** 各官方要求的表达尺度、物种/基因命名与模型覆盖、技术/深度、同谱系细胞和已有marker。CytoTRACE2需要未log的raw counts或CPM/TPM；FitDevo需要未scaled的表达，原始输入按官方NORM=TRUE处理、已有Seurat LogNormalize时NORM=FALSE。不同方法分别检查，不先把counts统一log化后喂全部算法。

**步骤：** 官方小例逐方法验证→同细胞按原尺度取结果→核对高/低分方向→检查读深/检测基因数/细胞周期/供者相关→与已支持的time和marker作分层比较。对不适用物种/状态记录缺口，不自行大写symbol或映射后称等价。

**图表：** 两潜能方法score UMAP、CytoTRACE2类别图、同lineage内score散点、score与检测基因数/供者关系、潜能与scTour time对照、基因覆盖表。所有图使用“预测潜能”，不改成实测干细胞能力。

**可组合：** 作多视角一致性比较，保留分类分数与相对排序的定义。**不成立：** 平均标准化后的不同score造综合干性指数；将炎症/应激高复杂度细胞直接定义为去分化；用潜能定义root后再用同潜能证明轨迹正确。

**STOP：** 物种/ID覆盖不达官方要求、技术深度解释主要差异、方向矛盾或无可信谱系。**PIVOT：** 报告覆盖/混杂及marker表达，不生成“干性增强”机制结论。

CellRank自带 `CytoTRACEKernel` 有自己的实现与输入假设，不能写作CytoTRACE2适配器。若未来要用外部CytoTRACE2结果定向，需单独说明score→direction/time的设计、验证和许可，不继承同名kernel的官方身份。

## D. Cell Fate / 命运概率

**问题与场景：** 在给定图、方向和终末状态下，细胞进入各终末状态的概率如何？Palantir与CellRank应先各自复现，再比较共同可定义的terminal。

**输入：** 有依据的早期状态或可信pseudotime、kNN邻域、足够覆盖的连续谱系、终末候选及cell IDs。可以不需要剪接层，但必须说明方向来自pseudotime而非RNA velocity。

**步骤：** 独立审查pseudotime的方向→分别拟合Palantir和CellRank `PseudotimeKernel`/GPCCA→检查终末细胞组成→保存Markov/absorbing状态及概率→核对非负、行和、异常cell与terminal敏感性→匹配终末后比较概率/熵。

**图表：** macrostates、terminal细胞、分终末概率UMAP/热图、entropy或commitment图、方法差异图与概率守恒表。Palantir differentiation potential、CellRank fate entropy和C中的potency不是同一个指标，不互换名称。

**可组合：** 经验证的Monocle3/Slingshot/scTour time可通过显式file契约供CellRank使用；这只是输入适配。**不成立：** 多方法用同一pseudotime后把相似概率当独立验证；用临床HG/PI标签作时间；把预测概率解释为细胞真实转化频率。

**STOP：** 无可靠方向、终末不存在/混杂、不连通图、行和/数值失败。**PIVOT：** 输出状态相似性和输入审计，不强行命运命名。

官方依据：[PseudotimeKernel API](https://cellrank.readthedocs.io/en/stable/api/_autosummary/kernels/cellrank.kernels.PseudotimeKernel.html)、[CellRank pseudotime教程](https://cellrank.readthedocs.io/en/stable/notebooks/tutorials/kernels/300_pseudotime.html)、[CellRank 2论文](https://doi.org/10.1038/s41592-024-02303-9)。

## E. RNA Velocity / RNA动力学

**问题与场景：** 剪接动力学是否提供可解释的短时表达方向，模型差异怎样影响命运？scVelo和Cell2fate应分别按其官方输入与模型规则运行，分别给CellRank构建kernel。

**输入：** 真实且来源可追溯的spliced/unspliced、counts尺度、相同细胞/基因的轴、样本/批次、可信动态谱系。Cell2fate的S/U层应为真实raw UMI counts；不要用普通表达拆出剪接层，不把scVelo归一化moments当成另一模型所需原始counts。Cell2fate的模型训练与后验输出独立保存，不预设可用官方预训练checkpoint。

**步骤：** 检查S/U与来源→按模型分别预处理→先小型官方基线再训练型模型→检查phase portrait、拟合/不确定性、速度基因和邻域方向→分别投影/CellRank→冻结同terminal后比较。Cell2fate velocity到CellRank的层名/尺度需要实际接口测试，不能在文档中声称适配完成。

**图表：** S/U QC、phase portraits、stream/grid、latent time、模型拟合/后验不确定性、Cell2fate动态模块、两模型方向/命运差异。流线只是投影展示，不能作为谱系追踪真值。

**可组合：** 相同cell IDs、共同终末/坐标下并列比较。**不成立：** 直接平均两个模型velocity；用UMAP箭头一致率当实验准确率；拿既有RegVelo环境PASS证明新Cell2fate环境兼容。

**STOP：** 缺真实S/U、动力学信号不足、主要受深度/批次支配、数值失败或资源超过批准预算。**PIVOT：** 记录RNA动力学不适用；若有可信pseudotime，可提出D路线供确认，不能静默替代。

## F. Real-Time Transition / 真实时间转移

**问题与场景：** 已知实验采样时间之间的细胞群如何通过OT耦合，如何汇总为祖先/后代及命运？仅用于真实多时间点实验。

**输入：** 可排序且有单位的真实采样时间、同一实验设计下可比较的表达空间、采样/批次/供者、增长/死亡或其模型假设。至少能定义相邻时间对；只有两个时间点只能分析该段，不支持中间动态的实测结论。病种/严重度/供者序号都不能伪装为实验时间。

**步骤：** 按相邻时间独立核对输入→WOT计算transport maps及边际/增长诊断→核对源/目标cell轴→传给CellRank RealTimeKernel→明确时间内self-transition设置→检查最终概率与命运。OT coupling和行归一化transition分别保存，不能先归一化后丢失原质量与诊断。

RealTimeKernel接收已算couplings，单独构造它不会从表达自动求OT。除最终行和外，还要检查原coupling/转移构造的empty-row警告及阈值处理：当前源码可能把空行填成uniform，不能因填补后的行和为1就宣布原输入有效；保留警告和填补细胞列表，先暂停查明原因。

**图表：** 时间分布/批次表、pairwise transport heatmap、祖先/后代分布、流量或Sankey、命运概率及对growth/regularization的敏感性表。

**关键版本决策：** 当前CellRank stable文档注明 `from_wot()` 从2.2弃用、计划3.0移除；WOT处于不维护状态。仍可显式传预计算couplings。待用户选：①固定历史WOT与兼容CellRank做官方历史复现；②独立WOT环境输出耦合，以显式文件传入新CellRank并验证；③另设moscot作为新方法比较。推荐先评估①/②，③会扩大/替代指定方法，不能擅自执行。[RealTimeKernel官方API](https://cellrank.readthedocs.io/en/stable/api/_autosummary/kernels/cellrank.kernels.RealTimeKernel.html)

**可组合：** WOT耦合与RealTimeKernel是有文档依据的路径；实验时间与pseudotime可对照但不能互换。**不成立：** 把OT匹配当单细胞真实谱系；将横断面疾病分组用于WOT；为了兼容自动切换到moscot。

**STOP：** 没有真实时间、相邻时间细胞不可比/批次完全混杂、增长假设无法说明、coupling轴不一致或版本适配不通。**PIVOT：** 先报告表达状态与设计缺口；方法替代、环境重建及数据选择等待确认。

## 共同验收 / Shared acceptance

每个单方法先有来源、安装/输入/运行/图件的独立证据，组合才进入验证。统一白底/配色/已确认注释不等于统一算法假设。每个组合记录输入hash、ID轴、版本、seed、root/terminal、排除规则、效应单位、错误和未完成项；小样本/模拟原型与正式分析分开。供者独立重复与细胞数不混用。
