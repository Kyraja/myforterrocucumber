# *****************************************************************************
#  Name             : GROUPSTRUCTURE.feature
#  Autor            : dgressel
#  Verantwortlich   : mh
#  Kontrolle        : cl
#  Funktion         : Test Infosystem GROUPSTRUCTURE auf gleiches Verhalten wie Kern-Maske
#
# *****************************************************************************

Feature: REWE-2058 Test Infosystem GROUPSTRUCTURE

Background:
Given I set the fake date to "07.01.2002"
Given I enable the flag 198

#####################################################################################################################
# Infosystem GROUPSTRUCTURE
#####################################################################################################################

Scenario: Open
Given I open the infosystem "GROUPSTRUCTURE"
Then field "bezzp" has value "07.01.02"
Then the table has 0 rows


Scenario: Single Hierarchy Level
Given I open the infosystem "GROUPSTRUCTURE"
And I set field "kkreis" to "10"
And I set field "bezzp" to "."
And I press button "bstart"
Then the table has 5 rows
# ROW 1 data
Then field "tkonzobj" has value "110" in row 1
Then field "tkonzobjname" has value "Mindelberger GmbH" in row 1
Then field "tkukonz" has value "870000" in row 1
Then field "tlikonz" is empty in row 1
Then field "tkdhist" has value "110a" in row 1
Then field "tkdhistname" has value "Konzerndatenhistorie Mindelberger" in row 1
Then field "twaehr" has value "EUR" in row 1
# Hierarchy
Then field "thierarchie" has value "0" in row 1
Then field "thierarchie" has value "0" in row 3
Then field "thierarchie" has value "0" in row 5
# Other values
Then field "tlikonz" has value "840004" in row 3

Scenario: Multiple Hierarchy Level
Given I open the infosystem "GROUPSTRUCTURE"
And I set field "kkreis" to "30"
And I set field "bezzp" to "."
And I press button "bstart"
Then the table has 9 rows
Then field "thierarchie" has value "0" in row 1
Then field "thierarchie" has value "2" in row 3
Then field "thierarchie" has value "2" in row 5
Then field "thierarchie" has value "1" in row 8
Then field "thierarchie" has value "0" in row 9


