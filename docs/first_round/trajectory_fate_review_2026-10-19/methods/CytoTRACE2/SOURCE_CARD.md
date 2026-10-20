# CytoTRACE2 来源与方法卡 / Source card

查询：2026-10-19。本目录是第一轮审查材料，尚无新实现或方法运行。

| INSTALL_OK | INPUT_OK | RUN_OK | FIGURE_OK |
|---|---|---|---|
| NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED |

下列图件是官方功能/代表性输出登记，不是本轮生成结果。已有人体/疾病数据不自动满足输入假设；历史scTour证据见[资产审查](../../02_EXISTING_ASSETS_AUDIT.md)。

[完整结构化来源与解释边界](source.json)

论文：["Improved reconstruction of single-cell developmental potential with CytoTRACE 2"](https://doi.org/10.1038/s41592-025-02857-2)；[Crossref](https://api.crossref.org/works/10.1038/s41592-025-02857-2)。身份：RESOLVED_PRIMARY_PAPER_AND_OFFICIAL_CODE。

官方：[代码](https://github.com/digitalcytometry/cytotrace2) / [官网或文档](https://cytotrace2.stanford.edu/)。Bioconductor：官方安装渠道见下，未确认存在官方Bioconductor包。

固定默认分支SHA：`33b9c6bbb0f8591ae7c5f7799e19d6ce5fec9789`；commit date：`2026-07-08T07:12:39Z`。 许可：STANFORD NON-COMMERCIAL SOFTWARE LICENSE AGREEMENT。 [许可原文](https://github.com/digitalcytometry/cytotrace2/blob/main/LICENSE)。
仅非商业用途；官方条款限制商业实体研究用途，不标MIT/BSD/无限制开源。

教程：[R官方README及两个vignettes](https://github.com/digitalcytometry/cytotrace2#usage)；[Python官方README](https://github.com/digitalcytometry/cytotrace2/tree/main/cytotrace2_python)。

数据入口（未下载/未核bytes，不能据链接默认大下载）：
- [R pancreas vignette，2850 cells（官方README）](https://drive.google.com/uc?export=download&id=1TYdQsMoDIJjoeuiTD5EO_kZgNJUyfRY2)；BYTES_NOT_VERIFIED。
- [Python pancreas表达，2280 cells；与R vignette不是同一个细胞数](https://drive.google.com/file/d/11eI1gSBoBqn9ccvBbthZ2nPW3CENsKbT/view)；BYTES_NOT_VERIFIED。

依赖、OS与硬件：
- `r`：R>=3.5.0；Seurat/SeuratObject、Matrix、data.table、dplyr、ggplot2、Rfast、RSpectra等；官方建议Seurat>=4，提示Seurat4+Matrix1.6冲突。
- `python`：cytotrace2-py 1.1.0.4: Python>=3.9、NumPy<2、torch>=2、Scanpy、AnnData、SciPy、scikit-learn>=1.0.2、gdown。
- `os`：Windows/macOS/Linux实际兼容性本轮均NOT_TESTED；不从R/Python可安装推断本机已通过。
- `hardware`：官方低于16GB RAM时建议max_cores/ncores设1或2；未声明本轮必须GPU，最低RAM/VRAM没有实测。

输入：基因×细胞的未log原counts或CPM/TPM；唯一gene/cell IDs。R可Seurat或矩阵，Python按官方格式；human/mouse需显式species；原注释及已有PCA/UMAP用于作图；不要求spliced/unspliced；不是RNA velocity。

输出：CytoTRACE2_Score [0,1]（高=高潜能）；六级CytoTRACE2_Potency；CytoTRACE2_Relative及preKNN预测。

代表图：保留已有UMAP，按potency score/category着色；按已有cell type的score boxplot。

边界：
- 潜能模型预测不等于真实采样时间、谱系追踪或分支命运概率；成熟炎症激活不能自动解释为去分化。
- 保留raw/CPM/TPM输入边界，不能直接把log1p/integrated/scaled值当合法输入。
- 官方后处理依赖同批细胞；跨样本batch影响须记录，原坐标/注释不为效果修改。

官方安装参考（**未执行**）：R: devtools::install_github('digitalcytometry/cytotrace2', subdir='cytotrace2_r'); Python: pip install cytotrace2-py（仅记载，未执行）

状态：**installation=NOT_TESTED / run=NOT_TESTED / real_analysis=NOT_RUN**。
