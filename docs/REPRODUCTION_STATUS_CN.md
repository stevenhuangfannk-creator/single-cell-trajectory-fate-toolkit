# 当前复现验收（第三轮）

| 对象 | INSTALL | INPUT | RUN | FIGURE | 中文教程/科学边界 |
|---|---|---|---|---|---|
| Slingshot原140点例 | PASS | PASS | PASS | 6组PASS | 原79文件校验不变，另有第三轮补充 |
| tradeSeq官方240×2660 | PASS | PASS | PASS，默认association 126 NA保留 | 5组PASS | 完整教程；Chol/eigen敏感性、FDR、预筛面板局限 |
| Monocle3官方10000×1805 | PASS，警告保留 | PASS | PASS | 6组PASS | 完整教程；3分区独立根、Moran与索引保存局限 |
| 同650细胞组合 | PASS | PASS，ID显式校核 | PASS，真实联合运行 | 7主图+1敏感性PASS | 科学可比性PARTIAL，AWA终点FAIL，共识未确认 |

47张数值结果表在最终用户入口重跑后hash完全一致；19组新图的PNG/PDF/SVG均实际生成并检查。原六大组合教程仍是设计，不因为新模块部分覆盖A/B问题就标成全部已运行。其他11种方法仍是历史来源审查，scTour历史PARTIAL保留。

详见[中文交付总结](ROUND3_DELIVERY_CN.md)、[机器验收](../ACCEPTANCE.json)、[图件校验](round3/ARTIFACT_QA.json)和[组合冲突](../combinations/Slingshot_tradeSeq_Monocle3/AGREEMENT_LIMITATIONS_CN.md)。未运行真实PI、未创建/修改远程。
