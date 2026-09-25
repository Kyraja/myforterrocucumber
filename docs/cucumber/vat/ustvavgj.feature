# *****************************************************************************
#  Name           : ustvavgj.feature
#  Autor          : tf
#  Verantwortlich : wane
#  Funktion       : Testet die UStVA mit Monatsversatz
# *****************************************************************************
@persistent
@USTVAVGJ_TEST
Feature: CRUD 54:4

Background:
Given I'm logged in with password "annette"
Given I set the fake date to "01.07.2000"

Scenario: Change annual closing date in financial dates

Given I open an editor "Termine" from table "(Company):(FinancialDates)" with command "UPDATE" for record "TERM"
And I press button "bsperremand"
And I set field "jaab" to "30.09.99"
And I save the current editor
And I close the current editor

Scenario: Post manual entries

Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "12-K"
And I set field "budat" to "01.05.00"
And I create a new row at the end of the table
And I set field "konto" to "L 500" in row 1
And I set field "ewsbetr" to "10000" in row 1
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "konto" to "K 200" in row 1
And I set field "ewsbetr" to "10000" in row 1
And I create a new row at the end of the table
And I set field "konto" to "44000" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "konto" to "K 201" in row 1
And I set field "ewsbetr" to "3000" in row 1
And I create a new row at the end of the table
And I set field "konto" to "54250" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "konto" to "L 501" in row 1
And I set field "ewhbetr" to "16000" in row 1
And I create a new row at the end of the table
And I set field "konto" to "43150" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: Change annual closing date in financial dates

Given I open an editor "Termine" from table "(Company):(FinancialDates)" with command "UPDATE" for record "TERM"
And I press button "bsperremand"
And I create a new row at the end of the table
And I set field "gjanf" to "01.02.01" in row 9
And I set field "gjend" to "31.01.02" in row 9
And I set field "jaab" to "31.05.00"
And I save the current editor
And I close the current editor

Scenario: Copy financial entries

Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "COPY" for record "123"
And I set field "budat" to "01.05.2000"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "COPY" for record "124"
And I set field "budat" to "01.05.2000"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "COPY" for record "125"
And I set field "budat" to "01.05.2000"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

