@persistent
Feature: CEPI_Sperrmodus_Gesperrt_VERKAUF.feature

  Background:
    Given I set the fake date to "03.02.1995"
    Given I'm logged in with password "sy"
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

  Scenario: 22 Lieferschein aus Auftrag, parallel dazu Artikel und Zusatzposition sperren, Lieferschein darf nicht gebucht werden

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
    And I set field "such" to "AUF22"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 20  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

    Given I'm logged in with password "adm"

# Lieferschein aus Auftrag erstellem Editor offen lassen
    Given I open an editor "ausAuftrag" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AUF22"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge |
      | VK-SWITCH     | 0   |
      | VK-OHNESPERRE | 0   |
      | ZUSATZ-SWITCH | 0   |
    And I modify table
      | !row | mge |
      | 1    | 10  |
      | 2    | 20  |
      | 3    | 1   |
# Editor offen lassen

    Given I'm logged in with password "sy"
#Given I set the fake date to "03.02.1995"

# SWITCH-Artikel sperren
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# zurueck zum geoffneten Lieferschein, darf nicht gebucht werden
    Given I'm logged in with password "adm"
#Given I set the fake date to "03.02.1995"

    And I switch the current editor to editor "ausAuftrag" with command "DELIVERY"
    And I set field "vom" to "."
    And I set field "ueb" to "ja"
# 4806 de |Objekt ist gesperrt.
## oder evtl 1361
    Then saving the current editor throws the exception "4806"
# Zeile mit gesperrter Zusatzposition loeschen, laesst sich noch nicht speichern, wegen gesperrtem Artikel
    And I delete row at position 3
    Then saving the current editor throws the exception "4806"
# laesst sich auch nicht speichern ohne buchen
    And I set field "ueb" to "nein"
    Then saving the current editor throws the exception "4806"
    And I close the current editor


  Scenario: 23 wie Szenario 22 aber Lieferschein zwischenspeichern

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
    And I set field "such" to "AUF23"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 20  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

    Given I'm logged in with password "adm"

# Lieferschein aus Auftrag erstellem Editor offen lassen
    Given I open an editor "ausAuftrag" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AUF23"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge |
      | VK-SWITCH     | 0   |
      | VK-OHNESPERRE | 0   |
      | ZUSATZ-SWITCH | 0   |
    And I modify table
      | !row | mge |
      | 1    | 10  |
      | 2    | 20  |
      | 3    | 1   |
    And I press button "schreib"
# Editor offen lassen

    Given I'm logged in with password "sy"
#Given I set the fake date to "03.02.1995"

# SWITCH-Artikel sperren
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# zurueck zum geoffneten Lieferschein, darf nicht gebucht werden
    Given I'm logged in with password "adm"
#Given I set the fake date to "03.02.1995"

    And I switch the current editor to editor "ausAuftrag" with command "DELIVERY"
    And I set field "vom" to "."
    And I set field "ueb" to "ja"
# 4806 de |Objekt ist gesperrt.
## oder evtl 1361
    Then saving the current editor throws the exception "4806"
# Zeile mit gesperrter Zusatzposition loeschen, laesst sich noch nicht speichern, wegen gesperrtem Artikel
    And I delete row at position 3
    Then saving the current editor throws the exception "4806"
# laesst sich auch nicht speichern ohne buchen
    And I set field "ueb" to "nein"
# Then saving the current editor throws the exception "4806"
    And I save the current editor

  Scenario: 24 Rechnung mit Lagerbewegung aus Auftrag, parallel dazu Artikel und Zusatzposition sperren, Rechnung darf nicht gebucht werden

    Given I'm logged in with password "sy"
    Given I set the fake date to "03.02.1995"

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
    And I set field "such" to "AUF24"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 20  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

    Given I'm logged in with password "adm"
    Given I set the fake date to "03.02.1995"

