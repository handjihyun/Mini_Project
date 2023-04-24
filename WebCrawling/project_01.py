from selenium import webdriver
from bs4 import BeautifulSoup
from urllib.request import urlopen
import pandas as pd
import time

# -------------------------------------------------------------------------------------------------------------------------------
''' https://www.showala.com/ '''
# 1)
driver = webdriver.Chrome('C:/workspace/chromedriver.exe')
driver.get('https://www.showala.com/ex/ex_list.php')

driver.find_element_by_id('sch_str').send_keys('데이터')
driver.find_element_by_xpath('//*[@id="searchFrm"]/dl/dd[2]/button').click()
driver.find_element_by_xpath('//*[@id="pageMain"]/div[3]/section/div[2]/div[1]/div[3]/ul/li[3]/button').click()
i = 1
while i < 6:
    driver.find_element_by_xpath('//*[@id="pageMain"]/div[3]/section/div[2]/div[3]/button').click()
    i += 1

html = driver.page_source
soup = BeautifulSoup(html, 'html.parser')

name, date, place = set(), set(), set()
for j in range(len(soup.select('div.ex_tit > a'))):
    name.add(soup.select('div.ex_bot_info_wrap')[j].text.split('\n')[5])
    date.add(soup.select('div.ex_bot_info_wrap')[j].text.split('\n')[9][4:])
    place.add(soup.select('div.ex_bot_info_wrap')[j].text.split('\n')[10][4:])

print(date)
data_df = pd.DataFrame(zip(name, place, date), columns=('전시명', '장소', '일정'))
data_df.to_csv('korea_data_fair1.csv', index=False)

# 2)
driver = webdriver.Chrome('C:/workspace/chromedriver.exe')
driver.get('https://www.showala.com/ex/ex_list.php')

driver.find_element_by_id('sch_str').send_keys('인공지능')
driver.find_element_by_xpath('//*[@id="searchFrm"]/dl/dd[2]/button').click()
driver.find_element_by_xpath('//*[@id="pageMain"]/div[3]/section/div[2]/div[1]/div[3]/ul/li[3]/button').click()
driver.find_element_by_xpath('//*[@id="pageMain"]/div[3]/section/div[2]/div[3]/button').click()

html = driver.page_source
soup = BeautifulSoup(html, 'html.parser')

name, date, place = [], [], []
for k in range(len(soup.select('div.ex_tit > a'))):
    name.append(soup.select('div.ex_bot_info_wrap')[k].text.split('\n')[5])
    date.append(soup.select('div.ex_bot_info_wrap')[k].text.split('\n')[9][4:])
    place.append(soup.select('div.ex_bot_info_wrap')[k].text.split('\n')[10][4:])

ai_df = pd.DataFrame(zip(name, place, date), columns=('전시명', '장소', '일정'))
ai_df.to_csv('korea_ai_fair.csv', index=False)

# -------------------------------------------------------------------------------------------------------------------------------
''' https://myfair.co/ '''

# 3)
name, date, place = [], [], []
for __ in range(2):
    html = urlopen(f'https://myfair.co/exhibition-list?sdt=2023-12&zn=2&in=106&page={__}&cancel=true')
    soup = BeautifulSoup(html, 'html.parser')

    for _ in range(len(soup.select('p.css-tr5gfz'))):
        name.append(soup.select('p.css-tr5gfz')[_].text)
        date.append(soup.select('span.css-1dbsdsw')[_].text)
        place.append(soup.select('div.css-1cq61h6 > span.css-8e6l32')[_].text)

pd.DataFrame(zip(name, place, date), columns=('전시명', '장소', '일정')).to_csv('global_data_fair.csv', index=False)

# 4)
name, date, place = [], [], []
for ___ in range(6):
    html = urlopen(f'https://myfair.co/exhibition-list?sdt=2023-12&zn=2&in=123&page={___}&cancel=true')
    soup = BeautifulSoup(html, 'html.parser')

    for _ in range(len(soup.select('p.css-tr5gfz'))):
        name.append(soup.select('p.css-tr5gfz')[_].text)
        date.append(soup.select('span.css-1dbsdsw')[_].text)
        place.append(soup.select('div.css-1cq61h6 > span.css-8e6l32')[_].text)

pd.DataFrame(zip(name, place, date), columns=('전시명', '장소', '일정')).to_csv('global_ai_fair.csv', index=False)

# 5)
# 국제 박람회 사이트 - 검색어 : IT전체
html = urlopen('https://myfair.co/exhibition-list?sdt=2023-12&zn=2&in=&page=&cancel=true&ctnum=&sctnum=&cnum=')
soup = BeautifulSoup(html, 'html.parser')

words = []
for j in range(42):
    html = urlopen(f'https://myfair.co/exhibition-list?sdt=2023-12&zn=2&in=&page={j}&cancel=true&ctnum=&sctnum=&cnum=')
    soup = BeautifulSoup(html, 'html.parser')

    for i in range(len(soup.select('div.css-1yb3gh8 > span.css-f25xqq'))):
        words.append(soup.select('div.css-1yb3gh8 > span.css-f25xqq')[i].text)

print(words)

from wordcloud import WordCloud
from collections import Counter
import matplotlib.pyplot as plt
import platform

counts = Counter(words)
tags = counts.most_common(40)

if platform.system() == 'Windows':
    path = r'c:\Windows\Fonts\malgun.ttf'

wc = WordCloud(font_path = path, background_color='white', max_font_size = 60)
cloud = wc.generate_from_frequencies(dict(tags))

plt.figure(figsize=(10, 8))
plt.axis('off')
plt.imshow(cloud)
plt.show()