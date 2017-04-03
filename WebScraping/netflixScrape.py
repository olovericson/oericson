import requests
from bs4 import BeautifulSoup
import pandas as pd

session = requests.session()

login_url = "https://www.netflix.com/Login"

result = session.get(login_url)

print(result.cookies)
soup = BeautifulSoup(result.content, 'html.parser')

inputs = list(soup.find(class_="login-form").find_all('input'))

authURL=''
for i in inputs:
    if i['name']=='authURL':
        authURL=i['value']
        break



url = "https://api-global.netflix.com/iosui/warmer/9.10?appInternalVersion=9.10.0&appVersion=9.10.0&config={'summaryHasTitleTreatment':false,'summaryHasUrl':false,'thumbRatingsEnabled':'false','billboardEnabled':'true'','summaryHasHorizontalDisplayArt':false,'summaryHasSynopsis':false,'showMoreDirectors':true,'kidsParityEnabled':'false','roarEnabled':'true','summaryHasStoryArt':false,'summaryHasPreviewStoryArt':false,'kidsBillboardEnabled':'true','bigRowEnabled':'true','summaryHasId':false,'warmerHasGenres':true,'useSecureImages':true}&device_type=NFAPPL-02-&esn=esn&id=genre_id&idiom=phone&iosVersion=10.2.1&isTablet=false&kids=false&languages=se-Sv&locale=se-sv&maxDeviceWidth=414&method=get&model=saget&modelType=IPHONE9-2&odpAware=true&pageType=page_type&pathFormat=graph&pixelDensity=3.0&progressive=false&responseFormat=json&type=gallery-ath"

data = {
    "email": "olov_ericson@hotmail.com",
    "password": "leksandstars1",
    "authURL": authURL,
    "RememberMe": "true"
}


header = {
    'User-Agent': "NodeScrape",
    'Cookie': 'NetflixId=3DBQAOAAEBEHoUpOw42U1EMOnTR0UU9U;SecureNetflixId=v%3D2%26mac%3DAQEAEQABABSypzgsIQYfTYhaHCXQv48IzuIMsjGqR9o.%26dt%3D1491162221899'
}

result = session.post(login_url, data=data, headers=header)
cookies = result.headers['set-cookie']

result = session.get("https://www.netflix.com/WiViewingActivity", headers = header)

soup = BeautifulSoup(result.content, 'html.parser')

print(soup.prettify())