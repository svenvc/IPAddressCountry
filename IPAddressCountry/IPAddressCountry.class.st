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
	object isCollection ifFalse: [ ^ -1 ].
	object isString 
		ifTrue: [ address := ('.' split: object) collect: [ : each | each asInteger ] ]
		ifFalse: [ address := object ].
	(address size = 4 and: [ address allSatisfy: [ :each | each isInteger and: [ each between: 0 and: 255 ] ] ])
		ifFalse: [ ^ -1 ].  
	integer := 0.
	address withIndexDo: [ :each :index | 
		integer := integer + (each bitShift: (4 - index) * 8) ].
	^ integer 
]

{ #category : #'instance creation' }
IPAddressCountry class >> readFrom: filename [
	"Read from a CSV with field start,stop,code as in 3651886848,3651887103,BE"
	"self readFrom: '/Users/sven/Tmp/geo-ip-country/GeoIPCountry.csv'."
	
	^ self new
		data: (filename asFileReference readStreamDo: [ :stream |
					(NeoCSVReader on: stream)
						recordClass: IPAddressRangeCountry;
						addIntegerField: #start: ; addIntegerField: #stop: ; addSymbolField: #country: ;
						upToEnd ]);
		yourself
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
