# *****************************************************************************
#  Name             : CEPI_Sperrmodus_Gesperrt_FERTIGUNG
#  Autor            : amk
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Jira-Issue       : FDA-1269
#  Funktion         : Testet das Erfassen, Ändern, Freigeben, Buchen, Stornieren
#                     von Fertigungsvorschlägen bzw. Rückmeldungen/Rückbauten mit
#                     gesperrtem Artikel Fertigteil oder gesperrten Komponeten in
#                     der AFL.
#
# *****************************************************************************
@persistent
Feature: CEPI_Sperrmodus_Gesperrt_FERTIGUNG.feature

  Background:
    And I enable the flag 42
    And I set the fake date to "13.02.1995"

    
#----------------------------------------------------------------------------------------------------------#
#------------------------------------- Tests mit gesperrtem Fertigteil ------------------------------------#

  Scenario: Bedarfe für Scenarios EF01-RAKRB01 manuell zubuchen
# EK-SWITCH auf ohne Sperre setzen
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Bedarfe zubuchen
    Given I post a receipt via ManualStockAdjustment for Product "MINE" and quantity "200" on StorageLocation "F1" with document "EF_RAKRB" and price ""
    Given I post a receipt via ManualStockAdjustment for Product "FEDER" and quantity "200" on StorageLocation "F1" with document "EF_RAKRB" and price ""
    Given I post a receipt via ManualStockAdjustment for Product "GRIFFROHR" and quantity "200" on StorageLocation "F1" with document "EF_RAKRB" and price ""
    Given I post a receipt via ManualStockAdjustment for Product "VORSCHUB" and quantity "100" on StorageLocation "F1" with document "EF_RAKRB" and price ""
    Given I post a receipt via ManualStockAdjustment for Product "EK-SWITCH" and quantity "100" on StorageLocation "F1" with document "EF_RAKRB" and price ""
    Given I post a receipt via ManualStockAdjustment for Product "EK-OHNESPERRE" and quantity "100" on StorageLocation "F1" with document "EF_RAKRB" and price ""


############### Szenarien: Fertigungsvorschlag mit gesperrtem Fertigteil erfassen ###############

  Scenario: EF01 - Gesperrten Artikel in neuen Fertigungsvorschlag eintragen
    And I set the fake date to "13.02.1995"
# Erwartetes Ergebnis: Fehlermeldung
    Given I open an editor "fvneu_EF01" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
# 4806 de |Objekt ist gesperrt.
    Then setting field "artikel" to "BG-GESPERRT" in row !lastRow throws the exception "1361"
    And I close the current editor

############### Szenarien: Fertigungsvorschlag mit gesperrtem Fertigteil kann nicht freigegeben werden ###############

  Scenario: EF02 - Angelegter Fertigungsvorschlag kann nicht freigegeben werden, wenn Artikel gesperrt wurde

    And I set the fake date to "13.02.1995"

# Switch-Artikel entsperren, FV anlegen, Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "fvneu_EF02" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig |
      | BG-SWITCH | 11     | nein   |
    And I save the current editor

    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Freigabe Fertigungsvorschlag nicht moeglich, mfreig ist nein und schreibgeschützt
    Given I open an editor "Freigabe_FV_EF02" from table "(Purchasing):(WorkOrderSuggestions)" with command "RELEASE" for record ""
    And I set field "artikel" to "BG-SWITCH"
    And I press button "ladetab"
    Then the table has 0 rows
    And I close the current editor

# Infosystem PRODLIST Freigabe Fertigungsvorschlag nicht möglich; Erwartetes Ergebnis: Stop-Icon und Hinweismeldung
    Given I open the infosystem "PRODLIST"
    And I set fields
      | kart | BG-SWITCH |
      | bfv  | ja        |
    Then I press start
    Then the table has 1 rows
    Then field "release" has value "icon:stop" in row 1
    And I press button "release" in row 1
    Then message "Freigabe nicht möglich!" was displayed
    And I close the current editor

############### Szenarien: Rückmeldung/Rückbau mit gesperrtem Fertigteil erfassen und buchen ###############

  Scenario: RF00 - Testdaten anlegen
    And I set the fake date to "13.02.1995"
## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "FV_RF00" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch   |
      | BG-SWITCH | 11     | ja     | FV_RF00_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor


  Scenario: RFE01 - Flag Gutmenge vorbesetzen in der Rückmeldung kann nicht gesetzt werden, wenn das Fertigteil gesperrt ist
# Erwartetes Ergebnis: Feld ist schreibgeschützt
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM_RF01" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_RF00_000"
    Then field "gut" is not modifiable
# 203 de      |Eintrag ist schreibgeschützt
    Then setting field "gut" to "ja" throws the exception "203"
    And I close the current editor


  Scenario: RFE02 - Gutmenge eintragen in der Rückmeldung ist nicht möglich, wenn das Fertigteil gesperrt ist
# Erwartetes Ergebnis: Feld ist schreibgeschützt
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM_RF02" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_RF00_000"
    Then field "gutmge" is not modifiable in row 1
# 203 de      |Eintrag ist schreibgeschützt
    Then setting field "gutmge" to "2" in row 1 throws the exception "203"
    And I close the current editor


  Scenario: RFE03 - Flag Beleg buchen in einer Rückmeldung kann gesetzt werden
# Erwartetes Ergebnis: Keine Fehlermeldung, weil buchen von Verlust und Nacharbeit erlaubt ist
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM_RF03" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_RF00_000"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I save the current editor


  Scenario: RFE05 - Button Menge uebertragen druecken, wenn das Fertigteil gesperrt ist
# Erwartetes Ergebnis: Die offene Menge wird nicht in das Feld gutmge eingetragen
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM_RF05" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_RF00_000"
    And I press button "ueber" in row 1
    Then field "gutmge" has value "0" in row 1
    And I close the current editor


############### Szenarien: Rückmeldung/Rückbau mit gesperrtem Fertigteil ändern und buchen ###############

  Scenario: RFC00 - Testdaten anlegen
## Switch-Artikel entsperren
    And I set the fake date to "13.02.1995"
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "FV_RFC00" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch    |
      | BG-SWITCH | 13     | ja     | FV_RFC00_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# RM erfassen
    Given I open an editor "RM_RFC00" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_RF00_000"
    Then I set field "mgr" to "101"
    And I set field "gutmge" to "7" in row 1
    And I set field "erbtext1" to "RM_RFC00" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor


  Scenario: RFC01 - Eine Rückmeldung, bei der das Fertigteil nachträglich gesperrt wurde, kann nicht über Kommando ändern gebucht werden
# Erwartetes Ergebnis: Fehlermeldung
    And I set the fake date to "13.02.1995"
## RM über Kommando ändern buchen
    Given I open an editor "RM_RFC01" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record from editor "RM_RFC00"
    And I set field "sofort" to "ja"
## 10343 de      |Das Fertigteil ist gesperrt. Keine Zugangsbuchung möglich.
# 4806 de      |Objekt ist gesperrt.
    Then saving the current editor throws the exception "4806"
    And I close the current editor


  Scenario: RFC02 - Eine Rückmeldung, bei der das Fertigteil nachträglich gesperrt wurde, kann nicht über Kommando übertragen gebucht werden
