@persistent
Feature: CEPI_Sperrmodus_Gesperrt_EINKAUF.feature

  Background:
    And I set the fake date to "03.02.1995"
    And I set the operation language to "deutsch"

# *****************************************************************************
#  Name             : CEPI_Sperrmodus_Gesperrt_EINKAUF
#  Autor            : lschneider
#  Verantwortlich   : bheim
#  Kontrolle        : bschiga
#  Jira-Issue       : FDA-1312
#  Funktion         : Testet das Verhalten von Artikeln und Zusatzpositionen 
#                   mit Sperrkonfiguration Gesperrt in Einkausfvorgaengen
#
# *****************************************************************************

  Scenario Outline: 01 Gesperrte Artikel und Zusatzpositionen koennen in neuer Anfrage, Rahmenauftrag eingetragen werden

    Given I open an editor "<editor>" from table "<table>" with command "NEW" for record ""
    And I set field "lief" to "FABER"
    And I append rows
      | artikel         |
      | EK-GESPERRT     |
      | ZUSATZ-GESPERRT |
    And I close the current editor

    Examples:
      | editor        | table                       |
      | Anfrage       | (Purchasing):(Request)      |
      | Rahmenauftrag | (Purchasing):(BlanketOrder) |


  Scenario Outline: 02 Gesperrte Artikel und Zusatzpositionen koennen nicht in neue Bestellung, Lieferschein eingetragen werden

# gesperrten Artikel und Zusatzposition eintragen bringt Fehlermeldung
    Given I open an editor "<editor>" from table "<table>" with command "NEW" for record ""
    And I set field "lief" to "FABER"
    And I create a new row at the end of the table
# 4806 de |Objekt ist gesperrt.
    And setting field "artikel" to "EK-GESPERRT" in row 1 throws the exception "1361"
    And setting field "artikel" to "ZUSATZ-GESPERRT" in row 1 throws the exception "1361"
    Then field "artikel" is empty in row 1
    And I close the current editor

    Examples:
      | editor       | table                        |
      | Bestellung   | (Purchasing):(PurchaseOrder) |
      | Lieferschein | (Purchasing):(PackingSlip)   |
      | Rechnung     | (Purchasing):(Invoice)       |


  Scenario Outline: 03 Gesperrte Artikel und Zusatzpositionen koennen in vorhandener Anfrage, Rahmenauftrag eingetragen werden

# Vorgaenge anlegen
    Given I open an editor "<editor>" from table "<table>" with command "NEW" for record ""
    And I set field "lief" to "FABER"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-OHNESPERRE | 10  |
    And I save the current editor

# gesperrten Artikel und Zusatzposition eintragen, keine Fehlermeldung
    And I switch the current editor to editor "<editor>" with command "UPDATE"
    And I append rows
      | artikel         |
      | EK-GESPERRT     |
      | ZUSATZ-GESPERRT |
    And I close the current editor

    Examples:
      | editor        | table                       |
      | Anfrage       | (Purchasing):(Request)      |
      | Rahmenauftrag | (Purchasing):(BlanketOrder) |


  Scenario Outline: 04 Gesperrte Artikel und Zusatzpositionen koennen nicht in neuer Zeile in vorhandener Bestellung, Lieferschein eingetragen werden

# Vorgang anlegen
    Given I open an editor "<vorgang>" from table "<table>" with command "NEW" for record ""
    And I set fields
      | lief   | FABER  |
      | vom    | .      |
      | ebeleg | EK-V04 |
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-OHNESPERRE | 10  |
    And I save the current editor

# gesperrten Artikel und Zusatzposition eintragen bringt Fehlermeldung
    And I switch the current editor to editor "<vorgang>" with command "UPDATE"
    And I create a new row at the end of the table
