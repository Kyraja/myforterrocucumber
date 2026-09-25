# **********************************************************************************
#  Name             : Rueckmeldung_ohne_FV.feature
#  Autor            : carue
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Funktion         : Chargen-/Seriennummernpruefungen bei Rueckmeldung neu
#                   : WICHTIG: Bei "Rückmeldung neu" wird NIE ein Zugang gebucht,
#                   :          auch wenn man in das Feld (bi)gutmge etwas eintragen kann.
#  ref              : ref_chargen_seriennr_cu
#
# **********************************************************************************

@persistent
Feature: Rueckmeldung_ohne_FV.feature

Background:
And I set the fake date to "16.01.1995"

Scenario: 01 Chargenpflicht bei Fertigteil und Material pruefen

Given I open an editor "RMneu1" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
Then field "typa279" has value "Rückmeldung ohne Fertigungsvorschlag"
And I set fields
    | barmex  | 1-RMohneFV  |
    | such    | RMohneFV-1  |
    | artikel | BG02_CHARGE |
    | mgr     | 101         |
    | kstelle | 100000      |
    | lgr     | 2           |
    | mzeit   | 1           |
    | bzeit   | 2           |
And I append rows
    | artikel     | mge | gutmge |
    | EK02_CHARGE | 2   | 3      |
# 1164 Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "tkcharge" to "101010"
Then saving the current editor throws the exception "1164"
And I set field "tcharge" to "202020" in row 1
And I save the current editor


Scenario: 02 Seriennummernpruefung - Menge muss 1 sein

Given I open an editor "RMneu2" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
And I set fields
    | barmex   | 2-RMohneFV  |
    | such     | RMohneFV-2  |
    | artikel  | BG03_SN     |
    | tkcharge | 303030SN    |
    | mgr      | 101         |
    | kstelle  | 100000      |
    | lgr      | 2           |
    | mzeit    | 1           |
    | bzeit    | 2           |
And I append rows
    | artikel     | mge | gutmge |
    | EK04_SN     | 2   | 3      |
Then field "tcharge" is not modifiable in row 1
And I set field "mge" to "1" in row 1
And I set field "gutmge" to "1" in row 1
And I set field "tcharge" to "404040SN" in row 1
And I save the current editor


Scenario: 03 Seriennummer erneut verwenden
# Es werden die beiden Seriennummern aus Scenario 02 wiederverwendet,
# die nur zu- aber nicht abgegangen sind

Given I open an editor "RMneu3" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
And I set fields
    | barmex   | 3-RMohneFV  |
    | such     | RMohneFV-3  |
    | artikel  | BG03_SN     |
    | tkcharge | 303030SN    |
    | mgr      | 101         |
    | kstelle  | 100000      |
    | lgr      | 2           |
    | mzeit    | 1           |
    | bzeit    | 2           |
And I append rows
    | artikel     | mge | gutmge | tcharge  |
    | EK04_SN     | 1   | 1      | 404040SN |
Then field "ksnerneutverwend" is not modifiable
Then field "snerneutverwend" is not modifiable in row 1
And I close the current editor

# Seriennummern zubuchen
Given I open an editor "Lagerbuchung_EK04_SN" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK04_SN       |
    | buart     | Zugang        |
    | beleg     | EK04_SN_ZU    |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  |
    | 1      | F1       | 404040SN  |
And I save the current editor

Given I open an editor "RMneu4" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
And I set fields
    | barmex           | 4-RMohneFV  |
    | such             | RMohneFV-4  |
    | artikel          | BG04_SN     |
    | tkcharge         | 303030SN    |
    | mgr              | 101         |
    | kstelle          | 100000      |
    | lgr              | 2           |
    | mzeit            | 1           |
    | bzeit            | 2           |
And I append rows
    | artikel     | mge | gutmge | tcharge  | snerneutverwend |
    | EK04_SN     | 1   | 1      | 404040SN | ja              |
And I save the current editor
