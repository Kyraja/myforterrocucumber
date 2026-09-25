@persistent
Feature: koppelprodukt_umbauartikel.feature

  Background:
    And I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : koppelprodukt_umbauartikel
#  Autor            : lschneider
#  Verantwortlich   : bheim
#  Kontrolle        : amk
#  Funktion         : Testet die Prozesse und Plausibilitäten, die mit 
#                     Koppelprodukten und Umbauartikel zusammenhängen
#  Jira-Issue       : FDA-534
# *****************************************************************************

  Scenario: 01 Komponenteneigenschaft ist in Fertigungsliste Artikelstamm und Standardfertigungsliste hinterlegt
# Arbeitsgang MONTAGE1 aufrufen
    Given I open an editor "MONTAGE1" from table "(Operation):(Operation)" with command "VIEW" for record "MONTAGE1"
    And I close the current editor

# Artikel anlegen und beispielhaft Koppelprodukt setzen
    Given I open an editor "KOPPELTEST_FL" from table "(Part):(Product)" with command "STORE" for record "KOPPELTEST_FL"
    And I set fields
      | such       | KOPPELTEST_FL                    |
      | namebspr   | Koppelprodukt in Fertigungsliste |
      | bsart      | Eigenfertigung                   |
      | flistestd  |                                  |
      | flistename | KOPPELLISTE                      |
    And I modify table
      | elex       | anzahl | kompeig       | !row |
      | EINKAUF-1  | 1      |               | 1    |
      | KOPPELPROD | 1      | Koppelprodukt | 2    |
      | A MONTAGE1 | 1      |               | 3    |
    And I save the current editor

# Standardfertigungsliste änden
    Given I open an editor "Standardfertigungsliste" from table "(ProductionList):(ProductionList)" with command "UPDATE" for record "KOPPELLISTE"
    And I set field "kompeig" to "Koppelprodukt" in row 1
    And I set field "kompeig" to "" in row 2
    And I append rows
      | elex       | anzahl | kompeig       |
      | KOPPELPROD | 1      | Koppelprodukt |
    And I save the current editor

# Fertigungsliste in Artikel auf Änderungen prüfen und ändern
    And I switch the current editor to editor "KOPPELTEST_FL" with command "UPDATE"
    Then field "kompeig" has value "Koppelprodukt" in row 1
    Then field "kompeig" is empty in row 2
    Then field "kompeig" has value "Koppelprodukt" in row !lastRow
    And I set field "kompeig" to "" in row 1
    And I set field "kompeig" to "Koppelprodukt" in row 2
    And I delete row at position !lastRow
    And I save the current editor

# Standardfertigungsliste auf Änderungen prüfen
    And I switch the current editor to editor "Standardfertigungsliste" with command "VIEW"
    Then field "kompeig" is empty in row 1
    Then field "kompeig" has value "Koppelprodukt" in row 2
    Then field "elex^nummer" in row !lastRow has value equal to field "nummer" from editor "MONTAGE1" in row 0
    And I close the current editor


  Scenario: 02 In einer Fertigungsliste, Standardfertigungsliste und AFL kann für Artikel keine negative Menge eingetragen werden
# Test in neu angelegtem Artikel
    Given I open an editor "Artikel" from table "(Part):(Product)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "elex" to "EINKAUF-1" in row 1
    And setting field "anzahl" to "-1" in row 1 throws the exception "1361"
    And I close the current editor

# Test in bestehendem Artikel
    Given I open an editor "BG-KOPPEL_UPDATE" from table "(Part):(Product)" with command "UPDATE" for record "BG-KOPPEL"
    And I set field "elex" to "KOPPELPROD" in row 1
    And setting field "anzahl" to "-1" in row 1 throws the exception "1361"
    And I close the current editor

# Test in Standardfertigungsliste
    Given I open an editor "Standardfertigungsliste" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "elex" to "KOPPELPROD" in row !lastRow
    And setting field "anzahl" to "-1" in row !lastRow throws the exception "1361"
    And I close the current editor

# Test in Auftragsfertigungsliste
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
    And I append rows
      | artikel   | mge |
      | BG-KOPPEL | 5   |
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row 1
    And I create a new row at position 1
    And I set field "elex" to "KOPPELPROD" in row 1
    And setting field "anzahl" to "-1" in row 1 throws the exception "1361"
    And I close the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor


  Scenario: 03 Komponenteneigenschaften können nicht im Arbeitsgang oder bei Fertigungsmitteln gesetzt werden
