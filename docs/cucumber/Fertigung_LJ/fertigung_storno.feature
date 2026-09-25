@persistent
Feature: fertigung_storno.feature

# *****************************************************************************
#  Name             : fertigung_storno
#  Autor            : tiwe
#  Verantwortlich   : teaminfosysteme
#  Kontrolle        : cl
#  Funktion         : schaut sich dann die Journaleinträge durch den Storno in der Fertigung an.
#
# *****************************************************************************

# letzter Test: tiwe:20192407 Status: läuft ohne Fehler durch
#                                     Szenario 8 ist noch eien Frage beim Storno offen
#                                     ist momentan auskommentiert, da gibt wohl noch ein Cucumberproblem
################################################################################
Scenario: 1 Fall S1 Teilrückmeldung auf letzten AG und Storno dieser Rückmeldung
# Debug: LJ und Prodlist zur ID von RM1_FallS1
#################################################################################
And I set the fake date to "23.02.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_FallS1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch          | mfreig    |
    | BG3-LOHNGRUPPE | 100        | LASTSTORNO_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallS1"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf ersten Arbeitsgang über die halbe Menge
Given I open an editor "RM1_FallS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LASTSTORNO_003"
And I set field "sofort" to "ja"
And I set field "gutmge" to "50" in row 1
And I save the current editor
#############################################
# 04 Diese Rückmeldung stornieren
Given I open an editor "Storno1_FallS1" via ID from editor "RM1_FallS1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" 
And I save the current editor
Then field "stornopartnervorg^id" has value equal to field "id" from editor "RM1_FallS1" in row 0
Then field "typa279" has value "Storno-Rückmeldung"
##############################################
# 05 LJ prüfen für beide Rückmeldungen
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallS1"
And I press start
Then table has values
    | art           | zmge  | amge  |detursache                     | 
    | EINKAUF-3     |       | 50    |Rückmeldung Fertigung          |
    | EINKAUF-2     |       | 50    |Rückmeldung Fertigung          |
    | EINKAUF-1     |       | 100   |Rückmeldung Fertigung          |
    | BG3-LOHNGRUPPE| 50    |       |Rückmeldung Fertigung          |   
    | EINKAUF-3     |       | -50   |Storno-Rückmeldung Fertigung   |
    | EINKAUF-2     |       | -50   |Storno-Rückmeldung Fertigung   |
    | EINKAUF-1     |       | -100  |Storno-Rückmeldung Fertigung   |
    | BG3-LOHNGRUPPE| -50   |       |Storno-Rückmeldung Fertigung   |    
And I close the current editor
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallS1"
And I set field "kdetursache" to "Storno-Rückmeldung Fertigung" 
And I press start
Then table has values
    | art           | zmge  | amge  |detursache                     | 
    | EINKAUF-3     |       | -50   |Storno-Rückmeldung Fertigung   |
    | EINKAUF-2     |       | -50   |Storno-Rückmeldung Fertigung   |
    | EINKAUF-1     |       | -100  |Storno-Rückmeldung Fertigung   |
    | BG3-LOHNGRUPPE| -50   |       |Storno-Rückmeldung Fertigung   | 
And I close the current editor
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallS1"
And I set field "umlag" to "ja"
And I press start
# Das scheitert momentan da Storno-RM bei Umlagerungen angezeigt werden
Then the table has 0 rows
And I close the current editor

#########################################################
Scenario: 2 Fall S2 Zeitrückmeldung stornieren
# Debug: Prodlist und gebuchte RM zur ID von RM1_FallS2
##############################################
And I set the fake date to "24.02.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_FallS2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch          | mfreig    |
    | BG3-LOHNGRUPPE | 100        | STORNOZEIT_     | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallS2"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 Rückmeldung auf ersten Arbeitsgang
Given I open an editor "RM1_FallS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNOZEIT_001"
And I set fields
    | sofort    | 1                                           |
    | bem       | Dies ist nur ein RM um eine Nummer zu haben | 
And I save the current editor
##############################################
# 04 Zeitückmeldung
Given I open an editor "Zeitbuchung1_FallS2" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "nummer" from editor "RM1_FallS2"
And I set fields
    | sofort    | 1                                           |
    | lgr       | 1         |
    | bzeit     | 5         | 
