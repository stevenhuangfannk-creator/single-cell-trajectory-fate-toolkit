# 本地动力学与轨迹资产审查 / Local asset audit

审查日期：2026-10-19（Asia/Singapore）。资产检查只读；没有安装、模型训练、下载数据、读取大型H5AD/RDS/模型、迁移、Git写入、提交或推送。原始审查记录保存在本任务 `work/trajectory_review/`，本文件为整理后的交付副本。完整路径、文件大小、Git状态、11个模型清单和小文件SHA256见[结构化证据](evidence/local_asset_audit.json)。

检索限于 `Documents/Codex`、`Desktop/scriptsR`、`Documents/ChatGPT/Research_OS`，文件名检索排除环境、包库和缓存。两份用户指定R风格脚本由既有审计记录定位后获准定向读取，没有扫描其项目数据。Git remote是当前本地配置，origin引用可能是缓存；本轮未fetch，不宣称核实远程最新HEAD。

## 1. 已有仓库 / Existing repositories

| 仓库 / 本地位置 | Remote | 分支 / HEAD | 本轮状态 |
|---|---|---|---|
| `C:/Users/13683/Documents/Codex/2026-10-12/files-pasted-by-the-user-codex/outputs/single-cell-dynamics-perturbation` | `https://github.com/stevenhuangfannk-creator/single-cell-dynamics-perturbation.git` | `main` / `c7b58d1d25b75e2d32ad0d3f27ed228ea3ce6ebc` | clean；scTour当前首选来源 |
| `C:/Users/13683/Documents/Codex/2026-10-10/files-pasted-by-the-user-codex/outputs/regvelo-grn-dynamics` | `https://github.com/stevenhuangfannk-creator/regvelo-grn-dynamics.git` | `main` / `6ffd33057b5c4841c19bd0706691038fb51aacbe` | clean；RegVelo独立发布来源 |
| `C:/Users/13683/Documents/Codex/2026-10-10/files-pasted-by-the-user-codex/outputs/research-scripts-r` | `https://github.com/stevenhuangfannk-creator/research-scripts-r.git` | `feat/regvelo-grn-dynamics` / `c3edd0f17c9740f107a47a058f793478c7281736` | clean；HEAD为撤销旧RegVelo模块的提交，不能当作当前RegVelo模块 |
| `C:/Users/13683/Documents/Codex/2026-10-07/research-scripts-r-zh` | 同上 | `docs/chinese-usage-guide` / `30d2ff3fc2d2aa3b1ae8b6067e2a316b598a20a5` | clean；既有方法卡/索引来源 |
| `C:/Users/13683/Desktop/scriptsR` | 同上 | `phase4-flagship-reconstruction` / `2f12bd7850407fdae44497a116fab8368613526b` | dirty：4个无关PI敏感性文件未追踪，应保留 |
| `C:/Users/13683/Documents/ChatGPT/Research_OS` | 未配置remote | `phase4-flagship-reconstruction` / `52be79b7217f7a1c155a8ce4b98057920b35105c` | dirty：文献、BibTeX、VS Code与方法笔记等多项修改/暂存，不应操作 |
| `C:/Users/13683/Documents/Codex/2026-10-10/files-pasted-by-the-user-codex/outputs/bioinformatics-research-workbench` | `https://github.com/stevenhuangfannk-creator/bioinformatics-research-workbench.git` | `feat/regvelo-module-link` / `064a03fcd1ab830bfd457c8fd9beec44f599bcf2` | clean；HEAD撤销旧RegVelo链接，不应误称仍有该集成 |

文件名检索未找到既有 `single-cell-trajectory-fate-toolkit` 目录或README。这只覆盖限定范围，不是全盘不存在的断言。已有 `single-cell-dynamics-perturbation` 覆盖scTour、scTenifoldKnk及Experimental OE，创建新库前应先确定新库是否仅需方法路由/交互式Figure接口。

## 2. scTour真实资产与执行证据 / scTour evidence

模块：`.../single-cell-dynamics-perturbation/modules/03_scTour/`。