# Test in Fertigungsliste
    Given I open an editor "Artikel" from table "(Part):(Product)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "elex" to "A VORBEREITUNG" in row 1
    Then field "kompeig" is not modifiable in row 1
    And I set field "elex" to "LEIM" in row 1
    Then field "kompeig" is not modifiable in row 1
    And I close the current editor

# Test in Auftragsfertigungsliste
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
    And I append rows
      | artikel   | mge |
      | BG-KOPPEL | 5   |
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row 1
    Then field "kompeig" is not modifiable in row 3
    And I create a new row at the end of the table
    And I set field "elex" to "A VORBEREITUNG" in row !lastRow
    Then field "kompeig" is not modifiable in row !lastRow
    And I create a new row at the end of the table
    And I set field "elex" to "LEIM" in row !lastRow
    Then field "kompeig" is not modifiable in row !lastRow
    And I close the current editor
    And I switch the current editor to editor "auftrag"
    And I close the current editor


  Scenario: 04 Im rückgemeldeten Bereich einer AFL kann keine Komponenteneigenschaft gesetzt werden
# Auftrag anlegen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-KOPPEL" and quantity "1"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch  | mfreig |
      | BG2-KOPPEL | 1      | KOPPEL_ | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    And I run Scheduling

# Betriebsauftrag aufrufen für BA-Nummer
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KOPPEL_000"
    And I save value from field "nummer" in row 0
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPPEL_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

# Änderungen im rückgemeldeten Bereich prüfen, aflschutz=nein
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "banummer" in row 0 to saved value
    And I press button "ladetab"
    And I press button "absteig" to open a subeditor for "AFL_bearbeiten" in row 1
    And I create a new row at position 1
    And I set field "elex" to "KOPPELPROD" in row 1
    And I set field "elanzahl" to "1" in row 1
    Then field "kompeig" is modifiable in row 1
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

# Rückmeldung auf zweiten Arbeitsgang, BA abschließen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPPEL_002"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "manrest" to "ja"
    And I save the current editor

# Auftrag liefen
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-04"


  Scenario: 05 Ein Koppelprodukt kann in einer Auftragsfertigungsliste nachträglich eingefügt und gesetzt werden
# Auftrag anlegen und Koppelprodukt in AFL einfügen
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "RADSHOP"
    And I append rows
      | artikel   | mge |
      | BG-KOPPEL | 5   |
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row 1
    And I modify table
      | !row | elex       | anzahl | kompeig       |
      | +1   | KOPPELPROD | 1      | Koppelprodukt |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

# Dispo starten
    And I run Scheduling

# Reservierung neu eingefügtes Koppelprodukt prüfen
    Given I open an editor "Fertigungsvorschläge" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-KOPPEL"
    And I press button "ladetab"
    And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    Then field "kompeig" has value "Koppelprodukt" in row 1
    And I close the current editor
    And I switch the current editor to editor "Fertigungsvorschläge"
    And I close the current editor

#  Auftrag stornieren
    And I switch the current editor to editor "auftrag"
    And I respond with answer "JA" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 06 In der AFL und Materialentnahme ist/wird für Koppelprodukt/Umbauartikel der Standard-Zugangslagerplatz gesetzt, bei leerer Komponenteneigenschaft wird wieder der Standard-Abgangslagerplatz gesetzt
# Fertigungsvorschlag anlegen, Lagerplatz prüfen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig |
      | BG-KOPPEL | 5   | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "platz" has value "F2" in row 1
    And I set field "kompeig" to "" in row 1
    Then field "platz" has value "F1" in row 1
    And I create a new row at the end of the table
    And I set field "elex" to "UMBAUART" in row !lastRow
    And I set field "kompeig" to "Umbauartikel" in row !lastRow
    Then field "platz" has value "F2" in row !lastRow
    And I set field "kompeig" to "" in row !lastRow
    Then field "platz" has value "F1" in row !lastRow
    And I close the current editor
    And I switch the current editor to editor "fvor"
    Then I set field "bisuch" to "LAGER_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Lagerplatz in freigegebenen Fertigungsvorschlag prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "LAGER_000"
    And I press button "absteig" to open a subeditor for "AFL_freigegeben"
    Then field "platz" has value "F2" in row 1
    And I set field "kompeig" to "" in row 1
    Then field "platz" has value "F1" in row 1
    And I create a new row at the end of the table
    And I set field "elex" to "UMBAUART" in row !lastRow
    And I set field "kompeig" to "Umbauartikel" in row !lastRow
    Then field "platz" has value "F2" in row !lastRow
    And I set field "kompeig" to "" in row !lastRow
    Then field "platz" has value "F1" in row !lastRow
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

