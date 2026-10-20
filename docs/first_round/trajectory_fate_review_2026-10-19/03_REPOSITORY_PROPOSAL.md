# 仓库结构建议 / Repository proposal

日期：2026-10-19。状态：**REVIEW_ONLY / PENDING_USER_CONFIRMATION**。下列为建议结构，尚未创建目标Git仓库、安装环境或移动任何既有资产。

## 现有仓库与选择 / Existing repositories and options

已通过连接的GitHub仓库清单核实，账号存在 `single-cell-dynamics-perturbation`，其中包含 `modules/03_scTour`；另有独立 `regvelo-grn-dynamics`、`research-scripts-r`、`virtual-perturbation-toolkit`。当前返回的14个可访问仓库中未见 `single-cell-trajectory-fate-toolkit`；此结论限该连接和账号，不等于检查了所有磁盘或其他账号。

| 方案 | 得失 | 本轮建议 |
|---|---|---|
| 新建独立 `single-cell-trajectory-fate-toolkit`，引用旧scTour | 符合长期方法库定位；需维护一个明确的来源登记；旧成果不搬动 | **推荐，等待确认** |
| 扩展 `single-cell-dynamics-perturbation` | 少一个仓库，但轨迹、潜能与原KO/OE主题混合，维护边界变大 | 可选，当前不改 |
| 将scTour迁入新库，旧库改链接 | 看似集中，但涉及历史、模型相对路径、重复数据和私有内容的公开范围 | 首轮不推荐，也未获迁移授权 |

推荐的新库先采用Private。现有scTour仓库是Private，链接不自动赋予新库读者访问权限；公开前需单独决定可发布的代码、结果和许可。不会把私有源文件、患者路径或数据清单批量搬到公开仓库。RegVelo保持独立，作为已有方法来源链接，用户本次没有要求把它并入新库。

## 简洁目录 / Proposed layout

```text
single-cell-trajectory-fate-toolkit/
  README.md                         # 中文入口、运行状态、使用顺序
  00_Start.R                        # R交互式入口；只检查和配置，不一键运行所有方法
  registry/
    methods.csv                     # 14方法来源、版本、状态
  docs/
    DATA_CONTRACT.md                 # 标准文件、ID顺序、尺度、时间/拟时序区别
    ENVIRONMENTS.md                  # 每方法环境、安装步骤与实际锁
    REPRODUCTION_STATUS.md           # 本地执行证据与问题
    COMBINATIONS.md                  # A–F边界及STOP/PIVOT
  methods/
    Monocle2/                       # 每种方法独立目录，共14种
    Monocle3/
    Slingshot/
    PAGA/
    Palantir/
    scTour/                         # 最初只放来源和旧资产链接，不复制模型/重训
    tradeSeq/
    CytoTRACE2/
    FitDevo/
    CellRank/
    scVelo/
    Cell2fate/
    WOT/
    VECTOR/                         # 论文/作者仓库已核实；仅来源卡，本轮不执行
  combinations/
    A_Trajectory_Consensus/
    B_Dynamic_Gene_Programs/
    C_Cell_Potency/
    D_Cell_Fate/
    E_RNA_Velocity/
    F_Real_Time_Transition/
  gallery/
    README.md                       # 仅展示通过验证的本次实际图；区分历史链接
  data_registry/
    examples.csv                    # URL、大小、license、hash、实际下载状态
  environments/                     # 安装被批准且执行后再写实际lock；现在不造lock
```

每个方法目录的最小内容：`README.md`、`SOURCES.md`、`STATUS.md`、按顺序编号的 `scripts/`。教程、官方数据地址和许可先登记链接；获准下载后再保存小型材料。只在确有结果时新增 `results/` 与 `figures/`。不建立14套空框架、任务调度器或自动安装器。

## 人可读的脚本 / Readable scripts

`00_Start.R` 集中设置项目根、外置数据/结果路径、物种、谱系、样本/供者列、既有坐标与标签、seed、配色、类型顺序和PNG/PDF/SVG尺寸。顶部说明目的、输入、输出、科学边界和VS Code运行方式；依赖检查失败给出明确缺包提示，**不自动安装**。后续按Figure或独立问题执行，例如：

```text
methods/Slingshot/scripts/01_Read_and_Check.R
methods/Slingshot/scripts/02_Infer_Lineages.R
methods/Slingshot/scripts/03_Plot_and_Export.R
methods/PAGA/scripts/01_check_input.py
methods/PAGA/scripts/02_paga.py
methods/PAGA/scripts/03_plot_export.py
```

这些文件目前是命名建议，未生成可执行实现。一个R会话读取一次所需对象，各步骤明确使用已存在变量；重启会话只加载对应阶段的保存结果。Python在自己的解释器中逐脚本运行，禁止把R和不同Torch/scvi版本塞进一个环境。绘图单独读取小表和固定坐标，不因调字体重训模型。

`00_Start.R`按所选方法启动相应R版本/独立包库；不在同一会话中卸载重装或切换Monocle2旧依赖与当前依赖。已定位的PI参考脚本中，Main v3与StyleB v1使用不同确认版注释，借用结构时保留这种科学内容边界。现有scTour绘图是Agg CLI，未来需另加薄的交互预览脚本，不能把它直接说成已支持VS Code交互预览。

## R/Python交换 / File contracts

| 文件 | 含义与要求 |
|---|---|
| `cells.tsv` | 唯一 `cell_id`、原始barcode、dataset/sample/donor、已有标签、真实time（如有）；不因转换重命名细胞 |
| `genes.tsv` | 唯一 `gene_id`、symbol、species、注释版本；一对多映射单独记录 |
| `counts.mtx` + 轴文件，或已存在H5AD | R端genes×cells；AnnData端cells×genes。显式转置并检查ID，保留稀疏格式；不反复转出完整Atlas |
| `expression_scale.tsv` | raw counts / normalized / log1p / integrated等尺度及来源，不能只靠矩阵是否整数猜测 |
| `embedding.tsv` | cell_id与已确认UMAP坐标，仅作统一展示；方法需要不同拟合空间时另存且说明 |
| `pseudotime.tsv` | cell_id、method、lineage_id、值、方向、root依据、unreachable/NA；不同方法尺度不直接平均 |
| `lineage_weights.tsv` | cell_id×lineage，保留Slingshot权重；不得把任意cluster one-hot冒充官方权重 |
| `fate_probabilities.tsv` | cell_id、terminal_id、概率、kernel/terminal配置；只比较同细胞和同终末定义 |
| `transition_matrix.npz` + 轴TSV | 细胞转移矩阵；校验稀疏性、非负和行和；不能与WOT原始coupling混为一谈 |

转换先审查交集与丢失列表；若ID重复、缺失、顺序不同或尺度不清，STOP，不能静默取交集继续。RDS/H5AD等大对象、模型权重、环境目录和原始测序文件留在Git外。CSV/TSV/MTX/NPZ的选择只为可检查交换，不新增通用对象框架。

## 版本与许可 / Versions and attribution

每个方法记录官方repo+tag/commit、教程URL、论文DOI、查询日期、改写脚本来源行和本地修改说明。查询时HEAD不是已安装版本；论文DOI和Bioconductor软件DOI分开。官方来源链接不等于允许复制整站或数据再分发；若复制许可允许的源码片段，保留原许可和作者声明。改写后的中文脚本标记 `ADAPTED_FROM_OFFICIAL`，不能称为官方原始代码。

GitHub创建、仓库可见性、现有资产复制/迁移、环境方案和每批下载清单均等待用户确认；实际代码验证后，commit/push仍由用户确认。此次仅交付审查材料，没有执行上述步骤。