# Erwartetes Ergebnis: Fehlermeldung
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM_RFC02" from table "(Workorder):(CompletionConfirmations)" with command "TRANSFER" for record from editor "RM_RFC00"
## 10343 de      |Das Fertigteil ist gesperrt. Keine Zugangsbuchung möglich.
# 4806 de      |Objekt ist gesperrt.
    Then saving the current editor throws the exception "4806"
    And I close the current editor


############### Szenarien: Rückmeldung mit gesperrtem Fertigteil Ausschuss/Nacharbeit buchen ###############

  Scenario: RAF00 - Testdaten anlegen
    And I set the fake date to "13.02.1995"
## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "FV_RAF00" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch    |
      | BG-SWITCH | 11     | ja     | FV_RAF00_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor


  Scenario: RAF01 - Buchen von Ausschuss und Nacharbeitsmenge auf gesperrtes Fertigteil
# Erwartetes Ergebnis: kein Fehler, Objektstatus ist im Fertigteil gesetzt
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM_RAF01a" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_RAF00_000"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "verlustmge" to "1" in row 1
    And I set field "namge" to "1" in row 1
    And I set field "erbtext1" to "RM_RAF01" in row 1
    And I save the current editor


############### Szenarien: Rückbau mit gesperrtem Fertigteil erfassen und buchen ###############

  Scenario: RBF00 - Testdaten anlegen
    And I set the fake date to "13.02.1995"
## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "FV_RBF00" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch    |
      | BG-SWITCH | 12     | ja     | FV_RBF00_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

## RM erfassen
    Given I open an editor "RM_RBF00" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_RBF00_000"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "9" in row 1
    And I set field "erbtext1" to "RM_RBF00" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor


  Scenario: RBF01 - Rückbau auf gesperrtes Fertigteil
# Erwartetes Ergebnis: kein Fehler
    And I set the fake date to "13.02.1995"
    Given I open an editor "RB_RBF01" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FV_RBF00_000"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor


############### Szenarien: Storno Rückbau/Rückmeldung gesperrtes Fertigteil auf lebendigen FV ##############

  Scenario: SRFL00 - Testvorbereitung Daten anlegen
    And I set the fake date to "13.02.1995"
## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

## Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "FV_SRFL00" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch     |
      | BG-SWITCH | 55     | ja     | FV_SRFL00_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Rückmeldung
    Given I open an editor "RM1_SRFL00" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_SRFL00_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "23" in row 1
    And I set field "erbtext1" to "RM1_SRFL00" in row 1
    And I save the current editor

## Rückbau
    And I set the fake date to "14.02.1995"
    Given I open an editor "RB1_SRFL00" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FV_SRFL00_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "-7" in row 1
    And I set field "erbtext1" to "RB1_SRFL00" in row 1
    And I save the current editor

## Rückmeldung
    And I set the fake date to "15.02.1995"
    Given I open an editor "RM2_SRFL00" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_SRFL00_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "RM2_SRFL00" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor


  Scenario: SRFL01 - Rückmeldung mit mittlerweile gesperrtem Fertigteil wird storniert
# Erwartetes Ergebnis: Rückmeldung kann storniert werden
    And I set the fake date to "16.02.1995"
    Given I open an editor "SRFL01" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM2_SRFL00"
    And I save the current editor


  Scenario: SRFL02 - Rückbau mit mittlerweile gesperrtem Artikel wird storniert
# Erwartetes Ergebnis: Rückbau kann storniert werden
    And I set the fake date to "17.02.1995"
    Given I open an editor "SRFL02" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RB1_SRFL00"
    And I save the current editor


############### Szenarien: Rückmeldung/Rückbau mit gesperrtem Fertigteil auf abgelegten FV ###############

  Scenario: RFF00  - Testvorbereitung Daten anlegen
    And I set the fake date to "13.02.1995"
## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# FV FV_SRFL00_ abschliessen
    Given I open an editor "RM3_SRFL00" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_SRFL00_000"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "erbtext1" to "RM3_SRFL00" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor


  Scenario: RFF01 - Auf abgelegten FV mit gesperrtem Fertigteil wird eine Rückmeldung erfasst
# Erwartetes Ergebnis: Fehlermeldung
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM1_RFF01" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record from editor "RM3_SRFL00"
# 10343 de      |Das Fertigteil ist gesperrt. Keine Zugangsbuchung möglich.
    Then setting field "gutmge" to "2" in row 1 throws the exception "10343"
    And I close the current editor


  Scenario: RFF02 - Auf abgelegten FV mit gesperrtem Fertigteil einen Rückbau erfasst
# Erwartetes Ergebnis: Rückbau wird gebucht
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM1_RFF02" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record from editor "RM3_SRFL00"
    And I set field "gutmge" to "-2" in row 1
    And I set field "erbtext1" to "RM1_RFF02" in row 1
    And I save the current editor


############### Szenarien: Storno Rückmeldung/Rückbau mit gesperrtem Fertigteil auf abgelegten FV ###############

  Scenario: SRFF00 - Daten anlegen
    And I set the fake date to "13.02.1995"
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

## Rückmeldung
    Given I open an editor "RM1_SRFF00" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record from editor "RM3_SRFL00"
    And I set field "gutmge" to "4" in row 1
    And I set field "erbtext1" to "RM1_SRFF00" in row 1
    And I save the current editor

## Rückbau
    Given I open an editor "RB1_SRFF00" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record from editor "RM3_SRFL00"
    And I set field "gutmge" to "-3" in row 1
    And I set field "erbtext1" to "RB1_SRFF00" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor


  Scenario: SRFF01 - Rückbau auf abgelegten FV mit gesperrtem Fertigteil wird wieder storniert
# Erwartetes Ergebnis: Rückbau kann storniert werden
    And I set the fake date to "13.02.1995"
    Given I open an editor "RB1_SRFF01" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record from editor "RB1_SRFF00"
    And I save the current editor

  Scenario: SRFF02 - Rückmeldung auf abgelegten FV mit gesperrtem Fertigteil wird wieder storniert
# Erwartetes Ergebnis: Rückmeldung kann storniert werden
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM1_SRFF01" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record from editor "RM1_SRFF00"
    And I save the current editor

#----------------------------------------------------------------------------------------------------------#
#------------------------------------- Tests mit gesperrter Komponente ------------------------------------#


############### Szenarien: Fertigungsvorschlag mit gesperrter Komponente erfassen ###############

  Scenario: EK01 - Artikel mit gesperrter Komponente in neuen Fertigungsvorschlag eintragen und freigeben
# Erwartetes Ergebnis: Hinweismeldung
    And I set the fake date to "13.02.1995"
    Given I open an editor "FV_EK01" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
# 2060 de      |Eine der Komponenten des Teils ist gesperrt und wird nicht beschafft. Trotzdem weiter?
    # Given I respond with answer "ja" to the dialog with id "2060"
    And I set field "artikel" to "BG-K-GESPERRT" in row 1
    And I set field "netmge" to "10" in row 1
    And I set field "bisuch" to "FV_EK01_" in row 1
    And I set field "mfreig" to "ja" in row 1
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor


##### Szenarien: Fertigungsvorschlag erfassen, Komponente sperren, Fertigungsvorschlag freigeben #######

  Scenario: CK00 - Testdaten anlegen
    And I set the fake date to "13.02.1995"

## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

## Fertigungsvorschlag anlegen
    Given I open an editor "FV_CK00" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | verw    |
      | BG-K-SWITCH | 80     | FV_CK00 |
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor


  Scenario: CK01 - Freigeben eines bestehenden FV, wenn Komponente nach Anlegen des FV gesperrt wurde
# Erwartetes Ergebnis: Hinweismeldung
    And I set the fake date to "13.02.1995"
    Given I open an editor "FV_CK01" from table "(Purchasing):(WorkOrderSuggestion)" with command "RELEASE" for search criteria "$,,artikel=BG-K-SWITCH;verw=FV_CK00;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bisuch" to "FV_CK01_"
    # Given I respond with answer "ja" to the dialog with id "2060"
    And I set field "mfreig" to "ja"
    And I save the current editor


############### Szenarien: Rückmeldung/Rückbau mit gesperrter Komponente buchen ###############

  Scenario: RK00 - Testdaten anlegen
    And I set the fake date to "13.02.1995"
    Given I open an editor "FV_RK00" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
# 2060 de      |Eine der Komponenten des Teils ist gesperrt und wird nicht beschafft. Trotzdem weiter?
    # Given I respond with answer "ja" to the dialog with id "2060"
    And I set field "artikel" to "BG-K-GESPERRT" in row 1
    And I set field "netmge" to "20" in row 1
    And I set field "bisuch" to "FV_RK00_" in row 1
    And I set field "mfreig" to "ja" in row 1
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

  Scenario: RK01 - Rückmeldung auf FV mit gesperrte Komponente in der AFL
# Erwartetes Ergebnis: kein Fehler
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM_RK01" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_RK00_000"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "6" in row 1
    And I save the current editor

    Given I open an editor "RM_RK01b" via ID from editor "RM_RK01" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
    Then field "mge" has value "0" in row 3
    And I close the current editor

  Scenario: RK02 - Rückbau auf FV mit gesperrter Komponente in der AFL
# Erwartetes Ergebnis: kein Fehler
    And I set the fake date to "13.02.1995"
    Given I open an editor "RB_RK02" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FV_RK00_000"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

    Given I open an editor "RB_RK02b" via ID from editor "RB_RK02" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
    Then field "mge" has value "-3" in row 2
    And I close the current editor


################### Scenarien: Rückmeldung auf FV, Komponente sperren und dann Rückbau ##############
  Scenario: RBK00 - Testdaten anlegen
    And I set the fake date to "13.02.1995"
    Given I open an editor "FV_RBK00" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
# 2060 de      |Eine der Komponenten des Teils ist gesperrt und wird nicht beschafft. Trotzdem weiter?
    # Given I respond with answer "ja" to the dialog with id "2060"
    And I set field "artikel" to "BG-K-SWITCH" in row 1
    And I set field "netmge" to "20" in row 1
    And I set field "bisuch" to "FV_RBK00_" in row 1
    And I set field "mfreig" to "ja" in row 1
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

## RM erfassen
    Given I open an editor "RM_RBK01" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_RBK00_000"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "16" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

  Scenario: RBK01 - Rückbau auf FV mit gesperrter Komponente in der AFL (nach RM ohne gesperrte Komponente)
# Erwartetes Ergebnis: kein Fehler
    And I set the fake date to "13.02.1995"
    Given I open an editor "RB_RBK01" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FV_RBK00_000"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-6" in row 1
    And I save the current editor

    Given I open an editor "RB_RBK01b" via ID from editor "RB_RBK01" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
    Then field "mge" has value "-6" in row 2
    And I close the current editor

## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor


############### Szenarien: Rückmeldung retrograd mit gesperrter Komponente ###############

  Scenario: RRK00 - Testdaten anlegen
    And I set the fake date to "13.02.1995"
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

## Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "FV_RRK00" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch    |
      | BG-K-SWITCH | 22     | ja     | FV_RRK00_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Rückmeldung
    Given I open an editor "RM_RRK00" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_RRK00_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "12" in row 1
    And I set field "erbtext1" to "RM_RRK00" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

  Scenario: RRK01 - Rückmeldung retrograd buchen mit gesperrter Komponente in der AFL
# Erwartetes Ergebnis: Wird Material retrograd über die Rückmeldung abgebucht, wird für den gesperrten Artikel kein Material abgebucht. Kein Eintrag im LJ.
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM_RRK01" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_RRK00_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "3" in row 1
    And I set field "erbtext1" to "RM_RRK01" in row 1
    And I save the current editor

## Rückbau
    Given I open an editor "RB_RRK01" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FV_RRK00_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "-5" in row 1
    And I set field "erbtext1" to "RB_RRK01" in row 1
    And I save the current editor

    Given I open an editor "RB_RRK01b" via ID from editor "RB_RRK01" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
    Then field "mge" has value "-2" in row 2
    And I close the current editor

## Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !RB_RRK01^nummer |
      | artikel  | EK-SWITCH        |
      | adatum   | 13.02.1995       |
      | edatum   | 14.02.1995       |
      | richtung | rückwärts        |
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge | !row |
      | EK-SWITCH | -2   | -2       | 0       | 1    |
      | EK-SWITCH | 12   | 2        | 10      | 2    |
    And I close the current editor


############### Szenarien: Fbuchung mit gesperrter Komponente ###############

  Scenario: RAK00 - Testdaten anlegen
    And I set the fake date to "13.02.1995"
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

## Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "FV_RAK00" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch    |
      | BG-K-SWITCH | 33     | ja     | FV_RAK00_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Materialentnahme
    Given I open an editor "FBU1_RAK00" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | FV_RAK00_000                                      |
      | bem         | FBU1_RAK00: Entnahme 10, nicht gesperrter Artikel |
      | gmgevorschl | 10                                                |
      | autorment   | ja                                                |
      | mgr         | 112                                               |
    And I press button "stllad"
    Then the table has 4 rows
    And table has values
      | art       | bumge |
      | MINE      | 10    |
      | FEDER     | 10    |
      | GRIFFROHR | 10    |
      | EK-SWITCH | 10    |
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

## Materialentnahme
    Given I open an editor "FBU2_RAK00" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | FV_RAK00_000                               |
      | bem         | FBU2_RAK00: Entnahme 5, gesperrter Artikel |
      | gmgevorschl | 5                                          |
      | autorment   | ja                                         |
      | mgr         | 112                                        |
    And I press button "stllad"
    Then the table has 4 rows
    And table has values
      | art       | bumge |
      | MINE      | 5     |
      | FEDER     | 5     |
      | GRIFFROHR | 5     |
      | EK-SWITCH | 0     |
    And I save the current editor

  Scenario: RAK01 - Materialabbuchung mit gesperrter Komponente in der AFL
