import os
import urllib.request
import shutil

LOCAL_FILE = r"don't touch\main.py"
REMOTE_URL = "https://raw.githubusercontent.com/EXCurryBar/threads_time_scrap/refs/heads/main/don't%20touch/main.py"
TEMP_FILE = os.path.join(os.environ.get("TEMP", "/tmp"), "main.py.tmp")

def files_are_identical(file1, file2):
    print("檢查阿寶有沒有更新...")
    if not os.path.exists(file1) or not os.path.exists(file2):
        return False
    with open(file1, 'rb') as f1, open(file2, 'rb') as f2:
        while True:
            b1 = f1.read(4096)
            b2 = f2.read(4096)
            if b1 != b2:
                print("有")
                return False
            if not b1:
                print("沒有")
                return True

try:
    urllib.request.urlretrieve(REMOTE_URL, TEMP_FILE)
    if not files_are_identical(LOCAL_FILE, TEMP_FILE):
        print("Downloading...")
        shutil.copy2(TEMP_FILE, LOCAL_FILE)
finally:
    if os.path.exists(TEMP_FILE):
        os.remove(TEMP_FILE)

from main import start_crawling
start_crawling()