# 4806 de |Objekt ist gesperrt.
    And setting field "artikel" to "EK-GESPERRT" in row 2 throws the exception "1361"
    And setting field "artikel" to "ZUSATZ-GESPERRT" in row 2 throws the exception "1361"
    And I close the current editor

    Examples:
      | vorgang      | table                        |
      | Bestellung   | (Purchasing):(PurchaseOrder) |
      | Lieferschein | (Purchasing):(PackingSlip)   |


  Scenario: 05 Gesperrte Artikel und Zusatzpositionen koennen nicht in neuer Zeile in vorhandener Rechnung eingetragen werden

# Vorgang anlegen
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | FABER           |
      | vom    | .               |
      | ebeleg | Fehler Rechnung |
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-OHNESPERRE | 10  |
    And I respond with answer "Ja" to the dialog with id "4841"
    And I save the current editor

# gesperrten Artikel und Zusatzposition eintragen bringt Fehlermeldung
    And I switch the current editor to editor "Rechnung" with command "UPDATE"
    And I create a new row at the end of the table
# 4806 de |Objekt ist gesperrt.
    And setting field "artikel" to "EK-GESPERRT" in row 5 throws the exception "1361"
    And setting field "artikel" to "ZUSATZ-GESPERRT" in row 5 throws the exception "1361"
    And I close the current editor


  Scenario Outline: 06 Gesperrte Artikel und Zusatzpositionen werden bei Bestellung aus Anfrage, Rahmenauftrag nicht uebernommen

# Vorgang Anfrage anlegen
    Given I open an editor "<vorgang>" from table "<table>" with command "NEW" for record ""
    And I set field "lief" to "FABER"
    And I delete all rows
    And I append rows
      | artikel         | mge |
      | EK-OHNESPERRE   | 50  |
      | EK-GESPERRT     | 50  |
      | ZUSATZ-GESPERRT | 1   |
    And I save the current editor

# Bestellung aus Anfrage enthaelt nur 1 Zeile mit dem nicht gesperrten Artikel
    Given I open an editor "<vorgang_freigeben>" from table "<table>" with command "RELEASE" for record from editor "<vorgang>"
    Then the table has 3 rows
    Then table has values
      | artikel         | mge |
      | EK-OHNESPERRE   | 50  |
      | EK-GESPERRT     | 50  |
      | ZUSATZ-GESPERRT | 1   |
    And I delete row at position 3
    And I delete row at position 2
    And I save the current editor

    Examples:
      | vorgang       | table                       | vorgang_freigeben        |
      | Anfrage       | (Purchasing):(Request)      | Bestellung_Anfrage       |
      | Rahmenauftrag | (Purchasing):(BlanketOrder) | Bestellung_Rahmenauftrag |


  Scenario: 07 Artikel und Zusatzposition werden nicht aus der Bestellung in den Lieferschein uebernommen, wenn sie gesperrt wurden

# Switch-Artikel leere Sperre
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang anlegen
    Given I open an editor "Bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set field "lief" to "FABER"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-OHNESPERRE | 10  |
      | EK-SWITCH     | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# Switch-Artikel sperren
    And I switch the current editor to editor "EK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# Lieferschein aus Bestellung, es wird nur 1 Zeile mit nicht gesperrtem Artikel uebernommen
    And I switch the current editor to editor "Bestellung" with command "DELIVERY"
    Then the table has 3 rows
    Then field "artikel" has value "EK-OHNESPERRE" in row 1
    And I set field "mge" to "10" in row 1
    And I delete row at position 3
    And I delete row at position 2
    And I set fields
      | vom    | .                           |
      | ebeleg | LIEFERSCHEIN AUS BESTELLUNG |
      | ueb    | ja                          |
    And I save the current editor


  Scenario: 08 Artikel und Zusatzposition werden aus Bestellung nicht ueber Beleg anfuegen in den Lieferschein uebernommen, wenn sie gesperrt wurden

