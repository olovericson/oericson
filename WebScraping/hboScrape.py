import requests
from bs4 import BeautifulSoup
import pandas as pd

__author__ = 'olov.ericson'

df = pd.DataFrame()

offset = 0

while True:
    page = requests.get('https://api-hbon.hbo.clearleap.com/cloffice/client/web/browse/ea73aabd-24a3-473e-8f3a-39aeb7f0f93e?max=20&offset={}&language=sv_hbon'.format(offset))

    soup = BeautifulSoup(page.content, 'html.parser')

    items = list(soup.find_all('item'))

    if not items:
        break

    #Get title
    titles = [ti.find("title").get_text() for ti in items]

    #Get description
    descs = [desc.find("description").get_text() for desc in items]

    #Get genre
    genres = [gen.find("media:keywords").get_text() for gen in items]

    hbo_movies_batch = pd.DataFrame({
            "title": titles,
            "hbo_desc": descs,
            "genre": genres
        })

    df = df.append(hbo_movies_batch)

    print(offset)

    offset += 20


df.to_csv("data/hbo_movies.csv", sep=';', decimal=',')

