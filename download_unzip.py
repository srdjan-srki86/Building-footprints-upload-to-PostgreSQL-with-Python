'Srdjan Stancic - 08/02/2021'
'download and unzip data from source'

# import the requests library
import requests
import zipfile

# source for city of Chicago
url = 'https://data.cityofchicago.org/api/geospatial/hz9b-7nh8?method=export&format=Original'

# download the file
r = requests.get(url)

# open method to open a file on your system
with open("chicago.zip", "wb") as code:
    code.write(r.content)

# download print
print("You have successfully downloaded file - Chicago building footprints from source to local machine")

# unzip file
with zipfile.ZipFile("chicago.zip", "r") as zip_ref:
    zip_ref.extractall("shapefile")

# unzip file print
print("You have successfully unpacked the file")
