# *****************************************************************************
#  Name           : dbu_vorschlaege_001_verschiedenes.feature
#  Autor          : wane
#  Verantwortlich : wane
#  Kontrolle      :
#  Funktion       : Testet Erzeugung von Dauerbuchungsvorschlaege.
#
#
#  Beschreibung:
#
# *****************************************************************************
#
Feature: Erzeugung von Dauerbuchungsvorschlaege
Background: XXXX

Scenario: 1

Given I open an editor "DBR-mitFehler" from table "(RecurringEntry):(RecurringEntryRules)" with command "NEW" for record ""
And I set field "such" to "MITFEHLER"
And I set field "nummer" to "2mFehler"
And I set field "name" to "Regel mit Fehler siehe REWE-3988"
When I create a new row at the end of the table
And I set field "rbuchvorl" to "2" in row 1
And I set field "kzyklus" to "Q1" in row 1
And I set field "budatvon" to "15.03.02" in row 1
And I set field "bezdat" to "19.01.02" in row 1
#
When I create a new row at the end of the table
And I set field "rbuchvorl" to "3" in row 2
And I set field "kzyklus" to "W1" in row 2
And I set field "budatvon" to "1.02.02" in row 2
#
#
When I create a new row at the end of the table
And I set field "rbuchvorl" to "7" in row 3
And I set field "kzyklus" to "Q2" in row 3
And I set field "budatvon" to "21.04.02" in row 3
#
When I create a new row at the end of the table
And I set field "rbuchvorl" to "8" in row 4
And I set field "kzyklus" to "W2" in row 4
And I set field "budatvon" to "15.02.02" in row 4
#
#
When I create a new row at the end of the table
And I set field "rbuchvorl" to "9" in row 5
And I set field "kzyklus" to "Q3" in row 5
And I set field "budatvon" to "1.03.02" in row 5
#
When I create a new row at the end of the table
And I set field "rbuchvorl" to "26" in row 6
And I set field "kzyklus" to "M15A" in row 6
And I set field "budatvon" to "1.02.02" in row 6
#
And I save the current editor
And I close the current editor



# Fast eine Kopie von DBR 2mFehler: hier wurden nur die Reihenfolge der Zeile
#                                   und die Vorlagen (haben kein Einfluss auf die Berechnung) vertauscht
Given I open an editor "DBR-ohneFehler" from table "(RecurringEntry):(RecurringEntryRules)" with command "NEW" for record ""
And I set field "such" to "OHNEFEHL"
And I set field "nummer" to "3oFehler"
And I set field "name" to "Regel ohne Fehler siehe REWE-3988"
#
When I create a new row at the end of the table
And I set field "rbuchvorl" to "2" in row 1
And I set field "kzyklus" to "W1" in row 1
And I set field "budatvon" to "1.02.02" in row 1
#
When I create a new row at the end of the table
And I set field "rbuchvorl" to "3" in row 2
And I set field "kzyklus" to "W2" in row 2
And I set field "budatvon" to "15.02.02" in row 2
#
#
When I create a new row at the end of the table
And I set field "rbuchvorl" to "7" in row 3
And I set field "kzyklus" to "M15A" in row 3
And I set field "budatvon" to "1.02.02" in row 3

When I create a new row at the end of the table
And I set field "rbuchvorl" to "8" in row 4
And I set field "kzyklus" to "Q1" in row 4
And I set field "budatvon" to "15.03.02" in row 4
And I set field "bezdat" to "19.01.02" in row 4
#
When I create a new row at the end of the table
And I set field "rbuchvorl" to "9" in row 5
And I set field "kzyklus" to "Q2" in row 5
And I set field "budatvon" to "21.04.02" in row 5
#
When I create a new row at the end of the table
And I set field "rbuchvorl" to "26" in row 6
And I set field "kzyklus" to "Q3" in row 6
And I set field "budatvon" to "1.03.02" in row 6
#
And I save the current editor
And I close the current editor

####################