历史大对象目录：`C:/Users/13683/Documents/Codex/2026-10-12/files-pasted-by-the-user-codex/work/sctour/`。本次只检查对象存在和文件大小，没有读取 `inferred.h5ad`、`model.pth`、counts、压缩表达矩阵或推断全表。

比单纯“有文件”更强的已保存证据包括：

- `reports/REPRODUCTION_CN.md`、`results/run_comparison.tsv`，以及Git内每次运行的 `results/<run>/run_summary.json`。
- 本地每次运行的摘要、配置/环境记录、非空loss与训练日志，并有 `.pth`、推断H5AD、训练/验证cell IDs等产物的文件存在证据。
- 数据来源与输入一致性审计、12项历史回归测试通过日志、独立1项组合图边界测试通过日志。
- 图件manifest、逐图格式/字体/布局检查及历史目视QA记录。

这些记录支持“2026-10-12已实际执行”，本轮没有重新认证训练或加载模型，也没有将旧PASS转成本轮重跑PASS。

### 正式模型 / Formal models

11个正式模型各400epochs，共4,400epochs，另有200细胞/3epochs smoke。

| 运行 | 细胞 / HVG | 训练比例 / seed | 本地对象目录（相对历史work/sctour） | 独立日志 |
|---|---|---|---|---|
| A90_seed0 | 4,007 / 500 | 90% / 0 | `full_A` | `full_A.log` |
| A90_seed1 | 4,007 / 500 | 90% / 1 | `full_A_seed1` | `full_A_seed1.log` |
| A20_seed0 | 4,007 / 500 | 20% / 0 | `full_A20` | `full_A20.log` |
| B_1 | 15,174 / 2,000 | 1% / 0 | `subsamples/B_1` | `subsamples/B_1.log` |
| B_5 | 同上 | 5% / 0 | `subsamples/B_5` | `subsamples/B_5.log` |
| B_10 | 同上 | 10% / 0 | `subsamples/B_10` | `subsamples/B_10.log` |
| B_20 | 同上 | 20% / 0 | `subsamples/B_20` | `subsamples/B_20.log` |
| B_40 | 同上 | 40% / 0 | `subsamples/B_40` | `subsamples/B_40.log` |
| B_60 | 同上 | 60% / 0 | `subsamples/B_60` | `subsamples/B_60.log` |
| B_80 | 同上 | 80% / 0 | `subsamples/B_80` | `subsamples/B_80.log` |
| B_95 | 同上 | 95% / 0 | `subsamples/B_95` | `full_B95.log` |

11份日志均存在且非空（约85–99KB），SHA256已保存机器清单。摘要记录模型载入往返ptime误差均为0；本轮未重新执行往返测试。A20训练518.47秒，B20训练2032.95秒仅为历史运行资源记录，不作为当前性能承诺。

### 科学状态 / Scientific status

scTour模块应保持 **PARTIAL**，不能写为论文严格全面复现：

- A20及A90两个seed均未恢复单调发育顺序。A20阶段中位数Spearman约0.1，A90约0；已有输入/标签逐值审计未发现错位，但没有证实偏差根因。
- B20与B95全细胞排序Spearman约0.981548，B10–95的颗粒阶段中位数递增；B1/B5终末局部错序仍在摘要中。
- Supplementary Table S2超参数未核实，部分参数来自官方API默认值；没有把HTML附件误认为已读XLSX。
- B每个比例只有一个seed；完整正式CPU重训未完成；没有用户PI/Healthy的正式scTour结果。
- scTour的ptime是表达排序，潜空间VF不是实测RNA剪接velocity。静态表达预测不直接证明真实谱系、终末命运或干预因果。

### 图件 / Figures

`modules/03_scTour/figures/figure_manifest.json`共17项：a–i及组合图10项，A90/B95诊断7项。实际文件计数为 **17 PNG + 17 PDF + 17 SVG**，所有格式文件均存在；本次不重新渲染。README中的38张是整个三模块仓库图数，不能误报为scTour图数。

