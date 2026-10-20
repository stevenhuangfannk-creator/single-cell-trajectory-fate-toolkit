"""GO官方注释的小型处理器；仅Python标准库。先用获取脚本下载GAF和OBO。
输入：缓存目录；输出：本模块example_data下BP基因集与来源校验。
不将线虫通路解释为PI疾病机制。
"""
from pathlib import Path
from functools import lru_cache
import gzip,csv,json,hashlib,sys
cache=Path(sys.argv[1]);out=Path(__file__).resolve().parents[1]/'example_data';out.mkdir(parents=True,exist_ok=True)
gene_file=Path(__file__).resolve().parents[3]/'methods/Monocle3/results/gene_metadata.tsv'
with gene_file.open(encoding='utf-8') as f: universe={z['gene_id'] for z in csv.DictReader(f,delimiter='\t')}
terms={};alias={};current={};version=''
def commit():
    if current.get('id') and current.get('namespace')=='biological_process' and not current.get('obsolete'):
        terms[current['id']]=dict(current)
        for a in current.get('alt',[]):alias[a]=current['id']
with (cache/'go-basic.obo').open(encoding='utf-8') as f:
    for line in f:
        line=line.strip()
        if line.startswith('data-version:'):version=line.partition(':')[2].strip()
        if line=='[Term]':commit();current={'parents':[],'alt':[]}
        elif line.startswith('['):commit();current={}
        elif line.startswith('id: '):current['id']=line[4:]
        elif line.startswith('name: '):current['name']=line[6:]
        elif line.startswith('namespace: '):current['namespace']=line[11:]
        elif line.startswith('is_a: '):current.setdefault('parents',[]).append(line[6:].split()[0])
        elif line.startswith('relationship: part_of '):current.setdefault('parents',[]).append(line.split()[2])
        elif line.startswith('alt_id: '):current.setdefault('alt',[]).append(line[8:])
        elif line=='is_obsolete: true':current['obsolete']=True
commit()
@lru_cache(None)
def ancestors(t):
    if t not in terms:return frozenset()
    result={t}
    for parent in terms[t].get('parents',[]):result.update(ancestors(parent))
    return frozenset(result)
members={};headers=[];rows=0
with gzip.open(cache/'wb.gaf.gz','rt',encoding='utf-8') as f:
    for line in f:
        if line.startswith('!'):headers.append(line.rstrip());continue
        z=line.rstrip('\n').split('\t');rows+=1
        if len(z)<15 or z[0]!='WB' or z[8]!='P' or z[6]=='IEA' or 'NOT' in z[3].split('|') or z[12]!='taxon:6239':continue
        gid=z[1];term=alias.get(z[4],z[4])
        if gid not in universe:continue
        for t in ancestors(term):members.setdefault(t,set()).add(gid)
with (out/'worm_GO_BP_membership.tsv').open('w',newline='',encoding='utf-8') as f:
    w=csv.writer(f,delimiter='\t');w.writerow(['GO_ID','term','gene_id'])
    for t in sorted(members):
        if t=='GO:0008150':continue
        for g in sorted(members[t]):w.writerow([t,terms[t]['name'],g])
manifest={'source_GAF':'https://current.geneontology.org/annotations/wb.gaf.gz','source_OBO':'https://purl.obolibrary.org/obo/go/go-basic.obo','ontology_version':version,'GAF_header':headers,'GAF_rows_read':rows,'filter':'C. elegans taxon6239; BP; NOT excluded; IEA excluded; is_a + part_of ancestors; unique gene-term pairs','license':'GO CC BY 4.0; preserve GO/WormBase attribution; source files cached outside repository','files':{n:{'bytes':(cache/n).stat().st_size,'sha256':hashlib.sha256((cache/n).read_bytes()).hexdigest()} for n in ['wb.gaf.gz','go-basic.obo']}}
(out/'GO_provenance.json').write_text(json.dumps(manifest,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print('GAF rows',rows,'BP terms',len(members),'gene-term pairs',sum(map(len,members.values())))
