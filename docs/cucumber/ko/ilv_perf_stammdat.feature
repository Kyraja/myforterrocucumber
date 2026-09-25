@persistent
Feature: REWE-2354 95                   
Background:
Given I set the fake date to "31.01.2002"

# *****************************************************************************
#  Name             : ILV: Performancetest
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : wane
#  Funktion         : Test der Performance der ILV
#
# *****************************************************************************

Scenario: Stammdaten
Given I open an editor "bg500" from table "(ActivityBase):(ActivityBase)" with command "NEW" for record ""
And I set field "num61" to "500"
And I set field "such61" to "bg500"
And I set field "einheitbz" to "STUECK"
And I save the current editor

Given I open an editor "bg500" from table "(ActivityBase):(ActivityBase)" with command "UPDATE" for record "bg500"
And I set field "gjahr" to "02"
And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "4020"
And I set field "s2" to "4020"
And I set field "s3" to "1000"
And I set field "s4" to "1000"
And I set field "s5" to "1000"
And I set field "s6" to "1000"
And I set field "s7" to "1000"
And I set field "s8" to "1000"
And I set field "s9" to "1000"
And I set field "s10" to "1000"
And I set field "s11" to "1000"
And I set field "s12" to "1000"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "bg500"
And I close the current editor

Given I open an editor "bg800" from table "(ActivityBase):(ActivityBase)" with command "NEW" for record ""
And I set field "num61" to "800"
And I set field "such61" to "bg800"
And I set field "einheitbz" to "STUECK"
And I save the current editor

Given I open an editor "bg800" from table "(ActivityBase):(ActivityBase)" with command "UPDATE" for record "bg800"
And I set field "gjahr" to "02"
And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "2020"
And I set field "s2" to "2020"
And I set field "s3" to "1000"
And I set field "s4" to "1000"
And I set field "s5" to "1000"
And I set field "s6" to "1000"
And I set field "s7" to "1000"
And I set field "s8" to "1000"
And I set field "s9" to "1000"
And I set field "s10" to "1000"
And I set field "s11" to "1000"
And I set field "s12" to "1000"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "bg800"
And I close the current editor