# Switch-Artikel leere Sperre
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Bestellung anlegen
    Given I open an editor "Bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set field "lief" to "FABER"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-OHNESPERRE | 10  |
      | EK-SWITCH     | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# Switch-Artikel sperren
    And I switch the current editor to editor "EK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# in Lieferschein Beleg "Bestellung" anfuegen, es wird nur 1 Zeile mit nicht gesperrtem Artikel uebernommen
    Given I open an editor "Beleg_Lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
    And I set field "beleg" to "nummer" from editor "Bestellung"
    Then the table has 3 rows
    Then field "artikel" has value "EK-OHNESPERRE" in row 1
    And I set field "mge" to "10" in row 1
    And I delete row at position 3
    And I delete row at position 2
    And I set fields
      | vom    | .                 |
      | ebeleg | Beleg anfuegen 10 |
      | ueb    | ja                |
    And I save the current editor


  Scenario: 09 Artikel und Zusatzposition werden aus Bestellung nicht in Rechnung uebernommen, wenn sie gesperrt wurden

# Switch-Artikel leere Sperre
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Bestellung anlegen
    Given I open an editor "Bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set field "lief" to "FABER"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-OHNESPERRE | 10  |
      | EK-SWITCH     | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# Switch-Artikel sperren
    And I switch the current editor to editor "EK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# Rechnung aus Bestellung, es wird nur 1 Zeile mit nicht gesperrtem Artikel uebernommen
    And I switch the current editor to editor "Bestellung" with command "INVOICE"
    Then the table has 3 rows
    Then field "artikel" has value "EK-OHNESPERRE" in row 1
    And I set field "mge" to "10" in row 1
    And I delete row at position 3
    And I delete row at position 2
    And I set fields
      | vom    | .                          |
      | ebeleg | RECHNUNG AUS BESTELLUNG_09 |
      | ueb    | ja                         |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor


  Scenario: 10 Artikel und Zusatzposition werden aus Bestellung ueber Beleg anfuegen nicht in Rechnung uebernommen, wenn sie gesperrt wurden

# Switch-Artikel leere Sperre
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Bestellung anlegen
    Given I open an editor "Bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set field "lief" to "FABER"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-OHNESPERRE | 10  |
      | EK-SWITCH     | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# Switch-Artikel sperren
    And I switch the current editor to editor "EK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# in Rechnung Beleg "Bestellung" anfuegen, es wird nur 1 Zeile mit nicht gesperrtem Artikel uebernommen
    Given I open an editor "Beleg_Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set field "beleg" to id from editor "Bestellung"
    Then the table has 3 rows
    Then field "artikel" has value "EK-OHNESPERRE" in row 1
    And I set field "mge" to "10" in row 1
    And I delete row at position 3
    And I delete row at position 2
    And I set fields
      | vom    | .                 |
      | ebeleg | RECHNUNG BELEG_10 |
      | ueb    | ja                |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor


  Scenario: 11 Gesperrte Artikel und Zusatzpositionen werden aus Lieferschein in Rechnung uebernommen

# Switch-Artikel leere Sperre
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Lieferschein anlegen
    Given I open an editor "Lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | lief   | FABER             |
      | vom    | .                 |
      | ebeleg | Beleg anfuegen 11 |
      | ueb    | ja                |
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-SWITCH     | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# Switch-Artikel sperren
    And I switch the current editor to editor "EK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# Rechnung aus Lieferschein
    Given I switch the current editor to editor "Lieferschein" with command "INVOICE"
    And I set fields
      | vom    | .                            |
      | ebeleg | RECHNUNG AUS LIEFERSCHEIN_11 |
      | ueb    | ja                           |
    Then field "artikel" has value "EK-SWITCH" in row 1
    And I set field "mge" to "10" in row 1
    Then field "artikel" has value "ZUSATZ-SWITCH" in row 2
    And I set field "mge" to "1" in row 2
    # And I respond with answer "ja" to the dialog with id "4841"
    # And I save the current editor


  Scenario: 12 Gesperrte Artikel und Zusatzpositionen werden ueber Beleg anfuegen aus Lieferschein in Rechnung uebernommen

