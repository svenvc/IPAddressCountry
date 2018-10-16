accessing
at: integer ifAbsent: block
	"Return a country Symbol for an IP address specified as an Integer"

	(integer between: 0 and: (2 raisedToInteger: 32) - 1)
		ifFalse: [ ^ block value ].  
	^ self data 
		findBinary: [ :each | each compare: integer ] 
		do: [ :each | each country ] 
		ifNone: [ :a :b | block value ]