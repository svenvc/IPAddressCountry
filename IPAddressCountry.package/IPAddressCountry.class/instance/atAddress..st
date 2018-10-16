accessing
atAddress: object
	"Return a country Symbol for an IP address specified as String or ByteArray"
	
	^ self at: (self class addressToInteger: object)
	  