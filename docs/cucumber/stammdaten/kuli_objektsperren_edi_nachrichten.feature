# *****************************************************************************
# Name           : kuli_objektsperren_edi_nachrichten.feature
# Verantwortlich : teampss
# Funktion       : Prueft Sperrkonfigurationen, die den Einkauf/Verkauf betreffen.
#
# *****************************************************************************
@persistent
Feature: Test von Sperrkonfigurationen, die EDI-Nachrichten bei KU/LI betreffen

  Background:
    Given I set the fake date to "02.01.1995"
    Given I enable the flag 39

  # ---------------------------------------------------------------------------------------------
  Scenario: EDI einschalten
    # ---------------------------------------------------------------------------------------------
    Given I open an editor "Firma" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
    And I set field "automotive" to "ja"
    And I set field "edi" to "ja"
    And I save the current editor

  # -----------------------------------------------------------------------------
  Scenario: Stammdaten anlegen
    # -----------------------------------------------------------------------------
    # EDI Kunde anlegen
    Given I open an editor "KU003" from table "(Customer):(Customer)" with command "NEW" for record ""
    And I set fields
      | nummer | 1KU003    |
      | such   | KU003     |
      | name   | TESLO     |
      | ans    | TESLO     |
      | nort   | Karlsruhe |
      | plz    | 76133     |
      | waehr  | DEM       |
    And I save the current editor
    # Kundenkontakt
    Given I open an editor "KK003" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
    And I set fields
      | nummer    | 1KK003          |
      | such      | KK003           |
      | firma     | KU003           |
      | name      | TESLO Zentrum 2 |
      | werk      | 2               |
      | ablstelle | Tor 1           |
      | ans       | TESLO AG        |
      | str       | Mozartstr 50    |
      | lakenn    | D               |
      | plz       | 89073           |
      | nort      | Ulm             |
      | gln       | GLN302          |
    And I save the current editor
    Given I open an editor "KK004" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
    And I set fields
      | nummer    | 1KK004          |
      | such      | KK004           |
      | firma     | KU003           |
      | name      | TESLO Zentrum 3 |
      | werk      | 3               |
      | ablstelle | Tor 1           |
      | ans       | TESLO AG        |
      | str       | Eddisonstr 100  |
      | lakenn    | D               |
      | plz       | 89073           |
      | nort      | Ulm             |
      | gln       | GLN303          |
    And I save the current editor
    Given I open an editor "KK005" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
    And I set fields
      | nummer    | 1KK005       |
      | such      | KK005        |
      | firma     | KU003        |
      | name      | TESLO Werk 1 |
      | werk      | W1           |
      | ablstelle | Tor 1        |
      | ans       | TESLO AG     |
      | str       | Eddisonstr 5 |
      | lakenn    | D            |
      | plz       | 86150        |
      | nort      | Augsburg     |
      | gln       | GLN304       |
    And I save the current editor
    Given I open an editor "KK006" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
    And I set fields
      | nummer    | 1KK006        |
      | such      | KK006         |
      | firma     | KU003         |
      | name      | TESLO Werk 2  |
      | werk      | W2            |
      | ablstelle | Tor 1         |
      | ans       | TESLO AG      |
      | str       | Eddisonstr 15 |
      | lakenn    | D             |
      | plz       | 86150         |
      | nort      | Augsburg      |
      | gln       | GLN305        |
    And I save the current editor
    # EDI Lieferant anlegen
    Given I open an editor "LI003" from table "(Vendor):(Vendor)" with command "NEW" for record ""
    And I set fields
      | nummer | 1LI003 |
      | such   | LI003  |
      | name   | BOSCH  |
      | ans    | BOSCH  |
      | nort   | Bühl   |
      | plz    | 7915   |
      | waehr  | DEM    |
    And I save the current editor
    # Lieferantenkontakt
    Given I open an editor "LK003" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
    And I set fields
      | nummer    | 1LK003                |
      | such      | LK003                 |
      | firma     | LI003                 |
      | name      | BOSCH Zentrum 2       |
      | werk      | 2                     |
      | ablstelle | Tor 1                 |
      | ans       | BOSCH AG              |
      | str       | Robert-Bosch-Straße 1 |
      | lakenn    | D                     |
      | plz       | 89073                 |
      | nort      | Ulm                   |
      | gln       | GLN312                |
    And I save the current editor
    Given I open an editor "LK004" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
    And I set fields
      | nummer    | 1LK004                  |
      | such      | LK004                   |
      | firma     | LI003                   |
      | name      | BOSCH Zentrum 3         |
      | werk      | 3                       |
      | ablstelle | Tor 1                   |
      | ans       | BOSCH AG                |
      | str       | Robert-Bosch-Straße 100 |
      | lakenn    | D                       |
      | plz       | 04103                   |
      | nort      | Leipzig                 |
      | gln       | GLN313                  |
    And I save the current editor
    Given I open an editor "LK005" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
    And I set fields
      | nummer    | 1LK005       |
      | such      | LK005        |
      | firma     | LI003        |
      | name      | BOSCH Werk 1 |
      | werk      | W1           |
      | ablstelle | Tor 1        |
      | ans       | BOSCH AG     |
      | str       | Robertweg 5  |
      | lakenn    | D            |
      | plz       | 04103        |
      | nort      | Leipzig      |
      | gln       | GLN314       |
    And I save the current editor
    Given I open an editor "LK006" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
    And I set fields
      | nummer    | 1LK006         |
      | such      | LK006          |
      | firma     | LI003          |
      | name      | BOSCH Werk 2   |
      | werk      | W2             |
      | ablstelle | Tor 1          |
      | ans       | BOSCH AG       |
      | str       | Buschstraße 15 |
      | lakenn    | D              |
      | plz       | 04103          |
      | nort      | Leipzig        |
      | gln       | GLN315         |
    And I save the current editor

  # -----------------------------------------------------------------------------
  Scenario: Sperrkonfiguration setzen bei Kunden setzt EDI-Nachrichten aktiv
    # -----------------------------------------------------------------------------
    Given I open an editor "KundeEDINachrichten" from table "(Customer):(Customer)" with command "UPDATE" for record "KU003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz          | erlaubt | protokoll | edlnum | umplatz |
      | Lieferabruf         | ja      | EDIFACT   | 002    | L3F2    |
      | Auftrag             | ja      | EDIFACT   | 002    | L3F2    |
      | Auftragsänderung    | nein    | EDIFACT   | 002    | L3F2    |
      | Auftragsbestätigung | ja      | EDIFACT   | 002    | L3F2    |
      | Lieferschein        | ja      | EDIFACT   | 002    | L3F2    |
    And I save the current editor
    And I switch the current editor to editor "KundeEDINachrichten"
    And I save the current editor
    # Aktiv-Button der Sperrkonfigration checken
    # Sperrkonfiguration "EDI-Auftrag fuer Kunde" aktiv = false
    Given I open an editor "SperrKfg" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100902"
    # Prozesssperrstelle EDI-Auftrag fuer Kunde deaktivieren
    And I set field "aktiv" to "Nein" in row 2
    And I save the current editor
    # Kunde setzt Sperrkonfiguraton 1
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "KU003"
    And I set field "sperrkonfigurationneu" to "EDI-AU-AB-Nachrichtensperre"
    # Subeditor kann nicht geoeffnet werden, da die Sperrkonfiguration geaendert wurde und nicht gespeichert wurde.
    Then pressing button "edinfo" in row 0 to open a subeditor throws the exception "11064"
    And I save the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "KU003"
    And I set field "bem" to "Keine Bemerkung"
    # Trotz geaendertem Kunden kann der Subdialog geoeffnet werden.
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | nein    | 2           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
    # Sperrkonfiguration "EDI-Auftrag fuer Kunde" aktiv = true
    Given I open an editor "SperrKfg" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100902"
    # Prozesssperrstelle EDI-Auftrag fuer Kunde deaktivieren
    And I set field "aktiv" to "Ja" in row 2
    And I save the current editor
    # Muss sich sofort auswirken auf den Kunden
    # Kunde setzt Sperrkonfiguraton 1
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "KU003"
    And I set field "sperrkonfigurationneu" to "EDI-AU-AB-Nachrichtensperre"
    # Subeditor kann nicht geoeffnet werden, da die Sperrkonfiguration geaendert wurde und nicht gespeichert wurde.
    Then pressing button "edinfo" in row 0 to open a subeditor throws the exception "11064"
    And I save the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 1           |
      | Auftragsbestätigung | nein    | 2           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
    # Testet das Neuanlegen von EDI-Nachrichten bei aktiver Sperrkonfiguration
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "KU003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I delete row at position 5
    And I delete row at position 4
    And I append rows
      | edinachraz          |
      | Auftragsbestätigung |
      | Lieferschein        |
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 1           |
      | Auftragsbestätigung | nein    | 1           |
      | Lieferschein        | nein    | 0           |
    Then field "erlaubt" is not modifiable in row 4
    Then field "erlaubt" is modifiable in row 5
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I save the current editor
    # Kunde setzt Sperrkonfiguraton 1 -> 2
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "KU003"
    And I set field "sperrkonfigurationneu" to "EDI-AU-LS-Nachrichtensperre"
    And I save the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 1           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | nein    | 2           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
    # Kunde setzt Sperrkonfiguraton 2->keine
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "KU003"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Sperrkonfiguration setzen bei Kundenkontakt setzt EDI-Nachrichten aktiv
    # -----------------------------------------------------------------------------
    Given I open an editor "KundenKontaktEDINachrichten" from table "(Customer):(CustomerContact)" with command "UPDATE" for record "KK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz          | erlaubt | protokoll | edlnum | umplatz |
      | Lieferabruf         | nein    | EDIFACT   | 002    | L3F2    |
      | Auftrag             | ja      | EDIFACT   | 002    | L3F2    |
      | Auftragsänderung    | nein    | EDIFACT   | 002    | L3F2    |
      | Auftragsbestätigung | ja      | EDIFACT   | 002    | L3F2    |
      | Lieferschein        | ja      | EDIFACT   | 002    | L3F2    |
    And I save the current editor
    And I switch the current editor to editor "KundenKontaktEDINachrichten"
    And I save the current editor
    # Kundenkontakt setzt Sperrkonfiguraton 1
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "UPDATE" for record "KK003"
    And I set field "sperrkonfigurationneu" to "EDI-AU-AB-Nachrichtensperre-Kont"
    And I save the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 1           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 1           |
      | Auftragsbestätigung | nein    | 2           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kundenkontakt"
    And I close the current editor
    # Kundenkontakt setzt Sperrkonfiguraton 1 -> 2
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "UPDATE" for record "KK003"
    And I set field "sperrkonfigurationneu" to "EDI-AU-LS-Nachrichtensperre-Kont"
    And I save the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 0           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 1           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | nein    | 2           |
    And I close the current editor
    And I switch the current editor to editor "Kundenkontakt"
    And I close the current editor
    # Kundenkontakt setzt Sperrkonfiguraton 2->keine
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "UPDATE" for record "KK003"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kundenkontakt"
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Sperrkonfiguration setzen bei Lieferanten setzt EDI-Nachrichten aktiv
    # -----------------------------------------------------------------------------
    Given I open an editor "LieferantEDINachrichten" from table "(Vendor):(Vendor)" with command "UPDATE" for record "LI003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz          | erlaubt | protokoll |
      | Lieferabruf         | ja      | EDIFACT   |
      | Auftrag             | ja      | EDIFACT   |
      | Auftragsänderung    | nein    | EDIFACT   |
      | Auftragsbestätigung | ja      | EDIFACT   |
      | Lieferschein        | ja      | EDIFACT   |
    And I save the current editor
    And I switch the current editor to editor "LieferantEDINachrichten"
    And I save the current editor
    # Lieferant setzt Sperrkonfiguraton 1
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "LI003"
    And I set field "sperrkonfigurationneu" to "EDI-LA-BE-Nachrichtensperre"
    And I save the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 2           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    # Lieferant setzt Sperrkonfiguraton 1 -> 2
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "LI003"
    And I set field "sperrkonfigurationneu" to "EDI-LA-Nachrichtensperre"
    And I save the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 2           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    # Lieferant setzt Sperrkonfiguraton 2->keine
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "LI003"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Sperrkonfiguration setzen bei Lieferantenkontakten setzt EDI-Nachrichten aktiv
    # -----------------------------------------------------------------------------
    Given I open an editor "LieferantenkontaktEDINachrichten" from table "(Vendor):(VendorContact)" with command "UPDATE" for record "LK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz          | erlaubt | protokoll |
      | Lieferabruf         | ja      | EDIFACT   |
      | Auftrag             | ja      | EDIFACT   |
      | Auftragsänderung    | nein    | EDIFACT   |
      | Auftragsbestätigung | ja      | EDIFACT   |
      | Lieferschein        | ja      | EDIFACT   |
    And I save the current editor
    And I switch the current editor to editor "LieferantenkontaktEDINachrichten"
    And I save the current editor
    # Lieferant setzt Sperrkonfiguraton 1
    Given I open an editor "Lieferant" from table "(Vendor):(VendorContact)" with command "UPDATE" for record "LK003"
    And I set field "sperrkonfigurationneu" to "EDI-LA-BE-Nachrichtensperre-Kont"
    And I save the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 2           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    # Lieferant setzt Sperrkonfiguraton 1 -> 2
    Given I open an editor "Lieferant" from table "(Vendor):(VendorContact)" with command "UPDATE" for record "LK003"
    And I set field "sperrkonfigurationneu" to "EDI-LA-Nachrichtensperre-Kont"
    And I save the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 2           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    # Lieferant setzt Sperrkonfiguraton 2->keine
    Given I open an editor "Lieferant" from table "(Vendor):(VendorContact)" with command "UPDATE" for record "LK003"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK003"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Sperrkonfiguration fuer Kunden aendern und Setzen von EDI-Nachrichten bei betroffenen Kunden
    # -----------------------------------------------------------------------------
    # 3 Kunden anlegen zwei mit EDI Nachrichten eines ohne
    # Alle erhalten die Sperrkonfiguration EDINACHRCUST1
    #
    # Ausgabe der Tabelle EDI-Nachrichten der Kunden mit Tabelle
    #
    # Aenderung 1 Sperrkonfiguration:  EDI-SALES-ORDER-CUSTOMER auf Hinweis aendern nicht erlaubt, stattdessen rausloeschen
    # -> Ausgabe der EDI-Nachrichten
    #
    # Aenderung 2 Sperrkonfiguration:  EDI-SALES-ORDER-CONF-CUSTOMER rausloeschen, dafuer eine andere Prozesssperrstelle und Verweissperrstelle einbauen
    # -> Ausgabe der EDI-Nachrichten
    #
    # Aenderung 3 Sperrkonfiguration:  EDI-PACKING-SLIP-CUSTOMER hinzufuegen mit gesperrt
    # -> Ausgabe der EDI-Nachrichten
    Given I open an editor "KU023" from table "(Customer):(Customer)" with command "NEW" for record ""
    And I set fields
      | nummer | 1KU023          |
      | such   | KU023           |
      | name   | SKFG1           |
      | ans    | Sperr Kfg Kunde |
      | nort   | Karlsruhe       |
      | plz    | 76133           |
      | waehr  | DEM             |
    And I save the current editor
    Given I open an editor "KU023" from table "(Customer):(Customer)" with command "UPDATE" for record from editor "KU023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz          | erlaubt | protokoll | edlnum | umplatz |
      | Lieferabruf         | ja      | EDIFACT   | 002    | L3F2    |
      | Auftrag             | ja      | EDIFACT   | 002    | L3F2    |
      | Auftragsänderung    | nein    | EDIFACT   | 002    | L3F2    |
      | Auftragsbestätigung | ja      | EDIFACT   | 002    | L3F2    |
      | Lieferschein        | ja      | EDIFACT   | 002    | L3F2    |
    And I save the current editor
    And I switch the current editor to editor "KU023"
    And I save the current editor
    Given I open an editor "KU024" from table "(Customer):(Customer)" with command "NEW" for record ""
    And I set fields
      | nummer | 1KU024          |
      | such   | KU024           |
      | name   | SKFG2           |
      | ans    | Sperr Kfg Kunde |
      | nort   | Ettlingen       |
      | plz    | 76133           |
      | waehr  | DEM             |
    And I save the current editor
    Given I open an editor "KU024" from table "(Customer):(Customer)" with command "UPDATE" for record from editor "KU024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz   | erlaubt | protokoll | edlnum | umplatz |
      | Lieferabruf  | ja      | EDIFACT   | 002    | L3F2    |
      | Lieferschein | nein    | EDIFACT   | 002    | L3F2    |
    And I save the current editor
    And I switch the current editor to editor "KU024"
    And I save the current editor
    # Kunde 3 ohne EDI-Nachrichten
    # Keine Auswirkungen einer Aenderung, Keine Diag usw.
    Given I open an editor "KU025" from table "(Customer):(Customer)" with command "NEW" for record ""
    And I set fields
      | nummer | 1KU025          |
      | such   | KU025           |
      | name   | SKFG3           |
      | ans    | Sperr Kfg Kunde |
      | nort   | Hinterwald      |
      | plz    | 00000           |
      | waehr  | DEM             |
    And I save the current editor
    # Sperrkonfigurationen eintragen
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record from editor "KU023"
    And I set field "sperrkonfigurationneu" to "EDI-AU-AB-Nachrichtensperre"
    And I save the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record from editor "KU024"
    And I set field "sperrkonfigurationneu" to "EDI-AU-AB-Nachrichtensperre"
    And I save the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record from editor "KU025"
    And I set field "sperrkonfigurationneu" to "EDI-AU-AB-Nachrichtensperre"
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Kunden
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 1           |
      | Auftragsbestätigung | nein    | 2           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz   | erlaubt | sperrstatus |
      | Lieferabruf  | ja      | 0           |
      | Lieferschein | nein    | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU025"
    Then field "edinfosnr" is empty
    And I close the current editor
    # Aenderung 1 Sperrkonfiguration:  EDI-SALES-ORDER-CUSTOMER auf Hinweis aendern nicht erlaubt, stattdessen rausloeschen
    Given I open an editor "SperrKfg" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100902"
    And I set field "sperrwirkung" to "Hinweis" in row 2
    Then saving the current editor throws the exception "10191"
    And I delete row at position 2
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Kunden
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | nein    | 2           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz   | erlaubt | sperrstatus |
      | Lieferabruf  | ja      | 0           |
      | Lieferschein | nein    | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU025"
    Then field "edinfosnr" is empty
    And I close the current editor
    # Aenderung 2 Sperrkonfiguration:  EDI-SALES-ORDER-CONF-CUSTOMER rausloeschen, dafuer eine andere Prozesssperrstelle und Verweissperrstelle einbauen
    Given I open an editor "SperrKfg" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100902"
    And I delete row at position 2
    And I append rows
      | prozesssperrstelle             | verweissperrstellen        | sperrwirkung |
      | CREATE-COMMISSION-CALC-FOR-REP | !dontChange                | Gesperrt     |
      | !dontChange                    | CUSTOMER-CONTAINER-ACCOUNT | Gesperrt     |
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Kunden
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz   | erlaubt | sperrstatus |
      | Lieferabruf  | ja      | 0           |
      | Lieferschein | nein    | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU025"
    Then field "edinfosnr" is empty
    And I close the current editor
    # Aenderung 3 Sperrkonfiguration:  EDI-PACKING-SLIP-CUSTOMER hinzufuegen mit gesperrt
    Given I open an editor "SperrKfg" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100902"
    And I append rows
      | prozesssperrstelle        | sperrwirkung |
      | EDI-PACKING-SLIP-CUSTOMER | Gesperrt     |
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Kunden
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | nein    | 2           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz   | erlaubt | sperrstatus |
      | Lieferabruf  | ja      | 0           |
      | Lieferschein | nein    | 1           |
    And I close the current editor
    And I switch the current editor to editor "Kunde"
    And I close the current editor
    Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "KU025"
    Then field "edinfosnr" is empty
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Sperrkonfiguration fuer Kundenkontakt aendern und Setzen von EDI-Nachrichten bei betroffenen Kundenkontakten
    # -----------------------------------------------------------------------------
    # 3 Kundenkontakte anlegen zwei mit EDI Nachrichten eines ohne
    # Alle erhalten die Sperrkonfiguration EDINACHRCUSTCONT1
    #
    # Ausgabe der Tabelle EDI-Nachrichten der Kundenkontakten mit Tabelle
    #
    # Aenderung 1 Sperrkonfiguration:  EDI-SALES-ORDER-CUST-CONT auf Hinweis aendern nicht erlaubt, stattdessen rausloeschen, EDI-DELIV-SCHEDULE-CUST-CONT rausloeschen
    # -> Ausgabe der EDI-Nachrichten
    #
    # Aenderung 2 Sperrkonfiguration:  EDI-SALES-ORDER-CONF-CUST-CONT rausloeschen, dafuer eine andere Prozesssperrstelle EDI-PACKING-SLIP-CUST-CONT und Verweissperrstelle einbauen
    # -> Ausgabe der EDI-Nachrichten
    #
    # Aenderung 3 Sperrkonfiguration:  EDI-SALES-ORDER-CONF-CUST-CONT wieder hinzufuegen mit gesperrt
    # -> Ausgabe der EDI-Nachrichten
    Given I open an editor "KK023" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
    And I set fields
      | firma | KU023                   |
      | such  | KK023                   |
      | name  | SKFG1                   |
      | ans   | Sperr Kfg Kundenkontakt |
      | nort  | Karlsruhe               |
      | plz   | 76133                   |
    And I save the current editor
    Given I open an editor "KK023" from table "(Customer):(CustomerContact)" with command "UPDATE" for record from editor "KK023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz          | erlaubt | protokoll | edlnum | umplatz |
      | Lieferabruf         | ja      | EDIFACT   | 002    | L3F2    |
      | Versandabruf        | ja      | EDIFACT   | 002    | L3F2    |
      | Feinabruf           | nein    | EDIFACT   | 002    | L3F2    |
      | Auftrag             | ja      | EDIFACT   | 002    | L3F2    |
      | Auftragsänderung    | nein    | EDIFACT   | 002    | L3F2    |
      | Auftragsbestätigung | ja      | EDIFACT   | 002    | L3F2    |
      | Lieferschein        | ja      | EDIFACT   | 002    | L3F2    |
    And I save the current editor
    And I switch the current editor to editor "KK023"
    And I save the current editor
    Given I open an editor "KK024" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
    And I set fields
      | firma | KU024                   |
      | such  | KK024                   |
      | name  | SKFG2                   |
      | ans   | Sperr Kfg Kundenkontakt |
      | nort  | Ettlingen               |
      | plz   | 76133                   |
    And I save the current editor
    Given I open an editor "KK024" from table "(Customer):(CustomerContact)" with command "UPDATE" for record from editor "KK024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz          | erlaubt | protokoll | edlnum | umplatz |
      | Lieferabruf         | ja      | EDIFACT   | 002    | L3F2    |
      | Lieferschein        | nein    | EDIFACT   | 002    | L3F2    |
      | Auftragsbestätigung | nein    | EDIFACT   | 002    | L3F2    |
    And I save the current editor
    And I switch the current editor to editor "KK024"
    And I save the current editor
    # Kundenkontakt 3 ohne EDI-Nachrichten
    # Keine Auswirkungen einer Aenderung, Keine Diag usw.
    Given I open an editor "KK025" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
    And I set fields
      | firma | KU025                   |
      | such  | KK025                   |
      | name  | SKFG3                   |
      | ans   | Sperr Kfg Kundenkontakt |
      | nort  | Hinterwald              |
      | plz   | 00000                   |
    And I save the current editor
    # Sperrkonfigurationen eintragen
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "UPDATE" for record from editor "KK023"
    And I set field "sperrkonfigurationneu" to "EDI-AU-AB-Nachrichtensperre-Kont"
    And I save the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "UPDATE" for record from editor "KK024"
    And I set field "sperrkonfigurationneu" to "EDI-AU-AB-Nachrichtensperre-Kont"
    And I save the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "UPDATE" for record from editor "KK025"
    And I set field "sperrkonfigurationneu" to "EDI-AU-AB-Nachrichtensperre-Kont"
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Kundenkontakt
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 2           |
      | Versandabruf        | nein    | 2           |
      | Feinabruf           | nein    | 1           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 1           |
      | Auftragsbestätigung | nein    | 2           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kundenkontakt"
    And I close the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 2           |
      | Lieferschein        | nein    | 0           |
      | Auftragsbestätigung | nein    | 1           |
    And I close the current editor
    And I switch the current editor to editor "Kundenkontakt"
    And I close the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK025"
    Then field "edinfosnr" is empty
    And I close the current editor
    # Aenderung 1 Sperrkonfiguration:  EDI-SALES-ORDER-CUST-CONT auf Hinweis aendern nicht erlaubt, stattdessen rausloeschen, EDI-DELIV-SCHEDULE-CUST-CONT rausloeschen
    Given I open an editor "SperrKfg" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100904"
    And I set field "sperrwirkung" to "Hinweis" in row 2
    Then saving the current editor throws the exception "10191"
    And I delete row at position 2
    And I delete row at position 1
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Kundenkontakt
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Versandabruf        | ja      | 0           |
      | Feinabruf           | nein    | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | nein    | 2           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kundenkontakt"
    And I close the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Lieferschein        | nein    | 0           |
      | Auftragsbestätigung | nein    | 1           |
    And I close the current editor
    And I switch the current editor to editor "Kundenkontakt"
    And I close the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK025"
    Then field "edinfosnr" is empty
    And I close the current editor
    # Aenderung 2 Sperrkonfiguration:  EDI-SALES-ORDER-CONF-CUST-CONT rausloeschen, dafuer eine andere Prozesssperrstelle und Verweissperrstelle einbauen
    Given I open an editor "SperrKfg" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100904"
    And I delete row at position 1
    And I append rows
      | prozesssperrstelle         | verweissperrstellen       | sperrwirkung |
      | EDI-PACKING-SLIP-CUST-CONT | !dontChange               | Gesperrt     |
      | !dontChange                | CUST-CONT-CONTAINER-CYCLE | Gesperrt     |
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Kundenkontakt
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Versandabruf        | ja      | 0           |
      | Feinabruf           | nein    | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | nein    | 2           |
    And I close the current editor
    And I switch the current editor to editor "Kundenkontakt"
    And I close the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Lieferschein        | nein    | 1           |
      | Auftragsbestätigung | nein    | 0           |
    And I close the current editor
    And I switch the current editor to editor "Kundenkontakt"
    And I close the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK025"
    Then field "edinfosnr" is empty
    And I close the current editor
    # Aenderung 3 Sperrkonfiguration:  EDI-SALES-ORDER-CONF-CUST-CONT und EDI-DELIV-SCHEDULE-CUST-CONT wieder hinzufuegen mit gesperrt
    Given I open an editor "SperrKfg" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100904"
    And I set field "sperrwirkung" to "Gesperrt" in row 1
    And I append rows
      | prozesssperrstelle             | sperrwirkung |
      | EDI-SALES-ORDER-CONF-CUST-CONT | Gesperrt     |
      | EDI-DELIV-SCHEDULE-CUST-CONT   | Gesperrt     |
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Kundenkontakt
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 2           |
      | Versandabruf        | nein    | 2           |
      | Feinabruf           | nein    | 1           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | nein    | 2           |
      | Lieferschein        | nein    | 2           |
    And I close the current editor
    And I switch the current editor to editor "Kundenkontakt"
    And I close the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 2           |
      | Lieferschein        | nein    | 1           |
      | Auftragsbestätigung | nein    | 1           |
    And I close the current editor
    And I switch the current editor to editor "Kundenkontakt"
    And I close the current editor
    Given I open an editor "Kundenkontakt" from table "(Customer):(CustomerContact)" with command "VIEW" for record "KK025"
    Then field "edinfosnr" is empty
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Sperrkonfiguration fuer Lieferanten aendern und Setzen von EDI-Nachrichten bei betroffenen Lieferanten
    # -----------------------------------------------------------------------------
    # 3 Lieferanten anlegen zwei mit EDI Nachrichten eines ohne
    # Alle erhalten die Sperrkonfiguration EDINACHRVEND1
    #
    # Ausgabe der Tabelle EDI-Nachrichten der Lieferanten mit Tabelle
    #
    # Aenderung 1 Sperrkonfiguration:  EDI-FCST-DELIV-SCHED-VENDOR auf Hinweis aendern nicht erlaubt, stattdessen rausloeschen
    # -> Ausgabe der EDI-Nachrichten
    #
    # Aenderung 2 Sperrkonfiguration:  EDI-PURCHASE-ORDER-VENDOR rausloeschen, dafuer eine andere Prozesssperrstelle und Verweissperrstelle einbauen
    # -> Ausgabe der EDI-Nachrichten
    #
    # Aenderung 3 Sperrkonfiguration:  EDI-PURCHASE-ORDER-VENDOR hinzufuegen mit gesperrt
    # -> Ausgabe der EDI-Nachrichten
    Given I open an editor "LI023" from table "(Vendor):(Vendor)" with command "NEW" for record ""
    And I set fields
      | nummer | 1LI023              |
      | such   | LI023               |
      | name   | SKFG1               |
      | ans    | Sperr Kfg Lieferant |
      | nort   | Karlsruhe           |
      | plz    | 76133               |
      | waehr  | DEM                 |
    And I save the current editor
    Given I open an editor "LI023" from table "(Vendor):(Vendor)" with command "UPDATE" for record from editor "LI023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz          | erlaubt | protokoll | edlnum |
      | Lieferabruf         | ja      | EDIFACT   | 002    |
      | Auftrag             | ja      | EDIFACT   | 002    |
      | Auftragsänderung    | nein    | EDIFACT   | 002    |
      | Auftragsbestätigung | ja      | EDIFACT   | 002    |
      | Lieferschein        | ja      | EDIFACT   | 002    |
    And I save the current editor
    And I switch the current editor to editor "LI023"
    And I save the current editor
    Given I open an editor "LI024" from table "(Vendor):(Vendor)" with command "NEW" for record ""
    And I set fields
      | nummer | 1LI024              |
      | such   | LI024               |
      | name   | SKFG2               |
      | ans    | Sperr Kfg Lieferant |
      | nort   | Ettlingen           |
      | plz    | 76133               |
      | waehr  | DEM                 |
    And I save the current editor
    Given I open an editor "LI024" from table "(Vendor):(Vendor)" with command "UPDATE" for record from editor "LI024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz   | erlaubt | protokoll | edlnum |
      | Lieferabruf  | ja      | EDIFACT   | 002    |
      | Lieferschein | nein    | EDIFACT   | 002    |
    And I save the current editor
    And I switch the current editor to editor "LI024"
    And I save the current editor
    # Kunde 3 ohne EDI-Nachrichten
    # Keine Auswirkungen einer Aenderung, Keine Diag usw.
    Given I open an editor "LI025" from table "(Vendor):(Vendor)" with command "NEW" for record ""
    And I set fields
      | nummer | 1LI025              |
      | such   | LI025               |
      | name   | SKFG3               |
      | ans    | Sperr Kfg Lieferant |
      | nort   | Hinterwald          |
      | plz    | 00000               |
      | waehr  | DEM                 |
    And I save the current editor
    # Sperrkonfigurationen eintragen
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record from editor "LI023"
    And I set field "sperrkonfigurationneu" to "EDI-LA-BE-Nachrichtensperre"
    And I save the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record from editor "LI024"
    And I set field "sperrkonfigurationneu" to "EDI-LA-BE-Nachrichtensperre"
    And I save the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record from editor "LI025"
    And I set field "sperrkonfigurationneu" to "EDI-LA-BE-Nachrichtensperre"
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Lieferanten
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | nein    | 2           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz   | erlaubt | sperrstatus |
      | Lieferabruf  | nein    | 2           |
      | Lieferschein | nein    | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI025"
    Then field "edinfosnr" is empty
    And I close the current editor
    # Aenderung 1 Sperrkonfiguration:  EDI-FCST-DELIV-SCHED-VENDOR auf Hinweis aendern nicht erlaubt, stattdessen rausloeschen
    Given I open an editor "SperrKfg" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100906"
    And I set field "sperrwirkung" to "Hinweis" in row 2
    Then saving the current editor throws the exception "10191"
    And I delete row at position 2
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Lieferanten
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz   | erlaubt | sperrstatus |
      | Lieferabruf  | ja      | 0           |
      | Lieferschein | nein    | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI025"
    Then field "edinfosnr" is empty
    And I close the current editor
    # Aenderung 2 Sperrkonfiguration:  EDI-PURCHASE-ORDER-VENDOR rausloeschen, dafuer eine Verweissperrstelle einbauen
    Given I open an editor "SperrKfg" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100906"
    And I delete row at position 2
    And I append rows
      | prozesssperrstelle | verweissperrstellen    | sperrwirkung |
      | !dontChange        | VENDOR-BIDDING-PROCESS | Gesperrt     |
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Lieferanten
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | ja      | 0           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz   | erlaubt | sperrstatus |
      | Lieferabruf  | ja      | 0           |
      | Lieferschein | nein    | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI025"
    Then field "edinfosnr" is empty
    And I close the current editor
    # Aenderung 3 Sperrkonfiguration:  EDI-PURCHASE-ORDER-VENDOR hinzufuegen mit gesperrt
    Given I open an editor "SperrKfg" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100906"
    And I append rows
      | prozesssperrstelle        | sperrwirkung |
      | EDI-PURCHASE-ORDER-VENDOR | Gesperrt     |
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Lieferanten
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz          | erlaubt | sperrstatus |
      | Lieferabruf         | ja      | 0           |
      | Auftrag             | nein    | 2           |
      | Auftragsänderung    | nein    | 0           |
      | Auftragsbestätigung | ja      | 0           |
      | Lieferschein        | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz   | erlaubt | sperrstatus |
      | Lieferabruf  | ja      | 0           |
      | Lieferschein | nein    | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferant"
    And I close the current editor
    Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "LI025"
    Then field "edinfosnr" is empty
    And I close the current editor

  # -----------------------------------------------------------------------------
  Scenario: Sperrkonfiguration fuer Lieferantenkontakt aendern und Setzen von EDI-Nachrichten bei betroffenen Lieferantenkontakten
    # -----------------------------------------------------------------------------
    # 3 Lieferantenkontakte anlegen zwei mit EDI Nachrichten eines ohne
    # Alle erhalten die Sperrkonfiguration EDINACHRVENDCUST1
    #
    # Ausgabe der Tabelle EDI-Nachrichten der Lieferantenkontakten mit Tabelle
    #
    # Aenderung 1 Sperrkonfiguration:  EDI-FCST-DELIV-SCHED-VEND-CONT auf Hinweis aendern nicht erlaubt, stattdessen rausloeschen
    # -> Ausgabe der EDI-Nachrichten
    #
    # Aenderung 2 Sperrkonfiguration:  EDI-PURCHASE-ORDER-VEND-CONT rausloeschen, dafuer EDI-FCST-DELIV-SCHED-VEND-CONT wieder auf gesperrt setzen und Verweissperrstelle einbauen
    # -> Ausgabe der EDI-Nachrichten
    #
    # Aenderung 3 Sperrkonfiguration:  EDI-PURCHASE-ORDER-VEND-CONT hinzufuegen mit gesperrt
    # -> Ausgabe der EDI-Nachrichten
    Given I open an editor "LK023" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
    And I set fields
      | firma | LI023                        |
      | such  | LK023                        |
      | name  | SKFG1                        |
      | ans   | Sperr Kfg Lieferantenkontakt |
      | nort  | Karlsruhe                    |
      | plz   | 76133                        |
    And I save the current editor
    Given I open an editor "LK023" from table "(Vendor):(VendorContact)" with command "UPDATE" for record from editor "LK023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz       | erlaubt | protokoll | edlnum |
      | Lieferabruf      | ja      | EDIFACT   | 002    |
      | Auftrag          | nein    | EDIFACT   | 002    |
      | Auftragsänderung | ja      | EDIFACT   | 002    |
    And I save the current editor
    And I switch the current editor to editor "LK023"
    And I save the current editor
    Given I open an editor "LK024" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
    And I set fields
      | firma | LI024                        |
      | such  | LK024                        |
      | name  | SKFG2                        |
      | ans   | Sperr Kfg Lieferantenkontakt |
      | nort  | Ettlingen                    |
      | plz   | 76133                        |
    And I save the current editor
    Given I open an editor "LK024" from table "(Vendor):(VendorContact)" with command "UPDATE" for record from editor "LK024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    And I append rows
      | edinachraz  | erlaubt | protokoll | edlnum |
      | Lieferabruf | ja      | EDIFACT   | 002    |
      | Auftrag     | ja      | EDIFACT   | 002    |
    And I save the current editor
    And I switch the current editor to editor "LK024"
    And I save the current editor
    # Lieferantenkontakt 3 ohne EDI-Nachrichten
    # Keine Auswirkungen einer Aenderung, Keine Diag usw.
    Given I open an editor "LK025" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
    And I set fields
      | firma | LI025                        |
      | such  | LK025                        |
      | name  | SKFG3                        |
      | ans   | Sperr Kfg Lieferantenkontakt |
      | nort  | Hinterwald                   |
      | plz   | 00000                        |
    And I save the current editor
    # Sperrkonfigurationen eintragen
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "UPDATE" for record from editor "LK023"
    And I set field "sperrkonfigurationneu" to "EDI-LA-BE-Nachrichtensperre-Kont"
    And I save the current editor
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "UPDATE" for record from editor "LK024"
    And I set field "sperrkonfigurationneu" to "EDI-LA-BE-Nachrichtensperre-Kont"
    And I save the current editor
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "UPDATE" for record from editor "LK025"
    And I set field "sperrkonfigurationneu" to "EDI-LA-BE-Nachrichtensperre-Kont"
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Lieferantenkontakt
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz       | erlaubt | sperrstatus |
      | Lieferabruf      | nein    | 2           |
      | Auftrag          | nein    | 1           |
      | Auftragsänderung | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferantenkontakt"
    And I close the current editor
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz  | erlaubt | sperrstatus |
      | Lieferabruf | nein    | 2           |
      | Auftrag     | nein    | 2           |
    And I close the current editor
    And I switch the current editor to editor "Lieferantenkontakt"
    And I close the current editor
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK025"
    Then field "edinfosnr" is empty
    And I close the current editor
    # Aenderung 1 Sperrkonfiguration:  EDI-FCST-DELIV-SCHED-VEND-CONT auf Hinweis aendern nicht erlaubt, stattdessen rausloeschen
    Given I open an editor "SperrKfg" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100908"
    And I set field "sperrwirkung" to "Hinweis" in row 2
    Then saving the current editor throws the exception "10191"
    And I delete row at position 2
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Lieferantenkontakt
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz       | erlaubt | sperrstatus |
      | Lieferabruf      | ja      | 0           |
      | Auftrag          | nein    | 1           |
      | Auftragsänderung | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferantenkontakt"
    And I close the current editor
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz  | erlaubt | sperrstatus |
      | Lieferabruf | ja      | 0           |
      | Auftrag     | nein    | 2           |
    And I close the current editor
    And I switch the current editor to editor "Lieferantenkontakt"
    And I close the current editor
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK025"
    Then field "edinfosnr" is empty
    And I close the current editor
    # Aenderung 2 Sperrkonfiguration:  EDI-PURCHASE-ORDER-VEND-CONT rausloeschen, dafuer EDI-FCST-DELIV-SCHED-VEND-CONT und eine andere Verweissperrstelle einbauen
    Given I open an editor "SperrKfg" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100908"
    And I delete row at position 2
    And I append rows
        | prozesssperrstelle           | verweissperrstellen            | sperrwirkung |
      | EDI-FCST-DELIV-SCHED-VEND-CONT | !dontChange                    | Gesperrt     |
      | !dontChange                    | VENDOR-CONTACT-SERVICE         | Gesperrt     |
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Lieferantenkontakt
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz       | erlaubt | sperrstatus |
      | Lieferabruf      | nein    | 2           |
      | Auftrag          | nein    | 0           |
      | Auftragsänderung | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferantenkontakt"
    And I close the current editor
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz  | erlaubt | sperrstatus |
      | Lieferabruf | nein    | 2           |
      | Auftrag     | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferantenkontakt"
    And I close the current editor
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK025"
    Then field "edinfosnr" is empty
    And I close the current editor
    # Aenderung 3 Sperrkonfiguration:  EDI-PURCHASE-ORDER-VEND-CONT hinzufuegen mit gesperrt
    Given I open an editor "SperrKfg" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100908"
    And I append rows
      | prozesssperrstelle           | sperrwirkung |
      | EDI-PURCHASE-ORDER-VEND-CONT | Gesperrt     |
    And I save the current editor
    # Pruefe EDI-Nachrichten beim Lieferantenkontakt
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK023"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz       | erlaubt | sperrstatus |
      | Lieferabruf      | nein    | 2           |
      | Auftrag          | nein    | 1           |
      | Auftragsänderung | ja      | 0           |
    And I close the current editor
    And I switch the current editor to editor "Lieferantenkontakt"
    And I close the current editor
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK024"
    And I press button "edinfo" to open a subeditor for "EDIInfo"
    Then table has values
      | edinachraz  | erlaubt | sperrstatus |
      | Lieferabruf | nein    | 2           |
      | Auftrag     | nein    | 2           |
    And I close the current editor
    And I switch the current editor to editor "Lieferantenkontakt"
    And I close the current editor
    Given I open an editor "Lieferantenkontakt" from table "(Vendor):(VendorContact)" with command "VIEW" for record "LK025"
    Then field "edinfosnr" is empty
    And I close the current editor
