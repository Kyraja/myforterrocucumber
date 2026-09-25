# *****************************************************************************
#  Name           : aktivier_fkkonfig.feature             
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test der Aktivierung der FKV im Zustand, dass es FV und ungebuchte RM ohne Kostenobjekte gibt.                                               
#                   RM dürfen nur mit vollständiger Kontierung gespeichert und gebucht werden.
#
# *****************************************************************************
@persistent
Feature: ref_aktivier_fkkonfig_cu 
Background: 
Given I set the fake date to "2.01.02"
Given I enable the flag 39

Scenario: Entfernen Kostenobjekt aus Kapazitaeten
Given I open an editor "kapaz1" from table "(Capacity):(Department)" with command "UPDATE" for record "10"
And I set field "kstelle" to ""
And I save the current editor

Given I open an editor "kapaz2" from table "(Capacity):(WorkCenter)" with command "UPDATE" for record "101"
And I set field "kstelle" to ""
And I save the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "COPY" for record "301"
And I set field "nummer" to "333"
And I set field "such" to "bg333"
And I save the current editor

Scenario: FV erzeugen ohne Kostenobjekte, einen FV freigeben, RM erzeugen
# Fertigungsvorschlag1 anlegen und freigeben
Given I open an editor "fvor1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge    | bisuch    | mfreig     | binoloe   | kstelle | verw |
    | 301       | 10        | ART1BG_    | ja        | ja        |         | sih1 |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor1"
And I save the current editor
#
# Fertigungsvorschlag2 anlegen und freigeben
Given I open an editor "fvor2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge    | bisuch    | mfreig    | binoloe   | kstelle |  verw  |
    | 333       |  8        | ART2BG_    | ja       | ja        |         |  sih2  |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor2"
And I save the current editor

Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ART1BG_001"
And I set fields
    | ma        | 7801  |
    | lgr       | 4     |
    | bzeit     | 1,5   |
    | mzeit     | 1,5   |
    | gut       | 1     |
And I save the current editor

Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ART1BG_002"
And I set fields
    | ma        | 7802  |
    | lgr       | 3     |
    | bzeit     | 1     |
    | mzeit     | 1     |
And I save the current editor

Scenario: FKV aktivieren
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "fkkonfig" to "ja"
Then saving the current editor throws the exception "2691"
And I close the current editor

Given I open an editor "fk" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "NEW" for record ""
And I set field "nummer" to "400"
And I set field "such" to "FKOGRP"
And I append rows
    | fertigungskosten     | belast    | entlast   |
    | Lohn                 | 99800     | 99900     |
    | Maschinenkosten fix  | 99800     | 99900     |
    | Maschinenkosten var  | 99800     | 99900     |
    | SK fix               | 99800     | 99900     |
    | SK var               | 99800     | 99900     |
And I save the current editor

Given I open an editor "korekonf" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "fertkont" to "FKOGRP"
And I save the current editor

Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "fkkonfig" to "ja"
And I respond with answer "Ja" to the dialog with id "3358"
And I respond with answer "Ja" to the dialog with id "3359"
And I save the current editor

Scenario: FV freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "333"
And I press button "ladetab"
And pressing button "freig" in row 0 to open a subeditor throws the exception "279"
And I set field "kstelle" to "100000" in row !lastRow
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# RM zu fv1 editieren zum buchen. FV hat kein Kostenobjekt. MGR und MA ebenfalls nicht.
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "ART1BG_001"
And I set field "sofort" to "ja"
Then saving the current editor throws the exception "279"
And I set field "kstelle" to "100000"
Then saving the current editor throws the exception "279"
And I set field "mgkstl" to "101"
Then saving the current editor throws the exception "7147"
And I set field "makstl" to "100"
And I save the current editor
And I close the current editor

# RM zu fv2 erfassen und buchen
Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ART2BG_001"
And I set fields
    | ma        | 7802  |
    | lgr       | 3     |
    | bzeit     | 1     |
    | mzeit     | 1     |
Then saving the current editor throws the exception "279"
And I set field "kstelle" to "100000"
Then saving the current editor throws the exception "279"
And I set field "mgkstl" to "101"
Then saving the current editor throws the exception "7147"
And I set field "makstl" to "100"
And I save the current editor
 
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "ART2BG_001"
And I set field "sofort" to "ja"
And I save the current editor 



