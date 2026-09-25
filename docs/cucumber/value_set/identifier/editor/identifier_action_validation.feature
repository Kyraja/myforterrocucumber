# *****************************************************************************
#  Name: identifier_action_validation.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Zulässigkeit des Datensatzes
# *****************************************************************************
@persistent
@IDENTIFIER_ACTION_VALIDATION
Feature: ACTION_VALIDATION_109:2

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298


Scenario: ErzeugeTestBezeichner

Given I open an editor "TEST1" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "TESTBEZ1"
And I set field "classname" to "TestIdent1"
And I save the current editor
And I close the current editor

Given I open an editor "TEST2" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "TESTBEZ2"
And I set field "classname" to "TestIdent2"
And I save the current editor
And I close the current editor

Given I enable the flag 298
Given I open an editor "STD1" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "nummer" to "2000"
And I set field "such" to "STD1"
And I set field "classname" to "TestIdent3"
And I save the current editor
And I close the current editor
Given I disable the flag 298

Scenario: ErzeugeAufzMitEinemBezeichner

Given I open an editor "AUFZ1" from table "(Enumeration):(Enumeration)" with command "NEW" for record ""
And I set field "such" to "TESTENUM1"
And I set field "classname" to "TestEnum1"
And I set field "tabart" to "P109:2"
And I append rows
   | vaufzelem           | aebez              |
   | Wertemenge TESTBEZ1 | Testbezeichner1    |
   | Wertemenge STD1     | TestbezeichnerStd  |
And I respond with answer "Nein" to the dialog with id "10951"
And I save the current editor
And I close the current editor

# Tests

# Der Versuch einen gelieferten Bezeichner (mit Verw. in AZ) zu entfernen MUSS scheitern.
Scenario: StandardbezeichnerEntfernenScheitert
Then opening an editor from table "(ValueSet):(Identifier)" with command "DELETE" for record "2000" throws the exception "3560"

# Der Versuch einen gelieferten Bezeichner (mit Verw. AZ) privilegiert zu entfernen darf nicht scheitern.
Scenario: StandardbezeichnerPrivilegiertEntfernenScheitertNicht
Given I enable the flag 298
Given I open an editor "FORCED_DELETE_IDENTIFIER" from table "(ValueSet):(Identifier)" with command "DELETE" for record "2000"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor
Given I disable the flag 298

# Der Versuch einen individuellen Bezeichner ohne Verwendung in einer Aufzählung zu entfernen darf nicht scheitern.
Scenario: NichtInAufzVerwendetenBezeichnerEntfernenScheitertNicht
Given I open an editor "DELETE_IDENTIFIER" from table "(ValueSet):(Identifier)" with command "DELETE" for record "TESTBEZ2"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

# Der Versuch einen individuellen Bezeichner mit Verwendung in einer Aufzählung zu entfernen MUSS scheitern
Scenario: InAufzVerwendetenBezeichnerEntfernenScheitert
Then opening an editor from table "(ValueSet):(Identifier)" with command "DELETE" for record "TESTBEZ1" throws the exception "40"
