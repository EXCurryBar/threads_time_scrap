from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import time
from datetime import datetime
from bs4 import BeautifulSoup
import pandas as pd

def start_crawling():
    chrome_options = Options()
    date_map = {
        0: "星期一",
        1: "星期二",
        2: "星期三",
        3: "星期四",
        4: "星期五",
        5: "星期六",
        6: "星期日"
    }
    today = datetime.today()
    target = today.weekday() - 3
    if target < 0:
        target += 7

    print(date_map[target])

    driver = webdriver.Chrome()

    accounts = list(pd.read_excel("accounts.xlsx", header=None, index_col=None)[0])

    post_links = list()
    for account in accounts:
        prefix = f"/@{account}"
        account_url = f"https://www.threads.com{prefix}"
        driver.get(account_url)

        html = driver.page_source
        soup = BeautifulSoup(html, "html.parser")
        while True:
            try:
                soup.find_all('a', href=True)
                break
            except:
                time.sleep(0.5)
                continue
        try:  
            for a in soup.find_all('a', href=True):
                if a['href'].startswith(prefix+'/post'):
                    try:
                        if date_map[target] in a.find('time')["title"]:
                            print(a['href'])
                            post_links.append("https://www.threads.com" + a['href'])
                            break
                    except AttributeError:
                        continue
                else:
                    continue
        except TypeError:
            continue
    pandas_df = pd.DataFrame(post_links, columns=["Post Links"])
    pandas_df.to_excel("Threads_Post_Links_{}.xlsx".format(today.date()), index=False)