instance creation
readFrom: filename
	"Read from a CSV with field start,stop,code as in 3651886848,3651887103,BE"
	"self readFrom: '/Users/sven/Tmp/geo-ip-country/GeoIPCountry.csv'."
	
	^ self new
		data: (filename asFileReference readStreamDo: [ :stream |
					(NeoCSVReader on: stream)
						recordClass: IPAddressRangeCountry;
						addIntegerField: #start: ; addIntegerField: #stop: ; addSymbolField: #country: ;
						upToEnd ]);
		yourself