# Switch-Artikel leere Sperre
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Lieferschein anlegen
    Given I open an editor "Lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | lief   | FABER             |
      | vom    | .                 |
      | ebeleg | Beleg anfuegen 12 |
      | ueb    | ja                |
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-SWITCH     | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# Switch-Artikel sperren
    And I switch the current editor to editor "EK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# Rechnung Beleg Lieferschein einfuegen, enthaelt gesperrten Artikel und gesperrte Zusatzposition
    Given I open an editor "Beleg_Lieferschein" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set field "beleg" to id from editor "Lieferschein"
    And I set fields
      | vom    | .                 |
      | ebeleg | RECHNUNG BELEG_12 |
      | ueb    | ja                |
    Then field "artikel" has value "EK-SWITCH" in row 1
    And I set field "mge" to "10" in row 1
    Then field "artikel" has value "ZUSATZ-SWITCH" in row 2
    And I set field "mge" to "1" in row 2
    # And I respond with answer "ja" to the dialog with id "4841"
    # And I save the current editor


  Scenario: 13 Artikel wird aus Ausschreibung nicht in Bestellung uebernommen, wenn Artikel gesperrt wurde

# Switch-Artikel leere Sperre
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Bestellvorschlag anlegen
    Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "artikel" to "EK-SWITCH" in row 1
    And I set field "mge" to "50" in row 1
    And I save the current editor

# Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Bestellvorschlag anfragen zu Ausschreibung
    Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "EK-SWITCH"
    And I press button "ladetab"
    And I set field "anfragen" to "ja" in row !lastRow
    And I press button "manfragen" to open a subeditor for "Ausschreibung"
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor
    
# Bestellung aus Anfrage: Gesperrter Artikel wird nicht in eine Bestellung uebernommen
    Given I switch the current editor to editor "Ausschreibung" with command "UPDATE"
    And I set field "sel" to "ja" in row 1
    And I press button "bestell" to open a subeditor for "Bestellung" in row 1
    Then the table has 1 rows
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Bestellvorschlag stornieren
    Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "EK-SWITCH"
    And I press button "ladetab"
    And I set field "mge" to "0" in row !lastRow
    And I save the current editor


  Scenario: 14 Bestellvorschlag fuer gesperrten Artikel kann nicht freigegeben werden

# Switch-Artikel leere Sperre
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Bestellvorschlag anlegen
    Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "artikel" to "EK-SWITCH" in row 1
    And I set field "mge" to "50" in row 1
    And I save the current editor

# Switch-Artikel sperren
    And I switch the current editor to editor "EK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Bestellvorschlag freigeben zu Bestellung nicht moeglich
    Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "EK-SWITCH"
    And I press button "ladetab"
    Then field "mfreig" is not modifiable in row !lastRow
    And I set field "mge" to "0" in row !lastRow
    And I save the current editor


  Scenario: 15 Umlagerungsvorschlag fuer gesperrte Artikel kann nicht freigegeben werden

# Switch-Artikel leere Sperre
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Umlagerungsvorschlag anlegen
    Given I open an editor "Umlagerungsvorschlaege" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "artikel" to "EK-SWITCH" in row 1
    And I set field "mge" to "50" in row 1
    And I set field "platz" to "L2F1" in row 1
    And I save the current editor

# Switch-Artikel sperren
    And I switch the current editor to editor "EK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Umlagerungsvorschlag freigeben zu Bestellung
    Given I open an editor "Umlagerungsvorschlaege" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "EK-SWITCH"
    And I press button "ladetab"
    Then field "mfreig" is not modifiable in row !lastRow
    And I set field "mge" to "0" in row !lastRow
    And I save the current editor


  Scenario: 16 Lohnfertigungsvorschlag fuer gesperrte Artikel kann nicht freigegeben werden

    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I delete all rows
    And I append rows
      | artikel     | mge |
      | SWITCH-LOHN | 10  |
    And I save the current editor

    And I run Scheduling

