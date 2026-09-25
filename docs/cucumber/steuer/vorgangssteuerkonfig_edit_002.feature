# *****************************************************************************
#  Name             : vorgangssteuerkonfig_edit_002.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Editierbarkeit von Vorgangssteuerkonfiguration
#
#
#
#
# *****************************************************************************
@persistent
Feature: vorgangssteuerkonfig_edit_002.feature
Background: Editierbarkeit von Vorgangssteuerkonfiguration


Scenario: eine Zeile an der Position 1

Given I open an editor "konfig-01" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
Then field "nummer" has value "500"
Then field "nummer" is modifiable
Then field "such" has value "VSRV"
Then field "such" is modifiable
Then field "namebspr" has value "Vorschlag Vorgangssteuerregel"
Then field "namebspr" is modifiable
#
Then the table has 68 rows
#
# Kontrolle in der Zeile 1
#
Then field "ev" has value "Verkauf" in row 1
Then field "ev" is modifiable in row 1
Then field "rechnlaart" has value "Inland" in row 1
Then field "rechnlaart" is modifiable in row 1
Then field "rechnland" has value "" in row 1
Then field "rechnland" is modifiable in row 1
Then field "bestlaart" has value "Inland" in row 1
Then field "bestlaart" is modifiable in row 1
Then field "bestland" has value "" in row 1
Then field "bestland" is modifiable in row 1
Then field "rechnustid" has value "irrelevant" in row 1
Then field "rechnustid" is modifiable in row 1
Then field "rechnustidland" has value "" in row 1
Then field "rechnustidland" is not modifiable in row 1
Then field "bestustid" has value "irrelevant" in row 1
Then field "bestustid" is modifiable in row 1
Then field "bestustidland" has value "" in row 1
Then field "bestustidland" is not modifiable in row 1
Then field "standard" has value "ja" in row 1
Then field "standard" is modifiable in row 1
Then field "vrgstrgl" has value "VKINL" in row 1
Then field "vrgstrgl" is modifiable in row 1
Then field "vrgstrglname" is not empty in row 1
Then field "vrgstrglname" is not modifiable in row 1
Then field "namebspr" is not empty in row 1
Then field "ftext" is empty in row 1
Then field "ftext" is modifiable in row 1

# Manipulationen in der Zeile 1
And I set field "ev" to "Einkauf" in row 1
# 2743|Vorgang abgebrochen
And saving the current editor throws the exception "2743"
# Abfrage funktioniert zur Zeit nicht
#Then message "Mehrdeutige Zuordnung in Zeilen 1 und 14." was displayed
#
And I set field "ev" to "Verkauf" in row 1

And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: neue Zeile in der Mitte der Tabelle

Given I open an editor "konfig-01" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
Then field "nummer" has value "500"
Then field "nummer" is modifiable
Then field "such" has value "VSRV"
Then field "such" is modifiable
Then field "namebspr" has value "Vorschlag Vorgangssteuerregel"
Then field "namebspr" is modifiable
#
Then the table has 68 rows
And I create a new row at position 32

Then field "ev" is empty in row 32
Then field "rechnlaart" is empty in row 32
Then field "rechnland" is empty in row 32
Then field "bestlaart" is empty in row 32
Then field "bestland" is empty in row 32
Then field "rechnustid" is not empty in row 32
Then field "rechnustidland" is empty in row 32
Then field "bestustid" is not empty in row 32
Then field "bestustidland" is empty in row 32
Then field "standard" is not empty in row 32
Then field "standard" has value "nein" in row 32
Then field "vrgstrgl" is empty in row 32
Then field "vrgstrglname" is empty in row 32
Then field "namebspr" is empty in row 32
Then field "ftext" is empty in row 32
Then field "ftext" is modifiable in row 32

# 10031 |Vorgangssteuerregel passt nicht zu Vorgang. -> weil "ev" noch leer ist
Then setting field "vrgstrgl" to "EKINL" in row 32 throws the exception "10031"
And I set field "vrgstrgl" to "" in row 32


