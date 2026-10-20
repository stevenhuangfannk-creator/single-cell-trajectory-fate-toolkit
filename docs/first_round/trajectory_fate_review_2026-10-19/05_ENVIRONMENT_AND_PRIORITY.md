# 环境兼容性与复现优先级 / Environments and priorities

日期：2026-10-19。本轮仅执行解释器 `--version`、硬件/WSL信息和已有环境文件读取，未安装包、import科研包、载入模型、生成图件或执行分析。软件版本清单不能替代实际环境测试。

## 本机现状 / Observed machine

| 项目 | 本次证据 | 含义 |
|---|---|---|
| 系统 | Windows 11 Home | 编译型R/Python依赖需核对Windows支持，不能预设WSL可用 |
| 内存 | 总计16,454,352 KiB，约15.69 GiB；即时空闲不足1 GiB | 16 GB是总容量而非当前分析预算；不终止用户程序释放内存 |
| GPU | RTX 4070 Laptop，8188 MiB，driver 610.60 | 不代表任意Torch/JAX模型都可用；GPU显存不替代主内存 |
| R | `C:/Program Files/R/R-4.3.1/bin/Rscript.exe`；另有R-4.6.1 | 两者 `--version`已读取；没有切换默认R或改库路径 |
| 全局Python | 3.13.15 | 不作为所有科研方法的默认兼容环境 |
| WSL | `wsl --list --quiet`返回未安装发行版提示/exit 1 | 本轮不安装WSL，后续若需要属于待确认环境决策 |
| 既有scTour | 旧项目有Python3.11/Torch2.5.1环境及实际锁 | 只读审查；保留，不升级或复制整个环境 |
| 既有RegVelo | 2026-10-10记录Python3.10.22、Torch2.5.1+cu124、scvi1.2.0、Scanpy1.10.4、scVelo0.3.3、CellRank2.0.7 | 历史记录，本轮未import复测；独立环境保留，不能直接装新Cell2fate或升级CellRank |

