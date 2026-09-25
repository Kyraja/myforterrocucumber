# *****************************************************************************
#  Name             : anbu_anlage_edit_002_aendern.feature
#  Autor            : Waldemar Neufeld
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Daten fuer den Test ref_anl_aend erzeugen
#
# *****************************************************************************

@persistent
Feature: ANBU Fehler
Background: Test des Editors fuer Anlage

Given I set the fake date to "01.01.02"

Given I'm logged in with password "sy"

Scenario: XXXX1

# Jetzt die Anlage 670002 aendern -> GJ 00 ist noch ueber Nachbuchungsmonate bebuchbar
Given I open an editor "anl-670002" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "670002"
And I set field "modart" to "steuer"
And I press button "bafamodell" to open a subeditor for "anl-670002-afamod"
Then field "kstelle" has value ""
Then field "andat" has value "01.01.2000"
Then field "afadat" has value "01.01.2000"
Then field "nmon" has value "12"
Then field "name" has value "GWG 2000"
And I set field "name" to "BLABLA"
And I set field "kstelle" to "100"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

# Jetzt die Anlage 240002 aendern -> GJ 00 ist noch ueber Nachbuchungsmonate bebuchbar
Given I open an editor "anl-240002" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "240002"
And I set field "modart" to "steuer"
And I press button "bafamodell" to open a subeditor for "anl-670002-afamod"
Then field "kstelle" has value ""
Then field "andat" has value "21.03.1975"
Then field "afadat" has value "01.03.1975"
Then field "nmon" has value "600"
Then field "name" has value "Halle 2 alt"
And I set field "name" to "BLABLA"
And I set field "kstelle" to "100"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

# GJ 2000 komplett abschliessen
Given I open an editor "abschl" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set field "nummer" to "200AB"
And I set field "such" to "ABSCHL-00"
Then field "gjakt" has value "01"
# Nachbuchungsmonate 13, 14 und 15 abschliessen
And I press button "fbbbu" in row 3
# 7626: Aktion wirklich durchf�hren?
And I respond with answer "ja" to the dialog with id "7626"
And I save the current editor
And I close the current editor


# Jetzt die Anlage 240002 aendern -> GJ 00 ist noch ueber Nachbuchungsmonate bebuchbar
Given I open an editor "anl-240002" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "240002"
And I set field "modart" to "steuer"
And I press button "bafamodell" to open a subeditor for "anl-670002-afamod"
Then field "kstelle" has value "100"
Then field "andat" has value "21.03.1975"
Then field "afadat" has value "01.03.1975"
Then field "nmon" has value "600"
Then field "name" has value "Halle 2 alt"
And I set field "name" to "BLABLA"
And I set field "kstelle" to "101"
# ohne DIAG speicherbar
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor


# Jetzt die Anlage 670002 aendern -> GJ 00 ist komplett zu
Given I open an editor "anl-670002" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "670002"
And I set field "modart" to "steuer"
And I press button "bafamodell" to open a subeditor for "anl-670002-afamod"
Then field "kstelle" has value "100"
Then field "andat" has value "01.01.2000"
Then field "afadat" has value "01.01.2000"
Then field "nmon" has value "12"
Then field "name" has value "GWG 2000"
And I set field "name" to "Testaenderung der Beschreibung"
And I set field "kstelle" to "101"
# Speichern war nicht moeglich - kam DIAG mit "Ungültiges Datum"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor




# Jetzt die Anlage 235001 aendern -> GJ 00 ist komplett zu
Given I open an editor "anl-235001" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "235001"
And I set field "modart" to "steuer"
And I press button "bafamodell" to open a subeditor for "anl-235001-afamod"
Then field "kstelle" has value ""
Then field "andat" has value "25.04.1995"
Then field "afadat" has value "01.04.1995"
Then field "nmon" has value "1200"
Then field "name" has value "Grund und Boden Halle alt"
And I set field "name" to "Testaenderung ohne Wirkung"
And I set field "kstelle" to "101"
# Speichern war nicht moeglich - kam DIAG mit "Ungültiges Datum"
And I respond with answer "Ja" to the dialog with id "4475"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor


