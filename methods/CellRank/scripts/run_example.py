from pathlib import Path
def main():
    folder=Path(__file__).resolve().parent;scope={'__file__':str(folder/'00_Start.py')}
    for name in ['00_Start.py','01_Download_and_QC.py']:exec(compile((folder/name).read_text(encoding='utf-8'),str(folder/name),'exec'),scope)
if __name__=='__main__':main()
