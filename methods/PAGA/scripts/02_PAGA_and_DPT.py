"""按官方Paul15教程的表达/扩散邻居流程；采用官方群注释以减少聚类先验变化。"""
started=time.perf_counter()
sc.pp.recipe_zheng17(adata)
sc.tl.pca(adata,svd_solver='arpack',random_state=CFG['seed'])
sc.pp.neighbors(adata,n_neighbors=CFG['first_neighbors'],n_pcs=CFG['n_pcs'],random_state=CFG['seed'])
sc.tl.diffmap(adata,n_comps=CFG['diffmap_components'],random_state=CFG['seed'])
sc.pp.neighbors(adata,n_neighbors=CFG['final_neighbors'],use_rep='X_diffmap',random_state=CFG['seed'])
sc.tl.paga(adata,groups=CFG['group'])
# 官方绘图函数产生群图布局供init_pos='paga'使用；不是额外轨迹模型。
sc.pl.paga(adata,threshold=CFG['display_threshold'],show=False,random_state=CFG['seed']);plt.close('all')
sc.tl.umap(adata,init_pos='paga',random_state=CFG['seed'])
adata.uns['iroot']=CFG['root_index']
sc.tl.dpt(adata,n_dcs=10)
groups=adata.obs[CFG['group']].cat.categories.tolist()
conn=adata.uns['paga']['connectivities'].toarray()
pd.DataFrame(conn,index=groups,columns=groups).to_csv(OUT/'results/PAGA_connectivities.csv')
edges=[dict(group_a=groups[i],group_b=groups[j],connectivity=conn[i,j],shown=bool(conn[i,j]>=CFG['display_threshold'])) for i in range(len(groups)) for j in range(i+1,len(groups)) if conn[i,j]>0]
pd.DataFrame(edges).to_csv(OUT/'results/PAGA_edges.csv',index=False)
cells=adata.obs.copy();cells['UMAP1']=adata.obsm['X_umap'][:,0];cells['UMAP2']=adata.obsm['X_umap'][:,1]
cells.to_csv(OUT/'results/cell_statistics.csv',index_label='cell_id')
finite=np.isfinite(adata.obs['dpt_pseudotime'])
qc=[]
for key in ['provided_gene_sum','detected_provided_genes']:
    rho,pvalue=stats.spearmanr(adata.obs.loc[finite,'dpt_pseudotime'],adata.obs.loc[finite,key])
    qc.append(dict(comparison=key,spearman_rho=float(rho),descriptive_p=float(pvalue),n=int(finite.sum())))
pd.DataFrame(qc).to_csv(OUT/'results/DPT_QC_correlations.csv',index=False)
adata.write_h5ad(DATA/'processed.h5ad',compression='gzip')
save_json('results/run_summary.json',dict(cells=adata.n_obs,selected_genes=adata.n_vars,groups=len(groups),nonzero_undirected_edges=len(edges),displayed_edges=sum(x['shown'] for x in edges),finite_DPT=int(finite.sum()),infinite_DPT=int((~finite).sum()),parameters=CFG,seconds=time.perf_counter()-started,threads=1,workflow_adaptations=['official supplied paul15_clusters instead of new louvain labels/manual renaming','PAGA-initialized UMAP instead of ForceAtlas2 draw_graph','dataset default root index 840; not retuned for attractive ordering']))
print('RUN_PASS',flush=True)
