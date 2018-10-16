comparing
compare: integer
	integer < start ifTrue: [ ^ -1 ].
	integer > stop ifTrue: [ ^ 1 ].
	^ 0   