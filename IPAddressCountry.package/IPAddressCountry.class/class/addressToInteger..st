private
addressToInteger: object
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