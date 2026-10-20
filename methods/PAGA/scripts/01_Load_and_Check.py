"""取得官方小数据；仅本地保存，不上传原始HDF5。"""
import urllib.request
dest=DATA/'paul15/paul15.h5';dest.parent.mkdir(exist_ok=True)
url='https://exampledata.scverse.org/scanpy/paul15.h5'
if not dest.exists():
    request=urllib.request.Request(url,headers={'User-Agent':'Mozilla/5.0'})
    with urllib.request.urlopen(request,timeout=90) as response,dest.with_suffix('.part').open('wb') as target:
        total=0
        while block:=response.read(1024*1024):
            total+=len(block)
            if total>64*1024**2:raise RuntimeError('Official small input exceeds 64 MiB budget')
            target.write(block)
    dest.with_suffix('.part').rename(dest)
adata=sc.datasets.paul15()
assert adata.shape==(2730,3451)
assert adata.obs_names.is_unique and adata.var_names.is_unique
x=np.asarray(adata.X)
assert np.isfinite(x).all() and x.min()>=0
adata.obs['provided_gene_sum']=x.sum(axis=1)
adata.obs['detected_provided_genes']=(x>0).sum(axis=1)
for gene in ['Hba-a2','Elane','Irf8','Itga2b']:
    adata.obs['marker_'+gene]=np.log1p(x[:,adata.var_names.get_loc(gene)]/np.maximum(x.sum(axis=1),1)*1e4)
save_json('results/input_provenance.json',dict(url=url,bytes=dest.stat().st_size,sha256=hashlib.sha256(dest.read_bytes()).hexdigest(),cells=adata.n_obs,provided_genes=adata.n_vars,minimum=float(x.min()),fraction_noninteger=float(np.mean(x!=np.floor(x))),species='mouse',data_note='Official data.debatched nonlog informative-gene matrix; not unqualified raw integer counts or full library depth',unique_cell_ids=True,unique_gene_ids=True,root_index=CFG['root_index'],root_cell=str(adata.obs_names[CFG['root_index']]),root_cluster=str(adata.obs.iloc[CFG['root_index']][CFG['group']])))
print('INPUT_PASS',adata,flush=True)
