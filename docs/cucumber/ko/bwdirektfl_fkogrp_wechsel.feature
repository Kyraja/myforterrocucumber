# *****************************************************************************
#  Name           : bwdirektfl_fkogrp_wechsel.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test 
#                   
#
# *****************************************************************************
@persistent
Feature: BW2-547   
Background:
Given I set the fake date to "31.01.02"

Scenario: 01  Stammdaten
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "99800"
And I set field "nummer" to "66800"
And I set field "such" to "K66800"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "99800"
And I set field "nummer" to "66900"
And I set field "such" to "K66900"
And I save the current editor

Given I open an editor "fk" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "NEW" for record ""
And I set field "nummer" to "66"
And I set field "such" to "KFKONT"
And I append rows
    | fertigungskosten     | belast    | entlast   |
    | fertigungskosten un  | 66800     | 66900     |
And I save the current editor

Given I open an editor "kst" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "600"
And I set field "such" to "k600"
And I set field "fertkont" to "66"
And I save the current editor

Scenario: 02 Bewertung vom Typ 2 erfassen mit Kostenart Lohn und unterschiedlichen bwkstellemgr in der Tabelle, damit bei anderer Kst andere Kontierung ermittelt werden muss

Given I'm logged in with password "annette"

Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "NEW" for record ""
And I set field "such" to "fkogrp"
And I set field "ppsref" to "R +2012"
And I set field "mgr" to "11"
And I set field "artikel" to "10002"
And I set field "bewzeitp" to "04.01.02 17"
And I set field "bem" to "Fertigungskontengruppenwechsel"
#
And I create a new row at the end of the table
And I set field "kart" to "lohn" in row 1
And I set field "tbudat" to "4.01.02" in row 1
And I set field "tiwbu" to "eur" in row 1
And I set field "tmge" to "1" in row 1
And I set field "tbewpr" to "10" in row 1
And I set field "kstellemgr" to "101" in row 1
And I set field "kostobj" to "100000" in row 1
#
And I create a new row at the end of the table
And I set field "kart" to "lohn" in row 2
And I set field "tbudat" to "4.01.02" in row 2
And I set field "tiwbu" to "eur" in row 2
And I set field "tmge" to "2" in row 2
And I set field "tbewpr" to "20" in row 2
And I set field "kstellemgr" to "600" in row 2
And I set field "kostobj" to "100000" in row 2
And I save the current editor

Given I'm logged in with password "sy"

Scenario: 03 manuell erfasste Bewertung FKOGRP prüfen auf korrekte Kontierung

Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for record "fkogrp"
Then field "such" has value "FKOGRP"
Then field "lbgrund" has value ""
Then field "lbstatus" has value "verbuchbar"
Then field "kstellemgr" has value "101" in row 1
Then field "koreso" has value "88100" in row 1
Then field "koreha" has value "88101" in row 1 
#
Then field "kstellemgr" has value "600" in row 2
Then field "koreso" has value "66800" in row 2
Then field "koreha" has value "66900" in row 2
And I close the current editor

Scenario: 04 Standardfertigungskontengruppe entfernen und individuelle Fertigungskontengruppe aus Kst 600 entfernen, so dass keine Kontierungsermittlung möglich ist

Given I'm logged in with password "annette"
Given I enable the flag 71
#
Given I execute FOP "XDELFKOGRP"
#
Given I disable the flag 71

Given I open an editor "kst" from table "(Account):(CostCenter)" with command "UPDATE" for record "600"
And I set field "fertkont" to " "
And I save the current editor

Scenario: 05 weitere Bewertung vom Typ 2 erfassen mit Kostenart Lohn und unterschiedlichen bwkstellemgr in der Tabelle, damit bei anderer Kst andere Kontierung ermittelt werden muss

Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "NEW" for record ""
And I set field "such" to "fkogrp2"
And I set field "ppsref" to "R +2012"
And I set field "mgr" to "11"
And I set field "artikel" to "10002"
And I set field "bewzeitp" to "05.01.02 17"
And I set field "bem" to "Fertigungskontengruppenwechsel"
#
And I create a new row at the end of the table
And I set field "kart" to "lohn" in row 1
And I set field "tbudat" to "5.01.02" in row 1
And I set field "tiwbu" to "eur" in row 1
And I set field "tmge" to "1" in row 1
And I set field "tbewpr" to "10" in row 1
And I set field "kstellemgr" to "101" in row 1
And I set field "kostobj" to "100000" in row 1
#
And I create a new row at the end of the table
And I set field "kart" to "lohn" in row 2
And I set field "tbudat" to "5.01.02" in row 2
And I set field "tiwbu" to "eur" in row 2
And I set field "tmge" to "2" in row 2
And I set field "tbewpr" to "20" in row 2
And I set field "kstellemgr" to "600" in row 2
And I set field "kostobj" to "100000" in row 2
And I save the current editor

Scenario: 06 manuell erfasste Bewertung FKOGRP prüfen auf korrekte Statusmeldung (fehlende Konten)

Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for record "fkogrp2"
Then field "lbgrund" has value "Buchungskonto fehlt."
Then field "lbstatus" has value "nicht verbuchbar"
Then field "kstellemgr" has value "101" in row 1
Then field "koreso" has value "" in row 1
Then field "koreha" has value "" in row 1 
#
Then field "kstellemgr" has value "600" in row 2
Then field "koreso" has value "" in row 2
Then field "koreha" has value "" in row 2
And I close the current editor
