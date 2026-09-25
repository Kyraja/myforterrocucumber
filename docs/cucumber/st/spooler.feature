@persistent
@FP_TEST
Feature: Infosystem st/SPOOLER testen

Scenario: Testdaten erstellen

Given I open an editor "Druckverteiler" from table "(Infrastructure):(PrintDistributor)" with command "NEW" for record ""
And I set field "such" to "TESTVERT"
And I set field "name" to "TESTVERTEILER"
And I create a new row at the end of the table
And I set field "drucker" to "11023" in row 1
And I create a new row at the end of the table
And I set field "drucker" to "11018" in row 2
And I save the current editor
And I close the current editor

Given I open an editor "Druckzuordner" from table "(Infrastructure):(PrintAllocator)" with command "NEW" for record ""
And I set field "such" to "TESTZUORD"
And I set field "name" to "TESTZUORDNER"
And I set field "drucker1" to "11023"
And I set field "drucker2" to "11018"
And I save the current editor
And I close the current editor

Given I open an editor "Druckzuordner" from table "(Infrastructure):(PrintAllocator)" with command "NEW" for record ""
And I set field "such" to "DRUCKZUORDNER2"
And I set field "name" to "DRUCKZUORDNER2"
And I set field "drucker1" to "11003"
And I set field "drucker2" to "11004"
And I save the current editor
And I close the current editor

Scenario: Filter testen

Given I open the infosystem "SPOOLER"
And I set field "drucker" to "DATEI"
And I press button "bstart"
Then the table has 24 rows
And I set field "drucker" to "BILDSCHIRM"
Then the table has 0 rows
And I set field "inaktivekanaele" to "ja"
And I press button "bstart"
Then the table has 24 rows
And I set field "inaktivekanaele" to "nein"
Then the table has 0 rows
And I close the current editor

Scenario Outline: Drucker, Druckerteiler, Druckzuordner testen

Given I open the infosystem "SPOOLER"
And I set field "drucker" to "<drucker>"
And I press button "bstart"
Then the table has <rows> rows
Then field "tinspoolerb" has value "<iconbefore>" in row 7
And I press button "tinspoolerb" in row 7
Then field "tinspoolerb" has value "<iconafter>" in row 7
And I press button "drloeschen"
And I close the current editor

Given I query "nummer, such" from table "(PrintParameter):(Spooler)" where "1:spdrucker=<drucker>"
Then query has no hits

Examples:
| row  | drucker        | rows | iconbefore  | iconafter  |
|  001 | DMS-ARCHIV     | 24   | icon:minus  | icon:minus |
|  002 | TESTVERT       | 24   | icon:minus  | icon:ok    |
|  003 | TESTZUORD      | 24   | icon:minus  | icon:ok    |
|  004 | DRUCKZUORDNER2 | 24   | icon:minus  | icon:ok    |

Scenario Outline: Bildschirmdrucker und Dateidrucker testen

Given I open the infosystem "SPOOLER"
And I set field "drucker" to "<spdrucker>"
And I press button "bstart"
Then field "tspooler^<field>" has value "<spdrucker>" in row <zeile>
And I press button "tinspoolerb" in row <zeile>
Then field "tspooler^<field>" is empty in row <zeile>
And I press button "tinspoolerb" in row <zeile>
And I close the current editor

Given I query "nummer,spdrucker" from table "(PrintParameter):(Spooler)" where "nummer==<nummer>;1:spdrucker=<spdrucker>"
Then query has values

| nummer   | spdrucker   |
| <nummer> | <spdrucker> |

Examples:
| row | nummer | spdrucker  | zeile | field      |
| 001 | 15001  | BILDSCHIRM | 1     | vordrucker |
| 002 | 15007  | DATEI      | 6     | datdrucker |