# Erwartetes Ergebnis: Wird Material über Fbuchung abgebucht, wird für einen gesperrten Artikel kein Material gebucht. In der Fbuchung-Maske ist der Artikel gesperrt und die bumge=0. Kein Eintrag im LJ.
    And I set the fake date to "13.02.1995"
    Given I open an editor "FBU3_RAK01" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | FV_RAK00_000                                 |
      | bem         | FBU3_RAK01: Entnahme -11, gesperrter Artikel |
      | gmgevorschl | -11                                          |
      | autorment   | ja                                           |
      | mgr         | 112                                          |
    And I press button "stllad"
    Then the table has 4 rows
    And table has values
      | art       | bumge |
      | MINE      | -11   |
      | FEDER     | -11   |
      | GRIFFROHR | -11   |
      | EK-SWITCH | -10   |
    And I save the current editor

## Nummer des FV besorgen, um LJ zu befüttern
    Given I open an editor "FV_NUM4LJ" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV_RAK00_000;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    Then field "mge" has value "-10" in row 2
    And I close the current editor

## Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !FV_NUM4LJ^barmex |
      | artikel  | EK-SWITCH         |
      | adatum   | 13.02.1995        |
      | edatum   | 14.02.1995        |
      | richtung | rückwärts         |
    And I press start
    Then the table has 2 rows
    Then table has values
      | art       | amge | rueckmge | restmge |
      | EK-SWITCH | -10  | -10      | 0       |
      | EK-SWITCH | 10   | 10       | 0       |
    And I close the current editor


############### Szenarien: Storno Rückbau/Rückmeldung gesperrte Komponente auf lebendigen FV ###############

  Scenario: SRKL00 - Testvorbereitung Daten anlegen
    And I set the fake date to "13.02.1995"
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

## Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "FV_SRKL00" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch     |
      | BG-K-SWITCH | 66     | ja     | FV_SRKL00_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Rückmeldung
    Given I open an editor "RM1_SRKL00" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_SRKL00_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "23" in row 1
    And I set field "erbtext1" to "RM1_SRKL00" in row 1
    And I save the current editor

## Rückbau
    And I set the fake date to "14.02.1995"
    Given I open an editor "RB1_SRKL00" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FV_SRKL00_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "-7" in row 1
    And I set field "erbtext1" to "RB1_SRKL00" in row 1
    And I save the current editor

## Rückmeldung
    And I set the fake date to "15.02.1995"
    Given I open an editor "RM2_SRKL00" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_SRKL00_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "RM2_SRKL00" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor


  Scenario: SRKL01 - Rückmeldung mit mittlerweile gesperrter Komponente wird storniert
# Erwartetes Ergebnis: Rückmeldung kann storniert werden
    And I set the fake date to "16.02.1995"
    Given I open an editor "SRKL01" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM2_SRKL00"
    Then field "mge" has value "-5" in row 2
    And I save the current editor


  Scenario: SRKL02 - Rückbau mit mittlerweile gesperrter Komponente wird storniert
# Erwartetes Ergebnis: Rückbau kann storniert werden
    And I set the fake date to "17.02.1995"
    Given I open an editor "SRFL02" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RB1_SRKL00"
    Then field "mge" has value "7" in row 2
    And I save the current editor


############### Szenarien: Rückmeldung/Rückbau mit gesperrter Komponente auf abgelegten FV ###############

  Scenario: RFF00  - Testvorbereitung Daten anlegen
# FV FV_SRFL00_ abschliessen
    And I set the fake date to "18.02.1995"

## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

## Restmenge buchen und dadurch BA abschliessen
    Given I open an editor "RM4_SRKL00" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_SRKL00_000"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "erbtext1" to "RM4_SRKL00" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor


  Scenario: RFK01 - Auf abgelegten FV mit gesperrter Komponente wird eine Rückmeldung erfasst
# Erwartetes Ergebnis: Fehlermeldung
    And I set the fake date to "19.02.1995"
    Given I open an editor "RM1_RFK01" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record from editor "RM4_SRKL00"
    Then the table has 5 rows
# 4806 de |Objekt ist gesperrt.
    Then setting field "mge" to "1" in row 5 throws the exception "4806"
    And I close the current editor


  Scenario: RFK02 - Auf abgelegten FV mit gesperrter Komponente ein Rückbau erfasst
# Erwartetes Ergebnis: Rückbau wird gebucht
    And I set the fake date to "20.02.1995"
    Given I open an editor "RM1_RFK02" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record from editor "RM4_SRKL00"
    Then the table has 5 rows
    And I set field "mge" to "-3" in row 5
    And I set field "erbtext1" to "RM1_RFK02" in row 5
    And I save the current editor


############### Szenarien: Storno Rückmeldung/Rückbau mit gesperrter Komponente auf abgelegten FV ###############

  Scenario: SRKF00 - Daten anlegen
    And I set the fake date to "13.02.1995"
## Switch-Artikel entperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

## Rückmeldung
    Given I open an editor "RM1_SRKF00" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record from editor "RM4_SRKL00"
    And I set field "gutmge" to "4" in row 1
    And I set field "erbtext1" to "RM1_SRKF00" in row 1
    And I save the current editor

## Rückbau
    Given I open an editor "RB1_SRKF00" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record from editor "RM4_SRKL00"
    And I set field "gutmge" to "-3" in row 1
    And I set field "erbtext1" to "RB1_SRKF00" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor


  Scenario: SRKF01 - Rückbau auf abgelegten FV mit gesperrter Komponente wird wieder storniert
# Erwartetes Ergebnis: Rückbau kann storniert werden
    And I set the fake date to "13.02.1995"
    Given I open an editor "RB1_SRFF01" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record from editor "RB1_SRKF00"
    And I save the current editor

  Scenario: SRKF02 - Rückmeldung auf abgelegten FV mit gesperrter Komponente wird wieder storniert
# Erwartetes Ergebnis: Rückmeldung kann storniert werden
    And I set the fake date to "13.02.1995"
    Given I open an editor "RB1_SRFF01" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record from editor "RM1_SRKF00"
    And I save the current editor


#----------------------------------------------------------------------------------------------------------#
#------------------ Tests mit gesperrter Komponente als zusätzliches Material -----------------------------#


### Szenarien: zusätzliches Material mit Artikelsperre in Rückbau/Rückmeldung/Materialentnahme eintragen ##

  Scenario: ZM00 - Testvorbereitung Daten anlegen
    And I set the fake date to "13.02.1995"
## Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "FV_ZM00" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel       | netmge | mfreig | bisuch   |
      | VK-OHNESPERRE | 66     | ja     | FV_ZM00_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Rückmeldung anlegen
  Scenario: ZM01 - Gesperrten Artikel als zusätzliche Entnahme in eine Rückmeldung eintragen
# Erwartetes Ergebnis: Fehlermeldung
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM_ZM01" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_ZM00_000"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "11" in row 1
    And I set field "erbtext1" to "RM_ZM00" in row 1
    And I create a new row at the end of the table
# 4806 de |Objekt ist gesperrt.
## 4806 kann nicht abgefragt werden
#  1361 de      |Ungültiger Feldwert
    Then setting field "artikel" to "EK-GESPERRT" in row !lastRow throws the exception "1361"
    And I close the current editor

  Scenario: ZM02 - Gesperrten Artikel als zusätzliche Entnahme in die Materialentnahme eintragen
