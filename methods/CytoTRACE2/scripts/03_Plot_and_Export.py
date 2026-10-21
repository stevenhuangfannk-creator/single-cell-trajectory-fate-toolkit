"""所有科研图只读同一小型结果表，不重新读表达或预测模型。"""
if 'cells' not in globals():cells=pd.read_csv(OUT/'results/potency_cell_statistics.csv',index_col=0)
types=sorted(cells.phenotype.unique());palette=dict(zip(types,plt.colormaps['tab20'].colors));xy=cells[['UMAP1','UMAP2']].to_numpy()
fig,axes=plt.subplots(1,2,figsize=(12,5))
for label in types:
    sel=cells.phenotype==label;axes[0].scatter(xy[sel,0],xy[sel,1],s=6,color=palette[label],label=label)
axes[0].legend(fontsize=7,loc='best');axes[0].set_title('Official phenotype')
im=axes[1].scatter(*xy.T,c=cells.CytoTRACE2_Score,s=6,cmap='viridis',vmin=0,vmax=1);fig.colorbar(im,ax=axes[1],label='Predicted potency score');axes[1].set_title('CytoTRACE2 prediction')
for ax in axes:ax.set(xlabel='UMAP1',ylabel='UMAP2')
export('CT01_potency_UMAP')
order=['Differentiated','Unipotent','Oligopotent','Multipotent','Pluripotent','Totipotent'];colors=plt.colormaps['Spectral_r'](np.linspace(.08,.92,6));fig,axes=plt.subplots(1,2,figsize=(12,5))
for label,color in zip(order,colors):
    sel=cells.CytoTRACE2_Potency==label;axes[0].scatter(xy[sel,0],xy[sel,1],s=6,color=color,label=f'{label} (n={int(sel.sum())})')
axes[0].legend(fontsize=7);axes[0].set(xlabel='UMAP1',ylabel='UMAP2',title='Predicted potency category')
axes[1].barh(order,[int((cells.CytoTRACE2_Potency==k).sum()) for k in order],color=colors);axes[1].set(xlabel='Cells',title='Six model-defined categories');export('CT02_potency_categories')
order_types=cells.groupby('phenotype',observed=True).CytoTRACE2_Score.median().sort_values(ascending=False).index.tolist();fig,ax=plt.subplots(figsize=(10,5));values=[cells.loc[cells.phenotype==k,'CytoTRACE2_Score'].to_numpy() for k in order_types]
parts=ax.violinplot(values,showmedians=True,showextrema=False)
for body,label in zip(parts['bodies'],order_types):body.set_facecolor(palette[label]);body.set_alpha(.8)
ax.set_xticks(range(1,len(order_types)+1),order_types,rotation=45,ha='right');ax.set(ylabel='Predicted potency score',ylim=(0,1),title='Distributions by official phenotype (not biological replicates)');export('CT03_phenotype_violin')
fig,axes=plt.subplots(1,2,figsize=(12,5))
for ax,metric,label in zip(axes,['n_counts','n_genes'],['log10 total counts','Detected genes']):
    x=np.log10(cells[metric]) if metric=='n_counts' else cells[metric]
    for phenotype in types:
        sel=cells.phenotype==phenotype;ax.scatter(x[sel],cells.loc[sel,'CytoTRACE2_Score'],s=5,color=palette[phenotype],alpha=.6,label=phenotype)
    rho=stats.spearmanr(cells[metric],cells.CytoTRACE2_Score).statistic;ax.set(xlabel=label,ylabel='Predicted potency score',title=f'All-cell Spearman rho={rho:.3f}',ylim=(0,1))
axes[1].legend(fontsize=7,loc='upper left',bbox_to_anchor=(1,1));export('CT04_technical_confounding')
fig,ax=plt.subplots(figsize=(6,5));delta=cells.CytoTRACE2_Score-cells.preKNN_CytoTRACE2_Score
im=ax.scatter(cells.preKNN_CytoTRACE2_Score,cells.CytoTRACE2_Score,c=delta,cmap='coolwarm',s=8);ax.plot([0,1],[0,1],'--',color='grey',lw=1);fig.colorbar(im,ax=ax,label='Final minus preKNN score');ax.set(xlabel='preKNN score',ylabel='Final smoothed score',xlim=(0,1),ylim=(0,1),title='Postprocessing changes predictions');export('CT05_smoothing_comparison')
print('FIGURE_PASS 5 groups / 15 formats',flush=True)
