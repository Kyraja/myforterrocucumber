@persistent
Feature: fertigung_rueckbau.feature

# *****************************************************************************
#  Name             : fertigung_rueckbau
#  Autor            : tiwe
#  Verantwortlich   : teaminfosysteme
#  Kontrolle        : cl
#  Funktion         : schaut sich dann die Journaleinträge durch den Rückbau in der Fertigung an.
#
# *****************************************************************************

# letzter Test: tiwe:20192407 Status: läuft ohne Fehler durch
################################################################################
Scenario: 1 Fall R1 Rückbau zu einer gebuchten Rückmeldung
# Debug: LJ mit ID von RM1_FallR1
##############################################
And I set the fake date to "12.02.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_FallR1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | RMNORMRB_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallR1"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf ersten Arbeitsgang über volle Menge
Given I open an editor "RM1_FallR1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RMNORMRB_001"
And I set fields
    | sofort    | 1         |
    | gut       | 1         | 
And I save the current editor
Then field "typa279" has value "Rückmeldung"
##############################################
# 04 Rückbau auf ersten Arbeitsgang um 20 Einheiten
Given I open an editor "RB1_FallR1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RMNORMRB_001"
And I set field "sofort" to "ja"
And I set field "gutmge" to "-20" in row 1
And I save the current editor
Then field "typa279" has value "Rückbau auf Betriebsauftrag"
##############################################
# 05 LJ prüfen
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallR1"
And I press start
Then table has values
    | art       | zmge  | amge  |detursache                     | 
    | EINKAUF-1 |       | 200   |Rückmeldung Fertigung          |
    | EINKAUF-1 |       | -40   |Rückbau Fertigung              |
And I close the current editor
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallR1"
And I set field "kdetursache" to "Rückbau Fertigung"
And I press start
Then table has values
    | art       | zmge  | amge  |detursache                     | 
    | EINKAUF-1 |       | -40   |Rückbau Fertigung              |    
And I close the current editor
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallR1"
And I set field "umlag" to "ja"
Then the table has 0 rows
################################################################################
Scenario: 2 Fall R2 Zeitkorrektur
# Debug: LJ und gebuchte RM mit ID von RM1_FallR2
################################################################################
And I set the fake date to "13.02.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_FallR2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | ZEITKORR_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallR2"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf ersten Arbeitsgang über volle Menge
Given I open an editor "RM1_FallR2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZEITKORR_001"
And I set fields
    | sofort    | 1         |
    | gut       | ja        | 
    | lgr       | 1         |
    | bzeit     | 5         |
And I save the current editor
##############################################
# 04 Zeitkorrektur um 2 h
Given I open an editor "Zeitbuchung1" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "nummer" from editor "RM1_FallR2"
And I set fields
# | barmex    | !Rückmeldung2^nummer|
    | lgr       | 1                   |
    | bzeit     | -3                  | 
And I save the current editor
##############################################
# 05 LJ Prüfen
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallR2"
And I press start
Then table has values
    | art       | zmge  | amge  |detursache                     | 
    | EINKAUF-1 |       | 200   |Rückmeldung Fertigung          |
##############################################    
Scenario: 3 Fall R3 Materialrückgabe
# Debug: LJ mit ID von RM1_FallR3
##############################################
And I set the fake date to "14.02.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_FallR3" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | MATRUECK_    | ja        |
And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row !lastRow 
And I set field "manbu" to "ja" in row 3
And I save the current editor 
And I switch the current editor to editor "fvor_FallR3"
And I set field "bisuch" to "MATRUECK_" in row !lastRow
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallR3"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 Materialentnahme
Given I open an editor "FBU1_FallR3" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "$,,such=MATRUECK_002;@richtung=rückwärts;@maxtreffer=1"
And I press button "stlvblad"
And I save the current editor
##############################################
# 04 Materialrückgabe
Given I open an editor "FBU2_FallR3" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "$,,such=MATRUECK_002;@richtung=rückwärts;@maxtreffer=1"
And I press button "stlvblad"
And I set field "bumge" to "-20" in row 1
And I save the current editor
##############################################
# 05 RM auf zweiten Arbeitsgang, damit man eine Nummer hat
Given I open an editor "RM1_FallR3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MATRUECK_002"
And I set fields
    | sofort    | 1         |
    | lgr       | 1         |
    | bzeit     | 5         |
And I save the current editor
##############################################
# 06 LJ prüfen für RM2
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallR3"
And I set field "abgang" to "ja"
And I press start
Then table has values
    | art       | zmge  | amge  |detursache                     | 
    | EINKAUF-2 |       | 100   |Materialentnahme Fertigung     | 
    | EINKAUF-2 |       | -20   |Materialrückgabe Fertigung     |
And I close the current editor
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallR3"
And I set field "kdetursache" to "Materialrückgabe Fertigung"
And I press start
Then table has values
    | art       | zmge  | amge  |detursache                     |  
    | EINKAUF-2 |       | -20   |Materialrückgabe Fertigung     |
Given I open the infosystem "LJ"   
And I set field "beleg" to "nummer" from editor "RM1_FallR3"
And I set field "umlag" to "ja"
And I press start
Then the table has 0 rows
##############################################
######################################################################
Scenario: 4 Fall R4 Rückbau und R5 Zeitkorrektur auf abgelegte FVs
# Debug: LJ und gebuchte RM für ID RM1_FallR4_5
##############################################
And I set the fake date to "15.02.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_FallR4" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | RBABL_    | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallR4"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf letzten Arbeitsgang über volle Menge
Given I open an editor "RM1_FallR4_5" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RBABL_003"
And I set fields
    | sofort    | 1         |
    | gut       | ja         | 
    | lgr       | 1         |
    | bzeit     | 5         |   
And I save the current editor
##############################################
# 04 Zusätzliche Zeit und Entnahme nachbuchen
Given I open an editor "RM2_FallR4_5" via ID from editor "RM1_FallR4_5" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
And I set field "lgr" to "1" 
And I set field "bzeit" to "2"
And I set field "gutmge" to "-20" in row 1
And I save the current editor
##############################################
# 05 Zeitkorrektur um 3 h
Given I open an editor "Zeitbuchung2" for tip command "Zeitbuchung" and arguments ""
# hier muss noch evtl. ein + vor die Rückmeldenummer
And I set field "barmex" to "id" from editor "RM1_FallR4_5"
And I set fields
    | lgr       | 1           |
    | bzeit     | -3          | 
And I save the current editor
# 06 LJ prüfen
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallR4_5"
And I press start
Then table has values
    | art            | zmge  | amge  |detursache                | 
    | EINKAUF-3      |       | 100   |Rückmeldung Fertigung     |
    | EINKAUF-2      |       | 100   |Rückmeldung Fertigung     | 
    | EINKAUF-1      |       | 200   |Rückmeldung Fertigung     |
    | BG3-LOHNGRUPPE | 100   |       |Rückmeldung Fertigung     |
    | BG3-LOHNGRUPPE | -20   |       |Rückbau Fertigung         |
# Beim Rückbau müssen die Komponenten manuell nachgebucht werden
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallR4_5"
And I set field "umlag" to "ja"
And I press start
Then the table has 0 rows

# bitte das fake date pro scenario neu auf den letzten wert setzen. vielen dank. BC-rewe
