#**********************************************************************************
#
#  Name            : bman1.feature
#  Datum           : 04.02.2025
#  Autor           : lclaus
#  Verantwortlich  : teampss
#  Kontrolle       :
#  Funktion        : Pruefung von Maskenfunktionalitaet und Eingabeplausipruefungen
#                    bei Behaelterkreislauf.
#                    Wird erweitert um weitere Pruefungen im Bereich
#                    Behaelterkontenverwaltung
#
#
#**********************************************************************************
#
Feature: Behaelterkontenverwaltung
Background:
Given I set the fake date to "02.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario: Pruefen von genau 3 Nachkommastellen bei der Menge
# ----------------------------------------------------------------------------------------------
Given I open an editor "Behaelterbuchung-1" from table "(ContainerAccounting):(ContainerAccounting)" with command "NEW" for record ""
And I set field "ebeleg" to "eee3333"
# Ungueltiger Feldwert
And setting field "mge" to "1.2345" throws the exception "1361"
#And I close the current editor
And I set fields
	| mge   | 1.234  |
	| bhkto | 1000   |
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Eingabe in Behaelterkreislauf pruefen
# ----------------------------------------------------------------------------------------------
Given I open an editor "Behaelterkresilauf-2" from table "(ContainerAccount):(ContainerCycle)" with command "NEW" for record ""
# Ungueltiger Feldwert
Then setting field "such" to "123" throws the exception "1361"
And I set field "such" to "KL123"
# Bitte eingeben (sendempf fehlt)
Then saving the current editor throws the exception "10179"
And I set field "sendempf" to "1"
And I save the current editor

Given I open an editor "Bhaelterkonto123" from table "(ContainerAccount):(ContainerCycle)" with command "UPDATE" for record "KL123"
And I create a new row at the end of the table
And I set field "tpartner" to "k 050" in row 1
# Die Kombination Geschaeftspartner und Werk gibt es schon
Then setting field "twerk" to "003" in row 1 throws the exception "8646"

And I set field "twerk" to "001" in row 1

And I create a new row at the end of the table
And I set field "tpartner" to "k 1" in row 5

And I create a new row at the end of the table
And I set field "tpartner" to "L 1" in row 6

And I create a new row at the end of the table
And I set field "tpartner" to "k 050" in row 7
# Die Kombination Geschaeftspartner und Werk gibt es schon
Then setting field "twerk" to "001" in row 7 throws the exception "8646"
And I delete row at position 7
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Behaelterkontoauszug bearbeiten
# ----------------------------------------------------------------------------------------------
Given I open an editor "KAZ0021" from table "(ContainerAccounting):(ContainerStatement)" with command "UPDATE" for record "KAZ002"
And I press button "ladetab"
# Es gibt bereis einen Behaelterkontoauszug...fortfahren?
#And I respond with answer "Ja" to the dialog with id "666"
And I press button "abgleichen"
And I save the current editor

Given I open an editor "KAZ003" from table "(ContainerAccounting):(ContainerStatement)" with command "UPDATE" for record "KAZ003"
And I press button "ladetab"
# Es gibt bereis einen Behaelterkntoauszug...fortfahren?
#And I respond with answer "Ja" to the dialog with id ""
And I press button "abgleichen"
And I save the current editor

# (In der GUI "Behaelterkontoauszug")
Given I open an editor "KAZ004" from table "(ContainerAccounting):(ContainerStatement)" with command "UPDATE" for record "KAZ004"
And I press button "ladetab"
And I press button "abgleichen"
# Ablegen?
And I respond with answer "Nein" to the dialog with id "1748"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Behaelterkontoauszug bearbeiten/ dokuart aendern
# ----------------------------------------------------------------------------------------------
Given I open an editor "kontoauszug" from table "(ContainerAccounting):(ContainerStatement)" with command "COPY" for record "303"
And I set field "dokuart" to "Ausgang"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Identischen Behaelterkreislauf neu anlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "BehaelterkontoBehaelterkreislauf-4" from table "(ContainerAccount):(ContainerCycle)" with command "NEW" for record ""
And I set fields
	| such     | GLASKOPIE  |
	| sendempf | 051        |
And I create a new row at the end of the table
And I set field "tpartner" to "k 051" in row 1
Then setting field "twerk" to "G2" in row 1 throws the exception "8646"
And I create a new row at the end of the table
And I set field "tpartner" to "k 051" in row 2
# Kreislauf schon vorhanden
Then setting field "twerk" to "G1" in row 2 throws the exception "8646"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Behaelterkreislaeufe ohne Werk
# ----------------------------------------------------------------------------------------------
Given I open an editor "Behaelterkreislauf-5" from table "(ContainerAccount):(ContainerCycle)" with command "NEW" for record ""
And I set fields
	| such     | OHNEWERK1  |
	| sendempf | 051        |
And I create a new row at the end of the table
And I set field "tpartner" to "L 001" in row 1
And I create a new row at the end of the table
And I set field "tpartner" to "L 002" in row 2
And I save the current editor

Given I open an editor "Behaelterkreislauf-6" from table "(ContainerAccount):(ContainerCycle)" with command "NEW" for record ""
#lterkreislauf
And I set fields
	| such     | OHNEWERK2  |
	| sendempf | 051        |
And I create a new row at the end of the table
And I set field "tpartner" to "L 001" in row 1
And I create a new row at the end of the table
And I set field "tpartner" to "L 002" in row 2
# Behaelterkreislauf ist bereits vorhanden
Then saving the current editor throws the exception "7858"
And I set field "tpartner" to "L 003" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: TC-BMAN-016: Testen der FOP-Funktionen containeraccountopeningbalance, containeraccountclosingbalance
# ----------------------------------------------------------------------------------------------
Given I execute FOP "BMAN1.FOP"


# ----------------------------------------------------------------------------------------------
Scenario: Versuch Behaelterkonto 1280 per Lader anlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "BehaelterkontoBehaelterkonto-7" from table "(ContainerAccount):(ContainerAccount)" with command "NEW" for record ""
And I set fields
	| nummer  | 1280          |
	| such    | TESLA         |
	| name    | Tesla Werk 1  |
	| artikel | 501           |
	| partner | K 304         |
# keine Kontofuehrung
Then saving the current editor throws the exception "10179"
And I close the current editor
