@persistent
Feature: fertigung_normal.feature

# *****************************************************************************
#  Name             : fertigung_normal
#  Autor            : tiwe
#  Verantwortlich   : teaminfosysteme
#  Kontrolle        : cl
#  Funktion         : Bucht den ganzen Fertigungsfortschritt.
#
# *****************************************************************************

# letzter Test: tiwe:20192407 Status: läuft ohne Fehler durch
Scenario: 1 Fall 1 RM auf ersten und zweiten Arbeitgang und testen der Journaleinträge
# Debug: LJ und ID von RM1_Fall1 und RM2_Fall1 auswerten
################################################################################
##############################################
And I set the fake date to "03.02.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_Fall1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | RMNORM_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_Fall1"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf ersten Arbeitsgang über volle Menge
Given I open an editor "RM1_Fall1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RMNORM_001"
And I set fields
    | sofort    | 1         |
    | gut       | 1         | 
And I save the current editor
Then field "typa279" has value "Rückmeldung"
##############################################
# 04 RM auf zweiten Arbeitsgang über volle Menge
Given I open an editor "RM2_Fall1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RMNORM_002"
And I set fields
    | sofort    | 1         |
    | gut       | 1         | 
And I save the current editor
Then field "typa279" has value "Rückmeldung"
##############################################
# 05 LJ prüfen für RM1
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_Fall1"
And I set field "abgang" to "ja"
And I press start
Then table has values
    | art       | zmge  | amge  |detursache                     | 
    | EINKAUF-1 |       | 200   |Rückmeldung Fertigung          |
And I close the current editor
##############################################
# 06 LJ prüfen für RM2
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM2_Fall1"
And I set field "abgang" to "ja"
And I set field "kdetursache" to "Rückmeldung Fertigung"
And I press start
Then table has values
    | art       | zmge  | amge  |detursache                     | 
    | EINKAUF-3 |       | 100   |Rückmeldung Fertigung          |
    | EINKAUF-2 |       | 100   |Rückmeldung Fertigung          |
And I close the current editor

############################################################################
Scenario: 2 Fall 1 RM auf den letzten Arbeitgang und testen der Journaleinträge
# Debug: LJ und ID von RM3_Fall1 auswerten
############################################################################
##############################################
And I set the fake date to "04.02.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor2_Fall1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | RMLASTAG_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor2_Fall1"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf ersten Arbeitsgang über volle Menge
Given I open an editor "RM3_Fall1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RMLASTAG_003"
And I set fields
    | sofort    | 1         |
    | gut       | 1         | 
And I save the current editor
Then field "typa279" has value "Rückmeldung"
##############################################
# 04 LJ prüfen für Abgänge von RM1
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM3_Fall1"
And I set field "abgang" to "ja"
And I press start
Then table has values
    | art            | zmge  | amge  |detursache                     |  
    | EINKAUF-3      |       | 100   |Rückmeldung Fertigung          |
    | EINKAUF-2      |       | 100   |Rückmeldung Fertigung          |
    | EINKAUF-1      |       | 200   |Rückmeldung Fertigung          |
##############################################
# 05 LJ prüfen für Zugänge von RM1
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM3_Fall1"
And I set field "zugang" to "ja"
And I set field "kdetursache" to "Rückmeldung Fertigung"
And I press start
Then table has values
    | art            | zmge  | amge  |detursache                     | 
    | BG3-LOHNGRUPPE | 100   |       |Rückmeldung Fertigung          | 
############################################################################
Scenario: 3 Fall 2 Zeitbuchung auf einen Arbeitsschein
#Debug: PRODLIST und ID von RM1_Fall2 auswerten
############################################################################
And I set the fake date to "05.02.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_Fall2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | RMTIME_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_Fall2"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
############################################## 
# 03 Zeitbuchung über Rückmeldung und Zeitückmeldung
Given I open an editor "RM1_Fall2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RMTIME_001"
And I set fields
    | lgr    | 1         |
    | bzeit  | 5         | 
    | sofort | ja        |
And I save the current editor
Given I open an editor "Zeitbuchung1" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "nummer" from editor "RM1_Fall2"
And I set fields
    | lgr       | 1         |
    | bzeit     | 5         | 
And I save the current editor
##############################################
# 04 LJ prüfen
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_Fall2"
And I press start
Then the table has 0 rows
############################################################################
Scenario: 4 Fall 3 Komponente Einkauf-2 auf manbu=ja und Rückmeldungen und Materialen
#Debug: LJ RM2_Fall3
############################################################################
##############################################
And I set the fake date to "06.02.1995"


# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_Fall3" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | RMFBU_    | ja        |
And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row !lastRow 
And I set field "manbu" to "ja" in row 3
And I save the current editor 
And I switch the current editor to editor "fvor_Fall3"
And I set field "bisuch" to "RMFBU_" in row !lastRow
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_Fall3"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf ersten Arbeitsgang über volle Menge
Given I open an editor "RM1_Fall3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RMFBU_001"
And I set fields
    | sofort    | 1         |
    | gut       | 1         | 
