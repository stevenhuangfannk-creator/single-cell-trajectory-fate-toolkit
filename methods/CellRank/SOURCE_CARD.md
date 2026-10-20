# CellRank 来源与方法卡 / Source card

查询：2026-10-19。本目录是第一轮审查材料，尚无新实现或方法运行。

| INSTALL_OK | INPUT_OK | RUN_OK | FIGURE_OK |
|---|---|---|---|
| NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED |

下列图件是官方功能/代表性输出登记，不是本轮生成结果。已有人体/疾病数据不自动满足输入假设；历史scTour证据见[资产审查](../../docs/first_round/trajectory_fate_review_2026-10-19/02_EXISTING_ASSETS_AUDIT.md)。

[完整结构化来源与解释边界](source.json)

论文：["CellRank 2: unified fate mapping in multiview single-cell data"](https://doi.org/10.1038/s41592-024-02303-9)；[Crossref](https://api.crossref.org/works/10.1038/s41592-024-02303-9)。身份：RESOLVED_PRIMARY_PAPER_AND_OFFICIAL_CODE。

官方：[代码](https://github.com/scverse/cellrank) / [官网或文档](https://cellrank.readthedocs.io/en/stable/)。Bioconductor：官方安装渠道见下，未确认存在官方Bioconductor包。

固定默认分支SHA：`d7821af1ff2665712b8329f0752580342abf93e4`；commit date：`2026-10-14T08:50:17Z`。 许可：BSD-3-Clause。 [许可原文](https://github.com/scverse/cellrank/blob/main/LICENSE)。

教程：[PseudotimeKernel及官方教程入口](https://cellrank.readthedocs.io/en/stable/api/_autosummary/kernels/cellrank.kernels.PseudotimeKernel.html)；[RealTimeKernel及Experimental Time教程入口](https://cellrank.readthedocs.io/en/stable/api/_autosummary/kernels/cellrank.kernels.RealTimeKernel.html)。

数据入口（未下载/未核bytes，不能据链接默认大下载）：
- [官方pancreas dataset API（小于全重编程案例；本轮未查bytes）](https://cellrank.readthedocs.io/en/stable/api/_autosummary/datasets/cellrank.datasets.pancreas.html)；BYTES_NOT_VERIFIED。
- [真实时间官方例reprogramming_schiebinger；不默认小文件](https://cellrank.readthedocs.io/en/stable/api/_autosummary/datasets/cellrank.datasets.reprogramming_schiebinger.html)；NOT_CONFIRMED_SMALL。

依赖、OS与硬件：
- `current_release`：PyPI2.3.3: Python>=3.12、NumPy>=2、anndata>=0.11、Scanpy>=1.11、SciPy>=1.14、pandas>=2.2、matplotlib>=3.9、pygpcca>=1.0.4、pygam>=0.10等。
- `optional`：petsc4py/slepc4py为PETSc可选，scVelo/moscot/JAX等额外依赖按方法分支选择；不自动添加。
- `os`：项目分类包含Windows/macOS/Linux；官方声明不等于本机验证。PETSc/SLEPc可选原生依赖需单独核查，未安装。
- `hardware`：邻居/转移矩阵稀疏计算以CPU/RAM为主；无统一GPU要求。规模和求解器影响资源，最低RAM未实测。
- `compatibility`：不能原地升级历史RegVelo Python3.10/NumPy1.26环境来满足CellRank2.3.3；拟使用版本/环境待确认。

输入：AnnData、已有kNN connectivities、adata.obs[time_key]的一维拟时序；AnnData，实验采样时间obs[time_key]必须categorical，预计算跨时间couplings或显式OT引擎；选定kernel/transition，加审查后的terminal定义；RNA velocity仅VelocityKernel分支必需。

输出：行归一化transition matrix；GPCCA macrostates、initial/terminal states；指定终末集合的fate probabilities、driver关联/趋势。

代表图：macrostates/terminal/fate probability UMAP；fate heatmap、circular projection、lineage gene trends；kernel projection/flow（注明kernel来源）。

边界：
- PseudotimeKernel的方向受输入ordering/root影响，拟时序不是实验采样时间。
- RealTimeKernel需要真实时间，横断面healthy/disease不是合法自动时间轴。
- fate概率以kernel和terminal集合为条件，不是体内观测命运频率或因果证明。

接口核查 / API contract：
- `pseudotime_signature`：PseudotimeKernel(adata, time_key, backward=False, **kwargs).compute_transition_matrix(threshold_scheme='hard', frac_to_keep=0.3, b=10.0, nu=0.5, ...)
- `pseudotime_semantics`：按已有拟时序对kNN边硬删除/软降权；time_key名字不是实验时间声明，流线也不是RNA velocity。
- `realtime_signature`：RealTimeKernel(adata, time_key, couplings=None, policy='sequential', **kwargs)
- `realtime_no_implicit_ot`：基础compute_coupling只查询couplings；None值要求子类实现，单独构造RealTimeKernel不会从表达矩阵自动求WOT。
- `external_couplings`：Mapping[(source_time,target_time)] -> ndarray/scipy sparse/AnnData；形状n_source×n_target，时间键匹配categorical类别。裸矩阵默认赋为该时间组obs顺序；建议显式named AnnData确保obs_names/var_names与对应cell IDs一致，验收有限非负与概率构造。
- `normalization_boundary`：RealTimeKernel拼接并行归一化为全细胞转移矩阵，存在阈值/自转移等选择；原WOT map是后代mass，不应被称为原始行概率。源码会对empty row发警告并填uniform，QC必须保留该变化。
- `from_wot_status`：since2.2 deprecated，planned removal3.0；官方称WOT unmaintained，可手动载入其couplings。
- `choices_requiring_user_decision`：冻结历史WOT和兼容CellRank版本；保留WOT计算，显式读取maps作为couplings传入当前RealTimeKernel；若用户明确批准另增moscot；本审查不替换WOT
- 固定release源码：[source](https://github.com/scverse/cellrank/blob/v2.3.3/src/cellrank/kernels/_real_time_kernel.py)；[source](https://github.com/scverse/cellrank/blob/v2.3.3/src/cellrank/kernels/_pseudotime_kernel.py)。

官方安装参考（**未执行**）：pip install cellrank（本轮不执行；最新2.3.3依赖不同于历史版本）。

状态：**installation=NOT_TESTED / run=NOT_TESTED / real_analysis=NOT_RUN**。
