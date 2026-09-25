@persistent
Feature: CEPI_Sperrmodus_Gesperrt_DISPO.feature

  Background:
    Given I set the operation language to "DEUTSCH"
    Given I set the fake date to "06.02.1995"

# *****************************************************************************
#  Name             : CEPI_Sperrmodus_Gesperrt_DISPO
#  Autor            : lschneider
#  Verantwortlich   : bheim
#  Kontrolle        : bschiga
#  Funktion         : Testet gesperrte Artikel und Disposition 
#
# *****************************************************************************


  Scenario: 01 Gesperrter Artikel kann nicht in eine AFL eingetragen werden

# Fertigungsvorschlag anlegen
    Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel       | mge | bisuch   | mfreig |
      | VK-OHNESPERRE | 100 | SWITCH03 | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I create a new row at position 1
    And I set field "elex" to "EK-GESPERRT" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor


# Umsetzung in CEPI-205
  Scenario: 02 Kein neuer Beschaffer, wenn Fehlmenge im FV durch nachtraeglich gesperrtes und auf auf Sperrplatz gebuchtes Material entsteht

# SWITCH-Artikel Sperrkonfiguration auf leer
    Given I open an editor "EK-SWITCH_A25" from table "(Part):(Product)" with command "COPY" for record "EK-SWITCH"
    And I set field "such" to "EK-SWITCH_A25"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Baugruppe mit Switch-Artikel
    Given I open an editor "VK-OHNES_A25" from table "(Part):(Product)" with command "COPY" for record "VK-OHNESPERRE"
    And I set field "such" to "VK-OHNES_A25"
    And I modify table
      | !row | elex              | elanzahl |
      | +1   | !EK-SWITCH_A25^id | 1        |
    And I save the current editor

# Lagerzugang EK-SWITCH
    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel | !EK-SWITCH_A25^id |
      | buart   | Zugang            |
      | beleg   | 08                |
      | beldat  | .                 |
    And I set field "mge" to "1" in row 1
    And I set field "verw" to "08_Beschaff" in row 1
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel          | mge | bisuch   | mfreig | verw        |
      | !VK-OHNES_A25^id | 100 | SWITCH08 | ja     | 08_Beschaff |
    And I press button "freig" to open a subeditor for "fertigung"
    And I close the current subeditor to switch back to the parent editor
    And I save the current editor

# Switch-Artikel sperren
    And I switch the current editor to editor "EK-SWITCH_A25" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Lagerbuchung EK-SWITCH auf Sperrlager
    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel | !EK-SWITCH_A25^id |
      | buart   | Umbuchung         |
      | beleg   | 08                |
      | beldat  | .                 |
    And I modify table
      | !row | mge | platz | platz2 | verw        | verw2       |
      | +1   | 1   | F1    | SPERR  | 08_Beschaff | 08_Beschaff |
    And I save the current editor

# Dispo
    Given I run Scheduling

# kein Beschaffgungsvorschlag fuer gesperrten Artikel
    Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "!EK-SWITCH_A25^id"
    And I press button "ladetab"
    Then the table has 0 rows
    And I close the current editor


  Scenario: 03 Fuer einen gesperrten Artikel wird kein neuer Beschaffer angelegt, wenn geplanter Ausschuss ueberschritten wird

# UBG_AUSSCHUSS Sperrkonfiguration leer setzen
    Given I open an editor "UBG-AUSSCHUSS" from table "(Part):(Product)" with command "UPDATE" for record "UBG_AUSSCHUSS"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Auftrag anlegen
    Given I create a SalesOrder "Auftrag" for Customer "PFISCHER" with Product "BG_AUSSCHUSS" and quantity "110"

# Fertigungsvorschlag BG und UBG anlegen und freigeben
    Given I open an editor "fvfreigeben" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel       | mge | bisuch  | mfreig |
      | UBG_AUSSCHUSS | 110 | UBG_AUS | ja     |
      | BG_AUSSCHUSS  | 110 | BG_AUS  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "Auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "Auftrag" in row 1
    And I press button "freig" to open a subeditor for "fertigung"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Komplett-Rueckmeldung UBG_AUSSCHUSS
    Given I open an editor "Arbeitsschein1-UBG" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UBG_AUS001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

# UBG_AUSSCHUSS Sperrkonfiguration Gesperrt setzen
    Given I open an editor "UBG_AUSSCHUSS" from table "(Part):(Product)" with command "UPDATE" for record "UBG_AUSSCHUSS"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Komplett-Rueckmeldung BG_AUSSCHUSS mit hoeherem Dipsoausschuss
    Given I open an editor "Arbeitsschein1-BG" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG_AUS001"
    And I set field "gutmge" to "50" in row 1
    And I set field "verlustmge" to "60" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Dispo starten
    Given I run Scheduling

