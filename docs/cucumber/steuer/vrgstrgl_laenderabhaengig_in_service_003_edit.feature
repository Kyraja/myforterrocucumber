# *****************************************************************************
#  Name             : vrgstrgl_laenderabhaengig_in_service_003_edit.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Service-Vorgaenge anlegen + Kontrolle von steuerlichen Feldern im 'Kopf'
#
#
# *****************************************************************************
@persistent
Feature:  vrgstrgl_laenderabhaengig_in_service_003_edit.feature
Background: XXX

@FALL-Service-Auftrag
Scenario: Reparaturauftrag
# Reparaturauftrag anlegen
Given I open an editor "repauftrag-6A" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to "2012"
And I set field "nummer" to "6A-AU"
And I set field "such" to "AU-6A"
And I create a new row at the end of the table
And I set field "serprod" to "F248-SCHUMI" in row 1

Then the table has 2 rows
And I save the current editor

# Ausgabe Reparaturauftrag
Given I open an editor "Auftrag-view" from table "(Sales):(RepairOrder)" with command "VIEW" for record from editor "repauftrag-6A"
Then field "vrgstrgl" has value "VKITAL" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "LOM" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "LOM" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123545" in row 0
Then field "rechnland" has value "ITALIEN" in row 0
Then field "rechnregion" has value "LOM" in row 0
Then field "versustid" has value "IT123545" in row 0
And I close the current editor

# Zugang Kundengeraet
Given I open an editor "reparauftrag" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-6A"
And I press button "repzug" to open a subeditor for "zugangsls-6A"
And I set field "nummer" to "6A-LS1"
And I set field "such" to "LS-6A-1"
And I set field "platz" to "5" in row 1
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "reparauftrag"
And I save the current editor
#####################################################################################################################################

Scenario: Service-Auftrag
# Service-Auftrag anlegen
Given I open an editor "servciceauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to "2012"
And I set field "nummer" to "6-SAU"
And I set field "such" to "SAU-6"
Then field "vrgstrgl" has value "VKITAL" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "LOM" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "LOM" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123545" in row 0
Then field "rechnland" has value "ITALIEN" in row 0
Then field "rechnregion" has value "LOM" in row 0
Then field "versustid" has value "IT123545" in row 0
And I create a new row at the end of the table
And I set field "techniker" to "MECHANIKER1" in row 1
And I set field "artikel" to "FEHLERANALYSE" in row 1
And I set field "mge" to "2" in row 1
And I set field "zzvon" to "11:15" in row 1
And I set field "zzbis" to "13:50" in row 1
And I set field "preis" to "45,45" in row 1

Then the table has 1 rows
And I save the current editor
#####################################################################################################################################


Scenario: ServiceAngebot
# ServiceAngebot anlegen
Given I open an editor "ServiceAngebot" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
And I set field "kunde" to "2012"
And I set field "nummer" to "6-SAN"
And I set field "such" to "SAN-6"
Then field "vrgstrgl" has value "VKITAL" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "LOM" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "LOM" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123545" in row 0
Then field "rechnland" has value "ITALIEN" in row 0
Then field "rechnregion" has value "LOM" in row 0
Then field "versustid" has value "IT123545" in row 0
And I create a new row at the end of the table
And I set field "techniker" to "MECHANIKER1" in row 1
And I set field "artikel" to "FEHLERANALYSE" in row 1
And I set field "mge" to "2" in row 1
Then the table has 1 rows
And I save the current editor
#####################################################################################################################################

