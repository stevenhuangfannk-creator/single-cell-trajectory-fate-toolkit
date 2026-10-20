# 图件与重复运行检查

19组新科研图、57文件全部存在并可解码：PNG逐图经三张联系表查看，19张PDF单页渲染成功、19张SVG经sharp渲染成功；另检查代表性矢量渲染。白底、坐标、图例/色条和实际数据内容可见，无占位图。

图内英文显示尺度已对照代码修正文档：tradeSeq曲线纵轴是log(1+count)显示；Monocle3基因地图是% Max；热图是每基因log1p均值的行z分数。M06不混合断开分区，选全图显著且局部检出≥20%的基因，展示同一分区465个AWA注释路径细胞；此前低覆盖展示与重绘警告留在日志。

原Slingshot 79个文件逐个SHA256一致。最终三模块使用交付PowerShell入口、全新R会话串行运行，全部退出成功；47张数值TSV与此前成功运行hash完全一致。此重复验证没有重跑原Slingshot140点例。

联系表：[1](qa/contact_1.png)、[2](qa/contact_2.png)、[3](qa/contact_3.png)。机器记录见[ARTIFACT_QA.json](ARTIFACT_QA.json)，入口日志见[FINAL_USER_ENTRIES.log](FINAL_USER_ENTRIES.log)。科学一致性未确认，不因图件完成而改为PASS。