# Erwartetes Ergebnis: Fehlermeldung
    And I set the fake date to "13.02.1995"
    Given I open an editor "FBU_ZM02" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "FV_ZM00_000"
    And I create a new row at the end of the table
# 4806 de |Objekt ist gesperrt.
    And I set field "elex" to "EK-GESPERRT" in row !lastRow
    Then setting field "mge" to "11" in row !lastRow throws the exception "203"
    And I close the current editor

  Scenario: ZM03 - Gesperrten Artikel als zusätzliche Entnahme in einen Rückbau eintragen
# Erwartetes Ergebnis: Fehlermeldung
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM_ZM03" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FV_ZM00_000"
    And I create a new row at the end of the table
# 4806 de |Objekt ist gesperrt.
## 4806 kann nicht abgefragt werden
#  1361 de      |Ungültiger Feldwert
    Then setting field "artikel" to "EK-GESPERRT" in row !lastRow throws the exception "1361"
    And I close the current editor

  Scenario: ZM04 - Gesperrten Artikel als zusätzliche Entnahme in die Materialentnahme (Rückbau) eintragen
# Erwartetes Ergebnis: Fehlermeldung
    And I set the fake date to "13.02.1995"
    Given I open an editor "FBU_ZM04" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "FV_ZM00_000"
    And I set field "gmgevorschl" to "-1"
    And I press button "stllad"
    And I create a new row at the end of the table
# 4806 de |Objekt ist gesperrt.
    And I set field "elex" to "EK-GESPERRT" in row !lastRow
    Then setting field "mge" to "11" in row !lastRow throws the exception "203"
    And I close the current editor


### Szenarien: Rückbau zusätzliches Material auf lebendigen FV wenn Artikel mittlerweile gesperrt wurde, muss möglich sein

  Scenario: ZMRB00 - Testdaten anlegen
    And I set the fake date to "13.02.1995"
## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "BG-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# FV anlegen und freigeben
    Given I open an editor "FV_ZMRB00" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch     |
      | BG-SWITCH | 11     | ja     | FV_ZMRB00_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

## RM mit zus. Material erfassen und buchen
    Given I open an editor "RM_ZMRB00" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_ZMRB00_000"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I set field "erbtext1" to "RM_ZMRB00" in row 1
    And I create a new row at the end of the table
    And I set field "artikel" to "EK-SWITCH" in row !lastRow
    And I set field "mge" to "4" in row !lastRow
    And I set field "erbtext1" to "RM_ZMRB00 ZM" in row !lastRow
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

  Scenario: ZMRB01 - Rückbau auf gesperrtes zus. Material
# Erwartetes Ergebnis: kein Fehler
    And I set the fake date to "13.02.1995"
    Given I open an editor "ZMRB01" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FV_ZMRB00_000"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "mge" to "-1" in row !lastRow
    And I save the current editor


### Szenarien: Rückbau zusätzliches Material auf abgelegten FV wenn Artikel mittlerweile gesperrt wurde, muss möglich sein ###

  Scenario: ZMRBF00 - Testdaten anlegen, dh. FV "FV_ZMRB00_" ablegen
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM_ZMRBF00" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_ZMRB00_000"
    And I set field "mgr" to "101"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I save the current editor

  Scenario: ZMRBF01 - Rückbau von zusätzlichem Material auf abgelegten FV
# Erwartetes Ergebnis: kein Fehler
    And I set the fake date to "13.02.1995"
    Given I open an editor "ZMRBF01" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for search criteria "$,,such=FV_ZMRB00_000;gutmge==1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then table has values
      | art           | mge | !row |
      | BG-SWITCH     | 0   | 1    |
      | MINE          | 0   | 2    |
      | FEDER         | 0   | 3    |
      | GRIFFROHR     | 0   | 4    |
      | EK-OHNESPERRE | 0   | 5    |
      | EK-SWITCH     | 0   | 6    |
    And I set field "mge" to "-2" in row !lastRow
    And I set field "erbtext1" to "RB_ZMRBF01" in row !lastRow
    And I save the current editor


############### Szenarien: Rückmeldung mit Flag "Restmenge buchen" mit gesperrter Komponente ###############

  Scenario: RAKRB00 - Testdaten anlegen
    And I set the fake date to "13.02.1995"
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

## Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "FV_RAKRB00" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch      |
      | BG-K-SWITCH | 13     | ja     | FV_RAKRB00_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Materialentnahme
    Given I open an editor "FBU1_RAKRB00" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | FV_RAKRB00_000                                      |
      | bem         | FBU1_RAKRB00: Entnahme 10, nicht gesperrter Artikel |
      | gmgevorschl | 10                                                  |
      | autorment   | ja                                                  |
      | mgr         | 112                                                 |
    And I press button "stllad"
    Then the table has 4 rows
    And table has values
      | art       | bumge |
      | MINE      | 10    |
      | FEDER     | 10    |
      | GRIFFROHR | 10    |
      | EK-SWITCH | 10    |
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

  Scenario: RAKRB01 - Rückmeldung der Gutmenge mit Flag "Restmenge buchen"
# Erwartetes Ergebnis: Für den gesperrten Artikel EK-SWITCH wird kein Material gebucht. In der Rückmeldung ist die Sperre aber dokumentiert.
    And I set the fake date to "13.02.1995"
    Given I open an editor "RM_RAKRB01" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_RAKRB00_000"
    And I set field "mgr" to "112"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I set field "erbtext1" to "RM_RAKRB01" in row 1
    And I save the current editor

## Lagerjournaleintrag pruefen, nur 10 Stueck von FBU aus Scen RAKRB00, die 3 Stueck Restmenge nicht
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !RM_RAKRB01^nummer |
      | artikel  | EK-SWITCH          |
      | adatum   | 13.02.1995         |
      | edatum   | 14.02.1995         |
      | richtung | rückwärts          |
    And I press start
    Then the table has 1 rows
    Then table has values
      | art       | amge | detursache                 |
      | EK-SWITCH | 10   | Materialentnahme Fertigung |
    And I close the current editor


############### Szenarien: gesperrte Artikel in AFL eintragen ###############

  Scenario: GK01 - Gesperrter Artikel wird in AFL eines nicht freigegebenen Fertigungsvorschlag eingetragen und eingeplant

    Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel       | netmge |
      | VK-OHNESPERRE | 10     |
    And I press button "absteig" to open a subeditor for "AFL01" in row 1
    And I modify table
      | !row | elex        | elanzahl |
      | +2   | EK-GESPERRT | 1        |
    Then table has values
      | einplan | relevant | !row |
      | nein    | ja       | 2    |
    Then field "einplan" is not modifiable in row 2
    Then field "relevant" is modifiable in row 2
    And I save the current subeditor to switch back to the parent editor
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: GK02 - Gesperrter Artikel wird in AFL eines freigegebenen Fertigungsvorschlags eingetragen und eingeplant

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "FV_GK02" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel       | netmge | mfreig | bisuch   |
      | VK-OHNESPERRE | 10     | ja     | FV_GK02_ |
    And I press button "freig" to open a subeditor for "FeVo freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# gesperrten Artikel in Fertigungsvorschlag eintragen und Felder prüfen - BA löschen
    Given I open an editor "BA_FV_GK02_" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FV_GK02_000"
    And I press button "absteig" to open a subeditor for "AFL_GK02" in row 0
    And I modify table
      | !row | elex        | elanzahl |
      | +2   | EK-GESPERRT | 1        |
    Then table has values
      | einplan | relevant | !row |
      | nein    | ja       | 2    |
    Then field "einplan" is not modifiable in row 2
    Then field "relevant" is modifiable in row 2
    And I save the current subeditor to switch back to the parent editor