# Lieferschein aus Auftrag erstellem Editor offen lassen
    Given I open an editor "ausAuftrag" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "AUF24"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge |
      | VK-SWITCH     | 0   |
      | VK-OHNESPERRE | 0   |
      | ZUSATZ-SWITCH | 0   |
    And I modify table
      | !row | mge |
      | 1    | 10  |
      | 2    | 20  |
      | 3    | 1   |
# Editor offen lassen

    Given I'm logged in with password "sy"

# SWITCH-Artikel sperren
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# zurueck zum geoffneten Lieferschein, darf nicht gebucht werden
    Given I'm logged in with password "adm"

    And I switch the current editor to editor "ausAuftrag" with command "INVOICE"
    And I set field "fakt" to "ja"
    And I set field "budat" to "."
    And I set field "tterm" to "+10"
    And I set field "vom" to "."
    And I set field "ueb" to "ja"
# 4806 de |Objekt ist gesperrt.
## oder evtl 1361
    # And I respond with answer "ja" to the dialog with id "4841"
    # And I save the current editor
    Then saving the current editor throws the exception "4806"
# Zeile mit gesperrter Zusatzposition loeschen, laesst sich noch nicht speichern, wegen gesperrtem Artikel
    And I delete row at position 3
    Then saving the current editor throws the exception "4806"
# laesst sich auch nicht speichern ohne buchen
    And I set field "ueb" to "nein"
    Then saving the current editor throws the exception "4806"


  Scenario: 25 wie Szenario 24 aber Rechnung zwischenspeichern
    Given I'm logged in with password "sy"
    Given I set the fake date to "03.02.1995"

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
    And I set field "such" to "AUF25"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 20  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

    Given I'm logged in with password "adm"
    Given I set the fake date to "03.02.1995"

# Lieferschein aus Auftrag erstellem Editor offen lassen
    Given I open an editor "ausAuftrag" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "AUF25"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge |
      | VK-SWITCH     | 0   |
      | VK-OHNESPERRE | 0   |
      | ZUSATZ-SWITCH | 0   |
    And I modify table
      | !row | mge |
      | 1    | 10  |
      | 2    | 20  |
    And I set field "fakt" to "ja"
    And I respond with answer "ja" to the dialog with id "4841"
    And I press button "schreib"
# Editor offen lassen

    Given I'm logged in with password "sy"

# SWITCH-Artikel sperren
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# zurueck zum geoffneten Lieferschein, darf nicht gebucht werden
    Given I'm logged in with password "adm"

    And I switch the current editor to editor "ausAuftrag" with command "INVOICE"
    And I set field "budat" to "."
    And I set field "tterm" to "+10"
    And I set field "vom" to "."
    And I set field "ueb" to "ja"
# 4806 de |Objekt ist gesperrt.
## oder evtl 1361
    Then saving the current editor throws the exception "4806"
# Zeile mit gesperrter Zusatzposition loeschen, laesst sich noch nicht speichern, wegen gesperrtem Artikel
    And I delete row at position 3
    Then saving the current editor throws the exception "4806"
# laesst sich auch nicht speichern ohne buchen
    And I set field "ueb" to "nein"
# Then saving the current editor throws the exception "4806"
    And I save the current editor


  Scenario: 26 Rechnung ohne Lagerbewegung aus Auftrag, parallel dazu Artikel und Zusatzposition sperren, Rechnung darf gebucht werden
    Given I'm logged in with password "sy"
    Given I set the fake date to "03.02.1995"

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
    And I set field "such" to "AUF26"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 20  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

    Given I'm logged in with password "adm"
    Given I set the fake date to "03.02.1995"

# Lieferschein aus Auftrag erstellem Editor offen lassen
    Given I open an editor "ausAuftrag" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "AUF26"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge |
      | VK-SWITCH     | 0   |
      | VK-OHNESPERRE | 0   |
      | ZUSATZ-SWITCH | 0   |
    And I modify table
      | !row | mge |
      | 1    | 10  |
      | 2    | 20  |
      | 3    | 1   |
