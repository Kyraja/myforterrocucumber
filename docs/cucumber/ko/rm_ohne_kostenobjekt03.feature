@persistent
Feature: ref_rm_ohne_kostenobjekt_fkv_ein_mkv_aus_cu
Background:
Given I set the fake date to "02.01.2002"

# *****************************************************************************
#  Name             : rm_ohne_kostenobjekt03.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Test der Plausibilisierung von leeren Kostenobjekten in der Rückmeldung bei allen möglichen 
#                     Konfigurationszuständen von Material- und Fertigungskostenverbuchung
#
# *****************************************************************************
Scenario: 01 Anlage Ks für FV und Mgr
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "666fv1"
And I set field "such" to "fv1_666"
And I save the current editor

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "777mgr"
And I set field "such" to "mgr777"
And I save the current editor

Given I open an editor "mgr" from table "(Capacity):(WorkCenter)" with command "UPDATE" for record "M101"
And I set field "kstelle" to "777mgr"
And I save the current editor

Scenario: 02 Fertigungsvorschlag 
Given I open an editor "fvor_ohnekost" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel| netmge| bisuch     | kstelle | mfreig|
| BG1    |     20| BG1okost_  | 666fv1  |  ja   |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_ohnekost"
And I save the current editor

# Scenario: 03 Rückmeldung auf ersten Arbeitsgang
Given I open an editor "RM_BG1okost" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG1okost_001"
And I set field "bem" to "RM_BG1okost"
And I set field "ma" to "1"
And I set field "lgr" to "2"
And I set field "bzeit" to "1"
And I set field "mzeit" to "1"
And I set field "sofort" to "ja"
And I set field "gutmge" to "2" in row 1
And I save the current editor



 




