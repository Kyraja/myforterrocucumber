# *****************************************************************************
#  Name           : kvert_rest.feature
#  Autor          : Silvia Warth
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Editieren eines Kostenverteilers derart, dass Restbetraege entstehen.
#                   Je nach dem, ob in der ersten Zeile des KV eine Kst oder ein Ktr enthalten ist, erfolgt die Buchung des Rests
#                   auf die Rest-Kst bzw. den Rest-Ktr.
#
# *****************************************************************************
@persistent
Feature: REWE-2473
Background:
Given I set the fake date to "30.11.00"

Scenario: Buchung XDYN erzeugen mit Kst in erster Zeile des KV und Buchung XDYN2 erzeugen mit Ktr in erster Zeile des KV
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "."
And I set field "beldat" to "."
And I set field "beleg" to "xdyn"
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 1
And I set field "ewsbetr" to "123,96" in row 1
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "204" in row 1
And I set field "proz" to "2,3" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "200002" in row 2
And I set field "proz" to "97,7" in row 2
And I save the current subeditor to switch back to the parent editor
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "UPDATE" for record "BXDYN"
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
And I set field "betr" to "2,87" in row 1
And I save the current subeditor to switch back to the parent editor
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Given I open an editor "Buchung2" from table "(Entry):(Entry)" with command "COPY" for record "BXDYN"
And I set field "budat" to "."
And I set field "beldat" to "."
And I set field "beleg" to "xdyn2"
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
And I set field "kstelle" to "200004" in row 1
And I set field "betr" to "2,88" in row 1
And I save the current subeditor to switch back to the parent editor
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