# Editor offen lassen

    Given I'm logged in with password "sy"

# SWITCH-Artikel sperren
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# zurueck zum geoffneten Lieferschein, darf nicht gebucht werden
    Given I'm logged in with password "adm"

    And I switch the current editor to editor "ausAuftrag" with command "INVOICE"
    And I set field "budat" to "."
    And I set field "tterm" to "+10"
    And I set field "vom" to "."
    And I set field "ueb" to "ja"
    And I set field "fakt" to "nein"
	Then saving the current editor throws the exception "4806"
    And I delete row at position 3
    And I delete row at position 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor


  Scenario: 27 wie Szenario 26 aber Rechnung zwischenspeichern
    Given I'm logged in with password "sy"
    Given I set the fake date to "03.02.1995"

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
    And I set field "such" to "AUF27"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | VK-SWITCH     | 10  |
      | VK-OHNESPERRE | 20  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

    Given I'm logged in with password "adm"
    Given I set the fake date to "03.02.1995"

# Lieferschein aus Auftrag erstellem Editor offen lassen
    Given I open an editor "ausAuftrag" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "AUF27"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge |
      | VK-SWITCH     | 0   |
      | VK-OHNESPERRE | 0   |
      | ZUSATZ-SWITCH | 0   |
    And I modify table
      | !row | mge |
      | 1    | 10  |
      | 2    | 20  |
      | 3    | 1   |
    And I set field "fakt" to "nein"
    And I respond with answer "ja" to the dialog with id "4841"
    And I press button "schreib"
# Editor offen lassen

    Given I'm logged in with password "sy"

# SWITCH-Artikel sperren
    Given I open an editor "VK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# zurueck zum geoffneten Lieferschein, darf nicht gebucht werden
    Given I'm logged in with password "adm"

    And I switch the current editor to editor "ausAuftrag" with command "INVOICE"
    And I set field "budat" to "."
    And I set field "tterm" to "+10"
    And I set field "vom" to "."
    And I set field "ueb" to "ja"
    And I save the current editor

  Scenario: 28 Gesperrte Artikel und Zusatzpositionen koennen nicht in neuer Zeile in vorhandenem Lieferschein eingetragen werden

# Vorgang anlegen
    Given I open an editor "Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | kunde | PFISCHER |
      | vom   | .        |
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | VK-OHNESPERRE | 10  |
    And I save the current editor

# gesperrten Artikel und Zusatzposition eintragen bringt Fehlermeldung
    And I switch the current editor to editor "Lieferschein" with command "UPDATE"
    And I create a new row at the end of the table
# 4806 de |Objekt ist gesperrt.
    Then setting field "artikel" to "VK-GESPERRT" in row !lastRow throws the exception "1361"
    # Then setting field "artikel" to "ZUSATZ-GESPERRT" in row 2 throws the exception "1361"
    And I close the current editor


  Scenario: 29 Gesperrte Artikel und Zusatzpositionen koennen nicht in neuer Zeile in vorhandener Rechnung eingetragen werden

# Vorgang anlegen
    Given I open an editor "Rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
    And I set fields
      | kunde | PFISCHER |
      | vom   | .        |
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | VK-OHNESPERRE | 10  |
    And I respond with answer "Ja" to the dialog with id "4841"
    And I save the current editor

# gesperrten Artikel und Zusatzposition eintragen bringt Fehlermeldung
    And I switch the current editor to editor "Rechnung" with command "UPDATE"
    And I create a new row at the end of the table
# 4806 de |Objekt ist gesperrt.
    Then setting field "artikel" to "VK-GESPERRT" in row !lastRow throws the exception "1361"
    # Then setting field "artikel" to "ZUSATZ-GESPERRT" in row 2 throws the exception "1361"
    And I close the current editor

