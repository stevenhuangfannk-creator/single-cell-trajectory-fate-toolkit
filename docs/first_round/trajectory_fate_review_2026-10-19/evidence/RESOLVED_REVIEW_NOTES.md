# 审查修正收据 / Review corrections

两份独立只读复核未发现阻断第一轮交付的问题。`fate_combination_review.md`列出的三项重要措辞修正均已纳入当前文档：

1. 04的E模块明确Cell2fate真实S/U raw UMI counts，删除未建立依据的“预训练”能力表述。
2. 04的C模块补充CytoTRACE2未log raw/CPM/TPM与FitDevo未scaled输入及NORM选择。
3. 05明确CytoTRACE2 NumPy<2与当前CellRank NumPy≥2的互斥。

另在F模块补充RealTimeKernel不会自动求OT，以及空行可能被填uniform的警告审查，避免只看最终行和就误判输入有效。两份原审查记录保留检查时的内容和行号，当前行号可能因补充变化。

这些修改仅完善说明，没有执行方法或提高任何运行状态。所有INSTALL_OK/INPUT_OK/RUN_OK/FIGURE_OK仍NOT_TESTED。
