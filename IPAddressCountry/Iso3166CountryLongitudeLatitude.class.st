"
Iso3166CountryLongitudeLatitude maps country codes to their average or central longtiude/latitude.

My keys are two letter Iso3166 Symbols representing a country, such as #BE
My values are Points holding coordinates as longtiude@latitude

I am constructed based on a CSV data file, see my class side.

Example

	Iso3166CountryLongitudeLatitude readFromCSVFile at: #BE

You should cache one instance of me.

Based on data from https://mledoze.github.io/countries/ https://github.com/mledoze/countries

This code is published under the http://en.wikipedia.org/wiki/MIT_License

"
Class {
	#name : #Iso3166CountryLongitudeLatitude,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #IPAddressCountry
}

{ #category : #dataset }
Iso3166CountryLongitudeLatitude class >> createDatasetFromSource [
	"Create the dataset that we use from its original source, https://mledoze.github.io/countries/ 
	or https://github.com/mledoze/countries , in particular the JSON file.
	Select the minimal information that we need and generate an efficient CSV file."

	| url data countries |
	url := 	'https://github.com/mledoze/countries/raw/master/dist/countries.json'.
	data := ZnClient new 
		contentReader: [ :entity | NeoJSONObject fromString: entity contents ]; 
		get: url.
	countries := data collect: [ :each | 
		{ each at: #cca2. (each at: #latlng) first. (each at: #latlng) second } ].
	self csvFilename asFileReference writeStreamDo: [ :out | 
		(NeoCSVWriter on: out) 
			lineEndConvention: #lf; fieldWriter: #raw; 
			writeHeader: #(country latitude longitude); 
			nextPutAll: countries ]

]

{ #category : #accessing }
Iso3166CountryLongitudeLatitude class >> csvFilename [
	"The local and remote file name of the CSV data set that we expect"
	
	^ 'country-lat-long.csv'
]

{ #category : #accessing }
Iso3166CountryLongitudeLatitude class >> precomputedCSVFileURL [
	"The URL where a precomputed version of the CSV data set that we need normally exists."
	
	^ ('https://github.com/svenvc/IPAddressCountry/raw/master/dist/', self csvFilename) asUrl 
]

{ #category : #'instance creation' }
Iso3166CountryLongitudeLatitude class >> readFrom: filename [
	"Read from a CSV file with fields code,latitude,longitude as in BE,50.8333,4.0000"

	| instance |
	instance := self new.
	filename asFileReference
		readStreamDo: [ :stream | 
			(NeoCSVReader on: stream)
				addSymbolField;
				addFloatField;
				addFloatField;
				skipHeader;
				do: [ :each | instance data at: each first put: each third @ each second ] ].
	^ instance
]

{ #category : #'instance creation' }
Iso3166CountryLongitudeLatitude class >> readFromCSVFile [
	"Read from the standard CSV file, either locally cached or from a location where it exists precomputed"

	| file |
	file := self csvFilename asFileReference.
	file exists
		ifFalse: [ self precomputedCSVFileURL saveContentsToFile: file ].
	^ self readFrom: file
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
	^ data ifNil: [ data := IdentityDictionary new ]
]