# Lagerplatz in Materialentnahme prüfen
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "nummer" from editor "Betriebsauftrag"
    And I set field "autorment" to "ja"
    And I press button "stllad"
    And I create a new row at the end of the table
    And I set field "elex" to "UMBAUART" in row !lastRow
    And I set field "kompeig" to "Umbauartikel" in row !lastRow
    Then field "buplatz" has value "F2" in row !lastRow
    And I set field "kompeig" to "" in row !lastRow
    Then field "buplatz" has value "F1" in row !lastRow
    And I close the current editor


  Scenario: 07 Koppelprodukt wird retrograd mit positiver Menge und Buchungsursache Zugang Fertigung gebucht, die Bewertung ist als Koppelprodukt gekennzeichnet
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BG-KOPPEL | 5      | RETRO_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag aufrufen für BA-Nummer
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RETRO_000"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RETRO_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor

# Berwertung prüfen
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=KOPPELPROD;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "koppelprodukt" has value "ja"
    And I close the current editor

# Lagerbuchung prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Arbeitsschein1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | buart  | detursache            | !row |
      | KOPPELPROD | 4    | Zugang | Rückmeldung Fertigung | 2    |
    And I close the current editor

## Nachkalkulkation prüfen
#Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
#And I set field "banummer" to "nummer" from editor "Betriebsauftrag"
#And I press button "ladetab"
#And I press button "kblatt" to open a subeditor for "Nachkalkulation" in row 1
#Then field "matek" has value "9.0000"
#Then field "menge" has value "-1" in row 1
#Then field "eeinzk" has value "0.0000" in row 1
#Then field "egeinzk" has value "0.0000" in row 1
#And I close the current editor
#And I switch the current editor to editor "fvor"
#And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RETRO_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 08 Koppelprodukt wird manuell mit positiver Menge und Buchungsursache Zugang Fertigung gebucht, die Bewertung ist als Koppelprodukt gekennzeichnet
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig |
      | BG-KOPPEL | 10     | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MANBU_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag aufrufen für BA-Nummer
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MANBU_000"
    And I close the current editor

# Materialentnahme für Betriebsauftrag
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "nummer" from editor "Betriebsauftrag"
    And I set field "manent" to "ja"
    And I set field "mgr" to "112"
    And I press button "stllad"
    Then the table has 2 rows
    Then field "elex" has value "KOPPELPROD" in row 1
    Then field "bumge" has value "10" in row 1
    Then field "kompeig" has value "Koppelprodukt" in row 1
    And I save the current editor

# Berwertung prüfen
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=KOPPELPROD;detursache=Materialentnahme Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "koppelprodukt" has value "ja"
    And I close the current editor

# Lagerbuchung prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Betriebsauftrag"
    And I press start
    Then table has values
      | !row | zmge | buart  | detursache                 |
      | 2    | 10   | Zugang | Materialentnahme Fertigung |
    And I close the current editor

## Nachkalkulkation prüfen
#Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
#And I set field "banummer" to "nummer" from editor "Betriebsauftrag"
#And I press button "ladetab"
#And I press button "kblatt" to open a subeditor for "Nachkalkulation" in row 1
#Then field "matek" has value "9.0000"
#Then field "menge" has value "-1" in row 1
#Then field "eeinzk" has value "0.0000" in row 1
#Then field "egeinzk" has value "0.0000" in row 1
#And I close the current editor
#And I switch the current editor to editor "fvor"
#And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANBU_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor


  Scenario: 09 Bedarfe des Koppelprodukts werden zuerst zu bestehenden Fertigungsvorschlägen der zugehörigen baugruppe zugeordnet
# Auftrag für Koppelprodukt anlegen
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "RADSHOP"
    And I append rows
      | artikel    | mge   |
      | KOPPELPROD | 50000 |
    And I save the current editor

# Betriebsauftrag freigeben und bearbeiten
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge   | bisuch  | mfreig |
      | BG-KOPPEL | 90000 | BEDARF_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Dispo starten
    And I run Scheduling
