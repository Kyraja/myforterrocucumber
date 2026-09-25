# *****************************************************************************
#  Name           : table_to_head.feature
#  Autor          : fwester
#  Verantwortlich : fwester
#  Funktion       : Macht neuen Abschreibungsvorschlag mit Zeilen, die Betraege
#  haben. Entfernt einen Zeile mit Betrag. Das Ergebnis in Summenfeld muss ok
#  sein.
# *****************************************************************************
@persistent
@TABLE_TO_HEAD_TEST
Feature: CRUD 27:5

Scenario: Create 1st new sequence description
Given I'm logged in with password "annette"
Given I open an editor "Abschreibungsvorschlag neu" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "1"
And I set field "such" to "TABLE2HEAD"
And I append rows
    | betrag | buchen |
    | 10.00  | 1      |
    | 20.00  | 1      |
    | 20.00  | 1      |
Then field "afasumme" has value "50.00"
And I modify table
    | !row | betrag |
    | 2    | 30.00  |
Then field "afasumme" has value "60.00"
And I modify table
    |!row |
    | -2  |
Then field "afasumme" has value "30.00"
And I close the current editor