# Lohnfertigung sperren
    Given I open an editor "LOHN-FERT" from table "(Part):(Product)" with command "UPDATE" for record "LOHN-FERT"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Lohnfertigungsvorschlag freigeben ist nicht moeglich
    Given I open an editor "Lohnfertigungsvorschlaege" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "LOHN-FERT"
    And I press button "ladetab"
    Then field "mfreig" is not modifiable in row !lastRow
    And I close the current editor

# Auftrag stornieren um aufzuraeumen
    And I switch the current editor to editor "Auftrag" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


# CEPI-205
  Scenario: 17 Vorhandene unfixierte Bestellvorschlaege werden geloescht, wenn Artikel gesperrt wurde und wieder angelegt, wenn Sperre aufgehoben wird

# Switch-Artikel mit leerer Sperre anlegen
    Given I open an editor "EK-SWITCH2" from table "(Part):(Product)" with command "STORE" for record "EK-SWITCH2"
    And I set fields
      | such                  | EK-SWITCH2       |
      | sperrkonfigurationneu |                  |
      | dispoa                | auftragsbezogen  |
      | bsart                 | Fremdbeschaffung |
    And I save the current editor

    Given I set StorageQuantity to zero for Product "EK-SWITCH2" on StorageLocation "F1" with document "KORR-17"

# Auftrag anlegen damit durch die Dispo ein BV erzeugt wird
    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I delete all rows
    And I append rows
      | artikel    | mge | verw  |
      | EK-SWITCH2 | 10  | VERW1 |
    And I save the current editor

    And I run Scheduling

# Bestellvorschlag vorhanden
    Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "EK-SWITCH2"
    And I press button "ladetab"
    Then the table has more than 1 rows
    And I close the current editor

# Switch-Artikel sperren
    And I switch the current editor to editor "EK-SWITCH2" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    And I run Scheduling

# Bestellvorschlag wurde geloescht
    Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "EK-SWITCH2"
    And I press button "ladetab"
    Then the table has 0 rows
    And I close the current editor

# Switch-Artikel leere Sperre
    And I switch the current editor to editor "EK-SWITCH2" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    And I run Scheduling

# Bestellvorschlag wieder vorhanden
    Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "EK-SWITCH2"
    And I press button "ladetab"
    # Then the table has 0 rows
    Then the table has more than 1 rows
    Then field "mfreig" is modifiable in row 1
    And I close the current editor


# CEPI-205
  Scenario: 18 Vorhandene unfixierte Umlagerungsvorschlaege werden geloescht, wenn Artikel gesperrt wurde

# Umlagerungsartikel leere Sperre anlegen
    Given I open an editor "EK-UMLAGERN" from table "(Part):(Product)" with command "STORE" for record "EK-UMLAGERN"
    And I set fields
      | such                  | EK-UMLAGERN          |
      | namebspr              | Artikel zum Umlagern |
      | sperrkonfigurationneu |                      |
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I delete all rows
    And I modify table
      | lgruppe  | bsart            | umllg     | !row |
      | HONGKONG | Fremdbeschaffung | karlsruhe | +1   |
    And I save the current editor
    And I switch the current editor to editor "EK-UMLAGERN"
    And I set fields
      | bsart | Umlagern |
      | umllg | HONGKONG |
    And I save the current editor

    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I delete all rows
    And I append rows
      | artikel     | mge |
      | EK-UMLAGERN | 10  |
    And I save the current editor

    Given I run Scheduling

# Umlagerungsvorschlag vorhanden
    Given I open an editor "Umlagerungsvorschlaege" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "EK-UMLAGERN"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# Umlagerungsartikel sperren
    And I switch the current editor to editor "EK-UMLAGERN" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Umlagerungsvorschlag kann nicht freigegeben werden
    Given I open an editor "Umlagerungsvorschlaege" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "EK-UMLAGERN"
    And I press button "ladetab"
    Then field "mfreig" is not modifiable in row !lastRow
    And I close the current editor

# Umlagerungsartikel Sperre aufheben
    And I switch the current editor to editor "EK-UMLAGERN" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I run Scheduling

# Umlagerungsvorschlag wurde wieder angelegt
    Given I open an editor "Umlagerungsvorschlaege" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "EK-UMLAGERN"
    And I press button "ladetab"
    Then the table has 1 rows
    Then field "mfreig" is modifiable in row !lastRow
    And I close the current editor

# Auftrag loeschen, um aufzuraeumen
    And I switch the current editor to editor "Auftrag" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 19 Vorhandene unfixierte Lohnfertigungsvorschlaege werden geloescht, wenn Artikel gesperrt wurde und wieder angelegt, wenn Sperre aufgehoben

# Lohnfertigung entsperren
    Given I open an editor "LOHN-FERT" from table "(Part):(Product)" with command "UPDATE" for record "LOHN-FERT"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Auftrag SWITCH-LOHN anlegen
    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I delete all rows
    And I append rows
      | artikel     | mge |
      | SWITCH-LOHN | 10  |
    And I save the current editor

    Given I run Scheduling

# Lohnfertigungsvorschlag vorhanden
    Given I open an editor "Lohnfertigungsvorschlaege" from table "(Purchasing):(SubcontractingSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "LOHN-FERT"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# Lohnfertigung sperren
    Given I open an editor "LOHN-FERT" from table "(Part):(Product)" with command "UPDATE" for record "LOHN-FERT"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Lohnfertigungsvorschlag kann nicht mehr freigegeben werden
    Given I open an editor "Lohnfertigungsvorschlaege" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "LOHN-FERT"
    And I press button "ladetab"
    Then field "mfreig" is not modifiable in row !lastRow
    And I close the current editor

    Given I run Scheduling

# Lohnfertigungsvorschlag wurde geloescht
    Given I open an editor "Lohnfertigungsvorschlaege" from table "(Purchasing):(SubcontractingSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "LOHN-FERT"
    And I press button "ladetab"
    Then the table has 0 rows
    And I close the current editor

# Lohnfertigung leere Sperre
    And I switch the current editor to editor "LOHN-FERT" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I run Scheduling

#  Lohnfertigungsvorschlag wurde wieder angelegt
    Given I open an editor "Lohnfertigungsvorschlaege" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "LOHN-FERT"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# Auftrag stornieren, um aufzuraeumen
    And I switch the current editor to editor "Auftrag" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 20 Vorhandene unfixierte Fertigungsvorschlaege werden geloescht, wenn Artikel gesperrt wurde und wieder angelegt, wenn Sperre aufgehoben wird

# Fertigungs-Artikel anlegen
    Given I open an editor "EK1" from table "(Part):(Product)" with command "STORE" for record "EK1"
    And I set fields
      | such                  | EK1              |
      | sperrkonfigurationneu |                  |
      | dispoa                | bedarfsbezogen   |
      | bsart                 | Fremdbeschaffung |
    And I save the current editor

    Given I open an editor "SWITCH-FERT" from table "(Part):(Product)" with command "STORE" for record "SWITCH-FERT"
    And I set fields
      | such                  | SWITCH-FERT    |
      | sperrkonfigurationneu |                |
      | bsart                 | Eigenfertigung |
      | lief                  | FABER          |
      | efrist                | 2              |
    And I delete all rows
    And I append rows
      | elex       | elanzahl | lge | breite |
      | EK1        | 1        |     |        |
      | A MONTAGE1 |          | 5   | 10     |
    And I save the current editor

# Auftrag SWITCH-FERT anlegen
    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I delete all rows
    And I append rows
      | artikel     | mge | verw   |
      | SWITCH-FERT | 10  | nummer |
    And I save the current editor

    Given I run Scheduling

# Fertigungsvorschlag vorhanden und freigeben ist moeglich; Freigabe nicht durchfuehren
    Given I open an editor "Fertigungsvorschlaege" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "SWITCH-FERT"
    And I press button "ladetab"
    Then the table has 1 rows
    Then field "mfreig" is modifiable in row 1
    And I close the current editor

