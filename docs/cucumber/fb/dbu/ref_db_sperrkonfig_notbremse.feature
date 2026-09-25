# *****************************************************************************
#  Name           : ref_db_sperrkonfig_notbremse.feature
#  Verantwortlich : uo
#  Kontrolle      : wane
#  Funktion       : s. dateiname
#
# *****************************************************************************
@persistent
Feature: Sperrkonfiguration beim Speichern von Dauerbuchungen prüfen - Notbremse

Background:
Given I set the fake date to "31.12.2002"

#-----------------------------------------------------------------------
Scenario: notbremse stat.dauerbuchung
#-----------------------------------------------------------------------

Given I open an editor "DBV-statitisch" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "plausi1"
And I set field "selr" to ""
And I set field "selbuart" to "statistische Buchung"

    # das datum so wählen, dass mindest. eine stat. buchung mit vorlage 10 geladen wird.
    # in vorlage 10 ist das konto 99800 drin!

And I set field "selerstbd" to "3.1.02"
And I set field "selletztbd" to "3.1.02"
And I press button "selladen"
Then the table has 1 rows
Then field "buchen" is modifiable in row 1
Then field "buchen" has value "ja" in row 1
Then field "statusico" has value "icon:ball_green" in row 1
Then field "buchvorl" has value "10" in row 1


# !!! neues login - zweites "fenster" 
Given I'm logged in with password "me"

Given I open an editor "Konto_sperren" from table "(Account):(Account)" with command "UPDATE" for record "99800"
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
And I save the current editor

Given I open an editor "Konto_gesperrt" from table "(Account):(Account)" with command "VIEW" for record "99800"
Then field "sperrkonfigurationneu" has value "Standard-Kontosperre"
And I close the current editor


# !!! ZURUECK IM DAUERBUCHUNGSEDITOR
And I switch the current editor to editor "DBV-statitisch" 
# 3532 |Buchung nicht möglich - Konto gesperrt.
Then saving the current editor throws the exception "3532"
Then field "buchen" is not modifiable in row 1
Then field "buchen" has value "nein" in row 1
Then field "statusico" has value "icon:ball_red" in row 1
Then field "buchvorl" has value "10" in row 1
Then field "butext" has value "Vorlage enthält gesperrte Objekte" in row 1

#-----------------------------------------------------------------------
Scenario: notbremse fibu-dauerbuchung
#-----------------------------------------------------------------------

Given I open an editor "DBV-fibu" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "plausi2"
And I set field "selr" to ""
And I set field "selbuart" to "Finanz"

    # das datum so wählen, dass mindest. eine stat. buchung mit vorlage 1 geladen wird.
    # in vorlage 3 ist das konto 45000 drin!

And I set field "selerstbd" to "3.1.03"
And I set field "selletztbd" to "3.1.03"
And I press button "selladen"
Then the table has 1 rows
Then field "buchen" is modifiable in row 1
Then field "buchen" has value "ja" in row 1
Then field "statusico" has value "icon:ball_green" in row 1
Then field "buchvorl" has value "3" in row 1


# !!! neues login - zweites "fenster" 
Given I'm logged in with password "me"

Given I open an editor "Konto_sperren" from table "(Account):(Account)" with command "UPDATE" for record "45000" 	
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
And I save the current editor

Given I open an editor "Konto_gesperrt" from table "(Account):(Account)" with command "VIEW" for record "45000" 	
Then field "sperrkonfigurationneu" has value "Standard-Kontosperre"
And I close the current editor


# !!! ZURUECK IM DAUERBUCHUNGSEDITOR
And I switch the current editor to editor "DBV-fibu" 
# 3532 |Buchung nicht möglich - Konto gesperrt.
Then saving the current editor throws the exception "3532"
Then field "buchen" is not modifiable in row 1
Then field "buchen" has value "nein" in row 1
Then field "statusico" has value "icon:ball_red" in row 1
Then field "buchvorl" has value "3" in row 1
Then field "butext" has value "Vorlage enthält gesperrte Objekte" in row 1
