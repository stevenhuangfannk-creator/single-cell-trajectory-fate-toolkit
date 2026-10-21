from pathlib import Path
import urllib.request,json,hashlib,time
p=Path(__file__).resolve().parents[3];out=p/'.local_round4/CytoTRACE2';out.mkdir(parents=True,exist_ok=True)
records=[]
for name,fileid in [('Pancreas_10x_downsampled_expression.txt','11eI1gSBoBqn9ccvBbthZ2nPW3CENsKbT'),('Pancreas_10x_downsampled_annotation.txt','1UESeZJDl2qWYnSu0VQQA5igpEbtxZPgq')]:
    url='https://drive.usercontent.google.com/download?id='+fileid+'&export=download&confirm=t';dest=out/name
    if not dest.exists():
        start=time.time();n=0
        with urllib.request.urlopen(url,timeout=90) as r,dest.with_suffix('.part').open('wb') as f:
            if 'text/html' in r.headers.get('Content-Type',''):raise RuntimeError('Not an expression file')
            while data:=r.read(1024*1024):
                n+=len(data)
                if n>256*1024**2:raise RuntimeError('Official small file exceeds 256 MiB budget')
                f.write(data)
        dest.with_suffix('.part').rename(dest);print(name,n,'seconds',time.time()-start,flush=True)
    records.append(dict(file=name,url=url,official_link='https://drive.google.com/file/d/'+fileid+'/view',bytes=dest.stat().st_size,sha256=hashlib.sha256(dest.read_bytes()).hexdigest()))
(out/'download_provenance.json').write_text(json.dumps(records,indent=2)+'\n',encoding='utf-8')
