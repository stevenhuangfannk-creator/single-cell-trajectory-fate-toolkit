# PAGA独立环境

本轮Python 3.12.14，Scanpy 1.12.4；完整精确版本见[requirements.lock.txt](requirements.lock.txt)。环境位于工作区work/runtime/paga-py312，未写入已有scTour/RegVelo。安装与运行串行，BLAS/OpenMP/Numba线程为1，未使用GPU。

新机器：`python -m venv .venv-paga`，在该环境用`python -m pip install -r environments/round4/PAGA/requirements.lock.txt`。Windows需微软Visual C++ 2015–2022 x64运行库；应从微软官方渠道准备，不从不明网站下载DLL。本机系统缺MSVCP140；第一次失败已保留，仅复制已存在的捆绑Python/NumPy运行库到本次venv/runtime_dlls，通过os.add_dll_directory在进程内加载。复制来源hash见[记录](local_runtime_provenance.json)，不修改系统、不替换Numba源码、不随Git分发DLL。成功加载见[日志](DLL_load_check.log)。

依赖安装通过不等于方法运行通过；方法证据见[状态](../../../methods/PAGA/STATUS.json)。原始官方HDF5和处理后AnnData仅存.local_round4/PAGA，由Git忽略。未在第二台机器验证完整安装。不要将本机运行时复制到科研旧环境。
