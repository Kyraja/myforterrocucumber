# *****************************************************************************
#  Name             : anbu_letzte_AfA_buchung.feature
#  Autor            : jeffler
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Test der Aktualisierung und Ermittlung der letzten
#                     nicht stornierten AfA-Buchung sowie der, von dieser 
#                     abhängigen Restnutzungsdauer
#
# *****************************************************************************

@persistent

Feature: anbu_letzte_AfA_buchung
Background: AfA

Given I set the fake date to "07.01.02"

Scenario: Startzustand pruefen

Given I open an editor "anl1" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "440001"
Then fields have values
|      aktafabu|        50|
|aktafabu^budat|  31.12.01|
|        lafabu|31.12.2001|
|   restnutzdau|        18|
And I press button "ivkz" to open a subeditor for "fibu_ist_vkz"
Then the table has 12 rows 
Then table has values
|    !row|tbunum|tbukenn|  tbudat|
|       2|    24|     AB|28.02.01|
|      11|    46|     AB|30.11.01|
|!lastRow|    50|     AB|31.12.01|
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Scenario: alte AfA-buchung ändern

Given I open an editor "fibu-upd" from table "(Entry):(Entry)" with command "UPDATE" for record "24"
And I set field "kstelle" to "100" in row 1
# 583 : Buchung o.k.?
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Scenario: prüfen ob sich aktafabu, lafabu oder Restnutzungsdauer geändert haben 

Given I open an editor "anl2" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "440001"
Then fields have values
|      aktafabu|        50|
|aktafabu^budat|  31.12.01|
|        lafabu|31.12.2001|
|   restnutzdau|        18|
 And I close the current editor

Scenario: alte AfA-buchung ändern 2

Given I open an editor "fibu-upd2" from table "(Entry):(Entry)" with command "UPDATE" for record "46"
And I set field "kstelle" to "101" in row 1
# 583 : Buchung o.k.?
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Scenario: prüfen ob sich aktafabu, lafabu oder Restnutzungsdauer geändert haben 2

Given I open an editor "anl3" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "440001"
Then fields have values
|      aktafabu|        50|
|aktafabu^budat|  31.12.01|
|        lafabu|31.12.2001|
|   restnutzdau|        18|
 And I close the current editor

