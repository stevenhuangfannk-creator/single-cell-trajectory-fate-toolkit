# CytoTRACE2许可与执行门槛

最新状态（2026-10-21）：非商业用途已确认，官方API小例通过。下方2026-10-20暂停判断保留为历史记录；其中Python示例2280的教程文字与当前官方链接实际2850不符，已在完整指南及输入审计中更正。

2026-10-20已核查官方固定提交33b9c6bbb0f8591ae7c5f7799e19d6ce5fec9789的LICENSE和Python教程。软件是Stanford非商业许可，不是MIT/BSD许可；Private仓库不解除用途限制。

官方第1条："Use of the Service by any commercial entity for any purpose, including research, is prohibited."

第3条："You agree not to use the Service on behalf of any organization that is not a non-profit organization."

第5条保留未明确授予的权利，第7条授予可撤销、非独占、不可转让使用权；第4条含按现状提供及赔偿责任规定。完整条款以[官方LICENSE](https://github.com/digitalcytometry/cytotrace2/blob/33b9c6bbb0f8591ae7c5f7799e19d6ce5fec9789/LICENSE)为准。本项目不代替机构法律审查，不将有限使用权解释为上游源码、模型、数据可任意再分发。

当前已向用户确认使用性质。确认符合非商业且不代表营利机构之前，不安装或运行官方模型。商业用途应联系Stanford Office of Technology Licensing并引用S24-057；不采用改包名、删许可、换镜像等方式绕过。

拟用官方Python鼠胰腺小例2280细胞；R示范2850细胞不是同一例。输入须非log原计数或CPM/TPM，human/mouse显式指定。官方仓库树列19个模型，约157 MB未压缩，运行按单核CPU设计，模型及输入不进入Git。下载、依赖或内存如出现重大障碍，记录BLOCKED而非生成占位图片。

官方来源及下载内容SHA256记录见[来源清单](CYTOTRACE2_REVIEW_SOURCES.json)。这里只读取网页和许可，没有安装/运行软件，没有将上游代码、模型或输入纳入仓库。


## 2026-10-21继续执行

用户针对上述用途问题回复“非商业用途”，已记录[确认](CYTOTRACE2_USE_CONFIRMATION.json)。据此继续本次非商业科研官方小例；不推断用户机构身份，也不扩大上游源码/模型/数据的再分发权。此前未安装/未运行描述为2026-10-20暂停时的历史状态，实际运行以最新方法STATUS为准。

## 2026-10-21最新执行状态
用户用途确认后已完成官方API非商业小例。19模型仅本地使用；官方源码、模型与输入未再分发。INSTALL/INPUT/RUN/FIGURE/中文教程已验收，先前BLOCKED记录是历史暂停点。最新状态见../../methods/CytoTRACE2/STATUS.json。
