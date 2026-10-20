# 第三轮独立环境：实际安装证据与重现步骤

本轮沿用工作区独立R 4.6.1和独立R-trajectory包库，安装tradeSeq 1.26.0、Monocle3 1.4.27、BPCells 0.3.1及依赖。未修改系统默认R、scTour或RegVelo，没有WSL或系统级Rtools安装。模型串行，OMP/OpenBLAS/MKL、BiocParallel、future及RhpcBLASctl在进程中限制单任务/单线程；没有大规模并行训练。

先阅读 [来源与校验](../../docs/round3/SOURCES.json) 和三个 [ZIP清单之一](../round3_tradeSeq_downloads.csv)。所有二进制经官方仓库MD5核验，源码/工具链记录本地SHA256。Rtools45官方页面明确支持R4.6；不需要寻找不存在的Rtools46发布。

## 当前机器直接运行

在仓库根运行 `./run_round3.ps1 -Module tradeSeq`，再Monocle3，再combination。参数 `-RscriptPath` 和 `-LibraryPath` 可指定环境；`-Replot` 只读保存对象导图。第二轮 `run_slingshot.ps1` 不在此顺序中，不会覆盖旧Slingshot资产。

## 换机器的安装顺序

1. 单独准备匹配的R 4.6和空包库；先设置 `options(toolkit.library='独立库')`。不要对既有科研库执行无选择升级。
2. 显式运行本目录 `01_Install_Binaries.R`，按本轮CSV精确URL/MD5安装所需Windows二进制。00入口不自动安装。它有1GiB缓存保护；这个脚本在已安装库验证，**未额外创建第二个完全空库重装全部依赖**。
3. 依官方链接取得固定Monocle3/BPCells源码。若不能取得匹配二进制，准备Rtools45编译器与HDF5开发库。实际本轮仅下载解压工具链到work/runtime，复用已存在的Git Bash，另外下载make；不运行系统安装器。
4. 从工作区根按 `executed_compile_env.ps1` 的进程变量执行 `R CMD INSTALL --no-multiarch BPCells-0.3.1/r`，成功后再 `R CMD INSTALL --no-multiarch monocle3-1.4.27`。其中路径是本次执行审计，迁移时要改为你的工作区；真正可移植的起点仍是官方安装说明与本目录固定版本清单。
5. 分别 `library(tradeSeq)`、`library(monocle3)`，再按各方法中文指南运行。安装成功不替代示例运行验收。

## 实际遇到并解决的问题

- 原始运行器缺少PROCESSOR_ARCHITECTURE；仅在缺失时按x86_64设置AMD64，避免cli退出清理异常。未修改cli。
- R使用Windows可接受的English_United States.utf8；Git Bash对此locale会有提示，但编译实际成功。警告保留。
- BPCells最初报告C++17 filesystem不可用；调试日志显示真正原因是Windows深路径头文件。临时Q:映射仅指向本工作区runtime，CPLUS_INCLUDE_PATH用短路径补充GCC架构头文件及Rcpp/Eigen，不修改官方源码。安装后撤销映射，运行方法不需要Q:。
- 源码解压Rtools的terminfo大小写/硬链接项有警告；所需编译器/HDF5文件经实际C/C++和包编译验证。没有假报整份工具链无警告。
- Monocle3安装时对IterableMatrix类定义有提示；本轮使用内存dgCMatrix，官方例子实际成功。**没有验证BPCells磁盘对象保存/迁移功能**。
- 官方代码有ggplot弃用提示和saveRDS缺少Annoy/HNSW索引警告；均保留。RDS可重绘，不声明保存了完整近邻索引。

`install_BPCells.log`、`install_BPCells_debug.log`、`install_BPCells_shortpath.log`是真实失败；`install_BPCells_final.log`和`install_Monocle3.log`为最终成功。`executed_*`保留当时执行源码，可能含本机路径，不应当成无需修改即可迁移的脚本。

安装包、工具链、源代码解压目录和运行时位于work，不进入Git或交付ZIP。实际资源记录和最终包清单见本目录RESOURCE_AUDIT.json、installed_packages.csv。峰值RAM没有覆盖全程的连续监测，不能用稀疏采样声称精确峰值；串行过程检查时剩余RAM约3.2–5GiB。
