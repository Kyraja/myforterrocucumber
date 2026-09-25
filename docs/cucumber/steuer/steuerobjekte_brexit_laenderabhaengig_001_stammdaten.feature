# *****************************************************************************
#  Name             : steuerobjekte_brexit_laenderabhaengig_001_stammdaten.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Brexit: Umstellung der Daten;
#                     offene Vorgaenge (GS) als EU behandeln
#
#
# *****************************************************************************

@persistent
Feature: steuerobjekte_brexit_laenderabhaengig_001_stammdaten.feature
Background: Brexit: Umstellung der Daten

Given I set the fake date to "01.07.2002"


@FALL-Brexit
Scenario: Brexit

Given I set the fake date to "01.07.2002"

# GROSSBRITANNIEN anpassen/umstellen
Given I open an editor "region" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "GROSSBRITANNIEN"
And I set field "egbis" to "30.06.2002"
And I set field "such" to "GROSSBRITANNIEN"
And I respond with answer "ja" to the dialog with id "5523"
And I respond with answer "ja" to the dialog with id "5523"
And I save the current editor

# Vorgangssteuerkonfiguration ergaenzen: DL nach Nordirland
Given I open an editor "region" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
#   VERKAUF
And I create a new row at the end of the table
And I set field "ev" to "Verkauf" in row !lastRow
And I set field "standard" to "nein" in row !lastRow
And I set field "rechnlaart" to "Ausland" in row !lastRow
And I set field "rechnland" to "NORDIRL" in row !lastRow
And I set field "bestlaart" to "Ausland" in row !lastRow
And I set field "bestland" to "NORDIRL" in row !lastRow
And I set field "vrgstrgl" to "VKAUSLSTFR" in row !lastRow
And I set field "namebspr" to "Brexit: DL-Abwicklung Nordirland" in row !lastRow
And I create a new row at the end of the table
And I set field "ev" to "Verkauf" in row !lastRow
And I set field "standard" to "ja" in row !lastRow
And I set field "rechnlaart" to "Ausland" in row !lastRow
And I set field "rechnland" to "NORDIRL" in row !lastRow
And I set field "bestlaart" to "Ausland" in row !lastRow
And I set field "bestland" to "NORDIRL" in row !lastRow
And I set field "rechnustid" to "vorhanden und aus EU-Staat" in row !lastRow
And I set field "vrgstrgl" to "VKEUSTFR" in row !lastRow
And I set field "namebspr" to "Brexit: EU-Ruecklieferungen Grossbritannien" in row !lastRow
# damit Gutschriften mit GBR moeglich sind
And I create a new row at the end of the table
And I set field "ev" to "Verkauf" in row !lastRow
And I set field "standard" to "ja" in row !lastRow
And I set field "rechnlaart" to "Ausland" in row !lastRow
And I set field "rechnland" to "GROSSBRITANNIEN" in row !lastRow
And I set field "bestlaart" to "Ausland" in row !lastRow
And I set field "bestland" to "GROSSBRITANNIEN" in row !lastRow
And I set field "rechnustid" to "vorhanden und aus EU-Staat" in row !lastRow
And I set field "vrgstrgl" to "VKEUSTFR" in row !lastRow
And I set field "namebspr" to "Brexit: EU-Ruecklieferungen Grossbritannien" in row !lastRow

#   EINKAUF
And I create a new row at the end of the table
And I set field "ev" to "Einkauf" in row !lastRow
And I set field "rechnlaart" to "EU-Staat" in row !lastRow
And I set field "bestlaart" to "EU-Staat" in row !lastRow
And I set field "vrgstrgl" to "EKAUSLSTFR" in row !lastRow
And I set field "namebspr" to "Brexit: DL-Abwicklung Nordirland" in row !lastRow
And I create a new row at the end of the table
And I set field "ev" to "Einkauf" in row !lastRow
And I set field "standard" to "ja" in row !lastRow
And I set field "rechnlaart" to "Ausland" in row !lastRow
And I set field "rechnland" to "NORDIRL" in row !lastRow
And I set field "bestlaart" to "Ausland" in row !lastRow
And I set field "bestland" to "NORDIRL" in row !lastRow
And I set field "rechnustid" to "vorhanden und aus EU-Staat" in row !lastRow
And I set field "vrgstrgl" to "EKEUSOFORT" in row !lastRow
And I set field "namebspr" to "Brexit: DL-Abwicklung Nordirland" in row !lastRow
# damit Gutschriften mit GBR moeglich sind
And I create a new row at the end of the table
And I set field "ev" to "Einkauf" in row !lastRow
And I set field "standard" to "nein" in row !lastRow
And I set field "rechnlaart" to "Ausland" in row !lastRow
And I set field "rechnland" to "GROSSBRITANNIEN" in row !lastRow
And I set field "bestlaart" to "Ausland" in row !lastRow
And I set field "bestland" to "GROSSBRITANNIEN" in row !lastRow
And I set field "rechnustid" to "vorhanden und aus EU-Staat" in row !lastRow
And I set field "vrgstrgl" to "EKEUSOFORT" in row !lastRow
And I set field "namebspr" to "Brexit: DL-Abwicklung Nordirland" in row !lastRow
And I save the current editor
#####################################################################################################################################

