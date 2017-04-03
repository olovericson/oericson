import requests
import pandas as pd

def get_page_data(start):
    headers = {
        'Accept': 'application/json, text/javascript, */*; q=0.01',
        'Accept-Encoding': 'gzip, deflate',
        'Accept-Language': 'en-US,en;q=0.8',
        'Connection': 'keep-alive',
        'Content-Length': '1893',
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Cookie': 'PHPSESSID=gjeuvksuefv3lhb8a4c2ic1ec1; SERVERID=web4; _ga=GA1.2.2007578377.1491235372; _gat=1; identifier=6e5e52f66cfce015f9ded7f7ee068549',
        'Host': 'www.allflicks.se',
        'Origin': 'http://www.allflicks.se',
        'Referer': 'http://www.allflicks.se/',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36',
        'X-Requested-With': 'XMLHttpRequest'
    }

    data = {
        'draw': '1',
        'columns[0][data]': 'box_art',
        'columns[0][name]': '',
        'columns[0][searchable]': 'true',
        'columns[0][orderable]': 'false',
        'columns[0][search][value]': '',
        'columns[0][search][regex]': 'false',
        'columns[1][data]': 'title',
        'columns[1][name]': '',
        'columns[1][searchable]': 'true',
        'columns[1][orderable]': 'true',
        'columns[1][search][value]': '',
        'columns[1][search][regex]': 'false',
        'columns[2][data]': 'year',
        'columns[2][name]': '',
        'columns[2][searchable]': 'true',
        'columns[2][orderable]': 'true',
        'columns[2][search][value]': '',
        'columns[2][search][regex]': 'false',
        'columns[3][data]': 'genre',
        'columns[3][name]': '',
        'columns[3][searchable]': 'true',
        'columns[3][orderable]': 'true',
        'columns[3][search][value]': '',
        'columns[3][search][regex]': 'false',
        'columns[4][data]': 'rating',
        'columns[4][name]': '',
        'columns[4][searchable]': 'true',
        'columns[4][orderable]': 'true',
        'columns[4][search][value]': '',
        'columns[4][search][regex]': 'false',
        'columns[5][data]': 'available',
        'columns[5][name]': '',
        'columns[5][searchable]': 'true',
        'columns[5][orderable]': 'true',
        'columns[5][search][value]': '',
        'columns[5][search][regex]': 'false',
        'columns[6][data]': 'director',
        'columns[6][name]': '',
        'columns[6][searchable]': 'true',
        'columns[6][orderable]': 'true',
        'columns[6][search][value]': '',
        'columns[6][search][regex]': 'false',
        'columns[7][data]': 'cast',
        'columns[7][name]': '',
        'columns[7][searchable]': 'true',
        'columns[7][orderable]': 'true',
        'columns[7][search][value]': '',
        'columns[7][search][regex]': 'false',
        'order[0][column]': '5',
        'order[0][dir]': 'desc',
        'start': '0',
        'length': '25',
        'search[value]': '',
        'search[regex]': 'false',
        'movies': 'true',
        'shows': 'false',
        'documentaries': 'true',
        'rating': 'netflix',
        'min': '1900',
        'max': '2017'
    }


    url = "http://www.allflicks.se/wp-content/themes/responsive/processing/processing.php"

    data['start'] = start

    result = requests.post(url, data=data, headers=headers)

    data = result.json()

    return [dat['title'] for dat in data['data']]


start = 0
titles = list()
while True:
    print(start)

    items = get_page_data(str(start))

    if not items:
        break

    titles.extend(items)

    start += 25

df = pd.DataFrame({'title': titles})

df.to_csv('data/netflix_movies.csv')
