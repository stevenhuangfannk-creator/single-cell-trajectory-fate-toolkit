# PAGA 来源与方法卡 / Source card

查询：2026-10-19。本目录是第一轮审查材料，尚无新实现或方法运行。

| INSTALL_OK | INPUT_OK | RUN_OK | FIGURE_OK |
|---|---|---|---|
| NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED |

下列图件是官方功能/代表性输出登记，不是本轮生成结果。已有人体/疾病数据不自动满足输入假设；历史scTour证据见[资产审查](../../02_EXISTING_ASSETS_AUDIT.md)。

[完整结构化来源与解释边界](source.json)

论文：[**PAGA: graph abstraction reconciles clustering with trajectory inference through a topology preserving map of single cells**](https://doi.org/10.1186/s13059-019-1663-x)（Genome Biology）。DOI `10.1186/s13059-019-1663-x`；[Crossref核验](https://api.crossref.org/works/10.1186%2Fs13059-019-1663-x)。

代码：[官方仓库](https://github.com/scverse/scanpy)；截至日期SHA [`8ed52d9dad906c260e52405380ed4ed1e353d4e7`](https://github.com/scverse/scanpy/commit/8ed52d9dad906c260e52405380ed4ed1e353d4e7)，commit时间 `2026-10-15T12:11:54Z`；[固定manifest](https://raw.githubusercontent.com/scverse/scanpy/8ed52d9dad906c260e52405380ed4ed1e353d4e7/pyproject.toml)。许可 **BSD-3-Clause**。

官方入口：[Original paper repository](https://github.com/theislab/paga)；[API](https://scanpy.readthedocs.io/en/stable/api/scanpy.tl.paga.html)；[Official tutorial](https://scanpy.readthedocs.io/en/stable/tutorials/trajectories/paga-paul15.html)；[Publisher paper](https://link.springer.com/article/10.1186/s13059-019-1663-x)。

版本注意：正式算法使用Scanpy1.12.4（2026-08-27）；1.13.0a2为预发布，不作当前稳定版。 另记录theislab/paga原论文notebook库SHA，避免把2019 notebook环境当现行依赖。

环境：稳定Scanpy1.12.4的pyproject：Python>=3.12；审查时main需>=3.13，不能混作稳定要求。关键依赖：anndata>=0.10.8、numpy>=2、scipy>=1.13、pandas>=2.3、scikit-learn>=1.6、numba>=0.60、matplotlib>=3.10、umap-learn>=0.5.12、PAGA extra: igraph、Leiden extra: igraph>=0.10.8, leidenalg>=0.10.1。

- PAGA本身不需GPU；Scanpy元数据列Windows/macOS/Linux，但本机未测试。
- 旧教程的scanpy/igraph/ForceAtlas2接口与当前稳定版可能不同；ForceAtlas2不是PAGA算法的必需输入。
- 不要在已锁定旧版AnnData/NumPy的RegVelo环境中直接升级到当前Scanpy栈。

输入：AnnData已有低维表示和cell kNN图；adata.obs中的categorical分组；.uns['neighbors']与.obsp的connectivities/distances；已有注释可作groups。保留已有cluster/embedding，记录neighbors参数和阈值；DPT若使用需另给iroot。

主要输出：partition级connectivities及tree子图（实际位于.uns['paga']）；可用于初始化UMAP/graph layout的partition位置；若另运行DPT则得到root相关dpt_pseudotime；PAGA单独不提供每细胞时钟。

代表图：节点大小/边权的PAGA图和单细胞layout对照（scanpy.pl.paga, scanpy.pl.paga_compare）；指定PAGA path的基因表达趋势热图（scanpy.pl.paga_path）。

教程与示例数据：

- [教程](https://scanpy.readthedocs.io/en/stable/tutorials/trajectories/paga-paul15.html)：2730个真实小鼠造血细胞的Paul15教程。
- [Paul et al. 2015](https://scanpy.readthedocs.io/en/stable/generated/scanpy.datasets.paul15.html)：scanpy.datasets.paul15()；会触发数据下载，本轮未调用。规模：官方PAGA README记2730细胞；文件大小未请求核实。数据类型 `REAL_PUBLIC_EXAMPLE`；获取/运行 `NOT_TESTED`。

科学边界：

- 边权为分组间实际/随机期望连接的比值型置信度，官方明确不是p值，也不是命运转移概率。
- 默认无方向；PAGA图不是谱系追踪，不能从两簇连接直接断言分化方向或细胞转换。
- use_rna_velocity=True需要真实预先计算的velocity_graph，普通表达矩阵不能伪造该输入。
- 文档returns字段部分简写为.uns['connectivities']；固定源码实际嵌套于.uns['paga']，后续实现须按选定版本核查。

状态：`installation=NOT_TESTED; execution=NOT_TESTED; example_run=NOT_TESTED; real_data_analysis=NOT_TESTED`。