10个主图已有历史600dpi、可编辑矢量文字、PDF≥5pt与布局检查。源检查记录17 PASS / 3 WARN / 0 FAIL；字体变量、未导出TIFF、a独立图宽度等限制保留。当前审查未逐图重新目视认证。

## 3. 代码和环境复用 / Code and environment reuse

可复用入口：

- `shared/input.py` / `prepare_input.py`：原始counts、ID、metadata和MEX契约；保留前导零及字面`NA`。
- `modules/03_scTour/scripts/prepare_custom.py`：现有注释和指定谱系转scTour counts/HVG输入；它会计算QC和HVG，**不能在本轮只读审查中运行**。
- `run_sctour.py`：官方Trainer、save/load、ptime/5D latent/VF及独立嵌入；包含输入恢复一致性保护。
- `run_subsampling.py`：八比例与已存在缓存核对；会触发训练，**本轮禁止运行**。
- `plot_figure2.py` + `config/plot.json`：基于真实保存obs/obsm重绘独立面板；不会用VF前两维伪造UMAP位移。现有类群配色针对论文神经谱系，不能直接套进PI类群。

现有runner与绘图脚本约188/335行，已经分开训练和绘图；属于CLI/函数实现，绘图强制`Agg`。它们不是目前用户偏好的VS Code逐段交互式Figure脚本。未来可加一个薄的、参数集中、明确输入对象字段的Figure层；不必复制数据、重写官方模型或替换已验证历史脚本。

历史环境：

- Python路径：`C:/Users/13683/Documents/Codex/2026-10-12/files-pasted-by-the-user-codex/work/sctour/.venv/Scripts/python.exe`，文件存在。
- `pyvenv.cfg`记录Python3.11.11；指向uv独立Python，不是全局3.13。
- 锁文件：`C:/Users/13683/Documents/Codex/2026-10-12/files-pasted-by-the-user-codex/outputs/single-cell-dynamics-perturbation/environments/sctour-lock.txt`。
- 安装脚本：同目录`sctour-setup.ps1`，仅阅读，未运行。
- 历史版本：sctour1.0.0、Torch2.5.1+cu121、Scanpy1.9.8、AnnData0.10.8、NumPy1.26.4、SciPy1.13.1、pandas2.2.3、matplotlib3.8.4、torchdiffeq0.2.5。

历史环境记录编码器/解码器CUDA、ODE在CPU；资产子审查没有import、pip check或GPU探测，因此当前可运行性仍待以后获准的小测试。总审另行查询了GPU硬件信息，不能替代模型运行验证。不要混装scTour旧环境与RegVelo3.10或现代AnnData共享环境；已有公开A的MEX跨环境桥可参考。

## 4. 用户风格参考 / Confirmed Figure scripts

当前可定向读取的确认版位于：

`C:/Users/13683/Documents/ChatGPT/PI_Research/scripts/Step01_Data_Preparation/confirmed_plots/`

| 文件 | 大小 | 本轮SHA256与2026-10-15记录 |
|---|---:|---|
| `01_PI_UMAP_Main_v3.R` | 12,886 bytes | `33CFDC808B2EDB0D77943E05B9ADFB300D87F403E8D6840ADAF5589806126713`，一致 |
| `03_PI_UMAP_StyleB_v1.R` | 9,850 bytes | `4B491A4B935E8F284D61E9530715EE66FF84F05DE832B0E116A5A73D10E48C00`，一致 |

既有审计另记录历史`科研项目1/PI-StateMap/approved_figure_scripts`；本轮未扫描该目录。当前PI_Research脚本顶部说明迁移只改路径/环境及默认预览边界，不修改原数据与参数。本轮未读它们引用的CSV/色表/对象，也未执行绘图。

值得沿用的具体结构：目的与输入/边界说明→集中可调参数及中文单位→显式包加载→数据/名称/注释/坐标检查→顺序可读的绘图→`print()`预览→显式导出。`export_figures=FALSE`、`allow_overwrite=FALSE`；Arial，白底，宽183mm；正式PNG600dpi、preview180dpi、svglite SVG与cairo PDF；保存sessionInfo。完整细胞、原坐标、1:1比例和颜色顺序保持。

