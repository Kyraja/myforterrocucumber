# *****************************************************************************
#  Name             : kasb_dyn_kverteiler_001.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : dynamischen Kostenverteiler in Kassenbuch
#
#
# *****************************************************************************

@persistent
Feature: Kassenbuch und dyn. Kostenverteiler
Background: Verwaltung von dyn. Kostenverteiler

Given I set the fake date to "03.02.2002"

Scenario: Kassenbuch anlegen
Given I open an editor "kassenbuch1" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "nummer" to "1"
And I set field "kasskto" to "16000"
And I create a new row at the end of the table
And I set field "beldat" to "1.02.02" in row 1
And I set field "beinn" to "15" in row 1
And I set field "gkonto" to "44000" in row 1
And I set field "kstelle" to "" in row 1
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
	And I create a new row at the end of the table
	And I set field "kstelle" to "100" in row 1
	And I set field "proz" to "10" in row 1
	And I create a new row at the end of the table
	And I set field "kstelle" to "101" in row 2
	And I set field "proz" to "90" in row 2
	And I save the current subeditor to switch back to the parent editor
And I create a new row at the end of the table
And I set field "beldat" to "1.02.02" in row 2
And I set field "beinn" to "15" in row 2
And I set field "gkonto" to "44000" in row 2
And I set field "kstelle" to "" in row 2
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 2
	And I create a new row at the end of the table
	And I set field "kstelle" to "100" in row 1
	And I set field "proz" to "10" in row 1
	And I create a new row at the end of the table
	And I set field "kstelle" to "101" in row 2
	And I set field "proz" to "90" in row 2
	And I save the current subeditor to switch back to the parent editor
And I create a new row at the end of the table
And I set field "beldat" to "1.02.02" in row 3
And I set field "beinn" to "15" in row 3
And I set field "gkonto" to "44000" in row 3
And I set field "kstelle" to "1" in row 3
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: Kassenbuch erweitern
Given I open an editor "kassenbuch2" from table "(CashBook):(CashBook)" with command "UPDATE" for record "1"
And I create a new row at the end of the table
And I set field "beldat" to "2.02.02" in row 4
And I set field "beinn" to "15.71" in row 4
And I set field "gkonto" to "44000" in row 4
And I set field "kstelle" to "100" in row 4
And I create a new row at the end of the table
And I set field "beldat" to "2.02.02" in row 5
And I set field "beinn" to "76" in row 5
And I set field "gkonto" to "44000" in row 5
And I set field "kstelle" to "" in row 5
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 5
	And I create a new row at the end of the table
	And I set field "kstelle" to "100" in row 1
	And I set field "proz" to "50" in row 1
	And I create a new row at the end of the table
	And I set field "kstelle" to "101" in row 2
	And I set field "proz" to "50" in row 2
	And I save the current subeditor to switch back to the parent editor
And I create a new row at the end of the table
And I set field "beldat" to "2.02.02" in row 6
And I set field "beinn" to "76.11" in row 6
And I set field "gkonto" to "44000" in row 6
And I set field "kstelle" to "" in row 6
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 6
	And I create a new row at the end of the table
	And I set field "kstelle" to "100" in row 1
	And I set field "proz" to "50" in row 1
	And I create a new row at the end of the table
	And I set field "kstelle" to "101" in row 2
	And I set field "proz" to "50" in row 2
	And I save the current subeditor to switch back to the parent editor
	And I create a new row at the end of the table
And I set field "beldat" to "2.02.02" in row 7
And I set field "beinn" to "100" in row 7
And I set field "gkonto" to "44000" in row 7
And I set field "kstelle" to "" in row 7
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 7
	And I create a new row at the end of the table
	And I set field "kstelle" to "100" in row 1
	And I set field "proz" to "33.3" in row 1
	And I create a new row at the end of the table
	And I set field "kstelle" to "101" in row 2
	And I set field "proz" to "33.3" in row 2
	And I create a new row at the end of the table
	And I set field "kstelle" to "100000" in row 3
	And I set field "proz" to "33.4" in row 3
	And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor
#####################################################################################################################################

Scenario: Kassenbuch freigeben und verbuchen
Given I open an editor "kassenbuch3" from table "(CashBook):(CashBook)" with command "UPDATE" for record "1"
And I press button "allefr"

And I press button "bucheschl" to open a subeditor for "Kostenumlage" in row 0
And I save the current editor
And I switch the current editor to editor "kassenbuch3"

And I close the current editor

#####################################################################################################################################


