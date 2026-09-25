
# *****************************************************************************
#  Name             : ref_steuerobjekte_bei_eu_austritt2_002.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         :  Brexit: Umstellung der Daten; 
#                      offene Vorgaenge als Ausland behandeln
#
#
# *****************************************************************************

@persistent
Feature: ref_steuerobjekte_bei_eu_austritt2_002.feature
Background: Brexit: Umstellung der Daten

Given I set the fake date to "01.07.2002"


@FALL-Brexit
Scenario: Brexit

# neues Land anlegen: Nordirland
# Nordirland wurde schon in einem Vorgaenger angelegt.


# GROSSBRITANNIEN anpassen/umstellen
Given I open an editor "region" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "GROSSBRITANNIEN"
And I set field "egbis" to "30.06.2002"
And I respond with answer "ja" to the dialog with id "5523"
And I respond with answer "ja" to the dialog with id "5523"
And I save the current editor
#####################################################################################################################################

Scenario Outline: Lieferant und Kunde

Given I set the fake date to "01.07.2002"

# Hier Kunden und Lieferanten aus Nordirland umstellen.
# Da Nordirland hier von Anfang an als ein Region existiert, muessen Kunden/Lieferanten dahin 'ziehen'
# um den gleichen Effekt zu erreichen.

Given I open an editor "<such>" from table "<table>" with command "UPDATE" for record "<nummer>"
And I set fields
	| staat		| NORDIRLAND	|
	| staat2	| NORDIRLAND	|

And I save the current editor
Examples:
| table			| such		| nummer	|
| (Customer):(Customer)	| BREXIT5	| 5brexit	|
| (Customer):(Customer)	| BREXIT7	| 7brexit	|
| (Vendor):(Vendor)	| BREXIT5	| 5brexit	|
| (Vendor):(Vendor)	| BREXIT7	| 7brexit	|

