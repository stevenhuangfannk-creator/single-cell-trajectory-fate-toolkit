# 退出异常的定位与修复

第一次安装进程已经写出INSTALL_OK和版本记录，但最终退出码为-1073741819，不能因此认定安装过程完整成功。第一次分析还遇到Windows locale不支持C.UTF-8，中文source失败；设置进程locale后能读取源码，随后发现真实推断调用还缺DelayedMatrixStats。

补齐该包与sparseMatrixStats后，03次分析实际生成了图件，但退出依然异常。依赖探针显示：Matrix/Rcpp/S4Vectors/SingleCellExperiment/princurve可正常退出；igraph异常。进一步检查间接依赖，cli、rlang、vctrs、lifecycle异常，而magrittr/pkgconfig正常。rlang载入后同时载入cli，因此不能将这些现象误报为多个独立方法错误。

检查cli 3.6.6官方源码包：

- URL：<https://cloud.r-project.org/src/contrib/cli_3.6.6.tar.gz>。
- `src/thread.c` 的 `cli__kill_thread()` 在Windows分支用 `getenv("PROCESSOR_ARCHITECTURE")` 取值，再直接 `strcmp(arch, "ARM64")`；当前进程该变量为空。
- RuntimeInformation核实OSArchitecture和ProcessArchitecture均为X64。只补当前进程AMD64后，单独载入cli退出0；随后完整Slingshot运行退出0。

原型曾试过CLI_NO_THREAD，但退出仍异常，因此未保留该开关。最终00_Start.R只为已核实的x86_64 R补齐缺失标准环境变量，不改cli代码、不改模型参数、不降级依赖、不通过强制退出掩盖异常。这是当前运行器的修复，不应推广成所有Windows用户都必须设置同一变量。

原始失败与探针结果保留在同目录的00_install.log、01/02/03_run日志及shutdown_dependency_probes*.json。最终安装、运行与绘图分别见00_install_final_exit.json、04_execution_record.json、05_replot_record.json。运行编号不代表不同数据或挑选种子；数据与seed未更换。
