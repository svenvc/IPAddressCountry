"
I am IPAddressCountryTest, a functional test for IPAddressCountry
"
Class {
	#name : #IPAddressCountryTest,
	#superclass : #TestCase,
	#category : #IPAddressCountry
}

{ #category : #tests }
IPAddressCountryTest >> testBelgium [
	| ip tool |
	"Initialize the tool from a local CSV file,
	which will download the CSV file from GitHub if necessary"
	tool := IPAddressCountry readFromCSVFile.
	"Start with some office IP address"
	ip := SocketAddress fromDottedString: '81.83.7.35'.
	"Assert that it is in range known to be in Belgium"
	self assert: (tool atAddress: ip) equals: #BE
]
