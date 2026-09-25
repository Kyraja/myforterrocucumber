@persistent
Feature: CEPI_Sperrmodus_Gesperrt_VERKAUF.feature

  Background:
    Given I set the fake date to "03.02.1995"
    Given I set the operation language to "DEUTSCH"

# ********************************************************************************
#  Name             : CEPI_Sperrmodus_Gesperrt_VERKAUF
#  Autor            : lschneider
#  Verantwortlich   : bheim
#  Kontrolle        : bschiga
#  Jira-Issue       : FDA-1300
#  Funktion         : Testet das Verhalten gesperrter Artikel und Zusatzpositionen
#                     im Verkauf
#
# ********************************************************************************

  Scenario Outline: 01 Artikel und Zusatzpostion mit Sperrkonfiguration Gesperrt koennen in neuer Chance, Rahmenauftrag, Webauftrag, Angebot verwendet werden

    Given I open an editor "<editor>" from table "<table>" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I append rows
      | artikel         |
      | VK-GESPERRT     |
      | ZUSATZ-GESPERRT |
    And I close the current editor

    Examples:
      | editor        | table                  |
      | Chance        | (Sales):(Opportunity)  |
      | Rahmenauftrag | (Sales):(BlanketOrder) |
      | Webauftrag    | (Sales):(WebOrder)     |
      | Angebot       | (Sales):(Quotation)    |


  Scenario Outline: 02 Artikel und Zusatzpositon mit Sperrkonfiguration Gesperrt koennen in neuem Lieferschein, Rechnung nicht verwendet werden

    Given I open an editor "<editor>" from table "<table>" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I create a new row at the end of the table
# 4806 de |Objekt ist gesperrt.
    Then setting field "artikel" to "VK-GESPERRT" in row 1 throws the exception "1361"
    # Then setting field "artikel" to "ZUSATZ-GESPERRT" in row 1 throws the exception "1361"
    Then field "artikel" is empty in row 1
    And I close the current editor

    Examples:
      | editor       | table                 |
      | Lieferschein | (Sales):(PackingSlip) |
      | Rechnung     | (Sales):(Invoice)     |


  Scenario: 03 Im Auftrag ist das Feld einplan schreibgeschuetzt, wenn Artikel gesperrt wurde

# SWITCH-Artikel leere Sperre
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Auftrag ohne einplan
    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I delete all rows
    And I append rows
      | artikel   | mge | einplan |
      | VK-SWITCH | 10  | nein    |
    And I save the current editor

# SWITCH-Artikel sperren
    And I switch the current editor to editor "VK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# einplan in Auftrag schreibgeschuetzt, Auftrag stornieren
    And I switch the current editor to editor "Auftrag" with command "UPDATE"
    Then field "einplan" is not modifiable in row 1
# Wollen Sie diese Position wirklich stornieren?
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario Outline: 04 Bei Freigabe eines Vorgangs zum Auftrag werden gesperrte Artikel und Zusatzpositionen nicht uebernommen, Tabelle ist leer

# SWITCH-Artikel leere Sperre
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Chance anlegen
    Given I open an editor "<vorgang>" from table "<table_vorgang>" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# SWITCH-Artikel sperren
    And I switch the current editor to editor "VK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# Angebot aus Chance buchen
    Given I open an editor "<vorgang_freigeben>" from table "<table_freigeben>" with command "RELEASE" for record from editor "<vorgang>"
    Then the table has 2 rows
    And I close the current editor

    Examples:
      | vorgang       | table_vorgang          | vorgang_freigeben  | table_freigeben        |
      | Angebot       | (Sales):(Quotation)    | Auftrag_Angebot    | (Sales):(Quotation)    |
      | Rahmenauftrag | (Sales):(BlanketOrder) | Auftrag_Rahmen     | (Sales):(BlanketOrder) |
      | Webauftrag    | (Sales):(WebOrder)     | Auftrag_Webauftrag | (Sales):(WebOrder)     |


  Scenario Outline: 05 Beim Anfuegen einer Position mit gesperrtem Artikel und Zusatzposition im Auftrag, werden diese nicht uebernommen, Tabelle ist leer

# SWITCH-Artikel leere Sperre
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Chance anlegen
    Given I open an editor "<vorgang>" from table "<table>" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# SWITCH-Artikel sperren
    And I switch the current editor to editor "VK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# im Angebot Beleg Chance anfuegen: gesperrter Artikel und Zusatzposition werden nicht uebernommen
    Given I open an editor "<vorgang2>" from table "<table2>" with command "NEW" for record ""
    And I set field "beleg" to "nummer" from editor "<vorgang>"
    Then the table has 2 rows
    And I close the current editor

    Examples:
      | vorgang       | table                  | vorgang2 | table2               |
      | Angebot       | (Sales):(Quotation)    | Auftrag  | (Sales):(SalesOrder) |
      | Rahmenauftrag | (Sales):(BlanketOrder) | Auftrag  | (Sales):(SalesOrder) |
      | Webauftrag    | (Sales):(WebOrder)     | Auftrag  | (Sales):(SalesOrder) |


  Scenario: 06 Lieferschein aus Auftrag uebernimmt keine gesperrten Artikel und Zusatzpositionen

# SWITCH-Artikel leere Sperre
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Auftrag anlegen
    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 20  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# SWITCH-Artikel sperren
    And I switch the current editor to editor "VK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# Lieferschein aus Auftrag buchen, enthaelt nur 1 Zeile mit dem nicht gesperrten Artikel
    Given I open an editor "ausAuftrag" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag"
    Then the table has 3 rows
    Then field "artikel^such" has value "VK-OHNESPERRE" in row 2
    And I set field "vom" to "."
    And I set field "mge" to "10" in row 2
    And I delete row at position 3
    And I delete row at position 1
    And I set field "ueb" to "ja"
    And I save the current editor


  Scenario: 07 Artikel und Zusatzposition werden ueber Beleg anfuegen nicht in den Lieferschein uebernommen, wenn sie gesperrt wurden

# SWITCH-Artikel leere Sperre
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Auftrag anlegen
    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# SWITCH-Artikel sperren
    And I switch the current editor to editor "VK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# im Lieferschein Beleg Auftrag anfuegen enthaelt keine Positionen
    Given I open an editor "Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
    And I set field "beleg" to id from editor "Auftrag"
    And the table has 2 rows
    And I close the current editor


  Scenario: 08 Artikel und Zsatzposition werden aus einem Auftrag nicht in eine Rechnung uebernommen, wenn sie gesperrt wurden

# SWITCH-Artikel Objektstaus leer
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Auftrag anlegen
    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | PFISCHER |
      | vom   | .        |
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# SWITCH-Artikel Sperrkonfiguration Gesperrt
    And I switch the current editor to editor "VK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# Rechnung aus Auftrag buchen, nur 1 Position mit dem nicht gesperrten Artikel wird uebernommen
    Given I open an editor "Auftrag_Rechnung" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "Auftrag"
    Then the table has 3 rows
    Then table has values
      | artikel^such  | ofmge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I set field "mge" to "10" in row 2
    And I set field "vom" to "."
    And I set field "ueb" to "ja"
    And I delete row at position 3
    And I delete row at position 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor


  Scenario: 09 Artikel und Zusatzposition werden aus einem Lieferschein in eine Rechnung uebernommen, auch wenn sie gesperrt wurden

# SWITCH-Artikel Objektstaus leer
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Lieferschein anlegen und buchen
    Given I open an editor "Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | kunde | PFISCHER |
      | ueb   | ja       |
      | vom   | .        |
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# SWITCH-Artikel Sperrkonfiguration Gesperrt
    And I switch the current editor to editor "VK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# Rechnung aus Lieferschein buchen
    And I switch the current editor to editor "Lieferschein" with command "INVOICE"
    Then the table has 3 rows
    Then table has values
      | artikel^such  | mge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I set field "vom" to "."
    And I set field "ueb" to "ja"
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor


  Scenario: 10 Artikel und Zusatzposition aus Auftrag werden ueber Beleg anfuegen nicht in eine Rechnung uebernommen, wenn sie gesperrt wurden

# SWITCH-Artikel leere Sperre
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Auftrag anlegen
    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | PFISCHER |
      | vom   | .        |
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# SWITCH-Artikel sperren
    And I switch the current editor to editor "VK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# in Rechnung Beleg des Auftrags anfuegen enthaelt nur 1 Position mit nicht gesperrtem Artikel
    Given I open an editor "Rechnung_Auftrag" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "beleg" to id from editor "Auftrag"
    And the table has 3 rows
    Then table has values
      | artikel^such  | ofmge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I set field "mge" to "10" in row 2
    And I set field "ueb" to "ja"
    And I set field "vom" to "."
    And I delete row at position 3
    And I delete row at position 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor


  Scenario: 11 Artikel und Zusatzposition aus Lieferschein werden ueber Beleg anfuegen in eine Rechnung uebernommen, auch wenn sie gesperrt wurden

# SWITCH-Artikel leere Sperre
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Lieferschein anlegen
    Given I open an editor "Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | kunde | PFISCHER |
      | ueb   | ja       |
      | vom   | .        |
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# SWITCH-Artikel sperren
    And I switch the current editor to editor "VK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# in Rechnung Beleg des Lieferscheins anfuegen, enthaelt auch gesperrten Artikel und Zusatzposition
    Given I open an editor "Rechnung_Lieferschein" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set field "beleg" to id from editor "Lieferschein"
    And the table has 3 rows
    Then table has values
      | artikel^such  | mge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I set field "ueb" to "ja"
    And I set field "vom" to "."
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor


  Scenario: 12 Ein gesperrter Setartikel kann in einen Auftrag eingetragen werden

# gesperrter Setartikel anlegen
    Given I open an editor "SETSPERR" from table "(Part):(Product)" with command "STORE" for record "SETSPERR"
    And I set fields
      | such                  | SETSPERR               |
      | namebspr              | gesperrter Setartikel  |
      | sperrkonfigurationneu | Standard-Artikelsperre |
      | bsart                 | Eigenfertigung         |
      | earta                 | über Stückliste        |
    And I delete all rows
    And I append rows
      | elex  | elanzahl |
      | MINE  | 1        |
      | FEDER | 1        |
    And I save the current editor

# Auftrag anlegen
    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I create a new row at the end of the table
    And I set field "artikel" to "SETSPERR" in row 1
    Then field "artikel" is not empty in row 1
    And I close the current editor


  Scenario: 13 In der Versandplanung wird ein Artikel mit Sperrkonfiguration Gesperrt nicht uebernommen

# SWITCH-Artikel leere Sperre
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Auftrag anlegen
    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I delete all rows
    And I append rows
      | artikel   | mge | packanw    | fmenge | abruftyp |
      | VK-SWITCH | 100 | PACKOSPERR | 10     | LAB      |
    And I save the current editor

# SWITCH-Artikel sperren
    And I switch the current editor to editor "VK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Versandplanung ueber Selektionskriterien im Kopf, ueber Beleg anfuegen und Zeile
    Given I open an editor "Versandplanung" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
    And I set field "pstermvon" to "."
    And I set field "kabruftyp" to "LAB"
    And I press button "ladetab"
    Then the table has 0 rows
    And I close the current editor

    Given I open an editor "Versandplanung" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
    And I set field "beleganfuegen" to "nummer" from editor "Auftrag"
    Then the table has 0 rows
    And I close the current editor

    Given I open an editor "Versandplanung" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "vkkopf" to "nummer" from editor "Auftrag" in row 1
    Then the table has 0 rows
    And I close the current editor


  Scenario: 14 Ein Artikel in einer Versandplanung kann nicht weiter bearbeitet werden, wenn Artikel gesperrt wurde

# SWITCH-Artikel leere Sperre
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Auftrag anlegen
    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I delete all rows
    And I append rows
      | artikel   | mge | packanw    | fmenge | abruftyp |
      | VK-SWITCH | 100 | PACKOSPERR | 10     | LAB      |
    And I save the current editor

# Versandplanung anlegen
    Given I open an editor "Versandplanung" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
    And I set field "pstermvon" to "."
    And I create a new row at the end of the table
    And I set field "vkkopf" to "nummer" from editor "Auftrag" in row 1
    Then the table has 1 rows
    And I save the current editor

# SWITCH-Artikel sperren
    And I switch the current editor to editor "VK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    And I switch the current editor to editor "Versandplanung" with command "UPDATE"
    # Then field "statusico" has value "icon:blue" in row 1
    Then field "mfreig" has value "nein" in row 1
    Then field "mfreig" is not modifiable in row 1
    And I close the current editor


  Scenario Outline: 15 Abfrage in Auftrag, wenn auf erster Stufe des VK-Teils ein Setartikel mit Sperrkonfiguration Gesperrt eingetragen wird

    Given I open an editor "<editor>" from table "<table>" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I create a new row at the end of the table
    And I set field "artikel" to "BG-K-GESPERRT" in row 1
    Then field "artikel" is not empty in row 1
    And I create a new row at the end of the table
# 2060 de   |Eine der Komponenten des Artikels ist gesperrt und wird nicht beschafft, trotzdem weiter?
    # Given I respond with answer "ja" to the dialog with id "2060"
    And I set field "artikel" to "SET-K-GESPERRT" in row 2
    Then field "artikel" is not empty in row 2
    And I close the current editor

    Examples:
      | editor  | table                |
      | Auftrag | (Sales):(SalesOrder) |


  Scenario Outline: 16 Hinweis in Lieferschein und Rechnung, wenn auf erster Stufe des VK-Teils ein Setartikel mit Sperrkonfiguration Gesperrt eingetragen wird

    Given I open an editor "<editor>" from table "<table>" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I create a new row at the end of the table
    And I set field "artikel" to "BG-K-GESPERRT" in row 1
    Then field "artikel" is not empty in row 1
    And I create a new row at the end of the table
    And I set field "artikel" to "BG-LB-GESPERRT" in row 2
    Then field "artikel" is not empty in row 2
    And I create a new row at the end of the table
