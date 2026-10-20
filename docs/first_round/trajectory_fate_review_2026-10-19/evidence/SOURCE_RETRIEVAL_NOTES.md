# 来源检索与错误记录 / Source retrieval notes

仅记录文档/元数据检索，不是方法执行日志。未下载示例数据、未安装方法。

## 轨迹组

`network_notes`

```json
[
  "academic-search MCP未提供，按skill允许方式以Crossref API和primary docs/GitHub回退。",
  "7/7论文Crossref题名与DOI已核验；GitHub未克隆，仅API/原始manifest/README。",
  "部分BioC/DOI网页web解析器报错，标准库HTTP读取BioC页面成功；部分publisher/PMC页面验证码，交叉使用Crossref及作者官方文档。",
  "GitHub第34次附近tree API达到匿名限额；此前8库repo/commit/release信息已保存，不影响7方法核心信息。",
  "scTour猜测installation.html为404，修正至官方首页；Palantirinstallation.html不可读，使用README与pyproject。",
  "数据只记录作者链接，不请求数据文件；链接可获取性、checksum及文件大小均NOT_TESTED。",
  "本轮仅复用既有Python运行标准库网络/文件脚本，未导入7方法或R包，未改变任何项目或环境。"
]
```

## 潜能/命运组

`source_retrieval_notes`

```json
[
  "没有可用academic-search MCP；使用官方网页/GitHub只读API、固定SHA小型文本、PyPI JSON与Crossref公开API。",
  "Crossref首次因Accept header406，改application/json后通过；VECTOR429后单条重试成功。",
  "GitHub公共API对VECTOR部分endpoint限流403；Atom feed与HTML确认SHA/date，无clone。git ls-remote超时后未重试大下载。",
  "所有引用release/commit/package上传日期均不晚于2026-10-19；默认分支SHA与稳定release分开列。",
  "只读取轻量源码/网页元信息，无H5AD/RDS/训练权重下载，无安装/导入候选方法。"
]
```

`cross_method_compatibility`

```json
[
  "CellRank2.3.3 Python>=3.12/NumPy>=2 vs CytoTRACE2 Python NumPy<2：当前发布不能据此设计成一个未检验统一环境。",
  "Cell2fate旧锁定栈与现代CellRank或历史RegVelo均冲突风险高；单独冻结候选环境，未创建。",
  "WOT→CellRank兼容路线等待用户选择；不可静默替moscot。",
  "FitDevo/VECTOR各自legacy Seurat分支需保存；不要原地更新用户现有R环境。"
]
```

## 总审补充

- 旧GSEA UserGuideFrame/UserGuideTEXT地址在web读取中失败；已改用官方docs.gsea-msigdb.org文档。Scanpy一个paul15 API直链未被web工具打开，PAGA教程地址由来源卡另核，未由此宣称所有数据URL可下载。
- 本地源文件、已有scTour/RegVelo模型均未改动；历史运行的PASS不继承为新方法库PASS。