# 345 de   |Wollen Sie den Betriebsauftrag wirklich beenden?
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "S"
    And I save the current editor


  Scenario: GK03 - Gesperrter Switch-Artikel wird in AFL eingeplant, Fertigungsvorschlag wird freigegeben, Artikel entsperrt

# Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Fertigungsvorschlag anlegen, gesperrten SWITCH-Artikel eintragen, Felder prüfen und freigeben
    Given I open an editor "FV_GK03" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel       | netmge | mfreig |
      | VK-OHNESPERRE | 10     | ja     |
    And I press button "absteig" to open a subeditor for "AFL_GK03" in row 1
    And I modify table
      | !row | elex      | elanzahl |
      | +2   | EK-SWITCH | 1        |
    Then table has values
      | einplan | relevant | !row |
      | nein    | ja       | 2    |
    Then field "einplan" is not modifiable in row 2
    Then field "relevant" is modifiable in row 2
    And I save the current subeditor to switch back to the parent editor
    And I set field "bisuch" to "FV_GK03_" in row 1
# Hinweismeldung 2065 de |Es werden Beschaffungsvorschläge mit Komponenten freigegeben die gesperrt sind und nicht mehr beschafft werden. Trotzdem weiter?
    And I press button "freig" to open a subeditor for "FeVo freigeben" in row 0
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Felder prüfen und BA löschen
    Given I open an editor "BA_FV_GK03_" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FV_GK03_000"
    And I press button "absteig" to open a subeditor for "AFL_GK03" in row 0
    Then table has values
      | einplan | relevant | !row |
      | nein    | ja       | 2    |
    Then field "einplan" is modifiable in row 2
    Then field "relevant" is modifiable in row 2
    And I close the current subeditor to switch back to the parent editor
 # 345 de   |Wollen Sie den Betriebsauftrag wirklich beenden?
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "S"
    And I save the current editor


  Scenario: GK04 - Gesperrte Komponente wird in AFL eines freigegebenen Fertigungsvorschlags eingetragen und eingeplant, dann entsperrt

# Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "FV_GK04" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel       | netmge | mfreig | bisuch   |
      | VK-OHNESPERRE | 10     | ja     | FV_GK04_ |
    And I press button "freig" to open a subeditor for "FeVo freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# gesperrten SWITCH-Artikel eintragen und Felder prüfen
    Given I open an editor "BA_FV_GK04_" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FV_GK04_000"
    And I press button "absteig" to open a subeditor for "AFL_GK04" in row 0
    And I modify table
      | !row | elex      | elanzahl |
      | +2   | EK-SWITCH | 1        |
    Then table has values
      | einplan | relevant | !row |
      | nein    | ja       | 2    |
    Then field "einplan" is not modifiable in row 2
    Then field "relevant" is modifiable in row 2
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

# Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Felder prüfen und BA löschen
    And I switch the current editor to editor "BA_FV_GK04_" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL_GK04" in row 0
    Then table has values
      | einplan | relevant | !row |
      | nein    | ja       | 2    |
    Then field "einplan" is modifiable in row 2
    Then field "relevant" is modifiable in row 2
    And I close the current subeditor to switch back to the parent editor
# 345 de   |Wollen Sie den Betriebsauftrag wirklich beenden?
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "S"
    And I save the current editor


  Scenario: GK05 - Gesperrte Komponente wird in AFL eingeplant, Fertigungsvorschlag wird freigegeben, Materialentnahme und Rückmeldung gebucht, dann Komponente entsperrt

# Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | FABER    |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel   | mge |
      | MINE      | 10  |
      | FEDER     | 10  |
      | GRIFFROHR | 10  |
      | VORSCHUB  | 10  |
      | EK-SWITCH | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Fertigungsvorschlag anlegen, gesperrten SWITCH-Artikel eintragen und freigeben
    Given I open an editor "FV_GK05" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel       | netmge | mfreig |
      | VK-OHNESPERRE | 10     | ja     |
    And I press button "absteig" to open a subeditor for "AFL_GK05" in row 1
    And I modify table
      | !row | elex      | elanzahl | manbu |
      | +2   | EK-SWITCH | 1        | ja    |
    Then table has values
      | einplan | relevant | !row |
      | nein    | ja       | 2    |
    Then field "einplan" is not modifiable in row 2
    Then field "relevant" is modifiable in row 2
    And I save the current subeditor to switch back to the parent editor
    And I set field "bisuch" to "FV_GK05_" in row 1
# Hinweismeldung 2065 de |Es werden Beschaffungsvorschläge mit Komponenten freigegeben die gesperrt sind und nicht mehr beschafft werden. Trotzdem weiter?
    And I press button "freig" to open a subeditor for "FeVo freigeben" in row 0
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialentnahme prüfen (nur gesperrter Artikel hat manbu gesetzt)
# Erwartetes Ergebnis: für gesperrter Artikel kann keine Buchungsmenge eingetragen werden
    Given I open an editor "Arbeitsschein001" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV_GK05_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein001^nummer"
    And I press button "stlvblad"
    Then field "elex" has value "EK-SWITCH" in row 1
    Then field "bumge" has value "0" in row 1
# 4806 de |Objekt ist gesperrt.
    Then setting field "bumge" to "1" in row 1 throws the exception "4806"
    And I close the current editor

# Rückmeldung buchen
    Given I open an editor "Rückmeldung001" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_GK05_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor

# Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Felder in AFL prüfen
    Given I open an editor "BA_FV_GK05_000" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FV_GK05_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL_GK05" in row 0
    Then table has values
      | einplan | relevant | limge | !row |
      | nein    | ja       | 10    | 2    |
    Then field "einplan" is not modifiable in row 2
    Then field "relevant" is modifiable in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# BA fertig buchen - ohne Löschschutz
# Erwartetes Ergebnis: Meldung "Wählen Sie ein Buchungsverfahren für die Restmenge" (1006)
    Given I open an editor "Rückmeldung001" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_GK05_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "8" in row 1
# Fehlermeldung Wählen Sie ein Buchungsverfahren für die Restmenge
    Then saving the current editor throws the exception "1006"
    And I set field "manrest" to "ja"
    And I save the current editor

# LJ prüfen von EK-SWITCH
# Erwartests Ergebnis: gesamte Menge wurde entnommen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung001^barmex"
    And I set field "artikel" to "EK-SWITCH"
    And I press button "bstart"
    Then table has values
      | art       | amge | detursache            | !row     |
      | EK-SWITCH | 10   | Rückmeldung Fertigung | !lastRow |
    And I close the current editor


  Scenario: GK06 - Gesperrte Komponente wird in AFL eines freigegebenen Fertigungsvorschlags eingeplant, Materialentnahme und Rückmeldung gebucht, dann Artikel entsperrt, BA mit Löschschutz

# Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | FABER    |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel   | mge |
      | MINE      | 10  |
      | FEDER     | 10  |
      | GRIFFROHR | 10  |
      | VORSCHUB  | 10  |
      | EK-SWITCH | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben - Löschschutz
    Given I open an editor "FV_GK06" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel       | netmge | mfreig | bisuch   | binoloe |
      | VK-OHNESPERRE | 10     | ja     | FV_GK06_ | ja      |
    And I press button "freig" to open a subeditor for "FeVo freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# gesperrten SWITCH-Artikel eintragen und Felder prüfen
    Given I open an editor "BA_FV_GK06_" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FV_GK06_000"
    And I press button "absteig" to open a subeditor for "AFL_GK06" in row 0
    And I modify table
      | !row | elex      | elanzahl | manbu |
      | +2   | EK-SWITCH | 1        | ja    |
    Then table has values
      | einplan | relevant | !row |
      | nein    | ja       | 2    |
    Then field "einplan" is not modifiable in row 2
    Then field "relevant" is modifiable in row 2
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

# Materialentnahme prüfen (nur gesperrter Artikel hat manbu gesetzt)
# Erwartetes Ergebnis: für gesperrter Artikel kann keine Buchungsmenge eingetragen werden
    Given I open an editor "Arbeitsschein001" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV_GK06_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein001^nummer"
    And I press button "stlvblad"
    Then field "elex" has value "EK-SWITCH" in row 1
    Then field "bumge" has value "0" in row 1
# 4806 de |Objekt ist gesperrt.
    Then setting field "bumge" to "1" in row 1 throws the exception "4806"
    And I close the current editor

# Rückmeldung buchen
    Given I open an editor "Rückmeldung001" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_GK06_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor

# LJ prüfen von EK-SWITCH (keine Buchung)
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung001^barmex"
    And I set field "artikel" to "EK-SWITCH"
    And I press button "bstart"
    Then the table has 0 rows
    And I close the current editor

# Switch-Artikel entsperren
    And I switch the current editor to editor "Artikel-switch" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Felder prüfen
    And I switch the current editor to editor "BA_FV_GK06_" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL_GK06" in row 0
    Then table has values
      | einplan | relevant | limge | !row |
      | nein    | ja       | 10    | 2    |
    Then field "einplan" is not modifiable in row 2
    Then field "relevant" is modifiable in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# BA fertig buchen - mit Löschschutz
    Given I open an editor "Rückmeldung001" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_GK06_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

# Löschschutz im BA entfernen
# Erwartetes Ergebnis: Löschschutz kann nicht entfernt werden, da Artikel nicht entnommen
    Given I open an editor "BA_FV_GK06_" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FV_GK06_000"
# Fehlermeldung Löschschutz kann nicht entfernt werden, da noch Restmengen vorhanden
    Then setting field "noloesch" to "nein" throws the exception "1697"
    And I close the current editor

# Rückmeldung buchen - BA abschließen
    Given I open an editor "Rückmeldung001" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV_GK06_001"
    And I set field "sofort" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

# Löschschutz entfernen
    Given I open an editor "BA_FV_GK06_" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FV_GK06_000"
    And I set field "noloesch" to "nein"
    And I save the current editor

# LJ prüfen von EK-SWITCH
# Erwartetes Ergbnis: gesamte Menge wurde entnommen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung001^barmex"
    And I set field "artikel" to "EK-SWITCH"
    And I press button "bstart"
    Then table has values
      | art       | amge | detursache            | !row     |
      | EK-SWITCH | 10   | Rückmeldung Fertigung | !lastRow |
    And I close the current editor


  Scenario: GK07 - Gesperrte Komponente in AFL in nicht eingeplante Stufe eintragen, nach Entsperren des Artikels die Stufe einplanen

# Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Auftrag anlegen mit einplan nein
    Given I open an editor "Auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | 1        |
      | such  | Auftrag1 |
    And I append rows
      | artikel       | mge | einplan |
      | VK-OHNESPERRE | 20  | nein    |
    And I press button "absteig" to open a subeditor for "AFL1" in row 1
    And I modify table
      | !row | elex      | elanzahl |
      | +2   | EK-SWITCH | 1        |
    Then field "einplan" has value "nein" in row 2
    Then field "einplan" is not modifiable in row 2
    Then field "relevant" is modifiable in row 2
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

# Switch-Artikel entsperren
    And I switch the current editor to editor "Artikel-switch" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# einplan in Auftragsposition setzen und in AFL prüfen, Auftrag stornieren
    And I switch the current editor to editor "Auftrag1" with command "UPDATE"
    And I set field "einplan" to "ja" in row 1
    And I press button "absteig" to open a subeditor for "AFL1" in row 1
    Then field "einplan" has value "ja" in row 2
    Then field "einplan" is not modifiable in row 2
    Then field "relevant" is modifiable in row 2
    And I close the current subeditor to switch back to the parent editor
# 191 de |Wollen Sie diese Position wirklich stornieren?
    And I respond with answer "ja" to the dialog with id "191"
    Then I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: GK08 - Gesperrte Komponente in AFL in nicht eingeplante Stufe eintragen, Stufe mit gesperrter Komponente einplanen

# Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Auftrag anlegen mit einplan nein
    Given I open an editor "Auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | 1        |
      | such  | Auftrag2 |
    And I append rows
      | artikel       | mge | einplan |
      | VK-OHNESPERRE | 20  | nein    |
    And I press button "absteig" to open a subeditor for "AFL2" in row 1
    And I modify table
      | !row | elex      | elanzahl |
      | +2   | EK-SWITCH | 1        |
    Then field "einplan" has value "nein" in row 2
    Then field "einplan" is not modifiable in row 2
    Then field "relevant" is modifiable in row 2
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

# einplan in Auftragsposition setzen, AFL des Auftrags prüfen und Auftrag stornieren
    And I switch the current editor to editor "Auftrag2" with command "UPDATE"
    And I set field "einplan" to "ja" in row 1
    And I press button "absteig" to open a subeditor for "AFL2" in row 1
    Then field "einplan" has value "ja" in row 2
    Then field "einplan" is not modifiable in row 2
    Then field "relevant" is modifiable in row 2
    And I close the current subeditor to switch back to the parent editor
# 191 de |Wollen Sie diese Position wirklich stornieren?
    And I respond with answer "ja" to the dialog with id "191"
    Then I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: LSS01 - Fertigungsvorschlag mit gesperrter Komponente abschliessen - Loeschschutz setzen

## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "LSS01" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch |
      | BG-K-SWITCH | 19     | ja     | LSS01_ |
    And I press button "freig" to open a subeditor for "FeVo freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA1_LSS01" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=LSS01_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "nein"
    And I close the current editor

## letzten AS teilweise bebuchen
    Given I open an editor "RM1_LSS01" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS01_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "9" in row 1
    And I set field "erbtext1" to "RM1_LSS01" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