And I save the current editor
##############################################
# 05 Storno dieser Zeitrückmeldung
Given I open an editor "Zeit_Storno_FallS2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=STORNOZEIT_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1" 
And I save the current editor
#Then field "typa279" has value "Storno-Zeitbuchung"
##############################################
# 06 LJ prüfen für beide Rückmeldungen
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallS2"
And I press start
Then the table has 0 rows
And I close the current editor
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallS2"
And I set field "umlag" to "ja"
And I press start
Then the table has 0 rows
################################################################################
Scenario: 3 Fall S3 Storno einer Materialentnahme
# Debug LJ und gbeuchte RM zur ID von Storno1_FallS3
################################################################################
And I set the fake date to "25.02.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben, manbu bei EINKAUF-2 setzen
Given I open an editor "fvor_FallS3" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | STORNOFBU_    | ja        |
And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row !lastRow 
And I set field "manbu" to "ja" in row 3
And I save the current editor 
And I switch the current editor to editor "fvor_FallS3"
And I set field "bisuch" to "STORNOFBU_" in row !lastRow
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallS3"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 Materialentnahme
Given I open an editor "FBU_FallS3" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "$,,such=STORNOFBU_002;@richtung=rückwärts;@maxtreffer=1"
And I press button "stlvblad"
And I save the current editor
##############################################
# 04 Materialentnahme wieder stornieren
Given I open an editor "Storno1_FallS3" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=STORNOFBU_002;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
Then field "typa279" has value "Storno-Rückmeldung"
Then the table has 2 rows
Then table has values
    | artikel       | mge   | gutmge        |
    | BG3-LOHNGRUPPE   | 100    | 0         |
    | EINKAUF-2        | -100   | 0         |
And I save the current editor
##############################################
# 05 LJ prüfen
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "Storno1_FallS3"
And I press start
Then the table has 2 rows
Then table has values
    | art       | amge  | zmge  | detursache                        |
    | EINKAUF-2 | 100   |       | Materialentnahme Fertigung        |
    | EINKAUF-2 | -100  |       | Storno-Materialentnahme Fertigung |
 And I close the current editor 
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "Storno1_FallS3"
And I set field "kdetursache" to "Storno-Materialentnahme Fertigung"
And I press start
Then the table has 1 rows
Then table has values
    | art       | amge  | zmge  | detursache                        |
    | EINKAUF-2 | -100  |       | Storno-Materialentnahme Fertigung |
And I close the current editor
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "Storno1_FallS3"
And I set field "umlag" to "ja"
And I press start
Then the table has 0 rows
################################################################################
Scenario: 4 Fall S4 Storno einer Rückmeldung auf einen abgelegten FV
# Debug LJ und gebuchte RM zur ID von RM1_FallS4
################################################################################
And I set the fake date to "26.02.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_FallS4" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch          | mfreig    |
    | BG3-LOHNGRUPPE | 100        | STORNOABLAGE_    | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallS4"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 Rückmeldung auf ersten Arbeitsgang
Given I open an editor "RM1_FallS4" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNOABLAGE_001"
And I set fields
    | sofort    | ja         |
    | gut       | ja        | 
And I save the current editor
##############################################
# 04 Rückmeldung auf letzten Arbeitsgang
Given I open an editor "RM2_FallS4" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNOABLAGE_003"
And I set fields
    | sofort    | ja         |
    | gut       | ja         | 
And I save the current editor
##############################################
# 05 Diese Rückmeldung auf den ersten AG stornieren
Given I open an editor "Storno1_FallS4" via ID from editor "RM1_FallS4" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" 
And I save the current editor
Then field "stornopartnervorg^id" has value equal to field "id" from editor "RM1_FallS4" in row 0
Then field "typa279" has value "Storno-Rückmeldung auf abgelegten Fertigungsvorschlag"
##############################################
# 06 LJ für Rückmeldung auf ersten AG auswerten
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallS4"
And I press start
Then table has values
    | art           | zmge  | amge   |detursache                     | 
    | EINKAUF-1     |       | 200    |Rückmeldung Fertigung          |
    | EINKAUF-1     |       | -200   |Storno-Rückmeldung Fertigung   |
And I close the current editor
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallS4"
And I set field "umlag" to "ja"
And I press start
Then the table has 0 rows
And I close the current editor


