from pathlib import Path
import csv, json, hashlib, xml.etree.ElementTree as ET
from PIL import Image, ImageOps, ImageDraw
import pypdfium2 as pdfium

root=Path('outputs/single-cell-trajectory-fate-toolkit')
method=root/'methods/Slingshot'
scratch=Path('work/figure_qa'); scratch.mkdir(parents=True,exist_ok=True)
reports=[]; png_tiles=[]; pdf_tiles=[]
def tile(im,label):
    im=ImageOps.contain(im.convert('RGB'),(640,490))
    out=Image.new('RGB',(660,530),'white')
    out.paste(im,((660-im.width)//2,26))
    ImageDraw.Draw(out).text((8,6),label,fill='black')
    return out
for p in sorted((method/'figures').glob('*.png')):
    stem=p.stem
    im=Image.open(p);im.load()
    assert im.width>1000 and im.height>800
    doc=pdfium.PdfDocument(str(p.with_suffix('.pdf')))
    assert len(doc)==1
    page=doc[0]
    bitmap=page.render(scale=1.4).to_pil().convert('RGB')
    bitmap.save(scratch/(stem+'_pdf.png'))
    tree=ET.parse(p.with_suffix('.svg'))
    tags=[x.tag.rsplit('}',1)[-1] for x in tree.iter()]
    assert 'svg' in tags and 'path' in tags
    assert 'image' not in tags, 'Unexpected embedded screenshot'
    png_tiles.append(tile(im,stem+' | PNG'))
    pdf_tiles.append(tile(bitmap,stem+' | PDF rendered'))
    reports.append(dict(figure=stem,png_dimensions=list(im.size),pdf_pages=len(doc),
                        svg_paths=tags.count('path'),embedded_raster_images=tags.count('image'),
                        formats={ext:dict(bytes=p.with_suffix('.'+ext).stat().st_size,
                                  sha256=hashlib.sha256(p.with_suffix('.'+ext).read_bytes()).hexdigest())
                                 for ext in ['png','pdf','svg']}))
for name,tiles in [('png_contact_sheet',png_tiles),('pdf_contact_sheet',pdf_tiles)]:
    sheet=Image.new('RGB',(1320,530*((len(tiles)+1)//2)),'#DDDDDD')
    for i,im in enumerate(tiles): sheet.paste(im,((i%2)*660,(i//2)*530))
    sheet.save(scratch/(name+'.png'))
def read_tsv(name):
    with (method/'results'/name).open(encoding='utf-8',newline='') as f:
        return list(csv.DictReader(f,delimiter='\t'))
coords=read_tsv('input_coordinates.tsv'); pt=read_tsv('pseudotime.tsv');wt=read_tsv('curve_weights.tsv')
assert len(coords)==len(pt)==len(wt)==140
assert [r['cell_id'] for r in coords]==[r['cell_id'] for r in pt]==[r['cell_id'] for r in wt]
assert len({r['cell_id'] for r in coords})==140
for r in wt:
    for k,v in r.items():
        if k!='cell_id': assert 0<=float(v)<=1
record=json.loads((method/'logs/04_execution_record.json').read_text(encoding='utf-8-sig'))
assert record['exit_code']==0
out=dict(scope='File opening, PDF rasterization, SVG XML/vector checks, numeric tables and process exit; visual inspection recorded separately',
         files=reports,input_cells=140,lineages=read_tsv('lineages.tsv'),summary=read_tsv('lineage_summary.tsv'),
         id_order_match=True,curve_weights_valid=True,process_exit_code=record['exit_code'])
(method/'logs/artifact_checks.json').write_text(json.dumps(out,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(dict(figures=len(reports),formats=3,input_cells=len(coords),exit_code=record['exit_code'])))
