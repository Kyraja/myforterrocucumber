@persistent
Feature: BW2-1586
Background:
Given I set the fake date to "02.01.2002"

# *****************************************************************************
#  Name             : nach_start_ohne_fkv03_ausgabe_manipulierte_rm.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Ausgabe spezieller, im Test manipulierter Rückmeldungen
#
# *****************************************************************************
Scenario: manipulierte RM ausgeben (Ursprungsbeleg und Stornobeleg)
Given I open an editor "RMView1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BG198_001;bem=RM198001_1;typa279=Stornierte Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts"
Then field "lohnkostsoll" has value ""
Then field "lohnkostsoll4" has value "88801"
Then field "lohnkosthaben4" has value "88802"
And I close the current editor

Given I open an editor "RMView1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BG198_001;bem=RM198001_1;typa279=Storno-Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts"
Then field "lohnkostsoll" has value ""
Then field "lohnkostsoll4" has value "88801"
Then field "lohnkosthaben4" has value "88802"
And I close the current editor


Given I open an editor "RMView2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BG199_001;bem=RM199003_1;typa279=Stornierte Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts"
Then field "mkostfixsoll" has value ""
Then field "lohnkostsoll4" has value "88801"
Then field "lohnkosthaben4" has value "88802"
And I close the current editor

Given I open an editor "RMView2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BG199_001;bem=RM199003_1;typa279=Storno-Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts"
Then field "mkostfixsoll" has value ""
Then field "lohnkostsoll4" has value "88801"
Then field "lohnkosthaben4" has value "88802"
And I close the current editor
