# CellRank独立环境：安装通过，数据阻塞

Python3.12.14、CellRank2.3.3、Scanpy1.12.4、NumPy2.5.4；精确依赖见[requirements.lock.txt](requirements.lock.txt)。实际环境位于工作区work/runtime/cellrank-py312，不进入Git，不与CytoTRACE2的NumPy1.26环境混用。

```powershell
python -m venv .venv-cellrank
& ./.venv-cellrank/Scripts/python.exe -m pip install -r environments/round4/CellRank/requirements.lock.txt
& ./.venv-cellrank/Scripts/python.exe -m pip check
& ./.venv-cellrank/Scripts/python.exe -X utf8 round4/run_with_monitor.py CellRank
```

[安装日志](install_cellrank.log)、[成功导入](import_cellrank.log)、[依赖检查](pip_check.log)为实际证据。一次在安装完成前的导入报错也保留，没有把它当作最终安装失败。Windows原生运行库只在新venv内复用已有可追溯DLL，[hash](local_runtime_provenance.json)；正常新机器应准备微软官方运行库。未修改系统或旧scTour/RegVelo环境，不随Git分发DLL。

线程固定1，未安装scVelo、PETSc/SLEPc或GPU额外依赖，未运行velocity。软件安装成功不代表方法通过：官方骨髓Figshare下载返回403，数据规模/许可元信息尚未取得，预设单文件上限512MiB，实际未下载。运行入口会在下载检查失败时退出。当前没有宏状态、命运概率或基因关联结果。

完整恢复条件与后续分析设计见[中文指南](../../../methods/CellRank/README_CN.md)。不应在网络恢复前重复运行模型；网络恢复后仍须审查输入尺度、根来源及预处理，再实现和验证后续计算。新机器锁文件安装尚未独立测试。