01使用`annotation_display_broad_v3`，StyleB使用已确认的`annotation_display_broad_v1`和12类3×4面板。后者顶部明确v1→v3属于科学内容变化，不能借统一风格擅自替换。可借用脚本结构与预览/导出约定，不借用其细胞类型、坐标或科学参数。

## 5. 其他可参考资产 / Other assets

独立RegVelo仓库已有官方697细胞、hard模型、27图、CellRank和regulon KO的执行报告；本轮仅读README/MODEL_QC头部及Git，未读取模型或重跑。它需要真实剪接层与命名GRN，不能因为scTour无需剪接层而放宽RegVelo契约。

`research-scripts-r-zh`中的Monocle3记录CANDIDATE/BLOCKED，Slingshot与tradeSeq为候选，CellRank桥接卡未验证。这是历史资产状态，不是2026-10-19真实包安装/可运行性的检测。PI历史项目另有Monocle相关源码与结果记录；本轮限定范围不读取其大型对象或替用户确认root/trajectory。

## 6. 最小工作区建议 / Minimal workspace

第一轮保留当前`work/trajectory_review`审查材料，不创建/迁移新Git仓库，不修改上述既有成果。若用户随后确认建立独立`single-cell-trajectory-fate-toolkit`，建议只新增方法路由、统一输入/结果契约、中文说明和按Figure拆分的交互脚本：

1. scTour与RegVelo继续各用现有独立仓库、独立环境和既有保存对象；通过显式根路径引用，记录commit与运行证据，不复制模型/数据。
2. 每个Figure读取已确认上游结果并有自己的集中参数，默认预览、显式另存；模型训练与重算必须独立授权。
3. 相同cell ID/基因/坐标/注释先核对；方法输出分别命名ptime、latent VF、RNA velocity、fate probability，不混合尺度或声称同等因果证据。
4. Monocle/Slingshot/CellRank新增接口的“代码完成、小样本验证、需真实数据、正式结果”分别登记；不从目录名或已安装包推定完成。
5. 保留A非单调、B1/B5反例、失败日志、所有正式模型和历史图件；不为重画或展示删除/覆盖、不重新选seed美化结论。

## 自检 / Self-check

已按限定范围定位真实Git来源；只读取小文档、配置、摘要与日志，模型/大对象仅文件统计；关键README/config/script/log的SHA256已记录。两份确认R脚本与既有哈希一致。既有仓库、环境、数据、图件与Git状态均未改变；本次只生成审查JSON及本说明。

结束前复核29份小文件/日志哈希及7个仓库HEAD/dirty清单，均与本轮已记录快照一致（PASS）；未对矩阵/模型内容计算hash。

## 交付提案只读复核 / Proposal cross-check

另按要求阅读本轮 `outputs/trajectory_fate_review_2026-10-19/03_REPOSITORY_PROPOSAL.md`、`04_COMBINATION_FEASIBILITY.md`、`05_ENVIRONMENT_AND_PRIORITY.md`、`06_FIRST_BATCH_AND_ACCEPTANCE.md`，没有修改它们。

四份文档整体通过：明确仅审查/建议，没有声称新库、环境、脚本、组合或训练已完成；scTour历史PARTIAL与失败保留；新库可见性、已有资产引用/迁移、首批数据/环境和Git发布均等待确认；VECTOR已核实身份但仍不自动执行；CellRank/Scanpy新栈与旧环境隔离的表述没有借历史PASS推定兼容。

没有阻断性问题。可选补充：在交付文档加入本审计的scTour精确根路径和锁路径；指出PI两份风格脚本分别用v3与v1注释；明确现有scTour绘图是Agg CLI，未来交互式Figure脚本另加薄层；未来`00_Start.R`按具体方法选择独立R包库，不能在一个会话任意切换旧/新依赖。这些补充不要求本轮实现或重跑。
