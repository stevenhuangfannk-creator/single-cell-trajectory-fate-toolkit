# 第三轮中文交付总结

已在现有项目完成本地tradeSeq、Monocle3官方小例与Slingshot+tradeSeq+Monocle3同数据组合。**本轮新增19组实际科研图、57个PNG/PDF/SVG文件；累计含原Slingshot为25组/75文件。没有运行真实PI、没有修改scTour或RegVelo、没有创建/修改GitHub远程。**

## 分方法验收

| 对象 | INSTALL | INPUT | RUN | FIGURE | 中文教程 |
|---|---|---|---|---|---|
| 原Slingshot140点小例 | PASS | PASS | 原PASS，未重跑 | 原6组PASS | 原教程+第三轮组合补充 |
| tradeSeq官方240基因×2660细胞 | PASS | PASS | PASS，数值局限明确 | 新5组PASS | 完整指南+5图卡 |
| Monocle3官方10000基因×1805细胞 | PASS，警告保留 | PASS | PASS | 新6组PASS | 完整指南+6图卡 |
| 三方法共同650细胞 | PASS | PASS，ID一致 | 真实联合执行PASS | 7主图+1敏感性PASS | 组合教程+8图卡+冲突报告 |

**组合另行验收**：输入/技术执行/图件通过；科学可比性PARTIAL、AWA终点FAIL、完整轨迹共识NOT_ESTABLISHED。没有用三方法单独成功替代组合验证。

## 实际数值结果和未通过项

- tradeSeq 240/240模型收敛，约50秒首次拟合。默认associationTest有126个NA；114个有效p值在n=240的BH校正族中110个显著。eigen敏感性240有效/240显著；两表同时保留，不挑显著最多者。其他四类显著数为230、235、206、170。
- Monocle3学习148个图节点、3个分区，分区分别选根；1805细胞有限拟时序。5921个表达合格基因全部完成graph_test，3294个q<.05。根支持在分区间不同；不能拼接分区时间。
- 共同数据SS得到AWA与ASG路径。主流程同细胞秩相关约−0.0108（AWA，471细胞）和0.7597（ASG，427细胞）。AWA晚期细胞多数映射MC根，终点匹配失败；不报告双方法共识。
- 不做MC批次/背景对齐的事后敏感性为0.6321/0.7424，显示预处理依赖；没有以更高相关替换主要结果。
- 共同数据300/300 NB-GAM收敛，298个共同有效关联检验基因中两检验交集263、Jaccard0.8976。这不是独立重复或轨迹真值。
- 条件GO示例：3515实际合格检验基因中2177有BP注释，196入选；948集合中22项FDR<.05。最前为化学感觉行为等注释；它不测行为、不提供程序方向、不证明PI机制。240/300预筛面板没有伪造全基因组GSEA。
- 官方弃用API、RDS不保存近邻索引、早期安装/ID/绘图错误均保留。已验证内存稀疏对象工作流，未验证BPCells磁盘对象迁移。精确全程峰值RAM未连续测量。

## 全部新增实际图件

