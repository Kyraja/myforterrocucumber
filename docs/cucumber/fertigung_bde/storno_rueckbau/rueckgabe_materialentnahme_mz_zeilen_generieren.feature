@persistent
Feature: rueckgabe_materialentnahmen_mz_zeilen_generieren.feature

  Background:
    Given I enable the flag 42
    And I set the fake date to "03.02.1995"
# fake dates können mit std/test/fake_date_subst_in_cucumber.pl gepflegt werden. anleitung s. dort


# ***********************************************************************************
#  Name             : rueckgabe_materialentnahmen_mz_zeilen_generieren
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet die Rückgabe von Material über Materialzuordnung
#                     mit den MZ-Vorschlags- bzw. Ergänzenbuttons
#  Jira-Issue       : FDA-1063
# ***********************************************************************************

# Plausichecks


  Scenario: P01 Bei leerer Tabelle oder zuomge=0 kann der Button burueckmzzuord nicht gedrückt werden
  # Fertigungsvorschlag anlegen und freigebn
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch    |
      | M_BAUGRUPPE | 10  | ja     | KEINEMGE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KEINEMGE_001"
    And I close the current editor

  # Materialentnahme über Teilmenge, Journaleinträge öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | 8                  |
    And I press button "stlvblad"
    And I save the current editor

  # Materialrückgabe über burueckmzerg
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    Then the table has 1 rows

    # Fehlermeldungen beim Drücken des Buttons für zuomge=0
    And I set field "zuomge" to "0" in row 1
    Then pressing button "burueckmzzuord" throws the exception "101"

    # Fehlermeldungen beim Drücken des Buttons für leere Tabelle; Fehler 101
    And I delete all rows
    Then pressing button "burueckmzzuord" throws the exception "101"

    And I close the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I close the current editor

    # Betriebsauftrag abbrechen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "KEINEMGE_000"
    And I respond with answer "ja" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P02 Über generierten Zeilen der MZ kann nicht zu viel Material zurückgegeben werden
  # Fertigungsvorschlag anlegen und freigebn
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch     |
      | M_BAUGRUPPE | 10  | ja     | ZUVIELMAT_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZUVIELMAT_001"
    And I close the current editor

  # Materialentnahme über Teilmenge, Journaleinträge öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | 8                  |
    And I press button "stlvblad"
    And I save the current editor

  # Materialrückgabe über burueckmzerg
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I press button "burueckmzzuord"
    Then table has values
      | zuomge | restmge | !row |
      | -8     | -8      | 1    |

    # zuomge > restmge führt zu Fehler: burueckmzzuord
    # Fehler 3917: Rückliefermenge zu hoch.
    Then setting field "zuomge" to "-100" in row 1 throws the exception "3917"

    # zuomge > restmge führt zu Fehler: burueckmzerg
    # Fehler 3917: Rückliefermenge zu hoch.
    And I press button "burueckmzerg"
    Then setting field "zuomge" to "-100" in row 2 throws the exception "3917"

    And I close the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I close the current editor

    # Betriebsauftrag abbrechen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZUVIELMAT_000"
    And I respond with answer "ja" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P03 In den generierten Zeilen der MZ können keine gemischten Vorzeichen angegeben werden
  # Fertigungsvorschlag anlegen und freigebn
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch     |
      | M_BAUGRUPPE | 10  | ja     | PLUSMINUS_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "PLUSMINUS_001"
    And I close the current editor

  # Materialentnahme über Teilmenge, Journaleinträge öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | 8                  |
    And I press button "stlvblad"
    And I save the current editor

  # Materialrückgabe über burueckmzerg
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I press button "burueckmzerg"
    Then table has values
      | zuomge | restmge | !row |
      | -8     | 0       | 1    |

    # in generierter Zeile kann kein positiver Wert eingetragen werden
    # Fehler: 10984: Positive Menge bei Rücklieferungen nicht erlaubt.
    Then setting field "zuomge" to "10" in row 1 throws the exception "10984"

    # in neuer Zeile kann kein positiver Wert eingetragen werden
    # Fehler 10984: Positive Menge bei Rücklieferungen nicht erlaubt.
    And I create a new row at the end of the table
    Then setting field "zuomge" to "10" in row !lastRow throws the exception "10984"

    And I close the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I close the current editor

    # Betriebsauftrag abbrechen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "PLUSMINUS_000"
    And I respond with answer "ja" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P04 In den generierten Zeilen der MZ kann nichts angegeben werden, das nicht gebucht wurde, bspw Charge
   # Chargen anlegen
    Given I create a Lot "FALSCHE_CH" for Product "EINKAUF-1"

  # Fertigungsvorschlag anlegen und freigebn
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch     |
      | M_BAUGRUPPE | 10  | ja     | FALSCHECH_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FALSCHECH_001"
    And I close the current editor

  # Materialentnahme über Teilmenge, Journaleinträge öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | 8                  |
    And I press button "stlvblad"
    And I save the current editor

  # Materialrückgabe über burueckmzerg
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I press button "burueckmzerg"

  # Fehler beim Eintragen einer nicht entnommene Charge
  # Fehler: 4066: Sie wollen Material zurückgeben, das zu diesem Vorgang noch nicht gebucht wurde. Passen Sie Menge oder Artikeleigenschaft an.
    And I set field "charge" to "!FALSCHE_CH" in row 1
    Then saving the current editor throws the exception "4066"

    And I close the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I close the current editor

  # Betriebsauftrag abbrechen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALSCHECH_000"
    And I respond with answer "ja" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor





 # Prozesstests

  Scenario: 01 Materialzuordnung für Materialrückgabe über burueckmzerg mit unterschiedlichen Plätzen
  # Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-01"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "KORR-01"

  # Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag01" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "rechnung01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ueb    | ja         |
      | fakt   | ja         |
      | ebeleg | Rechnung01 |
    And I delete all rows
    And I append rows
      | artikel   | mge | platz |
      | EINKAUF-1 | 10  | F1    |
      | EINKAUF-1 | 10  | F2    |
      | EINKAUF-2 | 10  | F1    |
    And I set field "verw" in row 1 to "verw" from editor "auftrag01" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag01" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag01" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

  # Fertigungsvorschlag anlegen und freigebn
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig |
      | M_BAUGRUPPE | 10  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag01" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | zuomge | lpsuch | !row |
      | 10     | F1     | +1   |
      | 10     | F2     | +2   |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MZPLAETZE1_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MZPLAETZE1_001"
    And I close the current editor

  # Materialentnahme über Teilmenge, Journaleinträge öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | 8                  |
    And I press button "stlvblad"
    And I modify table
      | !row | ljtext1   |
      | 1    | Entnahme1 |
      | 2    | Entnahme2 |
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MZPLAETZE1_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-F1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;erbtext1=Entnahme1;platz=F1;@richtung=rückwärts;@maxtreffer=1"
    Then field "mge" has value "10"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-F2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;erbtext1=Entnahme1;platz=F2;@richtung=rückwärts;@maxtreffer=1"
    Then field "mge" has value "6"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    And I close the current editor

  # Materialrückgabe über burueckmzerg
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I modify table
      | !row | ljtext1   |
      | 1    | Rückgabe1 |
      | 2    | Rückgabe2 |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I press button "burueckmzerg"
    Then the table has 3 rows
    Then table has values
      | !row | lpsuch | zuomge | restmge | ljorig^id          |
      | 1    |        | -8     | 0       | (0,0,0)            |
      | 2    |        | 0      | -6      | !LJ-EINKAUF1-F2^id |
      | 3    |        | 0      | -10     | !LJ-EINKAUF1-F1^id |
    And I modify table
      | !row | zuomge | lpsuch |
      | 1    | 0      |        |
      | 2    | -4     | F2     |
      | 3    | -4     | F1     |
    Then table has values
      | !row | lpsuch | zuomge | restmge | ljorig^id          |
      | 1    |        | 0      | 0       | (0,0,0)            |
      | 2    | F2     | -4     | -2      | !LJ-EINKAUF1-F2^id |
      | 3    | F1     | -4     | -6      | !LJ-EINKAUF1-F1^id |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

  # LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
      | artikel  | EINKAUF-1              |
    And I press start
    Then table has values
      | vplatz | amge | rueckmge | restmge | detursache                 | !row |
      | F1     | -2   | -2       | 0       | Materialrückgabe Fertigung | 1    |
      | F1     | -2   | -2       | 0       | Materialrückgabe Fertigung | 2    |
      | F2     | -4   | -4       | 0       | Materialrückgabe Fertigung | 3    |
      | F2     | 6    | 6        | 0       | Materialentnahme Fertigung | 4    |
      | F1     | 10   | 2        | 8       | Materialentnahme Fertigung | 5    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "rueckorig^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 6 rows
    Then table has values
      | lemge | lplatz | gebmge | kopfzugvorg^id | !row |
      | 4     | F1     |        | (0,0,0)        | 1    |
      |       | F1     | 2      | !rechnung01^id | 2    |
      |       | F1     | 2      | !rechnung01^id | 3    |
      | 8     | F2     |        | (0,0,0)        | 4    |
      |       | F2     | 4      | !rechnung01^id | 5    |
      |       | F2     | 4      | !rechnung01^id | 6    |
    And I close the current editor

  # Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^id |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | lpsuch | zuomge | !row |
      | F1     | 4      | 1    |
      | F2     | 8      | +2   |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZPLAETZE1_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag01" with PackingSlip "liefer01"


  Scenario: 02 Materialzuordnung für Materialrückgabe über burueckmzerg mit scharfer und unscharfer Verwendung
  # Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-02"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "KORR-02"

  # Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag02" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "rechnung02" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ueb    | ja         |
      | fakt   | ja         |
      | ebeleg | Rechnung02 |
    And I delete all rows
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 10  |
      | EINKAUF-1 | 10  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag02" in row 1
    And I set field "verw" in row 2 to "nummer" from editor "auftrag02" in row 0
    And I set field "verw" in row 3 to "verw" from editor "auftrag02" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

  # Fertigungsvorschlag anlegen und freigebn
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch  |
      | M_BAUGRUPPE | 10  | ja     | MZVERW_ |
    And I set field "verw" in row 1 to "verw" from editor "auftrag02" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MZVERW_001"
    And I close the current editor

  # Materialentnahme über Teilmenge, Journaleinträge öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | 8                  |
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MZVERW_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-Unscharf" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;mge=6;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    Then field "verw" has value equal to field "verw" from editor "auftrag02" in row 1
    Then field "verwla" has value equal to field "nummer" from editor "auftrag02" in row 0
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-Scharf" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;mge=10;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    Then field "verw" has value equal to field "verw" from editor "auftrag02" in row 1
    Then field "verwla" has value equal to field "verw" from editor "auftrag02" in row 1
    And I close the current editor

  # Materialrückgabe über burueckmzerg
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I modify table
      | !row | ljtext1   |
      | 1    | Rückgabe1 |
      | 2    | Rückgabe2 |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I press button "burueckmzerg"
    Then the table has 3 rows
    Then table has values
      | !row | zuomge | restmge | ljorig^id                |
      | 1    | -8     | 0       | (0,0,0)                  |
      | 2    | 0      | -6      | !LJ-EINKAUF1-Unscharf^id |
      | 3    | 0      | -10     | !LJ-EINKAUF1-Scharf^id   |
    And I modify table
      | !row | zuomge |
      | 1    | 0      |
      | 2    | -4     |
      | 3    | -4     |
    Then table has values
      | !row | zuomge | restmge | ljorig^id                |
      | 1    | 0      | 0       | (0,0,0)                  |
      | 2    | -4     | -2      | !LJ-EINKAUF1-Unscharf^id |
      | 3    | -4     | -6      | !LJ-EINKAUF1-Scharf^id   |
    Then field "verw" in row 2 has value equal to field "nummer" from editor "auftrag02" in row 0
    Then field "verw" in row 3 has value equal to field "verw" from editor "auftrag02" in row 1
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

  # LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
      | artikel  | EINKAUF-1              |
    And I press start
    Then table has values
      | amge | rueckmge | restmge | detursache                 | !row |
      | -2   | -2       | 0       | Materialrückgabe Fertigung | 1    |
      | -2   | -2       | 0       | Materialrückgabe Fertigung | 2    |
      | -4   | -4       | 0       | Materialrückgabe Fertigung | 3    |
      | 6    | 6        | 0       | Materialentnahme Fertigung | 4    |
      | 10   | 2        | 8       | Materialentnahme Fertigung | 5    |
    Then field "verwla" in row 1 has value equal to field "verw" from editor "auftrag02" in row 1
    Then field "verwla" in row 2 has value equal to field "nummer" from editor "auftrag02" in row 1
    Then field "verwla" in row 3 has value equal to field "nummer" from editor "auftrag02" in row 0
    And I close the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 5 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id | verw              | !row |
      | 12    |        | (0,0,0)        |                   | 1    |
      |       | 4      | !rechnung02^id | !auftrag02^nummer | 2    |
      |       | 4      | !rechnung02^id | !auftrag02^nummer | 3    |
      |       | 2      | !rechnung02^id | !auftrag02^nummer | 4    |
      |       | 2      | !rechnung02^id | !auftrag02^verw   | 5    |
    And I close the current editor

  # Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZVERW_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag02" with PackingSlip "liefer02"


  Scenario: 03 Materialzuordnung für Materialrückgabe über burueckmzerg mit Chargen
  # Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-03"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "KORR-03"

    # Chargen anlegen
    Given I create a Lot "MZ_CHARGE1" for Product "EINKAUF-1"
    Given I create a Lot "MZ_CHARGE2" for Product "EINKAUF-1"

  # Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag03" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "rechnung03" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ueb    | ja         |
      | fakt   | ja         |
      | ebeleg | Rechnung03 |
    And I delete all rows
    And I append rows
      | artikel   | mge | charge         |
      | EINKAUF-1 | 10  | !MZ_CHARGE1^id |
      | EINKAUF-1 | 10  | !MZ_CHARGE2^id |
      | EINKAUF-2 | 10  | !dontChange    |
    And I set field "verw" in row 1 to "verw" from editor "auftrag03" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag03" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag03" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

  # Fertigungsvorschlag anlegen und freigebn
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig |
      | M_BAUGRUPPE | 10  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag03" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | !row | zuomge | charge         |
      | +1   | 10     | !MZ_CHARGE1^id |
      | +2   | 10     | !MZ_CHARGE2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MZCHARGE_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MZCHARGE_001"
    And I close the current editor

  # Materialentnahme über Teilmenge, Journaleinträge öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | 8                  |
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MZCHARGE_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-CH2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;mge=6;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    Then table has values
      | vcharge^id     |
      | !MZ_CHARGE2^id |
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-CH1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;mge=10;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    Then table has values
      | vcharge^id     |
      | !MZ_CHARGE1^id |
    And I close the current editor

  # Materialrückgabe über burueckmzerg
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I modify table
      | !row | rescharge        | ljtext1   |
      | 1    | !MZ_CHARGE1^id   | Rückgabe1 |
      | 2    | (0,0,0)......... | Rückgabe2 |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I press button "burueckmzerg"
    Then the table has 2 rows
    And I modify table
      | !row | zuomge |
      | 1    | 0      |
      | 2    | -4     |
    Then table has values
      | !row | zuomge | restmge | ljorig^id           | charge^id      |
      | 1    | 0      | 0       | (0,0,0)             | !MZ_CHARGE1^id |
      | 2    | -4     | -6      | !LJ-EINKAUF1-CH1^id | !MZ_CHARGE1^id |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

  # LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
      | artikel  | EINKAUF-1              |
    And I press start
    Then table has values
      | amge | rueckmge | restmge | detursache                 | vcharge^such | !row |
      | -4   | -4       | 0       | Materialrückgabe Fertigung | MZ_CHARGE1   | 1    |
      | 6    | 0        | 6       | Materialentnahme Fertigung | MZ_CHARGE2   | 2    |
      | 10   | 4        | 6       | Materialentnahme Fertigung | MZ_CHARGE1   | 3    |
    And I close the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id | charge^such | !row |
      | 8     |        | (0,0,0)        |             | 1    |
      |       | 4      | !rechnung03^id | MZ_CHARGE2  | 2    |
      |       | 4      | !rechnung03^id | MZ_CHARGE1  | 3    |
    And I close the current editor

  # Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^id |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | zuomge | charge         | !row |
      | 4      | !MZ_CHARGE1^id | 1    |
      | 4      | !MZ_CHARGE2^id | +2   |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZCHARGE_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag03" with PackingSlip "liefer03"


  Scenario: 04 Materialzuordnung für Materialrückgabe über burueckmzerg mit Behältern
  # Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-04"

    # Behälter anlegen
    Given I create a Container "BEHAELTER1" for packaging material "BEHAELTER"
    Given I create a Container "BEHAELTER2" for packaging material "BEHAELTER"

  # Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag04" for Customer "RADSHOP" with Product "M_BG-BEHAELTER" and quantity "10"

    Given I open an editor "rechnung04" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ueb    | ja         |
      | fakt   | ja         |
      | ebeleg | Rechnung04 |
    And I delete all rows
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 10  |
      | EINKAUF-1 | 10  |
      | EINKAUF-2 | 10  |
      | BEHAELTER | 2   |
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!BEHAELTER1^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!BEHAELTER2^nummer" in row 2
    And I set field "verw" in row 1 to "verw" from editor "auftrag04" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag04" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag04" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

  # Fertigungsvorschlag anlegen und freigebn
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel        | mge | mfreig |
      | M_BG-BEHAELTER | 10  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag04" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | !row | zuomge | behaelter      |
      | +1   | 10     | !BEHAELTER1^id |
      | +2   | 10     | !BEHAELTER2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MZBEH_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MZBEH_001"
    And I close the current editor

  # Materialentnahme über Teilmenge, Journaleinträge öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | 8                  |
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MZBEH_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-BEH2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;mge=6;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    Then field "behaelter^id" has value "!BEHAELTER2^id"
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-BEH1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;mge=10;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    Then field "behaelter^id" has value "!BEHAELTER1^id"
    And I close the current editor

  # Materialrückgabe über burueckmzerg
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I modify table
      | !row | ljtext1   |
      | 1    | Rückgabe1 |
      | 2    | Rückgabe2 |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I press button "burueckmzerg"
    Then the table has 3 rows
    And I modify table
      | !row | zuomge | behaelter      |
      | 1    | 0      |                |
      | 2    | -4     | !BEHAELTER2^id |
      | 3    | -4     | !BEHAELTER1^id |
    Then table has values
      | !row | zuomge | restmge | ljorig^id            | behaelter^id   |
      | 1    | 0      | 0       | (0,0,0)              | (0,0,0)        |
      | 2    | -4     | -2      | !LJ-EINKAUF1-BEH2^id | !BEHAELTER2^id |
      | 3    | -4     | -6      | !LJ-EINKAUF1-BEH1^id | !BEHAELTER1^id |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

  # LJ, Bestand und Behälter prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
      | artikel  | EINKAUF-1              |
    And I press start
    Then table has values
      | amge | rueckmge | restmge | detursache                 | behaelter^such | !row |
      | -2   | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER1     | 1    |
      | -2   | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER1     | 2    |
      | -4   | -4       | 0       | Materialrückgabe Fertigung | BEHAELTER2     | 3    |
      | 6    | 6        | 0       | Materialentnahme Fertigung | BEHAELTER2     | 4    |
      | 10   | 2        | 8       | Materialentnahme Fertigung | BEHAELTER1     | 5    |
    And I close the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | behaelter  | ja        |
      | details    | nein      |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | tbehaelter^such | !row |
      | 4      | BEHAELTER1      | 1    |
      | 8      | BEHAELTER2      | 2    |
    And I close the current editor

    Given I switch the current editor to editor "BEHAELTER1"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 4   |
    And I close the current editor
    Given I switch the current editor to editor "BEHAELTER2"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 8   |
    And I close the current editor

  # Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^id |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I modify table
      | zuomge | behaelter      | !row |
      | 4      | !BEHAELTER1^id | +1   |
      | 8      | !BEHAELTER2^id | +2   |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZBEH_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    Then Container from editor "BEHAELTER1" is empty
    Then Container from editor "BEHAELTER2" is empty

    And I deliver the SalesOrder "auftrag04" with PackingSlip "liefer04"


  Scenario: 05 Materialzuordnung für Materialrückgabe über burueckmzerg mit Einheiten und Behältern, Handelseinheit und Lagereinheit
  # Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "KORR-05"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "KORR-05"

  # Behälter anlegen
    Given I create a Container "BEHAELTER3" for packaging material "BEHAELTER"
    Given I create a Container "BEHAELTER4" for packaging material "BEHAELTER"

  # Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag05" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "10"

    Given I open an editor "rechnung05" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ueb    | ja         |
      | fakt   | ja         |
      | ebeleg | Rechnung05 |
    And I delete all rows
    And I append rows
      | artikel    | mge |
      | GEBINDE    | 25  |
      | GEBINDE    | 25  |
      | GEBINDEPFL | 3   |
      | GEBINDEPFL | 2   |
      | EINKAUF-1  | 10  |
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!BEHAELTER3^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!BEHAELTER4^nummer" in row 2
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!BEHAELTER3^nummer" in row 3
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!BEHAELTER4^nummer" in row 4
    And I set field "verw" in row 1 to "verw" from editor "auftrag05" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag05" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag05" in row 1
    And I set field "verw" in row 4 to "verw" from editor "auftrag05" in row 1
    And I set field "verw" in row 5 to "verw" from editor "auftrag05" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

  # Fertigungsvorschlag anlegen und freigebn
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig |
      | BG-GEBINDE | 10  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag05" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | !row | zuomge | behaelter      |
      | +1   | 5      | !BEHAELTER3^id |
      | +2   | 5      | !BEHAELTER4^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | einh | behaelter      |
      | +1   | 3      | Paar | !BEHAELTER3^id |
      | +2   | 2      | Paar | !BEHAELTER4^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MZEINHEIT_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MZEINHEIT_001"
    And I close the current editor

  # Materialentnahme über Teilmenge, Journaleinträge öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | autorment   | ja                 |
      | gmgevorschl | 8                  |
    And I press button "stlvblad"
    And I set field "ljtext1" to "Behälter" in row 1
    And I set field "ljtext1" to "Behälter" in row 2
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MZEINHEIT_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "LJ-GEBINDE-BEH4" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=GEBINDE;erbtext1=Behälter;mge=3;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    And I close the current editor

    Given I open an editor "LJ-GEBINDE-BEH3" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=GEBINDE;erbtext1=Behälter;mge=5;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    And I close the current editor

    Given I open an editor "LJ-GEBINDEPFL-BEH4" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=GEBINDEPFL;erbtext1=Behälter;mge=2;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    And I close the current editor

    Given I open an editor "LJ-GEBINDEPFL-BEH3" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=GEBINDEPFL;erbtext1=Behälter;mge=6;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    And I close the current editor

  # Materialrückgabe über burueckmzerg in Handelseinheit kg und Paar
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | autorment   | ja                 |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I modify table
      | !row | ljtext1    | manbu |
      | 1    | Rückgabe1a | ja    |
      | 2    | Rückgabe1b | ja    |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I press button "burueckmzerg"
    Then the table has 3 rows
    And I modify table
      | !row | einh        | zuomge | behaelter      |
      | 1    | !dontChange | 0      |                |
      | 2    | kg          | -10    | !BEHAELTER4^id |
      | 3    | kg          | -10    | !BEHAELTER3^id |
    Then table has values
      | !row | zuomge | einh  | restmge | ljorig^id           | behaelter^id   |
      | 1    | 0      | Stück | 0       | (0,0,0)             | (0,0,0)        |
      | 2    | -10    | kg    | -5      | !LJ-GEBINDE-BEH4^id | !BEHAELTER4^id |
      | 3    | -10    | kg    | -15     | !LJ-GEBINDE-BEH3^id | !BEHAELTER3^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "Materialzuordnung"
    And I press button "burueckmzerg"
    Then the table has 3 rows
    And I modify table
      | !row | einh        | zuomge | behaelter      |
      | 1    | !dontChange | 0      |                |
      | 2    | Paar        | -1     | !BEHAELTER3^id |
      | 3    | Paar        | -1     | !BEHAELTER4^id |
    Then table has values
      | !row | zuomge | einh  | restmge | ljorig^id              | behaelter^id   |
      | 1    | 0      | Stück | 0       | (0,0,0)                | (0,0,0)        |
      | 2    | -1     | Paar  | 0       | !LJ-GEBINDEPFL-BEH4^id | !BEHAELTER3^id |
      | 3    | -1     | Paar  | -2      | !LJ-GEBINDEPFL-BEH3^id | !BEHAELTER4^id |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor
    And I set the fake date to "04.02.1995"
    And I wait 1 time units to move the time forward

    # Bestand unf Behälter prüfen
    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | behaelter  | ja      |
      | details    | nein    |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such | !row |
      | 2      | Stück    | BEHAELTER3      | 1    |
      | 4      | Stück    | BEHAELTER4      | 2    |
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | behaelter  | ja         |
      | details    | nein       |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such | !row |
      | 1      | Paar     | BEHAELTER3      | 1    |
      | 2      | Paar     | BEHAELTER4      | 2    |
    And I close the current editor

    Given I switch the current editor to editor "BEHAELTER3"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 2   | Stück   |
      | GEBINDEPFL | 1   | Paar    |
    And I close the current editor
    Given I switch the current editor to editor "BEHAELTER4"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 4   | Stück   |
      | GEBINDEPFL | 2   | Paar    |
    And I close the current editor

      # Materialrückgabe über burueckmzerg in Lagereinheit Stück
    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I modify table
      | !row | ljtext1    |
      | 1    | Rückgabe2a |
      | 2    | Rückgabe2b |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I press button "burueckmzerg"
    Then the table has 2 rows
    And I modify table
      | !row | zuomge | behaelter      |
      | 1    | 0      |                |
      | 2    | -2     | !BEHAELTER3^id |
      | +3   | -2     | !BEHAELTER4^id |
    Then table has values
      | !row | zuomge | einh  | restmge | ljorig^id           | behaelter^id   |
      | 1    | 0      | Stück | 0       | (0,0,0)             | (0,0,0)        |
      | 2    | -2     | Stück | -2      | !LJ-GEBINDE-BEH3^id | !BEHAELTER3^id |
      | 3    | -2     | Stück | 0       | (0,0,0)             | !BEHAELTER4^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "Materialzuordnung"
    And I press button "burueckmzerg"
    Then the table has 2 rows
    And I modify table
      | !row | zuomge | einh  | behaelter      |
      | 1    | 0      | Stück |                |
      | 2    | -2     | Stück | !BEHAELTER3^id |
      | +3   | -2     | Stück | !BEHAELTER4^id |
    Then table has values
      | !row | zuomge | einh  | restmge | ljorig^id              | behaelter^id   |
      | 1    | 0      | Stück | 0       | (0,0,0)                | (0,0,0)        |
      | 2    | -2     | Stück | -2      | !LJ-GEBINDEPFL-BEH3^id | !BEHAELTER3^id |
      | 3    | -2     | Stück | 0       | (0,0,0)                | !BEHAELTER4^id |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe2"
    And I save the current editor
    And I set the fake date to "05.02.1995"
    And I wait 1 time units to move the time forward

  # Bestand, Behälter und LJ prüfen
    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | behaelter  | ja      |
      | details    | nein    |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such | !row |
      | 4      | Stück    | BEHAELTER3      | 1    |
      | 6      | Stück    | BEHAELTER4      | 2    |
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | behaelter  | ja         |
      | details    | nein       |
    And I press start
    Then the table has 4 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such | !row |
      | 2      | Stück    | BEHAELTER3      | 1    |
      | 2      | Stück    | BEHAELTER4      | 2    |
      | 1      | Paar     | BEHAELTER3      | 3    |
      | 2      | Paar     | BEHAELTER4      | 4    |
    And I close the current editor

    Given I switch the current editor to editor "BEHAELTER3"
    Then the table has 3 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 4   | Stück   |
      | GEBINDEPFL | 2   | Stück   |
      | GEBINDEPFL | 1   | Paar    |
    And I close the current editor
    Given I switch the current editor to editor "BEHAELTER4"
    Then the table has 3 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 6   | Stück   |
      | GEBINDEPFL | 2   | Stück   |
      | GEBINDEPFL | 2   | Paar    |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then table has values
      | art        | amge | mei   | rueckmge | restmge | detursache                 | behaelter^such | !row |
      | GEBINDE    | -2   | Stück | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER4     | 1    |
      | GEBINDE    | -2   | Stück | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER3     | 2    |
      | GEBINDEPFL | -2   | Stück | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER4     | 3    |
      | GEBINDEPFL | -2   | Stück | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER3     | 4    |
      | GEBINDE    | -5   | kg    | -1       | 0       | Materialrückgabe Fertigung | BEHAELTER3     | 5    |
      | GEBINDE    | -5   | kg    | -1       | 0       | Materialrückgabe Fertigung | BEHAELTER3     | 6    |
      | GEBINDE    | -10  | kg    | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER4     | 7    |
      | GEBINDEPFL | -1   | Paar  | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER4     | 8    |
      | GEBINDEPFL | -1   | Paar  | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER3     | 9    |
      | GEBINDE    | 3    | Stück | 3        | 0       | Materialentnahme Fertigung | BEHAELTER4     | 10   |
      | GEBINDE    | 5    | Stück | 5        | 0       | Materialentnahme Fertigung | BEHAELTER3     | 11   |
      | GEBINDEPFL | 1    | Paar  | 2        | 0       | Materialentnahme Fertigung | BEHAELTER4     | 12   |
      | GEBINDEPFL | 3    | Paar  | 6        | 0       | Materialentnahme Fertigung | BEHAELTER3     | 13   |
    And I close the current editor

  # Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^id |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I modify table
      | zuomge | behaelter      | !row |
      | 4      | !BEHAELTER3^id | +1   |
      | 6      | !BEHAELTER4^id | +2   |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "Materialzuordnung"
    And I delete all rows
    And I modify table
      | zuomge | einh  | behaelter      | !row |
      | 2      | Stück | !BEHAELTER3^id | +1   |
      | 1      | Paar  | !BEHAELTER3^id | +2   |
      | 2      | Stück | !BEHAELTER4^id | +3   |
      | 2      | Paar  | !BEHAELTER4^id | +4   |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme3"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZEINHEIT_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    Then Container from editor "BEHAELTER3" is empty
    Then Container from editor "BEHAELTER4" is empty

    And I deliver the SalesOrder "auftrag05" with PackingSlip "liefer05"


  Scenario: 06 Materialzuordnung für Materialrückgabe über burueckmzzuord mit unterschiedlichen Plätzen
  # Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-06"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "KORR-06"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F3" with document "KORR-06"

  # Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag06" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "rechnung06" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ueb    | ja         |
      | fakt   | ja         |
      | ebeleg | Rechnung06 |
    And I delete all rows
    And I append rows
      | artikel   | mge | platz |
      | EINKAUF-1 | 10  | F1    |
      | EINKAUF-1 | 10  | F2    |
      | EINKAUF-2 | 10  | F1    |
    And I set field "verw" in row 1 to "verw" from editor "auftrag06" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag06" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag06" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

  # Fertigungsvorschlag anlegen und freigebn
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig |
      | M_BAUGRUPPE | 10  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag06" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | zuomge | lpsuch | !row |
      | 10     | F1     | +1   |
      | 10     | F2     | +2   |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MZPLAETZE2_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MZPLAETZE2_001"
    And I close the current editor

  # Materialentnahme über Teilmenge, Journaleinträge öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | 8                  |
    And I press button "stlvblad"
    And I modify table
      | !row | ljtext1   |
      | 1    | Entnahme1 |
      | 2    | Entnahme2 |
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MZPLAETZE2_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-F1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;erbtext1=Entnahme1;platz=F1;@richtung=rückwärts;@maxtreffer=1"
    Then field "mge" has value "10"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-F2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;erbtext1=Entnahme1;platz=F2;@richtung=rückwärts;@maxtreffer=1"
    Then field "mge" has value "6"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    And I close the current editor

  # Materialrückgabe über burueckmzzuord
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I modify table
      | !row | ljtext1   |
      | 1    | Rückgabe1 |
      | 2    | Rückgabe2 |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I press button "burueckmzzuord"
    Then the table has 2 rows
    Then table has values
      | !row | lpsuch | zuomge | restmge | ljorig^id          |
      | 1    |        | -6     | 0       | !LJ-EINKAUF1-F2^id |
      | 2    |        | -2     | -8      | !LJ-EINKAUF1-F1^id |
    And I modify table
      | !row | zuomge | lpsuch |
      | 1    | -4     |        |
      | 2    | -4     | F3     |
    Then table has values
      | !row | lpsuch | zuomge | restmge | ljorig^id          |
      | 1    |        | -4     | -2      | !LJ-EINKAUF1-F2^id |
      | 2    | F3     | -4     | -6      | !LJ-EINKAUF1-F1^id |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

  # LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
      | artikel  | EINKAUF-1              |
    And I press start
    Then table has values
      | vplatz | amge | rueckmge | restmge | detursache                 | !row |
      | F3     | -2   | -2       | 0       | Materialrückgabe Fertigung | 1    |
      | F3     | -2   | -2       | 0       | Materialrückgabe Fertigung | 2    |
      | F1     | -4   | -4       | 0       | Materialrückgabe Fertigung | 3    |
      | F2     | 6    | 6        | 0       | Materialentnahme Fertigung | 4    |
      | F1     | 10   | 2        | 8       | Materialentnahme Fertigung | 5    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "rueckorig^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 3
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 7 rows
    Then table has values
      | lemge | lplatz | gebmge | kopfzugvorg^id | !row |
      | 4     | F1     |        | (0,0,0)        | 1    |
      |       | F1     | 4      | !rechnung06^id | 2    |
      | 4     | F2     |        | (0,0,0)        | 3    |
      |       | F2     | 4      | !rechnung06^id | 4    |
      | 4     | F3     |        | (0,0,0)        | 5    |
      |       | F3     | 2      | !rechnung06^id | 6    |
      |       | F3     | 2      | !rechnung06^id | 7    |
    And I close the current editor

  # Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^id |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | lpsuch | zuomge | !row |
      | F1     | 4      | 1    |
      | F2     | 4      | +2   |
      | F3     | 4      | +3   |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZPLAETZE2_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag06" with PackingSlip "liefer06"


  Scenario: 07 Materialzuordnung für Materialrückgabe über burueckmzzuord mit scharfer und unscharfer Verwendung
  # Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-07"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "KORR-07"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F3" with document "KORR-07"

  # Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag07" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "rechnung07" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ueb    | ja         |
      | fakt   | ja         |
      | ebeleg | Rechnung07 |
    And I delete all rows
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 10  |
      | EINKAUF-1 | 10  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag07" in row 1
    And I set field "verw" in row 2 to "nummer" from editor "auftrag07" in row 0
    And I set field "verw" in row 3 to "verw" from editor "auftrag07" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

  # Fertigungsvorschlag anlegen und freigebn
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch   |
      | M_BAUGRUPPE | 10  | ja     | MZVERW2_ |
    And I set field "verw" in row 1 to "verw" from editor "auftrag07" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MZVERW2_001"
    And I close the current editor

  # Materialentnahme über Teilmenge, Journaleinträge öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | 8                  |
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MZVERW2_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-Unscharf" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;mge=6;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    Then field "verw" has value equal to field "verw" from editor "auftrag07" in row 1
    Then field "verwla" has value equal to field "nummer" from editor "auftrag07" in row 0
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-Scharf" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;mge=10;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    Then field "verw" has value equal to field "verw" from editor "auftrag07" in row 1
    Then field "verwla" has value equal to field "verw" from editor "auftrag07" in row 1
    And I close the current editor

  # Materialrückgabe über burueckmzzuord
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I modify table
      | !row | ljtext1   |
      | 1    | Rückgabe1 |
      | 2    | Rückgabe2 |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I press button "burueckmzzuord"
    Then the table has 2 rows
    Then table has values
      | !row | zuomge | restmge | ljorig^id                |
      | 1    | -6     | 0       | !LJ-EINKAUF1-Unscharf^id |
      | 2    | -2     | -8      | !LJ-EINKAUF1-Scharf^id   |
    And I modify table
      | !row | zuomge |
      | 1    | -4     |
      | 2    | -4     |
    Then table has values
      | !row | zuomge | restmge | ljorig^id                |
      | 1    | -4     | -2      | !LJ-EINKAUF1-Unscharf^id |
      | 2    | -4     | -6      | !LJ-EINKAUF1-Scharf^id   |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag07" in row 0
    Then field "verw" in row 2 has value equal to field "verw" from editor "auftrag07" in row 1
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

  # LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
      | artikel  | EINKAUF-1              |
    And I press start
    Then table has values
      | amge | rueckmge | restmge | detursache                 | !row |
      | -2   | -2       | 0       | Materialrückgabe Fertigung | 1    |
      | -2   | -2       | 0       | Materialrückgabe Fertigung | 2    |
      | -4   | -4       | 0       | Materialrückgabe Fertigung | 3    |
      | 6    | 6        | 0       | Materialentnahme Fertigung | 4    |
      | 10   | 2        | 8       | Materialentnahme Fertigung | 5    |
    Then field "verwla" in row 1 has value equal to field "verw" from editor "auftrag07" in row 1
    Then field "verwla" in row 2 has value equal to field "nummer" from editor "auftrag07" in row 1
    Then field "verwla" in row 3 has value equal to field "nummer" from editor "auftrag07" in row 0
    And I close the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 5 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id | verw              | !row |
      | 12    |        | (0,0,0)        |                   | 1    |
      |       | 4      | !rechnung07^id | !auftrag07^nummer | 2    |
      |       | 4      | !rechnung07^id | !auftrag07^nummer | 3    |
      |       | 2      | !rechnung07^id | !auftrag07^nummer | 4    |
      |       | 2      | !rechnung07^id | !auftrag07^verw   | 5    |
    And I close the current editor

  # Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZVERW2_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag07" with PackingSlip "liefer07"


  Scenario: 08 Materialzuordnung für Materialrückgabe über burueckmzzuord mit Chargen
  # Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-08"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "KORR-08"

    # Chargen anlegen
    Given I create a Lot "MZ_CHARGE3" for Product "EINKAUF-1"
    Given I create a Lot "MZ_CHARGE4" for Product "EINKAUF-1"

  # Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag08" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "rechnung08" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ueb    | ja         |
      | fakt   | ja         |
      | ebeleg | Rechnung08 |
    And I delete all rows
    And I append rows
      | artikel   | mge | charge         |
      | EINKAUF-1 | 10  | !MZ_CHARGE3^id |
      | EINKAUF-1 | 10  | !MZ_CHARGE4^id |
      | EINKAUF-2 | 10  | !dontChange    |
    And I set field "verw" in row 1 to "verw" from editor "auftrag08" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag08" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag08" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

  # Fertigungsvorschlag anlegen und freigebn
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig |
      | M_BAUGRUPPE | 10  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag08" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | !row | zuomge | charge         |
      | +1   | 10     | !MZ_CHARGE3^id |
      | +2   | 10     | !MZ_CHARGE4^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MZCHARGE2_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MZCHARGE2_001"
    And I close the current editor

  # Materialentnahme über Teilmenge, Journaleinträge öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | 8                  |
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MZCHARGE2_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-CH4" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;mge=6;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    Then table has values
      | vcharge^id     |
      | !MZ_CHARGE4^id |
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-CH3" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;mge=10;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    Then table has values
      | vcharge^id     |
      | !MZ_CHARGE3^id |
    And I close the current editor

  # Materialrückgabe über burueckmzzuord
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I modify table
      | !row | ljtext1   |
      | 1    | Rückgabe1 |
      | 2    | Rückgabe2 |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | charge         |
      | 1    | -4     | !MZ_CHARGE4^id |
      | +2   | -4     | !MZ_CHARGE3^id |
    And I press button "burueckmzzuord"
    Then the table has 2 rows
    Then table has values
      | !row | zuomge | restmge | ljorig^id           | charge^id      |
      | 1    | -4     | -2      | !LJ-EINKAUF1-CH4^id | !MZ_CHARGE4^id |
      | 2    | -4     | -6      | !LJ-EINKAUF1-CH3^id | !MZ_CHARGE3^id |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

  # LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
      | artikel  | EINKAUF-1              |
    And I press start
    Then table has values
      | amge | rueckmge | restmge | detursache                 | vcharge^such | !row |
      | -4   | -4       | 0       | Materialrückgabe Fertigung | MZ_CHARGE3   | 1    |
      | -4   | -4       | 0       | Materialrückgabe Fertigung | MZ_CHARGE4   | 2    |
      | 6    | 4        | 2       | Materialentnahme Fertigung | MZ_CHARGE4   | 3    |
      | 10   | 4        | 6       | Materialentnahme Fertigung | MZ_CHARGE3   | 4    |
    And I close the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id | charge^such | !row |
      | 12    |        | (0,0,0)        |             | 1    |
      |       | 4      | !rechnung08^id | MZ_CHARGE4  | 2    |
      |       | 4      | !rechnung08^id | MZ_CHARGE4  | 3    |
      |       | 4      | !rechnung08^id | MZ_CHARGE3  | 4    |
    And I close the current editor

  # Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^id |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | zuomge | charge         | !row |
      | 4      | !MZ_CHARGE3^id | 1    |
      | 8      | !MZ_CHARGE4^id | +2   |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZCHARGE2_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag08" with PackingSlip "liefer08"


  Scenario: 09 Materialzuordnung für Materialrückgabe über burueckmzzuord mit Behältern
  # Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-09"

    # Behälter anlegen
    Given I create a Container "BEHAELTER10" for packaging material "BEHAELTER"
    Given I create a Container "BEHAELTER20" for packaging material "BEHAELTER"

  # Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag09" for Customer "RADSHOP" with Product "M_BG-BEHAELTER" and quantity "10"

    Given I open an editor "rechnung09" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ueb    | ja         |
      | fakt   | ja         |
      | ebeleg | Rechnung09 |
    And I delete all rows
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 10  |
      | EINKAUF-1 | 10  |
      | EINKAUF-2 | 10  |
      | BEHAELTER | 2   |
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!BEHAELTER10^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!BEHAELTER20^nummer" in row 2
    And I set field "verw" in row 1 to "verw" from editor "auftrag09" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag09" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag09" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

  # Fertigungsvorschlag anlegen und freigebn
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel        | mge | mfreig |
      | M_BG-BEHAELTER | 10  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag09" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | !row | zuomge | behaelter       |
      | +1   | 10     | !BEHAELTER10^id |
      | +2   | 10     | !BEHAELTER20^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MZBEH2_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MZBEH2_001"
    And I close the current editor

  # Materialentnahme über Teilmenge, Journaleinträge öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | 8                  |
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MZBEH2_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-BEH20" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;mge=6;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    Then field "behaelter^id" has value "!BEHAELTER20^id"
    And I close the current editor

    Given I open an editor "LJ-EINKAUF1-BEH10" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;mge=10;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    Then field "behaelter^id" has value "!BEHAELTER10^id"
    And I close the current editor

  # Materialrückgabe über burueckmzzuord
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I modify table
      | !row | ljtext1   |
      | 1    | Rückgabe1 |
      | 2    | Rückgabe2 |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I press button "burueckmzzuord"
    Then the table has 2 rows
    And I modify table
      | !row | zuomge | behaelter       |
      | 1    | -4     | !BEHAELTER20^id |
      | 2    | -4     | !BEHAELTER10^id |
    Then table has values
      | !row | zuomge | restmge | ljorig^id             | behaelter^id    |
      | 1    | -4     | -2      | !LJ-EINKAUF1-BEH20^id | !BEHAELTER20^id |
      | 2    | -4     | -6      | !LJ-EINKAUF1-BEH10^id | !BEHAELTER10^id |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

  # LJ, Bestand und Behälter prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
      | artikel  | EINKAUF-1              |
    And I press start
    Then table has values
      | amge | rueckmge | restmge | detursache                 | behaelter^such | !row |
      | -2   | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER10    | 1    |
      | -2   | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER10    | 2    |
      | -4   | -4       | 0       | Materialrückgabe Fertigung | BEHAELTER20    | 3    |
      | 6    | 6        | 0       | Materialentnahme Fertigung | BEHAELTER20    | 4    |
      | 10   | 2        | 8       | Materialentnahme Fertigung | BEHAELTER10    | 5    |
    And I close the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | behaelter  | ja        |
      | details    | nein      |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | tbehaelter^such | !row |
      | 4      | BEHAELTER10     | 1    |
      | 8      | BEHAELTER20     | 2    |
    And I close the current editor

    Given I switch the current editor to editor "BEHAELTER10"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 4   |
    And I close the current editor
    Given I switch the current editor to editor "BEHAELTER20"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 8   |
    And I close the current editor

  # Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^id |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I modify table
      | zuomge | behaelter       | !row |
      | 4      | !BEHAELTER10^id | +1   |
      | 8      | !BEHAELTER20^id | +2   |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZBEH2_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    Then Container from editor "BEHAELTER10" is empty
    Then Container from editor "BEHAELTER20" is empty

    And I deliver the SalesOrder "auftrag09" with PackingSlip "liefer09"


  Scenario: 10 Materialzuordnung für Materialrückgabe über burueckmzzuord mit Einheiten und Behältern, Handelseinheit und Lagereinheit
  # Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "KORR-10"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "KORR-10"

  # Behälter anlegen
    Given I create a Container "BEHAELTER30" for packaging material "BEHAELTER"
    Given I create a Container "BEHAELTER40" for packaging material "BEHAELTER"

  # Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag10" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "10"

    Given I open an editor "rechnung10" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ueb    | ja         |
      | fakt   | ja         |
      | ebeleg | Rechnung10 |
    And I delete all rows
    And I append rows
      | artikel    | mge |
      | GEBINDE    | 25  |
      | GEBINDE    | 25  |
      | GEBINDEPFL | 3   |
      | GEBINDEPFL | 2   |
      | EINKAUF-1  | 10  |
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!BEHAELTER30^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!BEHAELTER40^nummer" in row 2
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!BEHAELTER30^nummer" in row 3
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!BEHAELTER40^nummer" in row 4
    And I set field "verw" in row 1 to "verw" from editor "auftrag10" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag10" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag10" in row 1
    And I set field "verw" in row 4 to "verw" from editor "auftrag10" in row 1
    And I set field "verw" in row 5 to "verw" from editor "auftrag10" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

  # Fertigungsvorschlag anlegen und freigebn
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig |
      | BG-GEBINDE | 10  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag10" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | !row | zuomge | behaelter       |
      | +1   | 5      | !BEHAELTER30^id |
      | +2   | 5      | !BEHAELTER40^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | +1   | 3      | Paar | !BEHAELTER30^id |
      | +2   | 2      | Paar | !BEHAELTER40^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MZEINHEIT2_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MZEINHEIT2_001"
    And I close the current editor

  # Materialentnahme über Teilmenge, Journaleinträge öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | autorment   | ja                 |
      | gmgevorschl | 8                  |
    And I press button "stlvblad"
    And I set field "ljtext1" to "Beh123" in row 1
    And I set field "ljtext1" to "Beh123" in row 2
    And I save the current editor

    Then Container from editor "BEHAELTER30" is empty
    And I switch the current editor to editor "BEHAELTER40" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 2   | Stück   |
      | GEBINDEPFL | 1   | Paar    |
    And I close the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MZEINHEIT2_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "LJ-GEBINDE-BEH40" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=GEBINDE;erbtext1=Beh123;mge=3;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    And I close the current editor

    Given I open an editor "LJ-GEBINDE-BEH30" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=GEBINDE;erbtext1=Beh123;mge=5;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    And I close the current editor

    Given I open an editor "LJ-GEBINDEPFL-BEH40" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=GEBINDEPFL;erbtext1=Beh123;mge=2;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    And I close the current editor

    Given I open an editor "LJ-GEBINDEPFL-BEH30" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=GEBINDEPFL;erbtext1=Beh123;mge=6;ursache=Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value "!Materialentnahme1^id"
    And I close the current editor

    # Materialrückgabe über burueckmzzuord in Handelseinheit kg und Paar
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | autorment   | ja                 |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I modify table
      | !row | ljtext1   | manbu |
      | 1    | Rückgabe1 | ja    |
      | 2    | Rückgabe2 | ja    |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I press button "burueckmzzuord"
    Then the table has 2 rows
    And I modify table
      | !row | einh | zuomge | behaelter       |
      | 1    | kg   | -10    | !BEHAELTER40^id |
      | 2    | kg   | -10    | !BEHAELTER30^id |
    Then table has values
      | !row | zuomge | restmge | einh | ljorig^id            |
      | 1    | -10    | -5      | kg   | !LJ-GEBINDE-BEH40^id |
      | 2    | -10    | -15     | kg   | !LJ-GEBINDE-BEH30^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "Materialzuordnung"
    And I press button "burueckmzzuord"
    Then the table has 2 rows
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | 1    | -1     | Paar | !BEHAELTER30^id |
      | 2    | -1     | Paar | !BEHAELTER40^id |
    Then table has values
      | !row | zuomge | restmge | einh | ljorig^id               | behaelter^id    |
      | 1    | -1     | 0       | Paar | !LJ-GEBINDEPFL-BEH40^id | !BEHAELTER30^id |
      | 2    | -1     | -2      | Paar | !LJ-GEBINDEPFL-BEH30^id | !BEHAELTER40^id |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

    # Bestand unf Behälter prüfen
    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | behaelter  | ja      |
      | details    | nein    |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such | !row |
      | 2      | Stück    | BEHAELTER30     | 1    |
      | 4      | Stück    | BEHAELTER40     | 2    |
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | behaelter  | ja         |
      | details    | nein       |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such | !row |
      | 1      | Paar     | BEHAELTER30     | 1    |
      | 2      | Paar     | BEHAELTER40     | 2    |
    And I close the current editor

  # Materialrückgabe über burueckmzzuord in Lagereinheit Stück
    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^id |
      | gmgevorschl | -4                 |
    And I press button "stlvblad"
    And I modify table
      | !row | ljtext1   |
      | 1    | Rückgabe1 |
      | 2    | Rückgabe2 |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I press button "burueckmzzuord"
    Then the table has 1 rows
    And I modify table
      | !row | zuomge | behaelter       |
      | 1    | -2     | !BEHAELTER40^id |
      | +2   | -2     | !BEHAELTER30^id |
    Then table has values
      | !row | zuomge | restmge | einh  | ljorig^id            |
      | 1    | -2     | -2      | Stück | !LJ-GEBINDE-BEH30^id |
      | 2    | -2     | 0       | Stück | (0,0,0)              |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "Materialzuordnung"
    And I press button "burueckmzzuord"
    Then the table has 1 rows
    And I modify table
      | !row | zuomge | behaelter       |
      | 1    | -2     | !BEHAELTER30^id |
      | +2   | -2     | !BEHAELTER40^id |
    Then table has values
      | !row | zuomge | restmge | einh  | ljorig^id               | behaelter^id    |
      | 1    | -2     | -2      | Stück | !LJ-GEBINDEPFL-BEH30^id | !BEHAELTER30^id |
      | 2    | -2     | 0       | Stück | (0,0,0)                 | !BEHAELTER40^id |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe2"
    And I save the current editor

  # Bestand, Behälter und LJ prüfen
    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | behaelter  | ja      |
      | details    | nein    |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such | !row |
      | 4      | Stück    | BEHAELTER30     | 1    |
      | 6      | Stück    | BEHAELTER40     | 2    |
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | behaelter  | ja         |
      | details    | nein       |
    And I press start
    Then the table has 4 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such | !row |
      | 2      | Stück    | BEHAELTER30     | 1    |
      | 2      | Stück    | BEHAELTER40     | 2    |
      | 1      | Paar     | BEHAELTER30     | 3    |
      | 2      | Paar     | BEHAELTER40     | 4    |
    And I close the current editor

    Given I switch the current editor to editor "BEHAELTER30"
    Then the table has 3 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 4   | Stück   |
      | GEBINDEPFL | 2   | Stück   |
      | GEBINDEPFL | 1   | Paar    |
    And I close the current editor
    Given I switch the current editor to editor "BEHAELTER40"
    Then the table has 3 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 6   | Stück   |
      | GEBINDEPFL | 2   | Stück   |
      | GEBINDEPFL | 2   | Paar    |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then table has values
      | art        | amge | mei   | rueckmge | restmge | detursache                 | behaelter^such | !row |
      | GEBINDE    | -2   | Stück | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER30    | 1    |
      | GEBINDE    | -2   | Stück | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER40    | 2    |
      | GEBINDEPFL | -2   | Stück | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER40    | 3    |
      | GEBINDEPFL | -2   | Stück | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER30    | 4    |
      | GEBINDE    | -5   | kg    | -1       | 0       | Materialrückgabe Fertigung | BEHAELTER30    | 5    |
      | GEBINDE    | -5   | kg    | -1       | 0       | Materialrückgabe Fertigung | BEHAELTER30    | 6    |
      | GEBINDE    | -10  | kg    | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER40    | 7    |
      | GEBINDEPFL | -1   | Paar  | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER40    | 8    |
      | GEBINDEPFL | -1   | Paar  | -2       | 0       | Materialrückgabe Fertigung | BEHAELTER30    | 9    |
      | GEBINDE    | 3    | Stück | 3        | 0       | Materialentnahme Fertigung | BEHAELTER40    | 10   |
      | GEBINDE    | 5    | Stück | 5        | 0       | Materialentnahme Fertigung | BEHAELTER30    | 11   |
      | GEBINDEPFL | 1    | Paar  | 2        | 0       | Materialentnahme Fertigung | BEHAELTER40    | 12   |
      | GEBINDEPFL | 3    | Paar  | 6        | 0       | Materialentnahme Fertigung | BEHAELTER30    | 13   |
    And I close the current editor

  # Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^id |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I modify table
      | zuomge | behaelter       | !row |
      | 4      | !BEHAELTER30^id | +1   |
      | 6      | !BEHAELTER40^id | +2   |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "Materialzuordnung"
    And I delete all rows
    And I modify table
      | zuomge | einh  | behaelter       | !row |
      | 2      | Stück | !BEHAELTER30^id | +1   |
      | 1      | Paar  | !BEHAELTER30^id | +2   |
      | 2      | Stück | !BEHAELTER40^id | +3   |
      | 2      | Paar  | !BEHAELTER40^id | +4   |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZEINHEIT2_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor

    And I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    Then Container from editor "BEHAELTER30" is empty
    Then Container from editor "BEHAELTER40" is empty

    And I deliver the SalesOrder "auftrag10" with PackingSlip "liefer10"
