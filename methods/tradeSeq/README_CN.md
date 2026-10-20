# tradeSeq：沿轨迹检验动态基因的中文实践指南

本页对应真实本地运行：R 4.6.1、Bioconductor 3.23、tradeSeq 1.26.0。官方 Paul15 小例为 **240 基因 × 2,660 细胞、两条已估计谱系**。模型和图由本项目实际运行生成，未复制官方截图。运行日志见 [首次运行](logs/01_official_run.log)、[数值敏感性检查](logs/02_numerical_sensitivity_replot.log) 与 [最终重绘](logs/04_final_figure_export.log)。首次重绘的独立对象加载错误也保留在日志中，已修正后重新导出。

## 先判断是否适合你的问题

tradeSeq 研究“给定一条或多条轨迹后，哪些基因随进程变化，在哪个阶段或分支不同”。它不决定根、分叉和命运概率。先有可信轨迹，再分析表达变化；对根和拓扑没有把握时，应先做轨迹敏感性分析。

适合比较早晚表达、非单调变化、分支整体模式、候选终点差异，以及指定结点区间的表达差异。若只有 UMAP 坐标、归一化表达或整合后的校正矩阵，没有原始计数，不适合直接套用这里的负二项计数模型。没有生物重复时，显著性只能描述这个细胞集合的轨迹关联，不能当作疾病效应或可推广到所有人的结论。