#############################################################################
Scenario: 5 Fall S5 Storno einer Zeitbuchung auf abgelegte FV
# Debug: LJ und gebuchte RM zur ID von RM1_FallS5
#############################################################################
And I set the fake date to "27.02.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_FallS5" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | STOABLZEIT_    | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallS5"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf letzten Arbeitsgang über volle Menge
Given I open an editor "RM1_FallS5" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STOABLZEIT_003"
And I set fields
    | sofort    | ja        |
    | gut       | ja        |
    | lgr       | 1         |
    | bzeit     | 5         |
And I save the current editor
############################################## 
# 04 Zeitbuchung auf abgelegten FV
Given I open an editor "Zeitbuchung1_FallS5" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "id" from editor "RM1_FallS5"
And I set fields
    | lgr       | 1           |
    | bzeit     | -3          | 
And I save the current editor
##############################################
# 05 Storno dieser Zeitbuchung
Given I open an editor "Storno1_FallS5" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=STOABLZEIT_003;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
And I save the current editor
##############################################
# 06 LJ prüfen
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallS5"
And I press start
Then the table has 4 rows
Then table has values
    | art            | zmge  | amge  |detursache                | 
    | EINKAUF-3      |       | 100   |Rückmeldung Fertigung     |
    | EINKAUF-2      |       | 100   |Rückmeldung Fertigung     | 
    | EINKAUF-1      |       | 200   |Rückmeldung Fertigung     |
    | BG3-LOHNGRUPPE | 100   |       |Rückmeldung Fertigung     |
And I close the current editor

#############################################################################
Scenario: 6 Fall SR1 Storno eines Rückbaus
# LJ, Prodlist und gebuchte RM zur ID von RM1_FallSR1 
#############################################################################
And I set the fake date to "28.02.1995"

# Bestandskorrektur: für eine einfachere spätere platzmengenkontrolle
Given I open an editor "Bestandskorrektur" for tip command "LBestand" and arguments ""
And I set fields
	| artikel	| EINKAUF-1	|
	| beleg		| storb		|
	| beldat	| .			|
And I set field "platz" to "F1" in row 1
And I modify table
	| !row			| mge	|
	| platz=="F1"	| 1000	|
And I save the current editor

# bestand 1000 sicherstellen:
Given I query "lgruppe,platz,charge,projekt,gebmge,verw,lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==EINKAUF-1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id"
Then query has values
	|  lgruppe|platz|charge|projekt|gebmge| verw | lffert |bewmge|
	|KARLSRUHE|   F1|      |       |  1000|      |        |  1000|

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_FallSR1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | STORNRB_    | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallSR1"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf ersten Arbeitsgang über volle Menge
Given I open an editor "RM1_FallSR1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNRB_001"
And I set fields
    | sofort    | ja         |
    | gut       | ja        | 
And I save the current editor 
##############################################
# 04 Rückbau auf ersten Arbeitsgang um 20 Einheiten
Given I open an editor "RB1_FallSR1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "STORNRB_001"
And I set field "sofort" to "ja"
And I set field "gutmge" to "-20" in row 1
And I save the current editor
##############################################
# 05 Diese Rückbau stornieren
Given I open an editor "Storno1_FallSR1" via ID from editor "RB1_FallSR1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" 
And I save the current editor
Then field "stornopartnervorg^id" has value equal to field "id" from editor "RB1_FallSR1" in row 0
Then field "typa279" has value "Storno-Rückbau auf Betriebsauftrag"
##############################################
# 06 LJ für Rückmeldung auf ersten AG auswerten
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallSR1"
And I press start
Then table has values
    | art           | zmge  | amge   |detursache                     | 
    | EINKAUF-1     |       | 200    |Rückmeldung Fertigung          |
    | EINKAUF-1     |       | -40    |Rückbau Fertigung              |
    | EINKAUF-1     |       |  40    |Storno-Rückbau Fertigung       |
And I close the current editor
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallSR1"
And I set field "umlag" to "ja"
And I press start
Then the table has 0 rows
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallSR1"
And I set field "kdetursache" to "Storno-Rückbau Fertigung"
And I press start
Then table has values
    | art           | zmge  | amge   |detursache                     | 
    | EINKAUF-1     |       |  40    |Storno-Rückbau Fertigung       |
