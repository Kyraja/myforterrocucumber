# *****************************************************************************
#  Name           : invoke_head_button.feature
#  Verantwortlich : @forterro-prd/t024-abas-core
#  Funktion       : Testet Kopfbuttons
# *****************************************************************************
@persistent
@INVOKE_HEAD_BUTTON_TEST
Feature: CRUD 65:1

Scenario: Sucherweiterung verwalten

Given I'm logged in with password "sy"
# Mehrsprachiges System
Given I enable the flag 46

Given I open an editor "Infosystem neu" from table "(Infosystem):(Infosystem)" with command "NEW" for record ""
Then field "nameuebloesch" is modifiable
Then field "nameueb" is modifiable
Then field "nameueballe" is modifiable
And I set field "sucherw" to "Kunde"
Then field "name1" has value "Kunde"
Then field "name2" has value ""
And I press button "nameueballe"
Then field "name1" has value "Kunde"
Then field "name2" has value "Customer"
And I press button "nameuebloesch"
Then field "sucherw" has value ""
Then field "name1" has value ""
Then field "name2" has value ""
And I close the current editor

Scenario: Sucherweiterung im LU privilegiert verwalten

Given I'm logged in with password "sy"
# Mehrsprachiges System
Given I enable the flag 46
Given I enable the flag 298

Given I open an editor "Infosystem ändern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "KDINFO"
Then field "nameuebloesch" is modifiable
Then field "nameueb" is modifiable
Then field "nameueballe" is modifiable
And I press button "nameuebloesch"
Then field "sucherw" has value ""
Then field "name1" has value ""
Then field "name2" has value ""
And I set field "sucherw" to "Kunde"
And I press button "nameueb"
Then field "name1" has value "Kunde"
Then field "name2" has value "Customer"
And I set field "sucherw" to "Kundeninfozentrale"
And I press button "nameueballe"
Then field "sucherw" has value "Kundeninfozentrale"
Then field "name1" has value "Kundeninfozentrale"
Then field "name2" has value "Customer information centre"
And I close the current editor

Scenario: Sucherweiterung im LU nicht privilegiert verwalten

Given I'm logged in with password "sy"
# Mehrsprachiges System
Given I enable the flag 46

Given I open an editor "Infosystem ändern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "KDINFO"
Then field "nameuebloesch" is not modifiable
Then field "nameueb" is not modifiable
Then field "nameueballe" is not modifiable
And I close the current editor
