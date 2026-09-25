@persistent
Feature: rechenregeln
Background:
Given I set the fake date to "04.01.2002"


Scenario: 01
Given I set the fake date to "04.01.2002"


Given I open an editor "bab1-test1" from table "(EDS):(EDS)" with command "UPDATE" for record "BAB1"
# 2614 de      |Zyklus in Rechenregel. Trotzdem speichern?
And I respond with answer "Ja" to the dialog with id "2614"
And I save the current editor

Given I open an editor "rere1upd" from table "(CostType):(ComputationRule)" with command "UPDATE" for record "rere1"
And I delete row at position 2
And I save the current editor

# mind. ein zyklus muss noch da sein: deshalb die rückfrage
Given I open an editor "bab1-test1" from table "(EDS):(EDS)" with command "UPDATE" for record "BAB1"
# 2614 de      |Zyklus in Rechenregel. Trotzdem speichern?
And I respond with answer "Ja" to the dialog with id "2614"
And I save the current editor

Given I open an editor "rere1upd" from table "(CostType):(ComputationRule)" with command "UPDATE" for record "rere1"
Then message "Enthaltene Rechenregel 2 verursacht einen Zyklus." was displayed
And I save the current editor

Given I open an editor "rere1upd" from table "(CostType):(ComputationRule)" with command "VIEW" for record "rere1"
Then message "Enthaltene Rechenregel 2 verursacht einen Zyklus." was displayed
And I close the current editor

# weiteren zyklus entfernen
Given I open an editor "rere2upd" from table "(CostType):(ComputationRule)" with command "UPDATE" for record "rere2"
And I delete row at position 1
And I save the current editor

# mind. ein zyklus muss noch da sein: deshalb die rückfrage
# findet auch den tiefsten zyklus noch
Given I open an editor "bab1-test1" from table "(EDS):(EDS)" with command "UPDATE" for record "BAB1"
# 2614 de      |Zyklus in Rechenregel. Trotzdem speichern?
And I respond with answer "Ja" to the dialog with id "2614"
And I save the current editor


Given I open an editor "rere2upd" from table "(CostType):(ComputationRule)" with command "UPDATE" for record "rere2"
Then message "Enthaltene Rechenregel 2 verursacht einen Zyklus." was displayed
And I save the current editor

Given I open an editor "rere1upd" from table "(CostType):(ComputationRule)" with command "VIEW" for record "rere2"
Then message "Enthaltene Rechenregel 2 verursacht einen Zyklus." was displayed
And I close the current editor


Given I open an editor "rere3upd" from table "(CostType):(ComputationRule)" with command "UPDATE" for record "rere3"
Then message "Enthaltene Rechenregel 2 verursacht einen Zyklus." was displayed
And I save the current editor

Given I open an editor "rere3upd" from table "(CostType):(ComputationRule)" with command "VIEW" for record "rere3"
Then message "Enthaltene Rechenregel 2 verursacht einen Zyklus." was displayed
And I close the current editor

Given I open an editor "rere4upd" from table "(CostType):(ComputationRule)" with command "UPDATE" for record "rere4"
Then message "Enthaltene Rechenregel 2 verursacht einen Zyklus." was displayed
And I save the current editor

Given I open an editor "rere4upd" from table "(CostType):(ComputationRule)" with command "VIEW" for record "rere4"
Then message "Enthaltene Rechenregel 2 verursacht einen Zyklus." was displayed
And I close the current editor

# tiefen zyklus entfernen
Given I open an editor "rere4upd" from table "(CostType):(ComputationRule)" with command "UPDATE" for record "rere4"
And I delete row at position 1
And I save the current editor

Given I open an editor "bab1-test2" from table "(EDS):(EDS)" with command "UPDATE" for record "BAB1"
# diese meldung kommt hier nicht mehr vor, weil kein zyklus mehr vorhanden ist
# 2614 de      |Zyklus in Rechenregel. Trotzdem speichern?
And I save the current editor

Given I open an editor "rere4upd" from table "(CostType):(ComputationRule)" with command "UPDATE" for record "rere4"
# <dev-26 uo ref_rere_keine_rekursionen2 >printf "RERE4\n" | edpimport.sh -p sy -b60:2 -f such -a VIEW
# <dev-26 uo ref_rere_keine_rekursionen2 >printf "RERE4\n" | edpimport.sh -p sy -b60:2 -f such -u
# diese zeile ist ein FALSCH POSITIV
# es wird keine meldung angezeigt, aber die zeile läuft fehlerfrei durch.
# die meldung an sich ist an anderer stelle gültig, hier aber m.e. nicht.
Then message "Enthaltene Rechenregel 2 verursacht einen Zyklus." was displayed
And I save the current editor

# ---------------- kein zyklus mehr vorhanden -----------------

Given I open an editor "rere1werte" from table "(CostType):(ComputationRule)" with command "VIEW" for record "RERE1"
And I set field "koobj" to "101"
Then I fill template "ko_rechenregel1.ftl" and append it to output file "rere_template_out.ref"
And I close the current editor

Given I open an editor "rere2werte" from table "(CostType):(ComputationRule)" with command "VIEW" for record "RERE2"
And I set field "koobj" to "101"
Then I fill template "ko_rechenregel1.ftl" and append it to output file "rere_template_out.ref"
And I close the current editor

Given I open an editor "rere3werte" from table "(CostType):(ComputationRule)" with command "VIEW" for record "RERE3"
And I set field "koobj" to "101"
Then I fill template "ko_rechenregel1.ftl" and append it to output file "rere_template_out.ref"
And I close the current editor

Given I open an editor "rere4werte" from table "(CostType):(ComputationRule)" with command "VIEW" for record "RERE4"
And I set field "koobj" to "101"
Then I fill template "ko_rechenregel1.ftl" and append it to output file "rere_template_out.ref"
And I close the current editor