And I close the current editor

# STORNRB_001
Given I query "lgruppe,platz,charge,projekt,gebmge,verw,lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==EINKAUF-1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id"
Then query has values
	|  lgruppe|platz|charge|projekt|gebmge|verw|lffert|bewmge|
	|KARLSRUHE|   F1|      |       |    40|    |      |    40|
	|KARLSRUHE|   F1|      |       |   760|    |      |   760|

#############################################################################
Scenario: 7 Fall SR2 Storno einer Zeitkorrektur
#Debug: Prodlist und gebuchte RM zu RM1_FallSR2 
#############################################################################
And I set the fake date to "01.03.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_FallSR2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | STORNZK_    | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallSR2"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf ersten AG über 1 Stunde
Given I open an editor "RM1_FallSR2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNZK_001"
And I set fields
    | sofort    | ja         |
    | lgr       | 1         |
    | bzeit     | 5          |
And I save the current editor 
##############################################
# 04 Zeitkorrektur um 3 h
Given I open an editor "Zeitbuchung1_FallSR2" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "nummer" from editor "RM1_FallSR2"
And I set fields
    | sofort    | 1                   |
    | lgr       | 1                   |
    | bzeit     | -3                  | 
And I save the current editor
##############################################
# 05 Diese Zeitkorrektur stornieren
Given I open an editor "Zeitkorr_Storno_FallSR2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=STORNZK_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1" 
And I save the current editor
##############################################
# 06 LJ 
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallSR2"
And I press start
Then the table has 0 rows
And I close the current editor

#############################################################################
Scenario: 8 Fall SR3 Storno einer Materialrückgabe
#Debug: LJ, Prodlist und gebuchte RM zur ID von RM1_FallSR3
#############################################################################
And I set the fake date to "02.03.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben, manbu bei EINKAUF-2 setzen
Given I open an editor "fvor_FallSR3" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch         | mfreig    |
    | BG3-LOHNGRUPPE | 100        | STORNMATRG_    | ja        |
And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row !lastRow 
And I set field "manbu" to "ja" in row 3
And I save the current editor 
And I switch the current editor to editor "fvor_FallSR3"
And I set field "bisuch" to "STORNMATRG_" in row !lastRow
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallSR3"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf zweiten AG 
Given I open an editor "RM1_FallSR3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNMATRG_002"
And I set fields
    | sofort    | 1                            |
    | bem       | Damit wir eine Nummer haben  |
And I save the current editor 
##############################################
# 04 Materialentnahme
Given I open an editor "FBU1_FallSR3" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "$,,such=STORNMATRG_002;@richtung=rückwärts;@maxtreffer=1"
And I press button "stlvblad"
And I save the current editor
##############################################
# 05 Materialrückgabe
Given I open an editor "Materialrückgabe_FallSR3" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "$,,such=STORNMATRG_002;@richtung=rückwärts;@maxtreffer=1"
And I press button "stlvblad"
And I set field "bumge" to "-20" in row 1
And I save the current editor
##############################################
# 06 Materialentnahme wieder stornieren
Given I open an editor "Storno1_FallSR3" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=STORNMATRG_002;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
Then the table has 2 rows
And I save the current editor
Then field "typa279" has value "Storno-Rückbau auf Betriebsauftrag"
#Then field "artikel" has value "BG3-LOHNGRUPPE" in row 1
#Then field "artikel" has value "EINKAUF-2" in row 2
#Then table has values
#    | artikel          | mge   | gutmge    |!row|
#    | BG3-LOHNGRUPPE   | 100   | 0         | 1  | 
#    | EINKAUF-2        |  20   | 0         | 2  |
#### hier nochmal Steffen fragen
#### man kann nur die erste Zeile abfragen
###  bei der zweiten Zeile gibts ne Fehlermeldung
##############################################
# 07 LJ für Rückmeldung auf ersten AG auswerten
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallSR3"
And I press start
Then table has values
    | art           | zmge  | amge   |detursache                          | 
    | EINKAUF-2     |       | 100    |Materialentnahme Fertigung          |
    | EINKAUF-2     |       | -20    |Materialrückgabe Fertigung          |
    | EINKAUF-2     |       |  20    |Storno-Materialrückgabe Fertigung   |