# Kein Bestellvorschlag vorhanden
    Given I open an editor "Bestellvorschläge" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BG-KOPPEL"
    And I press button "ladetab"
    Then the table has 0 rows
    And I close the current editor

# Auftrag und Betriebsauftrag stornieren
    And I switch the current editor to editor "auftrag"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BEDARF_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 10 Änderungen am Koppelprodukt in der AFL möglich
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "RADSHOP"
    And I append rows
      | artikel   | mge |
      | BG-KOPPEL | 5   |
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row 1
    Then field "kompeig" has value "Koppelprodukt" in row 1
    And I set field "anzahl" to "5" in row 1
    And I set field "manbu" to "ja" in row 1
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

# Dispo starten
    And I run Scheduling

# Fertigungsvorschlag freigeben und AFL prüfen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-KOPPEL"
    And I press button "ladetab"
    Then I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    Then field "kompeig" has value "Koppelprodukt" in row 1
    Then field "anzahl" has value "5" in row 1
    Then field "manbu" has value "ja" in row 1
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

# Auftrag stornieren
    And I switch the current editor to editor "auftrag"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 11 Koppelprodukt aus Fertigungsliste über eine Rückmeldung aus EntnahmeMZ in einen leeren Behlter buchen
    Given I open an editor "BEH_KOPPELPROD" from table "(Container):(ContainerShell)" with command "NEW" for record ""
    And I set field "such" to "BEH_KOPPELPROD"
    And I set field "packm" to "BEHAELTER"
    And I save the current editor

# Fertigungsvorschlag mit MZ für Behälter anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig |
      | BG-KOPPEL | 5   | ja     |
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I create a new row at the end of the table
    And I set field "zuomge" to "5" in row 1
    And I set field "behaelter" to id from editor "BEH_KOPPELPROD" in row 1
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEHNEU_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf den ersten Arbeitsgang, Koppelprodukt in Behälter
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHNEU_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

# Behälter prüfen
    And I switch the current editor to editor "BEH_KOPPELPROD" with command "VIEW"
    Then the table has 1 rows
    Then field "artikel" has value "KOPPELPROD" in row 1
    Then field "mge" has value "5" in row 1
    And I close the current editor


  Scenario: 12 Koppelprodukt aus Fertigungsliste über eine Rückmeldung in einen Behälter aus EntnahmeMZ buchen, der einen anderen Artikel enthält
# Behälter erstellen
    Given I open an editor "BEH_FERTIGUNG" from table "(Container):(ContainerShell)" with command "NEW" for record ""
    And I set field "such" to "BEH_FERTIGUNG"
    And I set field "packm" to "BEHAELTER"
    And I save the current editor

# Lagerbuchung Artikel EINKAUF-1 in Behälter
    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel | EINKAUF-1 |
      | buart   | Zugang    |
      | beleg   | 11        |
      | beldat  | .         |
    And I append rows
      | mge | behaelter                                                            |
      | 3   | $,,such=BEH_FERTIGUNG;@sort=nummer;@richtung=rückwärts;@maxtreffer=1 |
    And I save the current editor

# Fertigungsvorschlag mit MZ für Behälter anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig |
      | BG-KOPPEL | 5   | ja     |
    And I press button "mzabsm" to open a subeditor for "Materialzuordnung" in row 1
    And I create a new row at the end of the table
    And I set field "zuomge" to "5" in row 1
    And I set field "behaelter" to id from editor "BEH_FERTIGUNG" in row 1
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEHGEFUELLT_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang, Koppelprodukt in gefüllten Behälter
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHGEFUELLT_001"
    And I set fields
      | gut    | 1 |
      | sofort | 1 |
    And I save the current editor

# Behälter prüfen
    And I switch the current editor to editor "BEH_FERTIGUNG" with command "VIEW"
    Then the table has 2 rows
    Then field "artikel" has value "EINKAUF-1" in row 1
    Then field "artikel" has value "KOPPELPROD" in row 2
    Then field "mge" has value "5" in row 2
    And I close the current editor


  Scenario: 13 Koppelprodukt wird in der gebuchten Rückmeldung als Koppelprodukt angezeigt
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | bisuch   | mfreig |
      | BAUGRUPPE2 | 5   | ANZEIGE_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang, Koppelprodukt in Rückmeldung in neuer Zeile
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ANZEIGE_001"
    And I set fields
      | gut    | 1 |
      | sofort | 1 |
    And I create a new row at the end of the table
    And I set field "artikel" to "KOPPELPROD" in row !lastRow
    And I set field "mge" to "3" in row !lastRow
    And I set field "kompeig" to "Koppelprodukt" in row !lastRow
    And I save the current editor

