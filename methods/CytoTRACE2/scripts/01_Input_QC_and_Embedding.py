"""分块核查非log计数，并一次建立轻量表达UMAP；后续绘图只读小表。"""
import importlib.resources
expression_path=DATA/'Pancreas_10x_downsampled_expression.txt';annotation_path=DATA/'Pancreas_10x_downsampled_annotation.txt'
assert expression_path.exists() and annotation_path.exists(),'Run download_official.py first'
annotations=pd.read_csv(annotation_path,sep='\t',index_col=0)
blocks=[];genes=[];cell_ids=None;noninteger=0;total=0;minimum=np.inf;maximum=0
for chunk in pd.read_csv(expression_path,sep='\t',index_col=0,chunksize=500):
    if cell_ids is None:
        cell_ids=chunk.columns;depth=np.zeros(len(cell_ids));detected=depth.copy();mito=depth.copy()
    assert chunk.columns.equals(cell_ids)
    values=chunk.to_numpy(dtype=np.float32);assert np.isfinite(values).all() and (values>=0).all()
    minimum=min(minimum,float(values.min()));maximum=max(maximum,float(values.max()))
    noninteger+=int(np.sum(values!=np.floor(values)));total+=values.size
    depth+=values.sum(axis=0,dtype=np.float64);detected+=(values>0).sum(axis=0)
    mt=chunk.index.astype(str).str.lower().str.startswith('mt-');mito+=values[mt].sum(axis=0,dtype=np.float64)
    blocks.append(sparse.csr_matrix(values));genes.extend(chunk.index.astype(str))
# 官方README写2280，但当前官方同链接表达/注释均为2850；完整保留，禁止截取凑数。
assert len(cell_ids)==2850 and cell_ids.is_unique and pd.Index(genes).is_unique
assert annotations.index.is_unique and set(cell_ids)==set(annotations.index)
matrix=sparse.vstack(blocks,format='csr').T.tocsr();del blocks,chunk,values;gc.collect()
metadata=annotations.loc[cell_ids].iloc[:,[0]].rename(columns={annotations.columns[0]:'phenotype'})
metadata['n_counts']=depth;metadata['n_genes']=detected;metadata['mito_fraction']=mito/np.maximum(depth,1)
assert (detected>=200).all(),'Explicitly audit cells failing official plotting min_genes before proceeding'
adata=sc.AnnData(matrix,obs=metadata.copy(),var=pd.DataFrame(index=genes))
sc.pp.filter_genes(adata,min_cells=3);sc.pp.normalize_total(adata,target_sum=1e4);sc.pp.log1p(adata)
sc.pp.highly_variable_genes(adata,n_top_genes=CFG['embedding_hvg']);adata=adata[:,adata.var['highly_variable']].copy()
sc.pp.scale(adata,max_value=10);sc.tl.pca(adata,n_comps=CFG['embedding_pcs'],svd_solver='arpack',random_state=CFG['seed'])
sc.pp.neighbors(adata,n_neighbors=CFG['embedding_neighbors'],n_pcs=CFG['embedding_pcs'],random_state=CFG['seed'])
sc.tl.umap(adata,random_state=CFG['seed'])
metadata['UMAP1']=adata.obsm['X_umap'][:,0];metadata['UMAP2']=adata.obsm['X_umap'][:,1]
metadata.to_csv(OUT/'results/input_QC_embedding.csv',index_label='cell_id')
features=pd.read_csv(importlib.resources.files('cytotrace2_py')/'resources/features_model_training.csv')['0'].astype(str)
save_json('results/input_audit.json',dict(cells=len(cell_ids),official_readme_reported_cells=2280,official_link_actual_cells=2850,no_cell_subsampling=True,genes=len(genes),species='mouse',minimum=minimum,maximum=maximum,noninteger_fraction=noninteger/total,unique_gene_cell_IDs=True,annotation_ID_set_exact=True,detected_genes_range=[int(min(detected)),int(max(detected))],count_range=[int(min(depth)),int(max(depth))],exact_model_feature_overlap=len(set(genes)&set(features)),model_features=len(features),gene_symbols_before_alias_mapping=True,embedding='Independent display only: log1p 1e4-normalized counts, 2000 HVG, PCA50, kNN15, seed14; no normalized data passed to potency model'))
shutil_import=__import__('shutil');shutil_import.copyfile(DATA/'download_provenance.json',OUT/'results/input_download_provenance.json')
del adata,matrix,genes,features,depth,detected,mito;gc.collect()
print('INPUT_AND_EMBEDDING_PASS',flush=True)
