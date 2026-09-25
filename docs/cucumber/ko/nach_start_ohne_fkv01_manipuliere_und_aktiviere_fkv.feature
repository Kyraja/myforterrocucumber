@persistent
Feature: BW2-1586
Background:
Given I set the fake date to "02.01.2002"
Given I enable the flag 39

# *****************************************************************************
#  Name             : nach_start_ohne_fkv01_manipuliere_und_aktiviere_fkv.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Daten manipulieren (FOP XAENDRM), Fertigungskontengruppe anlegen und in Kostenrechnungskonfiguration eintragen, FKV aktivieren
#
# *****************************************************************************
Scenario: Rückmeldungen manipulieren
Given I'm logged in with password "annette"
Given I enable the flag 71
#
Given I execute FOP "XAENDRM"
#
Given I disable the flag 71
Given I'm logged in with password "sy"

Scenario: manipulierte RM ausgeben
Given I open an editor "RMView1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BG198_001;bem=RM198001_1;typa279=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts"
Then field "lohnkostsoll" has value ""
Then field "lohnkostsoll4" has value "88801"
Then field "lohnkosthaben4" has value "88802"
And I close the current editor

Given I open an editor "RMView2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BG199_001;bem=RM199003_1;typa279=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts"
Then field "mkostfixsoll" has value ""
Then field "lohnkostsoll4" has value "88801"
Then field "lohnkosthaben4" has value "88802"
And I close the current editor

Scenario: Aktivieren FKV

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
