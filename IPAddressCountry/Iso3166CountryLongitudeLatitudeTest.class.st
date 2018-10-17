"
I am Iso3166CountryLongitudeLatitudeTest, a functional test case for Iso3166CountryLongitudeLatitude
"
Class {
	#name : #Iso3166CountryLongitudeLatitudeTest,
	#superclass : #TestCase,
	#category : #IPAddressCountry
}

{ #category : #tests }
Iso3166CountryLongitudeLatitudeTest >> testBelgium [
	| tool coordinates brussels |
	"Initialize the tool from a local CSV file,
	which will download the CSV file from GitHub if necessary"
	tool := Iso3166CountryLongitudeLatitude readFromCSVFile.
	"Get the average/middle coordinates of Belgium"
	coordinates := tool at: #BE.
	"Brussels is more or less in the middle"
	brussels := 4.21 @ 50.51.
	"Assert that the difference is small"
	self assert: (coordinates - brussels) abs < (0.5 @ 0.5)
]
