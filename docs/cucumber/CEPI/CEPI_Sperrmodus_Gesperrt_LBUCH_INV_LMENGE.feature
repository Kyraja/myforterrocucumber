@persistent
Feature: CEPI_Sperrmodus_Gesperrt_LBUCH_INV_LMENGE.feature

  Background:
    And I set the operation language to "DEUTSCH"

# *****************************************************************************
#  Name             : CEPI_Sperrmodus_Gesperrt_LBUCH_INV_LMENGE
#  Autor            : lschneider
#  Verantwortlich   : bheim
#  Kontrolle        : bschiga
#  Jira-Issue       : FDA-1307
#  Funktion         : Testet das Verhalten gesperrter Artikel in Lagerbuchungen,
#                     Inventur und Bestandskorrektur
#
# *****************************************************************************

  Scenario: 01 Lagerbuchung Abgang kann für Artikel mit Sperrkonfiguration Hinweis gebucht werden

    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel | EK-HINWEIS |
      | buart   | Abgang     |
      | beleg   | L01        |
      | beldat  | .          |
    And I set field "mge" to "10" in row 1
    And I save the current editor

    And I open the infosystem "LJ"
    And I set fields
      | adatum   | .         |
      | beleg    | L01       |
      | richtung | rückwärts |
      | kursache | erfasst   |
    And I press start
    Then field "art" has value "EK-HINWEIS" in row 1
    And I close the current editor


  Scenario Outline: 02 Lagerbuchung Abgang und Zugang kann für Artikel mit Sperrkonfiguration Gesperrt nicht gebucht werden

    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set field "buart" to "<buart>"
# 4806 de |Objekt ist gesperrt.
	And setting field "artikel" to "EK-GESPERRT" in row 1 throws the exception "6640"
    And I close the current editor
    Examples:
      | buart  |
      | Abgang |
      | Zugang |


  Scenario: 03 Lagerbuchung Umbuchen kann für Artikel mit Sperrkonfiguration Gesperrt gebucht werden

    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel | EK-GESPERRT |
      | buart   | Umbuchung   |
      | beleg   | L03         |
      | beldat  | .           |
    And I modify table
      | !row | mge | platz2 | platz |
      | 1    | 10  | F1     | F2    |
    And I save the current editor

    And I open the infosystem "LJ"
    And I set fields
      | adatum   | .         |
      | beleg    | L03       |
      | richtung | rückwärts |
      | kursache | erfasst   |
    And I press start
    Then field "art" has value "EK-GESPERRT" in row 1
    And I close the current editor


  Scenario: 04 Inventur Zählliste, Bestandsabschluss, Inventurabschluss für Artikel mit Sperrkonfiguration Gesperrt durchführbar

# Switch-Artikel Sperrkonfiguration leer
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Lagerzugang buchen
    Given I post a receipt via ManualStockAdjustment for Product "EK-SWITCH" and quantity "15" on StorageLocation "F1" with document "L04" and price ""

# Switch-Artikel Sperrkonfiguration Gesperrt
    And I switch the current editor to editor "EK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Inventur Zählliste mit gesperrtem Artikel erstellen
    Given I open an editor "Zaehlliste" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
    And I set field "such" to "ZAEHL_SPERRE"
    And I append rows
      | artikel   | platz |
      | EK-SWITCH | F1    |
    And I save the current editor

# Inventur eröffnen
    Given I open an editor "Invstart" from table "(Stocktaking)" with command "RELEASE" for record "ZAEHL_SPERRE" and menu choice "Ja"
    And I save the current editor

# Zählliste mit gesperrtem Artikel bearbeiten
    Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL_SPERRE"
    And I set field "nbest" to "20" in row 1
    And I append rows
      | artikel   | platz | gebeinh | gebf | bpr | nbest | verw   |
      | EK-SWITCH | F2    | Stück   | 1    | 7   | 5     | SWITCH |
    And I save the current editor

# Bestandsabschluss einer Zählliste mit gesperrtem Artikel
    Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ZAEHL_SPERRE" and menu choice "Ja"
    And I save the current editor

# Inventurabschluss einer Zählliste mit gesperrtem Artikel
    Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "ZAEHL_SPERRE" and menu choice "Ja"
    And I save the current editor


  Scenario: 05 Bestandskorrektur für Artikel mit Sperrkonfiguration Gesperrt kann gebucht werden

# Switch-Artikel Sperrkonfiguration leer
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Lagerbuchung
    Given I post a receipt via ManualStockAdjustment for Product "EK-SWITCH" and quantity "15" on StorageLocation "F1" with document "L05" and price ""

# Switch-Artikel Sperrkonfiguration Gesperrt
    And I switch the current editor to editor "EK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Bestandskorrektur
    Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
    And I set fields
      | artikel | EK-SWITCH |
      | beleg   | K_05      |
      | beldat  | .         |
    And I modify table
      | !row | platz | mge |
      | 1    | F1    | 5   |
    And I save the current editor

## Korrektur prüfen
    And I open the infosystem "LJ"
    And I set fields
      | adatum   | .         |
      | beleg    | K_05      |
      | artikel  | EK-SWITCH |
      | lplatz   | F1        |
      | richtung | rückwärts |
    And I press start
    Then table has values
      | buart     | ursache | detursache                 |
      | Korrektur | erfasst | Manuelle Bestandskorrektur |
    And I close the current editor