# Rückmeldung auf zweiten Arbeitsgang, Betriebsauftrag abschließen
    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ANZEIGE_002"
    And I set fields
      | gut     | 1  |
      | sofort  | 1  |
      | manrest | ja |
    And I save the current editor

# Rückmeldung 1 auf Koppelprodukt prüfen
    And I switch the current editor to editor "Arbeitsschein1" with command "VIEW"
    Then field "artikel" has value "KOPPELPROD" in row 2
    Then field "kompeig" has value "Koppelprodukt" in row 2
    And I close the current editor


  Scenario: 14 Ein Umbauartikel kann in einer Auftragsfertigungsliste nachträglich eingefügt und gesetzt werden
# Auftrag anlegen und Umbauartikel in AFL einfügen
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "RADSHOP"
    And I append rows
      | artikel  | mge |
      | BG-UMBAU | 5   |
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row 1
    And I create a new row at position 1
    And I set field "elex" to "UMBAUART" in row 1
    And I set field "anzahl" to "1" in row 1
    And I set field "kompeig" to "Umbauartikel" in row 1
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

# Dispo starten
    And I run Scheduling

# Reservierung neu eingefügter Umbauartikel prüfen
    Given I open an editor "Fertigungsvorschläge" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-UMBAU"
    And I press button "ladetab"
    And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    Then field "kompeig" has value "Umbauartikel" in row 1
    And I close the current editor
    And I switch the current editor to editor "Fertigungsvorschläge"
    And I close the current editor

#  Auftrag stornieren
    And I switch the current editor to editor "auftrag"
    And I respond with answer "JA" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 15 Umbauartikel wird retrograd mit positiver Menge und Buchungsursache Zugang Fertigung gebucht, die Bewertung ist als Umbauartikel gekennzeichnet
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BG3-UMBAU | 5      | URETRO_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag aufrufen für BA-Nummer
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "URETRO_000"
    Then field "nummer" is not empty
    And I close the current editor

# Rückmeldung auf ersten und zweiten Arbeitsgang
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "URETRO_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "URETRO_002"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "manrest" to "1"
    And I save the current editor

# Berwertung prüfen
    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=UMBAUART;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "koppelprodukt" has value "ja"
    And I close the current editor

# Lagerbuchung prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Arbeitsschein2"
    And I press start
    Then field "art" has value "UMBAUART" in row 2
    Then field "zmge" has value "5" in row 2
    Then field "buart" has value "Zugang" in row 2
    Then field "detursache" has value "Rückmeldung Fertigung" in row 2
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "URETRO_003"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 16 Umbauartikel wird manuell mit positiver Menge und Buchungsursache Zugang Fertigung gebucht, die Bewertung ist als Umbauartikel gekennzeichnet
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel  | netmge | mfreig |
      | BG-UMBAU | 5      | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "UMANBU_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag aufrufen für BA-Nummer
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "UMANBU_000"
    And I close the current editor

# Materialentnahme für Betriebsauftrag
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "nummer" from editor "Betriebsauftrag"
    And I set field "manent" to "ja"
    And I set field "mgr" to "112"
    And I press button "stllad"
    Then the table has 2 rows
    Then field "elex" has value "UMBAUART" in row 1
    Then field "bumge" has value "5" in row 1
    Then field "kompeig" has value "Umbauartikel" in row 1
    And I save the current editor

# Berwertung prüfen
    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=UMBAUART;detursache=Materialentnahme Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "koppelprodukt" has value "ja"
    And I close the current editor

# Lagerbuchung prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Betriebsauftrag"
    And I press start
    Then table has values
      | !row | zmge | buart  | detursache                 |
      | 2    | 5    | Zugang | Materialentnahme Fertigung |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UMANBU_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "manrest" to "1"
    And I save the current editor


  Scenario: 17 Umbauartikel kann in Bedarfen verwendet werden
# Auftrag für Koppelprodukt anlegen
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "RADSHOP"
    And I append rows
      | artikel  | mge   |
      | UMBAUART | 50000 |
    And I save the current editor

