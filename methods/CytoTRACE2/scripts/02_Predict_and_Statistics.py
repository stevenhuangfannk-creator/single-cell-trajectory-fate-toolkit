"""官方public API预测；原计数文件传入模型，独立UMAP不参与预测。"""
import importlib.resources
from cytotrace2_py import cytotrace2
from cytotrace2_py.common.gen_utils import check_and_download_models
if 'metadata' not in globals():
    expression_path=DATA/'Pancreas_10x_downsampled_expression.txt'
    annotation_path=DATA/'Pancreas_10x_downsampled_annotation.txt'
    metadata=pd.read_csv(OUT/'results/input_QC_embedding.csv',index_col=0)
# PyPI包首次使用需由官方帮助函数下载19个模型；不修改第三方源码。
check_and_download_models()
resource=Path(str(importlib.resources.files('cytotrace2_py')/'resources'))
model_files=sorted((resource/'models').glob('*.pt'))
save_json('results/model_manifest.json',dict(model_count=len(model_files),models=[dict(file=x.name,bytes=x.stat().st_size,sha256=hashlib.sha256(x.read_bytes()).hexdigest()) for x in [*model_files,resource/'background.pt']],official_source='cytotrace2-py 1.1.0.4 PyPI distribution; upstream source/model not redistributed'))
assert len(model_files)==19
start=time.perf_counter();old_cwd=Path.cwd();os.chdir(DATA)
(DATA/'inference').mkdir(exist_ok=True)
try:
    predictions=cytotrace2(str(expression_path),annotation_path=str(annotation_path),species=CFG['species'],batch_size=CFG['batch_size'],smooth_batch_size=CFG['smooth_batch_size'],disable_parallelization=True,max_cores=1,seed=CFG['seed'],output_dir='inference',disable_plotting=True)
finally:os.chdir(old_cwd)
assert predictions.index.is_unique and set(predictions.index)==set(metadata.index)
assert np.isfinite(predictions['CytoTRACE2_Score']).all() and predictions['CytoTRACE2_Score'].between(0,1).all()
cells=metadata.join(predictions.loc[metadata.index]);cells.to_csv(OUT/'results/potency_cell_statistics.csv',index_label='cell_id')
cells.groupby('phenotype',observed=True)['CytoTRACE2_Score'].agg(['size','median','mean','min','max']).to_csv(OUT/'results/phenotype_score_summary.csv')
cells['CytoTRACE2_Potency'].value_counts(sort=False).to_csv(OUT/'results/potency_category_counts.csv')
correlations=[]
for group,subset in [('ALL',cells),*[(str(k),v) for k,v in cells.groupby('phenotype',observed=True) if len(v)>=20]]:
    for metric in ['n_counts','n_genes','mito_fraction']:
        rho,pvalue=stats.spearmanr(subset['CytoTRACE2_Score'],subset[metric])
        correlations.append(dict(group=group,metric=metric,n=len(subset),spearman_rho=float(rho),pvalue=float(pvalue)))
corr=pd.DataFrame(correlations);valid=corr.pvalue.notna();corr.loc[valid,'BH_FDR_descriptive']=multipletests(corr.loc[valid,'pvalue'],method='fdr_bh')[1];corr.to_csv(OUT/'results/QC_correlations.csv',index=False)
rho,pvalue=stats.spearmanr(cells['CytoTRACE2_Score'],cells['preKNN_CytoTRACE2_Score'])
save_json('results/run_summary.json',dict(cells=len(cells),predictions_finite=True,score_min=float(cells.CytoTRACE2_Score.min()),score_max=float(cells.CytoTRACE2_Score.max()),category_counts={str(k):int(v) for k,v in cells.CytoTRACE2_Potency.value_counts().items()},parameters=CFG,inference_seconds=time.perf_counter()-start,pre_post_spearman=float(rho),CPU_threads=1,model_source_not_modified=True,limitations=['cell-level descriptive correlations; no donors/causal claims','independent lightweight UMAP instead of upstream built-in rendering','small official example not PI or inflammation reprogramming evidence']))
print('PREDICTION_PASS',flush=True)
