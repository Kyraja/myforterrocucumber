@persistent
Feature: neu_CEPI_Sperrmodus_Gesperrt_EINKAUF.feature

  Background:
    Given I set the fake date to "03.02.1995"
    Given I'm logged in with password "sy"
    Given I set the operation language to "DEUTSCH"

# ********************************************************************************
#  Name             : CEPI_Sperrmodus_Gesperrt_EINKAUF
#  Autor            : lschneider
#  Verantwortlich   : bheim
#  Kontrolle        : bschiga
#  Jira-Issue       : FDA-1300
#  Funktion         : Testet das Verhalten gesperrter Artikel und Zusatzpositionen
#                     im Einkauf
#
# ********************************************************************************

  Scenario: 22 Lieferschein aus Bestellung, parallel dazu Artikel und Zusatzposition sperren, Lieferschein darf nicht gebucht werden

# SWITCH-Artikel leere Sperre
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Bestellung anlegen
    Given I open an editor "Bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set field "lief" to "FABER"
    And I set field "such" to "EKBE22"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-SWITCH     | 10  |
      | EK-OHNESPERRE | 20  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

    Given I'm logged in with password "adm"
    Given I set the fake date to "03.02.1995"

# Lieferschein aus Bestellung erstellen, Editor offen lassen
    Given I open an editor "ausBestellung" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBE22"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge |
      | EK-SWITCH     | 0   |
      | EK-OHNESPERRE | 0   |
      | ZUSATZ-SWITCH | 0   |
    And I modify table
      | !row | mge |
      | 1    | 10  |
      | 2    | 20  |
      | 3    | 1   |
    And I set fields
      | vom    | .     |
      | ebeleg | LS_22 |
# Editor offen lassen

    Given I'm logged in with password "sy"

# SWITCH-Artikel sperren
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# zurueck zum geoffneten Lieferschein, darf nicht gebucht werden
    Given I'm logged in with password "adm"

    And I switch the current editor to editor "ausBestellung" with command "DELIVERY"
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
    Given I'm logged in with password "sy"
    Given I set the fake date to "03.02.1995"

# SWITCH-Artikel leere Sperre
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Bestellung anlegen
    Given I open an editor "Bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set field "lief" to "FABER"
    And I set field "such" to "EKBE23"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-SWITCH     | 10  |
      | EK-OHNESPERRE | 20  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

    Given I'm logged in with password "adm"
    Given I set the fake date to "03.02.1995"

# Lieferschein aus Bestellung erstellem Editor offen lassen
    Given I open an editor "ausBestellung" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBE23"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge |
      | EK-SWITCH     | 0   |
      | EK-OHNESPERRE | 0   |
      | ZUSATZ-SWITCH | 0   |
    And I modify table
      | !row | mge |
      | 1    | 10  |
      | 2    | 20  |
      | 3    | 1   |
    And I set fields
      | vom    | .     |
      | ebeleg | LS_23 |
    And I press button "schreib"
# Editor offen lassen

    Given I'm logged in with password "sy"

# SWITCH-Artikel sperren
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# zurueck zum geoffneten Lieferschein, darf nicht gebucht werden
    Given I'm logged in with password "adm"

    And I switch the current editor to editor "ausBestellung" with command "DELIVERY"
    And I set field "ueb" to "ja"
# 4806 de |Objekt ist gesperrt.
## oder evtl 1361
    Then saving the current editor throws the exception "4806"
# Zeile mit gesperrter Zusatzposition loeschen, laesst sich noch nicht speichern, wegen gesperrtem Artikel
    And I delete row at position 3
    Then saving the current editor throws the exception "4806"
# laesst sich speichern ohne buchen, da bereits zwischengespeichert war
    And I set field "ueb" to "nein"
    And I save the current editor


  Scenario: 24 Rechnung aus Bestellung, parallel dazu Artikel und Zusatzposition sperren, Rechnung darf nicht gebucht werden
    Given I'm logged in with password "sy"
    Given I set the fake date to "03.02.1995"

# SWITCH-Artikel leere Sperre
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Bestellung anlegen
    Given I open an editor "Bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set field "lief" to "FABER"
    And I set field "such" to "EKBE24"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-SWITCH     | 10  |
      | EK-OHNESPERRE | 20  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

    Given I'm logged in with password "adm"
    Given I set the fake date to "03.02.1995"

# Rechnung aus Bestellung erstellem Editor offen lassen
    Given I open an editor "ausBestellung" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "EKBE24"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge |
      | EK-SWITCH     | 0   |
      | EK-OHNESPERRE | 0   |
      | ZUSATZ-SWITCH | 0   |
    And I modify table
      | !row | mge |
      | 1    | 10  |
      | 2    | 20  |
      | 3    | 1   |
    And I set field "fakt" to "ja"
# Editor offen lassen

    Given I'm logged in with password "sy"

# SWITCH-Artikel sperren
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# zurueck zur geoffneten Rechnung, darf nicht gebucht werden
    Given I'm logged in with password "adm"

    And I switch the current editor to editor "ausBestellung" with command "INVOICE"
    And I set fields
      | vom    | .     |
      | ebeleg | RE_24 |
      | ueb    | ja    |
# 4806 de |Objekt ist gesperrt.
## oder evtl 1361
    And I set field "budat" to "."
    And I set field "tterm" to "+10"
    And I set field "vom" to "."
    And I set field "ueb" to "ja"
    Then saving the current editor throws the exception "4806"
# Zeile mit gesperrter Zusatzposition loeschen, laesst sich noch nicht speichern, wegen gesperrtem Artikel
    And I delete row at position 3
    Then saving the current editor throws the exception "4806"
# laesst sich auch nicht speichern ohne buchen
    And I set field "ueb" to "nein"
    And I delete row at position 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor


  Scenario: 25 wie Szenario 24 aber Rechnung zwischenspeichern
    Given I'm logged in with password "sy"
    Given I set the fake date to "03.02.1995"

# SWITCH-Artikel leere Sperre
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Vorgang Bestellung anlegen
    Given I open an editor "Bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set field "lief" to "FABER"
    And I set field "such" to "EKBE25"
    And I delete all rows
    And I append rows
      | artikel       | mge |
      | EK-SWITCH     | 10  |
      | EK-OHNESPERRE | 20  |
      | ZUSATZ-SWITCH | 1   |
    And I save the current editor

    Given I'm logged in with password "adm"
    Given I set the fake date to "03.02.1995"

# Rechnung aus Bestellung erstellem Editor offen lassen
    Given I open an editor "ausBestellung" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "EKBE25"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge |
      | EK-SWITCH     | 0   |
      | EK-OHNESPERRE | 0   |
      | ZUSATZ-SWITCH | 0   |
    And I modify table
      | !row | mge |
      | 1    | 10  |
      | 2    | 20  |
      | 3    | 1   |
    And I set fields
      | vom    | .     |
      | ebeleg | RE_25 |
      | fakt   | ja    |
    And I respond with answer "ja" to the dialog with id "4841"
    And I press button "schreib"
# Editor offen lassen

    Given I'm logged in with password "sy"

# SWITCH-Artikel sperren
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

    Given I open an editor "ZUSATZ-SWITCH" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Zusatzpositionssperre"
    And I save the current editor

# zurueck zur geoffneten Rechnung, darf nicht gebucht werden
    Given I'm logged in with password "adm"

    And I switch the current editor to editor "ausBestellung" with command "INVOICE"
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
# laesst sich dann speichern ohne buchen
    And I set field "ueb" to "nein"
    And I save the current editor
