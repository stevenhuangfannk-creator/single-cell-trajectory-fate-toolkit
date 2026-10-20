"""例：独立环境python -X utf8 methods/PAGA/scripts/run_example.py [--replot]。"""
from pathlib import Path
import sys
scripts=Path(__file__).resolve().parent
scope={'__file__':str(scripts/'00_Start.py')}
sequence=['00_Start.py']+(['03_Plot_and_Export.py'] if '--replot' in sys.argv else ['01_Load_and_Check.py','02_PAGA_and_DPT.py','03_Plot_and_Export.py'])
for name in sequence:exec(compile((scripts/name).read_text(encoding='utf-8'),str(scripts/name),'exec'),scope)
