# *****************************************************************************
#    Name      : kasb_kasb_0004_kassbuch1_cu.feature                           
#    Autor     : Jan Effler                                                    
#    Verantwortlich : wane                                                     
#    Kontrolle:                                                                
#                                                                              
#     Funktion  : ersetzt den in ref_kasb generierte Lader KASSBUCH1           
#                                                                              
# *****************************************************************************

@persistent
Feature: kassbuch1
Background: ref_kasb

# 008-01 ======== Test Buchungsvorschau abblocken

Given I'm logged in with password "annette"
Given I set the fake date to "08.01.02"

Scenario: Kassenbuecher anlegen

Given I'm logged in with password "annette"
Given I open an editor "kasb1" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "kasskto" to "16004"
And I set field "gj" to "02"
And I set field "gmon" to "2"
And I create a new row at the end of the table
And I set field "beldat" to "1.2.02" in row 1
And I set field "bausg" to "5" in row 1
And I set field "gkonto" to "54000" in row 1
And I set field "isbestkorr" to "ja" in row 1
# 5899 : Keine Buchungsgenerierung da nur Bestandskorrekturzeile.
Then pressing button "buvorsch" in row 1 to open a subeditor throws the exception "5899"
# And I save the current editor
And I close the current editor

Given I open an editor "kasb2" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "kasskto" to "16005"
And I set field "gj" to "02"
And I set field "gmon" to "2"
And I save the current editor
And I close the current editor

Scenario: Kassenbuch loeschen

Given I open an editor "kasb-del" from table "(CashBook):(CashBook)" with command "DELETE" for record "K16005/02/02/01"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Scenario: Kassenbuch anlegen

Given I open an editor "kasb2-2" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "kasskto" to "16005"
And I set field "gj" to "02"
And I set field "gmon" to "2"
And I save the current editor
And I close the current editor

# 008-02 ======== Fehler 5774 - nicht eindeutig erzwingen ...

Scenario: Kassenbuch nim aendern

Given I enable the flag 71
Given I execute FOP "KASB.KASSBUCH1.FOP"
Given I disable the flag 71

Scenario: Kassenbuch aendern

Given I open an editor "kasb-edit" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16005/02/02/02"
# 5774 : Kassenkonto und Zeitraum nicht eindeutig (Prüfung erfolgt inkl. Ablage)
Then saving the current editor throws the exception "5774"
And I close the current editor




