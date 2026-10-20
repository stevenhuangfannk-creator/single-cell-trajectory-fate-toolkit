"""PAGA参数集中入口；只使用独立Python环境，单线程执行。"""
import os
import sys
from pathlib import Path
# 本机缺MSVCP140：仅搜索独立环境的运行库目录，不修改系统或第三方源代码。
_dll_handles=[]
if os.name=='nt' and (Path(sys.prefix)/'runtime_dlls').is_dir():
    _dll_handles.append(os.add_dll_directory(str(Path(sys.prefix)/'runtime_dlls')))
for key in ['OMP_NUM_THREADS','OPENBLAS_NUM_THREADS','MKL_NUM_THREADS','NUMBA_NUM_THREADS']:
    os.environ[key]='1'
os.environ['MPLBACKEND']='Agg'
import json,hashlib,time
import numpy as np,pandas as pd,scanpy as sc
import matplotlib.pyplot as plt
from scipy import sparse,stats
ROOT=Path(__file__).resolve().parents[3]
OUT=ROOT/'methods/PAGA';DATA=Path(os.environ.get('TOOLKIT_PAGA_DATA',ROOT/'.local_round4/PAGA'))
for directory in [DATA,*[OUT/d for d in ['results','figures','logs','figure_notes']]]:directory.mkdir(parents=True,exist_ok=True)
CFG=dict(seed=0,n_pcs=20,first_neighbors=4,diffmap_components=15,final_neighbors=10,display_threshold=.03,group='paul15_clusters',root_index=840)
sc.settings.n_jobs=1;sc.settings.verbosity=3;sc.settings.datasetdir=DATA
sc.settings.set_figure_params(dpi=100,dpi_save=180,facecolor='white',frameon=False)
def save_json(name,obj):
    (OUT/name).write_text(json.dumps(obj,ensure_ascii=False,indent=2,default=str)+'\n',encoding='utf-8')
def export(name):
    for ext in ['png','pdf','svg']:plt.savefig(OUT/'figures'/f'{name}.{ext}',bbox_inches='tight',facecolor='white',dpi=180)
    plt.close('all')
print('PAGA configuration',CFG,flush=True)