| 方法 | 实际图名 | 解释入口 |
|---|---|---|
| tradeSeq | T01_official_trajectory：官方UMAP与配套轨迹 | [图件与8项解读](../methods/tradeSeq/figure_notes/T01_official_trajectory_CN.md) |
| tradeSeq | T02_expression_smoothers：Apoe表达平滑曲线 | [图件与8项解读](../methods/tradeSeq/figure_notes/T02_expression_smoothers_CN.md) |
| tradeSeq | T03_dynamic_gene_heatmap：动态基因平滑热图 | [图件与8项解读](../methods/tradeSeq/figure_notes/T03_dynamic_gene_heatmap_CN.md) |
| tradeSeq | T04_lineage_pattern_difference：Mpo分支拟合与描述差值 | [图件与8项解读](../methods/tradeSeq/figure_notes/T04_lineage_pattern_difference_CN.md) |
| tradeSeq | T05_test_summary：动态检验与数值敏感性汇总 | [图件与8项解读](../methods/tradeSeq/figure_notes/T05_test_summary_CN.md) |
| Monocle3 | M01_celltypes_principal_graph：细胞注释与主图 | [图件与8项解读](../methods/Monocle3/figure_notes/M01_celltypes_principal_graph_CN.md) |
| Monocle3 | M02_partitions：分区结构 | [图件与8项解读](../methods/Monocle3/figure_notes/M02_partitions_CN.md) |
| Monocle3 | M03_rooted_pseudotime：根锚定拟时序 | [图件与8项解读](../methods/Monocle3/figure_notes/M03_rooted_pseudotime_CN.md) |
| Monocle3 | M04_embryo_time：已有胚胎时间注释 | [图件与8项解读](../methods/Monocle3/figure_notes/M04_embryo_time_CN.md) |
| Monocle3 | M05_dynamic_gene_maps：图动态基因表达分布 | [图件与8项解读](../methods/Monocle3/figure_notes/M05_dynamic_gene_maps_CN.md) |
| Monocle3 | M06_gene_expression_pseudotime：局部AWA注释路径的表达-时间示例 | [图件与8项解读](../methods/Monocle3/figure_notes/M06_gene_expression_pseudotime_CN.md) |
| Slingshot_tradeSeq_Monocle3 | C01_independent_trajectory_comparison：独立轨迹结构对照 | [图件与8项解读](../combinations/Slingshot_tradeSeq_Monocle3/figure_notes/C01_independent_trajectory_comparison_CN.md) |
| Slingshot_tradeSeq_Monocle3 | C02_per_lineage_pseudotime：逐谱系同细胞时间对照 | [图件与8项解读](../combinations/Slingshot_tradeSeq_Monocle3/figure_notes/C02_per_lineage_pseudotime_CN.md) |
| Slingshot_tradeSeq_Monocle3 | C03_pseudotime_difference：相对拟时序差值 | [图件与8项解读](../combinations/Slingshot_tradeSeq_Monocle3/figure_notes/C03_pseudotime_difference_CN.md) |
| Slingshot_tradeSeq_Monocle3 | C04_tradeSeq_lineage_smoothers：ces-1谱系表达平滑 | [图件与8项解读](../combinations/Slingshot_tradeSeq_Monocle3/figure_notes/C04_tradeSeq_lineage_smoothers_CN.md) |
| Slingshot_tradeSeq_Monocle3 | C05_dynamic_gene_heatmap：共同数据动态热图 | [图件与8项解读](../combinations/Slingshot_tradeSeq_Monocle3/figure_notes/C05_dynamic_gene_heatmap_CN.md) |
| Slingshot_tradeSeq_Monocle3 | C06_joint_gene_test_comparison：共同基因的不同假设检验 | [图件与8项解读](../combinations/Slingshot_tradeSeq_Monocle3/figure_notes/C06_joint_gene_test_comparison_CN.md) |
| Slingshot_tradeSeq_Monocle3 | C07_GO_dynamic_programs：图动态基因GO生物过程富集 | [图件与8项解读](../combinations/Slingshot_tradeSeq_Monocle3/figure_notes/C07_GO_dynamic_programs_CN.md) |
| Slingshot_tradeSeq_Monocle3 | C08_no_alignment_sensitivity：不对齐的事后敏感性主图 | [图件与8项解读](../combinations/Slingshot_tradeSeq_Monocle3/figure_notes/C08_no_alignment_sensitivity_CN.md) |


## 复现、文件保护与发布状态

三模块经交付入口在全新R会话串行重跑成功，47张数值表hash完全一致；原Slingshot79文件hash完全一致。第一轮47原件继续保留。新图的三种格式全部验证；PNG联系表逐图查看，PDF/SVG实际渲染并抽查。

已完善中文导航、方法矩阵、图集、三个方法材料、组合冲突报告、PI动态程序设计、固定依赖/校验、相对链接和发布候选清单。PI State1/6/7仍只做ECM合成/降解/重塑、Integrin–FAK–YAP/TAZ、炎症/修复与内皮衔接的研究设计。

本地发布静态检查通过：554个相对Markdown链接无失效，README实际图片引用可用，14个新方法RDS被未来Git候选排除；418个候选文件中最大约7.59 MiB，无文件达到100 MiB。所列凭据模式扫描无匹配；这不替代历史私人路径与Private链接的人工公开范围审查。

远程操作继续等待授权；自写材料总许可、Private/Public及历史私人信息的公开范围待确定。见[发布前审查](GITHUB_PREPUBLICATION_CN.md)。本地交付不是已发布GitHub仓库，也不是可无条件公开的原始材料包。

## 下一阶段建议

优先审查共同数据的批次/时间混杂、MC终点覆盖和候选根，做受控表示/节点剪枝敏感性及独立方向验证；不继续调到相关最大。完成许可和公开范围决定后准备远程。随后再逐步扩展PAGA、CellRank、CytoTRACE2；真实PI运行需另定输入和范围。
