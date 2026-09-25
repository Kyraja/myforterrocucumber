# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : 
#  Funktion       : 
# *****************************************************************************
@persistent
Feature: uE-Buchungswert manuell verwerfen und prüfen
Background:
Given I set the fake date to "12.04.02"

Scenario: 01 uE verwerfen Bewertungskette fuer Fertigungsleistung aus den direkt erzeugten
#-----------------------------------------------------------------------------------------

# u.a. sind das die voraussetzungen für manuelles verwerfen des ue.
Given I'm logged in with password "annette"
Given I enable the flag 71
Given I enable the flag 82

Given I open an editor "ue_fl_verwerf1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,such==BUCHBAR6-4;@ablageart=abgelegt;@maxtreffer=1"
Then the table has 3 rows
Then field "tuebuwert" has value "30.00" in row 3
And I press button "cpueverwerfen"
And I close the current editor
