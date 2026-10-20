# 第三方材料、来源与再分发

本地交付尚未发布远程GitHub。链接可访问不等于许可允许复制；项目自己的说明不能替代第三方许可。

## Slingshot官方模拟例与改写代码

来源：[作者仓库](https://github.com/kstreet13/slingshot)、[BioC3.23 slingshot 2.20.0](https://bioconductor.org/packages/3.23/bioc/html/slingshot.html)，作者与引用见软件citation及原论文 [DOI](https://doi.org/10.1186/s12864-018-4772-0)。官方包声明Artistic-2.0。本地保留未修改随包文件 `methods/Slingshot/example_data/slingshotExample.rda`，并导出可检查的140行坐标/标签小表；未找到本示例另行标注的独立许可，按包内材料保留包许可与归属，不扩大为原始论文所有数据都可自由分发。

许可全文见 [Artistic-2.0.txt](third_party/Slingshot/Artistic-2.0.txt)，从R项目许可站点 <https://svn.r-project.org/R/trunk/share/licenses/Artistic-2.0> 获取。随包原文件hash见输入登记；对外再分发时需连同本说明和许可保留。安装包、R、全部依赖二进制和运行时不随本ZIP分发。

本项目01/02脚本明确为官方教程思路的改写，保留来源段落与版本；添加数据检查、ID、日志、统计和导出。03绘图为本次结果的新增可编辑展示代码。生成图来自本地计算，未拷贝官方截图；许可说明不意味着官方作者为本项目解释或结论背书。

## 第一轮审查与其他方法

`docs/first_round/`为用户提供ZIP的原样副本，包含用户既有资产路径与私有GitHub链接；本地保留用于溯源，未来公开前需要复核可发布范围。这句话对应第二轮范围：其他13种当时只有来源卡。第三轮已实际安装tradeSeq/Monocle3并生成图表；剩余11种仍未新增复现。

scTour历史图仍引用Private旧库，访问权限不因新平台而扩大。RegVelo保持独立。CytoTRACE2非商业条款、FitDevo/VECTOR未明确许可和WOT旧维护状况均按第一轮记录保留，未经新核查不假定允许安装或再分发。

原始患者数据、完整大对象、模型、访问凭据与环境不应进入未来仓库；本轮没有读取真实PI数据。选择仓库整体许可证时须将自写材料、改写代码、第三方示例与数据分开处理，不给整个材料包套一个会覆盖第三方权利的许可证。


## 第三轮新增材料

tradeSeq包MIT声明的2019版权持有人为Koen Van den Berge、Hector Roux de Bezieux；Monocle3为2019 Cole Trapnell。分别保留[tradeSeq版权](third_party/tradeSeq/COPYRIGHT.txt)、[Monocle3版权](third_party/Monocle3/COPYRIGHT.txt)及R发行版MIT模板。官方代码未做方法逻辑修改；本项目脚本新增输入核查、记录、统计导出和图件解释。运行时、依赖二进制、源码包/工具链缓存不进入Git。

官方示例数据已保留来源、筛选说明和hash；包许可声明不自动替代Paul/Packer原始研究数据的独立权利。新方法的输入/拟合RDS本地保留并由.gitignore排除未来Git候选；可用脚本从已安装官方包重新取得小输入。图件是本地计算，并非官方截图；作者不为本项目推论背书。

GO派生基因集来自Gene Ontology Consortium及WormBase，以[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)使用，遵循[GO许可与引用政策](https://geneontology.org/docs/go-citation-policy/)。本次GAF头日期2026-05-21，OBO标注releases/2026-07-26，均于2026-10-19获取；不可将它们写成同一个统一新发布。处理包括线虫/生物过程筛选、排除NOT/IEA、沿is_a/part_of传播、与官方10,000基因宇宙相交和去重。来源URL、原文件SHA256及修改规则见[GO_provenance](combinations/Slingshot_tradeSeq_Monocle3/example_data/GO_provenance.json)。派生文件不是GO或WormBase官方发布品。依CC BY 4.0第5条，许可材料按现状提供，不提供担保。保留Gene Ontology Consortium及WormBase的署名、原始来源与许可；原始文件若有附加版权/归属通知，应一并遵循。

项目自写代码/中文说明的统一许可证尚待仓库所有者决定；目前不为所有材料强加一个总许可。公开前还须复核原样历史档案中的私人路径、Private项目链接和其他作者条款。见[发布前审查](docs/GITHUB_PREPUBLICATION_CN.md)。
