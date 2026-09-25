# *****************************************************************************
#  Name             : kasb_kasbfw_00_kasb1.feature
#  Autor            : Jan Effler
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : ersetzt KASB1.LAD in ref_kasbfw
# *****************************************************************************

Feature: kasb_kasbfw_002_kasb1
Background: 
Scenario: kasb1

Given I set the fake date to "03.03.01"

Given I open an editor "kasb-5" from table "(CashBook):(CashBook)" with command "UPDATE" for record "5"
And I set field "kstelle" to " " in row 1
And I press button "vert" to open a subeditor for "kasb-5-kostenvert" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1
And I set field "proz" to "20" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "80" in row 2
And I save the current subeditor to switch back to the parent editor
And I save the current editor