当前Bioconductor官方页面将3.23与R4.6配对；R4.3对应历史3.17/3.18。包本身的最低R版本不等于整套当前Bioconductor仓库兼容；不能将当前release包全部装入R4.3历史库。下一轮先按拟复现包版本选择对应R/Bioc，不重建所有环境。[官方安装页](https://bioconductor.org/install/)、[版本配对表](https://bioconductor.org/about/release-announcements/)

## 环境分组建议 / Proposed isolation

下表是**待确认的隔离方案**，不是已建立、已安装或已验证环境。优先最少新增环境；只有依赖确实兼容后才合并环境。

| 环境候选 | 方法 | 主要冲突/检查点 |
|---|---|---|
| 既有scTour只读复用 | scTour | 固定Python3.11、旧Scanpy/Torch及checkpoint语义；保留CPU ODE行为，禁止混装通用3.13环境 |
| `R-trajectory`独立包库 | Slingshot、tradeSeq；Monocle3经验证后再加入 | R/Bioc成对、Matrix/igraph/SingleCellExperiment版本；Monocle3依赖与编译单独确认 |
| `R-monocle2-legacy`（必要时） | Monocle2 | 历史API、igraph/DDRTree/VGAM兼容风险；不为了旧代码全局降级igraph |
| `py-trajectory`候选 | Scanpy/PAGA、Palantir、CellRank pseudotime | 当前CellRank2.3.3要求Python≥3.12、NumPy≥2、Scanpy≥1.11；Scanpy1.12.4要求Python≥3.12。与旧scTour/RegVelo的Python3.10/3.11、NumPy1.x分开；Palantir还需实际依赖解析 |
| 独立potency环境 | CytoTRACE2；FitDevo先核对R实现及模型资源 | CytoTRACE2 Python1.1.0.4要求NumPy<2，与CellRank2.3.3的NumPy≥2互斥；模型文件、物种/基因集、Python/R接口分别审核，不强制二者共环境 |
| `py-velocity`候选 | scVelo、CellRank | 可先只读已有环境信息；新运行目录与旧RegVelo科学结果分离 |
| `py-cell2fate`独立 | Cell2fate | 官方setup.cfg锁scvi-tools0.16.1、anndata0.8、torch1.11等历史栈；release v1.0.0与源码自报0.01a分开记录。不能和当前CellRank混装；Windows/Python轮子及训练内存均待实测 |
| `py-wot-legacy`（待选） | WOT | 旧依赖/维护状态；与当前CellRank通过标准couplings文件分开更易审查，但适配仍NOT_TESTED |
| 历史R环境待评估 | VECTOR | 论文与jumphone/Vector已相互核实；教程为R3.6.1/Seurat3，官方仓库无明确LICENSE，不假定可复制源码；本轮不安装或执行 |

Python具体版本与包锁以方法来源卡的官方声明为依据；查询到的最新tag不等于适合历史论文复现的版本。正式锁必须来自获准后实际解析/安装成功的环境；本轮不伪造requirements freeze或可运行保证。

## 资源预算建议 / Proposed budget

- 本轮只读审查无模型计算。下一轮先让用户在VS Code关闭无需占用的会话或选择空闲时段；不自动终止进程。
- 每次只运行一个方法、一个示例；R并行worker=1、Python `n_jobs=1` 为起始建议。线程数可设1–2，不等于所有底层BLAS一定受控，实际需记录。
- 首个原型优先官方140点Slingshot示例或300细胞模拟counts，明确标记SIMULATED/OFFICIAL_TUTORIAL；不是患者数据验证，也不作paper-exact claim。
- 建议为首例预留约4 GiB可用内存并记录RSS；这是本项目保守预算，**不是官方最低硬件声明**。若达不到，先交脚本，不自动缩样后称完整复现。
- 10,000×10,000 float64密集矩阵本体约0.75 GiB，复制、求解和模型还会增加内存；OT、扩散、GAM和稠密图不能仅按表达矩阵大小估算。
- Cell2fate/scTour正式训练、全基因tradeSeq、大时间序列OT和多方法参数网格均不在默认许可内。先保存小例结果，预算变大就暂停。

## 复现顺序 / Order

| 批次 | 方法/任务 | 推荐理由 | 进入条件 |
|---|---|---|---|
| P0 | 既有scTour证据与文件契约复用 | 避免重复11个正式模型；保留未通过结果 | 用户确认引用路线；先只读/不重绘 |
| P1 | Slingshot官方例→tradeSeq官方工作流 | 方法组合有官方直接范例；小型CPU流程，便于中文脚本审阅 | 确认R/Bioc独立库和示例；单方法先验收 |
| P1b | PAGA官方教程 | 不需RNA剪接或深度训练；补群级拓扑视角 | 确认官方数据下载清单/大小和Python环境 |
| P2 | Monocle3、Palantir、CellRank PseudotimeKernel | 补A与D；方向/终末可系统审查 | root/terminal依据明确，不自动合并输出 |
| P2 | CytoTRACE2、FitDevo | 建立C，先小例和物种/覆盖检查 | 确认模型资源、输入尺度、许可及内存 |
| P3 | scVelo→CellRank，再Cell2fate | 先低成本速度基线，再审查训练模型 | 有真实S/U、批准数据与训练预算 |
| P3 | WOT→RealTimeKernel | 真实时间输入和历史接口复杂，独立处理 | 真实时间数据与WOT兼容选项经确认 |
| P4 | Monocle2历史复现 | 兼容成本高，先保留官方来源与旧版隔离方案 | 确有历史比较需求及独立环境 |
| P4 / HOLD运行 | VECTOR | 身份已核实：Cell Reports2020、DOI10.1016/j.celrep.2020.108069、jumphone/Vector；历史依赖和许可尚需处理 | 用户确认该候选符合原意，且来源/环境方案明确后再授权复现 |

优先级是工程与科学前提的建议，不代表方法优劣排名。任何新增安装、下载、环境重建、替代方法、正式分析与GitHub发布均未执行。
