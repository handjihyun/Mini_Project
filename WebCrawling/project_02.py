# 국내 박람회 사이트 --> 검색어 : 데이터
from selenium import webdriver
from bs4 import BeautifulSoup
from urllib.request import urlopen

driver = webdriver.Chrome('C:/workspace/chromedriver.exe')
driver.get('https://www.showala.com/ex/ex_list.php?totalSearch=%EB%8D%B0%EC%9D%B4%ED%84%B0')
driver.find_element_by_xpath('//*[@id="searchFrm"]/dl/dd[2]/button').click()
driver.find_element_by_xpath('//*[@id="pageMain"]/div[3]/section/div[2]/div[1]/div[3]/ul/li[3]/button').click()

i = 1
while i < 6:
    driver.find_element_by_xpath('//*[@id="pageMain"]/div[3]/section/div[2]/div[3]/button').click()
    i += 1

html = driver.page_source
soup = BeautifulSoup(html, 'html.parser')

words = []
for __ in range(len(soup.select('div.ex_tit > a'))):
    new = "https://www.showala.com" + soup.select('div.ex_tit > a')[__].attrs['href']
    n_html = urlopen(new)
    n_soup = BeautifulSoup(n_html, 'html.parser')
    for j in range(1, len(n_soup.select_one('div.tag_wrap').text.strip().split('#'))):
        words.append(n_soup.select_one('div.tag_wrap').text.strip().split('#')[j])
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