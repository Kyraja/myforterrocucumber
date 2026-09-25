# *****************************************************************************
#  Name             : ref_fe_storno_bewertungssicht_02_rueckmeldungen.feature
#  Autor            : wane
#  Verantwortlich   : uo
#  Kontrolle        : 
#  Funktion         : Testet Prozesse Storno Rueckmeldung
#
#      Hinweis: hier werden angepasste Teile aus der Datei
#               BC2_STORNO_Lager_Lagerbuchung_Prozesstests.feature verwendet
#
# *****************************************************************************
@persistent
Feature: Storno Rueckmeldungen (Bewertung)
Background: Test von Stornos in der Fertigung
Given I set the fake date to "07.01.2002"

## Rueckmeldungen eines lebendigen Betriebsauftrags

Scenario: 01 Storno einer Rueckmeldung ueber die gesamte Gutemenge, Teile retrograd entnommen; Testumgebung 15

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "22" with Price "12.10" in the Area "15"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "22" in the Area "15"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "22" in the Area "15"

# Rechnung mit Menge 22 und Preis 12.71 anlegen + verbuchen
Given I create an invoice for the Test Case "22" with Quantity "22" per Price "12.71" to the PurchasingPackingSlip in the Area "15"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "22" in the Area "15" with Command Revalue

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge    | bisuch    | mfreig    | binoloe   |
    | 0vfall15  | 10        | RETRO_    | ja        | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "22" in the Area "15" with Command Revalue

# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RETRO_001"
And I set fields
    | sofort    | 1     |
    | bzeit     | 1,5   |
    | mzeit     | 1,5   |
    | gut       | 1     |
And I save the current editor

# Bewertung Rueckmeldung1
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=0vfall15;detursache=`;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "22" in the Area "15" with Command Revalue

# Erste Rueckmeldung stornieren
Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" 
And I save the current editor
Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Bewertung hat Nachfolger
Given I switch the current editor to editor "Bewertung" with command "VIEW"
Then field "nachfolger" is not empty
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "22" in the Area "15" with Command Revalue
#####################################################################################################################################


Scenario: 04 Storno einer Teil-Rueckmeldung, Teile manuell entnommen; Testumgebung 18


# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "24" with Price "12.10" in the Area "18"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "24" in the Area "18"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "24" in the Area "18"

# Rechnung mit Menge 22 und Preis 12.71 anlegen + verbuchen
Given I create an invoice for the Test Case "24" with Quantity "24" per Price "12.71" to the PurchasingPackingSlip in the Area "18"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "24" in the Area "18" with Command Revalue

# Fertigungsartikel anpassen
Given I open an editor "<such>" from table "(Part):(Product)" with command "UPDATE" for record "0vfall18"
And I set fields
    | dispoa    | auftragsbezogen |
    | efrist    | 2               |
    | epr       | 25              |
    | chimlager | ja              |
    | chverfolgung | Chargenverfolgung              |
And I set field "manbu" to "ja" in row 1
And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel       | netmge    | mfreig    | bisuch     |
    | 0vfall18      | 10        | ja        | TEILMANBU_ |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "24" in the Area "18" with Command Revalue

# Betriebsauftrag aufrufen fuer BA-Nummer
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "TEILMANBU_000"
Then field "nummer" is not empty
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "24" in the Area "18" with Command Revalue

# Materialentnahme fuer Betriebsauftrag
Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "nummer" from editor "Betriebsauftrag"
And I set field "manent" to "ja"
And I press button "stllad"
And I set field "mgr" to "121"
And I set field "bumge" to "10" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "24" in the Area "18" with Command Revalue

# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEILMANBU_001"
And I set field "sofort" to "ja"
And I set field "gutmge" to "5" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "24" in the Area "18" with Command Revalue

# Bewertung Rueckmeldung1
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=0vfall18;detursache=`;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
And I close the current editor

# # Erste Rueckmeldung stornieren
# Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" 
# And I save the current editor
# Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "24" in the Area "18" with Command Revalue

# Berwertung hat Nachfolger
Given I switch the current editor to editor "Bewertung" with command "VIEW"
Then field "nachfolger" is empty
And I close the current editor

# Offene Mengen Material und Arbeitsgaenge pruefen
And I switch the current editor to editor "Betriebsauftrag" with command "UPDATE"
Then field "mge" has value "10"
Then field "rgutmge" has value "0"
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
    | limge | gmge  |
    | 10    | 10    |
    | 5     | 0.42  |
    | 10    | 1.68  |
And I close the current editor
And I switch the current editor to editor "Betriebsauftrag"
And I respond with answer "JA" to the dialog with id "1483"
And I set field "status" to "s"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "24" in the Area "18" with Command Revalue
#####################################################################################################################################


Scenario: 06 Storno einer Rueckmeldung mit Zeitmeldung und gesamter Gutmenge; Testumgebung 20

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "25" with Price "12.10" in the Area "20"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "25" in the Area "20"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "25" in the Area "20"

