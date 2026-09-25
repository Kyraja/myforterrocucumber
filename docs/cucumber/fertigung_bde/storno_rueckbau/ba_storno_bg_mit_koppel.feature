@persistent
Feature: ba_storno_bg_mit_koppel.feature

  Background:
    And I set the fake date to "05.02.1995"

# *****************************************************************************
#  Autor            : Silvia Warth
#  Name             : ba_storno_bg_mit_koppel.feature
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Funktion         : Testet das Stornieren eines Betriebsauftrags mittels S-Kennzeichen im Statusfeld
#  Jira-Issue       : BW2-1787/FDA-4109
# *****************************************************************************

  Scenario: 01 Stammdaten
    Given I open an editor "bewkonfig" from table "(Company):(ValuationConfiguration)" with command "UPDATE" for record "bewert"
    And I append rows
      | bewverf | bewab             | bewzu         |
      | 5       | Preis des Zugangs | Nullbewertung |
    And I save the current editor

# Herstellkostenrelevanz Konto 50000
    Given I open an editor "ko" from table "(Account):(Account)" with command "UPDATE" for record "50000"
    And I set field "hkost" to "ja"
    And I save the current editor
    And I close the current editor

# Artikel mit Fertigungsliste anlegen
    Given I open an editor "Artikel" from table "(Part):(Product)" with command "NEW" for record ""
    And I set field "such" to "bg-mit-koppel"
    And I create a new row at the end of the table
    And I set field "elex" to "E1" in row 1
    And I set field "elanzahl" to "2" in row 1
    And I set field "lge" to "10" in row 1
    And I set field "breite" to "20" in row 1
    And I create a new row at the end of the table
    And I set field "elex" to "A AG1" in row 2
    And I create a new row at the end of the table
    And I set field "elex" to "E2" in row 3
    And I set field "elanzahl" to "4" in row 3
    And I create a new row at the end of the table
    And I set field "elex" to "E3" in row 4
    And I set field "elanzahl" to "1" in row 4
    And I set field "kompeig" to "koppel" in row 4
    And I create a new row at the end of the table
    And I set field "elex" to "A AG2" in row 5
    And I save the current editor
    And I close the current editor

# Lagerplätze in Artikeln angleichen
    Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "e1"
    And I set field "abplatz" to "f1"
    And I save the current editor
    And I close the current editor

    Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "e2"
    And I set field "abplatz" to "f1"
    And I save the current editor
    And I close the current editor

    Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "e3"
    And I set field "abplatz" to "f1"
# Koppelprodukt E3: Nullbewertung
    And I set field "ekbewverf" to "5"
    And I save the current editor
    And I close the current editor

  Scenario: 02 Bestand schaffen
    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set field "artikel" to "E1"
    And I set field "buart" to "Zugang"
    And I set field "beleg" to "L1"
    And I set field "beldat" to "."
    And I set field "wert" to "100"
    And I set field "mge" to "100" in row 1
    And I set field "platz2" to "F1" in row 1
    And I save the current editor

    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set field "artikel" to "E2"
    And I set field "buart" to "Zugang"
    And I set field "beleg" to "L1"
    And I set field "beldat" to "."
    And I set field "wert" to "120"
    And I set field "mge" to "100" in row 1
    And I set field "platz2" to "F1" in row 1
    And I save the current editor

    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set field "artikel" to "E3"
    And I set field "buart" to "Zugang"
    And I set field "beleg" to "L1"
    And I set field "beldat" to "."
    And I set field "wert" to "80"
    And I set field "mge" to "100" in row 1
    And I set field "platz2" to "F1" in row 1
    And I save the current editor

  Scenario: 03 Fertigungsvorschlag anlegen, freigeben und AS rückmelden
    Given I open an editor "fvor1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel       | netmge | bisuch | kstelle | mfreig |
      | bg-mit-koppel | 10     | BGMKO_ | 100000  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor1"
    And I save the current editor

# 1. Rückmeldung auf zweiten Arbeitsgang
    Given I open an editor "Rueckmeldung_002" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGMKO_002"
    And I set field "bem" to "RM_BGMKO"
    And I set field "ma" to "7802"
    And I set field "lgr" to "2"
    And I set field "bzeit" to "2"
    And I set field "mzeit" to "2"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

  Scenario: 04 Kostenbuchungsvorschläge
    Given I create CostEntriesSuggestions "kv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

  Scenario: 05 Storno Rückmeldebelege
    Given I open an editor "StornoAS" via ID from editor "Rueckmeldung_002" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Scenario:06  Kostenbuchungsvorschläge
    Given I create CostEntriesSuggestions "kv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# obwohl alle Bewertungen zum BA gebucht sind und es keine ungebuchten Vorgänge/Bewertungen mehr gibt, liess sich der BA nicht per Eintrag "S" beenden.
# Ursache war das Koppelprodukt, was im KSammler mit Kostenart "Zugang" erscheint
  Scenario: 07 Abbruch des Betriebsauftrags durch S-Eintrag ins Statusfeld
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BGMKO_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "S"
    And I save the current editor
    And I close the current editor






