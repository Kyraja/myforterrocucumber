@persistent
Feature: reparaturauftrag.feature

  # *****************************************************************************
  # Name             : reparaturauftrag.feature
  # Autor            : amk
  # Verantwortlich   : amk
  # Kontrolle        : drpf
  # Funktion         : Tested den Reparaturauftrag in der Fertigung
  # *****************************************************************************
  Scenario: REPA01 Storno und Neuanlage eines FV aus einem Reparaturauftrag
    # Serviceprodukt anlegen
    Given I open an editor "SPROD01" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
    And I set field "such" to "SPROD01"
    And I set field "artikel" to "V1"
    And I save the current editor
    # Reparaturauftrag
    Given I open an editor "REPANEU01" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
    And I set field "kunde" to "1"
    And I set field "such" to "REPA01"
    And I set field "vserprod" to "SPROD01"
    And I append rows
      | serprod     | artikel      | mge         | verw    |
      | SPROD01     | V1           | !dontChange | absteig |
      | !dontChange | OELWECHSEL_G | 1           | absteig |
    And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    And I save the current editor
    And I switch the current editor to editor "REPANEU01"
    And I save the current editor
    # Fertigungsvorschlag stornieren
    Given I open an editor "fvor" from table "(Purchasing)" with command "UPDATE" for search criteria "$,,artikel=OELWECHSEL_G;verw=absteig;@maxtreffer=1"
    And I respond with answer "ja" to the dialog with id "396"
    And I set field "mge" to "0"
    And I save the current editor
    # Absteigen aus dem Reparaturauftrag
    # Erzeugt DIAG:
    # Fehlermeldung:
    # NULLREF:
    # Falsche Datenbank-/Satznummer!
    # Fehlernummer -123: in C/db/datei.cpp:723 in do_datei_fehler()
    Given I open an editor "REPAUPD01" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "REPANEU01"
    And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    And I save the current editor
    And I switch the current editor to editor "REPAUPD01"
    And I save the current editor
