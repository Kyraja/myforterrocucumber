# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : 
#  Funktion       : 
# *****************************************************************************
@persistent
Feature: uE-Buchungswert manuell verwerfen und prüfen
Background:
Given I set the fake date to "30.03.02"

Scenario: 01 sucht u. verwendet eine im uE gebuchte Bewertung mit Fall 39 aus den direkt erzeugten, als Grundlage für den test.
#--------------------------------------------------------------------------------------------------------------------------------

# u.a. sind das die voraussetzungen für manuelles verwerfen des ue.
Given I'm logged in with password "annette"
Given I enable the flag 71
Given I enable the flag 82

Given I open an editor "ue_verwerf1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==E1A-VM;such==F39;uestatus==gebucht;buart==Abgang;@richtung=vorwaerts;@maxtreffer=1"
Then the table has 1 rows
Then field "tuebuwert" has value "50.00" in row 1
And I press button "cpueverwerfen"
And I close the current editor

Given I open an editor "ue_verwerf2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==E1A-VM;such==F39;uestatus==gemischt;buart==Abgang;@richtung=vorwaerts;@maxtreffer=1"
Then the table has 2 rows
Then field "tuestatus" has value "verworfen" in row 1
Then field "tuebuwert" has value "0.00" in row 1
And I close the current editor

Given I open an editor "ue_verwerf3" from table "(Valuation):(Valuation)" with command "UPDATE" for search criteria "$,,artikel==E1A-VM;such==F39;uestatus==gemischt;buart==Abgang;@richtung=vorwaerts;@maxtreffer=1"
And I set field "kostobj" to "100002" in row 1
And I save the current editor