## letzten AS mit Rest bebuchen - Hinweis erwartet
    Given I open an editor "RM2_LSS01" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS01_001"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "erbtext1" to "RM2_LSS01" in row 1
    And I save the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA2_LSS01" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=LSS01_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "ja"
    And I close the current editor


  Scenario: LSE01 - Abgeschlossener Fertigungsvorschlag mit gesperrter Komponente - Loeschschutz entfernen
## Voraussetzung: Scenario: LSS01

## Loeschschutz im BA mit gesperrter Komponente und offener Menge entfernen - Fehlermeldung erwartet
    Given I open an editor "BA3_LSS01" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=LSS01_000;@richtung=rückwärts;@maxordtreffer=1"
# 1697 de      |Löschschutz kann nicht entfernt werden, da noch Restmengen vorhanden.
    Then setting field "noloesch" to "nein" throws the exception "1697"
    And I close the current editor


  Scenario: LSS02 - Fertigungsvorschlag mit gesperrter Komponente stornieren - Loeschschutz nicht setzen

## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "LSS02" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | verw      | bisuch |
      | BG-K-SWITCH | 17     | ja     | LSS02_000 | LSS02_ |
    And I press button "freig" to open a subeditor for "FeVo freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA1_LSS02" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=LSS02_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "nein"
    And I close the current editor

## letzten AS teilweise bebuchen
    Given I open an editor "RM1_LSS02" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS02_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "15" in row 1
    And I set field "erbtext1" to "RM1_LSS02" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

## letzten AS OHNE Gutmenge stornieren - BA wird abgelegt/gelöscht
    Given I open an editor "RM2_LSS02" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS02_001"
    And I set field "sofort" to "ja"
    And I set field "erbtext1" to "RM2_LSS02" in row 1
    And I set field "status" to "S" in row 1
    And I save the current editor

## Pruefen, ob FV in der Ablage
    Given I open an editor "FV1_LSS02" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel=BG-K-SWITCH;verw=LSS02_000;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor


  Scenario: LSS03 - Fertigungsvorschlag mit gesperrter Komponente reduzieren - Loeschschutz nicht setzen

## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "LSS03" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | verw      | bisuch |
      | BG-K-SWITCH | 17     | ja     | LSS03_000 | LSS03_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA1_LSS03" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=LSS03_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "nein"
    And I close the current editor

## letzten AS teilweise bebuchen
    Given I open an editor "RM1_LSS03" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS03_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "15" in row 1
    And I set field "erbtext1" to "RM1_LSS03" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

## letzten AS OHNE Gutmenge reduzieren - BA wird abgelegt/gelöscht
    Given I open an editor "RM2_LSS03" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS03_001"
    And I set field "sofort" to "ja"
    And I set field "mgereduzieren" to "ja"
    And I set field "erbtext1" to "RM2_LSS03" in row 1
    And I save the current editor

## Pruefen, ob FV in der Ablage
    Given I open an editor "FV1_LSS03" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel=BG-K-SWITCH;verw=LSS03_000;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor


  Scenario: LSS04 - Fertigungsvorschlag mit gesperrter Komponente stornieren (gesperrtes Teil hat offene Menge) - Loeschschutz setzen

## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "LSS04" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch |
      | BG-K-SWITCH | 17     | ja     | LSS04_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA1_LSS04" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=LSS04_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "nein"
    And I close the current editor

## letzten AS teilweise bebuchen
    Given I open an editor "RM1_LSS04" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS04_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "15" in row 1
    And I set field "erbtext1" to "RM1_LSS04" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

## letzten AS teilweise bebuchen, Artikel ist jetzt gesperrt
    Given I open an editor "RM2_LSS04" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS04_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I set field "erbtext1" to "RM2_LSS04" in row 1
    And I save the current editor

## letzten AS OHNE Gutmenge stornieren - BA wird abgelegt/gelöscht
    Given I open an editor "RM3_LSS04" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS04_001"
    And I set field "sofort" to "ja"
    And I set field "erbtext1" to "RM3_LSS04" in row 1
    And I set field "status" to "S" in row 1
    And I save the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA2_LSS04" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=LSS04_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "ja"
    And I close the current editor


  Scenario: LSS05 - Fertigungsvorschlag mit gesperrter Komponente stornieren (gesperrtes Teil hat offene Menge) - Loeschschutz setzen

## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "LSS05" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch |
      | BG-K-SWITCH | 17     | ja     | LSS05_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA1_LSS05" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=LSS05_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "nein"
    And I close the current editor

## letzten AS teilweise bebuchen
    Given I open an editor "RM1_LSS05" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS05_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "15" in row 1
    And I set field "erbtext1" to "RM1_LSS05" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

## letzten AS teilweise bebuchen, Artikel ist jetzt gesperrt
    Given I open an editor "RM2_LSS05" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS05_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I set field "status" to "S" in row 1
    And I set field "erbtext1" to "RM2_LSS05" in row 1
    And I save the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA2_LSS05" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=LSS05_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "ja"
    And I close the current editor


  Scenario: LSS06 - Fertigungsvorschlag mit gesperrter Komponente Gutmenge buchen und reduzieren (1. Schritt) - Loeschschutz setzen

## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "LSS06" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch |
      | BG-K-SWITCH | 17     | ja     | LSS06_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA1_LSS06" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=LSS06_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "nein"
    And I close the current editor

## letzten AS teilweise bebuchen
    Given I open an editor "RM1_LSS06" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS06_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "15" in row 1
    And I set field "erbtext1" to "RM1_LSS06" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

## letzten AS OHNE Gutmenge reduzieren - BA wird abgelegt/gelöscht
    Given I open an editor "RM2_LSS06" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS06_001"
    And I set field "sofort" to "ja"
    And I set field "mgereduzieren" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I set field "erbtext1" to "RM2_LSS06" in row 1
    And I save the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA2_LSS06" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=LSS06_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "ja"
    And I close the current editor


  Scenario: LSS07 - Fertigungsvorschlag mit gesperrter Komponente Gutmenge buchen und reduzieren (2. Schritte) - Loeschschutz setzen

## Switch-Artikel entsperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "LSS07" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch |
      | BG-K-SWITCH | 19     | ja     | LSS07_ |
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA1_LSS07" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=LSS07_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "nein"
    And I close the current editor

## letzten AS teilweise bebuchen
    Given I open an editor "RM1_LSS07" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS07_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "15" in row 1
    And I set field "erbtext1" to "RM1_LSS07" in row 1
    And I save the current editor

## Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

## letzten AS OHNE Gutmenge reduzieren - BA wird abgelegt/gelöscht
    Given I open an editor "RM2_LSS07" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS07_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I set field "erbtext1" to "RM2_LSS07" in row 1
    And I save the current editor

## letzten AS OHNE Gutmenge reduzieren - BA wird abgelegt/gelöscht
    Given I open an editor "RM3_LSS07" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS07_001"
    And I set field "sofort" to "ja"
    And I set field "mgereduzieren" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I set field "erbtext1" to "RM2_LSS07" in row 1
    And I save the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA2_LSS07" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=LSS07_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "ja"
    And I close the current editor
