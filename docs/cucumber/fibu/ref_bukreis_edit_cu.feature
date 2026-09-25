#  Verantwortlich   : uo

@persistent
Feature: Buchungskreiseditor pruefen

Background: Buchungskreise

Given I set the fake date to "02.01.95"

Scenario: Fehlermeldung bei deaktiver paralleler Rechnungslegung prüfen

Given I open an editor "check_config" from table "(Company):(Configuration)" with command "VIEW" for record "0k"
Then field "pararele" has value "nein"
And I close the current editor

Then opening an editor from table "(AcctngMasterFiles):(SetOfBooksConfiguration)" with command "NEW" for record "" throws the exception "5951"