# Rechnung mit Menge 22 und Preis 12.71 anlegen + verbuchen
Given I create an invoice for the Test Case "25" with Quantity "25" per Price "12.71" to the PurchasingPackingSlip in the Area "20"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "25" in the Area "20" with Command Revalue

# Fertigungsartikel anpassen
Given I open an editor "<such>" from table "(Part):(Product)" with command "UPDATE" for record "0vfall20"
And I set fields
    | dispoa    | auftragsbezogen |
    | efrist    | 2               |
    | epr       | 25              |
    | chimlager | ja              |
    | chverfolgung | Chargenverfolgung              |
And I set field "manbu" to "ja" in row 1
And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel       | netmge    | bisuch    | mfreig    | binoloe |
    | 0vfall20      | 10        | ZEITMGE_  | ja        | ja      |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Zeit-Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZEITMGE_001"
And I set field "gut" to "ja"
And I set field "mzeit" in row 0 to "vzeit" from editor "Rückmeldung1" in row 0
And I set field "bzeit" in row 0 to "vzeit" from editor "Rückmeldung1" in row 0
And I set field "sofort" to "1"
And I save the current editor

# Bewertung Rueckmeldung1
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=0vfall20;detursache=`;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
And I close the current editor

# Zeit- und Mengenangaben auf Arbeitsgang = 0 in Prodlist pruefen
Given I open the infosystem "PRODLIST"
And I set field "kba" to "$,,such=ZEITMGE_000;@richtung=rückwärts;@maxtreffer=1"
And I set field "detail" to "ja"
And I press start
Then field "bzeit" has value "1" in row 3
Then field "mzeit" has value "1" in row 3
Then field "ofmge" has value "0" in row 3
Then field "ofmge" has value "20" in row 2
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "25" in the Area "20" with Command Revalue

# # Rueckmeldung stornieren
# Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" 
# Then field "mzeit" has value "-1"
# Then field "bzeit" has value "-1"
# Then field "gutmge" has value "-10" in row 1
# And I save the current editor
# Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
Given I switch the current editor to editor "Bewertung" with command "VIEW"
Then field "nachfolger" is empty
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "25" in the Area "20" with Command Revalue

# # Betriebsauftrag abschließen
# Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZEITMGE_000"
# And I set field "noloesch" to "nein"
# And I respond with answer "JA" to the dialog with id "345"
# And I set field "status" to "s"
# And I save the current editor
#
# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion for the Test Case "25" in the Area "20" with Command Revalue
# ####################################################################################################################################


Scenario: 17 Storno moeglich, wenn es noch ungebuchte Rueckmeldungen zum gleichen oder einem anderen Arbeitsschein gibt; Testumgebung 21

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "26" with Price "12.10" in the Area "21"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "26" in the Area "21"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "26" in the Area "21"

# Rechnung mit Menge 22 und Preis 12.71 anlegen + verbuchen
Given I create an invoice for the Test Case "26" with Quantity "26" per Price "12.71" to the PurchasingPackingSlip in the Area "21"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "26" in the Area "21" with Command Revalue

# Fertigungsartikel anpassen
Given I open an editor "<such>" from table "(Part):(Product)" with command "UPDATE" for record "0vfall21"
And I set fields
    | dispoa    | auftragsbezogen |
    | efrist    | 2               |
    | epr       | 25              |
    | chimlager | ja              |
    | chverfolgung | Chargenverfolgung              |
And I set field "manbu" to "ja" in row 1
And I save the current editor

# Fertigungsvorschlag anlegen und freigeben, Fall mit erlaubtem BA-Abbruch da eine KST verwendet wird
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel       | netmge    | mfreig    | bisuch        | kstelle |
    | 0vfall21      | 10        | ja        | STORNONEIN_   | 101     |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Rueckmeldung auf ersten Arbeitsgang ohne Buchen
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNONEIN_001"
And I set field "gut" to "1"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "26" in the Area "21" with Command Revalue

# Rueckmeldung auf zweiten Arbeitsgang
Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNONEIN_002"
And I set field "gut" to "1"
And I set field "sofort" to "1"
And I set field "manrest" to "1"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "26" in the Area "21" with Command Revalue

# Zweite Rueckmeldung stornieren
Given I open an editor "Storno1" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" 
And I save the current editor
Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung2" in row 0

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "26" in the Area "21" with Command Revalue

# Erste Rueckmeldung uebernehmen
And I switch the current editor to editor "Rückmeldung1" with command "TRANSFER"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "26" in the Area "21" with Command Revalue

# Betriebsauftrag abschliessen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "STORNONEIN_000"
And I respond with answer "JA" to the dialog with id "1483"
And I set field "status" to "s"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "26" in the Area "21" with Command Revalue
#####################################################################################################################################