#
Given I open an editor "DBV-1000" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBV33"
And I set field "selr" to "MITFEHLER"
And I set field "selist" to "ja"
And I set field "selerstbd" to "07.01.02"
And I set field "selletztbd" to "31.05.02"
And I press button "selladen"
#
Then the table has 28 rows
Then field "kzyklus" has value "Q1" in row 1
Then field "buchvorl" has value "2" in row 1
Then field "budat" has value "05.04.02" in row 1
# --- Uebergang zum naechsten Zyklus ---
Then field "kzyklus" has value "W1" in row 2
Then field "buchvorl" has value "3" in row 2
Then field "budat" has value "02.02.02" in row 2
#...
Then field "kzyklus" has value "W1" in row 18
Then field "buchvorl" has value "3" in row 18
Then field "budat" has value "25.05.02" in row 18
# --- Uebergang zum naechsten Zyklus ---
Then field "kzyklus" has value "Q2" in row 19
Then field "buchvorl" has value "7" in row 19
Then field "budat" has value "30.04.02" in row 19
# --- Uebergang zum naechsten Zyklus ---
Then field "kzyklus" has value "W2" in row 20
Then field "buchvorl" has value "8" in row 20
Then field "budat" has value "15.02.02" in row 20
#...
Then field "kzyklus" has value "W2" in row 23
Then field "buchvorl" has value "8" in row 23
Then field "budat" has value "10.05.02" in row 23
# --- Uebergang zum naechsten Zyklus ---
Then field "kzyklus" has value "Q3" in row 24
Then field "buchvorl" has value "9" in row 24
Then field "budat" has value "29.03.02" in row 24
# --- Uebergang zum naechsten Zyklus ---
Then field "kzyklus" has value "M15A" in row 25
Then field "buchvorl" has value "26" in row 25
Then field "budat" has value "01.02.02" in row 25
#...
Then field "kzyklus" has value "M15A" in row 28
Then field "buchvorl" has value "26" in row 28
Then field "budat" has value "01.05.02" in row 28
#
And I press button "bucheschl" to open a subeditor for "Verbuchen" in row 0 with dialog "6932" and answer "Ja"
And I save the current editor
And I switch the current editor to editor "DBV-1000"
And I close the current editor

#
Given I open an editor "DBV-2000" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBV34"
And I set field "selr" to "OHNEFEHL"
And I set field "selist" to "ja"
And I set field "selerstbd" to "07.01.02"
And I set field "selletztbd" to "31.05.02"
And I press button "selladen"
#
Then the table has 28 rows
Then field "kzyklus" has value "W1" in row 1
Then field "buchvorl" has value "2" in row 1
Then field "budat" has value "02.02.02" in row 1
# ...
Then field "kzyklus" has value "W1" in row 17
Then field "buchvorl" has value "2" in row 17
Then field "budat" has value "25.05.02" in row 17
# --- Uebergang zum naechsten Zyklus ---
Then field "kzyklus" has value "W2" in row 18
Then field "buchvorl" has value "3" in row 18
Then field "budat" has value "15.02.02" in row 18
# ...
Then field "kzyklus" has value "W2" in row 21
Then field "buchvorl" has value "3" in row 21
Then field "budat" has value "10.05.02" in row 21
# --- Uebergang zum naechsten Zyklus ---
Then field "kzyklus" has value "M15A" in row 22
Then field "buchvorl" has value "7" in row 22
Then field "budat" has value "01.02.02" in row 22
# ...
Then field "kzyklus" has value "M15A" in row 25
Then field "buchvorl" has value "7" in row 25
Then field "budat" has value "01.05.02" in row 25
# --- Uebergang zum naechsten Zyklus ---
Then field "kzyklus" has value "Q1" in row 26
Then field "buchvorl" has value "8" in row 26
Then field "budat" has value "05.04.02" in row 26
# --- Uebergang zum naechsten Zyklus ---
Then field "kzyklus" has value "Q2" in row 27
Then field "buchvorl" has value "9" in row 27
Then field "budat" has value "30.04.02" in row 27
# --- Uebergang zum naechsten Zyklus ---
Then field "kzyklus" has value "Q3" in row 28
Then field "buchvorl" has value "26" in row 28
Then field "budat" has value "29.03.02" in row 28
#
And I press button "bucheschl" to open a subeditor for "Verbuchen" in row 0 with dialog "6932" and answer "Ja"
And I save the current editor
And I switch the current editor to editor "DBV-2000"
And I close the current editor
###############################################################################


