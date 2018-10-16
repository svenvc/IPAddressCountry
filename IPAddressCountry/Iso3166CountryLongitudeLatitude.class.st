"
Iso3166CountryLongitudeLatitude maps country codes to their average or central longtiude/latitude.

My keys are two letter Iso3166 Symbols representing a country, such as #BE
My values are Points holding coordinates as longtiude@latitude

I am constructed based on a CSV data file using my class' #readFrom:
which expects lines like BE,50.8333,4.0000 or code,latitude,longitude

You can download a version of this file from http://homepage.mac.com/svc/data/CountryLatLong.csv.gz

((Iso3166CountryLongitudeLatitude readFrom: 'CountryLatLong.csv') at: #BE) = 4.0@50.8333

You should cache one instance of me.

This code is published under the http://en.wikipedia.org/wiki/MIT_License

"
Class {
	#name : #Iso3166CountryLongitudeLatitude,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : 'IPAddressCountry'
}

{ #category : #'instance creation' }
Iso3166CountryLongitudeLatitude class >> readFrom: filename [
	"Read from a CSV file with fields code,latitude,longitude as in BE,50.8333,4.0000"
	"self readFrom: '/Users/sven/Tmp/geo-ip-country/CountryLatLong.csv'."
	
	| instance |
	instance := self new.
	filename asFileReference readStreamDo: [ :stream | 
		(NeoCSVReader on: stream)
			addSymbolField; addFloatField; addFloatField;
			do: [ :each | 
				instance data 
					at: each first put: each third @ each second ] ].
	^ instance
]

{ #category : #accessing }
Iso3166CountryLongitudeLatitude >> at: countryCode [
	"Return a Point (longitude@latitude) for the Symbol countryCode"
	
	^ self at: countryCode ifAbsent: [ nil ]
]

{ #category : #accessing }
Iso3166CountryLongitudeLatitude >> at: countryCode ifAbsent: block [
	"Return a Point (longitude@latitude) for the Symbol countryCode"
	
	^ self data at: countryCode ifAbsent: block
]

{ #category : #private }
Iso3166CountryLongitudeLatitude >> data [
	^ data ifNil: [ data := Dictionary new ]
]
