# 第四轮中文交付与独立验收（2026-10-21）

**本轮部分完成：PAGA与CytoTRACE2通过；CellRank安装通过，官方骨髓数据403导致INPUT/RUN/FIGURE阻塞。** 仓库保持Private，不以安装成功代替方法成功，不以不同数据的图件冒充组合验证。

## GitHub与授权

仓库：[stevenhuangfannk-creator/single-cell-trajectory-fate-toolkit](https://github.com/stevenhuangfannk-creator/single-cell-trajectory-fate-toolkit)，分支main。第三轮首发`99228954aa4872f97d6f844fae92396a31e94b91`，423文件，[首次回执](FIRST_PRIVATE_PUSH.json)。此前PAGA提交`8181f525fc8272a9d95d7a3c94616b821f95c88a`含476文件。当前提交自身SHA/数量在工作区outputs最终远程回执及聊天交付提供，避免自引用哈希循环。

按授权正常push，不强制推送，不转Public。自写材料统一许可证未选定，第三方权利分别保留。模型、环境、原始大对象、安装缓存和凭据不入Git。scTour、RegVelo及其他科研仓库不修改。

## 逐方法验收

| 方法 | INSTALL | INPUT | RUN | FIGURE | 中文教程 |
|---|---|---|---|---|---|
| PAGA | PASS，独立venv及局部运行库 | PASS，官方2730×3451 | PASS，记录改编 | PASS，4组12格式 | 完整指南+4图卡 |
| CytoTRACE2 | PASS，独立CPU环境 | PASS，当前官方2850×27998 | PASS，官方API，batch1000 | PASS，5组15格式 | 完整指南+5图卡 |
| CellRank | PASS，2.3.3导入及依赖检查 | BLOCKED，官方Figshare403 | BLOCKED，无输入未执行 | NOT_RUN，无占位 | 详细概念/执行设计；实际复现未验收 |

证据：[PAGA](../../methods/PAGA/STATUS.json)、[CytoTRACE2](../../methods/CytoTRACE2/STATUS.json)、[CellRank](../../methods/CellRank/STATUS.json)。累计34组科研图、102个PNG/PDF/SVG文件，本轮新增9组27文件；审图联系表不计入。

## PAGA实际结果

官方Paul15文件10297693字节，SHA256=`6161984f758dd464992edc23f1a8ab89b2081600130c6aa93a1ab12b3ada5bfb`。2730细胞、3451提供基因，预处理后999高变基因；19群、58条非零无向边，阈值0.03显示54边。边权不是p值、方向或命运概率。

| 图件 | 三格式与中文解读 |
|---|---|
| P01群连接拓扑 | [8项图卡](../../methods/PAGA/figure_notes/P01_population_topology_CN.md) |
| P02 PAGA初始化UMAP | [8项图卡](../../methods/PAGA/figure_notes/P02_PAGA_initialized_UMAP_CN.md) |
| P03 DPT拟时序 | [8项图卡](../../methods/PAGA/figure_notes/P03_DPT_pseudotime_CN.md) |
| P04造血标志表达 | [8项图卡](../../methods/PAGA/figure_notes/P04_marker_expression_CN.md) |

DPT有限2671、不可达59，后者保留非有限并标灰，不填0。根为官方默认索引840，W37022、8Mk，不宣称已验证干祖起点。使用提供群标签替代Louvain/手工命名、PAGA初始化UMAP替代ForceAtlas2，均在[指南](../../methods/PAGA/README_CN.md)记录。此次未重算此前已验收的PAGA。

## CytoTRACE2实际结果与资源

用户已确认非商业用途：[用途记录](CYTOTRACE2_USE_CONFIRMATION.json)、[许可审查](CYTOTRACE2_LICENSE_REVIEW_CN.md)。19模型合计156525236字节，仅本地使用；背景张量、模型与官方输入不上传。实际PyPI1.1.0.4模型下载函数与固定GitHub来源不同，[安装源hash和模型URL](../../methods/CytoTRACE2/results/installed_source_manifest.json)、[模型hash](../../methods/CytoTRACE2/results/model_manifest.json)分别登记。

官方Python教程写2280细胞，其当前确切链接表达和注释均为2850、ID完全匹配；完整保留2850×27998，不人为凑数。[输入校验](../../methods/CytoTRACE2/results/input_download_provenance.json)：表达160322553字节、注释126301字节。未取对数、非负整数，精确特征覆盖14247/14271（别名映射前）；覆盖率不是性能保证。

单批2850尝试触发资源保护：进程树采样约5.05GiB、最低可用约349MiB，日志保留，无可交付预测。改用官方batch_size=1000，官方实现等分3批各950，种子14，覆盖全部细胞，未改官方源码。官方平滑即使单核仍启动单worker；自写Windows入口加main保护，避免子进程重复执行。分批会影响邻域，不宣称等价于完整单批。

成功退出码0，推断约147秒。每秒采样进程树峰值3500818432字节（3.26GiB），最低可用2636660736字节（2.46GiB）；采样不是连续精确峰值。真实记录见[logs](../../methods/CytoTRACE2/logs)。预测与绘图分开，新机器重装尚未独立复测。

分数0.004143–0.646064；已分化1673、单能299、寡能426、多能452，Pluripotent/Totipotent均0。全局与总计数rho=0.2752、检测基因rho=0.1341、线粒体比例rho=0.0865；表型内相关及描述性BH FDR全部保存。平滑前后rho=0.9631。检查相关不能宣布混杂消除，预测潜能不证明真实去分化或炎症可塑性。

| 实际图件 | 三格式与中文解读 |
|---|---|
| CT01表型/潜能UMAP | [8项图卡](../../methods/CytoTRACE2/figure_notes/CT01_potency_UMAP_CN.md) |
| CT02六类与计数 | [8项图卡](../../methods/CytoTRACE2/figure_notes/CT02_potency_categories_CN.md) |
| CT03表型内小提琴 | [8项图卡](../../methods/CytoTRACE2/figure_notes/CT03_phenotype_violin_CN.md) |
| CT04深度/基因数混杂 | [8项图卡](../../methods/CytoTRACE2/figure_notes/CT04_technical_confounding_CN.md) |
| CT05平滑前后对照 | [8项图卡](../../methods/CytoTRACE2/figure_notes/CT05_smoothing_comparison_CN.md) |

五组均本地生成，PNG目视、PDF渲染、SVG实际栅格化检查通过。[完整指南](../../methods/CytoTRACE2/README_CN.md)包含尺度、Seurat/AnnData、参数、运行、科学解释、错误处理及PI设计。独立轻量UMAP仅展示，不参与官方模型，不宣称逐像素复刻官方图。

内分泌祖细胞内部与总计数、检测基因数rho均约0.524，部分群内技术关联强于全局，已在图卡和指南突出，不能用全局弱相关宣布技术影响很小。

最终完整入口00→01→02→03另行运行成功，2850细胞的分数、类别及QC数值与先前恢复预测一致：[复现检查](../../methods/CytoTRACE2/logs/REPRODUCIBILITY_CHECK.json)。每细胞CSV有浮点文本表示差异，未宣称字节hash相同。最终日志run_20261021_051649.log，采样峰值3591692288字节（约3.34GiB），最低可用2308177920字节（约2.15GiB），无资源中止；上方3.26GiB为首次成功运行记录。

## CellRank：阻塞与恢复条件

独立Python3.12安装CellRank2.3.3、Scanpy1.12.4，成功导入并通过pip check；未安装scVelo/PETSc/SLEPc/GPU扩展。已阅读官方GitHub源码、骨髓PseudotimeKernel notebook和宏状态/命运教程，保存hash；未运行velocity。

官方datasets.py指定骨髓5780×27876、文件35826944，含预计算Palantir拟时序。官方文件下载器、Figshare API和网页访问均403；文档站也403，资料阅读改用官方GitHub notebook。实际入口已执行并退出：[输入证据](../../methods/CellRank/results/input_provenance.json)。没有取得完整文件、bytes或SHA256，不捏造校验；预设上限512MiB，大小无法核查时停止。

没有核矩阵、宏状态、终末概率或相关基因结果，没有命运UMAP。[详细中文教学及执行设计](../../methods/CellRank/README_CN.md)提供原理、预定图形阅读、假设、PI及恢复方案，实际复现教程未通过。软件安装不是方法成功。

下一阶段先恢复官方文件可访问性，取得大小/许可/校验并核实X尺度、根来源，再实现非velocity预处理、PseudotimeKernel、GPCCA、终末选择、吸收概率与基因关联。不能把另一数据的VelocityKernel嫁接进来；不使用未知镜像绕过来源要求。

## 组合、PI与科学边界

本轮分别使用鼠造血、鼠胰腺和未取得的人骨髓，不能逐细胞拼接/相关或投票建立共识。[比较范围](COMPARISON_SCOPE_CN.md)给出未来同数据契约。第三轮同650细胞组合独立验收，**AWA终点匹配FAIL、排序冲突和预处理敏感性不变，轨迹共识未建立**。

[PI设计](../../case_studies/PI_Fibroblast_State_Reprogramming/ROUND4_METHOD_DESIGN_CN.md)覆盖State1/6/7、供者、ECM合成/降解/重塑、Integrin–FAK–YAP/TAZ、炎症修复及内皮衔接。动态基因/功能富集支持轨迹条件表达关联；潜能及命运概率需独立功能验证。本轮没有读取真实PI。方向缺失、终点冲突或深度/供者主导时STOP，PIVOT到供者层状态程序比较。

第三轮275个保护文件提交前逐字节复核；259个跟踪原文件与Git原内容相同，其他忽略RDS保留本地。相对链接、敏感模式、大小和排除规则见[FINAL_CHECKS](FINAL_CHECKS.json)；[Git发布清单](GIT_PUBLICATION_MANIFEST.csv)以规范化Git索引字节生成，与SHA256SUMS自身互相排除，避免循环。

完整第四轮尚不能宣布全部PASS；CellRank必须在后续补齐实际计算和图件后独立验收。
