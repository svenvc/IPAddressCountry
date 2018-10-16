"
I am BaselineOfIPAddressCountry.
I am a BaselineOf.

IPAddressCountry maps IPv4 addresses to ISO 3166 2-char country codes and their average coordinates.
"
Class {
	#name : #BaselineOfIPAddressCountry,
	#superclass : #BaselineOf,
	#category : #BaselineOfIPAddressCountry
}

{ #category : #baselines }
BaselineOfIPAddressCountry >> baselineOf: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec baseline: 'NeoCSV' with: [ spec repository: 'github://svenvc/NeoCSV:master/repository' ].
			spec baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON:master/repository' ].
			spec package: 'IPAddressCountry' with: [ spec requires: #('IPAddressCountry') ].
			spec group: 'default' with: #('IPAddressCountry') ]
]
