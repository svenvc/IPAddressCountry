accessing
at: integer
	"Return a country Symbol for an IP address specified as an Integer"

	^ self at: integer ifAbsent: [ nil ]