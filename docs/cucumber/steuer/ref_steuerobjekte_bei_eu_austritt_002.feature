# *****************************************************************************
#  Name             : ref_steuerobjekte_bei_eu_austritt_002.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Brexit: Umstellung der Daten;
#                     offene Vorgaenge (GS) als EU behandeln
#
#
# *****************************************************************************

@persistent
Feature: ref_steuerobjekte_bei_eu_austritt_002.feature
Background: Brexit: Umstellung der Daten

Given I set the fake date to "01.07.2002"


@FALL-Brexit
Scenario: Brexit

# neues Land anlegen: Nordirland
# Nordirland wurde schon in einem Vorgaenger angelegt.

# GROSSBRITANNIEN anpassen/umstellen
Given I open an editor "region" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "GROSSBRITANNIEN"
And I set field "egab" to "1.1.1973"
And I set field "egbis" to "30.06.2002"
And I set field "such" to "GROSSBRITANNIEN"
And I respond with answer "ja" to the dialog with id "5523"
And I respond with answer "ja" to the dialog with id "5523"
And I save the current editor

## neu Vorgangssteuerregeln anlegen - extra fuer Brexit
#Given I open an editor "vk-vgstrgl" from table "(ProcessTaxRule):(ProcessTaxRule)" with command "COPY" for record "VKEUSTFR"
#And I set field "namebspr" to "Verkauf, EU-Staat, steuerfrei, fuer Brexit"
#And I set field "such" to "VKBREXIT"
#And I save the current editor

# Vorgangssteuerkonfiguration ergaenzen: DL nach Nordirland
Given I open an editor "region" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
And I create a new row at position 13
And I set field "ev" to "Verkauf" in row 13
And I set field "rechnlaart" to "EU-Staat" in row 13
And I set field "bestlaart" to "EU-Staat" in row 13
And I set field "vrgstrgl" to "VKAUSLSTFR" in row 13
And I set field "namebspr" to "Brexit: DL-Abwicklung Nordirland" in row 13
And I create a new row at position 14
And I set field "ev" to "Verkauf" in row 14
And I set field "rechnlaart" to "Ausland" in row 14
And I set field "bestlaart" to "Ausland" in row 14
And I set field "rechnustid" to "vorhanden und aus EU-Staat" in row 14
And I set field "vrgstrgl" to "VKEUSTFR" in row 14
And I set field "namebspr" to "Brexit: EU-Ruecklieferungen Grossbritannien" in row 14
And I create a new row at position 20
And I set field "ev" to "Einkauf" in row 20
And I set field "rechnlaart" to "EU-Staat" in row 20
And I set field "bestlaart" to "EU-Staat" in row 20
And I set field "vrgstrgl" to "EKAUSLSTFR" in row 20
And I set field "namebspr" to "Brexit: DL-Abwicklung Nordirland" in row 20
And I create a new row at position 21
And I set field "ev" to "Einkauf" in row 21
And I set field "rechnlaart" to "Ausland" in row 21
And I set field "bestlaart" to "Ausland" in row 21
And I set field "rechnustid" to "vorhanden und aus EU-Staat" in row 21
And I set field "vrgstrgl" to "EKEUSOFORT" in row 21
And I set field "namebspr" to "Brexit: EU-Ruecklieferungen Grossbritannien" in row 21
And I save the current editor
#####################################################################################################################################

Scenario Outline: Lieferant und Kunde

# Hier Kunden und Lieferanten aus Nordirland umstellen.

Given I open an editor "<such>" from table "<table>" with command "UPDATE" for record "<nummer>"
And I set fields
  | staat  | NORDIRLAND |
  | staat2 | NORDIRLAND |

And I save the current editor
Examples:
  | table                 | such    | nummer  |
  | (Customer):(Customer) | BREXIT5 | 5brexit |
  | (Customer):(Customer) | BREXIT7 | 7brexit |
  | (Vendor):(Vendor)     | BREXIT5 | 5brexit |
  | (Vendor):(Vendor)     | BREXIT7 | 7brexit |
#####################################################################################################################################