论文：[Van den Berge 等，2020](https://doi.org/10.1038/s41467-020-14766-3)。官方 [GitHub](https://github.com/statOmics/tradeSeq)、[Bioconductor 3.23](https://bioconductor.org/packages/3.23/bioc/html/tradeSeq.html)、[工作流 vignette（官方示例教程）](https://statomics.github.io/tradeSeq/articles/tradeSeq.html)、[拟合参数教程](https://statomics.github.io/tradeSeq/articles/fitGAM.html)。本轮网页域名部分 DNS 失败，已从作者 GitHub 的原始 Rmd 读取同一官方教程，版本和校验见 [来源记录](../../docs/round3/SOURCES.json)。

## 模型原理与关键概念

负二项广义加性模型（negative binomial generalized additive model，NB-GAM）分别为每个基因拟合计数分布，并用平滑函数表示每条谱系随拟时序的均值变化。负二项分布允许计数方差超过均值；平滑函数允许先升后降等非线性模式。

拟时序（pseudotime）是上游方法推断的相对顺序，不是培养小时数。谱系（lineage）是从指定根走向某一计算终点的路径。谱系权重（cell weights）描述细胞对曲线的归属；同一祖细胞可同时参与两条谱系，权重不一定行和为1，也不是命运概率。模型在内部按这些权重处理谱系归属，拟合包含随机性，应保存随机种子。

结点（knots）决定平滑基函数的灵活度。6个结点不表示6个细胞状态，也不自动定位生物分叉。偏置项（offset）用于计数测序深度校正。官方例子采用默认 TMM 归一化偏置；这240个基因是既有筛选面板，其归一化和推断范围都受面板限制。共同数据组合另用提供的全部10,000个基因计数计算细胞测序深度，避免把下游挑出的300个基因当作完整文库。

## 输入契约与 Seurat / AnnData 准备

计数必须是 **基因×细胞**、非负整数，基因和细胞 ID 不重复；零膨胀不是简单删除零值的理由。拟时序与权重都是 **细胞×谱系**，行名、顺序和表达列名逐一一致。不能只检查维度相同。`slingPseudotime(crv, na=FALSE)` 给模型提供有限的时间值，权重负责排除不属于某谱系的贡献；绘图和方法比较仍保留原始 NA 时间。

Seurat v5 先用 `LayerData(obj, assay='RNA', layer='counts')` 取得原始计数；多层对象须明确哪个 layer（数据层）对应哪些细胞，不能默认拼接所有批次。Seurat v4 可用 `GetAssayData(..., slot='counts')`。保存元数据、供者、条件、批次、状态注释以及轨迹使用的细胞清单。不要传入 `integrated` 或 `scale.data`。

AnnData（Python 的带注释矩阵对象）通常是细胞×基因。先确认 `adata.layers['counts']` 确实是原始计数，再转置到R，并导出 `obs_names` 和 `var_names`。`adata.X` 不保证是计数；转换前必须检查。整数外观也不能替代来源记录。稀疏矩阵优先，不要为大型对象反复转成稠密矩阵。

## 安装、配置与运行顺序

使用独立包库，本轮没有改系统默认 R、scTour 或 RegVelo。已经安装的精确包清单和下载校验见 [环境记录](../../environments/round3_tradeSeq_downloads.csv)。标准安装入口是 `BiocManager::install('tradeSeq')`；应匹配 R / Bioconductor，不能把本机现有环境无条件升级。Windows 本轮使用官方二进制，单进程即可。

从仓库根目录运行：

```r
options(toolkit.library='你的独立R包库')  # 已有合适环境时可省略
source('round3/00_Start.R', encoding='UTF-8')
source('methods/tradeSeq/scripts/01_Load_and_Check.R', encoding='UTF-8')
source('methods/tradeSeq/scripts/02_Fit_and_Test.R', encoding='UTF-8')
source('methods/tradeSeq/scripts/03_Plot_and_Export.R', encoding='UTF-8')
```

也可 `Rscript methods/tradeSeq/scripts/run_example.R`。01只加载一次小数据并核查，02拟合与检验，03绘图。VS Code R Interactive（交互式R会话）可按这些文件逐段运行。配置集中在 [第三轮00入口](../../round3/00_Start.R)，不会调用第二轮的 Slingshot 入口或覆盖其文件。重新运行本方法会更新本方法结果；需要保留新旧参数比较时，先给结果目录加版本名。

只重绘：在新会话先 source 00，再 source 03；它读取保存的模型，不重新训练。图件统一白底，导出 PNG（位图）、PDF 和 SVG（矢量图）。英文图内标签避免跨系统中文字体缺失，中文含义在本页与图卡解释。

| 参数 | 本例 | 作用与调整依据 |
|---|---|---|
| seed | 7 | 与官方拟合例子一致；保存用于重复拟合 |
| nknots | 6 | 官方教程示范值；本次未执行 evaluateK，不声称最优 |
| parallel / 后端 | FALSE / SerialParam | 单进程；适合16 GB设备串行运行 |
| nPoints | 100 | 仅用于展示平滑网格；不增加独立观测数 |
| FDR | 0.05 | 每类检验分别进行BH校正，不是所有检验合并校正 |
| earlyDE knots | 1、2 | 第一个结点区间；须先核查其是否覆盖真实研究关注的分叉区 |
| association inverse | 默认Chol；另报eigen | 矩阵求逆算法的数值敏感性检查，不能按显著基因最多者择优 |

真实项目可在预先选定的代表基因上运行 `evaluateK(k=3:10)`，结合 AIC（赤池信息准则）、收敛与曲线复杂度选择结点数。不要用反复调参寻找最显著结果。本轮官方240基因例未做这个选参计算，也未拷贝教程中的 AIC 图片冒充本次结果。

官方旧版Rmd设置 `RNGversion("3.5.0")`（沿用旧版随机数与采样规则）。本轮使用R 4.6默认的Mersenne-Twister / Inversion / Rejection及seed=7，未切回旧采样器；同一seed不保证跨采样器得到相同谱系抽样。本轮属于固定当前环境的官方工作流复现，不声称与旧教程逐数值或逐像素一致。最终入口重跑的数值表一致；若比较旧采样器，应另建结果目录，不覆盖本次结果。见[执行范围说明](../../docs/round3/EXECUTION_PROTOCOL_CN.md)。

## 五类检验分别回答什么

| 函数 | 零假设/问题 | 不能据此断言 |
|---|---|---|
| associationTest | 表达是否沿一条或多条谱系发生变化 | 显著基因是因果驱动基因 |
| startVsEndTest | 各谱系起点与终点表达是否不同 | 中间过程单调；两个终点彼此不同 |
| patternTest | 多条谱系的整体表达模式是否一致 | 已对齐真实时间；分叉点已被定位 |
| diffEndTest | 不同谱系计算终点的均值是否相同 | 细胞生物学不可逆或已终末分化 |
| earlyDETest | 两个指定结点间不同谱系的平滑模式是否一致 | 默认 knots=c(1,2) 就一定是分支形成区 |

谱系间模式检验依赖两条曲线的时间参数化。把每条谱系0–1化便于展示，但两个0.5未必是同一个生物学阶段。`patternTest` 的跨谱系比较有此限制，不能把不同路径长度、取样密度或成熟速度造成的差异全部解释为命运机制。

## 实际收敛、FDR与数值局限

240/240 模型收敛，首次拟合约50.25秒。这不代表所有 Wald 检验都可识别。默认 associationTest 的协方差对比矩阵使用 Cholesky 分解，126个基因返回 NA；替代官方参数 `inverse='eigen'` 返回240个有限结果。实现中 Cholesky 失败会返回NA，原实现片段留存在日志；这属于数值敏感性，不是生物学缺失。

最终文件始终保留默认表 `association.tsv` 和独立的 `association_eigen_sensitivity.tsv`。默认结果在114个有效p值中有110个通过FDR<0.05；校正时 **n=240个收敛模型**，NA不当成显著或阴性。eigen敏感性表240个通过阈值，但这个高度预筛选的示例面板不能用来估计全基因组阳性率。两种求逆给出明显不同的可用性，实际项目应结合效应量、拟合图、条件数/秩和重复数据核查。

startVsEnd / pattern / diffEnd / earlyDE 各有240个有效p值，显著数分别为230 / 235 / 206 / 170。统计表保留每个基因的原始p值、自由度、Wald统计量、收敛和BH结果。FDR（false discovery rate，假发现率）控制的是所定义检验族中错误发现的期望比例，不能解释为每个基因“有95%概率是真的”。不同检验族的FDR不能直接合并成一个全局保证。

软件用 `1-pchisq` 计算某些极小p值，可能数值下溢显示0。0不是数学上精确为零。展示排序在p值并列时使用Wald统计量降序，再按基因名稳定排序；不把零p值当作无限证据。请同时读效应和拟合图。

## 本次图件与逐图阅读

![官方配套轨迹](figures/T01_official_trajectory.png)

T01 的点是细胞、颜色是官方细胞类型，黑线是提供的 Slingshot 曲线；坐标是这个例子的官方 UMAP（统一流形近似与投影）。它不是第二轮140点模拟坐标，也不是本轮重新学习的轨迹。图不能证明黑线是细胞真实移动路径。

![表达平滑曲线](figures/T02_expression_smoothers.png)

T02 展示 Apoe 的原始计数经log(1+count)显示的散点与谱系平滑拟合，横轴为拟时序。平滑曲线不是逐细胞实测时间序列，也不是置信带；零计数常见。该图支持“给定当前轨迹，Apoe表达与进程有关”，不能推出其调控脂质代谢或驱动PI纤维化的因果作用。

![动态基因热图](figures/T03_dynamic_gene_heatmap.png)

T03 每行是默认 associationTest 排名前30的基因，两段列分别是两条谱系各100个平滑网格点；黑线分隔谱系。颜色为 log(1+拟合均值) 的逐基因z分数（标准分数），色条给出范围。红色是该基因相对自身均值较高，不是跨基因的绝对高表达；网格列不是100个新细胞。并列p值按Wald统计排序。

![分支模式差异](figures/T04_lineage_pattern_difference.png)

T04 左侧是 Mpo 的两条谱系拟合均值；右侧为 `log2((mu1+1)/(mu2+1))` 描述性差值。颜色标出谱系，横轴各自0–1化。这里的+1只是稳定描述，右图没有独立的逐位置显著性检验，不能用曲线穿过0定位命运决定点。

![检验汇总](figures/T05_test_summary.png)

T05 逐列显示六张统计表在各自校正族中的显著基因数，包含额外的eigen敏感性结果。它说明问题定义和数值实现会影响结果；不能用柱子最高的一项证明哪个检验最好。上述每张图的8项阅读卡、脚本与输出格式见 [figure_notes](figure_notes/INDEX_CN.md)。

## 与其他方法怎样组合

Slingshot提供每谱系时间与权重，tradeSeq负责条件表达检验，Monocle3独立推断主图和时间。相同细胞集合、根方向和终点覆盖核实后，才可比较结果。Monocle3 的 Moran's I 检验关注图邻域相似性，与tradeSeq平滑时间关联不是同一个假设；交集不是经过独立重复的“真基因”，因为双方使用同一表达数据。

真正的同数据组合在 [650细胞示范](../../combinations/Slingshot_tradeSeq_Monocle3/README_CN.md)，有独立的组合验收。单独运行三个方法成功不等于组合成功。不要将官方240基因的Paul15例子与线虫神经元例子拼接计算相关性。

功能分析须用明确物种、稳定基因ID、版本固定的基因集，以及与检验一致的背景。过度富集分析（over-representation analysis，ORA）比较入选基因与背景的基因集覆盖；基因集富集分析（gene set enrichment analysis，GSEA）通常需要完整、可解释的带方向排序。associationTest为多自由度非定向统计量，不可直接给它任意加正负号冒充通路激活/抑制。240基因官方示范不是合适的完整GSEA输入，故未对它生成虚构通路图。

## PI Fibroblast State 1/6/7 预设应用：仅研究设计

先按供者与PI/Healthy条件检查状态覆盖、质量、双细胞、细胞周期及批次，保留原始RNA计数。不得预设1→6→7是已成立路径。分别用各供者和条件估计连续性、起点证据及候选分支；方向不稳定则停止机制叙事。

ECM（extracellular matrix，细胞外基质）需要分开讨论合成程序（如COL1A1/COL1A2/COL3A1、FN1）、降解与抑制（如MMP家族、TIMP1/2）和组织重塑（如LOX、POSTN）。预先登记集合，检查基因实际检出及物种映射，避免把少数高表达胶原基因重复计入多个通路后当作多个独立证据。

Integrin–FAK–YAP/TAZ机械转导的候选转录程序可包括ITGA/ITGB、PTK2、CTGF/CCN2、CYR61/CCN1、ANKRD1等；YAP/TAZ活性还涉及定位、磷酸化和力学环境。PTK2或YAP1的mRNA变化不能直接证明FAK磷酸化或YAP入核，应衔接蛋白、成像和力学扰动实验。

炎症/修复须结合条件、供者、细胞微环境，分别检查IL6、CXCL等基因及NF-κB/干扰素/修复集合。不能因一条轨迹终点炎症评分高就称它是PI疾病终点。起终点检验配合分支模式和效应阈值；最终疾病比较应使用适当的供者层面或重复设计，而非把细胞当独立病人。

在每条可信谱系上拟合动态程序，画平滑曲线、效应/不确定性与供者分层覆盖。动态功能排序只在同一条件、匹配区段且有明确方向对比时构建；跨分支先分开解释。详细 STOP/PIVOT（停止/调整方向）条件见 [PI专题](../../case_studies/PI_Fibroblast_State_Reprogramming/ROUND3_DYNAMIC_DESIGN_CN.md)。本轮没有运行真实PI数据。

## 常见问题与处理

| 现象 | 排查和处理 |
|---|---|
| 维度一致却结果错误 | 用 `identical(colnames(counts),rownames(pseudotime))` 检查顺序，按ID显式重排 |
| 非整数或负表达 | 回到原始 counts；不能简单四舍五入校正矩阵 |
| 拟时序有NA | 模型输入按官方 `na=FALSE`，同时保留原始NA用于归属解释；不要给未归属细胞加伪权重 |
| 某基因不收敛 | 保留记录；检查极低表达、测序深度、结点数、权重和分支覆盖；不要删除后假报100% |
| 收敛但检验NA | 检查对比矩阵与数值求逆；可记录官方eigen参数敏感性，但不能只汇报最显著版本 |
| Windows退出异常 | 本项目00入口仅在缺失时补架构变量；不要盲目降级cli或改其他环境 |
| 内存不够 | 串行拟合、预先规则筛基因、保存对象后在新会话绘图；记录缩小后的检验宇宙 |
| 高显著率/很多0p值 | 检查预筛选偏差与数值下溢，结合效应与独立重复；不要等同机制证明 |
| 分支早期差异被称为分叉驱动 | earlyDETest只检验所选结点区间；分叉区域、扰动因果和时间顺序需额外证据 |

验收详见 [STATUS.json](STATUS.json)。复现通过只适用于这个例子及记录的环境，不代表患者研究或所有参数已获科学验证。
