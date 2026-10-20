# 首批复现建议与验收 / First batch and acceptance

状态：**PROPOSED / NOT_TESTED**。本文件列预期图件，不包含本轮生成的科研图。首批建议采用“Slingshot→tradeSeq”，PAGA作为第二个独立小例；CellRank在前两者验证后再进入。scTour先复用历史证据，不重训。

## 首批清单 / Suggested first batch

| 方法 | 官方例与数据 | 建议代表图 | 验收与边界 |
|---|---|---|---|
| Slingshot | vignette的 `slingshotExample`：140点×2维及cluster；另有750 genes×300 cells的官方模拟counts流程 | cluster MST、principal curves、lineage pseudotime散点 | 分支/权重/NA与原例一致；官方模拟例可证明接口与图件，不证明真实生物学 |
| tradeSeq | 先用官方workflow规定的counts、pseudotime、cellWeights；或Slingshot vignette的300细胞模拟单谱系 | NB-GAM smoothers、动态基因热图、收敛/association表 | 拟合诊断、预指定检验与FDR；140点例只有坐标，不能直接充当表达counts |
| PAGA（可选第二小例） | 官方Scanpy/PAGA教程指定数据；下载前先核实大小和hash | 群级PAGA图、PAGA初始化的embedding、DPT/marker对照 | 图连通性与参数记录；DPT另需root，PAGA本身不提供真实时间 |
| CellRank（下一批） | 官方pseudotime教程及其原生数据 | macrostates、terminal与fate probability | 若缩小官方数据，只能标小样本原型；不称完整教程/论文复现 |
| scTour（已有资产审查） | 旧库Figure2 a–i、诊断图、run_summary与环境锁 | **链接原图**；不在新库制造新“复现图” | 历史 `PARTIAL` 保持，A20/A90错序与B1/B5问题原样保留 |

示例依据：[Slingshot官方vignette](https://bioconductor.org/packages/release/bioc/vignettes/slingshot/inst/doc/vignette.html)、[tradeSeq官方workflow](https://statomics.github.io/tradeSeq/articles/tradeSeq.html)。首批不要求把所有方法放进同一数据例或同一环境。

## 脚本交付约定 / Script delivery

获准后每个Figure模块按“顶部说明→集中参数→依赖检查→读取/校验→分析→预览/导出”组织。R统一入口 `00_Start.R` 只准备路径、对象、包和绘图参数；用户在VS Code按01/02/03逐段执行。Python用独立解释器，不自动安装。按图单独修改/运行，保护既有坐标、标签和上游对象。

每图输出PNG/PDF/SVG、实际绘图小表、图件说明、参数与版本。图先在VS Code预览，正式导出另存；宽高、DPI、字体、颜色和legend顺序集中配置。默认白底、清晰英文轴/图例，中文注释解释科学含义。缩小数据、改变annotation或删除细胞不是单纯画图参数；须先说明依据并由用户决定。

## 五项状态 / Status definitions

统一使用 `PASS / FAIL / BLOCKED / NOT_TESTED`，并给证据文件、日期和范围。不要把来源登记完成写作INSTALL_OK。

| 字段 | PASS所需证据 | 本轮新库 |
|---|---|---|
| INSTALL_OK | 对应独立环境版本记录、依赖检查、实际包加载；不只存在requirements | NOT_TESTED |
| INPUT_OK | 实际示例来源/hash/shape/尺度/ID/必需字段检查；不是看教程截图 | NOT_TESTED |
| RUN_OK | 官方例实际执行、退出状态、关键数值/对象检查、日志 | NOT_TESTED |
| FIGURE_OK | 本次真实结果绘图，三格式可打开、标签/截断/来源数值检查 | NOT_TESTED |
| BIOLOGICAL_INTERPRETATION_LIMITS | 始终填写文本；另有 `limits_review_status` | 已进行文档层面的边界审查；不是生物学验证PASS |

`BIOLOGICAL_INTERPRETATION_LIMITS`不是一个可以笼统通过的生物学真值测试。记录能支持什么、不能推断什么、还需何种实验/供者证据。模拟数据标明simulation；工程测试与生物学验证分开。某方法失败不删除日志，不通过换seed挑成功图掩盖失败。

## 授权前不做的依赖步骤 / Pending decisions

1. 仓库：确认新独立库方案及Private/Public；推荐新Private库+旧scTour只读链接。当前没有创建Git仓库或推送。
2. 首批：建议只批准Slingshot→tradeSeq官方小例，之后再决定PAGA。确认这一批不等于授权14方法全部安装或正式科研分析。
3. 环境：选择独立R/Bioc包库，保留R4.3与scTour/RegVelo环境；若需升级/重建或WSL，另列方案确认。
4. 数据：下载前逐文件列官方URL、预计大小、许可和目标目录；本轮只登记地址，未获取示例数据。
5. F模块：WOT历史兼容、显式coupling路线、或另加moscot需单独选择。VECTOR已找到相互核实的论文与作者仓库，仍须确认这就是用户所指候选，不能据此自行安装或运行。

本轮完成上述审查后暂停。下一轮核心交付仍是用户可编辑、逐步执行的脚本；未经用户确认，不提交GitHub，不运行大型QC/整合/训练或完整科研流水线。
