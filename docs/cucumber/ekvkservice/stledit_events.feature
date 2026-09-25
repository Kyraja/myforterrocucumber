@persistent
Feature: Auftragsfertigungsliste
Background: Test der FO-Eventvariablen bim Absteigen in AFL
Given I set the fake date to "02.01.95"

Scenario: Zwei Mal absteigen aus VK-Auftrag dann wieder aufsteigen.

Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde    | 1    |
And I modify table    
    | artikel    | mge    | !row  |
    | V1         | 10     | +1    |
And I press button "absteig" to open a subeditor for "AFL_Stufe_1" in row 1
And I press button "absteig" to open a subeditor for "AFL_Stufe_1_pseudo" in row 3
And I save the current editor
And I switch the current editor to editor "AFL_Stufe_1"
And I press button "aufsteig" to open a subeditor for "AFL_Stufe_1_pseudo"
And I save the current editor
And I switch the current editor to editor "AFL_Stufe_1"
And I save the current editor
And I switch the current editor to editor "auftrag"
And I save the current editor
