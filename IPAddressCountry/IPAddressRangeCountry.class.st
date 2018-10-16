"
IPAddressRangeCountry holds an IP address range and maps it to a country code.

My start and stop define an inclusive range of IP addresses,
converted to Integers as by IPAddressCountry class>>#addressToInteger:

My country is an two letter Iso3166 Symbol, such as #BE

I am used by IPAddressCountry 

This code is published under the http://en.wikipedia.org/wiki/MIT_License
"
Class {
	#name : #IPAddressRangeCountry,
	#superclass : #Object,
	#instVars : [
		'start',
		'stop',
		'country'
	],
	#category : 'IPAddressCountry'
}

{ #category : #'instance creation' }
IPAddressRangeCountry class >> from: start to: stop country: countryCode [
	^ self new
		start: start;
		stop: stop;
		country: countryCode;
		yourself   
]

{ #category : #comparing }
IPAddressRangeCountry >> compare: integer [
	integer < start ifTrue: [ ^ -1 ].
	integer > stop ifTrue: [ ^ 1 ].
	^ 0   
]

{ #category : #accessing }
IPAddressRangeCountry >> country [
	^ country
]

{ #category : #accessing }
IPAddressRangeCountry >> country: anObject [
	country := anObject
]

{ #category : #testing }
IPAddressRangeCountry >> includes: integer [
	^ (start <= integer) and: [ integer <= stop ]
]

{ #category : #accessing }
IPAddressRangeCountry >> start [
	^ start
]

{ #category : #accessing }
IPAddressRangeCountry >> start: anObject [
	start := anObject
]

{ #category : #accessing }
IPAddressRangeCountry >> stop [
	^ stop
]

{ #category : #accessing }
IPAddressRangeCountry >> stop: anObject [
	stop := anObject
]
