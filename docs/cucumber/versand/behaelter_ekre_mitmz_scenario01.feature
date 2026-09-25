# *****************************************************************************
#  Name             : behaelter_ekre_mitmz_scenario01.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Behaelterfelder werden beim Kopieren einer Rechnung mit Lagerbewegung geleert
#
# *****************************************************************************
@persistent
Feature: behaelter_ekre_mitmz_scenario01.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelterfelder werden beim Kopieren einer Rechnung mit Lagerbewegung geleert
Given I open an editor "Rechnung01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | RE_01   |
And I append rows
    | artikel | mge |
    | RAHMEN  | 1   |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_01a" in row 1
And I modify table
    | !row | exbehnum        | packm |
    | 1    | 8016_Rechnung01 | KLT   |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I switch the current editor to editor "Rechnung01" with command "COPY"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_01b" in row 1
Then field "behaelter" is empty in row 1
Then field "exbehnum" is empty in row 1
Then field "packm" is empty in row 1
And I close the current subeditor to switch back to the parent editor
And I close the current editor
