from pathlib import Path
import sys
def main():
    folder=Path(__file__).resolve().parent;scope={'__file__':str(folder/'00_Start.py')}
    sequence=['00_Start.py']+(['03_Plot_and_Export.py'] if '--replot' in sys.argv else (['02_Predict_and_Statistics.py','03_Plot_and_Export.py'] if '--predict-only' in sys.argv else ['01_Input_QC_and_Embedding.py','02_Predict_and_Statistics.py','03_Plot_and_Export.py']))
    for name in sequence:exec(compile((folder/name).read_text(encoding='utf-8'),str(folder/name),'exec'),scope)
# 官方平滑即使max_cores=1也启动单worker；Windows spawn必须保护主入口。
if __name__=='__main__':main()
