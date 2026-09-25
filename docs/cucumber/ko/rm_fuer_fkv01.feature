@persistent
Feature: ref_storno_rueck_prozesse_mit_bew_upg_rm_fuer_fkv
Background:
# Vorgaenger hat 2.07.02
Given I set the fake date to "02.08.2002"

# *****************************************************************************
#  Name             : rm_fuer_fkv01.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Im Test und Vorgänger gibt es nur Rückmeldungen vom Typ (typa279) Rückmeldung.
#                     Fortführen von Geschäftsprozessen, die vor dem Upgrade begonnen haben.
#                     weitere Rückmeldungen
#                     Storno von RM von vor dem Upgrade mit anderen Konten der Kostenobjekte (nach dem Upgrade Fertigungskontengruppe mit anderen Konten als vor dem Upgrade)
#                     Rückbau von RM von vor dem Upgrade mit anderen Konten der Kostenobjekte (nach dem Upgrade Fertigungskontengruppe mit anderen Konten als vor dem Upgrade
#
# *****************************************************************************

Scenario: 01 Kst 101 erhält andere Fertigungskontengruppe: 154 -> 500
Given I open an editor "kst" from table "(Account):(CostCenter)" with command "UPDATE" for record "101"
And I set field "fertkont" to "500"
And I save the current editor

Scenario: 02 Rückmeldung
Given I open an editor "RM1039" from table "(Workorder):(WorkOrders)" with command "DONE" for record "1039001"
And I set field "bem" to "RM1039_1_n_upg"
And I set field "ma" to "1"
And I set field "lgr" to "2"
And I set field "bzeit" to "1"
And I set field "mzeit" to "1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "2" in row 1
Then field "lohnkostsoll" has value "97100"
Then field "lohnkosthaben" has value "97101"
Then field "mkostfixsoll" has value "97200"
Then field "mkostfixhaben" has value "97201"
Then field "mkostvarsoll" has value "97300"
Then field "mkostvarhaben" has value "97301"
Then field "skostfixsoll" has value "97400"
Then field "skostfixhaben" has value "97401"
Then field "skostvarsoll" has value "97500"
Then field "skostvarhaben" has value "97501"
And I save the current editor

Scenario: 03 Storno RM von vor dem Upgrade
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BG3SIH1_001;verw=bg3_1;@richtung=rückwärts;@maxordtreffer=1"
And I set field "bem" to "Storno1_v_upg"
And I save the current editor

Scenario: 04 Storno RM von nach dem Upgrade
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=TEILRUECKBVORUPG001;bem=RM1039_1_n_upg;bzeit=1;mzeit=1;@richtung=rückwärts;@maxordtreffer=1"
And I set field "bem" to "Storno1_n_upg"
And I save the current editor


