import requests
from bs4 import BeautifulSoup
import pandas as pd

__author__ = 'olov.ericson'

df = pd.read_csv('data/hbo_movies.csv', sep=';', decimal=',', encoding='latin1')

titles = df['title']

rating_list = []

for i in titles:
    i = str.replace(i, "&apos;", "'")

    print(i)

    movie = str.replace(i, "&apos;", "'")

    base_url = 'http://www.imdb.com'

    url = '{}/find?ref_=nv_sr_fn&q={}&s=tt'.format(base_url, movie)

    result = requests.get(url)

    soup = BeautifulSoup(result.content, 'html.parser')

    find_list = soup.find(class_='findList')
    if find_list:
        link_to_movie = find_list.find_all(class_='result_text')[0].find('a')['href']
        print(link_to_movie)

        url = base_url + link_to_movie
        result = requests.get(url)

        soup = BeautifulSoup(result.content, 'html.parser')

        rating_value = soup.find(class_='ratingValue')
        if rating_value:
            rating = rating_value.find_all('span')[0].get_text()
        else:
            rating = 'Not enough ratings'
    else:
        rating = 'Movie not found'

    print(rating)
    rating_list.append(rating)


df['imdb_rating'] = rating_list

df.to_csv("data/hbo_movies_with_imdb_rating.csv", sep=';', decimal=',')