And I set field "ev" to "Einkauf" in row 32
And I set field "rechnlaart" to "Inland" in row 32
# Fehlerfall mit USA
# 2708 |Landart passt nicht zur Landart des Rechnungslandes.
Then setting field "rechnland" to "USA" in row 32 throws the exception "2708"
And I set field "rechnland" to "BAYERN" in row 32
#
# komplette Meldung ist:
#      Folgende Pflichtfelder sind nicht ausgefuellt:
#      Landart des Bestimmungslands in Zeile 32
#      Vorgang-Steuerregel in Zeile 32
#      Landart des Bestimmungslands in Zeile 32 bitte eintragen
#
# 10179 |bitte eintragen
And saving the current editor throws the exception "10179"
#
And I set field "bestlaart" to "EU-Staat" in row 32
And I set field "bestland" to "" in row 32
And I set field "standard" to "ja" in row 32
And I set field "vrgstrgl" to "EKINL" in row 32
Then field "vrgstrglname" is not empty in row 32
Then field "vrgstrglname" is not modifiable in row 32
And I set field "namebspr" to "BAYERN -> EU extra behandeln" in row 32
#
Then the table has 69 rows

And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: Zeileoperationen: Verschieben/Loeschen

Given I open an editor "konfig-zeilen1" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
Then field "nummer" has value "500"
Then the table has 69 rows

Then field "ev" has value "Verkauf" in row 1
Then field "rechnlaart" has value "Inland" in row 1
Then field "rechnland" has value "" in row 1
Then field "bestlaart" has value "Inland" in row 1
Then field "bestland" has value "" in row 1
Then field "rechnustid" has value "irrelevant" in row 1
Then field "rechnustidland" has value "" in row 1
Then field "bestustid" has value "irrelevant" in row 1
Then field "bestustidland" has value "" in row 1
Then field "standard" has value "ja" in row 1
Then field "vrgstrgl" has value "VKINL" in row 1
Then field "vrgstrglname" is not empty in row 1
Then field "namebspr" is not empty in row 1

And I move rows "1" to position "11"

Then field "ev" has value "Verkauf" in row 1
Then field "rechnlaart" has value "Inland" in row 1
Then field "rechnland" has value "" in row 1
Then field "bestlaart" has value "Inland" in row 1
Then field "bestland" has value "" in row 1
Then field "rechnustid" has value "irrelevant" in row 1
Then field "rechnustidland" has value "" in row 1
Then field "bestustid" has value "irrelevant" in row 1
Then field "bestustidland" has value "" in row 1
Then field "standard" has value "nein" in row 1
Then field "vrgstrgl" has value "VKINLSTFR" in row 1
Then field "vrgstrglname" is not empty in row 1
Then field "namebspr" is not empty in row 1


Then field "ev" has value "Verkauf" in row 10
Then field "rechnlaart" has value "Inland" in row 10
Then field "rechnland" has value "" in row 10
Then field "bestlaart" has value "Inland" in row 10
Then field "bestland" has value "" in row 10
Then field "rechnustid" has value "irrelevant" in row 10
Then field "rechnustidland" has value "" in row 10
Then field "bestustid" has value "irrelevant" in row 10
Then field "bestustidland" has value "" in row 10
Then field "standard" has value "ja" in row 10
Then field "vrgstrgl" has value "VKINL" in row 10
Then field "vrgstrglname" is not empty in row 10
Then field "namebspr" is not empty in row 10
Then the table has 69 rows

And I save the current editor
And I close the current editor


Given I open an editor "konfig-zeilen2" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
Then field "nummer" has value "500"
Then the table has 69 rows

And I delete row at position 32

Then the table has 68 rows
And I save the current editor
And I close the current editor


Given I open an editor "konfig-zeilen3" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
Then field "nummer" has value "500"
Then the table has 68 rows

And I delete all rows

Then the table has 0 rows
# 1188 |keine Zeile vorhanden
And saving the current editor throws the exception "1188"
#
# ohne Speichern beenden
And I close the current editor