# kein neuer Fertigungsvorschlag fuer UBG_AUSSCHUSS
    Given I open an editor "fvpruefen" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "UBG_AUSSCHUSS"
    And I press button "ladetab"
    Then the table has 0 rows
    And I set field "artikel" to "BG_AUSSCHUSS"
    And I press button "ladetab"
    Then the table has more than 1 rows
    And I close the current editor

# UBG_AUSSCHUSS Sperrkonfiguration leer setzen
    And I switch the current editor to editor "UBG_AUSSCHUSS" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# CEPI-205
  Scenario: 04 Vorhandener unfixierter Fertigungsvorschlag wird geloescht, wenn Artikel gesperrt wird

# Artikel mit Mindestbestand anlegen
    Given I open an editor "SPERRE_MINDESTB" from table "(Part):(Product)" with command "STORE" for record "SPERRE_MINDESTB"
    And I set fields
      | such                  | SPERRE_MINDESTB            |
      | namebspr              | Artikel mit Mindestbestand |
      | bsart                 | Eigenfertigung             |
      | mindest               | 50                         |
      | sperrkonfigurationneu |                            |
    And I delete all rows
    And I append rows
      | elex       |
      | A MONTAGE1 |
    And I save the current editor

# Dispo starten
    And I run Scheduling

# Fertigungsvorschlag pruefen
    Given I open an editor "fvpruefen" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "SPERRE_MINDESTB"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# Artikel mit Mindestbestand Sperrkonfiguration Gesperrt setzen
    Given I switch the current editor to editor "SPERRE_MINDESTB" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Dispo starten
    And I run Scheduling

# Fertigungsvorschlag pruefen
    Given I open an editor "fvpruefen" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "SPERRE_MINDESTB"
    And I press button "ladetab"
    Then the table has 0 rows
    And I close the current editor

# CEPI-205
  Scenario: 05 Vorhandener fixierter Fertigungsvorschlag kann nicht freigegeben werden, wenn Artikel gesperrt wird

# Artikel mit Mindestbestand anlegen
    Given I open an editor "SPERRE_MINDESTB" from table "(Part):(Product)" with command "STORE" for record "SPERRE_MINDESTB"
    And I set fields
      | such                  | SPERRE_MINDESTB            |
      | namebspr              | Artikel mit Mindestbestand |
      | bsart                 | Eigenfertigung             |
      | mindest               | 50                         |
      | sperrkonfigurationneu |                            |
    And I delete all rows
    And I append rows
      | elex       |
      | A MONTAGE1 |
    And I save the current editor

# Dispo starten
    And I run Scheduling

# Fertigungsvorschlag pruefen
    Given I open an editor "fvpruefen" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "SPERRE_MINDESTB"
    And I press button "ladetab"
    Then the table has 1 rows
    And I modify table
      | !row | fix | mfreig |
      | 1    | ja  | ja     |
    And I save the current editor

# Artikel mit Mindestbestand Sperrkonfiguration Gesperrt setzen
    Given I switch the current editor to editor "SPERRE_MINDESTB" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Dispo starten
    And I run Scheduling

# Fertigungsvorschlag pruefen: mfreig ist leer und schreibgeschuetzt, fix kann bearbeitet werden
    Given I open an editor "fvpruefen" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "SPERRE_MINDESTB"
    And I press button "ladetab"
    Then the table has 1 rows
    Then table has values
      | !row | mfreig | fix |
      | 1    | nein   | ja  |
    Then field "mfreig" is not modifiable in row 1
    Then field "fix" is modifiable in row 1

# FV loeschen
    And I set field "fix" to "nein" in row 1
    And I set field "mge" to "0" in row 1
    And I save the current editor

# CEPI-205
  Scenario: 06 Wird Sperrkonfiguration eines gesperrten Artikel auf leer gesetzt, werden wieder Beschaffungsvorschlaege angelegt

# Artikel mit Mindestbestand aus Scenario 05 -> Sperre entfernen
    Given I open an editor "SPERRE_MINDESTB" from table "(Part):(Product)" with command "UPDATE" for record "SPERRE_MINDESTB"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Dispo starten
    And I run Scheduling

# Fertigungsvorschlag pruefen
    Given I open an editor "fvpruefen" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "SPERRE_MINDESTB"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# Artikel mit Mindestbestand Sperrkonfiguration Gesperrt setzen
    Given I switch the current editor to editor "SPERRE_MINDESTB" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Dispo starten
    And I run Scheduling

# Fertigungsvorschlag pruefen: mfreig ist leer und schreibgeschuetzt, fix kann bearbeitet werden
    Given I open an editor "fvpruefen" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "SPERRE_MINDESTB"
    And I press button "ladetab"
    Then the table has 0 rows
    And I close the current editor

# Artikel mit Mindestbestand Sperrkonfiguration leer setzen
    Given I switch the current editor to editor "SPERRE_MINDESTB" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Dispo starten
    And I run Scheduling

    Given I open an editor "fvpruefen" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "SPERRE_MINDESTB"
    And I press button "ladetab"
    Then the table has 1 rows
    And I set field "mge" to "0" in row 1
    And I save the current editor
