@persistent
@FP_TEST
Feature: Infosystem st/DRUCKER testen

Scenario: Testdaten erstellen

Given I open an editor "Standort" from table "(Infrastructure):(Location)" with command "NEW" for record ""
And I set field "such" to "FOYER"
And I set field "name" to "FOYER"
And I save the current editor
And I close the current editor

Given I open an editor "Drucker" from table "(Infrastructure):(Printer)" with command "COPY" for record "DATEI"
And I set field "such" to "FOYER"
And I set field "name" to "FOYER"
And I set field "standort" to "FOYER"
And I save the current editor
And I close the current editor

Scenario: Testdaten erstellen

Given I open the infosystem "DRUCKER"
And I press button "bstart"
Then the table has 43 rows
And I set field "kdruckertyp" to "Datei"
And I set field "kaktiv" to "ja"
And I press button "bstart"
Then field "tdruckertyp" has value "Datei" in row 1
Then field "tbueinausb" has value "icon:bulb_on" in row 1
And I set field "kstandard" to "nein"
And I set field "kstandort" to "FOYER"
And I set field "kinaktiv" to "ja"
And I press button "bstart"
Then the table has 1 rows
And I press button "tbueinaus" in row 1
Then field "tbueinausb" has value "icon:bulb_off" in row 1
And I set field "kinaktiv" to "ja"
And I set field "kstandort" to ""
And I press button "bstart"
And I press button "tdrerzeugen" in row 1
And I set field "kaktiv" to "ja"
And I set field "kstandort" to "FOYER"
And I press button "bstart"
And I press button "tbuloeschen" in row 1
And I close the current editor

Given I query "such, aktiv" from table "(Infrastructure):(Printer)" where "such==FOYER;@ablageart=(Filed)"
Then query has values
| such            | aktiv |
| FOYER           | nein  |
