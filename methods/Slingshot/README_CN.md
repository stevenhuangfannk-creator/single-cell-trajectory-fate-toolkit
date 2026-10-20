# Slingshot 中文使用指南：从状态结构到谱系内拟时序

本页对应本机实际执行的 **slingshot 2.20.0 / Bioconductor 3.23 / R 4.6.1**，2026-10-19。官方140点模拟例已运行成功；本项目新增6组真实图件，每组有 PNG/PDF/SVG。安装、输入、运行与图件检查见 [STATUS.json](STATUS.json)，原始日志见 [logs](logs/)。这证明教学小例可复现，不证明 PI 细胞存在某条真实转化路线。

## 1. 方法在解决什么问题

单细胞测序通常把不同细胞分别测量一次。若一组细胞来自相对连续的生物过程，我们希望研究它们是否形成一条或多条状态路径，以及每条路径内部的相对先后顺序。

Slingshot 先连接细胞群，再在细胞分布上拟合平滑曲线。谱系（lineage）在本方法中是从起始群到末端群的一条路径，并非通过遗传标记观察到的真实祖先后代。拟时序（pseudotime）是细胞投影到曲线后的弧长位置，不是小时、天数、年龄或实测分化速度。

最小生成树（minimum spanning tree，MST）以聚类为节点构造连接骨架，距离计算会考虑群内结构；不能简单理解为只把二维图上最近的几个点用线连起来。主曲线（principal curve）是穿过细胞分布的平滑曲线。同时主曲线（simultaneous principal curves）允许不同谱系在早期共享部分结构，再逐渐分离。

曲线归属权重（curve assignment weight）表示拟合过程中细胞对各曲线的归属/贡献。默认输出不要求每个细胞的多谱系权重和为1。它不同于进入各终末状态的命运概率（fate probability），也不是细胞已经分化成某状态的置信度。

适用问题：同一细胞谱系的状态是否连续？是否有树样分支？在有依据的起点下，哪些细胞相对靠前或靠后？哪些基因随后可用于动态表达分析？

不宜直接使用的情形：互不相关细胞类型混在一起；中间状态几乎没有采到；批次制造了连接；预期过程以循环或汇聚为主却强制拟合成树；只想比较 PI/Healthy 差异但没有连续谱系依据。静态表达相似性本身不提供可靠方向。

## 2. 论文、实现与教程

