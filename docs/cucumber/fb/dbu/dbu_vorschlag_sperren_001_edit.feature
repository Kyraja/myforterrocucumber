# *****************************************************************************
#  Name           : dbu_vorschlag_sperren_001_edit.feature
#  Autor          : wane
#  Verantwortlich : wane
#  Kontrolle      :
#  Funktion       : Testet Dauerbuchungsvorschlaege auf Konten- und Kostenobjektsperren.
#
#
#  Beschreibung:
#
#
# *****************************************************************************
#
Feature: dbu_vorschlag_sperren_001_edit.feature
Background: Sperren bei DB-Vorschlag


Scenario: Vorlage mit einem KV, wo gesperrte KST steckt

#
Given I open an editor "kstelle-sperren1" from table "(Account):(CostCenter)" with command "UPDATE" for record "100a"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I save the current editor

#
Given I open an editor "DBV-1000" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBV1000"
And I set field "selr" to "DBR114"
And I set field "selist" to "ja"
And I set field "selerstbd" to "21.1.02"
And I set field "selletztbd" to "15.02.02"
And I press button "selladen"
#
Then the table has 2 rows
Then field "buchen" is modifiable in row 1
Then field "buchen" has value "ja" in row 1
Then field "statusico" has value "icon:ball_green" in row 1
Then field "buchvorl" has value "29" in row 1
Then field "butext" has value "01/02" in row 1
#
Then field "buchen" is not modifiable in row 2
Then field "buchen" has value "nein" in row 2
Then field "statusico" has value "icon:ball_red" in row 2
Then field "buchvorl" has value "32" in row 2
Then field "butext" has value "Vorlage mit Sperren im Kostenverteiler" in row 2
And I press button "bucheschl" to open a subeditor for "Verbuchen" in row 0 with dialog "6932" and answer "Ja"
And I save the current editor
And I close the current editor

# hier wird neues Scenario gestartet, damit der Editor "DBV-1000" geschlossen wird!!!
Scenario: Kontrolle


Given I open an editor "DBV-VIEW1000" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "VIEW" for record "DBV1000"
#
Then the table has 2 rows
Then field "statusico" has value "icon:ball_green" in row 1
Then field "buch" is not empty in row 1
#
Then field "buch" is empty in row 2
Then field "buchen" has value "nein" in row 2
Then field "statusico" has value "icon:ball_red" in row 2
Then field "buchvorl" has value "32" in row 2
Then field "butext" has value "Vorlage mit Sperren im Kostenverteiler" in row 2
And I close the current editor
###############################################################################


Scenario: Vorlage mit einer gesperrten KST


# Kostenstelle sperren
Given I open an editor "kstelle-sperren2" from table "(Account):(CostCenter)" with command "UPDATE" for record "100a"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I save the current editor
#
Given I open an editor "DBV-1010" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBV1010"
And I set field "selr" to "DBR115"
And I set field "selist" to "ja"
And I set field "selerstbd" to "7.1.02"
And I set field "selletztbd" to "15.01.02"
And I press button "selladen"
#
Then the table has 1 rows
Then field "buchen" is not modifiable in row 1
Then field "buchen" has value "nein" in row 1
Then field "statusico" has value "icon:ball_red" in row 1
Then field "buchvorl" has value "37" in row 1
Then field "butext" has value "Vorlage enthält gesperrte Objekte" in row 1
Then saving the current editor throws the exception "Keine Zeilen vorhanden. Bitte zuerst Buchungsvorschläge laden."
And I close the current editor
###############################################################################


Scenario: Vorlage mit gesperrtem Konto

# Kontrolle, dass die Zeile verbuchbar war
Given I open an editor "DBV-1020Kontrolle" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBV1020"
And I set field "selr" to "DBR116"
And I set field "selist" to "ja"
And I set field "selerstbd" to "1.1.02"
And I set field "selletztbd" to "31.01.02"
And I press button "selladen"
#
Then the table has 1 rows
Then field "buchen" is modifiable in row 1
Then field "buchen" has value "ja" in row 1
Then field "statusico" has value "icon:ball_green" in row 1
Then field "buchvorl" has value "34" in row 1
Then field "butext" has value "01/02" in row 1
# ohne zu verbuchen wird geschlossen
And I close the current editor


# Jetzt wird das Konto gesperrt
Given I open an editor "konto-sperren" from table "(Account):(Account)" with command "UPDATE" for record "45000"
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
And I save the current editor


#
Given I open an editor "DBV-1020" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBV1020"
And I set field "selr" to "DBR116"
And I set field "selist" to "ja"
And I set field "selerstbd" to "1.1.02"
And I set field "selletztbd" to "31.01.02"
And I press button "selladen"
#
Then the table has 1 rows
Then field "buchen" is not modifiable in row 1
Then field "buchen" has value "nein" in row 1
Then field "statusico" has value "icon:ball_red" in row 1
Then field "buchvorl" has value "34" in row 1
Then field "butext" has value "Vorlage enthält gesperrte Objekte" in row 1
Then saving the current editor throws the exception "Keine Zeilen vorhanden. Bitte zuerst Buchungsvorschläge laden."
And I close the current editor
###############################################################################


#-----------------------------------------------------------------------
Scenario: Notbremse Fibu-Dauerbuchung; gesperrte KST in Kostenverteiler
#-----------------------------------------------------------------------


#
Given I open an editor "kstelle-entsperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "100a"
Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor

Given I open an editor "DBV-fibu" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "plausi2"
And I set field "selr" to ""
And I set field "selbuart" to "Finanz"
And I set field "selr" to "DBR117"

And I set field "selerstbd" to "1.1.02"
And I set field "selletztbd" to "31.1.02"
And I press button "selladen"
Then the table has 1 rows
Then field "buchen" is modifiable in row 1
Then field "buchen" has value "ja" in row 1
Then field "statusico" has value "icon:ball_green" in row 1
Then field "buchvorl" has value "32" in row 1


# !!! neues login - zweites "fenster" 
Given I'm logged in with password "me"

Given I open an editor "kstelle-sperren3" from table "(Account):(CostCenter)" with command "UPDATE" for record "100a"
Then field "sperrkonfigurationneu" has value ""
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I save the current editor

Given I open an editor "kstelle-view" from table "(Account):(CostCenter)" with command "VIEW" for record "100a"
Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
And I close the current editor


# !!! ZURUECK IM DAUERBUCHUNGSEDITOR
And I switch the current editor to editor "DBV-fibu" 
# 3602 | Kostenverteiler enthaelt gesperrten Objekte
Then saving the current editor throws the exception "3602"
Then field "buchen" is not modifiable in row 1
Then field "buchen" has value "nein" in row 1
Then field "statusico" has value "icon:ball_red" in row 1
Then field "buchvorl" has value "32" in row 1
Then field "butext" has value "Vorlage mit Sperren im Kostenverteiler" in row 1
###############################################################################