And I close the current editor
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallSR3"
And I set field "umlag" to "ja"
And I press start
Then the table has 0 rows
And I close the current editor
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallSR3"
And I set field "kdetursache" to "Storno-Materialrückgabe Fertigung"
And I press start
Then the table has 1 rows
Then table has values
    | art           | zmge  | amge   |detursache                          | 
    | EINKAUF-2     |       |  20    |Storno-Materialrückgabe Fertigung   |
And I close the current editor




#############################################################################
Scenario: 9 Fall SR4 Storno eines Rückbaus auf abgelegte FVs
# Debug: LJ und gebuchte RM zur ID von RM1_FallSR4
#############################################################################
And I set the fake date to "03.03.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_FallSR4" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | STORNRBABL_    | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallSR4"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf letzten Arbeitsgang über volle Menge
Given I open an editor "RM1_SR4" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNRBABL_003"
And I set fields
    | sofort    | ja         |
    | gut       | ja         | 
And I save the current editor 
##############################################
# 04 Rückbau nachbuchen
Given I open an editor "RB1_FallSR4" via ID from editor "RM1_SR4" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
And I set field "lgr" to "1" 
And I set field "bzeit" to "2"
And I set field "gutmge" to "-20" in row 1
And I save the current editor
#############################################
# 05 Rückbau stornieren
Given I open an editor "Storno1_FallSR4" via ID from editor "RB1_FallSR4" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" 
And I save the current editor
Then field "stornopartnervorg^id" has value equal to field "id" from editor "RB1_FallSR4" in row 0
Then field "typa279" has value "Storno-Rückbau auf abgelegten Fertigungsvorschlag"
##############################################
# 06 LJ für Rückmeldung auswerten
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_SR4"
And I press start
Then table has values
    | art           | zmge  | amge    |detursache               | 
    | EINKAUF-3     |       |  100    |Rückmeldung Fertigung    |
    | EINKAUF-2     |       |  100    |Rückmeldung Fertigung    |
    | EINKAUF-1     |       |  200    |Rückmeldung Fertigung    |
    | BG3-LOHNGRUPPE| 100   |         |Rückmeldung Fertigung    |
    | BG3-LOHNGRUPPE| -20   |         |Rückbau Fertigung        |
    | BG3-LOHNGRUPPE|  20   |         |Storno-Rückbau Fertigung | 
    # hier scheitert der Test momentan berechtigt, da Storno-Rückmeldun Fertigung im LJ steht
# Komponenten müssen beim Rückbau einzeln gebucht werden
And I close the current editor
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_SR4"
And I set field "umlag" to "ja"
And I press start
Then the table has 0 rows
And I close the current editor
    
#############################################################################
Scenario: 10 Fall SR5 Storno einer Zeitkorrektur auf abgelegte FVs
# Debug: LJ und gebuchte RM zur ID von RM1_FallSR5
#############################################################################
And I set the fake date to "04.03.1995"

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_FallSR5" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch         | mfreig    |
    | BG3-LOHNGRUPPE | 100        | STORNZKABL_    | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallSR5"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf letzten Arbeitsgang über volle Menge
Given I open an editor "RM1_FallSR5" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNZKABL_003"
And I set fields
    | sofort    | ja         |
    | gut       | ja         | 
And I save the current editor 
##############################################
# 04 Zeitkorrektur nachbuchen
Given I open an editor "Zeitbuchung1_FallSR5" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "id" from editor "RM1_FallSR5"
And I set field "lgr" to "1"
And I set field "bzeit" to "100"
And I save the current editor
#################################################
# 06 Zeitkorrektur stornieren
Given I open an editor "Storno1_FallSR5" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=STORNZKABL_003;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
And I save the current editor
# 07 LJ für Rückmeldung auswerten
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallSR5"
And I press start
Then table has values
    | art           | zmge  | amge    |detursache               | 
    | EINKAUF-3     |       |  100    |Rückmeldung Fertigung    |
    | EINKAUF-2     |       |  100    |Rückmeldung Fertigung    |
    | EINKAUF-1     |       |  200    |Rückmeldung Fertigung    |
    | BG3-LOHNGRUPPE| 100   |         |Rückmeldung Fertigung    |

 
# bitte das fake date pro scenario neu auf den letzten wert setzen. vielen dank. BC-rewe
