@persistent
Feature: BW2-1586
Background:
Given I set the fake date to "02.01.2002"

# *****************************************************************************
#  Name             : nach_start_ohne_fkv02_geschaeftsprozesse_fortsetzen.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Bei aktiver FKV in Vorgängertest angefangene Geschäftsprozesse fortführen (Storno).
#
# *****************************************************************************
Scenario:   Storno-Rückmeldung
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BG1a_001;bem=RM_BG1a;typa279=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts"
And I save the current editor
# Then field "stornopartnervorg^id" has value equal to field "id" from editor "RB1_FallSR1" in row 0
Then field "typa279" has value "Storno-Rückmeldung"

Scenario:   Storno-Rückmeldung auf abgelegten Fertigungsvorschlag
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BG102_001;bem=VollRMBG1_001;typa279=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts"
And I save the current editor
# Then field "stornopartnervorg^id" has value equal to field "id" from editor "RB1_FallSR1" in row 0
Then field "typa279" has value "Storno-Rückmeldung auf abgelegten Fertigungsvorschlag"

Scenario:   Storno-Rückbau auf abgelegten Fertigungsvorschlag
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BG6_000;typa279=Rückbau auf abgelegten Fertigungsvorschlag;@ablageart=abgelegt;@richtung=rückwärts"
And I set field "bem" to "Rückbau Rbau1"
And I save the current editor
# Then field "stornopartnervorg^id" has value equal to field "id" from editor "RB1_FallSR1" in row 0
Then field "typa279" has value "Storno-Rückbau auf abgelegten Fertigungsvorschlag"

Scenario:   Storno-Rückbau auf Betriebsauftrag
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BG101_001;typa279=Rückbau auf Betriebsauftrag;@ablageart=abgelegt;@richtung=rückwärts"
And I save the current editor
# Then field "stornopartnervorg^id" has value equal to field "id" from editor "RB1_FallSR1" in row 0
Then field "typa279" has value "Storno-Rückbau auf Betriebsauftrag"

Scenario:   Storno-Zeitbuchung
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BG101_000;typa279=Zeitbuchung;@ablageart=abgelegt;@richtung=rückwärts"
And I save the current editor
# Then field "stornopartnervorg^id" has value equal to field "id" from editor "RB1_FallSR1" in row 0
# Die folgende typa279-Abfrage führt komischerweise zum Fehler (auch in fertigung_storno.feature), andere typa279-Abfragen nicht!?
# Then field "typa279" has value "Storno-Zeitbuchung"

Scenario:   Storno-Zeitkorrktur
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BG103_001;typa279=Zeitkorrektur;@ablageart=abgelegt;@richtung=rückwärts"
And I save the current editor
# Then field "stornopartnervorg^id" has value equal to field "id" from editor "RB1_FallSR1" in row 0
# Then field "typa279" has value "Storno-Zeitkorrektur"

Scenario:   Storno-Zeitbuchung auf abgelegten Fertigungsvorschlag
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BG6_001;typa279=Zeitbuchung auf abgelegten Fertigungsvorschlag;@ablageart=abgelegt;@richtung=rückwärts"
And I save the current editor
# Then field "typa279" has value "Storno-Zeitbuchung auf abgelegten Fertigungsvorschlag"

Scenario:   Storno-Zeitkorrektur auf abgelegten Fertigungsvorschlag
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BG6_000;typa279=Zeitkorrektur auf abgelegten Fertigungsvorschlag;@ablageart=abgelegt;@richtung=rückwärts"
And I save the current editor
# Then field "typa279" has value "Storno-Zeitkorrektur auf abgelegten Fertigungsvorschlag"

Scenario:   Storno-Rückmeldung ohne Fertigungsvorschlag
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=RM1010;typa279=Rückmeldung ohne Fertigungsvorschlag;@ablageart=abgelegt;@richtung=rückwärts"
And I save the current editor
Then field "typa279" has value "Storno-Rückmeldung ohne Fertigungsvorschlag"

Scenario: Storno der manipulerten RM 
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BG198_001;artikel==BG1;bem==RM198001_1;@ablage=abgelegt;@richtung=rückwärts"
And I save the current editor
Then field "typa279" has value "Storno-Rückmeldung"

Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BG199_001;artikel==BG1;bem==RM199003_1;@ablage=abgelegt;@richtung=rückwärts"
And I save the current editor
Then field "typa279" has value "Storno-Rückmeldung"

Scenario: Zeitkorrektur gesamte Menge
Given I open an editor "Zeitkorrektur4" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "BG120_001"
And I set field "sofort" to "ja"
And I set field "lgr" to "4"
And I set field "bzeit" to "-2"
And I set field "mzeit" to "-3"
# im Betriebsauftrag 1007 und auch in der Rückmeldung 1007001/BG120_001, ist kstelle leer (da FKV inaktiv war)
# kstelle würde für ref_start_ohne_fkv_weiter_ohne_fkv_cuNachf nicht gesetzt werden müssen, da dort doe FKV weiter inaktiv ist,
# aber in ref_start_ohne_fkv_ohne_fkogrp_cuNachf und ref_start_ohne_fkv_mit_std_fkogrp_cuNachf ist FKV aktiv und daher muss kstelle gesetzt werden.
And I set field "kstelle" to "100000"
And I save the current editor


Scenario: Zeitkorrektur Teilmenge
Given I open an editor "Zeitkorrektur4" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "BG130_001"
And I set field "sofort" to "ja"
And I set field "lgr" to "4"
And I set field "bzeit" to "-2"
And I set field "mzeit" to "-4"
# im Betriebsauftrag 1008 und auch in der Rückmeldung 1008001/BG130_001, ist kstelle leer (da FKV inaktiv war)
# kstelle würde für ref_start_ohne_fkv_weiter_ohne_fkv_cuNachf nicht gesetzt werden müssen, da dort doe FKV weiter inaktiv ist,
# aber in ref_start_ohne_fkv_ohne_fkogrp_cuNachf und ref_start_ohne_fkv_mit_std_fkogrp_cuNachf ist FKV aktiv und daher muss kstelle gesetzt werden.
And I set field "kstelle" to "100000"
And I save the current editor

Scenario: Storno Rückmeldung aus Serviceabwicklung
# Es gibt kein Storno für den Typ "Rückmeldung aus Serviceabwicklung".


