# Slingshot + tradeSeq + Monocle3：同数据组合分析与冲突教学

**这是本项目实际运行的研究工作流，不是官方联合算法。技术执行完成，完整轨迹一致性未获确认。** 两种轨迹方法在共同650细胞上均运行，AWA谱系出现明显排序/终点冲突；本模块以真实结果解释冲突，不把三种单方法成功当成联合验证通过。

## 为什么组合，能增加什么信息

Slingshot（给定聚类后的主曲线）提供每谱系时间与权重；tradeSeq（轨迹条件下的负二项广义加性模型，NB-GAM）研究表达形状和分支差异；Monocle3（独立预处理和分区主图）提供另一种结构/排序及图动态基因视角。组合可以检查“某个动态基因结论是否依赖单一轨迹表示”和“同一细胞排序是否稳定”，不能自动增加真实时间、细胞命运概率或因果证据。

## 为什么不直接拼接官方最小例

第二轮Slingshot为140×2模拟坐标，没有表达计数。tradeSeq官方为240基因×2660个小鼠Paul15细胞及配套曲线。Monocle3官方小例为线虫胚胎神经元。这三个例子的细胞、物种和观测不同，不可拼接算相关性。

本模块选择 **Monocle3官方仓库worm_embryo小数据中的同一650细胞**：Neuroblast_ASG_AWA 142、ASG_AWA 99、ASG 173、AWA 236。先按官方注释限定一个有生物学来源依据的共同发育系统，排除ADL/AWC/AWB等其他神经元。两方法从同一个10,000×650原始计数对象开始；细胞ID、基因ID和原始对象hash登记在 [输入来源](../../data_registry/Round3_inputs.json)。这是官方数据的本地限定子集，不冒称原作者已经验证过本联合流程。

## 输入、环境和运行顺序

先完成 [Monocle3官方例](../../methods/Monocle3/README_CN.md)，它生成小型 `input_bundle.rds`；然后在仓库根顺序执行本模块01→02→03→04。安装沿用独立R包库，统一参数在 [第三轮00入口](../../round3/00_Start.R)，串行运行，不启动多进程训练。

```r
source('round3/00_Start.R', encoding='UTF-8')
source('combinations/Slingshot_tradeSeq_Monocle3/scripts/01_Common_Input.R', encoding='UTF-8')
source('combinations/Slingshot_tradeSeq_Monocle3/scripts/02_Independent_Trajectories.R', encoding='UTF-8')
source('combinations/Slingshot_tradeSeq_Monocle3/scripts/03_Compare_and_Dynamic.R', encoding='UTF-8')
source('combinations/Slingshot_tradeSeq_Monocle3/scripts/04_Plot_and_Export.R', encoding='UTF-8')
source('combinations/Slingshot_tradeSeq_Monocle3/scripts/06_Functional_Analysis.R', encoding='UTF-8')
source('combinations/Slingshot_tradeSeq_Monocle3/scripts/07_Sensitivity_No_Alignment.R', encoding='UTF-8')
```

05是可选的GO官方注释再生成脚本（Python标准库）：先按 [获取脚本](../../environments/round3/Get_Optional_GO.ps1) 下载GAF/本体，再运行05。仓库已保留本次小型派生基因集及校验，正常重跑06无需重新下载注释。07是看到主要流程冲突后补充的敏感性分析，单独保存，不能替代主要结果。重绘04只读取保存拟合，不重新推断轨迹或拟合NB-GAM。

| 脚本 | 作用和关键限制 |
|---|---|
| 01 | 按预定注释选择650细胞，逐一核查ID；不按相关性或图形挑细胞 |
| 02 | 两方法独立处理：Slingshot为2000变异基因/20维PCA+给定注释聚类；Monocle3为20维PCA+官方批次/背景对齐、UMAP、聚类/分区和主图 |
| 03 | 同细胞逐谱系比较、终点映射，300个预先方差筛选基因的tradeSeq，3515个表达合格基因的Monocle3图检验 |
| 04 | 轨迹、相关、差异、曲线、热图和共同基因检验图；PNG/PDF/SVG |
| 05/06 | 官方GO注释处理和条件ORA（过度富集分析）；不是有方向GSEA |
| 07 | 唯一流程改变是省略align_cds；保持其余设置/根规则，报告依赖性而非择优 |

Slingshot的根群预设为Neuroblast_ASG_AWA；Monocle3在含这些细胞的分区用最近图节点投票选根Y_4。任何不含预设祖细胞的分区保留不可达时间，不为了连续性强行选根。当前650细胞在一个分区且时间有限。最初PCA函数丢失行名，ID检查真实中止；按原始输入行顺序明确恢复行名后重新运行。首次失败及修复日志均保留。

## 什么可以比较，什么不能直接比较

可以比较共同ID的排序、可信共享根下的方向、末段细胞覆盖、候选终点映射，以及共同被检验基因中的结果集合。每条Slingshot谱系分别筛选原始时间有限、Monocle时间有限且Slingshot权重≥0.5的细胞；在同一组有效细胞上分别归一化到0–1，不自动翻转。不同谱系的共享祖细胞会重复出现，样本数不能相加为独立细胞数。

