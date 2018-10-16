Iso3166CountryLongitudeLatitude maps country codes to their average or central longtiude/latitude.

My keys are two letter Iso3166 Symbols representing a country, such as #BE
My values are Points holding coordinates as longtiude@latitude

I am constructed based on a CSV data file using my class' #readFrom:
which expects lines like BE,50.8333,4.0000 or code,latitude,longitude

You can download a version of this file from http://homepage.mac.com/svc/data/CountryLatLong.csv.gz

((Iso3166CountryLongitudeLatitude readFrom: 'CountryLatLong.csv') at: #BE) = 4.0@50.8333

You should cache one instance of me.

This code is published under the http://en.wikipedia.org/wiki/MIT_License