# Switch-Artikel sperren
    And I switch the current editor to editor "SWITCH-FERT" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Fertigungsvorschlag kann nicht freigegeben werden
    Given I open an editor "Fertigungsvorschlaege" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "SWITCH-FERT"
    And I press button "ladetab"
    Then field "mfreig" is not modifiable in row !lastRow
    And I close the current editor

    Given I run Scheduling

# Fertigungsvorschlag wurde geloescht
    Given I open an editor "Fertigungsvorschlaege" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "SWITCH-FERT"
    And I press button "ladetab"
    Then the table has 0 rows
    And I close the current editor

# Switch-Artikel leere Sperre
    And I switch the current editor to editor "SWITCH-FERT" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I run Scheduling

# Fertigungsvorschlag wurde wieder angelegt
    Given I open an editor "Fertigungsvorschlaege" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "SWITCH-FERT"
    And I press button "ladetab"
    # Then the table has 0 rows
    Then the table has more than 1 rows
    Then field "mfreig" is modifiable in row 1
    And I close the current editor

# Auftrag stornieren, um aufzuraeumen
    And I switch the current editor to editor "Auftrag" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 21 Abfrage in Bestellung, wenn auf erster Stufe des VK-Teils eine Lieferantenbeistellung mit Sperrkonfiguration Gesperrt eingetragen ist

    Given I open an editor "Bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set field "lief" to "1"
    And I create a new row at the end of the table
#    2060 de   |Eine der Komponenten des Artikels ist gesperrt und wird nicht beschafft, trotzdem weiter?
    # Given I respond with answer "ja" to the dialog with id "2060"
    And I set field "artikel" to "BG-LB-GESPERRT" in row 1
    Then field "artikel" is not empty in row 1
    And I close the current editor


  Scenario Outline: 22 Hinweis in Lieferschein und Rechnung, wenn auf erster Stufe des VK-Teils eine Lieferantenbeistellung mit Sperrkonfiguration Gesperrt eingetragen ist

    Given I open an editor "<editor>" from table "<table>" with command "NEW" for record ""
    And I set field "lief" to "1"
    And I create a new row at the end of the table
#    2049 de   |Eine der Komponenten des Artikels ist gesperrt und wird nicht beschafft.
    # And setting field "artikel" to "BG-LB-GESPERRT" in row 1 throws the exception "2049"
    Then field "artikel" is empty in row 1
    And I close the current editor

    Examples:
      | editor       | table                      |
      | Lieferschein | (Purchasing):(PackingSlip) |
      | Rechnung     | (Purchasing):(Invoice)     |


  Scenario: 23 Storno Lieferschein, wenn Artikel und Zusatzposition nach Lieferung gesperrt wurden

# SWITCH-Artikel leere Sperre
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Lieferschein anlegen
    Given I open an editor "Lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | lief | FABER   |
      | num4 | 463-FAB |
      | vom  | .       |
      | ueb  | ja      |
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-SWITCH     | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# SWITCH-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# Storno Lieferschein ist moeglich
    Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "463-FAB"
    And I set field "num4" to "463-S"
    And I save the current editor


  Scenario: 24 Ruecklieferung Lieferschein, wenn Artikel und Zusatzposition nach Lieferung gesperrt wurden

# SWITCH-Artikel leere Sperre
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Lieferschein anlegen
    Given I open an editor "Lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | lief | FABER   |
      | num4 | 464-FAB |
      | vom  | .       |
      | ueb  | ja      |
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-SWITCH     | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# SWITCH-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# Ruecklieferung fuer gesperrten Artikel und gesperrte Zusatzposition kann gebucht werden
    Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "464-FAB"
    And I set fields
      | num4 | 464-RLS |
      | vom  | .       |
      | ueb  | ja      |
    And I set field "mge" to "-6" in row 1
    And I set field "mge" to "-1" in row 2
    And I save the current editor