And I save the current editor
Then field "typa279" has value "Rückmeldung"
Then field "manrm" has value "nein"
##############################################
# 04 LJ prüfen für RM1
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_Fall3"
And I set field "abgang" to "ja"
And I press start
Then table has values
    | art       | zmge  | amge  |detursache                     | 
    | EINKAUF-1 |       | 200   |Rückmeldung Fertigung          |
And I close the current editor
##############################################
# 05 RM auf den zweiten AG über die volle Menge
Given I open an editor "RM2_Fall3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RMFBU_002"
And I set fields
    | sofort    | 1         |
    | gut       | 1         | 
And I save the current editor
Then field "typa279" has value "Rückmeldung"
Then field "manrm" has value "nein"
##############################################
# 06 LJ prüfen für RM2
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM2_Fall3"
And I set field "abgang" to "ja"
And I press start
Then table has values
    | art       | zmge  | amge  |detursache                     | 
    | EINKAUF-3 |       | 100   |Rückmeldung Fertigung          |
And I close the current editor
##############################################
# 07 Materialentnahme
Given I open an editor "FBU1_Fall3" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "$,,such=RMFBU_002;@richtung=rückwärts;@maxtreffer=1"
And I press button "stlvblad"
And I save the current editor
###############################################
# 08 LJ prüfen für RM2
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM2_Fall3"
And I set field "abgang" to "ja"
And I set field "kdetursache" to "Materialentnahme Fertigung"
And I press start
Then table has values
    | art       | zmge  | amge  |detursache                     | 
    | EINKAUF-2 |       | 100   |Materialentnahme Fertigung     | 
And I close the current editor
################################################
############################################################################
Scenario: 5 Fall 4 und 5 Nachbuchen und Zeitbuchung auf abgelegten FV
#Debug: LJ und gebuchte RM mit ID von RM1_Fall4_5
############################################################################
##############################################
And I set the fake date to "07.02.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_Fall4_5" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | RMABL_    | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_Fall4_5"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf letzten Arbeitsgang über volle Menge
Given I open an editor "RM1_Fall4_5" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RMABL_003"
And I set fields
    | sofort    | 1         |
    | gut       | 1         | 
And I save the current editor
Then field "typa279" has value "Rückmeldung"
##############################################
# 04 Zusätzliche Zeit und Entnahme nachbuchen
Given I open an editor "RM2_Fall4_5" via ID from editor "RM1_Fall4_5" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
And I set field "lgr" to "1" 
And I set field "bzeit" to "2"
And I set field "mge" to "2" in row 2
And I save the current editor
Then field "typa279" has value "Rückmeldung auf abgelegten Fertigungsvorschlag"
############################################## 
# 05 Zeitbuchung
Given I open an editor "Zeitbuchung_Fall4_5" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "id" from editor "RM1_Fall4_5"
And I set fields
    | lgr       | 1         |
    | bzeit     | 5         | 
And I save the current editor
##############################################
##############################################
# 06 LJ prüfen
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_Fall4_5"
And I press start
Then table has values
    | art            | zmge  | amge  |detursache                | 
    | EINKAUF-3      |       | 100   |Rückmeldung Fertigung     |
    | EINKAUF-2      |       | 100   |Rückmeldung Fertigung     | 
    | EINKAUF-1      |       | 200   |Rückmeldung Fertigung     |
    | BG3-LOHNGRUPPE | 100   |       |Rückmeldung Fertigung     |
    | EINKAUF-1      |       | 2     |Rückmeldung Fertigung     |
And I close the current editor
################################################
############################################################################
Scenario: 6 Fall 6 Rückmeldung neu, Fertigung ohne FV
#Debug: LJ mit ID RM1_Fall6
############################################################################
################################################
And I set the fake date to "08.02.1995"

# 01 Rückmeldung neu
Given I open an editor "RM1_Fall6" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
And I set fields
    | barmex    | 9999999        | 
    | mgr       | 101            |
    | artikel   | BG3-Lohngruppe |
    | kstelle   | 100            |
And I append rows
| artikel       | mge   | 
| EINKAUF-1     | 33   |
| EINKAUF-2     | 66    |      
And I save the current editor
Then field "typa279" has value "Rückmeldung ohne Fertigungsvorschlag"
# 02 LJ prüfen
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_Fall6"
And I press start
Then table has values
    | art            | zmge  | amge  |detursache                           | 
    | EINKAUF-2      |       | 66    |Fertigung ohne Fertigungsvorschlag   | 
    | EINKAUF-1      |       | 33    |Fertigung ohne Fertigungsvorschlag   |
And I close the current editor
################################################

# bitte das fake date pro scenario neu auf den letzten wert setzen. vielen dank. BC-rewe
