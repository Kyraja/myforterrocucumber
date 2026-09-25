 @persistant
Feature: Editing the Table of a Standard Chart of Account
Background:
Given I set the fake date to "2.2.2002"


Scenario: editing_Standard_chart_of_account_tab_sy
Given I open an editor "StCA4" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
Then field "verb" is not modifiable
Then field "ford" is not modifiable
Then field "verdku" is not modifiable
Then field "verdli" is not modifiable
Then field "verdma" is not modifiable
Then field "stsnull" is not modifiable
Then field "jdikenn" is not modifiable
Then field "jdiname" is modifiable
And I set field "jekkenn" to "EK"
Then field "jekkenn" is modifiable
And I create a new row at the end of the table
Then field "jkenn" is modifiable in row 1
And I set field "jkenn" to "E1" in row 1
# Leere Zeilen k�nnen gelöscht werden
And I create a new row at the end of the table
And I delete row at position 2
# Noch nicht gespeicherte Zeilen k�nnen gelöscht werden
And I create a new row at the end of the table
And I set field "jkenn" to "E2" in row 2
And I delete row at position 2
And I save the current editor
And I close the current editor

Given I open an editor "StCA5" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
Then field "jekkenn" is not modifiable
Then field "jkenn" is not modifiable in row 1
Then deleting the row at position 1 throws the exception "295"
And I close the current editor


Scenario: editing_Standard_chart_of_account_tab_w
Given I'm logged in with password "annette"

Given I open an editor "StCA6" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
Then field "verb" is modifiable
Then field "ford" is modifiable
Then field "verdku" is modifiable
Then field "verdli" is modifiable
Then field "verdma" is modifiable
Then field "stsnull" is modifiable
Then field "jdikenn" is modifiable
Then field "jekkenn" is modifiable
Then field "jkenn" is modifiable in row 1
Then deleting the row at position 1 throws the exception "295"
And I save the current editor
And I close the current editor


