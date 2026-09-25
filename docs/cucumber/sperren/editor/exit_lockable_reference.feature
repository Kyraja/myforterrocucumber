# *****************************************************************************
#  Name: exit_lockable_reference.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet Feldaustritte bei der Verweissperrstelle
#  Das ist die Zeile in der Tabelle von Verweissperrstellen!
# *****************************************************************************
@persistent
@EXIT_LOCKABLE_REFERENCE
Feature: CRUD 192:3

Given I'm logged in with password "annette"

Scenario: exit_verweisfeldingruppe

Given I open an editor "verweisfeldingruppe" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "VERWEISFELDINGRUPPE"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
And I set field "verweisfeldintabelle" to "ja" in row 1
And I set field "verweisfeldname" to "artikel" in row 1
And I set field "bedingungsfeldintabelle" to "ja" in row 1
And I set field "bedingungsfeld" to "mge" in row 1
And I set field "bedingungswertneu" to "100000" in row 1
Then field "bedingungsfeldbedeutung" has value "Menge in Handelseinheit Verkauf" in row 1
Then field "bedingungsfeldart" has value "ARTR51000" in row 1
Then field "bedingungswertuniversal" has value "100000.000" in row 1
Then field "bedingungswert" has value "100.000" in row 1
Then field "bedingungswertneu" has value "100.000" in row 1
And I set field "verweisfeldingruppe" to "" in row 1
Then field "bedingungsfeldintabelle" has value "nein" in row 1
Then field "bedingungsfeld" has value "" in row 1
Then field "bedingungsfeldbedeutung" has value "" in row 1
Then field "bedingungsfeldart" has value "" in row 1
Then field "bedingungswertuniversal" has value "" in row 1
Then field "bedingungswert" has value "" in row 1
Then field "bedingungswertneu" has value "" in row 1
And I close the current editor

Scenario: exit_verweisfeldintabelle

Given I open an editor "verweisfeldintabelle" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "VERWEISFELDINTABELLE"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
And I set field "verweisfeldintabelle" to "ja" in row 1
And I set field "verweisfeldname" to "artikel" in row 1
And I set field "bedingungsfeldintabelle" to "ja" in row 1
And I set field "bedingungsfeld" to "mge" in row 1
And I set field "bedingungswertneu" to "100000" in row 1
Then field "bedingungsfeldbedeutung" has value "Menge in Handelseinheit Verkauf" in row 1
Then field "bedingungsfeldart" has value "ARTR51000" in row 1
Then field "bedingungswertuniversal" has value "100000.000" in row 1
Then field "bedingungswert" has value "100.000" in row 1
Then field "bedingungswertneu" has value "100.000" in row 1
And I set field "verweisfeldintabelle" to "nein" in row 1
Then field "bedingungsfeldintabelle" has value "nein" in row 1
Then field "bedingungsfeld" has value "" in row 1
Then field "bedingungsfeldbedeutung" has value "" in row 1
Then field "bedingungsfeldart" has value "" in row 1
Then field "bedingungswertuniversal" has value "" in row 1
Then field "bedingungswert" has value "" in row 1
Then field "bedingungswertneu" has value "" in row 1
And I close the current editor

Scenario: exit_bedingungsfeld

Given I open an editor "bedingungsfeld" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "BEDINGUNGSFELD"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
And I set field "verweisfeldintabelle" to "ja" in row 1
And I set field "verweisfeldname" to "artikel" in row 1
And I set field "bedingungsfeldintabelle" to "ja" in row 1
And I set field "bedingungsfeld" to "mge" in row 1
And I set field "bedingungswertneu" to "100000" in row 1
Then field "bedingungsfeldbedeutung" has value "Menge in Handelseinheit Verkauf" in row 1
Then field "bedingungsfeldart" has value "ARTR51000" in row 1
Then field "bedingungswertuniversal" has value "100000.000" in row 1
Then field "bedingungswert" has value "100.000" in row 1
Then field "bedingungswertneu" has value "100.000" in row 1
And I set field "bedingungsfeld" to "" in row 1
Then field "bedingungsfeldbedeutung" has value "" in row 1
Then field "bedingungsfeldart" has value "" in row 1
Then field "bedingungsfeldintabelle" has value "ja" in row 1
Then field "bedingungswertuniversal" has value "" in row 1
Then field "bedingungswert" has value "" in row 1
Then field "bedingungswertneu" has value "" in row 1
And I close the current editor



