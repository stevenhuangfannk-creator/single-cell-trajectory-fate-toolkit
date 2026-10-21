"""在同一独立Python环境中串行启动一个方法，记录采样资源并保留全部日志。"""
from pathlib import Path
import subprocess,sys,time,json,os
import psutil
root=Path(__file__).resolve().parents[1]
method=sys.argv[1]
if method not in {'CytoTRACE2','CellRank'}:raise ValueError('Choose CytoTRACE2 or CellRank')
folder=root/'methods'/method;logs=folder/'logs';logs.mkdir(parents=True,exist_ok=True)
stamp=time.strftime('%Y%m%d_%H%M%S');log=logs/f'run_{stamp}.log'
env=os.environ.copy();env['PYTHONUTF8']='1';env['PYTHONUNBUFFERED']='1'
samples=[];low=0;abort=None
with log.open('w',encoding='utf-8') as stream:
    child=subprocess.Popen([sys.executable,'-X','utf8',str(folder/'scripts/run_example.py'),*sys.argv[2:]],cwd=root,env=env,stdout=stream,stderr=subprocess.STDOUT)
    process=psutil.Process(child.pid)
    while child.poll() is None:
        try:rss=sum(x.memory_info().rss for x in [process,*process.children(recursive=True)] if x.is_running())
        except psutil.NoSuchProcess:rss=0
        available=psutil.virtual_memory().available;samples.append(dict(unix_time=time.time(),process_tree_RSS=rss,available_RAM=available))
        low=low+1 if available<600*1024**2 else 0
        if low>=10 or rss>5*1024**3:
            abort='RESOURCE_GUARD: available RAM <600MiB for10 samples or process-tree RSS>5GiB'
            for descendant in process.children(recursive=True):descendant.terminate()
            child.terminate();break
        time.sleep(1)
    code=child.wait()
record=dict(exit_code=code,abort_reason=abort,log=log.name,sampling_interval_seconds=1,max_sampled_process_tree_RSS=max((x['process_tree_RSS'] for x in samples),default=0),min_sampled_available_RAM=min((x['available_RAM'] for x in samples),default=0),samples=samples)
(logs/f'resources_{stamp}.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(method,'exit',code,'log',log,flush=True)
sys.exit(code if not abort else 99)
