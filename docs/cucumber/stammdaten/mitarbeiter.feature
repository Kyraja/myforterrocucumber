# *****************************************************************************
#  Name           : mitarbeiter.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Test ergaenzender Funktionen rund um Mitarbieter.
#                   Die meisten Funktionen werden im Vorgaengertest ref_klm getestet.
#
# *****************************************************************************
#
@persistent
Feature: Mitarbeiter
Background:
Given I set the fake date to "05.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario Outline: STAMMDATEN - Qualifikationen anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "<such>" from table "(Qualifications):(Qualifications)" with command "NEW" for record ""
And I set fields
| such     | <such> |
| namebspr | <name> |
And I save the current editor
Examples:
| such        | name            |
| Q-ENGLISCH  | Englisch        |
| Q-READ      | Lesen           |
| Q-WRITE     | Schreiben       |
| Q-THINK     | Denken          |
| Q-HYDRAULIK | Hydraulikanlage |
| Q-MOTOR     | Motoren         |
| Q-FAHRWERK  | Fahrwerk        |

# ----------------------------------------------------------------------------------------------
Scenario: Qualifikationsliste zum Mitarbeiter
# ----------------------------------------------------------------------------------------------

# Mitarbeiter anlegen
Given I open an editor "Mitarbeiter" from table "(Employee):(Employee)" with command "NEW" for record ""
And I set fields
    | such   | TED |
And I press button "listequal" to open a subeditor for "Qualifikationen"
And I append rows
   | serqual     | gltvon | gltbis      | bem                |
   | Q-ENGLISCH  |      . |   +366      | verhandlungssicher |
   | Q-HYDRAULIK |    +10 | !dontChange | !dontChange        |
And I save the current editor
And I switch the current editor to editor "Mitarbeiter"
And I save the current editor

Given I open an editor "Mitarbeiter2" from table "(Employee):(Employee)" with command "UPDATE" for record from editor "Mitarbeiter"
And I press button "listequal" to open a subeditor for "Qualifikationen"
Then table has values
   | serqual     | gltvon   | gltbis   | bem                |
   | Q-ENGLISCH  | 05.01.95 | 06.01.96 | verhandlungssicher |
   | Q-HYDRAULIK | 15.01.95 |          |                    |
And I delete row at position 2
And I set field "bem" to "Grundkenntnisse" in row 1
And I save the current editor
And I switch the current editor to editor "Mitarbeiter2"
And I save the current editor

Given I open an editor "Mitarbeiter3" from table "(Employee):(Employee)" with command "VIEW" for record from editor "Mitarbeiter2"
And I press button "listequal" to open a subeditor for "Qualifikationen"
Then table has values
   | serqual     | gltvon   | gltbis   | bem                |
   | Q-ENGLISCH  | 05.01.95 | 06.01.96 | Grundkenntnisse    |
And I close the current editor
And I switch the current editor to editor "Mitarbeiter3"
And I close the current editor
