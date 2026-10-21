"""CytoTRACE2官方小例统一参数；非商业使用已由用户确认。"""
import os,sys,gc,time,json,hashlib
from pathlib import Path
for key in ['OMP_NUM_THREADS','OPENBLAS_NUM_THREADS','MKL_NUM_THREADS','NUMBA_NUM_THREADS']:os.environ[key]='1'
os.environ['MPLBACKEND']='Agg'
_dll_handles=[]
if os.name=='nt' and (Path(sys.prefix)/'runtime_dlls').exists():_dll_handles.append(os.add_dll_directory(str(Path(sys.prefix)/'runtime_dlls')))
import numpy as np,pandas as pd,scanpy as sc,torch
import matplotlib.pyplot as plt
from scipy import sparse,stats
from statsmodels.stats.multitest import multipletests
ROOT=Path(__file__).resolve().parents[3];OUT=ROOT/'methods/CytoTRACE2';DATA=ROOT/'.local_round4/CytoTRACE2'
for directory in [DATA,*[OUT/d for d in ['results','figures','logs','figure_notes']]]:directory.mkdir(parents=True,exist_ok=True)
# 完整单批2850触发资源保护；官方支持分批，保留全部细胞且不修改模型。
CFG=dict(species='mouse',seed=14,batch_size=1000,smooth_batch_size=1000,disable_parallelization=True,max_cores=1,disable_plotting=True,embedding_hvg=2000,embedding_pcs=50,embedding_neighbors=15)
torch.set_num_threads(1);torch.set_num_interop_threads(1);sc.settings.n_jobs=1
np.random.seed(CFG['seed']);sc.settings.verbosity=2
plt.rcParams.update({'figure.facecolor':'white','axes.facecolor':'white','svg.fonttype':'none','pdf.fonttype':42})
def save_json(name,obj):(OUT/name).write_text(json.dumps(obj,ensure_ascii=False,indent=2,default=str)+'\n',encoding='utf-8')
def export(name):
    for ext in ['png','pdf','svg']:plt.savefig(OUT/'figures'/f'{name}.{ext}',bbox_inches='tight',facecolor='white',dpi=180)
    plt.close('all')
print('CytoTRACE2 CONFIG',CFG,flush=True)
