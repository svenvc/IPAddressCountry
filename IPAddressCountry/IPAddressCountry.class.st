"
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
"
Class {
	#name : #IPAddressCountry,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : 'IPAddressCountry'
}

{ #category : #private }
IPAddressCountry class >> addressToInteger: object [
	"Convert either a String or a ByteArray into an IP address Integer"

	| address integer |
	object isCollection
		ifFalse: [ ^ -1 ].
	address := object isString
		ifTrue: [ ('.' split: object) collect: [ :each | each asInteger ] ]
		ifFalse: [ object ].
	(address size = 4 and: [ address allSatisfy: [ :each | each isInteger and: [ each between: 0 and: 255 ] ] ])
		ifFalse: [ ^ -1 ].
	integer := 0.
	address withIndexDo: [ :each :index | integer := integer + (each bitShift: (4 - index) * 8) ].
	^ integer
]

{ #category : #dataset }
IPAddressCountry class >> createDatasetFromSource [
	"Create the dataset that we use from its original source, http://software77.net/geo-ip 
	in particular the zipped IPv4 CSV file with sorted ranges (IP address blocks).
	Select the minimal information that we need and generate an efficient CSV file."

	| zip ranges |
	zip := ZnClient new get: 'http://software77.net/geo-ip/?DL=2'.
	ranges := ((ZipArchive new readFrom: zip readStream) contentsOf: 'IpToCountry.csv')
		in: [ :csvString | 
			(NeoCSVReader on: (String cr join: (csvString lines reject: [ :line | line first = $# ])) readStream)
				addIntegerField;
				addIntegerField;
				addIgnoredFields: 2;
				addSymbolField;
				addIgnoredFields: 2;
				upToEnd ].
	self csvFilename asFileReference
		writeStreamDo: [ :out | 
			(NeoCSVWriter on: out)
				lineEndConvention: #lf;
				fieldWriter: #raw;
				writeHeader: #(start stop country);
				nextPutAll: ranges ]
]

{ #category : #accessing }
IPAddressCountry class >> csvFilename [
	"The local and remote file name of the CSV data set that we expect"
	
	^ 'ip4-country.csv'
]

{ #category : #accessing }
IPAddressCountry class >> precomputedCSVFileURL [
	"The URL where a precomputed version of the CSV data set that we need normally exists."
	
	^ ('https://github.com/svenvc/IPAddressCountry/raw/master/dist/', self csvFilename) asUrl 
]

{ #category : #'instance creation' }
IPAddressCountry class >> readFrom: filename [
	"Read from a sorted CSV file with fields start,stop,code as in 3651886848,3651887103,BE"

	^ self new
		data:
			(filename asFileReference
				readStreamDo: [ :stream | 
					(NeoCSVReader on: stream)
						recordClass: IPAddressRangeCountry;
						addIntegerField: #start:;
						addIntegerField: #stop:;
						addSymbolField: #country:;
						skipHeader;
						upToEnd ]);
		yourself
]

{ #category : #'instance creation' }
IPAddressCountry class >> readFromCSVFile [
	"Read from the standard CSV file, either locally cached or from a location where it exists precomputed"

	| file |
	file := self csvFilename asFileReference.
	file exists
		ifFalse: [ self precomputedCSVFileURL saveContentsToFile: file ].
	^ self readFrom: file
]

{ #category : #accessing }
IPAddressCountry >> at: integer [
	"Return a country Symbol for an IP address specified as an Integer"

	^ self at: integer ifAbsent: [ nil ]
]

{ #category : #accessing }
IPAddressCountry >> at: integer ifAbsent: block [
	"Return a country Symbol for an IP address specified as an Integer"

	(integer between: 0 and: (2 raisedToInteger: 32) - 1)
		ifFalse: [ ^ block value ].  
	^ self data 
		findBinary: [ :each | each compare: integer ] 
		do: [ :each | each country ] 
		ifNone: [ :a :b | block value ]
]

{ #category : #accessing }
IPAddressCountry >> atAddress: object [
	"Return a country Symbol for an IP address specified as String or ByteArray"
	
	^ self at: (self class addressToInteger: object)
	  
]

{ #category : #accessing }
IPAddressCountry >> atAddress: object ifAbsent: block [
	"Return a country Symbol for an IP address specified as String or ByteArray"

	^ self at: (self class addressToInteger: object) ifAbsent: block
	  
]

{ #category : #private }
IPAddressCountry >> data [
	^ data
]

{ #category : #private }
IPAddressCountry >> data: array [
	data := array
]