- 论文：Street 等，*Slingshot: cell lineage and pseudotime inference for single-cell transcriptomics*，BMC Genomics，2018；[DOI 10.1186/s12864-018-4772-0](https://doi.org/10.1186/s12864-018-4772-0)。
- [作者官方 GitHub](https://github.com/kstreet13/slingshot)。
- [本次版本对应的官方教程](https://bioconductor.org/packages/3.23/bioc/vignettes/slingshot/inst/doc/vignette.html)；[官方教程 R 代码](https://bioconductor.org/packages/3.23/bioc/vignettes/slingshot/inst/doc/vignette.R)。
- [Bioconductor 3.23 包页](https://bioconductor.org/packages/3.23/bioc/html/slingshot.html)；软件 DOI [10.18129/B9.bioc.slingshot](https://doi.org/10.18129/B9.bioc.slingshot)，与原论文 DOI 不同。
- 第一轮来源记录保留在 [SOURCE_CARD.md](SOURCE_CARD.md) 与 [source.json](source.json)。其中 NOT_TESTED 是第一轮的历史状态；本轮运行状态独立保存，不改写历史。

本次代码为 **ADAPTED_FROM_OFFICIAL**：数据加载参考 `data_sling`，谱系推断参考 `sling_lines_unsup`，主曲线参考 `curves`。保留官方 `start.clus='1'`，不约束终点。新增唯一行号ID、输入验证、统计导出、分阶段保存、白底配色和三格式绘图。未执行整篇官方教程（vignette） 中的300细胞表达模拟、高斯混合模型（Gaussian mixture model，GMM）、tradeSeq、omega 和预测新细胞等扩展示例，不能称为整篇教程或原论文全部复现。

代码及随包示例依据官方包的 Artistic-2.0 许可保留来源。见 [第三方说明](../../THIRD_PARTY_NOTICES.md)。本页和本项目编辑脚本不是作者原教程的官方中文版。

## 3. 输入数据与准备

最小输入是细胞×维度的数值矩阵，以及严格按同一行顺序排列的聚类标签。这里的低维空间可以是经核查的主成分分析（principal component analysis，PCA）空间；统一流形近似与投影（Uniform Manifold Approximation and Projection，UMAP）常用于展示，但它的二维距离不一定适合拟合。拟合空间与展示空间须分别记录。

### 官方小例

`slingshotExample` 是包内官方模拟数据。本次 `rd` 为140×2，`cl` 为140个群标签，5群大小分别为36、36、24、22、22。官方数据帮助说明这些群标签由K=5的k均值聚类（k-means）产生；本次不重新聚类。它没有表达计数、供者、患者、真实时间或真实谱系追踪信息。坐标不能称为 UMAP。

[example_data/slingshotExample.rda](example_data/slingshotExample.rda) 是安装包内原文件的原样副本，3,190 bytes；[输入坐标表](results/input_coordinates.tsv) 是本项目导出并增加本地行号ID的表。原文件与下载包的 SHA-256、来源和许可说明在 [输入登记](../../data_registry/Slingshot_example.json)。算法脚本默认使用安装包原例，不依赖私有路径。

### Seurat 数据准备示意（不在本次模拟例执行）

Seurat 是常用的 R 单细胞分析对象。下列代码只说明接口，不会在本轮读取真实数据。

```r
# 先用自己的已确认对象替换obj；不要在这里重新聚类或改变注释。
rd <- SeuratObject::Embeddings(obj, reduction = 'pca')[, 1:20, drop = FALSE]
meta <- obj[[]]
stopifnot(!anyDuplicated(rownames(rd)), !anyDuplicated(rownames(meta)))
stopifnot(setequal(rownames(rd), rownames(meta)))
meta <- meta[match(rownames(rd), rownames(meta)), , drop = FALSE]
stopifnot(identical(rownames(rd), rownames(meta)))
cl <- meta$confirmed_fibroblast_state
stopifnot(length(cl) == nrow(rd), !anyNA(cl), all(is.finite(rd)))
```

20维只是接口示意，真实应用要预登记维数及敏感性范围。本方法可只使用低维空间，不必为它重复提取整份表达矩阵。若后续接 tradeSeq，另从正确 assay/layer 获取原始计数；Seurat 版本、合并层和轴顺序另查，不把整合矩阵当计数。

### AnnData 数据准备示意（不在本次模拟例执行）

AnnData 是 Python 中常用的带注释单细胞矩阵结构。导出已有 PCA 与元数据即可；本例不要求安装 Python。

```python
# adata是已确认对象。CSV/TSV索引必须保留，R端显式按ID重排。
import pandas as pd
assert adata.obs_names.is_unique
embedding = pd.DataFrame(adata.obsm['X_pca'], index=adata.obs_names)
embedding.index.name = 'cell_id'
embedding.to_csv('pca.tsv', sep='\t')
metadata = adata.obs[['confirmed_fibroblast_state', 'sample_id', 'donor_id']].copy()
metadata.index.name = 'cell_id'
metadata.to_csv('cells.tsv', sep='\t')
```

不要把任意 AnnData 的 `.X`、`.raw.X` 自动当作原始计数；它们可能是归一化、对数或整合尺度。输入转换先检查ID集合和顺序，再检查数值。不能静默截取共同细胞或重命名barcode后继续。

## 4. 环境与运行顺序

本次独立 R 与包库留在项目外的 `work/runtime/`，不随交付 ZIP 携带，不修改原 scTour/RegVelo 环境。仅安装31个非基础包，包括运行时实际需要的 `DelayedMatrixStats`；没有为了官方教程的其他段落安装所有 Suggests 可选依赖。实际锁见 [R-installed-packages.csv](../../environments/R-installed-packages.csv)，下载 URL/版本/校验见 [download_manifest.csv](../../environments/download_manifest.csv)。

[安装与运行说明](../../environments/README_CN.md) 给出 Windows 配置和独立安装入口。禁止直接在原科研包库内执行全局更新。首次运行先在 VS Code 选择该独立 R 解释器，工作目录设为项目根目录；VS Code R Interactive 指 R 交互窗口，可按选中代码逐段运行。

```r
# 如果移动了项目或使用自己的包库，先明确设置；路径请填写实际位置。
options(toolkit.root = getwd())
# options(toolkit.library = '你的独立包库绝对路径')
source('00_Start.R', encoding = 'UTF-8')
source('methods/Slingshot/scripts/01_Load_and_Check.R', encoding = 'UTF-8')
source('methods/Slingshot/scripts/02_Infer_Lineages_and_Curves.R', encoding = 'UTF-8')
source('methods/Slingshot/scripts/03_Plot_and_Export.R', encoding = 'UTF-8')
```

如需调整额外拟合参数，应先在00集中新增参数，再显式传给02，并另存本次配置。本例保留上述官方默认。

完整命令行执行：`Rscript --vanilla methods/Slingshot/scripts/run_example.R`。仅重绘时，在全新会话执行 `Rscript --vanilla methods/Slingshot/scripts/replot_saved_fit.R`。后者已实测退出码0，拟合对象 hash 不变，不再次拟合。

01读取一次小例，02在内存中使用同一数据并保存小对象，03优先使用内存或保存对象。数据不因改字体、颜色或图尺寸重新读取、过滤或训练。VS Code 可先选中执行绘图函数预览，再调用导出；已实测的是 Rscript 批处理，尚未在用户的 VS Code 交互窗口逐段验收。

## 5. 参数怎么理解

参数入口在 [00_Start.R](../../00_Start.R)，拟合代码在 [02脚本](scripts/02_Infer_Lineages_and_Curves.R)，本次实际默认值在 [fit_parameters.txt](logs/fit_parameters.txt)。

| 参数 | 本次设置 / 实际默认 | 作用与注意事项 |
|---|---|---|
| `seed` | 20261019 | 固定随机性来源，不用反复换种子挑图；本例主要拟合步骤为确定性计算 |
| `start.clus` | `'1'`，官方例指定 | 给路径定向，不是算法证明群1最早；真实数据需独立依据 |
| `end.clus` | 未指定；推断末端5和4 | 不能为了让某个 PI State 看似终点而强制设置 |
| `omega` | FALSE | 控制可能断开的谱系结构；本次不改该默认，不强制连接真实不相关谱系 |
| `shrink` | TRUE | 让共享区域的曲线相互收缩，提高早期结构一致性 |
| `reweight` / `reassign` | TRUE / TRUE | 迭代更新细胞权重和归属；权重不是概率守恒量 |
| `thresh` / `maxit` | 0.001 / 15 | 迭代停止条件和上限；不是生物学可靠性阈值 |
| `extend` / `stretch` | y / 2 | 控制曲线端点延伸方式与幅度；保留官方默认，不据此推断真实动态 |
| `shrink.method` / `allow.breaks` | cosine / TRUE | 共享区收缩方式与允许不同起始段的几何规则，不是命运分支的实验证据 |
| `smoother` | smooth.spline | 平滑样条；其拟合平滑度不能解释为细胞真实速度 |
| `width` / `height` / `dpi` | 7.2 / 5.5英寸 / 220 | 只改变导出尺寸与PNG分辨率；PDF/SVG保留矢量内容 |
| 群颜色、缺失颜色、字体 | 集中配置 | 不改变细胞、标签、坐标或模型；缺失拟时序显示灰色，不补0 |

拟时序起点为0是距离坐标的约定，不说明该细胞生理年龄为0。不同谱系或不同方法的时间量纲不同，不直接平均、不据最大值比较分化速度。

## 6. 本次实际结果

本次完整运行记录 [04_execution_record.json](logs/04_execution_record.json) 的退出码为0，用时约5.3秒，100毫秒采样得到的峰值进程工作集约721 MiB；其中拟合约0.37秒。工作集不是严格峰值内存承诺，加载依赖和绘图开销包含在完整运行中。

| 谱系 | 聚类路径 | 有效拟时序 | 缺失拟时序 | 拟时序范围 | 权重范围 |
|---|---|---:|---:|---|---|
| Lineage1 | 1 → 2 → 3 → 5 | 107 | 33 | 0–15.045364 | 0–1 |
| Lineage2 | 1 → 2 → 3 → 4 | 108 | 32 | 0–15.126327 | 0–1 |

75个细胞同时在两条谱系上有有限拟时序；没有细胞在两条谱系上均缺失。32个细胞在两条曲线上权重都等于1，行和最大为2。这是默认曲线归属权重的性质，不应强制改成和为1后冒充命运概率。缺失拟时序是该条谱系中无有效归属，不表示零表达、死亡或质量差。

结果文件：`input_coordinates.tsv` 为实际输入；`cluster_sizes.tsv` 为群大小；`lineages.tsv` 为路径；`pseudotime.tsv` 为细胞×谱系时间；`curve_weights.tsv` 为同轴权重；`lineage_summary.tsv` 为上述统计；`checked_input.rds` 与 `slingshot_fit.rds` 为阶段恢复对象。不要依赖 RDS 在不同 R/包版本下永远兼容；可检查的小表与实际环境一起保留。

## 7. 图件怎样读

全部为本次脚本真实生成，未使用官方截图。完整可点击列表见 [Figure Gallery](../../gallery/README.md)，逐图文档见 [figure_notes](figure_notes/)。

- **S01 聚类MST**：点为模拟细胞、颜色为5群，黑色连接为群级骨架；回答连接结构，不给细胞命运概率。
- **S02 同时主曲线**：黑线为平滑谱系，显示共享前段和两条分支；曲线不是细胞曾经运动的路径。
- **S03 两条谱系拟时序图**：紫色靠前、黄色靠后，灰点在当前谱系中无有效拟时序；每个面板只解释对应谱系。
- **S04 两条谱系权重图**：灰色低权重、蓝色高权重；早期共享区可同时高权重，不是两种互斥命运。

所有坐标轴都标“Simulated dimension”，不是时间，也不是UMAP。三格式来自同一绘图函数；PDF已逐文件打开并栅格化，PNG与PDF版面已检查，SVG已解析并确认为矢量路径、无嵌入截图。SVG的浏览器字体渲染可能略有区别。

## 8. 能得到什么科学结论

本例支持：代码接口正确衔接；在这组官方模拟坐标及指定起点下，模型给出共享前段和两个末端的结构；细胞可按每条谱系分别排序。

本例不能支持：PI State 1/6/7 的转化顺序；疾病导致去分化；某基因是驱动因素；曲线末端是真实终末细胞；拟时序差异代表真实时间差。即使真实 PI 数据上重复观察到类似树，也需要供者重复、标志物、空间/纵向证据及适当实验验证。

## 9. 真实遇到的错误与解决

| 问题 | 本次证据与处理 | 复核 |
|---|---|---|
| `C.UTF-8` 在 Windows 设置失败，中文源码读取失败 | [01失败日志](logs/01_run_stderr.log)；仅为新进程设置Windows可接受UTF-8 locale | 中文脚本正常读取，最终无该启动错误；不改系统语言 |
| 缺少 `DelayedMatrixStats` | [02失败日志](logs/02_run_stderr.log)；必需依赖元数据未覆盖实际调用，显式补充该包及 sparseMatrixStats | 最终推断与曲线拟合成功；不安装全部Suggests |
| 分析结束后退出码 `-1073741819` | 从igraph追到间接依赖cli；包单独加载探针和cli源码检查发现Windows架构变量缺失 | 核实x64后在进程内补 `AMD64`，cli及完整小例退出码0；没有降级包、屏蔽异常或强制退出 |
| 图下方副标题空间不足 | 初次视觉检查发现，增加底边距；权重色标改为更清楚的灰→蓝 | 全新会话只重绘，模型hash不变，重新检查图件 |

先前失败日志均保留，最终通过不是删除失败后的选择性报告。退出码检查与图件检查分别做，不能只因文件存在就写 RUN_OK。

其他常见问题：标签长度不一致应检查ID而非截断；NA/Inf坐标应定位上游；新群颜色缺失在00补配色；曲线跨越空白可能来自缺少中间状态、过度降维或聚类，应检查输入与敏感性，不手动画弯曲线。若出现新的包API错误，先核对本页版本锁，不全局升级/降级原科研环境。

## 10. 与其他方法比较和组合

与 Monocle3 比，Slingshot 以已有低维空间和聚类为主要起点，不负责完整的基因筛选/降维/分区流程；两者的树、主图、距离和分支定义不同。PAGA 描述群级图连接，不直接提供相同的曲线权重。scTour 学习的动态时间也不同于曲线弧长。

推荐 [A模块](../../combinations/A_Trajectory_Consensus/README_CN.md) 比较结构和谱系内排序；[B模块](../../combinations/B_Dynamic_Gene_Programs/README_CN.md) 将原始计数、同轴时间与权重交给 tradeSeq。官方140点坐标例不能用于动态基因；必须使用有真实计数的官方表达小例或另行准备的数据。CellRank 与 Palantir 可用于终末模型，但不能将这里的曲线权重改名为其命运概率。

## 11. PI Fibroblast 预设应用

以已确认的成纤维细胞集合和 State 1/6/7 注释开始，先检查供者分布、批次和邻域覆盖，不指定1→6→7。选择拟合空间、聚类层级和候选根的独立依据，记录范围及敏感性；按同一细胞ID展示路径与缺失，不为连成树删除细胞。

在结构稳定后才研究细胞外基质（extracellular matrix，ECM）合成/降解/重塑和炎症/修复程序，并检查整合素–FAK–YAP/TAZ相关靶程序。表达趋势只产生机械转导假说，不直接证明激酶活化或YAP核定位。按供者展示，细胞数不能充当生物重复数。

STOP：无可靠起点、批次主导、谱系混杂、关键中间区缺失或方法方向冲突。PIVOT：保留无方向状态结构与程序描述，明确证据不足。具体输入、论文图件和外部验证设计见 [PI专题](../../case_studies/PI_Fibroblast_State_Reprogramming/README_CN.md)。本轮未运行真实 PI 数据。
