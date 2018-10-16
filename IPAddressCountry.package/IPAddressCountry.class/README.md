IPAddressCountry maps IP addresses to their country code.
I hold a collection of IPAddressRangeCountry objects that I do a binary search on.

I am constructed based on a CSV data file using my class' #readFrom:
which expects lines like 3651886848,3651887103,BE or start,stop,code

You can download a version of this file from http://homepage.mac.com/svc/data/GeoIPCountry.csv.gz

((IPAddressCountry readFrom: 'GeoIPCountry.csv') atAddress: '81.83.7.35') = #BE

Addresses can also be specified as #(81 83 7 35) for #atAddress: or as 1364395811 for #at:

You should cache one instance of me.

Based on data from http://www.maxmind.com/app/geolitecountry

This code is published under the http://en.wikipedia.org/wiki/MIT_License