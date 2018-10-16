accessing
at: countryCode ifAbsent: block
	"Return a Point (longitude@latitude) for the Symbol countryCode"
	
	^ self data at: countryCode ifAbsent: block