# Betriebsauftrag freigeben und bearbeiten
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge   | bisuch   | mfreig |
      | BG2-UMBAU | 90000 | UBEDARF_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Dispo starten
    And I run Scheduling

# Kein Bestellvorschlag vorhanden
    Given I open an editor "Bestellvorschläge" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BG2-UMBAU"
    And I press button "ladetab"
    Then the table has 0 rows
    And I close the current editor

# Auftrag und Betriebsauftrag stornieren
    And I switch the current editor to editor "auftrag"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "UBEDARF_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 18 Änderungen am Umbauartikel in der AFL möglich
# Auftrag anlegen
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "RADSHOP"
    And I append rows
      | artikel  | mge |
      | BG-UMBAU | 5   |
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row 1
    Then field "kompeig" has value "Umbauartikel" in row 1
    And I set field "anzahl" to "5" in row 1
    And I set field "manbu" to "ja" in row 1
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

# Dispo starten
    And I run Scheduling

# Fertigungsvorschlag freigeben und AFL prüfen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-UMBAU"
    And I press button "ladetab"
    Then I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    Then field "kompeig" has value "Umbauartikel" in row 1
    Then field "anzahl" has value "5" in row 1
    Then field "manbu" has value "ja" in row 1
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

# Auftrag stornieren
    And I switch the current editor to editor "auftrag"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 19 Umbauartikel kann in AFL neu eingefügt werden
# Auftrag anlegen
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "RADSHOP"
    And I append rows
      | artikel   | mge |
      | BAUGRUPPE | 5   |
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row 1
    And I create a new row at position 1
    And I set field "elex" to "UMBAUART" in row 1
    And I set field "anzahl" to "1" in row 1
    And I set field "kompeig" to "Umbauartikel" in row 1
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

# Dispo starten
    And I run Scheduling

# Auftrag prüfen und stornieren
    And I switch the current editor to editor "auftrag" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row 1
    Then table has values
      | artikel  | kompeig      |
      | UMBAUART | Umbauartikel |
    And I close the current editor
    And I switch the current editor to editor "auftrag"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 20 In AFL eingefügter Umbauartikel über eine Rückmeldung in einen leeren Behälter buchen, EnznahmeMZ und Materialentnahme
# Behälter erstellen
    Given I create a Container "BEH_UMBAUART" for packaging material "BEHAELTER" and search word "BEH_UMBAUART"

# Fertigungsvorschlag mit MZ für Behälter anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig |
      | BAUGRUPPE | 5   | ja     |
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row 1
    And I modify table
      | !row | elex      | kompeig      | elanzahl |
      | +1   | UMBAUART  | Umbauartikel | 1        |
      | +1   | EINKAUF-1 | Umbauartikel | 1        |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I append rows
      | zuomge | behaelter     |
      | 5      | !BEH_UMBAUART |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "UMBAUNEU_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag aufrufen für BA-Nummer
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "UMBAUNEU_000"
    And I close the current editor

# Materialentnahme auf den ersten Arbeitsgang und setzen des Behälters für UMBAUART
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "nummer" from editor "Betriebsauftrag"
    And I set field "autorment" to "ja"
    And I set field "mgr" to "112"
    And I press button "stllad"
    Then the table has 4 rows
    Then table has values
      | elex     | bumge | kompeig      | !row |
      | UMBAUART | 5     | Umbauartikel | 2    |
    And I set field "manbu" to "ja" in row 2
    And I set field "buplatz" to "F1" in row 2
    And I set field "behaelter" to id from editor "BEH_UMBAUART" in row 2
    And I save the current editor

# Rückmeldung auf den ersten Arbeitsgang, Koppelprodukt in Behälter
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UMBAUNEU_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

# Behälter prüfen
    And I switch the current editor to editor "BEH_UMBAUART" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 5   |
    And I close the current editor


  Scenario: 21 In AFL eingefügter Umbauartikel über eine Rückmeldung in einen bereits gefüllten Behälter buchen, EnznahmeMZ und Materialentnahme
# Behälter erstellen
    Given I create a Container "BEH_UNGEFUELLT" for packaging material "BEHAELTER"

# Lagerbuchung Artikel EINKAUF-1 in Behälter
    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel | EINKAUF-1 |
      | buart   | Zugang    |
      | beleg   | 11        |
      | beldat  | .         |
    And I append rows
      | platz2 | mge | behaelter       |
      | F2     | 3   | !BEH_UNGEFUELLT |
    And I save the current editor

