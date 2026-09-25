@persistent
Feature: REWE-2439
Background:
Given I set the fake date to "10.01.2002"

# *********************************************************************************************
#  Name             : Test der 
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : wane
#  Funktion         : Test der Errechnung der kumulierten Werte im BAB-Formular für Monat 14
#
# *********************************************************************************************

Scenario: ILV umfasst auch Monat 14
Given I'm logged in with password "annette"
Given I open an editor "korekonf" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "ilvnach14" to "ja"
And I save the current editor

Given I'm logged in with password "sy"
Given I open an editor "babformular" from table "(EDS):(EDS)" with command "NEW" for record ""
And I set field "num63" to "500"
And I set field "such63" to "bab500"
And I set field "name" to "BAB Monat 14"
And I set field "gjahr" to "02-1"
And I set field "ganmon" to "1"
And I set field "gendmon" to "3"
And I set field "koobj" to "1121"
And I create a new row at the end of the table
And I set field "koart" to "640" in row 1
And I save the current editor

Given I open an editor "babformular" from table "(EDS):(EDS)" with command "VIEW" for record "bab500"
Then field "ikum" has value "3000.00" in row 1
And I close the current editor

Given I open an editor "babformular" from table "(EDS):(EDS)" with command "VIEW" for record "bab500"
And I set field "sgendmon" to "13"
Then field "ikum" has value "4000.00" in row 1
And I close the current editor

Given I open an editor "babformular" from table "(EDS):(EDS)" with command "VIEW" for record "bab500"
And I set field "sgendmon" to "14"
Then field "ikum" has value "5000.00" in row 1
And I close the current editor

Given I open an editor "babformular" from table "(EDS):(EDS)" with command "VIEW" for record "bab500"
And I set field "sganmon" to "13"
And I set field "sgendmon" to "13"
Then field "ikum" has value "1000.00" in row 1
And I close the current editor

Given I open an editor "babformular" from table "(EDS):(EDS)" with command "VIEW" for record "bab500"
And I set field "sganmon" to "14"
And I set field "sgendmon" to "14"
Then field "ikum" has value "1000.00" in row 1
And I close the current editor




