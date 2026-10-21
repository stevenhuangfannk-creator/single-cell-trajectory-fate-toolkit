"""CellRank独立环境入口；当前官方数据下载受阻，统计模块尚未验收。"""
import os,sys,json,time,hashlib,gc
from pathlib import Path
for key in ['OMP_NUM_THREADS','OPENBLAS_NUM_THREADS','MKL_NUM_THREADS','NUMBA_NUM_THREADS']:os.environ[key]='1'
os.environ['MPLBACKEND']='Agg'
_dll_handles=[]
if os.name=='nt' and (Path(sys.prefix)/'runtime_dlls').exists():_dll_handles.append(os.add_dll_directory(str(Path(sys.prefix)/'runtime_dlls')))
import numpy as np,pandas as pd,scanpy as sc,cellrank as cr
import matplotlib.pyplot as plt
from scipy import sparse,stats
ROOT=Path(__file__).resolve().parents[3];OUT=ROOT/'methods/CellRank';DATA=ROOT/'.local_round4/CellRank'
for folder in [DATA,OUT/'logs',OUT/'results']:folder.mkdir(parents=True,exist_ok=True)
CFG=dict(seed=0,max_download_bytes=512*1024**2,n_neighbors=30,n_pcs=30,n_hvg=2000,time_key='palantir_pseudotime',n_macrostates=8,threshold_scheme='hard',frac_to_keep=.3,threads=1)
sc.settings.n_jobs=1;cr.settings.logging_level='INFO'
def save_json(name,obj):(OUT/name).write_text(json.dumps(obj,ensure_ascii=False,indent=2,default=str)+'\n',encoding='utf-8')
def export(name):
    (OUT/'figures').mkdir(exist_ok=True)
    for ext in ['png','pdf','svg']:plt.savefig(OUT/'figures'/f'{name}.{ext}',dpi=180,bbox_inches='tight',facecolor='white')
    plt.close('all')
plt.rcParams.update({'figure.facecolor':'white','axes.facecolor':'white','svg.fonttype':'none','pdf.fonttype':42})
print('CellRank CONFIG',CFG,flush=True)
