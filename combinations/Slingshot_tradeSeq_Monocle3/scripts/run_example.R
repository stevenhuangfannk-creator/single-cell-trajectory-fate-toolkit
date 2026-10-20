source('round3/00_Start.R',encoding='UTF-8')
for(s in c('01_Common_Input.R','02_Independent_Trajectories.R','03_Compare_and_Dynamic.R','04_Plot_and_Export.R')) source(file.path(root,'combinations/Slingshot_tradeSeq_Monocle3/scripts',s),encoding='UTF-8')
if(file.exists(file.path(root,'combinations/Slingshot_tradeSeq_Monocle3/example_data/worm_GO_BP_membership.tsv'))) source(file.path(root,'combinations/Slingshot_tradeSeq_Monocle3/scripts/06_Functional_Analysis.R'),encoding='UTF-8')
source(file.path(root,'combinations/Slingshot_tradeSeq_Monocle3/scripts/07_Sensitivity_No_Alignment.R'),encoding='UTF-8')
