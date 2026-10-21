# CytoTRACE2：预测分化潜能的中文使用指南

本例仅作已确认的非商业科研教学用途。实际状态、数值和图件以[STATUS](STATUS.json)、[运行总结](results/run_summary.json)和[真实日志](logs)为准；这里的“潜能”是模型预测，不能替代谱系追踪或功能实验。

## 1. 方法、来源与问题

CytoTRACE2（细胞转录组分化潜能预测第二版）利用预先训练的基因集二值网络（gene set binary network，GSBN）集成，从表达程序推断细胞的发育潜能。官方模型结合表达排序和表达量特征，再进行扩散与自适应近邻平滑。本例是应用19个官方权重的推断（inference），没有训练新模型。高分表示与模型所学高潜能程序更相似，不表示已观察到更多后代。

- 原文：Kang等，*Improved reconstruction of single-cell developmental potential with CytoTRACE 2*，[DOI 10.1038/s41592-025-02857-2](https://doi.org/10.1038/s41592-025-02857-2)。
- [官方GitHub](https://github.com/digitalcytometry/cytotrace2)、[Python教程](https://github.com/digitalcytometry/cytotrace2/tree/main/cytotrace2_python)、[Stanford网站](https://cytotrace2.stanford.edu/)、[PyPI](https://pypi.org/project/cytotrace2-py/1.1.0.4/)。
- 第一轮固定来源与版本见[source.json](source.json)。实际安装为PyPI 1.1.0.4；其模型下载函数与登记的GitHub提交不同，不声称源码相同。实际源文件、模型和输入均另外登记SHA256。
- [Stanford许可审查与本轮非商业确认](../../docs/round4/CYTOTRACE2_LICENSE_REVIEW_CN.md)。Private仓库不消除再分发限制：本仓库不包含官方源码、模型或表达文件；自写脚本和派生结果保留来源及使用限制。

适合的问题：已定义谱系内哪些细胞具有较高的预测潜能？分数与分化标志、拟时序是否协调？供者间分数变化是否仍能排除深度混杂？不适合：直接证明去分化、炎症可塑性、干细胞功能或肿瘤起源；替代轨迹分支、命运概率或实验时间。

## 2. 输入、尺度和数据准备

官方小例是小鼠胰腺10x表达及注释，来源链接与校验在[输入来源](results/input_download_provenance.json)。教程文字写2280细胞，但本次链接实际得到**2850细胞×27998基因**，表达和注释ID完全匹配，未抽样凑成2280。文件约153MiB；本下载器单文件上限256MiB。输入是基因×细胞的制表符文本，第一列基因符号、第一行细胞ID。此次值非负整数、最大2312，符合未取对数计数的形式；整数外观本身不能证明没有上游处理。

官方接受原计数或未取对数的CPM/TPM；禁止输入已经log、scale、插补或批次整合的表达。CPM指每百万计数，TPM指每百万转录本。人类与小鼠必须明确指定；不能只改大小写代替物种转换。重复符号应在原计数层有依据地汇总，不能简单保留任意一行。不要只导出高变基因给模型。

Seurat准备：使用RNA assay的counts层，Seurat v5先明确每个layer对应样本；禁止使用integrated或scale.data。AnnData（带注释的数据矩阵）准备：确认`layers['counts']`确为原计数，细胞×基因矩阵转置后再导出；`.raw`这个名字不保证原计数。另保存供者、批次、状态和物种信息，ID顺序由显式匹配确定。大样本应评估文本密集化成本，不能直接把全矩阵转成DataFrame后才检查内存。

本例全部细胞检测基因1383–7154，总计数3625–62867。与14271个模型特征在别名转换前精确重叠14247个。覆盖率不是性能保证。模型官方映射会进一步处理符号，不能把这个前置数当作最终有效特征数。

## 3. 环境、运行与参数

完整安装步骤、包锁和安装证据见[独立环境](../../environments/round4/CytoTRACE2/README_CN.md)。本机Python3.12、NumPy1.26、CPU PyTorch2.5.1；与PAGA/CellRank及scTour/RegVelo隔离。首次模型下载约157MB未压缩，模型不入库。若官方权重无法获得，停止预测，不用随机权重或第三方镜像替代。

在仓库根目录，用自己的独立环境Python路径替换下面的`$ctPython`；VS Code选该解释器，可以按编号脚本分段执行。统一入口为Python的[00_Start.py](scripts/00_Start.py)，沿用既有R方法的00入口习惯但不混用R环境。

```powershell
$ctPython = '你的独立环境/Scripts/python.exe'
& $ctPython -X utf8 methods/CytoTRACE2/scripts/download_official.py
& $ctPython -X utf8 round4/run_with_monitor.py CytoTRACE2
# 已有输入审计及嵌入时，仅恢复预测；必须是相同输入及配置
& $ctPython -X utf8 round4/run_with_monitor.py CytoTRACE2 --predict-only
# 只重绘，不再读取大矩阵、加载模型
& $ctPython -X utf8 methods/CytoTRACE2/scripts/run_example.py --replot
```

运行顺序：00集中配置→01分块检查表达、构建展示嵌入→02官方API预测与统计→03读取小型表绘图。第一次失败日志也保留。`--predict-only`复用本次已保存的输入审计和坐标；更换数据时必须重新运行01。

| 参数 | 本例值 | 为什么及边界 |
|---|---|---|
| species | mouse | 与官方胰腺输入物种一致 |
| seed | 14 | 固定随机数；不保证跨平台位级相同 |
| batch_size | 1000 | 全部2850细胞按官方实现等分成3批各950；完整单批触发资源保护，分批会影响平滑 |
| smooth_batch_size | 1000 | 官方默认平滑子批；不同值可能改变结果 |
| disable_parallelization / max_cores | True / 1 | 单线程CPU，禁止并行训练 |
| disable_plotting | True | 模型与绘图分开，独立展示坐标不参与模型 |
| embedding_hvg / pcs / neighbors | 2000 / 50 / 15 | 仅决定展示坐标，不能作为潜能模型输入 |

UMAP指统一流形近似与投影；HVG指高变基因；PCA指主成分分析。展示流程为基因至少3细胞表达→每细胞总量归一化1万→log1p→2000高变基因→缩放截断10→PCA50→15近邻→UMAP，种子14。模型仍读取**原始官方文本**。因此这里复现官方预测API并另作可审查的轻量绘图，不宣称逐像素复刻官方全基因UMAP。

首次单批2850运行触发了内存保护，日志保留；当前采用官方支持的分批参数，不抽样删除细胞。官方单worker进程池需要Windows主入口保护，已在自写入口补齐。资源监控每秒记录进程树驻留内存（RSS）和系统可用内存，超过5GiB或连续10次低于600MiB时中止。采样峰值不是连续真实峰值；运行前应关闭无关大型软件。无需GPU。

## 4. 输出、统计和逐图阅读

最主要表是[每细胞结果](results/potency_cell_statistics.csv)：细胞ID、官方表型、QC、UMAP、最终分数、类别、相对分数及preKNN结果。`CytoTRACE2_Score`在0–1；`CytoTRACE2_Relative`是本数据最小最大缩放，不能跨数据直接比较。`preKNN`是自适应近邻平滑前的结果，已经包含此前处理，不能称完全原始网络输出。最终六类按0–1六等分阈值划分：Differentiated已分化、Unipotent单能、Oligopotent寡能、Multipotent多能、Pluripotent多潜能、Totipotent全能；中文名称相近时应同时核对英文标签。模型赋予的“全能”等标签不是功能实验鉴定。

| 图件 | 主要问题与学习入口 |
|---|---|
| CT01潜能UMAP | 表型结构与模型分数如何对应？[逐图解读](figure_notes/CT01_potency_UMAP_CN.md) |
| CT02类别与数量 | 六类预测如何分布，是否出现极高潜能？[逐图解读](figure_notes/CT02_potency_categories_CN.md) |
| CT03表型小提琴 | 同类细胞内分数离散程度如何？[逐图解读](figure_notes/CT03_phenotype_violin_CN.md) |
| CT04技术混杂 | 分数与计数、检测基因数是否相关？[逐图解读](figure_notes/CT04_technical_confounding_CN.md) |
| CT05平滑前后 | 邻域平滑对局部结果影响多大？[逐图解读](figure_notes/CT05_smoothing_comparison_CN.md) |

每组均有本地实际PNG/PDF/SVG，不使用官方截图。摘要见[表型统计](results/phenotype_score_summary.csv)、[类别计数](results/potency_category_counts.csv)、[QC相关](results/QC_correlations.csv)。Spearman是秩相关，BH FDR是Benjamini–Hochberg多重检验校正后的错误发现率控制指标。这里将所有全局/表型内QC检验一起校正，仅供描述；细胞不是独立生物学重复，极小p值不能充当供者层疾病效应证据。

本次实际分数0.0041–0.6461；1673已分化、299单能、426寡能、452多能，Pluripotent与Totipotent均为0。全局分数与总计数rho=0.275、检测基因数rho=0.134；平滑前后rho=0.963。相关检查不能宣布混杂消除。成功推断约147秒，进程树采样峰值约3.26GiB、最低可用内存约2.46GiB；图件5组15格式经PNG目视、PDF渲染和SVG实际栅格化检查。

## 5. 可以解释什么，不能证明什么

可以描述这批官方细胞在固定版本、物种、基因覆盖和后处理下的预测分数分布；可以发现分数与成熟注释或技术量的关系。深度与基因数往往也随细胞类型变化，因此全局相关可能由组成驱动，应同时看表型内相关。不能仅用一次相关校正宣布混杂消除；后续需要深度匹配/下采样敏感性、供者重复和独立标志验证。

潜能不是拟时序，拟时序反向也不是潜能；不应为了高相关而选根。分数不是终末命运概率，六类不是六条谱系；邻居平滑可增强连续外观，不能据此声称真实状态转化。跨数据“绝对空间”是方法目标，仍受测序平台、覆盖和训练域影响。

本例内分泌祖细胞中，潜能与总计数、检测基因数的rho均约0.524，比全局n_genes的0.134更强。不能把较小的全局相关用作“深度影响很小”的结论；后续应用须优先做群内、供者内的深度匹配与敏感性分析。

## 6. 与已有方法组合

与Slingshot/Monocle3：先独立确定结构与起点，按细胞ID合并分数；分谱系、分供者看潜能与时间的关系，保留不一致。与scTour是六组合C的待验证设计，当前不重训scTour。与PAGA比较群体潜能中位数时必须给出分布和群内混杂，不能给连接边添加未经验证的方向。与CellRank区分“可产生多少类型的潜能”和“给定终末集合的吸收概率”；两者高相关也不构成独立验证。此小例与其他方法各自官方小例不自动构成同数据组合。

## 7. PI Fibroblast预设应用

仅研究设计，未读取真实PI。限定可信成纤维细胞谱系后，把State1/6/7保留为状态标签，先核查供者、PI/Healthy组成、计数、检测基因、细胞周期和应激。先定义ECM合成（如COL1A1/COL1A2）、降解（MMP相关）、重塑（FN1/LOX等）以及Integrin–FAK–YAP/TAZ机械转导程序，再按供者汇总潜能与程序关系；CTGF/CYR61等单个响应基因不是YAP核定位测定。

预设图为每供者状态分布、潜能—动态程序曲线、深度匹配敏感性及独立轨迹对照。程序随潜能变化只支持相关假设；炎症高表达或ECM激活不能改称去分化。若效应被供者/深度主导、基因覆盖差或状态不连续，STOP：停止潜能生物学排序，PIVOT到供者层表达程序比较。后续内皮互作仍需空间/共培养或受体配体证据，不能从潜能分数推断微环境因果。详见[PI专题](../../case_studies/PI_Fibroblast_State_Reprogramming/ROUND4_METHOD_DESIGN_CN.md)。

## 8. 常见问题与排查

- `pkg_resources`缺失：使用本例锁定setuptools<81的独立环境，不升级旧研究环境。
- 模型目录为空：PyPI小包首次下载19权重属正常步骤；下载失败停止，核对来源和文件hash。
- 缺`MSVCP140.dll`：本机仅在新venv中使用已有可追溯运行库及进程内DLL搜索目录，不复制到系统目录、不修改第三方源码。
- 细胞数与教程文字不符：以实际文件及ID审计为准，记录版本差异，不删细胞凑数。
- 物种警告、重复ID、非有限值或log尺度：回到输入准备，不靠关闭警告解决。
- 分数与n_genes高度相关：查看表型内与供者内结果，检查深度，不直接回归后宣布得到纯潜能。
- Windows的官方`mkdir -p`可能给出命令提示：本脚本预建推断目录；预测成功必须以返回值、结果文件和退出码共同验收。
- 资源阈值中止：保留日志、释放其他应用内存；若仍不足，记录BLOCKED并重新评估官方数据规模，不能静默改变模型或抽样再称完整复现。

验收范围是本机官方小例的实际预测和本仓库派生图件；全新机器重装、PI功能验证、跨方法共识均不在本次PASS含义内。

最终完整统一入口重复运行通过：[数值复现记录](logs/REPRODUCIBILITY_CHECK.json)。2850细胞的预测、类别和QC数值一致；每细胞CSV浮点格式存在字节差异，不宣称hash相同。最终完整运行进程树采样峰值约3.34GiB、最低可用约2.15GiB；前述3.26GiB是首次成功恢复预测运行的记录。
