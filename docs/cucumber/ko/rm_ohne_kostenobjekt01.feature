@persistent
Feature: ref_rm_ohne_kostenobjekt_fkv_*
Background:
Given I set the fake date to "02.01.2002"

# *****************************************************************************
#  Name             : rm_ohne_kostenobjekt01.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Test der Plausibilisierung von leeren Kostenobjekten in der Rückmeldung bei allen möglichen 
#                     Konfigurationszuständen von Material- und Fertigungskostenverbuchung
#
# *****************************************************************************
Scenario: 01 Bestand E1 beschaffen
Given I open an editor "LbuchZu1" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "E1"
And I set field "beleg" to "sih1"
And I set field "beldat" to "."
And I set field "buart" to "zugang"
And I set field "wert" to "10"
And I set field "mge" to "20" in row 1
And I set field "platz2" to "F1" in row 1
And I save the current editor

Given I open an editor "LbuchZu2" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "E1"
And I set field "beleg" to "sih2"
And I set field "beldat" to "."
And I set field "buart" to "zugang"
And I set field "wert" to "12"
And I set field "mge" to "26" in row 1
And I set field "platz2" to "F2" in row 1
And I save the current editor

Scenario: 02 Anlage Kst 888 und 999
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "111wg"
And I set field "such" to "wg111"
And I save the current editor

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "222wg"
And I set field "such" to "wg222"
And I save the current editor

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "333pg"
And I set field "such" to "pg333"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "55"
And I set field "wgkst" to "111wg"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "56"
And I set field "wgkst" to "222wg"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "UPDATE" for record "66"
And I set field "pgkst" to "333pg"
And I save the current editor





 




