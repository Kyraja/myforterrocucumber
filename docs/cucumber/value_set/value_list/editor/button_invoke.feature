# *****************************************************************************
#  Name: button_invoke.feature
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Buttonklicks
# *****************************************************************************
@persistent
@VALUE_LIST_BUTTON_INVOKE
Feature: BUTTON_INVOKE_109:4

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

Scenario: ErzeugeWertemengenBezeichner

Given I open an editor "BI_BRD" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "BI_BRD"
And I set field "classname" to "BiBrd"
And I save the current editor
And I close the current editor

Scenario: ErzeugeBezeichnerBaden

Given I open an editor "BI_BADEN" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "BI_BADEN"
And I set field "classname" to "BiBaden"
And I save the current editor
And I close the current editor

Scenario: ErzeugeBezeichnerBayern

Given I open an editor "BI_BAYERN" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "BI_BAYERN"
And I set field "classname" to "BiBayern"
And I save the current editor
And I close the current editor

Scenario: ErzeugeWertBrdBaden

Given I open an editor "BI_BADEN" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "BI_BRD"
And I set field "bezeichner" to "BI_BADEN"
And I set field "wtyp" to "Integer"
And I set field "integer" to "1"
And I save the current editor
And I close the current editor

Scenario: WertemengeLaden

Given I open an editor "BI_LADETAB" from table "(ValueSet):(ValueList)" with command "VIEW" for record ""
And I set field "wmbezeichner" to "BI_BRD"
And I press button "ladetab"
Then the table has 1 rows
Then field "bezeichner^such" has value "BI_BADEN" in row 1
And I close the current editor

Scenario: WertemengeOhneBearbeiten2xLaden

Given I open an editor "BI_LADETAB2x" from table "(ValueSet):(ValueList)" with command "VIEW" for record ""
And I set field "wmbezeichner" to "BI_BRD"
And I press button "ladetab"
Then the table has 1 rows
Then field "bezeichner^such" has value "BI_BADEN" in row 1
And I press button "ladetab"
Then the table has 1 rows
Then field "bezeichner^such" has value "BI_BADEN" in row 1
And I close the current editor

Scenario: WertemengeMitBearbeiten2xLadenNein

Given I open an editor "BI_LADETAB2xNEIN" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "BI_BRD"
And I press button "ladetab"
Then the table has 1 rows
And I create a new row at the end of the table
Then the table has 2 rows
And I set field "bezeichner" to "BI_BAYERN" in row 2
And I set field "integer" to "1" in row 2
# Änderungen verwerfen? Nein -> Abbruch
And I respond with answer "Nein" to the dialog with id "10310"
And I press button "ladetab"
Then the table has 2 rows
Then field "bezeichner^such" has value "BI_BADEN" in row 1
Then field "bezeichner^such" has value "BI_BAYERN" in row 2
And I close the current editor

Scenario: WertemengeMitBearbeiten2xLadenJa

Given I open an editor "BI_LADETAB2xJA" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "BI_BRD"
And I press button "ladetab"
Then the table has 1 rows
And I delete row at position 1
# Änderungen verwerfen? Ja -> Überschreiben
And I respond with answer "Ja" to the dialog with id "10310"
And I press button "ladetab"
Then the table has 1 rows
Then field "bezeichner^such" has value "BI_BADEN" in row 1
And I close the current editor
