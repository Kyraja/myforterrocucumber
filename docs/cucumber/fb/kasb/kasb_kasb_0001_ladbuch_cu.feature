# *****************************************************************************
#    Name      : kasb_kasb_0001_ladbuch_cu.feature                             
#    Autor     : Jan Effler                                                    
#    Verantwortlich : wane                                                     
#    Kontrolle:                                                                
#                                                                              
#     Funktion  : ersetzt den in ref_kasb generierte Lader LADBUCH             
#                                                                              
#                User me versucht im Aendernmodus (Fehler 4669)                
#                und am Stern zu buchen (Fehler 40)                            
#                                                                              
# *****************************************************************************

@persistent
Feature: ladbuch
Background: ref_kasb

Given I set the fake date to "07.01.02"

# == FehlerNrn   4669 keine Erlaubnis / 40 Kommando nicht erlaubt (kein Buchen fuer User me erlaubt!)
Scenario: Kassenbuch buchen - User me

# 4669 : Keine Erlaubnis

Given I'm logged in with password "me"
Given I open an editor "kasb-b-me" from table "(CashBook):(CashBook)" with command "UPDATE" for record "2"
Then pressing button "bucheschl" in row 0 to open a subeditor throws the exception "4669"
Then saving the current editor throws the exception "2743"
And I close the current editor

# sy darf buchen - dieser Teil muss erfolgreich laufen

Scenario: Kassenbuch buchen - User sy

Given I'm logged in with password "sy"
Given I open an editor "kasb-b-sy" from table "(CashBook):(CashBook)" with command "UPDATE" for record "2"
And I press button "bucheschl" to open a subeditor for "kasb-sy-buchschl" in row 0
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# me versucht am Stern mit Kommando uebertragen zu buchen - hat aber keine Erlaubnis!

Scenario: Kassenbuch uebertragen - User me

# 40 : Kommando nicht erlaubt

Given I'm logged in with password "me"
Then opening an editor from table "(CashBook):(CashBook)" with command "TRANSFER" for record "2" throws the exception "40"