# Fertigungsvorschlag mit MZ für Behälter anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig |
      | BAUGRUPPE | 5   | ja     |
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row 1
    And I modify table
      | !row | elex      | kompeig      | elanzahl |
      | +1   | UMBAUART  | Umbauartikel | 1        |
      | +1   | EINKAUF-1 | Umbauartikel | 1        |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I create a new row at the end of the table
    And I set field "zuomge" to "5" in row 1
    And I set field "behaelter" to id from editor "BEH_UNGEFUELLT" in row 1
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "UMBAUGEF_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag aufrufen für BA-Nummer
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "UMBAUGEF_000"
    And I close the current editor

# Materialentnahme auf den ersten Arbeitsgang und setzen des Behälters für UMBAUART
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "nummer" from editor "Betriebsauftrag"
    And I set field "autorment" to "ja"
    And I set field "mgr" to "112"
    And I press button "stllad"
    Then the table has 4 rows
    Then table has values
      | elex     | bumge | kompeig      | !row |
      | UMBAUART | 5     | Umbauartikel | 2    |
    And I set field "manbu" to "ja" in row 2
    And I set field "behaelter" to id from editor "BEH_UNGEFUELLT" in row 2
    And I save the current editor

# Rückmeldung auf den ersten Arbeitsgang, Koppelprodukt in Behälter
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UMBAUGEF_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

# Behälter prüfen
    And I switch the current editor to editor "BEH_UNGEFUELLT" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel   | mge | !row |
      | EINKAUF-1 | 8   | 1    |
      | UMBAUART  | 5   | 2    |
    And I close the current editor


  Scenario: 22 Mehrere Koppelprodukte in einer Fertigungsliste werden korrekt in den gleichen Behälter über Materialentnahme gebucht
# Baugruppe mit mehreren Koppelprodukten anlegen
    Given I open an editor "VIELEKOPPEL" from table "(Part):(Product)" with command "STORE" for record "VIELEKOPPEL"
    And I set fields
      | such     | VIELEKOPPEL                  |
      | namebspr | Mehrere Koppelprodukte in FL |
      | bsart    | Eigenfertigung               |
    And I delete all rows
    And I append rows
      | elex        | anzahl | kompeig       |
      | EINKAUF-1   | 1      | Koppelprodukt |
      | KOPPELPROD  | 1      | Koppelprodukt |
      | A SCHRAUBEN | 1      |               |
      | EINKAUF-2   | 1      |               |
      | A MONTAGE1  | 1      |               |
    And I save the current editor

# Behälter erstellen
    Given I create a Container "BEH_VIELEKOPPEL" for packaging material "BEHAELTER"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | bisuch | mfreig |
      | VIELEKOPPEL | 5   | INBEH_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag aufrufen für BA-Nummer
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "INBEH_000"
    And I close the current editor

# Materialentnahme zu Arbeisgang 1
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "nummer" from editor "Betriebsauftrag"
    And I set fields
      | manent    | ja  |
      | autorment | ja  |
      | mgr       | 112 |
    And I press button "stllad"
    And I modify table
      | !row | manbu | buplatz |
      | 1    | ja    | F1      |
      | 2    | ja    | F1      |
    And I set field "behaelter" to id from editor "BEH_VIELEKOPPEL" in row 1
    And I set field "behaelter" to id from editor "BEH_VIELEKOPPEL" in row 2
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "INBEH_001"
    And I set fields
      | gut    | 1 |
      | sofort | 1 |
    And I save the current editor

# Behälter BEH_VIELEKOPPEL auf Koppelprodukte prüfen
    And I switch the current editor to editor "BEH_VIELEKOPPEL" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge |
      | EINKAUF-1  | 5   |
      | KOPPELPROD | 5   |
    And I close the current editor

## Nachkalkulkation prüfen
#Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
#And I set field "banummer" to "nummer" from editor "Betriebsauftrag"
#And I press button "ladetab"
#And I press button "kblatt" to open a subeditor for "Nachkalkulation" in row 1
#Then field "matek" has value "6.0000"
#Then table has values
#	| menge	| eeinzk	| egeinzk	| !row	|
#	| -1	| 0.0000	| 0.0000	| 1		|
#	| -1	| 0.0000	| 0.0000	| 2		|
#And I close the current editor
#And I switch the current editor to editor "fvor"
#And I close the current editor

