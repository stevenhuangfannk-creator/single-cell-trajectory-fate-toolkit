# 数据契约：让结果可以比较

矩阵方向、尺度、ID、版本、供者与时间来源必须显式记录。不能仅因矩阵全是整数就认定是原始计数，也不能仅因对象字段叫raw就跳过来源追溯。转换先核对集合再显式重排；缺失或重复ID应停止，不静默取交集。

| 文件/对象 | 要求与科学含义 |
|---|---|
| cells.tsv | 唯一cell_id、原barcode、dataset/sample/donor、已确认状态与批次；真实时间有单位与来源 |
| genes.tsv | 唯一gene_id、symbol、物种与注释版本；一对多映射另表，不按大小写猜物种 |
| 原始计数 | R通常gene×cell，AnnData通常cell×gene；稀疏保存，转置和轴文件可核对 |
| expression_scale.tsv | 明确counts/normalized/log1p/integrated及处理来源；按各方法需要使用不同尺度 |
| embedding.tsv | cell_id与已确认展示坐标；各算法拟合空间另登记，不强制二维展示替代模型空间 |
| pseudotime.tsv | cell_id、method、lineage、值、根与方向、NA/不可达；不跨分支或跨方法直接平均 |
| lineage_weights.tsv | cell×lineage，保留官方权重定义；Slingshot默认权重行和可大于1，不改名为命运概率 |
| fate_probabilities.tsv | 终末身份、模型核、版本与配置；只有同细胞/同终末定义才比较 |
| coupling与transition | WOT原质量耦合和行归一化转移分开；检查非负、轴、边际、空行与填补，不只检查最终行和 |

Seurat需记录版本及assay/layer；AnnData需追溯X/raw/layers。临床疾病分组不是实验时间。单细胞是测量单位，供者/实验重复才可能支持相应层面的独立推断。大型对象只读一次，阶段结果小表和必要对象持久化；绘图不重训。

本次Slingshot的input_coordinates.tsv中cell_id是新增的本地顺序ID；它不假装原始barcode。当前例无计数/供者/真实时间，不可扩写为动态基因、疾病比较或WOT输入。