# 2049 de   |Eine der Komponenten des Artikels ist gesperrt und wird nicht beschafft.
    # And setting field "artikel" to "SET-K-GESPERRT" in row 3 throws the exception "2049"
    Then field "artikel" is empty in row 3
    And I close the current editor

    Examples:
      | editor       | table                 |
      | Lieferschein | (Sales):(PackingSlip) |
      | Rechnung     | (Sales):(Invoice)     |


  Scenario: 17 Beim Freigeben und Beleg anfuegen einer Chance zu einem Angebot wird der gesperrte Artikel uebernommen

# SWITCH-Artikel leere Sperre
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Chance anlegen
    Given I open an editor "Chance" from table "(Sales):(Opportunity)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I append rows
      | artikel   | mge |
      | VK-SWITCH | 10  |
    And I save the current editor

# SWITCH-Artikel sperren
    And I switch the current editor to editor "VK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# im Angebot Beleg Chance anfuegen: gesperrter Artikel wird nicht uebernommen
    Given I open an editor "Angebot" from table "(Sales):(Quotation)" with command "NEW" for record ""
    And I set field "beleg" to "nummer" from editor "Chance"
    Then the table has 1 rows
    Then table has values
      | artikel^such | mge |
      | VK-SWITCH    | 10  |
    And I close the current editor

# ueber Kommando Release die Chance zu einem Angebot freigeben: Artikel wird uebernommen
    And I switch the current editor to editor "Chance" with command "RELEASE"
    Then the table has 1 rows
    Then table has values
      | artikel^such | mge |
      | VK-SWITCH    | 10  |
    And I close the current editor


  Scenario: 18 Keine Fehlermeldung, wenn gesperrter Artikel in Kundenanlieferung eingetragen wird

# SWITCH-Artikel leere Sperre
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Gesperrten Artikel in Kundenanlieferung eintragen
    Given I open an editor "Auftrag" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | lsart | Kundenanlieferung |
      | kunde | PFISCHER          |
    And I append rows
      | artikel   | mge | platz   |
      | VK-SWITCH | -1  | KONSILP |
    And I save the current editor


  Scenario: 19 Storno Lieferschein moeglich, wenn Artikel und Zusatzposition nach Lieferung gesperrt wurden

# SWITCH-Artikel leere Sperre
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Lieferschein anlegen
    Given I open an editor "Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | kunde | PFISCHER |
      | num3  | 563-PFI  |
      | vom   | .        |
      | ueb   | ja       |
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

# SWITCH-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# Storno Lieferschein wird gebucht
    Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "563-PFI"
    And I set field "num3" to "563-PFIS"
    And I save the current editor


  Scenario: 20 Ruecklieferung Lieferschein, wenn Artikel nach Lieferung gesperrt wurde

# SWITCH-Artikel leere Sperre
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Lieferschein anlegen
    Given I open an editor "Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | kunde | PFISCHER |
      | num3  | 564-PFI  |
      | vom   | .        |
      | ueb   | ja       |
    And I delete all rows
    And I append rows
      | artikel   | mge |
      | VK-SWITCH | 10  |
    And I save the current editor

# SWITCH-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Ruecklieferung Entnahme
    Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "RETURN" for record "564-PFI"
    And I set field "num3" to "564-RLS"
    And I set field "ueb" to "ja"
    And I set field "mge" to "-6" in row 1
    And I save the current editor


  Scenario: 21 Artikel und Zusatzposition mit Sperrkonfiguration Gesperrt koennen in neuem Auftrag verwendet werden, Feld einplan schreibgeschuetzt

    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I create a new row at the end of the table
    And I set field "artikel" to "VK-GESPERRT" in row 1
    Then field "artikel" is not empty in row 1
    And I set field "mge" to "1" in row 1
    Then field "einplan" is not modifiable in row 1
    Then field "einplan" has value "nein" in row 1
    And I create a new row at the end of the table
    And I set field "artikel" to "ZUSATZ-GESPERRT" in row 2
    Then field "artikel" is not empty in row 2
    And I set field "mge" to "1" in row 2
    And I save the current editor
