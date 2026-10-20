# CytoTRACE2许可与执行门槛

2026-10-20已核查官方固定提交33b9c6bbb0f8591ae7c5f7799e19d6ce5fec9789的LICENSE和Python教程。软件是Stanford非商业许可，不是MIT/BSD许可；Private仓库不解除用途限制。

官方第1条："Use of the Service by any commercial entity for any purpose, including research, is prohibited."

第3条："You agree not to use the Service on behalf of any organization that is not a non-profit organization."

第5条保留未明确授予的权利，第7条授予可撤销、非独占、不可转让使用权；第4条含按现状提供及赔偿责任规定。完整条款以[官方LICENSE](https://github.com/digitalcytometry/cytotrace2/blob/33b9c6bbb0f8591ae7c5f7799e19d6ce5fec9789/LICENSE)为准。本项目不代替机构法律审查，不将有限使用权解释为上游源码、模型、数据可任意再分发。

当前已向用户确认使用性质。确认符合非商业且不代表营利机构之前，不安装或运行官方模型。商业用途应联系Stanford Office of Technology Licensing并引用S24-057；不采用改包名、删许可、换镜像等方式绕过。

拟用官方Python鼠胰腺小例2280细胞；R示范2850细胞不是同一例。输入须非log原计数或CPM/TPM，human/mouse显式指定。官方仓库树列19个模型，约157 MB未压缩，运行按单核CPU设计，模型及输入不进入Git。下载、依赖或内存如出现重大障碍，记录BLOCKED而非生成占位图片。

官方来源及下载内容SHA256记录见[来源清单](CYTOTRACE2_REVIEW_SOURCES.json)。这里只读取网页和许可，没有安装/运行软件，没有将上游代码、模型或输入纳入仓库。
