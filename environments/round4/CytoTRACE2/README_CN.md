# CytoTRACE2独立CPU环境

用途已确认为非商业；先阅读[Stanford许可审查](../../../docs/round4/CYTOTRACE2_LICENSE_REVIEW_CN.md)。当前环境位于工作区`work/runtime/cytotrace2-py312`，不进入Git。Python3.12.14，CPU PyTorch2.5.1，CytoTRACE2-py1.1.0.4，NumPy1.26.4，Scanpy1.11.5。精确依赖见[锁文件](requirements.lock.txt)，[pip check](pip_check.log)应无依赖冲突。

在新环境安装，不在已有scTour、RegVelo或PAGA环境运行以下命令：

```powershell
python -m venv .venv-cytotrace2
& ./.venv-cytotrace2/Scripts/python.exe -m pip install torch==2.5.1 --index-url https://download.pytorch.org/whl/cpu
& ./.venv-cytotrace2/Scripts/python.exe -m pip install -r environments/round4/CytoTRACE2/requirements.lock.txt
& ./.venv-cytotrace2/Scripts/python.exe -m pip check
```

锁文件中torch带CPU本地版本标识，需先从官方CPU索引安装；不能直接让默认索引拉取大型GPU运行库。`setuptools==78.1.0`保留官方包使用的pkg_resources，NumPy不能升级到2。实际安装记录：[CPU torch](install_ct_torch.log)、[其余依赖](install_cytotrace2.log)。这些是本机实际成功环境，不等于已在第二台机器完成重装。

Windows通常应通过微软官方Visual C++运行库满足原生依赖。本机仅在新venv使用已有可追溯的`msvcp140.dll`，由00入口进程内`os.add_dll_directory`加载；[来源与hash](local_runtime_provenance.json)，不修改系统、不随Git分发DLL。官方库可能仍打印未安装系统运行库的提示，最终以实际导入和退出码验收。

模型由官方函数首次下载19个文件（合计156525236字节），另有背景张量。模型、官方源码和输入均不入Git；[源文件hash与模型URL](../../../methods/CytoTRACE2/results/installed_source_manifest.json)、[模型hash](../../../methods/CytoTRACE2/results/model_manifest.json)可用于核对。官方权重以PyTorch格式加载，只使用可核实的官方来源，不能替换为未知下载。

全部数值库线程为1。官方扩散与KNN会启动单个worker，即使disable_parallelization=True也不能理解为完全没有子进程；Windows入口已加main保护。模型推断与子进程不同时运行其他方法。一次完整2850单批触发资源保护；当前用官方batch_size=1000，内部等分为3批各950细胞，种子14，所有细胞均保留。此资源适配会改变平滑邻域，不能宣称与完整单批结果等价。失败和成功日志均保留，资源记录包括整个进程树。

下载和运行命令见[方法教程](../../../methods/CytoTRACE2/README_CN.md)。VS Code选择独立解释器；交互执行可在同一会话按00、01、02、03逐段运行，但Windows涉及进程池时优先使用已保护的run_example入口。重绘只读取派生小表，不加载表达或权重。
