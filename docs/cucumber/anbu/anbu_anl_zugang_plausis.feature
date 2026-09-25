# *****************************************************************************
#  Name             : anbu_anl_zugang_plausis.feature
#  Autor            : Jan Effler
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         :  Ergaenzt ref_anl_zugang_plausis.edp
#                       Erzeugt Zugaenge auf Anlagen mit aktivierter
#                       und deaktivierter Anbu. 
#                       Verwendet Elemente aus ref_anl_zugang_plausis.edp
#                       
#
# *****************************************************************************

@persistent
Feature: ref_anbu_buchungen_plausis
Background: Anlagenbuchhaltung

Given I set the fake date to "07.01.95"
Given I enable the flag 39

Scenario: anbu deaktiviert 

# setup

Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
Then field "anl" has value "nein"
And I save the current editor
And I close the current editor

# Buchung - anbu deaktiviert

Given I'm logged in with password "sy"

Given I open an editor "buch-new" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "BZU11" in row 0
And I set field "kenn" to "ZU" in row 0
And I set field "beleg" to "ZU11" in row 0
And I set field "beldat" to "07.01.95" in row 0
And I set field "budat" to "07.01.95" in row 0
And I create a new row at the end of the table
Then setting field "anlage" to "72" in row 1 throws the exception "4166"
And I set field "konto" to "05200" in row 1
And I set field "sbetrag" to "380" in row 1
And I create a new row at the end of the table
And I set field "konto" to "35010" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
Then message "Zugang auf Anlage verbucht" was not displayed
And I close the current editor

# Buchung mit Anlage kopieren - anbu deaktiviert

Given I'm logged in with password "sy"

Given I open an editor "buch-cp2" from table "(Entry):(Entry)" with command "COPY" for record "BZU00"
And I set field "such" to "BZU00cu1"
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor 
Then message "Zugang auf Anlage verbucht" was not displayed
And I close the current editor

Scenario: Anbu aktiviert

# setup

Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "anl" to "ja"
And I save the current editor
And I close the current editor

# Buchung mit Anlage - anbu aktiv

Given I'm logged in with password "sy"

Given I open an editor "buch-new2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "BZU12" in row 0
And I set field "kenn" to "ZU" in row 0
And I set field "beleg" to "ZU12" in row 0
And I set field "beldat" to "07.01.95" in row 0
And I set field "budat" to "07.01.95" in row 0
And I create a new row at the end of the table
And I set field "anlage" to "72" in row 1
And I set field "sbetrag" to "380" in row 1
And I create a new row at the end of the table
And I set field "konto" to "35010" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
Then message "Zugang auf Anlage verbucht" was displayed
And I close the current editor

# Buchung mit Anlage kopieren - anbu aktiviert

Given I'm logged in with password "sy"

Given I open an editor "buch-cp" from table "(Entry):(Entry)" with command "COPY" for record "BZU00"
And I set field "such" to "BZU00cu2"
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor 
Then message "Zugang auf Anlage verbucht" was displayed
And I close the current editor
