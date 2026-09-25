# *****************************************************************************
# Name           : fakturaplan_vorbelegung_anzrechnung_lf-233.feature
# Autor          : mibr
# Verantwortlich : teampss
# Funktion       : Erstellen von Anzahlungsrechnungen ueber die Buttons im
# Fakturaplan und korrekte Vorbelegung fuer pwert.
#
# *****************************************************************************
#
Feature: LF-233

  Background:
    Given I set the fake date to "02.01.1995"

  @LF-233 @persistent
  # ----------------------------------------------------------------------------------------------
  Scenario: Neuen Kunden anlegen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Bayram"
    And I set field "such" to "Bayram"
    And I set field "namebspr" to "Bayram Werkzeugbau, Rastatt"
    And I set field "ans" to "Bayram Werkzeugbau GmbH"
    And I set field "str" to "Riedstr. 24-28"
    And I set field "plz" to "76437"
    And I set field "nort" to "Rastatt"
    And I set field "region" to "BADEN"
    And I set field "tele" to "+49 (0) 7222/9456-0"
    And I set field "email" to "info@bayram-corp.de"
    And I set field "betreuer" to "."
    And I set field "ustid" to "DE56454651"
    And I set field "lbed" to "EXW"
    And I set field "zbed" to "201"
    And I save the current editor
    Then field "name" has value "Bayram Werkzeugbau, Rastatt"
    Then field "zbed" has value "201"

  @LF-233 @persistent
  # ----------------------------------------------------------------------------------------------
  Scenario: Neuen Verkaufsartikel anlegen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "traktor10ps"
    And I set field "such" to "traktor10ps"
    And I set field "namebspr" to "Rasentraktor 10 PS"
    And I set field "vkbez" to "Rasentraktor 10 PS"
    And I set field "vbez" to "Rasentraktor 10 PS"
    And I set field "ebez" to "Rasentraktor 10 PS"
    And I set field "vpr" to "10000"
    And I set field "bsart" to "Fremdbeschaffung"
    And I set field "dispoa" to "bedarfsbezogen"
    And I set field "efrist" to "15"
    And I save the current editor
    Then field "such" has value "TRAKTOR10PS"

  @LF-233
  # ----------------------------------------------------------------------------------------------
  Scenario: Testcase AUO10 Auftrag anlegen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Testcase AUO10 (Anzahlungen geplant ohne Faktura)"
    When I create a new row at the end of the table
    And I set field "artex" to id from editor "artikel" in row 1
    And I set field "mge" to "1" in row 1
    And I save the current editor
    Then field "fktaplan" is empty
    Then field "zbed" has value "201"

  @LF-233 @persistent
  # ----------------------------------------------------------------------------------------------
  Scenario: Testcase AUO10 Fakturaplan anlegen
    # ----------------------------------------------------------------------------------------------
    Given I open an editor "fakturaplan" from table "186:3" with command "NEW" for record ""
    And I set field "namebspr" to "Test-Fakturaplan AUO10"
    And I set field "evvorgang" to id from editor "auftrag"
    And I create a new row at the end of the table
    And I set field "reart" to "Anzahlung" in row 1
    And I set field "anzpwert" to "1000" in row 1
    And I set field "ptext" to "1. Anzahlung" in row 1
    And I set field "zbed" to "203" in row 1
    And I create a new row at the end of the table
    And I set field "reart" to "Anzahlung" in row 2
    And I set field "anzpwert" to "2000" in row 2
    And I set field "ptext" to "2. Anzahlung" in row 2
    And I set field "zbed" to "203" in row 2
    And I press button "anzahlungsrechn" to open a subeditor for "anzrecherstellen" in row 1
    And I set field "pwert" to "100" in row 1
    And I respond with answer "Ja" to the dialog with id "4841"
    And I save the current editor
    And I switch the current editor to editor "fakturaplan"
    And I press button "anzahlungsrechn" to open a subeditor for "anzrecherstellen" in row 1
    And I set field "pwert" to "-50" in row 1
    And I respond with answer "Ja" to the dialog with id "4841"
    And I save the current editor
    And I switch the current editor to editor "fakturaplan"
    And I press button "anzahlungsrechn" to open a subeditor for "anzrecherstellen" in row 1
    And I set field "pwert" to "250" in row 1
    And I respond with answer "Ja" to the dialog with id "4841"
    And I save the current editor
    And I switch the current editor to editor "fakturaplan"
    And I press button "anzahlungsrechn" to open a subeditor for "anzrecherstellen" in row 1
    And I set field "pwert" to "-300" in row 1
    And I respond with answer "Ja" to the dialog with id "4841"
    And I save the current editor
    And I switch the current editor to editor "fakturaplan"
    And I press button "anzahlungsrechn" to open a subeditor for "anzrecherstellen" in row 1
    Then field "pwert" has value "1000.00" in row 1

  # ----------------------------------------------------------------------------------------------
  Scenario: Unterschiedliche Steuersaetze bei Schlussrechnung - stornierte Anzahlungen ignorieren
    # ----------------------------------------------------------------------------------------------
    #
    # Auftrag mit Fakturaplan anlegen
    Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "euland"
    And I set fields
      | such     | euland     |
      | namebspr | EU-Land    |
      | ans      | Hier       |
      | str      | Dort 10    |
      | plz      | 77777      |
      | nort     | Paris      |
      | staat    | Frankreich |
      | ustid    |            |
      | lbed     | exw        |
      | zbed     | 200        |
    And I save the current editor
    Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "artikel1"
    And I set fields
      | such     | artikel1  |
      | namebspr | Artikel 1 |
      | vpr      | 50        |
      | intrarel | FALSE     |
    And I save the current editor
    #
    # Kontensteuerregel VKEUFREI erweitern
    Given I open an editor "kontenstrgl" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7002"
    And I append rows
      | vrgstrgl | belteartdleist | strgl       |
      | VKEUSTFR | Nein           | VKEUIRRELEV |
    And I save the current editor
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Auftrag mit Anzahlung"
    And I set field "such" to "ANZPOS"
    And I create a new row at the end of the table
    And I set field "artex" to id from editor "artikel" in row 1
    And I set field "mge" to "10" in row 1
    And I save the current editor
    #
    # Fakturaplan anlegen
    Given I open an editor "fakturaplan1" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
    And I set field "evvorgang" to id from editor "auftrag"
    And I set field "namebspr" to "Fakturaplan"
    And I create a new row at the end of the table
    And I set field "reart" to "Anzahlung" in row 1
    And I set field "proz" to "10" in row 1
    And I set field "ptext" to "1. Anzahlung" in row 1
    #
    # Anzahlungsrechnung anlegen
    And I press button "anzahlungsrechn" to open a subeditor for "anz1rechnung" in row 1
    And I set field "such" to "Anz1"
    And I set field "ueb" to "ja"
    And I set field "betreff" to "1. Anzahlungsrechnung"
    And I respond with answer "Ja" to the dialog with id "4841"
    And I save the current editor
    And I switch the current editor to editor "fakturaplan1"
    And I save the current editor
    #
    # Anzahlungsrechnung stornieren
    Given I open an editor "stornorechnung" from table "(Sales):(Invoice)" with command "REVERSAL" for record "anz1;@ablageart=abgelegt"
    And I set field "betreff" to "Storno-Anzahlungsrechnung"
    And I save the current editor
    #
    # USTID im Kunden nachtragen
    Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "euland"
    And I set field "ustid" to "FR123456789"
    And I save the current editor
    #
    # Fakturaplan um weitere Position erweitern
    Given I open an editor "fakturaplan2" from table "(BillingPlan):(BillingPlan)" with command "UPDATE" for record from editor "fakturaplan1"
    And I create a new row at the end of the table
    And I set field "reart" to "Anzahlung" in row 2
    And I set field "proz" to "10" in row 2
    #
    # Anzahlungsrechnung anlegen
    And I press button "anzahlungsrechn" to open a subeditor for "anz2rechnung" in row 2
    And I set field "kunde" to "euland"
    And I set field "such" to "Anz2"
    And I set field "ueb" to "ja"
    And I set field "betreff" to "2. Anzahlungsrechnung"
    And I respond with answer "Ja" to the dialog with id "4841"
    And I save the current editor
    And I switch the current editor to editor "fakturaplan2"
    And I save the current editor
    #
    # Schlussrechnung anlegen
    Given I open an editor "rechnung" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "auftrag"
    And I set field "kunde" to "euland"
    And I set field "ueb" to "ja"
    And I press button "offueb" in row 1
    And I respond with answer "Ja" to the dialog with id "4841"
    And I save the current editor
    #
    # Schlussrechnung stornieren
    Given I open an editor "stornorechnung" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung"
    And I set field "betreff" to "Storno-Schlussrechnung"
    # Hier kommt KEIN Fehler wegen unterschiedlicher Steuersaetze, da Stornovorgaenge ignoriert werden.
    And I save the current editor
