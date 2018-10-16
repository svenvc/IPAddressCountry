accessing
at: countryCode
	"Return a Point (longitude@latitude) for the Symbol countryCode"
	
	^ self at: countryCode ifAbsent: [ nil ]