# scTour 来源与方法卡 / Source card

查询：2026-10-19。本目录是第一轮审查材料，尚无新实现或方法运行。

| INSTALL_OK | INPUT_OK | RUN_OK | FIGURE_OK |
|---|---|---|---|
| NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED |

下列图件是官方功能/代表性输出登记，不是本轮生成结果。已有人体/疾病数据不自动满足输入假设；历史scTour证据见[资产审查](../../docs/first_round/trajectory_fate_review_2026-10-19/02_EXISTING_ASSETS_AUDIT.md)。

[完整结构化来源与解释边界](source.json)

论文：[**scTour: a deep learning architecture for robust inference and accurate prediction of cellular dynamics**](https://doi.org/10.1186/s13059-023-02988-9)（Genome Biology）。DOI `10.1186/s13059-023-02988-9`；[Crossref核验](https://api.crossref.org/works/10.1186%2Fs13059-023-02988-9)。

代码：[官方仓库](https://github.com/LiQian-XC/sctour)；截至日期SHA [`4d26abb936b7872706e6540f38bab6251159a475`](https://github.com/LiQian-XC/sctour/commit/4d26abb936b7872706e6540f38bab6251159a475)，commit时间 `2025-07-20T21:29:06Z`；[固定manifest](https://raw.githubusercontent.com/LiQian-XC/sctour/4d26abb936b7872706e6540f38bab6251159a475/setup.py)。许可 **MIT**。

官方入口：[Documentation](https://sctour.readthedocs.io/en/latest/)；[Basic inference](https://sctour.readthedocs.io/en/latest/notebook/scTour_inference_basic.html)；[Direction adjustment](https://sctour.readthedocs.io/en/latest/notebook/scTour_inference_PostInference_adjustment.html)；[Publisher article](https://link.springer.com/article/10.1186/s13059-023-02988-9)。

版本注意：正式release/setup.py为1.0.0（2023-07-30），截至日期的repo SHA更新至2025-07-20；论文版另存Zenodo DOI10.5281/zenodo.7538567。 误猜installation.html得到404；真实安装说明就在docs首页。

环境：setup.py Python>=3.7；最低版本不等于与现在最新依赖组合可解。关键依赖：torch>=1.9.1、torchdiffeq>=0.2.2、numpy>=1.19.2、scanpy>=1.7.1、anndata>=0.7.5、scipy>=1.5.2、tqdm>=4.32.2、scikit-learn>=0.24.1、leidenalg>=0.8.4、教程seurat_v3 HVG另需匹配scikit-misc。

- PyTorch/ODE训练需记录CPU/GPU、设备及seed；本轮不测试CUDA或硬件。
- setup.py标OS Independent，但老教程pandas inplace及Scanpy API需兼容核查，不能认为现代依赖自动兼容。
- 官方主教程36318细胞、400epochs，不能把它当默认允许的小型测试或未经许可启动。

输入：AnnData .X为raw UMI counts用于默认nb likelihood；其他loss/表达尺度须按API另核实；计算每细胞检测基因数（先calculate_qc_metrics）并保留后再选HVG；cell×gene顺序一致。已有QC/注释、HVG策略、训练/验证切分、seed和方向审查；不要求S/U分层。

主要输出：learned pseudotime（可能须有依据地reverse）；编码与ODE混合latent space；latent vector field与保存模型；query预测为额外功能。

代表图：UMAP并列细胞注释、伪时序和vector-field stream/quiver（scanpy.pl.umap, sctour.vf.plot_vector_field）；跨数据预测/模型latent space可视化（sctour.predict（按1.0.0独立预测API核查））。

教程与示例数据：

- [教程](https://sctour.readthedocs.io/en/latest/notebook/scTour_inference_basic.html)：human cortex真实主例36318细胞，非小数据。
- [教程](https://sctour.readthedocs.io/en/latest/notebook/scTour_inference_PostInference_adjustment.html)：GSE95315颗粒细胞谱系subset4007×14545；训练前2000 HVGs。
- [GSE95315 dentate-gyrus subset（须按教程过滤）](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE95315)：原文件GSE95315_10X_expression_data_v2.tab，教程筛5类后4007细胞；未下载。规模：较主教程小但仍需训练，不是免许可即跑的toy。数据类型 `REAL_PUBLIC_EXAMPLE`；获取/运行 `NOT_TESTED`。
- [官方human cortex数据目录](https://drive.google.com/drive/folders/1zGr_Gqio8zpJWAdLj0g66kN004PyYq_x?usp=sharing)：作者教程链接，未列目录或下载数据。规模：36318细胞，NOT_SMALL。数据类型 `REAL_PUBLIC_EXAMPLE`；获取/运行 `NOT_TESTED`。

科学边界：

- 不依赖S/U不意味着测得RNA剪接动力学；latent vector field不是RegVelo/scVelo式机理速度。
- 无手动root并不保证方向正确：官方承认ODE反方向及检测基因数与发育潜能规则失效，需独立生物依据确认reverse。
- 预测未见细胞/跨数据状态不能当实验验证；batch-insensitive是作者报告性能，不是任意数据保证。
- 拟合/seed/训练收敛和外推适用范围需要另行验证，当前一律未运行。

状态：`installation=NOT_TESTED; execution=NOT_TESTED; example_run=NOT_TESTED; real_data_analysis=NOT_TESTED`。