不能直接比较PCA与UMAP的坐标/曲线形状优劣、原始时间数值、同名谱系编号、q值大小或不同检验族的显著数。20维PCA曲线投影到二维会重叠，不能仅凭平面线条看不出分叉就判算法错误。Slingshot使用给定注释，Monocle3自行聚类，且批次处理不同，所以这比较的是两套完整流程，不是控制其他变量后对算法核心的排名。

## 实际一致性与冲突

| Slingshot路径 | 同时有效且权重≥0.5细胞 | 主要流程Spearman秩相关 | 不做Monocle对齐的敏感性相关 |
|---|---:|---:|---:|
| Neuroblast_ASG_AWA→ASG_AWA→AWA | 471 | −0.0108 | 0.6321 |
| Neuroblast_ASG_AWA→ASG_AWA→ASG | 427 | 0.7597 | 0.7424 |

Spearman秩相关衡量排序一致，不能测定方向真伪。AWA末20%中的64/95个细胞最近主图叶节点为Y_4，**该节点同时是Monocle根**；另27/95映射Y_18、4/95映射Y_7。该分支不满足可信共同终点匹配，AWA不通过一致性验收。ASG末段83/86映射Y_18，但这只是最近叶节点映射；图对终末区域的覆盖仍须审查，不能仅凭0.76就宣布完整拓扑一致。

去掉对齐后AWA排序改变很大，提示批次校正/表达表示对结论有实质影响。收集时间与发育状态可能混杂，对齐既可能纠正技术效应，也可能抹去生物学变化；不用“相关性更高”来判定哪套流程是真实轨迹。本轮没有独立真值、谱系追踪或留出供者来裁决。完整定量和限制见 [冲突报告](AGREEMENT_LIMITATIONS_CN.md)。

## 动态基因与功能结果

共同数据tradeSeq对300个预先按表达方差筛选的基因拟合，300/300收敛；关联检验使用明确记录的eigen求逆，298个结果有效，2个NA保留。偏置使用输入全部10,000基因计数的文库深度，避免用筛选300基因的列和替代整个输入的深度。6结点、seed7、单进程。各类检验有独立BH校正族n=300。

Monocle3对同一650细胞中至少20细胞检出的3515基因检验。在298个共同有效检验基因中，tradeSeq显著274、Monocle3显著282、交集263、并集293，Jaccard（交并比）=0.8976。两个检验共享表达数据且基因已高变筛选，零假设不同，因此高交集不是独立验证，也不能修复AWA排序冲突。

功能示例使用 **Monocle3图动态基因**，条件为q<0.05且Moran's I>0.1，不依赖人为给关联统计量添加符号。GO基因本体（Gene Ontology）使用WormBase线虫注释，排除NOT/IEA（电子推断）记录，并沿is_a/part_of关系传播，保留来源、日期和hash。只有2177/3515个被检验基因能映射到该BP（生物过程）背景；其中196个满足动态阈值。对背景内大小10–500的948个集合统一BH，22项FDR<0.05。

最靠前条目包括chemosensory behavior（化学感觉行为）、behavior（行为）和细胞突起组织相关注释。第一项覆盖14/196入选基因、30/2177背景基因，富集倍数约5.18、FDR约5.55×10⁻⁵。它支持“当前图相关基因集富含这些功能注释”的条件解释，不等于测量了动物行为，且GO父子术语重叠，22项不是22条独立机制。结果不证明程序上调/下调，更不能推导PI纤维化机制。

没有为240基因官方Paul15面板或300高变基因面板伪造全基因组GSEA。真正的GSEA（基因集富集分析）需要明确方向、完整可解释排序、合适物种和背景，另见 [PI动态研究设计](../../case_studies/PI_Fibroblast_State_Reprogramming/ROUND3_DYNAMIC_DESIGN_CN.md)。

## 实际图件与阅读顺序

![独立轨迹对照](figures/C01_independent_trajectory_comparison.png)

先读C01的两种坐标和真实覆盖差异，再读C02/C03的同细胞排序/尺度偏差。C04用ces-1演示tradeSeq谱系曲线，C05为动态热图，C06展示共同基因的不同假设检验，C07为GO条件富集。C08（位于敏感性目录）只用来检查不对齐流程，不是替换主要图。

![同细胞逐谱系排序](figures/C02_per_lineage_pseudotime.png)

![动态程序热图](figures/C05_dynamic_gene_heatmap.png)

[八张逐图中文阅读卡](figure_notes/INDEX_CN.md) 给出来源、数据、脚本、图形元素、回答的问题、本例解释、误读与PI使用。所有主要图实际导出三种格式，统计表和可编辑脚本可以追溯图件。

## PI应用与STOP/PIVOT

该工作流可用来检查State1/6/7是否形成稳定局部连续结构，随后研究ECM合成/降解/重塑、机械转导和炎症程序。状态数字不决定方向；整合表达不替代计数；供者不是细胞。真实PI仅做 [教学研究设计](../../case_studies/PI_Fibroblast_State_Reprogramming/ROUND3_DYNAMIC_DESIGN_CN.md)，本轮无患者数据。

若候选根不足、分区不连通、终点映射不稳、预处理改变方向或关键状态由单个供者支撑，则停止“全局状态重编程”的结论，转向有支持的局部路径或供者层面状态差异。当前AWA冲突就是应保留的PIVOT示范，不应调参隐藏。

验收：[STATUS.json](STATUS.json)。**实际组合已运行；科学一致性是部分可比较/未确认，不能作为官方联合算法或生物学证明发布。**
