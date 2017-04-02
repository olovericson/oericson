import requests
from bs4 import BeautifulSoup
import pandas as pd

__author__ = 'olov.ericson'

page = requests.get("http://dataquestio.github.io/web-scraping-pages/simple.html")

soup = BeautifulSoup(page.content, 'html.parser')

# print(soup.prettify())

kids = list(soup.children)

# print all the types
types = [type(item) for item in kids]

# html is the third child of content
html = kids[2]

# Body is the fourth child of html
body = list(html.children)[3]

# p is the second child of body
p = list(body.children)[1]

# Get the text of p
p_text = p.get_text()

p_text = soup.find_all('p')[0].get_text()

# Find the first instance of p
p_text = soup.find('p').get_text()

# New page: http://dataquestio.github.io/web-scraping-pages/ids_and_classes.html
page = requests.get("http://forecast.weather.gov/MapClick.php?lat=37.7772&lon=-122.4168")
soup = BeautifulSoup(page.content, 'html.parser')

seven_day = soup.find(id='seven-day-forecast')

forecast_items = soup.find_all(class_='tombstone-container')

tonight = forecast_items[0]
print(tonight.prettify())

print("Period: {}".format(tonight.find(class_='period-name').get_text()))

print("Short desc: {}".format(tonight.find(class_='short-desc').get_text()))

print("Temp: {}".format(tonight.find(class_='temp').get_text()))

print(tonight.find('img')['title'])

period_tags = seven_day.select(".tombstone-container .period-name")

periods = [pt.get_text() for pt in period_tags]

print(seven_day)
short_descs = [sd.get_text() for sd in seven_day.select(".tombstone-container .short-desc")]
temps = [t.get_text() for t in seven_day.select(".tombstone-container .temp")]
descs = [d["title"] for d in seven_day.select(".tombstone-container img")]

print(short_descs)
print(temps)
print(descs)


weather = pd.DataFrame({
        "period": periods,
        "short_desc": short_descs,
        "temp": temps
    })
print(weather)


