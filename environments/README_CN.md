第四轮当前环境：[PAGA](round4/PAGA/README_CN.md)、[CytoTRACE2](round4/CytoTRACE2/README_CN.md)、[CellRank](round4/CellRank/README_CN.md)。三者独立；CytoTRACE2已运行通过，CellRank安装通过但输入403阻塞。以下保留第二轮Slingshot安装记录，第三轮环境见[第三轮](round3/README_CN.md)。

# Slingshot独立环境与复现说明

本次真实使用 Windows x64、R 4.6.1、Bioconductor 3.23、slingshot 2.20.0。完整版本见 [R-installed-packages.csv](R-installed-packages.csv)，实际会话见 [sessionInfo-install.txt](sessionInfo-install.txt)。锁来自实际安装结果，不是计划依赖。

R 位于本任务工作区 `work/runtime/R-4.6.1/`，包库位于 `work/runtime/R-trajectory/library/`，均在交付项目外，不进入ZIP或未来Git仓库。未安装WSL或Rtools，未更改PATH、默认R和文件关联，未修改既有scTour/RegVelo环境。

## 已执行的安装与校验

R安装文件由 [CRAN云镜像](https://cloud.r-project.org/bin/windows/base/R-4.6.1-win.exe) 获取，91,749,976 bytes；MD5与[CRAN主站清单](https://cran.r-project.org/bin/windows/base/md5sum.R-4.6.1.txt)的 `7907f3a20ec8ec88cd0da279024b8e27` 一致。主站下载过慢的部分文件保留在本地缓存，不作为安装文件使用。

安装使用当前用户、指定工作区目录、静默安装、无图标、无额外任务：`/CURRENTUSER /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /NOICONS /TASKS="" /DIR="目标目录"`。软件安装日志保留在 [R-install.log](../methods/Slingshot/logs/R-install.log)。

Slingshot及31个非基础包按Windows R4.6二进制下载清单安装。此处“31个”包含Slingshot本身。首轮仅按元数据必要依赖解析得到29个；真实调用发现还需要DelayedMatrixStats及sparseMatrixStats，补入后为31个。没有安装全部Suggests可选依赖，也没有安装tradeSeq/Monocle3。

[下载清单](download_manifest.csv)列URL、固定版本、本地MD5、SHA-256和实际大小。某些仓库索引没有提供MD5sum，清单的 `repository_md5` 为NA；不能声称这些包通过了仓库提供的独立MD5比对。ZIP安装时R进行了包内MD5文件检查，本地文件hash供后续固定文件复核，HTTPS来源、包内检查、本地hash和官方签名不是同一层证据。

## 在当前机器运行

在项目根目录PowerShell执行：

```powershell
./run_slingshot.ps1
# 或显式传入Rscript：
# ./run_slingshot.ps1 -Rscript '你的R安装目录/bin/x64/Rscript.exe'
```

助手只运行已有环境，不安装包；每次保存带时间戳的stdout/stderr和退出码。默认寻找本任务已安装的独立R，再找PATH上的Rscript；自选解释器时仍要匹配包库。

在VS Code使用该R解释器，设置项目根工作目录，按根目录00_Start.R、方法01、02、03逐段执行。移动项目或切换包库时，先在R中设置 `options(toolkit.root='项目根绝对路径', toolkit.library='独立包库绝对路径')`。当前目录结构下00会找到项目外的独立库；如果解压到其他位置，应明确指定库路径。

## 在新位置安装

先安装相容R版本，再在项目根运行：

```r
# 必须选择专用包库，勿指向已有科研方法的包库。
options(toolkit.library = file.path(getwd(), 'work/runtime/R-trajectory/library'))
options(toolkit.download_dir = file.path(getwd(), 'work/downloads'))
source('environments/01_Install_Slingshot.R', encoding = 'UTF-8')
```

[固定包安装脚本](01_Install_Slingshot.R)从本次清单获取相同文件，不静默换最新版。若官方文件已撤下、hash不同或下载超过范围，停止并保留证据，另行选择版本后重新验收。此脚本是从实际安装流程整理的可编辑固定版本入口；本轮实测的安装执行源码另见 [bootstrap_executed.R](../methods/Slingshot/logs/bootstrap_executed.R)。固定包安装入口未在第二个空白包库再重复安装验收。

## 本轮运行器特有的问题

1. Windows未接受继承的 `C.UTF-8` locale；新进程设置 `LANG` / `LC_ALL` 为 `English_United States.utf8` 后中文脚本正常读取。设置只作用于进程，运行助手退出时恢复原值，不改系统语言。
2. 当前运行器没有 `PROCESSOR_ARCHITECTURE`。cli 3.6.6的退出清理源码读取该值但没有先检查空值，导致原生退出异常。先核实OS/进程均x64；00_Start.R只在缺失且R自报x86_64时补进程变量AMD64。没有伪造平台、忽略退出码、强制退出或修改包源码。

诊断依据见 [ENVIRONMENT_FIX_CN.md](../methods/Slingshot/logs/ENVIRONMENT_FIX_CN.md)。早期cli_no_thread尝试没有解决问题，已经移除，没有作为最终方案。原始失败日志保留。

## 验收与资源范围

[00_install_final_exit.json](../methods/Slingshot/logs/00_install_final_exit.json)为0；[04完整运行](../methods/Slingshot/logs/04_execution_record.json)为0；[05独立重绘](../methods/Slingshot/logs/05_replot_record.json)为0且拟合文件hash不变。R包载入时的masked信息是命名空间提示，不等于运行失败；原生异常退出则必须处理。

下载缓存、运行时磁盘和内存记录见 [RESOURCE_AUDIT.json](RESOURCE_AUDIT.json)。缓存落盘字节数不是精确网络传输计费；重试/响应头和部分下载可能额外产生少量传输。实际资源明显低于批准的1 GiB下载、4 GiB运行目录和约4 GiB分析内存预算。使用CPU、单方法串行；没有运行真实PI数据或大型训练。

后续tradeSeq/Monocle3先分别列数据、包、编译与内存清单；Slingshot批准范围不自动扩展到它们。Monocle3如需BPCells/HDF5/sf或编译工具链，独立评估，不为整合修改旧环境。