# Rückmeldung auf zweiten Arbeitsgang, Betriebsauftrag abschließen
    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "INBEH_002"
    And I set fields
      | gut    | 1 |
      | sofort | 1 |
    And I save the current editor


  Scenario: 23 Koppelprodukt und Umbauartikel in einer Fertigungsliste werden korrekt in den gleichen Behälter über Materialentnahme gebucht
# Baugruppe mit Koppelprodukte und Umbauartikel anlegen
    Given I open an editor "KOPPELUMBAU" from table "(Part):(Product)" with command "STORE" for record "KOPPELUMBAU"
    And I set fields
      | such     | KOPPELUMBAU                     |
      | namebspr | Koppelprod & Umbauartikel in FL |
      | bsart    | Eigenfertigung                  |
    And I delete all rows
    And I append rows
      | elex        | anzahl | kompeig       |
      | KOPPELPROD  | 1      | Koppelprodukt |
      | UMBAUART    | 1      | Umbauartikel  |
      | A SCHRAUBEN | 1      |               |
      | EINKAUF-2   | 1      |               |
      | A MONTAGE1  | 1      |               |
    And I save the current editor

# Behälter erstellen
    Given I create a Container "BEH_KOPPELUMBAU" for packaging material "BEHAELTER"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | bisuch | mfreig |
      | KOPPELUMBAU | 5   | KOPUM_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag aufrufen für BA-Nummer
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KOPUM_000"
    And I close the current editor

# Materialentnahme zu Arbeisgang 1
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "nummer" from editor "Betriebsauftrag"
    And I set fields
      | manent    | ja  |
      | autorment | ja  |
      | mgr       | 112 |
    And I press button "stllad"
    And I modify table
      | !row | manbu | behaelter                                                              |
      | 1    | ja    | $,,such=BEH_KOPPELUMBAU;@richtung=rückwärts;@sort=nummer;@maxtreffer=1 |
      | 2    | ja    | $,,such=BEH_KOPPELUMBAU;@richtung=rückwärts;@sort=nummer;@maxtreffer=1 |
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPUM_001"
    And I set fields
      | gut    | 1 |
      | sofort | 1 |
    And I save the current editor

# Behälter BEH_KOPPELUMBAU auf Koppelprodukte prüfen
    And I switch the current editor to editor "BEH_KOPPELUMBAU" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge |
      | KOPPELPROD | 5   |
      | UMBAUART   | 5   |
    And I close the current editor

## Nachkalkulkation prüfen
#Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
#And I set field "banummer" to "nummer" from editor "Betriebsauftrag"
#And I press button "ladetab"
#And I press button "kblatt" to open a subeditor for "Nachkalkulation" in row 1
#Then field "matek" has value "6.0000"
#Then table has values
#	| menge	| eeinzk	| egeinzk	| !row	|
#	| -1	| 0.0000	| 0.0000	| 1		|
#	| -1	| 0.0000	| 0.0000	| 2		|
#And I close the current editor
#And I switch the current editor to editor "fvor"
#And I close the current editor

# Rückmeldung auf zweiten Arbeitsgang, Betriebsauftrag abschließen
    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPUM_002"
    And I set fields
      | gut    | 1 |
      | sofort | 1 |
    And I save the current editor


  Scenario: 24 Koppelprodukt wird als zusätzliche Entnahme mit Charge gebucht. Prüfung auf Zugang zur Charge.
# Charge anlegen
    Given I open an editor "charge01" from table "(Lots):(Lots)" with command "STORE" for record "CH_FERT01"
    And I set field "such" to "CH_FERT01"
    And I set field "chname" to "CH_FERT01"
    And I set field "artikel" to "KOPPELPROD"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch  | mfreig |
      | BAUGRUPPE2 | 24     | KOPZUS_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag aufrufen für BA-Nummer
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KOPZUS_000"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPZUS_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "4" in row 1
    And I append rows
      | artikel    | mge | kompeig       | charge    |
      | KOPPELPROD | 4   | Koppelprodukt | CH_FERT01 |
    And I save the current editor

# Lagerbuchung prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Arbeitsschein1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | buart  | detursache            | ncharge | !row |
      | KOPPELPROD | 4    | Zugang | Rückmeldung Fertigung | 1       | 2    |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPZUS_000"
    And I set field "mgr" to "101"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "manrest" to "ja"
    And I save the current editor
