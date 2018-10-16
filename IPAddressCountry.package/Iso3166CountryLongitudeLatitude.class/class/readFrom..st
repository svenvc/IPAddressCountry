instance creation
readFrom: filename
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