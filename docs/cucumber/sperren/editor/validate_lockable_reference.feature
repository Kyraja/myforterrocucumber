# *****************************************************************************
#  Name: validate_lockable_reference.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet Validierung einer Verweissperrstelle
#  Das ist die Zeile in der Tabelle von Verweissperrstellen!
# *****************************************************************************
@persistent
@VALIDATE_LOCKABLE_REFERENCE
Feature: CRUD 192:3

Given I'm logged in with password "annette"

Scenario: nok_undefined_name

Given I open an editor "NOK" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "NOK"
And I create a new row at the end of the table
Then field "verweisfeldname" is not modifiable in row 1
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
Then field "verweisfeldname" is modifiable in row 1
Then setting field "verweisfeldname" to " @@@ ??? " in row 1 throws the exception "4446"
And I close the current editor

Scenario: nok_correct_field_in_wrong_location

Given I open an editor "NOK" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "NOK"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
Then setting field "verweisfeldname" to "artikel" in row 1 throws the exception "4446"
And I close the current editor

Scenario: nok_correct_field_but_no_reference

Given I open an editor "NOK" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "NOK"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
Then setting field "verweisfeldname" to "such" in row 1 throws the exception "4446"
And I close the current editor

Scenario: nok_correct_field_but_read_only

Given I open an editor "NOK" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "NOK"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
And I set field "verweisfeldintabelle" to "ja" in row 1
Then setting field "verweisfeldname" to "pos" in row 1 throws the exception "4446"
And I close the current editor

Scenario: nok_correct_field_but_not_lockable

Given I open an editor "NOK" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "NOK"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
And I set field "verweisfeldintabelle" to "ja" in row 1
Then setting field "verweisfeldname" to "kl" in row 1 throws the exception "4446"
And I set field "verweisfeldname" to "artex" in row 1
Then field "verweisfeldname" has value "artikel" in row 1
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 2
And I set field "verweisfeldintabelle" to "ja" in row 2
And I respond with answer "2" to the dialog with id "Variablenauswahl"
And I press button "verweisfeldauswahl" in row 2
Then field "verweisfeldname" is not empty in row 2
And I close the current editor

Scenario: nok_correct_field_but_not_lockable

Given I open an editor "NOK" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "NOK"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
And I set field "verweisfeldintabelle" to "ja" in row 1
Then setting field "verweisfeldname" to "kl" in row 1 throws the exception "4446"
And I set field "verweisfeldname" to "artex" in row 1
Then field "verweisfeldname" has value "artikel" in row 1
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 2
And I set field "verweisfeldintabelle" to "ja" in row 2
And I respond with answer "2" to the dialog with id "Variablenauswahl"
And I press button "verweisfeldauswahl" in row 2
Then field "verweisfeldname" is not empty in row 2
And I close the current editor

Scenario: Set replacement identifier

Given I open an editor "REPLACEMENT" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "REPLACEMENT"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
And I set field "verweisfeldintabelle" to "ja" in row 1
#And I respond with answer "ok" to the dialog with id "3476"
And I set field "verweisfeldname" to "artex" in row 1
Then field "verweisfeldname" has value "artikel" in row 1
And I save the current editor
And I close the current editor

Scenario: nok_condition_field_has_not_compatible_type

Given I open an editor "NOK" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "NOK"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
And I set field "verweisfeldintabelle" to "ja" in row 1
And I set field "verweisfeldname" to "artikel" in row 1
Then setting field "bedingungsfeld" to "baftextbenart" in row 1 throws the exception "4446"
And I close the current editor

Scenario: nok_correct_field_in_wrong_location_screen_validation

Given I open an editor "NOK" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "NOK"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
And I set field "verweisfeldintabelle" to "ja" in row 1
And I set field "verweisfeldname" to "artikel" in row 1
# Jetzt wieder kaputt machen
And I set field "verweisfeldintabelle" to "nein" in row 1
And saving the current editor throws the exception "4446"
And I close the current editor

Scenario: nok_condition_with_condition_field_and_incompatible_value

Given I open an editor "NOK" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "NOK"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
And I set field "verweisfeldintabelle" to "ja" in row 1
And I set field "verweisfeldname" to "artikel" in row 1
And I set field "bedingungsfeld" to "vorganga" in row 1
Then setting field "bedingungswertneu" to "xylophon" in row 1 throws the exception "1361"
#Then message "Der Bedingungswert 'xylophon' in Zeile 1 passt nicht zur Art 'A11' des Bedingungsfeldes.\nunzulässige Angabe" was displayed
Then field "bedingungswert" has value "" in row 1
Then field "bedingungswertneu" has value "" in row 1
Then field "bedingungswertuniversal" has value "(EmptyEntry)" in row 1
And I close the current editor

Scenario: nok_do_not_confirm_correct_location_of_condition_field

Given I open an editor "NOK" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "NOK"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
And I set field "verweisfeldintabelle" to "ja" in row 1
And I set field "verweisfeldname" to "artikel" in row 1
Then field "bedingungsfeldintabelle" has value "nein" in row 1
And I set field "bedingungsfeld" to "kunde" in row 1
And I respond with answer "nein" to the dialog with id "10884"
Then setting field "bedingungsfeld" to "mge" in row 1 throws the exception "1361"
Then field "bedingungsfeld" has value "kunde" in row 1
Then field "bedingungsfeldintabelle" has value "nein" in row 1
Then field "bedingungswertneu" has value "" in row 1
Then field "bedingungswert" has value "" in row 1
Then field "bedingungswertuniversal" has value "(0,0,0)" in row 1
And I close the current editor

Scenario: ok_do_confirm_correct_location_of_condition_field

Given I open an editor "NOK" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "NOK"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
And I set field "verweisfeldintabelle" to "ja" in row 1
And I set field "verweisfeldname" to "artikel" in row 1
Then field "bedingungsfeldintabelle" has value "nein" in row 1
And I set field "bedingungsfeld" to "kunde" in row 1
Then field "bedingungsfeldintabelle" has value "nein" in row 1
And I respond with answer "ja" to the dialog with id "10884"
And I set field "bedingungsfeld" to "mge" in row 1
Then field "bedingungsfeldintabelle" has value "ja" in row 1
Then field "bedingungswertneu" has value "0" in row 1
Then field "bedingungswert" has value "0" in row 1
Then field "bedingungswertuniversal" has value "0.000" in row 1
And I close the current editor

Scenario: conditionfield_change

Given I open an editor "OK" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "OK"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
And I set field "verweisfeldintabelle" to "ja" in row 1
And I set field "verweisfeldname" to "artikel" in row 1
And I set field "bedingungsfeldintabelle" to "ja" in row 1
And I set field "bedingungsfeld" to "konto" in row 1
And I set field "bedingungswertneu" to "44000" in row 1
Then field "bedingungswert" has value "44000" in row 1
Then field "bedingungswertuniversal" has value "(519,5,0)" in row 1
And I set field "bedingungswertneu" to "" in row 1
Then field "bedingungswertuniversal" has value "(0,0,0)" in row 1
And I close the current editor
