source('round3/00_Start.R',encoding='UTF-8')
for(s in c('01_Load_and_Check.R','02_Learn_and_Order.R','03_Dynamic_Genes.R','04_Plot_and_Export.R')) source(file.path(root,'methods/Monocle3/scripts',s),encoding='UTF-8')
