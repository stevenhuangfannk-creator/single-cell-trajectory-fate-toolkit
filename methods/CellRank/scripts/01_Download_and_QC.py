"""先核查官方文件大小；失败保留证据，不用非官方替代数据。"""
import urllib.request,urllib.error
url='https://ndownloader.figshare.com/files/35826944';dest=DATA/'bone_marrow.h5ad'
record=dict(date='2026-10-21',url=url,official_reference='https://github.com/scverse/cellrank/blob/v2.3.3/src/cellrank/datasets.py',expected_shape=[5780,27876],budget_bytes=CFG['max_download_bytes'],raw_data_redistributed=False)
if not dest.exists():
    try:
        with urllib.request.urlopen(urllib.request.Request(url,method='HEAD'),timeout=45) as response:
            size=response.headers.get('Content-Length');record['reported_bytes']=int(size) if size else None
            if not size:raise RuntimeError('BLOCKED: official size unknown; inspect before download')
            if int(size)>CFG['max_download_bytes']:raise RuntimeError('BLOCKED: official file exceeds 512MiB budget')
        count=0
        with urllib.request.urlopen(url,timeout=90) as response,dest.with_suffix('.part').open('wb') as stream:
            while data:=response.read(1024*1024):
                count+=len(data)
                if count>CFG['max_download_bytes']:raise RuntimeError('BLOCKED: actual file over budget')
                stream.write(data)
        dest.with_suffix('.part').rename(dest)
    except Exception as error:
        record.update(status='BLOCKED_OFFICIAL_DOWNLOAD',error=f'{type(error).__name__}: {error}',download_completed=False,sha256=None)
        if isinstance(error,urllib.error.HTTPError):record['HTTP_status']=error.code
        save_json('results/input_provenance.json',record);raise RuntimeError('BLOCKED: official bone marrow input unavailable; no inference or figures') from error
record.update(status='DOWNLOADED',bytes=dest.stat().st_size,sha256=hashlib.sha256(dest.read_bytes()).hexdigest(),download_completed=True)
save_json('results/input_provenance.json',record)
adata=sc.read_h5ad(dest)
assert adata.shape==(5780,27876) and adata.obs_names.is_unique
assert {'clusters',CFG['time_key']}<=set(adata.obs.columns)
time_values=adata.obs[CFG['time_key']].to_numpy(dtype=float)
assert np.isfinite(time_values).all(),'Do not replace missing/Inf pseudotime with zero'
adata.obs['clusters']=adata.obs['clusters'].astype('category')
save_json('results/input_audit.json',dict(shape=adata.shape,obs_keys=list(adata.obs.columns),layers=list(adata.layers),obsm=list(adata.obsm),time_range=[float(time_values.min()),float(time_values.max())],root_id_precomputed=str(adata.obs_names[np.argmin(time_values)]),root_cluster=str(adata.obs.iloc[np.argmin(time_values)]['clusters']),time_source='Official precomputed Palantir; root parameters not independently reconstructed'))
# 明确使用X表达建立邻居；不调用剪接层/速度/latent_time。
adata.layers.clear()
adata.raw=None
if sparse.issparse(adata.X):data_values=adata.X.data
else:data_values=np.asarray(adata.X)
assert np.isfinite(data_values).all() and data_values.min()>=0
# 此模块尚未获得官方输入，先审查X尺度后才能运行后续脚本。
raise RuntimeError('REVIEW_GATE: official input obtained; inspect X scale, root provenance and preprocessing before enabling 02. Current downstream plan not accepted.')
