@persistent
Feature: storno_rueckgabe_materialentnahmen_mz_prozesstests.feature

  Background:
    And I set the fake date to "02.01.1995"


# *****************************************************************************
#  Name             : storno_rueckgabe_materialentnahmen_mz_prozesstests
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet die Rückgabe von Material über Materialzuordnung
#                     in der FBuchung in der Fertigung
#  Jira-Issue       : FDA-993
# *****************************************************************************


  Scenario: 01 Rückgabe und Storno Rückgabe von bedarfsbez und auftragsbez Material auf unterschiedliche Lagerplätze auf letzten AS, bisher Teilentnahme über Fbuch, EntnahmeMZ mit Plätzen vor Freigabe FV angelegt
# Baugruppe mit bedarfsbezogenen und auftragsbezogenen Material in Stückliste
    Given I open an editor "BAUGRUPPE-BA" from table "(Part):(Product)" with command "STORE" for record "BAUGRUPPE-BA"
    And I set fields
      | such     | BAUGRUPPE-BA                    |
      | namebspr | auftrags- & bedarfsbez Material |
      | dispoa   | bedarfsbezogen                  |
      | bsart    | Eigenfertigung                  |
      | wgruppe  | 55                              |
      | erlgrp   | 66                              |
    And I delete all rows
    And I append rows
      | elex        | anzahl | manbu |
      | EINKAUF-1   | 2      | ja    |
      | B_EINKAUF-2 | 1      | ja    |
      | A MONTAGE1  | 1      |       |
    And I save the current editor

# Bestände auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "S-KORR01"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "S-KORR01"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F3" with document "S-KORR01"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1" with document "S-KORR01"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F2" with document "S-KORR01"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F3" with document "S-KORR01"

# Auftrag anlegen und Bedarfe auf verschiedene Plätze einkaufen
    Given I create a SalesOrder "auftrag1" for Customer "RADSHOP" with Product "BAUGRUPPE-BA" and quantity "10"

    Given I open an editor "Rechnung1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ueb    | ja        |
      | fakt   | ja        |
      | ebeleg | Rechnung1 |
    And I append rows
      | artikel     | mge | platz |
      | EINKAUF-1   | 10  | F1    |
      | EINKAUF-1   | 10  | F2    |
      | B_EINKAUF-2 | 5   | F1    |
      | B_EINKAUF-2 | 5   | F2    |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | mge | mfreig |
      | BAUGRUPPE-BA | 10  | ja     |
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | !row | zuomge | platz |
      | +1   | 10     | F1    |
      | +2   | 10     | F2    |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | platz |
      | +1   | 5      | F1    |
      | +2   | 5      | F2    |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "PLAETZE_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "PLAETZE_001"
    And I close the current editor

# Materialentnahme Material F1
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 6                      |
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE-BA | 0        | 0       | 0      | 0      |
      | 6   | B_EINKAUF-2  | 0        | 6       | 10     | 4      |
      | 12  | EINKAUF-1    | 0        | 12      | 20     | 8      |
    And I close the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then the table has 4 rows
    Then table has values
      | art         | vplatz | amge |
      | EINKAUF-1   | F2     | 2    |
      | EINKAUF-1   | F1     | 10   |
      | B_EINKAUF-2 | F2     | 1    |
      | B_EINKAUF-2 | F1     | 5    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F2     | 8     |        | (0,0,0)        |
      | F2     |       | 8      | !Rechnung1^id  |
    And I set fields
      | artikel    | B_EINKAUF-2 |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F2     | 4     |        | (0,0,0)        |
      | F2     |       | 4      | !Rechnung1^id  |
    And I close the current editor

# Rückgabe auf Lagerplatz aus Ursprungs-MZ sowie anderem Lagerplatz
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Rückgabe1              |
      | gmgevorschl | -2                     |
    And I press button "stlvblad"
    Then the table has 2 rows
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge | platz |
      | 1    | -2     | F2    |
      | +2   | -2     | F3    |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "Materialzuordnung_Rückgabe"
    And I modify table
      | !row | zuomge | platz |
      | 1    | -1     | F1    |
      | +2   | -1     | F3    |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE_001;manrm=ja;bem=Rückgabe1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then the table has 8 rows
    Then table has values
      | art         | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1   | F3     | -2   | -2       | 0       | 1    |
      | EINKAUF-1   | F2     | -2   | -2       | 0       | 2    |
      | B_EINKAUF-2 | F3     | -1   | -1       | 0       | 3    |
      | B_EINKAUF-2 | F1     | -1   | -1       | 0       | 4    |
      | EINKAUF-1   | F2     | 2    | 2        | 0       | 5    |
      | EINKAUF-1   | F1     | 10   | 2        | 8       | 6    |
      | B_EINKAUF-2 | F2     | 1    | 1        | 0       | 7    |
      | B_EINKAUF-2 | F1     | 5    | 1        | 4       | 8    |
    Then field "rueckorig" in row 1 has value equal to field "verweis" from editor "LJ" in row 6
    Then field "rueckorig" in row 2 has value equal to field "verweis" from editor "LJ" in row 5
    Then field "rueckorig" in row 3 has value equal to field "verweis" from editor "LJ" in row 8
    Then field "rueckorig" in row 4 has value equal to field "verweis" from editor "LJ" in row 7
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 5 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F2     | 10    |        | (0,0,0)        |
      | F2     |       | 8      | !Rechnung1^id  |
      | F2     |       | 2      | !Rechnung1^id  |
      | F3     | 2     |        | (0,0,0)        |
      | F3     |       | 2      | !Rechnung1^id  |
    And I set fields
      | artikel    | B_EINKAUF-2 |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 3
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 6 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 1     |        | (0,0,0)        |
      | F1     |       | 1      | !Rechnung1^id  |
      | F2     | 4     |        | (0,0,0)        |
      | F2     |       | 4      | !Rechnung1^id  |
      | F3     | 1     |        | (0,0,0)        |
      | F3     |       | 1      | !Rechnung1^id  |
    And I close the current editor

  # Rückgabe auf Lagerplätze aus Ursprungs-MZ
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Rückgabe2              |
      | gmgevorschl | -2                     |
    And I press button "stlvblad"
    Then the table has 2 rows
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge | platz |
      | 1    | -2     | F1    |
      | +2   | -2     | F2    |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "Materialzuordnung_Rückgabe"
    And I modify table
      | !row | zuomge | platz |
      | 1    | -1     | F1    |
      | +2   | -1     | F2    |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe2"
    And I save the current editor

    Given I open an editor "Materialrückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE_001;manrm=ja;bem=Rückgabe2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then the table has 12 rows
    Then table has values
      | art         | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1   | F2     | -2   | -2       | 0       | 1    |
      | EINKAUF-1   | F1     | -2   | -2       | 0       | 2    |
      | B_EINKAUF-2 | F2     | -1   | -1       | 0       | 3    |
      | B_EINKAUF-2 | F1     | -1   | -1       | 0       | 4    |
      | EINKAUF-1   | F3     | -2   | -2       | 0       | 5    |
      | EINKAUF-1   | F2     | -2   | -2       | 0       | 6    |
      | B_EINKAUF-2 | F3     | -1   | -1       | 0       | 7    |
      | B_EINKAUF-2 | F1     | -1   | -1       | 0       | 8    |
      | EINKAUF-1   | F2     | 2    | 2        | 0       | 9    |
      | EINKAUF-1   | F1     | 10   | 6        | 4       | 10   |
      | B_EINKAUF-2 | F2     | 1    | 1        | 0       | 11   |
      | B_EINKAUF-2 | F1     | 5    | 3        | 2       | 12   |
    Then field "rueckorig" in row 1 has value equal to field "verweis" from editor "LJ" in row 10
    Then field "rueckorig" in row 2 has value equal to field "verweis" from editor "LJ" in row 10
    Then field "rueckorig" in row 3 has value equal to field "verweis" from editor "LJ" in row 12
    Then field "rueckorig" in row 4 has value equal to field "verweis" from editor "LJ" in row 12
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 3
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 8 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 2     |        | (0,0,0)        |
      | F1     |       | 2      | !Rechnung1^id  |
      | F2     | 12    |        | (0,0,0)        |
      | F2     |       | 8      | !Rechnung1^id  |
      | F2     |       | 2      | !Rechnung1^id  |
      | F2     |       | 2      | !Rechnung1^id  |
      | F3     | 2     |        | (0,0,0)        |
      | F3     |       | 2      | !Rechnung1^id  |
    And I set fields
      | artikel    | B_EINKAUF-2 |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 3
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 8 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 2     |        | (0,0,0)        |
      | F1     |       | 1      | !Rechnung1^id  |
      | F1     |       | 1      | !Rechnung1^id  |
      | F2     | 5     |        | (0,0,0)        |
      | F2     |       | 4      | !Rechnung1^id  |
      | F2     |       | 1      | !Rechnung1^id  |
      | F3     | 1     |        | (0,0,0)        |
      | F3     |       | 1      | !Rechnung1^id  |
    And I close the current editor

# Rückgabe über Zeile der Materialentnahme
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialrückgabe3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Rückgabe3              |
      | gmgevorschl | -2                     |
    And I press button "stlvblad"
    Then the table has 2 rows
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge | lpsuch |
      | 1    | -4     | F2     |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "Materialzuordnung_Rückgabe"
    And I modify table
      | !row | zuomge | lpsuch |
      | 1    | -2     | F3     |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe3"
    And I save the current editor

    Given I open an editor "Materialrückgabe3" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE_001;manrm=ja;bem=Rückgabe3;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then the table has 14 rows
    Then table has values
      | art         | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1   | F2     | -4   | -4       | 0       | 1    |
      | B_EINKAUF-2 | F3     | -2   | -2       | 0       | 2    |
      | EINKAUF-1   | F2     | -2   | -2       | 0       | 3    |
      | EINKAUF-1   | F1     | -2   | -2       | 0       | 4    |
      | B_EINKAUF-2 | F2     | -1   | -1       | 0       | 5    |
      | B_EINKAUF-2 | F1     | -1   | -1       | 0       | 6    |
      | EINKAUF-1   | F3     | -2   | -2       | 0       | 7    |
      | EINKAUF-1   | F2     | -2   | -2       | 0       | 8    |
      | B_EINKAUF-2 | F3     | -1   | -1       | 0       | 9    |
      | B_EINKAUF-2 | F1     | -1   | -1       | 0       | 10   |
      | EINKAUF-1   | F2     | 2    | 2        | 0       | 11   |
      | EINKAUF-1   | F1     | 10   | 10       | 0       | 12   |
      | B_EINKAUF-2 | F2     | 1    | 1        | 0       | 13   |
      | B_EINKAUF-2 | F1     | 5    | 5        | 0       | 14   |
    Then field "rueckorig" in row 1 has value equal to field "verweis" from editor "LJ" in row 12
    Then field "rueckorig" in row 2 has value equal to field "verweis" from editor "LJ" in row 14
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 3
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 9 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 2     |        | (0,0,0)        |
      | F1     |       | 2      | !Rechnung1^id  |
      | F2     | 16    |        | (0,0,0)        |
      | F2     |       | 8      | !Rechnung1^id  |
      | F2     |       | 2      | !Rechnung1^id  |
      | F2     |       | 2      | !Rechnung1^id  |
      | F2     |       | 4      | !Rechnung1^id  |
      | F3     | 2     |        | (0,0,0)        |
      | F3     |       | 2      | !Rechnung1^id  |
    And I set fields
      | artikel    | B_EINKAUF-2 |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 3
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 9 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 2     |        | (0,0,0)        |
      | F1     |       | 1      | !Rechnung1^id  |
      | F1     |       | 1      | !Rechnung1^id  |
      | F2     | 5     |        | (0,0,0)        |
      | F2     |       | 4      | !Rechnung1^id  |
      | F2     |       | 1      | !Rechnung1^id  |
      | F3     | 3     |        | (0,0,0)        |
      | F3     |       | 1      | !Rechnung1^id  |
      | F3     |       | 2      | !Rechnung1^id  |
    And I close the current editor

	# Materialrückgaben stornieren, in Reihenfolge der Buchung
    Given I open an editor "Materialrückgabe1_Storno" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open an editor "Materialrückgabe2_Storno" via ID from editor "Materialrückgabe2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open an editor "Materialrückgabe3_Storno" via ID from editor "Materialrückgabe3" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

	# Storno- und stornierte Belege prüfen
    Given I switch the current editor to editor "Materialrückgabe1" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE-BA | 0        | 0       | 0      | 0      |
      | -2  | B_EINKAUF-2  | -2       | 0       | 4      | 6      |
      | -4  | EINKAUF-1    | -4       | 0       | 8      | 12     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe2" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE-BA | 0        | 0       | 0      | 0      |
      | -2  | B_EINKAUF-2  | -2       | 0       | 6      | 8      |
      | -4  | EINKAUF-1    | -4       | 0       | 12     | 16     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe3" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE-BA | 0        | 0       | 0      | 0      |
      | -2  | B_EINKAUF-2  | -2       | 0       | 8      | 10     |
      | -4  | EINKAUF-1    | -4       | 0       | 16     | 20     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe1^id"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE-BA | 0        | 0       | 0      | 0      |
      | 2   | B_EINKAUF-2  | 0        | 2       | 10     | 8      |
      | 4   | EINKAUF-1    | 0        | 4       | 20     | 16     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe2_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe2^id"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE-BA | 0        | 0       | 0      | 0      |
      | 2   | B_EINKAUF-2  | 0        | 2       | 8      | 6      |
      | 4   | EINKAUF-1    | 0        | 4       | 16     | 12     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe3_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe3^id"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE-BA | 0        | 0       | 0      | 0      |
      | 2   | B_EINKAUF-2  | 0        | 2       | 6      | 4      |
      | 4   | EINKAUF-1    | 0        | 4       | 12     | 8      |
    And I close the current editor

  	# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F2     | 8     |        | (0,0,0)        |
      | F2     |       | 2      | !Rechnung1^id  |
      | F2     |       | 2      | !Rechnung1^id  |
      | F2     |       | 4      | !Rechnung1^id  |
    And I set fields
      | artikel | B_EINKAUF-2 |
      | details | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F2     | 4     |        | (0,0,0)        |
      | F2     |       | 3      | !Rechnung1^id  |
      | F2     |       | 1      | !Rechnung1^id  |
    And I close the current editor

  	# FV abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stlvblad"
    And I set field "buplatz" to "F2" in row 1
    And I set field "buplatz" to "F2" in row 2
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel | B_EINKAUF-2 |
      | details | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag1" with PackingSlip "LS-MA01"


  Scenario: 02 Rückgabe und Storno Rückgabe von bedarfsbez und auftragsbez Material auf unterschiedliche Lagerplätze auf letzten AS, bisher Teilentnahme über Fbuch
    And I set the fake date to "03.01.1995"
# Baugruppe mit bedarfsbezogenen und auftragsbezogenen Material in Stückliste
    Given I open an editor "BAUGRUPPE-BA" from table "(Part):(Product)" with command "STORE" for record "BAUGRUPPE-BA"
    And I set fields
      | such     | BAUGRUPPE-BA                    |
      | namebspr | auftrags- & bedarfsbez Material |
      | dispoa   | bedarfsbezogen                  |
      | bsart    | Eigenfertigung                  |
      | wgruppe  | 55                              |
      | erlgrp   | 66                              |
    And I delete all rows
    And I append rows
      | elex        | anzahl | manbu |
      | EINKAUF-1   | 2      | ja    |
      | B_EINKAUF-2 | 1      | ja    |
      | A MONTAGE1  | 1      |       |
    And I save the current editor

# Bestände auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "S-KORR02"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "S-KORR02"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F3" with document "S-KORR02"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1" with document "S-KORR02"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F2" with document "S-KORR02"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F3" with document "S-KORR02"

# Auftrag anlegen und Bedarfe buchen
    Given I create a SalesOrder "auftrag2" for Customer "RADSHOP" with Product "BAUGRUPPE-BA" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-1" and quantity "10" on StorageLocation "F1" with document "ZUGANG-2A" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-1" and quantity "10" on StorageLocation "F2" with document "ZUGANG-2A" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "5" on StorageLocation "F1" with document "ZUGANG-2A" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "5" on StorageLocation "F2" with document "ZUGANG-2A" and price "0"

# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | mge | mfreig | bisuch    |
      | BAUGRUPPE-BA | 10  | ja     | PLAETZE9_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "PLAETZE9_001"
    And I close the current editor

# Materialentnahme1 von F1 und Materialentnahme2 von F2
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | EntnahmeF1             |
      | gmgevorschl | 3                      |
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE9_001;manrm=ja;bem=EntnahmeF1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | EntnahmeF2             |
      | gmgevorschl | 3                      |
    And I press button "stlvblad"
    And I modify table
      | buplatz | !row |
      | F2      | 1    |
      | F2      | 2    |
    And I save the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE9_001;manrm=ja;bem=EntnahmeF2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then the table has 4 rows
    Then table has values
      | art         | vplatz | amge |
      | EINKAUF-1   | F2     | 6    |
      | B_EINKAUF-2 | F2     | 3    |
      | EINKAUF-1   | F1     | 6    |
      | B_EINKAUF-2 | F1     | 3    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lplatz | lemge | gebmge |
      | F1     | 4     |        |
      | F1     |       | 4      |
      | F2     | 4     |        |
      | F2     |       | 4      |
    And I set fields
      | artikel | B_EINKAUF-2 |
      | details | nein        |
    And I press start
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lplatz | lemge | gebmge |
      | F1     | 2     |        |
      | F1     |       | 2      |
      | F2     | 2     |        |
      | F2     |       | 2      |
    And I close the current editor

# Rückgabe1 auf Lagerplatz aus Entnahme und Rückgabe2 auf anderen Lagerplatz
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | RückgabeF1             |
      | gmgevorschl | -1                     |
    And I press button "stlvblad"
    And I modify table
      | !row | buplatz |
      | 1    | F1      |
      | 2    | F1      |
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE9_001;manrm=ja;bem=RückgabeF1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | RückgabeF3             |
      | gmgevorschl | -1                     |
    And I press button "stlvblad"
    And I modify table
      | !row | buplatz |
      | 1    | F3      |
      | 2    | F3      |
    And I save the current editor

    Given I open an editor "Materialrückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE9_001;manrm=ja;bem=RückgabeF3;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then the table has 8 rows
    Then table has values
      | art         | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1   | F3     | -2   | -2       | 0       | 1    |
      | B_EINKAUF-2 | F3     | -1   | -1       | 0       | 2    |
      | EINKAUF-1   | F1     | -2   | -2       | 0       | 3    |
      | B_EINKAUF-2 | F1     | -1   | -1       | 0       | 4    |
      | EINKAUF-1   | F2     | 6    | 4        | 2       | 5    |
      | B_EINKAUF-2 | F2     | 3    | 2        | 1       | 6    |
      | EINKAUF-1   | F1     | 6    | 0        | 6       | 7    |
      | B_EINKAUF-2 | F1     | 3    | 0        | 3       | 8    |
    Then field "rueckorig" in row 1 has value equal to field "verweis" from editor "LJ" in row 5
    Then field "rueckorig" in row 2 has value equal to field "verweis" from editor "LJ" in row 6
    Then field "rueckorig" in row 3 has value equal to field "verweis" from editor "LJ" in row 5
    Then field "rueckorig" in row 4 has value equal to field "verweis" from editor "LJ" in row 6
    And I close the current editor

    Given I open the infosystem "BESTAND"
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
      | lplatz | lemge | gebmge |
      | F1     | 6     |        |
      | F1     |       | 4      |
      | F1     |       | 2      |
      | F2     | 4     |        |
      | F2     |       | 4      |
      | F3     | 2     |        |
      | F3     |       | 2      |
    And I set fields
      | artikel | B_EINKAUF-2 |
      | details | nein        |
    And I press start
    And I press button "taufzu" in row 3
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 7 rows
    Then table has values
      | lplatz | lemge | gebmge |
      | F1     | 3     |        |
      | F1     |       | 2      |
      | F1     |       | 1      |
      | F2     | 2     |        |
      | F2     |       | 2      |
      | F3     | 1     |        |
      | F3     |       | 1      |
    And I close the current editor

# Rückgabe auf Lagerplätze aus Entnahme, Menge betrifft 2 Buchungen
    Given I open an editor "Materialrückgabe3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Rückgabe_3             |
      | gmgevorschl | -3                     |
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialrückgabe3" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE9_001;manrm=ja;bem=Rückgabe_3;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then the table has 12 rows
    Then table has values
      | art         | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1   | F1     | -4   | -4       | 0       | 1    |
      | EINKAUF-1   | F1     | -2   | -2       | 0       | 2    |
      | B_EINKAUF-2 | F1     | -2   | -2       | 0       | 3    |
      | B_EINKAUF-2 | F1     | -1   | -1       | 0       | 4    |
      | EINKAUF-1   | F3     | -2   | -2       | 0       | 5    |
      | B_EINKAUF-2 | F3     | -1   | -1       | 0       | 6    |
      | EINKAUF-1   | F1     | -2   | -2       | 0       | 7    |
      | B_EINKAUF-2 | F1     | -1   | -1       | 0       | 8    |
      | EINKAUF-1   | F2     | 6    | 6        | 0       | 9    |
      | B_EINKAUF-2 | F2     | 3    | 3        | 0       | 10   |
      | EINKAUF-1   | F1     | 6    | 4        | 2       | 11   |
      | B_EINKAUF-2 | F1     | 3    | 2        | 1       | 12   |
    Then field "rueckorig" in row 1 has value equal to field "verweis" from editor "LJ" in row 11
    Then field "rueckorig" in row 3 has value equal to field "verweis" from editor "LJ" in row 9
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 3
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 9 rows
    Then table has values
      | lplatz | lemge | gebmge |
      | F1     | 12    |        |
      | F1     |       | 4      |
      | F1     |       | 2      |
      | F1     |       | 2      |
      | F1     |       | 4      |
      | F2     | 4     |        |
      | F2     |       | 4      |
      | F3     | 2     |        |
      | F3     |       | 2      |
    And I set fields
      | artikel | B_EINKAUF-2 |
      | details | nein        |
    And I press start
    And I press button "taufzu" in row 3
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 9 rows
    Then table has values
      | lplatz | lemge | gebmge |
      | F1     | 6     |        |
      | F1     |       | 2      |
      | F1     |       | 1      |
      | F1     |       | 1      |
      | F1     |       | 2      |
      | F2     | 2     |        |
      | F2     |       | 2      |
      | F3     | 1     |        |
      | F3     |       | 1      |
    And I close the current editor

	# Storno des Rückbaus, in Reihenfolge der Buchung
    Given I open an editor "Materialrückgabe1_Storno" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open an editor "Materialrückgabe2_Storno" via ID from editor "Materialrückgabe2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open an editor "Materialrückgabe3_Storno" via ID from editor "Materialrückgabe3" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

	# Storno- und stornierte Belege prüfen
    Given I switch the current editor to editor "Materialrückgabe1" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE-BA | 0        | 0       | 0      | 0      |
      | -1  | B_EINKAUF-2  | -1       | 0       | 4      | 5      |
      | -2  | EINKAUF-1    | -2       | 0       | 8      | 10     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe2" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE-BA | 0        | 0       | 0      | 0      |
      | -1  | B_EINKAUF-2  | -1       | 0       | 5      | 6      |
      | -2  | EINKAUF-1    | -2       | 0       | 10     | 12     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe3" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE-BA | 0        | 0       | 0      | 0      |
      | -3  | B_EINKAUF-2  | -3       | 0       | 6      | 9      |
      | -6  | EINKAUF-1    | -6       | 0       | 12     | 18     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe1^id"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE-BA | 0        | 0       | 0      | 0      |
      | 1   | B_EINKAUF-2  | 0        | 1       | 9      | 8      |
      | 2   | EINKAUF-1    | 0        | 2       | 18     | 16     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe2_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe2^id"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE-BA | 0        | 0       | 0      | 0      |
      | 1   | B_EINKAUF-2  | 0        | 1       | 8      | 7      |
      | 2   | EINKAUF-1    | 0        | 2       | 16     | 14     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe3_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe3^id"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE-BA | 0        | 0       | 0      | 0      |
      | 3   | B_EINKAUF-2  | 0        | 3       | 7      | 4      |
      | 6   | EINKAUF-1    | 0        | 6       | 14     | 8      |
    And I close the current editor

# FV abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | lpsuch |
      | 1    | 4      | F1     |
      | +2   | 4      | F2     |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "Materialzuordnung"
    And I modify table
      | !row | zuomge | lpsuch |
      | 1    | 2      | F1     |
      | +2   | 2      | F2     |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme3"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZE9_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel | B_EINKAUF-2 |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag2" with PackingSlip "PS-A02"


  Scenario: 03 Rückgabe und Storno Rückgabe mit scharfer und unscharfer Verwendung auf verschiedene Lagerplätze auf letzten AS, bisher Teilmenge über Fbuch entnommen
    And I set the fake date to "04.01.1995"
# Bestände auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "S-KORR03"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "S-KORR03"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "S-KORR03"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F2" with document "S-KORR03"

# Auftrag anlegen und Bedarfe mit scharfer und unscharfer Verwendung einkaufen
    Given I create a SalesOrder "auftrag3" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "Rechnung3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ueb    | ja        |
      | fakt   | ja        |
      | ebeleg | Rechnung3 |
    And I append rows
      | artikel   | mge | verw             |
      | EINKAUF-1 | 10  | !auftrag3^nummer |
      | EINKAUF-1 | 10  |                  |
      | EINKAUF-2 | 5   | !auftrag3^nummer |
      | EINKAUF-2 | 5   |                  |
    And I set field "verw" in row 2 to "verw" from editor "auftrag3" in row 1
    And I set field "verw" in row 4 to "verw" from editor "auftrag3" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch   |
      | M_BAUGRUPPE | 10  | ja     | VERWEND_ |
    And I set field "verw" in row 1 to "verw" from editor "auftrag3" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "VERWEND_001"
    And I close the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 8                      |
    And I press button "stlvblad"
    And I save the current editor

# Materialrückgabe ohne Angabe der MZ
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | RückgabeM1             |
      | gmgevorschl | -2                     |
    And I press button "stlvblad"
    Then the table has 2 rows
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=VERWEND_001;bem=RückgabeM1;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen, unscharfe Verwendung wurde zurückgebucht
		# scharfe Verwendung entspricht Verwendung in Arbeitsschein1
		# unscharfe Verwendung entspricht Nummer des Auftrags
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then the table has 6 rows
    Then table has values
      | art       | amge | rueckmge | restmge | verw                 | verwla               | !row |
      | EINKAUF-1 | -4   | -4       | 0       | !Arbeitsschein1^verw | !auftrag3^nummer     | 1    |
      | EINKAUF-2 | -2   | -2       | 0       | !Arbeitsschein1^verw | !auftrag3^nummer     | 2    |
      | EINKAUF-1 | 6    | 4        | 2       | !Arbeitsschein1^verw | !auftrag3^nummer     | 3    |
      | EINKAUF-1 | 10   | 0        | 10      | !Arbeitsschein1^verw | !Arbeitsschein1^verw | 4    |
      | EINKAUF-2 | 3    | 2        | 1       | !Arbeitsschein1^verw | !auftrag3^nummer     | 5    |
      | EINKAUF-2 | 5    | 0        | 5       | !Arbeitsschein1^verw | !Arbeitsschein1^verw | 6    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lplatz | lemge | gebmge | verw             | kopfzugvorg^id |
      | F1     | 8     |        |                  | (0,0,0)        |
      | F1     |       | 4      | !auftrag3^nummer | !Rechnung3^id  |
      | F1     |       | 4      | !auftrag3^nummer | !Rechnung3^id  |
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lplatz | lemge | gebmge | verw             | kopfzugvorg^id |
      | F1     | 4     |        |                  | (0,0,0)        |
      | F1     |       | 2      | !auftrag3^nummer | !Rechnung3^id  |
      | F1     |       | 2      | !auftrag3^nummer | !Rechnung3^id  |
    And I close the current editor

# Materialrückgabe MZ passend mit scharfer und unscharfer Verwendung
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | RückgabeM2             |
      | gmgevorschl | -4                     |
    And I press button "stlvblad"
    Then the table has 2 rows
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge | platz |
      | 1    | -4     | F1    |
      | +2   | -4     | F2    |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe2"
    And I save the current editor

    Given I open an editor "Materialrückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=VERWEND_001;bem=RückgabeM2;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen, unscharfe Verwendung wurde zurückgebucht
		# scharfe Verwendung entspricht Verwendung in Arbeitsschein1
		# unscharfe Verwendung entspricht Nummer des Auftrags
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then the table has 11 rows
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | verw                 | verwla               | !row |
      | EINKAUF-1 | F2     | -4   | -4       | 0       | !Arbeitsschein1^verw | !Arbeitsschein1^verw | 1    |
      | EINKAUF-1 | F1     | -2   | -2       | 0       | !Arbeitsschein1^verw | !Arbeitsschein1^verw | 2    |
      | EINKAUF-1 | F1     | -2   | -2       | 0       | !Arbeitsschein1^verw | !auftrag3^nummer     | 3    |
      | EINKAUF-2 | F1     | -3   | -3       | 0       | !Arbeitsschein1^verw | !Arbeitsschein1^verw | 4    |
      | EINKAUF-2 | F1     | -1   | -1       | 0       | !Arbeitsschein1^verw | !auftrag3^nummer     | 5    |
      | EINKAUF-1 | F1     | -4   | -4       | 0       | !Arbeitsschein1^verw | !auftrag3^nummer     | 6    |
      | EINKAUF-2 | F1     | -2   | -2       | 0       | !Arbeitsschein1^verw | !auftrag3^nummer     | 7    |
      | EINKAUF-1 | F1     | 6    | 6        | 0       | !Arbeitsschein1^verw | !auftrag3^nummer     | 8    |
      | EINKAUF-1 | F1     | 10   | 6        | 4       | !Arbeitsschein1^verw | !Arbeitsschein1^verw | 9    |
      | EINKAUF-2 | F1     | 3    | 3        | 0       | !Arbeitsschein1^verw | !auftrag3^nummer     | 10   |
      | EINKAUF-2 | F1     | 5    | 3        | 2       | !Arbeitsschein1^verw | !Arbeitsschein1^verw | 11   |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 5 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id | verw                 |
      | F1     | 12    |        | (0,0,0)        |                      |
      | F1     |       | 4      | !Rechnung3^id  | !auftrag3^nummer     |
      | F1     |       | 4      | !Rechnung3^id  | !auftrag3^nummer     |
      | F1     |       | 2      | !Rechnung3^id  | !auftrag3^nummer     |
      | F1     |       | 2      | !Rechnung3^id  | !Arbeitsschein1^verw |
    And I set fields
      | klplatz | F2   |
      | details | nein |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id | verw                 |
      | F2     | 4     |        | (0,0,0)        |                      |
      | F2     |       | 4      | !Rechnung3^id  | !Arbeitsschein1^verw |
    And I set fields
      | artikel    | EINKAUF-2 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 5 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id | verw                 |
      | F1     | 8     |        | (0,0,0)        |                      |
      | F1     |       | 2      | !Rechnung3^id  | !auftrag3^nummer     |
      | F1     |       | 2      | !Rechnung3^id  | !auftrag3^nummer     |
      | F1     |       | 1      | !Rechnung3^id  | !auftrag3^nummer     |
      | F1     |       | 3      | !Rechnung3^id  | !Arbeitsschein1^verw |
    And I close the current editor

# Storno Rückbau, zuletzt gebuchter Rückbau wird zuerst storniert
    Given I open an editor "Materialrückgabe2_Storno" via ID from editor "Materialrückgabe2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open an editor "Materialrückgabe1_Storno" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Storno- und stornierte Belege prüfen
    Given I switch the current editor to editor "Materialrückgabe2" with command "VIEW"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -4  | EINKAUF-2   | -4       | 0       | 4      | 8      |
      | -8  | EINKAUF-1   | -8       | 0       | 8      | 16     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1" with command "VIEW"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -2  | EINKAUF-2   | -2       | 0       | 2      | 4      |
      | -4  | EINKAUF-1   | -4       | 0       | 4      | 8      |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe2_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe2^id"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 4   | EINKAUF-2   | 0        | 4       | 8      | 4      |
      | 8   | EINKAUF-1   | 0        | 8       | 16     | 8      |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe1^id"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 2   | EINKAUF-2   | 0        | 2       | 4      | 2      |
      | 4   | EINKAUF-1   | 0        | 4       | 8      | 4      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id | verw             |
      | F1     | 4     |        | (0,0,0)        |                  |
      | F1     |       | 2      | !Rechnung3^id  | !auftrag3^nummer |
      | F1     |       | 2      | !Rechnung3^id  | !auftrag3^nummer |
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id | verw             |
      | F1     | 2     |        | (0,0,0)        |                  |
      | F1     |       | 1      | !Rechnung3^id  | !auftrag3^nummer |
      | F1     |       | 1      | !Rechnung3^id  | !auftrag3^nummer |
    And I close the current editor

# Betriebsauftrag abschließen, Bestand prüfen und liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "VERWEND_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag3" with PackingSlip "LS-03"


  Scenario: 04 Rückgabe und Storno Rückgabe auf verschiedene Plätze über BA und AS mit Bestandsumbuchung aufgrund negativer Zeilen, bisher Entnahmen auf letzten AS und BA gebucht, EntnahmeMZ Plätze vor Freigabe FV angelegt
    And I set the fake date to "05.01.1995"
# Bestandskorrektur auf 0
    Given  I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORRX04"
    Given  I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "KORRX04"
    Given  I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F3" with document "KORRX04"

    # Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag4" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "Rechnung4" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ueb    | ja        |
      | fakt   | ja        |
      | ebeleg | Rechnung4 |
    And I append rows
      | artikel   | mge | platz |
      | EINKAUF-1 | 10  | F1    |
      | EINKAUF-1 | 10  | F2    |
      | EINKAUF-2 | 10  | F1    |
    And I set field "verw" in row 1 to "verw" from editor "auftrag4" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag4" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag4" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig |
      | M_BAUGRUPPE | 10  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag4" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | !row | zuomge | platz |
      | +1   | 10     | F1    |
      | +2   | 10     | F2    |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "RUECKBAX_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RUECKBAX_000"
    And I close the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RUECKBAX_001"
    And I close the current editor

# Materialentnahme auf Arbeitsschein
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | EntnahmeAS             |
      | gmgevorschl | 7                      |
    And I press button "stlvblad"
    Then the table has 2 rows
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RUECKBAX_001;manrm=ja;bem=EntnahmeAS;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Materialrückgabe auf Betriebsauftrag
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Betriebsauftrag^nummer |
      | gmgevorschl | -3                      |
      | bem         | RückgabeBA              |
      | mgr         | 112                     |
    And I press button "stllad"
    Then the table has 2 rows
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge | platz |
      | 1    | -2     | F3    |
      | +2   | -4     | F1    |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RUECKBAX_000;manrm=ja;bem=RückgabeBA;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | artikel  | EINKAUF-1              |
      | richtung | rückwärts              |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1 | F2     | 4    | 4        | 0       | 1    |
      | EINKAUF-1 | F1     | 10   | 2        | 8       | 2    |
    And I set fields
      | beleg | !Betriebsauftrag^nummer |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1 | F1     | -2   | -2       | 0       | 1    |
      | EINKAUF-1 | F1     | -2   | -2       | 0       | 2    |
      | EINKAUF-1 | F3     | -2   | -2       | 0       | 3    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
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
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 4     |        | (0,0,0)        |
      | F1     |       | 2      | !Rechnung4^id  |
      | F1     |       | 2      | !Rechnung4^id  |
      | F2     | 6     |        | (0,0,0)        |
      | F2     |       | 6      | !Rechnung4^id  |
      | F3     | 2     |        | (0,0,0)        |
      | F3     |       | 2      | !Rechnung4^id  |
    And I close the current editor

# Materialentnahme auf Betriebsauftrag
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Betriebsauftrag^nummer |
      | gmgevorschl | 1                       |
      | bem         | EntnahmeBA              |
      | mgr         | 112                     |
    And I press button "stllad"
    Then the table has 2 rows
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Entnahme" in row 1
    And I modify table
      | !row | zuomge | platz |
      | 1    | 1      | F2    |
      | +2   | 1      | F3    |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RUECKBAX_000;manrm=ja;bem=EntnahmeBA;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Materialrückgabe auf Arbeitsschein
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | RückgabeAS             |
      | gmgevorschl | -1                     |
    And I press button "stlvblad"
    Then the table has 2 rows
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge | platz |
      | 1    | -1     | F1    |
      | +2   | -1     | F2    |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe2"
    And I save the current editor

    Given I open an editor "Materialrückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RUECKBAX_001;manrm=ja;bem=RückgabeAS;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen für Materialrückgabe2
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | artikel  | EINKAUF-1              |
      | richtung | rückwärts              |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1 | F2     | -1   | -1       | 0       | 1    |
      | EINKAUF-1 | F1     | -1   | -1       | 0       | 2    |
      | EINKAUF-1 | F2     | 4    | 4        | 0       | 3    |
      | EINKAUF-1 | F1     | 10   | 2        | 8       | 4    |
    And I set fields
      | beleg | !Betriebsauftrag^nummer |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1 | F3     | 1    | 1        | 0       | 1    |
      | EINKAUF-1 | F2     | 1    | 1        | 0       | 2    |
      | EINKAUF-1 | F1     | -2   | -2       | 0       | 3    |
      | EINKAUF-1 | F1     | -2   | -2       | 0       | 4    |
      | EINKAUF-1 | F3     | -2   | -2       | 0       | 5    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 3
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 9 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 5     |        | (0,0,0)        |
      | F1     |       | 2      | !Rechnung4^id  |
      | F1     |       | 2      | !Rechnung4^id  |
      | F1     |       | 1      | !Rechnung4^id  |
      | F2     | 6     |        | (0,0,0)        |
      | F2     |       | 5      | !Rechnung4^id  |
      | F2     |       | 1      | !Rechnung4^id  |
      | F3     | 1     |        | (0,0,0)        |
      | F3     |       | 1      | !Rechnung4^id  |
    And I close the current editor

# Storno der Rückgaben, letzte Rückgabe wird zuerst storniert
    Given I open an editor "Materialrückgabe2_Storno" via ID from editor "Materialrückgabe2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open an editor "Materialrückgabe1_Storno" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Storno- und stornierte Belege prüfen
    Given I switch the current editor to editor "Materialrückgabe2" with command "VIEW"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -1  | EINKAUF-2   | -1       | 0       | 5      | 6      |
      | -2  | EINKAUF-1   | -2       | 0       | 10     | 12     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1" with command "VIEW"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -3  | EINKAUF-2   | -3       | 0       | 3      | 6      |
      | -6  | EINKAUF-1   | -6       | 0       | 6      | 12     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe2_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe2^id"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 1   | EINKAUF-2   | 0        | 1       | 6      | 5      |
      | 2   | EINKAUF-1   | 0        | 2       | 12     | 10     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe1^id"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 3   | EINKAUF-2   | 0        | 3       | 5      | 2      |
      | 6   | EINKAUF-1   | 0        | 6       | 10     | 4      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 5 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id        |
      | F2     | 5     |        | (0,0,0)               |
      | F2     |       | 4      | !Rechnung4^id         |
      | F2     |       | 1      | !Rechnung4^id         |
      | F3     | -1    |        | (0,0,0)               |
      | F3     |       | -1     | !Materialentnahme1^id |
    And I close the current editor

    Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | EINKAUF-1 |
      | beleg   | UMBUCH4   |
      | beldat  | .         |
      | buart   | Umbuchung |
    And I modify table
      | !row | mge | platz2 | platz | verw                 | verw2                |
      | +1   | 5   | F3     | F2    | !Arbeitsschein1^verw | !Arbeitsschein1^verw |
    And I save the current editor

# FV abschließen, Auftrag liefern
    Given I open an editor "Materialentnahme3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stlvblad"
    And I set field "buplatz" to "F3" in row 1
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKBAX_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag4" with PackingSlip "LS-04"


  Scenario: 05 Rückgabe und Storno Rückgabe auf verschiedene Plätze über AS mit Bestandsumbuchung aufgrund negativer Zeilen, bisher Entnahmen auf letzten AS gebucht
    And I set the fake date to "06.01.1995"
# Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-05"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "KORR-05"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F3" with document "KORR-05"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag5" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "Rechnung5" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ueb    | ja        |
      | fakt   | ja        |
      | ebeleg | Rechnung5 |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag5" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag5" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch   |
      | M_BAUGRUPPE | 10  | ja     | RUECKBA_ |
    And I set field "verw" in row 1 to "verw" from editor "auftrag5" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RUECKBA_000"
    And I close the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RUECKBA_001"
    And I close the current editor

# Materialentnahme auf Arbeitsschein
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Entnahme1              |
      | gmgevorschl | 5                      |
    And I press button "stlvblad"
    Then the table has 2 rows
    And I save the current editor

# Materialrückgabe auf Betriebsauftrag
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Rückgabe1              |
      | gmgevorschl | -2                     |
      | mgr         | 112                    |
    And I press button "stllad"
    Then the table has 2 rows
    Then table has values
      | bumge | entmge | limge | nlimge | !row |
      | -4    | 10     | 10    | 14     | 1    |
      | -2    | 5      | 5     | 7      | 2    |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge | platz |
      | 1    | -2     | F2    |
      | +2   | -2     | F1    |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RUECKBA_001;bem=Rückgabe1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | artikel  | EINKAUF-1 |
      | richtung | rückwärts |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1 | F1     | -2   | -2       | 0       | 1    |
      | EINKAUF-1 | F2     | -2   | -2       | 0       | 2    |
      | EINKAUF-1 | F1     | 10   | 4        | 6       | 3    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 3
    And I set fields
      | artikel  | EINKAUF-2 |
      | richtung | rückwärts |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-2 | F1     | -2   | -2       | 0       | 1    |
      | EINKAUF-2 | F1     | 5    | 2        | 3       | 2    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 5 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 12    |        | (0,0,0)        |
      | F1     |       | 10     | !Rechnung5^id  |
      | F1     |       | 2      | !Rechnung5^id  |
      | F2     | 2     |        | (0,0,0)        |
      | F2     |       | 2      | !Rechnung5^id  |
    And I close the current editor

# Materialentnahme auf Betriebsauftrag
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Entnahme2              |
      | gmgevorschl | 4                      |
      | mgr         | 112                    |
    And I press button "stllad"
    Then the table has 2 rows
    Then table has values
      | bumge | entmge | limge | !row |
      | 8     | 6      | 14    | 1    |
      | 4     | 3      | 7     | 2    |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Entnahme" in row 1
    And I modify table
      | !row | zuomge | platz |
      | 1    | 4      | F2    |
      | +2   | 4      | F1    |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

# Materialrückgabe auf Arbeitsschein
    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Rückgabe2              |
      | gmgevorschl | -3                     |
    And I press button "stlvblad"
    Then the table has 2 rows
    Then table has values
      | bumge | entmge | limge | nlimge | !row |
      | -6    | 14     | 6     | 12     | 1    |
      | -3    | 7      | 3     | 6      | 2    |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge | platz |
      | 1    | -3     | F3    |
      | +2   | -3     | F2    |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe2"
    And I save the current editor

    Given I open an editor "Materialrückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RUECKBA_001;bem=Rückgabe2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen für Materialrückgabe2
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | artikel  | EINKAUF-1              |
      | richtung | rückwärts              |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1 | F2     | -2   | -2       | 0       | 1    |
      | EINKAUF-1 | F2     | -1   | -1       | 0       | 2    |
      | EINKAUF-1 | F3     | -3   | -3       | 0       | 3    |
      | EINKAUF-1 | F1     | 4    | 4        | 0       | 4    |
      | EINKAUF-1 | F2     | 4    | 2        | 2       | 5    |
      | EINKAUF-1 | F1     | -2   | -2       | 0       | 6    |
      | EINKAUF-1 | F2     | -2   | -2       | 0       | 7    |
      | EINKAUF-1 | F1     | 10   | 4        | 6       | 8    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "rueckorig^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | artikel  | EINKAUF-2              |
      | richtung | rückwärts              |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-2 | F1     | -3   | -3       | 0       | 1    |
      | EINKAUF-2 | F1     | 4    | 3        | 1       | 2    |
      | EINKAUF-2 | F1     | -2   | -2       | 0       | 3    |
      | EINKAUF-2 | F1     | 5    | 2        | 3       | 4    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    And I close the current editor

    Given I open the infosystem "BESTAND"
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
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 8     |        | (0,0,0)        |
      | F1     |       | 6      | !Rechnung5^id  |
      | F1     |       | 2      | !Rechnung5^id  |
      | F2     | 1     |        | (0,0,0)        |
      | F2     |       | 1      | !Rechnung5^id  |
      | F3     | 3     |        | (0,0,0)        |
      | F3     |       | 3      | !Rechnung5^id  |
    And I close the current editor

# Rückgaben stornieren, zuletzt geuchter Rückbau wird zuerst storniert
    Given I open an editor "Materialrückgabe2_Storno" via ID from editor "Materialrückgabe2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open an editor "RMPRUEFENT1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RUECKBA_001;bem=Entnahme1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "RMPRUEFENT2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RUECKBA_001;bem=Entnahme2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
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
      | lplatz | lemge | gebmge | kopfzugvorg^id  |
      | F1     | 8     |        | (0,0,0)         |
      | F1     |       | 6      | !Rechnung5^id   |
      | F1     |       | 2      | !Rechnung5^id   |
      | F2     | -2    |        | (0,0,0)         |
      | F2     |       | -1     | !RMPRUEFENT2^id |
      | F2     |       | -1     | !RMPRUEFENT2^id |
    And I close the current editor

    Given I open an editor "Materialrückgabe1_Storno" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Storno- und stornierte Belege prüfen
    Given I switch the current editor to editor "Materialrückgabe2" with command "VIEW"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -3  | EINKAUF-2   | -3       | 0       | 3      | 6      |
      | -6  | EINKAUF-1   | -6       | 0       | 6      | 12     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1" with command "VIEW"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -2  | EINKAUF-2   | -2       | 0       | 5      | 7      |
      | -4  | EINKAUF-1   | -4       | 0       | 10     | 14     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe2_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe2^id"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 3   | EINKAUF-2   | 0        | 3       | 6      | 3      |
      | 6   | EINKAUF-1   | 0        | 6       | 12     | 6      |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe1^id"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 2   | EINKAUF-2   | 0        | 2       | 3      | 1      |
      | 4   | EINKAUF-1   | 0        | 4       | 6      | 2      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 7 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id  |
      | F1     | 6     |        | (0,0,0)         |
      | F1     |       | 4      | !Rechnung5^id   |
      | F1     |       | 2      | !Rechnung5^id   |
      | F2     | -4    |        | (0,0,0)         |
      | F2     |       | -1     | !RMPRUEFENT2^id |
      | F2     |       | -1     | !RMPRUEFENT2^id |
      | F2     |       | -2     | !RMPRUEFENT1^id |
    And I close the current editor

    Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | EINKAUF-1 |
      | beleg   | UMBUCH5   |
      | beldat  | .         |
      | buart   | Umbuchung |
    And I modify table
      | !row | mge | platz2 | platz | verw                 | verw2                |
      | +1   | 6   | F2     | F1    | !Arbeitsschein1^verw | !Arbeitsschein1^verw |
    And I save the current editor

# FV abschließen, Auftrag liefern
    Given I open an editor "Materialentnahme3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stlvblad"
    And I set field "buplatz" to "F2" in row 1
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKBA_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag5" with PackingSlip "LS-05"


  Scenario: 06 Rückgabe auf verschiedene Plätze über verschiedene AS, bisher Entnahmen auf AS1 und AS2, EntnahmeMZ Plätze vor Freigabe FV angelegt
    And I set the fake date to "07.01.1995"
# Bestände auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "S-KORR06"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "S-KORR06"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F3" with document "S-KORR06"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "S-KORR06"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F2" with document "S-KORR06"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F3" with document "S-KORR06"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag6" for Customer "RADSHOP" with Product "M_BAUGRUPPE2" and quantity "10"

    Given I open an editor "rechnung6" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ueb    | ja        |
      | fakt   | ja        |
      | ebeleg | Rechnung6 |
    And I append rows
      | artikel   | mge | platz |
      | EINKAUF-1 | 10  | F1    |
      | EINKAUF-1 | 10  | F2    |
      | EINKAUF-2 | 10  | F1    |
    And I set field "verw" in row 1 to "verw" from editor "auftrag6" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag6" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag6" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | mge | mfreig |
      | M_BAUGRUPPE2 | 10  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag6" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | zuomge | platz | !row |
      | 10     | F1    | +1   |
      | 10     | F2    | +2   |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | zuomge | platz | !row |
      | 10     | F1    | +1   |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "PLAETZEBG2_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "PLAETZEBG2_001"
    And I close the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "PLAETZEBG2_002"
    And I close the current editor

# Materialentnahme EINKAUF-1 auf Arbeitsschein1
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 4                      |
    And I press button "stlvblad"
    Then the table has 1 rows
    And I save the current editor

# Materialentnahme EINKAUF-2 auf Arbeitsschein2
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein2^nummer |
      | gmgevorschl | 2                      |
    And I press button "stlvblad"
    Then the table has 1 rows
    And I save the current editor

# Materialentnahme EINKAUF-1 und EINKAUF-2 auf Arbeitsschein2
    And I wait 2 time units to move the time forward
    Given I open an editor "Materialentnahme3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein2^nummer |
      | gmgevorschl | 3                      |
    And I press button "stllad"
    Then the table has 2 rows
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F2     | 6     |        | (0,0,0)        |
      | F2     |       | 6      | !rechnung6^id  |
    And I set fields
      | artikel    | EINKAUF-2 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 5     |        | (0,0,0)        |
      | F1     |       | 5      | !rechnung6^id  |
    And I close the current editor

# Materialrückgabe EINKAUF-1 und EINKAUF-2 über Arbeitsschein2 auf verschiedene Plätze
    And I wait 2 time units to move the time forward
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein2^nummer |
      | bem         | Rückbau1_AS2           |
      | gmgevorschl | -4                     |
    And I press button "stllad"
    Then the table has 2 rows
    And I press button "mzsubm" to open a subeditor for "MZ_Rückgabe" in row 1
    And I modify table
      | platz | zuomge | !row |
      | F1    | -4     | 1    |
      | F3    | -4     | +2   |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ_Rückgabe"
    And I modify table
      | platz | zuomge | !row |
      | F1    | -2     | 1    |
      | F2    | -2     | +2   |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZEBG2_002;bem=Rückbau1_AS2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
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
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 4     |        | (0,0,0)        |
      | F1     |       | 4      | !rechnung6^id  |
      | F2     | 6     |        | (0,0,0)        |
      | F2     |       | 6      | !rechnung6^id  |
      | F3     | 4     |        | (0,0,0)        |
      | F3     |       | 2      | !rechnung6^id  |
      | F3     |       | 2      | !rechnung6^id  |
    And I set fields
      | artikel    | EINKAUF-2 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 6 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 7     |        | (0,0,0)        |
      | F1     |       | 5      | !rechnung6^id  |
      | F1     |       | 2      | !rechnung6^id  |
      | F2     | 2     |        | (0,0,0)        |
      | F2     |       | 1      | !rechnung6^id  |
      | F2     |       | 1      | !rechnung6^id  |
    And I close the current editor

# Materialrückgabe EINKAUF-1 über Arbeitsschein1 auf verschiedene Plätze
    And I wait 2 time units to move the time forward
    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Rückbau2_AS1           |
      | gmgevorschl | -1                     |
    And I press button "stlvblad"
    Then the table has 1 rows
    And I press button "mzsubm" to open a subeditor for "MZ_Rückgabe" in row 1
    And I modify table
      | platz | zuomge | !row |
      | F2    | -1     | 1    |
      | F3    | -1     | +2   |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe2"
    And I save the current editor

    Given I open an editor "Materialrückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZEBG2_001;bem=Rückbau2_AS1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 3
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 9 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 4     |        | (0,0,0)        |
      | F1     |       | 4      | !rechnung6^id  |
      | F2     | 7     |        | (0,0,0)        |
      | F2     |       | 6      | !rechnung6^id  |
      | F2     |       | 1      | !rechnung6^id  |
      | F3     | 5     |        | (0,0,0)        |
      | F3     |       | 2      | !rechnung6^id  |
      | F3     |       | 2      | !rechnung6^id  |
      | F3     |       | 1      | !rechnung6^id  |
    And I set fields
      | artikel    | EINKAUF-2 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 6 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 7     |        | (0,0,0)        |
      | F1     |       | 5      | !rechnung6^id  |
      | F1     |       | 2      | !rechnung6^id  |
      | F2     | 2     |        | (0,0,0)        |
      | F2     |       | 1      | !rechnung6^id  |
      | F2     |       | 1      | !rechnung6^id  |
    And I close the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | artikel  | EINKAUF-1              |
      | richtung | rückwärts              |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1 | F3     | -1   | -1       | 0       | 1    |
      | EINKAUF-1 | F2     | -1   | -1       | 0       | 2    |
      | EINKAUF-1 | F1     | 8    | 4        | 4       | 3    |
    And I set fields
      | beleg    | !Arbeitsschein2^nummer |
      | artikel  | EINKAUF-1              |
      | richtung | rückwärts              |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1 | F3     | -2   | -2       | 0       | 1    |
      | EINKAUF-1 | F3     | -2   | -2       | 0       | 2    |
      | EINKAUF-1 | F1     | -4   | -4       | 0       | 3    |
      | EINKAUF-1 | F2     | 4    | 4        | 0       | 4    |
      | EINKAUF-1 | F1     | 2    | 2        | 0       | 5    |
    And I close the current editor

# Rückbau stornieren, letzte Rückgabe zuerst stornieren
    Given I open an editor "Materialrückgabe2_Storno" via ID from editor "Materialrückgabe2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open an editor "Materialrückgabe1_Storno" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Storno- und stornierte Belege prüfen
    Given I switch the current editor to editor "Materialrückgabe2" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE2 | 0        | 0       | 0      | 0      |
      | -2  | EINKAUF-1    | -2       | 0       | 14     | 16     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE2 | 0        | 0       | 0      | 0      |
      | -4  | EINKAUF-2    | -4       | 0       | 5      | 9      |
      | -8  | EINKAUF-1    | -8       | 0       | 6      | 14     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe2_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe2^id"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE2 | 0        | 0       | 0      | 0      |
      | 2   | EINKAUF-1    | 0        | 2       | 16     | 14     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe1^id"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE2 | 0        | 0       | 0      | 0      |
      | 4   | EINKAUF-2    | 0        | 4       | 9      | 5      |
      | 8   | EINKAUF-1    | 0        | 8       | 14     | 6      |
    And I close the current editor

# FV abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme4" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein2^nummer |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ_Entnahme" in row 1
    And I delete all rows
    And I modify table
      | platz | zuomge | !row |
      | F2    | 6      | +1   |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ_Entnahme"
    And I delete all rows
    And I modify table
      | platz | zuomge | !row |
      | F1    | 5      | +1   |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme4"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZEBG2_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZEBG2_002"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel    | EINKAUF-2 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag6" with PackingSlip "LS-06"


  @test
  Scenario: 07 Rückgabe auf verschiedene Plätze über verschiedene AS, bisher Entnahmen auf AS1 und AS2
    And I set the fake date to "08.01.1995"
# Bestände auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "S-KORR07"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "S-KORR07"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F3" with document "S-KORR07"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "S-KORR07"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F2" with document "S-KORR07"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F3" with document "S-KORR07"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag7" for Customer "RADSHOP" with Product "M_BAUGRUPPE2" and quantity "10"

    Given I open an editor "rechnung7" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ueb    | ja        |
      | fakt   | ja        |
      | ebeleg | Rechnung7 |
    And I append rows
      | artikel   | mge | platz |
      | EINKAUF-1 | 10  | F1    |
      | EINKAUF-1 | 10  | F2    |
      | EINKAUF-2 | 10  | F1    |
    And I set field "verw" in row 1 to "verw" from editor "auftrag7" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag7" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag7" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | mge | mfreig | bisuch       |
      | M_BAUGRUPPE2 | 10  | ja     | PLAETZEBG2X_ |
    And I set field "verw" in row 1 to "verw" from editor "auftrag7" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "PLAETZEBG2X_001"
    And I close the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "PLAETZEBG2X_002"
    And I close the current editor

# Materialentnahmen EINKAUF-1 auf Arbeitsschein1 von F1 und F2
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | EntnahmeF1             |
      | gmgevorschl | 4                      |
    And I press button "stlvblad"
    Then the table has 1 rows
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZEBG2X_001;bem=EntnahmeF1;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | EntnahmeF2             |
      | gmgevorschl | 4                      |
    And I press button "stlvblad"
    Then the table has 1 rows
    And I set field "buplatz" to "F2" in row 1
    And I save the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZEBG2X_001;bem=EntnahmeF2;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Materialentnahme EINKAUF-2 auf Arbeitsschein2 von F1
    And I wait 2 time units to move the time forward
    Given I open an editor "Materialentnahme3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein2^nummer |
      | bem         | Entnahme3              |
      | gmgevorschl | 6                      |
    And I press button "stlvblad"
    Then the table has 1 rows
    And I save the current editor

    Given I open an editor "Materialentnahme3" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZEBG2X_002;bem=Entnahme3;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Materialrückgabe EINKAUF-1 und EINKAUF-2 über Arbeitsschein2 auf verschiedene Plätze
    And I wait 2 time units to move the time forward
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein2^nummer |
      | gmgevorschl | -5                     |
      | bem         | RückgabeAS2            |
    And I press button "stllad"
    Then the table has 2 rows
    And I press button "mzsubm" to open a subeditor for "MZ_Rückgabe" in row 1
    And I modify table
      | platz | zuomge | !row |
      | F1    | -5     | 1    |
      | F3    | -5     | +2   |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ_Rückgabe"
    And I modify table
      | platz | zuomge | !row |
      | F1    | -2     | 1    |
      | F2    | -3     | +2   |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZEBG2X_002;bem=RückgabeAS2;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Materialrückgabe EINKAUF-1 über Arbeitsschein1 auf verschiedene Plätze
    And I wait 2 time units to move the time forward
    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -1                     |
      | bem         | RückgabeAS1            |
    And I press button "stlvblad"
    Then the table has 1 rows
    And I press button "mzsubm" to open a subeditor for "MZ_Rückgabe" in row 1
    And I modify table
      | platz | zuomge | !row |
      | F2    | -1     | 1    |
      | F3    | -1     | +2   |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe2"
    And I save the current editor

    Given I open an editor "Materialrückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZEBG2X_001;bem=RückgabeAS1;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | artikel  | EINKAUF-1              |
      | richtung | rückwärts              |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1 | F3     | -1   | -1       | 0       | 1    |
      | EINKAUF-1 | F2     | -1   | -1       | 0       | 2    |
      | EINKAUF-1 | F2     | 8    | 8        | 0       | 3    |
      | EINKAUF-1 | F1     | 8    | 4        | 4       | 4    |
    And I set fields
      | beleg    | !Arbeitsschein2^nummer |
      | artikel  | EINKAUF-1              |
      | richtung | rückwärts              |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1 | F3     | -2   | -2       | 0       | 1    |
      | EINKAUF-1 | F3     | -3   | -3       | 0       | 2    |
      | EINKAUF-1 | F1     | -5   | -5       | 0       | 3    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 3
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 10 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 7     |        | (0,0,0)        |
      | F1     |       | 2      | !rechnung7^id  |
      | F1     |       | 5      | !rechnung7^id  |
      | F2     | 3     |        | (0,0,0)        |
      | F2     |       | 2      | !rechnung7^id  |
      | F2     |       | 1      | !rechnung7^id  |
      | F3     | 6     |        | (0,0,0)        |
      | F3     |       | 3      | !rechnung7^id  |
      | F3     |       | 2      | !rechnung7^id  |
      | F3     |       | 1      | !rechnung7^id  |
    And I set fields
      | artikel    | EINKAUF-2 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 5 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 6     |        | (0,0,0)        |
      | F1     |       | 4      | !rechnung7^id  |
      | F1     |       | 2      | !rechnung7^id  |
      | F2     | 3     |        | (0,0,0)        |
      | F2     |       | 3      | !rechnung7^id  |
    And I close the current editor

# Storno der Rückgaben, letzter Beleg wird zuerst gebucht
    Given I open an editor "Materialrückgabe2_Storno" via ID from editor "Materialrückgabe2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open an editor "Materialrückgabe1_Storno" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Storno- und stornierte Belege prüfen
    Given I switch the current editor to editor "Materialrückgabe2" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE2 | 0        | 0       | 0      | 0      |
      | -2  | EINKAUF-1    | -2       | 0       | 14     | 16     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE2 | 0        | 0       | 0      | 0      |
      | -5  | EINKAUF-2    | -5       | 0       | 4      | 9      |
      | -10 | EINKAUF-1    | -10      | 0       | 4      | 14     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe2_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe2^id"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE2 | 0        | 0       | 0      | 0      |
      | 2   | EINKAUF-1    | 0        | 2       | 16     | 14     |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Materialrückgabe1^id"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE2 | 0        | 0       | 0      | 0      |
      | 5   | EINKAUF-2    | 0        | 5       | 9      | 4      |
      | 10  | EINKAUF-1    | 0        | 10      | 14     | 4      |
    And I close the current editor

# FV abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme4" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein2^nummer |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ_Entnahme" in row 1
    And I delete all rows
    And I modify table
      | platz | zuomge | !row |
      | F1    | 2      | +1   |
      | F2    | 2      | +2   |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ_Entnahme"
    And I delete all rows
    And I modify table
      | platz | zuomge | !row |
      | F1    | 4      | +1   |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme4"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZEBG2X_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZEBG2X_002"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel    | EINKAUF-2 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag7" with PackingSlip "LS-07"


  Scenario: 08 Rückgabe und Storno Rückgabe retrogrades Material mit Chargen auf letzten AS, bisher Entnahme über Rückmeldung, EntnahmeMZ Chargen vor Freigabe FV angelegt
    And I set the fake date to "09.01.1995"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-08"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "KORR-08"

	 # Chargen anlegen
    Given I create a Lot "MAT01-01" for Product "EINKAUF-1"
    Given I create a Lot "MAT01-02" for Product "EINKAUF-1"
    Given I create a Lot "MAT02-01" for Product "EINKAUF-2"
    Given I create a Lot "MAT02-02" for Product "EINKAUF-2"

#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag8" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung8" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-08    |
    And I append rows
      | artikel   | mge | charge       |
      | EINKAUF-1 | 10  | !MAT01-01^id |
      | EINKAUF-1 | 10  | !MAT01-02^id |
      | EINKAUF-2 | 5   | !MAT02-01^id |
      | EINKAUF-2 | 5   | !MAT02-02^id |
    And I set field "verw" in row 1 to "verw" from editor "auftrag8" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag8" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag8" in row 1
    And I set field "verw" in row 4 to "verw" from editor "auftrag8" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig |
      | BAUGRUPPE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag8" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge       |
      | +1   | 10     | !MAT01-01^id |
      | +2   | 10     | !MAT01-02^id |
    And I press button "abv" to open a subeditor for "mz2"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | charge       |
      | +1   | 5      | !MAT02-01^id |
      | +2   | 5      | !MAT02-02^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "CHARGERED_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERED_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHARGERED_001;@richtung=rückwärts;@maxtreffer=1"
    And I set fields
      | gmgevorschl | -5        |
      | autorment   | ja        |
      | bem         | Rückgabe8 |
    Then field "maxofmge" has value "ja"
    Then field "maxofmge" is not modifiable
    And I press button "stllad"
    And I set field "manbu" to "ja" in row 1
    And I set field "manbu" to "ja" in row 2
    And I press button "mzsubm" to open a subeditor for "Materialzuord" in row 1
    And I modify table
      | !row | zuomge | charge       |
      | 1    | -6     | !MAT01-01^id |
      | +2   | -4     | !MAT01-02^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "Materialzuord"
    And I modify table
      | !row | zuomge | charge       |
      | 1    | -2     | !MAT02-01^id |
      | +2   | -3     | !MAT02-02^id |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe1"
    Then table has values
      | bumge | elex      | nlimge | limge | chentmge | entmge | rescharge |
      | -10   | EINKAUF-1 | 14     | 4     | 0        | 16     |           |
      | -5    | EINKAUF-2 | 7      | 2     | 0        | 8      |           |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHARGERED_001;bem=Rückgabe8;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 2   | BAUGRUPPE | 0        | 0       | 8      | 8      |
      | -5  | EINKAUF-2 | -5       | 0       | 2      | 7      |
      | -10 | EINKAUF-1 | -10      | 0       | 4      | 14     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE | 0        | 8       | 0      | 8      |
      | 8   | EINKAUF-2 | 5        | 3       | 10     | 2      |
      | 16  | EINKAUF-1 | 10       | 6       | 20     | 4      |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | rueckmge | restmge | vcharge^such | !row |
      | EINKAUF-1 | -4   |      | -4       | 0       | MAT01-02     | 1    |
      | EINKAUF-1 | -6   |      | -6       | 0       | MAT01-01     | 2    |
      | EINKAUF-2 | -3   |      | -3       | 0       | MAT02-02     | 3    |
      | EINKAUF-2 | -2   |      | -2       | 0       | MAT02-01     | 4    |
      | BAUGRUPPE |      | 8    | 0        | 8       |              | 5    |
      | EINKAUF-1 | 6    |      | 4        | 2       | MAT01-02     | 6    |
      | EINKAUF-1 | 10   |      | 6        | 4       | MAT01-01     | 7    |
      | EINKAUF-2 | 3    |      | 3        | 0       | MAT02-02     | 8    |
      | EINKAUF-2 | 5    |      | 2        | 3       | MAT02-01     | 9    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "rueckorig^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 8
    Then field "rueckorig^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 9
    And I close the current editor

# Storno Rückgabe und Beleg prüfen
    Given I open an editor "Rückgabe1_Storno" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    And I switch the current editor to editor "Rückgabe1_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Rückgabe1^id"
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 2   | BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 5   | EINKAUF-2 | 0        | 5       | 7      | 2      |
      | 10  | EINKAUF-1 | 0        | 10      | 14     | 4      |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then field "stornopartnervorg^id" has value "!Rückgabe1_Storno^id"
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 2   | BAUGRUPPE | 0        | 0       | 8      | 8      |
      | -5  | EINKAUF-2 | -5       | 0       | 2      | 7      |
      | -10 | EINKAUF-1 | -10      | 0       | 4      | 14     |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | charge^such |
      | 4     |        |             |
      |       | 4      | MAT01-02    |
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | charge^such |
      | 2     |        |             |
      |       | 2      | MAT02-02    |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERED_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag8" with PackingSlip "LS-RED85"


  Scenario: 09 Rückgabe und Storno Rückgabe mit Chargen auf letzten AS, bisher Entnahme Teilmenge, EntnahmeMZ Chargen vor Freigabe FV angelegt
    And I set the fake date to "10.01.1995"
# Bestandkorrektur auf 0
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-09"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "KORR-09"

	# Chargen anlegen
    Given I create a Lot "MAT01-03" for Product "EINKAUF-1"
    Given I create a Lot "MAT01-04" for Product "EINKAUF-1"
    Given I create a Lot "MAT02-03" for Product "EINKAUF-2"
    Given I create a Lot "MAT02-04" for Product "EINKAUF-2"

#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag9" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung9" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-09    |
    And I append rows
      | artikel   | mge | charge       |
      | EINKAUF-1 | 10  | !MAT01-03^id |
      | EINKAUF-1 | 10  | !MAT01-04^id |
      | EINKAUF-2 | 5   | !MAT02-03^id |
      | EINKAUF-2 | 5   | !MAT02-04^id |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig |
      | M_BAUGRUPPE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag9" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge       |
      | +1   | 10     | !MAT01-03^id |
      | +2   | 10     | !MAT01-04^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | charge       |
      | +1   | 5      | !MAT02-03^id |
      | +2   | 5      | !MAT02-04^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "CHARGEMANMZ_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über gesamte Menge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHARGEMANMZ_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme"
    And I press button "stllad"
    And I save the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHARGEMANMZ_001;@richtung=rückwärts;@maxtreffer=1"
    And I set fields
      | gmgevorschl | -8       |
      | bem         | Rückgabe |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | charge       |
      | 1    | -10    | !MAT01-03^id |
      | +2   | -6     | !MAT01-04^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ"
    And I modify table
      | !row | zuomge | charge       |
      | 1    | -3     | !MAT02-03^id |
      | +2   | -5     | !MAT02-04^id |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe1"
    Then table has values
      | bumge | elex      | nlimge | limge | chentmge | entmge | rescharge^such |
      | -16   | EINKAUF-1 | 16     | 0     | 0        | 20     |                |
      | -8    | EINKAUF-2 | 8      | 0     | 0        | 10     |                |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe und Bestand prüfen
    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHARGEMANMZ_001;bem=Rückgabe;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -8  | EINKAUF-2   | -8       | 0       | 0      | 8      |
      | -16 | EINKAUF-1   | -16      | 0       | 0      | 16     |
    And I close the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHARGEMANMZ_001;bem=Entnahme;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2   | 8        | 2       | 10     | 0      |
      | 20  | EINKAUF-1   | 16       | 4       | 20     | 0      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^such |
      | 16    |        |             |
      |       | 10     | MAT01-03    |
      |       | 6      | MAT01-04    |
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^such |
      | 8     |        |             |
      |       | 3      | MAT02-03    |
      |       | 5      | MAT02-04    |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Materialentnahme1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge | vcharge^such | !row | detursache                 |
      | EINKAUF-1 | -6   | -6       | 0       | MAT01-04     | 1    | Materialrückgabe Fertigung |
      | EINKAUF-1 | -10  | -10      | 0       | MAT01-03     | 2    | Materialrückgabe Fertigung |
      | EINKAUF-2 | -5   | -5       | 0       | MAT02-04     | 3    | Materialrückgabe Fertigung |
      | EINKAUF-2 | -3   | -3       | 0       | MAT02-03     | 4    | Materialrückgabe Fertigung |
      | EINKAUF-1 | 10   | 6        | 4       | MAT01-04     | 5    | Materialentnahme Fertigung |
      | EINKAUF-1 | 10   | 10       | 0       | MAT01-03     | 6    | Materialentnahme Fertigung |
      | EINKAUF-2 | 5    | 5        | 0       | MAT02-04     | 7    | Materialentnahme Fertigung |
      | EINKAUF-2 | 5    | 3        | 2       | MAT02-03     | 8    | Materialentnahme Fertigung |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "rueckorig^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "rueckorig^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 8
    And I close the current editor

# Storno Rückgabe, Stornobeleg prüfen, Bestand prüfen
    Given I open an editor "Rückgabe1_Storno" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    And I switch the current editor to editor "Rückgabe1_Storno" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 8   | EINKAUF-2   | 0        | 8       | 8      | 0      |
      | 16  | EINKAUF-1   | 0        | 16      | 16     | 0      |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGEMANMZ_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag9" with PackingSlip "LS-MAN09"


  Scenario: 10 Rückgabe und Storno Rückgabe mit Chargen auf letzten AS, bisher Entnahme Teilmenge
    And I set the fake date to "11.01.1995"
# Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-10"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "KORR-10"

# Chargen anlegen
    Given I create a Lot "MAT01-10-03" for Product "EINKAUF-1"
    Given I create a Lot "MAT01-10-04" for Product "EINKAUF-1"
    Given I create a Lot "MAT02-10-03" for Product "EINKAUF-2"
    Given I create a Lot "MAT02-10-04" for Product "EINKAUF-2"

#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag10" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-05    |
    And I append rows
      | artikel   | mge | charge          |
      | EINKAUF-1 | 10  | !MAT01-10-03^id |
      | EINKAUF-1 | 10  | !MAT01-10-04^id |
      | EINKAUF-2 | 5   | !MAT02-10-03^id |
      | EINKAUF-2 | 5   | !MAT02-10-04^id |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch      |
      | M_BAUGRUPPE | 10     | ja     | CHARGEMANX_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag10" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme1 und Materialentnahme2 über gesamte Menge mit Chargen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=CHARGEMANX_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | 5                                                        |
      | bem         | Entnahme1                                                |
    And I press button "stllad"
	And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
    And I set field "charge" to "!MAT01-10-03^id" in row 1
	And I press button for next product
    And I set field "charge" to "!MAT02-10-03^id" in row 1
	And I save the current editor
	And I switch the current editor to editor "Materialentnahme1"
    And I save the current editor

    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=CHARGEMANX_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | 5                                                        |
      | bem         | Entnahme2                                                |
    And I press button "stllad"
	And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
    And I set field "charge" to "!MAT01-10-04^id" in row 1
	And I press button for next product
    And I set field "charge" to "!MAT02-10-04^id" in row 1
	And I save the current editor
	And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

# Rückgabe1 mt Charge MAT01 und MAT02
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHARGEMANX_001;@richtung=rückwärts;@maxtreffer=1"
    And I set fields
      | gmgevorschl | -1        |
      | bem         | Rückgabe1 |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | charge          |
      | 1    | -1     | !MAT01-10-03^id |
      | +2   | -1     | !MAT01-10-04^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ"
    And I modify table
      | !row | zuomge | charge          |
      | 1    | -1     | !MAT02-10-03^id |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe1"
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHARGEMANX_001;bem=Rückgabe1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -1  | EINKAUF-2   | -1       | 0       | 0      | 1      |
      | -2  | EINKAUF-1   | -2       | 0       | 0      | 2      |
    And I close the current editor

    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHARGEMANX_001;bem=Entnahme2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 5   | EINKAUF-2   | 0        | 5       | 5      | 0      |
      | 10  | EINKAUF-1   | 1        | 9       | 10     | 0      |
    And I close the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHARGEMANX_001;bem=Entnahme1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 5   | EINKAUF-2   | 1        | 4       | 10     | 5      |
      | 10  | EINKAUF-1   | 1        | 9       | 20     | 10     |
    And I close the current editor

# Lagerjournaleintrag und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Materialentnahme1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge | vcharge^such    | !row | detursache                 |
      | EINKAUF-1 | -1   | -1       | 0       | MAT01-10-04     | 1    | Materialrückgabe Fertigung |
      | EINKAUF-1 | -1   | -1       | 0       | MAT01-10-03     | 2    | Materialrückgabe Fertigung |
      | EINKAUF-2 | -1   | -1       | 0       | MAT02-10-03     | 3    | Materialrückgabe Fertigung |
      | EINKAUF-1 | 10   | 1        | 9       | MAT01-10-04     | 4    | Materialentnahme Fertigung |
      | EINKAUF-2 | 5    | 0        | 5       | MAT02-10-04     | 5    | Materialentnahme Fertigung |
      | EINKAUF-1 | 10   | 1        | 9       | MAT01-10-03     | 6    | Materialentnahme Fertigung |
      | EINKAUF-2 | 5    | 1        | 4       | MAT02-10-03     | 7    | Materialentnahme Fertigung |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^such    |
      | 2     |        |                |
      |       | 1      | MAT01-10-03    |
      |       | 1      | MAT01-10-04    |
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | charge^such    |
      | 1     |        |                |
      |       | 1      | MAT02-10-03    |
    And I close the current editor

# Storno Rückgabe, Beleg und Bestand prüfen
    Given I open an editor "Rückgabe1_Storno" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    And I switch the current editor to editor "Rückgabe1_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückgabe1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 1   | EINKAUF-2   | 0        | 1       | 1      | 0      |
      | 2   | EINKAUF-1   | 0        | 2       | 2      | 0      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGEMANX_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    And I deliver the SalesOrder "auftrag10" with PackingSlip "LS-MAN10"


  Scenario: 11 Rückgabe von einer Charge auf letzten AS und durch andere Charge ersetzen, bisher Entnahme Gesamtmenge, EntnahmeMZ eine Charge vor Freigabe FV angelegt
    And I set the fake date to "12.01.1995"
# Chargen anlegen
    Given I create a Lot "GOOD1_CH" for Product "EINKAUF-1"
    Given I create a Lot "GOOD2_CH" for Product "EINKAUF-1"
    Given I create a Lot "BAD1_CH" for Product "EINKAUF-1"
    Given I create a Lot "BAD2_CH" for Product "EINKAUF-1"

#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag11" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung11" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-11    |
    And I append rows
      | artikel   | mge | charge       |
      | EINKAUF-1 | 10  | !GOOD1_CH^id |
      | EINKAUF-1 | 10  | !GOOD2_CH^id |
      | EINKAUF-1 | 10  | !BAD1_CH^id  |
      | EINKAUF-1 | 10  | !BAD2_CH^id  |
      | EINKAUF-2 | 10  |              |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig |
      | M_BAUGRUPPE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag11" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge      |
      | +1   | 10     | !BAD1_CH^id |
      | +2   | 10     | !BAD2_CH^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "AUSTAUSCH_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über gesamte Gutmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=AUSTAUSCH_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme1"
    And I press button "stllad"
    And I save the current editor

# Über Materialentnahme das entnommenen Materials zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | $,,such=AUSTAUSCH_001;@richtung=rückwärts;@maxtreffer=1 |
      | bem     | Rückgabe                                                |
    And I press button "stllad"
    And I set field "bumge" to "-20" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | charge      |
      | 1    | -10    | !BAD1_CH^id |
      | +2   | -10    | !BAD2_CH^id |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe1"
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCH_001;bem=Rückgabe;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -20 | EINKAUF-1   | -20      | 0       | 0      | 20     |
    And I close the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCH_001;bem=Entnahme1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2   | 0        | 10      | 10     | 0      |
      | 20  | EINKAUF-1   | 20       | 0       | 20     | 0      |
    And I close the current editor

# Zweite Charge entnehmen
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=AUSTAUSCH_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme2"
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | charge       |
      | 1    | 10     | !GOOD1_CH^id |
      | +2   | 10     | !GOOD2_CH^id |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

# Belege zu Materialentnahmmen prüfen
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCH_001;bem=Entnahme1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2   | 0        | 10      | 10     | 0      |
      | 20  | EINKAUF-1   | 20       | 0       | 20     | 0      |
    And I close the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCH_001;bem=Entnahme2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 20  | EINKAUF-1   | 0        | 20      | 20     | 0      |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Materialentnahme1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge | vcharge^such | !row |
      | EINKAUF-1 | 10   | 0        | 10      | GOOD2_CH     | 1    |
      | EINKAUF-1 | 10   | 0        | 10      | GOOD1_CH     | 2    |
      | EINKAUF-1 | -10  | -10      | 0       | BAD2_CH      | 3    |
      | EINKAUF-1 | -10  | -10      | 0       | BAD1_CH      | 4    |
      | EINKAUF-1 | 10   | 10       | 0       | BAD2_CH      | 5    |
      | EINKAUF-1 | 10   | 10       | 0       | BAD1_CH      | 6    |
      | EINKAUF-2 | 10   | 0        | 10      |              | 7    |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUSTAUSCH_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag11" with PackingSlip "LS-MAN11"


  Scenario: 12 Rückgabe von einer Charge auf letzten AS und durch andere Charge ersetzen, bisher Entnahme Gesamtmenge
    And I set the fake date to "13.01.1995"
# Chargen anlegen
    Given I create a Lot "GOOD_CH" for Product "EINKAUF-1"
    Given I create a Lot "BAD1_CH" for Product "EINKAUF-1"
    Given I create a Lot "BAD2_CH" for Product "EINKAUF-1"

#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag12" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung12" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-12    |
    And I append rows
      | artikel   | mge | charge      |
      | EINKAUF-1 | 20  | !GOOD_CH^id |
      | EINKAUF-1 | 10  | !BAD1_CH^id |
      | EINKAUF-1 | 10  | !BAD2_CH^id |
      | EINKAUF-2 | 10  |             |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch      |
      | M_BAUGRUPPE | 10     | ja     | AUSTAUSCHX_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag12" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über gesamte Gutmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=AUSTAUSCHX_001;@richtung=rückwärts;@maxtreffer=1 |
      | bem         | Entnahme1                                                |
      | gmgevorschl | 5                                                        |
    And I press button "stllad"
	And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
    And I set field "charge" to "!BAD1_CH^id" in row 1
	And I save the current editor
	And I switch the current editor to editor "Materialentnahme1"
    And I save the current editor

    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=AUSTAUSCHX_001;@richtung=rückwärts;@maxtreffer=1 |
      | bem         | Entnahme2                                                |
      | gmgevorschl | 5                                                        |
    And I press button "stllad"
	And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
    And I set field "charge" to "!BAD2_CH^id" in row 1
	And I save the current editor
	And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

# Über Materialentnahme das entnommenen Material zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | $,,such=AUSTAUSCHX_001;@richtung=rückwärts;@maxtreffer=1 |
      | bem     | Rückgabe1                                                |
    And I press button "stllad"
    And I set field "bumge" to "-20" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | charge      |
      | 1    | -10    | !BAD1_CH^id |
      | +2   | -10    | !BAD2_CH^id |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe1"
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCHX_001;bem=Rückgabe;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -20 | EINKAUF-1   | -20      | 0       | 0      | 20     |
    And I close the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCHX_001;bem=Entnahme2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 5   | EINKAUF-2   | 0        | 5       | 5      | 0      |
      | 10  | EINKAUF-1   | 10       | 0       | 10     | 0      |
    And I close the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCHX_001;bem=Entnahme1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 5   | EINKAUF-2   | 0        | 5       | 10     | 5      |
      | 10  | EINKAUF-1   | 10       | 0       | 20     | 10     |
    And I close the current editor

# Zweite Charge entnehmen, Beleg prüfen
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | $,,such=AUSTAUSCHX_001;@richtung=rückwärts;@maxtreffer=1 |
      | bem     | Entnahme3                                                |
    And I press button "stllad"
	And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
    And I set field "charge" to "!GOOD_CH^id" in row 1
	And I save the current editor
	And I switch the current editor to editor "Materialentnahme3"
    And I save the current editor

    Given I open an editor "Materialentnahme3" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCHX_001;bem=Entnahme3;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 20  | EINKAUF-1   | 0        | 20      | 20     | 0      |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Materialentnahme1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge | vcharge^such | !row |
      | EINKAUF-1 | 20   | 0        | 20      | GOOD_CH      | 1    |
      | EINKAUF-1 | -10  | -10      | 0       | BAD2_CH      | 2    |
      | EINKAUF-1 | -10  | -10      | 0       | BAD1_CH      | 3    |
      | EINKAUF-1 | 10   | 10       | 0       | BAD2_CH      | 4    |
      | EINKAUF-2 | 5    | 0        | 5       |              | 5    |
      | EINKAUF-1 | 10   | 10       | 0       | BAD1_CH      | 6    |
      | EINKAUF-2 | 5    | 0        | 5       |              | 7    |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUSTAUSCHX_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag12" with PackingSlip "LS-MAN12"


  Scenario: 13 Rückgabe und Storno Rückgabe in in gefüllte oder leere Behälter auf letzten AS, bisher Entnahme Teilmenge, EntnahmeMZ Behälter vor Freigabe FV angelegt
    And I set the fake date to "14.01.1995"
# Behälter anlegen
    Given I create a Container "B_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL2" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL3" for packaging material "BEHAELTER"
    Given I create a Container "B_LEER" for packaging material "BEHAELTER"

# Auftrag anlagen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag13" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "Rechnung13" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-13    |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 10  |
      | EINKAUF-1  | 10  |
      | EINKAUF-2  | 5   |
      | EINKAUF-2  | 5   |
      | BEHAELTER  | 4   |
      | EU-PALETTE | 1   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag13" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag13" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag13" in row 1
    And I set field "verw" in row 4 to "verw" from editor "auftrag13" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL1^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL2^nummer" in row 2
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL3^nummer" in row 3
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig |
      | M_BAUGRUPPE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag13" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | behaelter       |
      | +1   | 10     | !B_MATERIAL1^id |
      | +2   | 10     | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "mz2"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | behaelter       |
      | +1   | 5      | !B_MATERIAL3^id |
      | +2   | 5      |                 |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEHAELTER_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BEHAELTER_001"
    And I close the current editor

# Materialentnahme Teilmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 5                      |
      | bem         | Entnahme1              |
    And I press button "stllad"
    And I save the current editor

# Behälter prüfen
    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL3" is empty

# Teil-Rückgabe in gefüllten und leeren Behälter (über Zeile)
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
      | bem         | Rückgabe               |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | behaelter       |
      | 1    | -1     | !B_MATERIAL1^id |
      | +2   | -1     | !B_MATERIAL2^id |
      | +3   | -2     | !B_LEER^id      |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe1"
    And I set field "behaelter" to "!B_LEER^id" in row 2
    And I save the current editor

# Behälter prüfen
    Then Container from editor "B_MATERIAL3" is empty

    And I switch the current editor to editor "B_MATERIAL1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 1   |
    And I close the current editor
    And I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 11  |
    And I close the current editor
    And I switch the current editor to editor "B_LEER" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 2   |
      | EINKAUF-2 | 2   |
    And I close the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Arbeitsschein1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | rueckmge | restmge | behaelter^such | !row |
      | EINKAUF-1 | -2   |      | -2       | 0       | B_LEER         | 1    |
      | EINKAUF-1 | -1   |      | -1       | 0       | B_MATERIAL2    | 2    |
      | EINKAUF-1 | -1   |      | -1       | 0       | B_MATERIAL1    | 3    |
      | EINKAUF-2 | -2   |      | -2       | 0       | B_LEER         | 4    |
      | EINKAUF-1 | 10   |      | 4        | 6       | B_MATERIAL1    | 5    |
      | EINKAUF-2 | 5    |      | 2        | 3       | B_MATERIAL3    | 6    |
    And I close the current editor

# Materialentnahme und Rückmeldung auf ersten AG
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme2              |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | behaelter       |
      | 1    | 1      | !B_MATERIAL1^id |
      | +2   | 11     | !B_MATERIAL2^id |
      | +3   | 2      | !B_LEER^id      |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ"
    And I modify table
      | !row | zuomge | behaelter  |
      | 1    | 2      | !B_LEER^id |
      | +2   | 5      |            |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHAELTER_001"
    And I set fields
      | gut     | ja |
      | sofort  | ja |
      | manrest | ja |
    And I save the current editor

# Behälter prüfen
    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty
    Then Container from editor "B_MATERIAL3" is empty
    Then Container from editor "B_LEER" is empty

# Lieferschein zu Auftrag
    And I deliver the SalesOrder "auftrag13" with PackingSlip "LS-13"


  Scenario: 14 Rückgabe und Storno Rückgabe in in gefüllte oder leere Behälter auf letzten AS, bisher Entnahmen mit Behälterangaben
    And I set the fake date to "15.01.1995"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-X14"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "KORR-X14"

# Behälter anlegen
    Given I create a Container "B_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL2" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL3" for packaging material "BEHAELTER"
    Given I create a Container "B_LEER" for packaging material "BEHAELTER"

# Auftrag anlagen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag14" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "Rechnung14" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-14    |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 10  |
      | EINKAUF-1  | 10  |
      | EINKAUF-2  | 5   |
      | EINKAUF-2  | 5   |
      | BEHAELTER  | 4   |
      | EU-PALETTE | 1   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag14" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag14" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag14" in row 1
    And I set field "verw" in row 4 to "verw" from editor "auftrag14" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL1^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL2^nummer" in row 2
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL3^nummer" in row 3
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch      |
      | M_BAUGRUPPE | 10     | ja     | BEHAELTERX_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag14" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BEHAELTERX_001"
    And I close the current editor

# Materialentnahme Teilmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 5                      |
      | bem         | Entnahme1              |
    And I press button "stllad"
    And I modify table
      | !row | behaelter       |
      | 1    | !B_MATERIAL1^id |
      | 2    | !B_MATERIAL3^id |
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEHAELTERX_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 2                      |
      | bem         | Entnahme2              |
    And I press button "stllad"
    And I modify table
      | !row | behaelter       |
      | 1    | !B_MATERIAL2^id |
      | 2    |                 |
    And I save the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEHAELTERX_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Behälter prüfen
    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL3" is empty

# Teil-Rückgabe in gefüllten und leeren Behälter (über MZ), betrifft beide Entnahmen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -4                     |
      | bem         | Rückgabe               |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | behaelter       |
      | 1    | -4     | !B_MATERIAL2^id |
      | +2   | -4     | !B_LEER^id      |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ"
    And I modify table
      | !row | zuomge | behaelter       |
      | 1    | -2     | !B_MATERIAL2^id |
      | +2   | -2     | !B_LEER^id      |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe1"
    And I save the current editor

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEHAELTERX_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Behälter prüfen
    Then Container from editor "B_MATERIAL1" is empty

    And I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 10  |
      | EINKAUF-2 | 2   |
    And I close the current editor
    And I switch the current editor to editor "B_LEER" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 4   |
      | EINKAUF-2 | 2   |
    And I close the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Arbeitsschein1^nummer"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | rueckmge | restmge | behaelter^such | !row |
      | EINKAUF-1 | -4   |      | -4       | 0       | B_LEER         | 1    |
      | EINKAUF-1 | -4   |      | -4       | 0       | B_MATERIAL2    | 2    |
      | EINKAUF-2 | -2   |      | -2       | 0       | B_LEER         | 3    |
      | EINKAUF-2 | -2   |      | -2       | 0       | B_MATERIAL2    | 4    |
      | EINKAUF-1 | 4    |      | 4        | 0       | B_MATERIAL2    | 5    |
      | EINKAUF-2 | 2    |      | 2        | 0       |                | 6    |
      | EINKAUF-1 | 10   |      | 4        | 6       | B_MATERIAL1    | 7    |
      | EINKAUF-2 | 5    |      | 2        | 3       | B_MATERIAL3    | 8    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | behaelter  | ja        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | tbehaelter^such |
      | 10     | B_MATERIAL2     |
      | 4      | B_LEER          |
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    Then the table has 3 rows
    Then table has values
      | gebmge | tbehaelter^such |
      | 3      |                 |
      | 2      | B_MATERIAL2     |
      | 2      | B_LEER          |
    And I close the current editor

# Storno Rückgabe, Beleg und Behälter prüfen
    Given I open an editor "Rückgabe1_Storno" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    And I switch the current editor to editor "Rückgabe1_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückgabe1"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 4   | EINKAUF-2   | 0        | 4       | 7      | 3      |
      | 8   | EINKAUF-1   | 0        | 8       | 14     | 6      |
    And I close the current editor

    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL3" is empty
    Then Container from editor "B_LEER" is empty

    And I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then field "behleer" has value "nein"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 6   |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | behaelter  | ja        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | tbehaelter^such |
      | 6      | B_MATERIAL2     |
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | tbehaelter^such |
      | 3      |                 |
    And I close the current editor

# FV abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme3              |
    And I press button "stllad"
    And I set field "behaelter" to "!B_MATERIAL2^id" in row 1
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHAELTERX_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

# Bestand und Behälter prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | behaelter  | ja        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty
    Then Container from editor "B_MATERIAL3" is empty
    Then Container from editor "B_LEER" is empty

# Lieferschein zu Auftrag
    And I deliver the SalesOrder "auftrag14" with PackingSlip "LS-14"


  Scenario: 15 Rückgabe in leere Behälter auf verschiedene Plätze auf letzten AS, bisher Entnahme Gesamtmenge, EntnahmeMZ Behälter und Plätze vor Freigabe FV angelegt
    And I set the fake date to "16.01.1995"
# Bestand korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "S-KORRXX15"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "S-KORRXX15"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F3" with document "S-KORRXX15"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "S-KORRXX15"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F2" with document "S-KORRXX15"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F3" with document "S-KORRXX15"

# Behälter erstellen
    Given I create a Container "MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "MATERIAL2" for packaging material "BEHAELTER"
    Given I create a Container "MATERIAL3" for packaging material "BEHAELTER"

# Auftrag anlegen und Bedarfe in Behälter einkaufen
    Given I create a SalesOrder "auftrag15" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "Rechnung15" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ueb    | ja         |
      | fakt   | ja         |
      | ebeleg | Rechnung15 |
    And I append rows
      | artikel   | mge | platz |
      | EINKAUF-1 | 10  | F1    |
      | EINKAUF-1 | 10  | F2    |
      | EINKAUF-2 | 10  | F1    |
    And I set field "verw" in row 1 to "verw" from editor "auftrag15" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag15" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag15" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!MATERIAL1^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!MATERIAL2^nummer" in row 2
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!MATERIAL3^nummer" in row 3
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag mit Materialzuordnung anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig |
      | M_BAUGRUPPE | 10  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag15" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | !row | zuomge | behaelter     | lpsuch |
      | +1   | 10     | !MATERIAL1^id | F1     |
      | +2   | 10     | !MATERIAL2^id | F2     |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | behaelter     | lpsuch |
      | +1   | 10     | !MATERIAL3^id | F1     |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEHAELTERMZ_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BEHAELTERMZ_001"
    And I close the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 6                      |
    And I press button "stlvblad"
    And I save the current editor

# Materialrückgabe in leere und gefüllte Behälter
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | XRUECK1                |
      | gmgevorschl | -2                     |
    And I press button "stlvblad"
    Then the table has 2 rows
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge | platz | behaelter     |
      | 1    | -2     | F3    | !MATERIAL1^id |
      | +2   | -2     | F1    | !MATERIAL3^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "Materialzuordnung_Rückgabe"
    And I modify table
      | !row | zuomge | platz | behaelter     |
      | 1    | -2     | F3    | !MATERIAL1^id |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEHAELTERMZ_001;bem=XRUECK1;manrm=ja;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

# Behälter, Bestand und LJ prüfen
    And I switch the current editor to editor "MATERIAL1"
    Then field "platz" has value "F3"
    Then the table has 2 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 2   |
      | EINKAUF-2 | 2   |
    And I close the current editor

    And I switch the current editor to editor "MATERIAL2"
    Then field "platz" has value "F2"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 8   |
    And I close the current editor

    And I switch the current editor to editor "MATERIAL3"
    Then field "platz" has value "F1"
    Then the table has 2 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 2   |
      | EINKAUF-2 | 4   |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    |           |
      | behaelter  | ja        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 3 rows
    Then table has values
      | lplatz | gebmge | tbehaelter^such |
      | F1     | 2      | MATERIAL3       |
      | F2     | 8      | MATERIAL2       |
      | F3     | 2      | MATERIAL1       |
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    Then the table has 2 rows
    Then table has values
      | lplatz | gebmge | tbehaelter^such |
      | F1     | 4      | MATERIAL3       |
      | F3     | 2      | MATERIAL1       |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then table has values
      | art       | amge | vplatz | rueckmge | restmge | behaelter^such | !row |
      | EINKAUF-1 | -2   | F1     | -2       | 0       | MATERIAL3      | 1    |
      | EINKAUF-1 | -2   | F3     | -2       | 0       | MATERIAL1      | 2    |
      | EINKAUF-2 | -2   | F3     | -2       | 0       | MATERIAL1      | 3    |
      | EINKAUF-1 | 2    | F2     | 2        | 0       | MATERIAL2      | 4    |
      | EINKAUF-1 | 10   | F1     | 2        | 8       | MATERIAL1      | 5    |
      | EINKAUF-2 | 6    | F1     | 2        | 4       | MATERIAL3      | 6    |
    And I close the current editor

# Storno Rückgabe, Behälter und Bestand prüfen
    Given I open an editor "Materialrückgabe1_Storno" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Then Container from editor "MATERIAL1" is empty

    And I switch the current editor to editor "MATERIAL2" with command "VIEW"
    Then field "platz" has value "F2"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 8   |
    And I close the current editor

    And I switch the current editor to editor "MATERIAL3" with command "VIEW"
    Then field "platz" has value "F1"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-2 | 4   |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    |           |
      | behaelter  | ja        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then table has values
      | lplatz | gebmge | tbehaelter^such |
      | F2     | 8      | MATERIAL2       |
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    Then the table has 1 rows
    Then table has values
      | lplatz | gebmge | tbehaelter^such |
      | F1     | 4      | MATERIAL3       |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stlvblad"
    And I modify table
      | !row | buplatz | behaelter  |
      | 1    | F2      | !MATERIAL2 |
      | 2    | F1      | !MATERIAL3 |
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHAELTERMZ_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    Then Container from editor "MATERIAL1" is empty
    Then Container from editor "MATERIAL2" is empty
    Then Container from editor "MATERIAL3" is empty

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    |           |
      | behaelter  | ja        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag15" with PackingSlip "LS-TMZ15"


  Scenario: 16 Rückgabe in leere Behälter auf verschiedene Plätze auf letzten AS, bisher Entnahme Gesamtmenge
    And I set the fake date to "17.01.1995"
# Bestand korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "S-KORRXX16"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "S-KORRXX16"

# Behälter erstellen
    Given I create a Container "MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "MATERIAL2" for packaging material "BEHAELTER"

# Auftrag anlegen und Bedarfe in Behälter einkaufen
    Given I create a SalesOrder "auftrag16" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "Rechnung16" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ueb    | ja        |
      | fakt   | ja        |
      | ebeleg | Rechnung1 |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
      | EINKAUF-3 | 1   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag16" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag16" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!MATERIAL1^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!MATERIAL2^nummer" in row 2
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!MATERIAL2^nummer" in row 3
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag mit Materialzuordnung anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch     |
      | M_BAUGRUPPE | 10  | ja     | BEHAELTER_ |
    And I set field "verw" in row 1 to "verw" from editor "auftrag16" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BEHAELTER_001"
    And I close the current editor

# Materialentnahme und leeren Behälter prüfen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stlvblad"
    And I set field "behaelter" to "!MATERIAL1^id" in row 1
    And I set field "behaelter" to "!MATERIAL2^id" in row 2
    And I save the current editor

    Then Container from editor "MATERIAL1" is empty

# Materialrückgabe in leere und gefüllte Behälter
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
    And I press button "stlvblad"
    Then the table has 2 rows
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge | platz | behaelter     |
      | 1    | -2     | F2    | !MATERIAL1^id |
      | +2   | -2     | F1    | !MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "Materialzuordnung_Rückgabe"
    And I modify table
      | !row | zuomge | platz | behaelter     |
      | 1    | -2     | F2    | !MATERIAL1^id |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

# Behälter prüfen
    Given I switch the current editor to editor "MATERIAL1" with command "VIEW"
    Then field "platz" has value "F2"
    Then the table has 2 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 2   |
      | EINKAUF-2 | 2   |
    And I close the current editor

    Given I switch the current editor to editor "MATERIAL2" with command "VIEW"
    Then field "platz" has value "F1"
    Then the table has 2 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 2   |
      | EINKAUF-3 | 1   |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stlvblad"
    Then the table has 2 rows
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | platz | behaelter     |
      | 1    | 2      | F2    | !MATERIAL1^id |
      | +2   | 2      | F1    | !MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "Materialzuordnung"
    And I modify table
      | !row | zuomge | platz | behaelter     |
      | 1    | 2      | F2    | !MATERIAL1^id |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHAELTER_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    And I deliver the SalesOrder "auftrag16" with PackingSlip "LS-T16"


  Scenario: 17 Rückgabe mit Einheiten und Behältern auf letzten AS, bisher Entnahme Gesamtmenge, EntnahmeMZ Einheiten und Behälter vor Freigabe FV angelegt
    And I set the fake date to "18.01.1995"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "S-KORR17"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "S-KORR17"

# Behälter anlegen
    Given I create a Container "B_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL2" for packaging material "BEHAELTER"

# Auftrag anlagen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag17" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "10"

    Given I open an editor "Rechnung17" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-17    |
    And I append rows
      | artikel    | mge | he   |
      | GEBINDEPFL | 2   | Paar |
      | GEBINDEPFL | 3   | Paar |
      | GEBINDE    | 50  | kg   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag17" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag17" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag17" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL1^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL2^nummer" in row 2
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL2^nummer" in row 3
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BG-GEBINDE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag17" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | behaelter       |
      | +1   | 10     | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | +1   | 2      | Paar | !B_MATERIAL1^id |
      | +2   | 3      | Paar | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEINHEIT_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BEINHEIT_001;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Materialentnahme gesamtes Material
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme1              |
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEINHEIT_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Teil-Rückgabe in leeren Behälter über MZ in Handelseinheit kg und Paar
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
      | bem         | Rückgabe               |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | 1    | -5     | kg   | !B_MATERIAL1^id |
      | +2   | -5     | kg   | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ"
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | 1    | -0.5   | Paar | !B_MATERIAL1^id |
      | +2   | -0.5   | Paar | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe1"
    And I save the current editor

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEINHEIT_001;manrm=ja;bem=Rückgabe;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Behälter, LJ und Bestand prüfen
    And I switch the current editor to editor "B_MATERIAL1" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 1   | Stück   |
      | GEBINDEPFL | 0.5 | Paar    |
    And I close the current editor

    And I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 1   | Stück   |
      | GEBINDEPFL | 0.5 | Paar    |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Arbeitsschein1^nummer"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | mei   | rueckmge | restmge | behaelter^such | !row |
      | GEBINDE    | -5   | kg    | -1       | 0       | B_MATERIAL2    | 1    |
      | GEBINDE    | -5   | kg    | -1       | 0       | B_MATERIAL1    | 2    |
      | GEBINDEPFL | -0.5 | Paar  | -1       | 0       | B_MATERIAL2    | 3    |
      | GEBINDEPFL | -0.5 | Paar  | -1       | 0       | B_MATERIAL1    | 4    |
      | GEBINDE    | 10   | Stück | 2        | 8       | B_MATERIAL2    | 5    |
      | GEBINDEPFL | 3    | Paar  | 2        | 4       | B_MATERIAL2    | 6    |
      | GEBINDEPFL | 2    | Paar  | 0        | 4       | B_MATERIAL1    | 7    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | behaelter  | ja      |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 1      | Stück    | B_MATERIAL1     |
      | 1      | Stück    | B_MATERIAL2     |
    And I set fields
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 0.5    | Paar     | B_MATERIAL1     |
      | 0.5    | Paar     | B_MATERIAL2     |
    And I close the current editor

# Teil-Rückgabe in leeren Behälter über MZ in Lagereineit Stück
    And I wait 1 time units to move the time forward
    Given I open an editor "Rückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
      | bem         | Rückgabe2              |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | einh  | behaelter       |
      | 1    | -1     | Stück | !B_MATERIAL1^id |
      | +2   | -1     | Stück | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ"
    And I modify table
      | !row | zuomge | einh  | behaelter       |
      | 1    | -1     | Stück | !B_MATERIAL1^id |
      | +2   | -1     | Stück | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe2"
    And I save the current editor

    Given I open an editor "Rückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEINHEIT_001;manrm=ja;bem=Rückgabe2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Behälter, LJ und Bestand prüfen
    And I switch the current editor to editor "B_MATERIAL1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 2   | Stück   |
      | GEBINDEPFL | 1   | Stück   |
      | GEBINDEPFL | 0.5 | Paar    |
    And I close the current editor

    And I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 2   | Stück   |
      | GEBINDEPFL | 1   | Stück   |
      | GEBINDEPFL | 0.5 | Paar    |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Arbeitsschein1^nummer"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | mei   | rueckmge | restmge | behaelter^such | !row |
      | GEBINDE    | -1   | Stück | -1       | 0       | B_MATERIAL2    | 1    |
      | GEBINDE    | -1   | Stück | -1       | 0       | B_MATERIAL1    | 2    |
      | GEBINDEPFL | -1   | Stück | -1       | 0       | B_MATERIAL2    | 3    |
      | GEBINDEPFL | -1   | Stück | -1       | 0       | B_MATERIAL1    | 4    |
      | GEBINDE    | -5   | kg    | -1       | 0       | B_MATERIAL2    | 5    |
      | GEBINDE    | -5   | kg    | -1       | 0       | B_MATERIAL1    | 6    |
      | GEBINDEPFL | -0.5 | Paar  | -1       | 0       | B_MATERIAL2    | 7    |
      | GEBINDEPFL | -0.5 | Paar  | -1       | 0       | B_MATERIAL1    | 8    |
      | GEBINDE    | 10   | Stück | 4        | 6       | B_MATERIAL2    | 9    |
      | GEBINDEPFL | 3    | Paar  | 4        | 2       | B_MATERIAL2    | 10   |
      | GEBINDEPFL | 2    | Paar  | 0        | 4       | B_MATERIAL1    | 11   |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | behaelter  | ja      |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 2      | Stück    | B_MATERIAL1     |
      | 2      | Stück    | B_MATERIAL2     |
    And I set fields
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    Then the table has 4 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 1      | Stück    | B_MATERIAL1     |
      | 1      | Stück    | B_MATERIAL2     |
      | 0.5    | Paar     | B_MATERIAL1     |
      | 0.5    | Paar     | B_MATERIAL2     |
    And I close the current editor

# BA abschließen, Behälter und Bestand prüfen, Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme1              |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | einh  | behaelter       |
      | 1    | 2      | Stück | !B_MATERIAL1^id |
      | +2   | 2      | Stück | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ"
    And I modify table
      | !row | zuomge | einh  | behaelter       |
      | 1    | 1      | Stück | !B_MATERIAL1^id |
      | +2   | 1      | Stück | !B_MATERIAL2^id |
      | +3   | 0.5    | Paar  | !B_MATERIAL1^id |
      | +4   | 0.5    | Paar  | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEINHEIT_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty

    And I deliver the SalesOrder "auftrag17" with PackingSlip "LS-17"


  Scenario: 18 Rückgabe und Storno Rückgabe mit Chargen und Behältern auf letzten AS, bisher Entnahme Teilmenge, EntnahmeMZ Charge und Behälter vor Freigabe FV angelegt
    And I set the fake date to "19.01.1995"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "S-KORRXX18"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "S-KORRXX18"

# Behälter und Chargen anlegen
    Given I create a Container "B_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL2" for packaging material "BEHAELTER"
    Given I create a Container "B_LEER" for packaging material "BEHAELTER"

    Given I create a Lot "CH_1234" for Product "EINKAUF-1"
    Given I create a Lot "CH_4567" for Product "EINKAUF-1"
    Given I create a Lot "CH_6666" for Product "EINKAUF-2"

# Auftrag anlagen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag18" for Customer "RADSHOP" with Product "M_BG-BEHAELTER" and quantity "10"

    Given I open an editor "Rechnung18" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-18    |
    And I append rows
      | artikel   | mge | charge      |
      | EINKAUF-1 | 10  | !CH_1234^id |
      | EINKAUF-1 | 10  | !CH_4567^id |
      | EINKAUF-2 | 5   | !CH_6666^id |
      | EINKAUF-2 | 5   | !CH_6666^id |
      | BEHAELTER | 3   |             |
    And I set field "verw" in row 1 to "verw" from editor "auftrag18" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag18" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag18" in row 1
    And I set field "verw" in row 4 to "verw" from editor "auftrag18" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL1^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL1^nummer" in row 2
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL1^nummer" in row 3
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL2^nummer" in row 4
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel        | netmge | mfreig |
      | M_BG-BEHAELTER | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag18" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge      | behaelter       |
      | +1   | 10     | !CH_1234^id | !B_MATERIAL1^id |
      | +2   | 10     | !CH_4567^id | !B_MATERIAL1^id |
    And I press button "abv" to open a subeditor for "mz2"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | charge      | behaelter       |
      | +1   | 5      | !CH_6666^id | !B_MATERIAL1^id |
      | +2   | 5      | !CH_6666^id | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MZUORD_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung über Teilmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZUORD_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "6" in row 1
    And I save the current editor

# Materialentnahme Teilmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Rückmeldung1^nummer |
      | gmgevorschl | 8                    |
      | bem         | Entnahme1            |
    And I press button "stllad"
    And I save the current editor
    And I wait 1 time units to move the time forward

# Teil-Rückgabe in gefüllte und leeren Behälter (über MZ)
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Rückmeldung1^nummer |
      | gmgevorschl | -6                   |
      | bem         | Rückgabe             |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | charge      | behaelter       |
      | 1    | -6     | !CH_1234^id | !B_MATERIAL1^id |
      | +2   | -4     | !CH_4567^id | !B_MATERIAL1^id |
      | +3   | -2     | !CH_4567^id | !B_LEER^id      |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ"
    And I modify table
      | !row | zuomge | charge      | behaelter       |
      | 1    | -2     | !CH_6666^id | !B_MATERIAL1^id |
      | +2   | -3     | !CH_6666^id | !B_MATERIAL2^id |
      | +3   | -1     | !CH_6666^id | !B_LEER^id      |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe1"
    Then table has values
      | bumge | elex      | nlimge | chentmge | entmge |
      | -12   | EINKAUF-1 | 16     | 0        | 16     |
      | -6    | EINKAUF-2 | 8      | 0        | 8      |
    And I save the current editor

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MZUORD_001;manrm=ja;bem=Rückgabe;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor

# Behälter prüfen
    And I switch the current editor to editor "B_MATERIAL1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | artikel   | mge | charge^such |
      | EINKAUF-1 | 6   | CH_1234     |
      | EINKAUF-1 | 8   | CH_4567     |
      | EINKAUF-2 | 2   | CH_6666     |
    And I close the current editor

    And I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge | charge^such |
      | EINKAUF-2 | 5   | CH_6666     |
    And I close the current editor

    And I switch the current editor to editor "B_LEER" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel   | mge | charge^such |
      | EINKAUF-1 | 2   | CH_4567     |
      | EINKAUF-2 | 1   | CH_6666     |
    And I close the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | rueckmge | restmge | vcharge^such | behaelter^such | !row |
      | EINKAUF-1 | -2   |      | -2       | 0       | CH_4567      | B_LEER         | 1    |
      | EINKAUF-1 | -4   |      | -4       | 0       | CH_4567      | B_MATERIAL1    | 2    |
      | EINKAUF-1 | -6   |      | -6       | 0       | CH_1234      | B_MATERIAL1    | 3    |
      | EINKAUF-2 | -1   |      | -1       | 0       | CH_6666      | B_LEER         | 4    |
      | EINKAUF-2 | -2   |      | -2       | 0       | CH_6666      | B_MATERIAL2    | 5    |
      | EINKAUF-2 | -1   |      | -1       | 0       | CH_6666      | B_MATERIAL2    | 6    |
      | EINKAUF-2 | -2   |      | -2       | 0       | CH_6666      | B_MATERIAL1    | 7    |
      | BEHAELTER | -1   |      | -1       | 0       |              |                | 8    |
      | EINKAUF-1 | 6    |      | 6        | 0       | CH_4567      | B_MATERIAL1    | 9    |
      | EINKAUF-1 | 10   |      | 6        | 4       | CH_1234      | B_MATERIAL1    | 10   |
      | EINKAUF-2 | 3    |      | 3        | 0       | CH_6666      | B_MATERIAL2    | 11   |
      | EINKAUF-2 | 5    |      | 3        | 2       | CH_6666      | B_MATERIAL1    | 12   |
    And I close the current editor

# Storno Rückbau, Beleg, Behälter und Bestand prüfen
    Given I open an editor "Rückgabe1_Storno" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    And I switch the current editor to editor "Rückgabe1_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückgabe1"
    Then table has values
      | mge | artikel        | rueckmge | restmge | limgev | limgen | chentmge | !row |
      | 4   | M_BG-BEHAELTER | 0        | 0       | 0      | 0      | 0        | 1    |
      | 6   | EINKAUF-2      | 0        | 6       | 8      | 2      | 0        | 3    |
      | 12  | EINKAUF-1      | 0        | 12      | 16     | 4      | 0        | 4    |
    And I close the current editor

    Given I switch the current editor to editor "B_MATERIAL1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge | charge^such |
      | EINKAUF-1 | 4   | CH_4567     |
    And I close the current editor

    Given I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge | charge^such |
      | EINKAUF-2 | 2   | CH_6666     |
    And I close the current editor

    Then Container from editor "B_LEER" is empty

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | behaelter  | ja        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | charge^such | tbehaelter^such |
      | 4      | CH_4567     | B_MATERIAL1     |
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | charge^such | tbehaelter^such |
      | 2      | CH_6666     | B_MATERIAL2     |
    And I close the current editor

# Materialentnahme und Rückmeldung auf ersten AG
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Rückmeldung1^nummer |
      | bem     | Entnahme2            |
    And I press button "stllad"
	And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
    And I set field "charge" to "!CH_4567^id" in row 1
	And I set field "behaelter" to "!B_MATERIAL1^id" in row 1
	And I press button for next product
    And I set field "charge" to "!CH_6666^id" in row 1
	And I set field "behaelter" to "!B_MATERIAL2^id" in row 1
	And I save the current editor
	And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZUORD_001"
    And I set fields
      | gut     | ja |
      | sofort  | ja |
      | manrest | ja |
    And I save the current editor

# Behälter und Bestand prüfen
    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty
    Then Container from editor "B_LEER" is empty

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | behaelter  | ja        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Lieferschein zu Auftrag
    And I deliver the SalesOrder "auftrag18" with PackingSlip "LS-18"


  Scenario: 19 Rückgabe mit Einheiten, Chargen und Behälter auf letzten AS, bisher Entnahme Gesamtmenge, EntnahmeMZ Behälter und Einheit vor Freigabe FV angelegt
    And I set the fake date to "20.01.1995"
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "S-KORR19"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "S-KORR19"

# Behälter anlegen
    Given I create a Container "B_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL2" for packaging material "BEHAELTER"

# Auftrag anlagen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag19" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "10"

    Given I open an editor "Rechnung19" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-19    |
    And I append rows
      | artikel    | mge | he   |
      | GEBINDEPFL | 2   | Paar |
      | GEBINDEPFL | 3   | Paar |
      | GEBINDE    | 50  | kg   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag19" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag19" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag19" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL1^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL2^nummer" in row 2
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL2^nummer" in row 3
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BG-GEBINDE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag19" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | behaelter       |
      | +1   | 10     | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | +1   | 2      | Paar | !B_MATERIAL1^id |
      | +2   | 3      | Paar | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEINHEIT_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BEINHEIT_001;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Materialentnahme gesamtes Material
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme1              |
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEINHEIT_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Teil-Rückgabe in leeren Behälter über MZ in Handelseinheit kg und Paar
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
      | bem         | Rückgabe               |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | 1    | -5     | kg   | !B_MATERIAL1^id |
      | +2   | -5     | kg   | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ"
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | 1    | -0.5   | Paar | !B_MATERIAL1^id |
      | +2   | -0.5   | Paar | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe1"
    And I save the current editor

# Behälter, LJ und Bestand prüfen
    And I switch the current editor to editor "B_MATERIAL1" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 1   | Stück   |
      | GEBINDEPFL | 0.5 | Paar    |
    And I close the current editor

    And I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 1   | Stück   |
      | GEBINDEPFL | 0.5 | Paar    |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Arbeitsschein1^nummer"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | mei   | rueckmge | restmge | behaelter^such | !row |
      | GEBINDE    | -5   | kg    | -1       | 0       | B_MATERIAL2    | 1    |
      | GEBINDE    | -5   | kg    | -1       | 0       | B_MATERIAL1    | 2    |
      | GEBINDEPFL | -0.5 | Paar  | -1       | 0       | B_MATERIAL2    | 3    |
      | GEBINDEPFL | -0.5 | Paar  | -1       | 0       | B_MATERIAL1    | 4    |
      | GEBINDE    | 10   | Stück | 2        | 8       | B_MATERIAL2    | 5    |
      | GEBINDEPFL | 3    | Paar  | 2        | 4       | B_MATERIAL2    | 6    |
      | GEBINDEPFL | 2    | Paar  | 0        | 4       | B_MATERIAL1    | 7    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | behaelter  | ja      |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 1      | Stück    | B_MATERIAL1     |
      | 1      | Stück    | B_MATERIAL2     |
    And I set fields
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 0.5    | Paar     | B_MATERIAL1     |
      | 0.5    | Paar     | B_MATERIAL2     |
    And I close the current editor

# Teil-Rückgabe in leeren Behälter über MZ in Lagereineit Stück
    Given I open an editor "Rückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
      | bem         | Rückgabe               |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | einh  | behaelter       |
      | 1    | -1     | Stück | !B_MATERIAL1^id |
      | +2   | -1     | Stück | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ"
    And I modify table
      | !row | zuomge | einh  | behaelter       |
      | 1    | -1     | Stück | !B_MATERIAL1^id |
      | +2   | -1     | Stück | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe2"
    And I save the current editor

# Behälter, LJ und Bestand prüfen
    And I switch the current editor to editor "B_MATERIAL1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 2   | Stück   |
      | GEBINDEPFL | 1   | Stück   |
      | GEBINDEPFL | 0.5 | Paar    |
    And I close the current editor

    And I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 2   | Stück   |
      | GEBINDEPFL | 1   | Stück   |
      | GEBINDEPFL | 0.5 | Paar    |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Arbeitsschein1^nummer"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | mei   | rueckmge | restmge | behaelter^such | !row |
      | GEBINDE    | -1   | Stück | -1       | 0       | B_MATERIAL2    | 1    |
      | GEBINDE    | -1   | Stück | -1       | 0       | B_MATERIAL1    | 2    |
      | GEBINDEPFL | -1   | Stück | -1       | 0       | B_MATERIAL2    | 3    |
      | GEBINDEPFL | -1   | Stück | -1       | 0       | B_MATERIAL1    | 4    |
      | GEBINDE    | -5   | kg    | -1       | 0       | B_MATERIAL2    | 5    |
      | GEBINDE    | -5   | kg    | -1       | 0       | B_MATERIAL1    | 6    |
      | GEBINDEPFL | -0.5 | Paar  | -1       | 0       | B_MATERIAL2    | 7    |
      | GEBINDEPFL | -0.5 | Paar  | -1       | 0       | B_MATERIAL1    | 8    |
      | GEBINDE    | 10   | Stück | 4        | 6       | B_MATERIAL2    | 9    |
      | GEBINDEPFL | 3    | Paar  | 4        | 2       | B_MATERIAL2    | 10   |
      | GEBINDEPFL | 2    | Paar  | 0        | 4       | B_MATERIAL1    | 11   |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | behaelter  | ja      |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 2      | Stück    | B_MATERIAL1     |
      | 2      | Stück    | B_MATERIAL2     |
    And I set fields
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    Then the table has 4 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 1      | Stück    | B_MATERIAL1     |
      | 1      | Stück    | B_MATERIAL2     |
      | 0.5    | Paar     | B_MATERIAL1     |
      | 0.5    | Paar     | B_MATERIAL2     |
    And I close the current editor

# BA abschließen, Behälter und Bestand prüfen, Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme1              |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | einh  | behaelter       |
      | 1    | 2      | Stück | !B_MATERIAL1^id |
      | +2   | 2      | Stück | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ"
    And I modify table
      | !row | zuomge | einh  | behaelter       |
      | 1    | 1      | Stück | !B_MATERIAL1^id |
      | +2   | 1      | Stück | !B_MATERIAL2^id |
      | +3   | 0.5    | Paar  | !B_MATERIAL1^id |
      | +4   | 0.5    | Paar  | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEINHEIT_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | behaelter  | ja      |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag19" with PackingSlip "LS-19"


  Scenario: 20 Storno Rückbau mit Einheiten ohne Gebindepflicht, bisher Fbuchung gesamtes Material aus Behälter in LE, Rückgabe in Behälter in HE, EntnahmeMZ vor Freigabe FV angelegt
    And I set the fake date to "21.01.1995"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "S-KORR20"

# Behälter anlegen
    Given I create a Container "B_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL2" for packaging material "BEHAELTER"

# Auftrag anlagen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag20" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "10"

    Given I open an editor "Rechnung20" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-20    |
    And I append rows
      | artikel    | mge | he   |
      | GEBINDEPFL | 5   | Paar |
      | GEBINDE    | 50  | kg   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag20" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag20" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL1^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL2^nummer" in row 2
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BG-GEBINDE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag20" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | einh  | behaelter       |
      | +1   | 10     | Stück | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | +1   | 5      | Paar | !B_MATERIAL1^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEINHEIT2_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BEINHEIT2_001;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Materialentnahme gesamtes Material
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme1              |
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEINHEIT2_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty

# Teil-Rückgabe in leeren Behälter über MZ in Handelseinheit kg
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
      | bem         | Rückgabe               |
    And I press button "stllad"
    And I delete row at position 2
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | 1    | -5     | kg   | !B_MATERIAL1^id |
      | +2   | -5     | kg   | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe1"
    And I save the current editor

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEINHEIT2_001;manrm=ja;bem=Rückgabe;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | behaelter  | ja      |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 1      | Stück    | B_MATERIAL1     |
      | 1      | Stück    | B_MATERIAL2     |
    And I close the current editor

# Rückgabe stornieren, Bestand und Behälter prüfen
    Given I open an editor "Rückgabe1_Storno" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I switch the current editor to editor "Rückgabe1_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückgabe1"
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | 2   | GEBINDE    | 0        | 2       | 2      | 0      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | behaelter  | ja      |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEINHEIT2_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    Given I deliver the SalesOrder "auftrag20" with PackingSlip "LS-20"


  Scenario: 21 Storno Rückbau mit Einheiten mit Gebindepflicht, bisher Fbuchung gesamtes Material aus Behälter in LE, Rückgabe in Behälter in HE, EntnahmeMZ vor Freigabe FV angelegt
    And I set the fake date to "22.01.1995"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "S-KORR21"

# Behälter anlegen
    Given I create a Container "B_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL2" for packaging material "BEHAELTER"

# Auftrag anlagen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag21" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "10"

    Given I open an editor "Rechnung21" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-21    |
    And I append rows
      | artikel    | mge | he   |
      | GEBINDEPFL | 5   | Paar |
      | GEBINDE    | 50  | kg   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag21" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag21" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL1^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL2^nummer" in row 2
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BG-GEBINDE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag21" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | behaelter       |
      | +1   | 10     | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | +1   | 5      | Paar | !B_MATERIAL1^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEINHEIT3_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BEINHEIT3_001;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Materialentnahme gesamtes Material
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme1              |
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEINHEIT3_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Teil-Rückgabe in leeren Behälter über MZ in Handelseinheit kg
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
      | bem         | Rückgabe               |
    And I press button "stllad"
    And I delete row at position 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | einh  | behaelter       |
      | 1    | -1     | Stück | !B_MATERIAL1^id |
      | +2   | -1     | Stück | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe1"
    And I save the current editor

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEINHEIT3_001;manrm=ja;bem=Rückgabe;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDEPFL |
      | klplatz    | F1         |
      | behaelter  | ja         |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 1      | Stück    | B_MATERIAL1     |
      | 1      | Stück    | B_MATERIAL2     |
    And I close the current editor

# Rückgabe stornieren, Bestand und Behälter prüfen
    Given I open an editor "Rückgabe1_Storno" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I switch the current editor to editor "Rückgabe1_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückgabe1"
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | 2   | GEBINDEPFL | 0        | 2       | 2      | 0      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDEPFL |
      | klplatz    | F1         |
      | behaelter  | ja         |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEINHEIT3_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    Given I deliver the SalesOrder "auftrag21" with PackingSlip "LS-21"


  Scenario: 22 Storno Rückbau mit Einheiten mit Gebindepflicht, bisher Fbuchung gesamtes Material aus Behälter in LE, Rückgabe in Behälter in LE, EntnahmeMZ vor Freigabe FV angelegt
    And I set the fake date to "23.01.1995"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "S-KORR22"

# Behälter anlegen
    Given I create a Container "B_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL2" for packaging material "BEHAELTER"

# Auftrag anlagen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag22" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "10"

    Given I open an editor "Rechnung22" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-22    |
    And I append rows
      | artikel    | mge | he   |
      | GEBINDEPFL | 5   | Paar |
      | GEBINDE    | 50  | kg   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag22" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag22" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL1^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL2^nummer" in row 2
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BG-GEBINDE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag22" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | behaelter       |
      | +1   | 10     | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | +1   | 5      | Paar | !B_MATERIAL1^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEINHEIT4_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BEINHEIT4_001;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Materialentnahme gesamtes Material
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme1              |
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEINHEIT4_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Teil-Rückgabe in leeren Behälter über MZ in Handelseinheit kg
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
      | bem         | Rückgabe               |
    And I press button "stllad"
    And I delete row at position 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | 1    | -0.5   | Paar | !B_MATERIAL1^id |
      | +2   | -0.5   | Paar | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe1"
    And I save the current editor

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEINHEIT4_001;manrm=ja;bem=Rückgabe;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDEPFL |
      | klplatz    | F1         |
      | behaelter  | ja         |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 0.5    | Paar     | B_MATERIAL1     |
      | 0.5    | Paar     | B_MATERIAL2     |
    And I close the current editor

# Rückgabe stornieren, Bestand und Behälter prüfen
    Given I open an editor "Rückgabe1_Storno" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I switch the current editor to editor "Rückgabe1_Storno" with command "VIEW"
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückgabe1"
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | 2   | GEBINDEPFL | 0        | 2       | 2      | 0      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDEPFL |
      | klplatz    | F1         |
      | behaelter  | ja         |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEINHEIT4_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    Given I deliver the SalesOrder "auftrag22" with PackingSlip "LS-22"


  Scenario: 23 Rückgabe mit Einheiten und gebindiepflichtigem Material in Behälter auf letzten AS, bisher Materialentnahme auf letzten AS, EntnahmeMZ Einhieten und Behälter vor Freigabe FV angelegt
    And I set the fake date to "24.01.1995"
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "S-KORR23"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "S-KORR23"

# Behälter anlegen
    Given I create a Container "B_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL2" for packaging material "BEHAELTER"

# Auftrag anlagen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "10"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-23    |
    And I append rows
      | artikel    | mge | he   |
      | GEBINDEPFL | 2   | Paar |
      | GEBINDEPFL | 3   | Paar |
      | GEBINDE    | 50  | kg   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL1^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL2^nummer" in row 2
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL2^nummer" in row 3
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BG-GEBINDE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | behaelter       |
      | +1   | 10     | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | +1   | 2      | Paar | !B_MATERIAL1^id |
      | +2   | 3      | Paar | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEINHEIT_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BEINHEIT_001;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Materialentnahme gesamtes Material
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme1              |
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEINHEIT_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Teil-Rückgabe in leeren Behälter über MZ in Handelseinheit kg und Paar
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
      | bem         | Rückgabe               |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | 1    | -5     | kg   | !B_MATERIAL1^id |
      | +2   | -5     | kg   | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ"
    And I modify table
      | !row | zuomge | einh | behaelter       |
      | 1    | -0.5   | Paar | !B_MATERIAL1^id |
      | +2   | -0.5   | Paar | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe1"
    And I save the current editor

# Behälter, LJ und Bestand prüfen
    And I switch the current editor to editor "B_MATERIAL1" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 1   | Stück   |
      | GEBINDEPFL | 0.5 | Paar    |
    And I close the current editor

    And I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 1   | Stück   |
      | GEBINDEPFL | 0.5 | Paar    |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Arbeitsschein1^nummer"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | mei   | rueckmge | restmge | behaelter^such | !row |
      | GEBINDE    | -5   | kg    | -1       | 0       | B_MATERIAL2    | 1    |
      | GEBINDE    | -5   | kg    | -1       | 0       | B_MATERIAL1    | 2    |
      | GEBINDEPFL | -0.5 | Paar  | -1       | 0       | B_MATERIAL2    | 3    |
      | GEBINDEPFL | -0.5 | Paar  | -1       | 0       | B_MATERIAL1    | 4    |
      | GEBINDE    | 10   | Stück | 2        | 8       | B_MATERIAL2    | 5    |
      | GEBINDEPFL | 3    | Paar  | 2        | 4       | B_MATERIAL2    | 6    |
      | GEBINDEPFL | 2    | Paar  | 0        | 4       | B_MATERIAL1    | 7    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | behaelter  | ja      |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 1      | Stück    | B_MATERIAL1     |
      | 1      | Stück    | B_MATERIAL2     |
    And I set fields
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 0.5    | Paar     | B_MATERIAL1     |
      | 0.5    | Paar     | B_MATERIAL2     |
    And I close the current editor

# Teil-Rückgabe in leeren Behälter über MZ in Lagereineit Stück
    Given I open an editor "Rückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
      | bem         | Rückgabe               |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | einh  | behaelter       |
      | 1    | -1     | Stück | !B_MATERIAL1^id |
      | +2   | -1     | Stück | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ"
    And I modify table
      | !row | zuomge | einh  | behaelter       |
      | 1    | -1     | Stück | !B_MATERIAL1^id |
      | +2   | -1     | Stück | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "Rückgabe2"
    And I save the current editor

# Behälter, LJ und Bestand prüfen
    And I switch the current editor to editor "B_MATERIAL1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 2   | Stück   |
      | GEBINDEPFL | 1   | Stück   |
      | GEBINDEPFL | 0.5 | Paar    |
    And I close the current editor

    And I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 2   | Stück   |
      | GEBINDEPFL | 1   | Stück   |
      | GEBINDEPFL | 0.5 | Paar    |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Arbeitsschein1^nummer"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | mei   | rueckmge | restmge | behaelter^such | !row |
      | GEBINDE    | -1   | Stück | -1       | 0       | B_MATERIAL2    | 1    |
      | GEBINDE    | -1   | Stück | -1       | 0       | B_MATERIAL1    | 2    |
      | GEBINDEPFL | -1   | Stück | -1       | 0       | B_MATERIAL2    | 3    |
      | GEBINDEPFL | -1   | Stück | -1       | 0       | B_MATERIAL1    | 4    |
      | GEBINDE    | -5   | kg    | -1       | 0       | B_MATERIAL2    | 5    |
      | GEBINDE    | -5   | kg    | -1       | 0       | B_MATERIAL1    | 6    |
      | GEBINDEPFL | -0.5 | Paar  | -1       | 0       | B_MATERIAL2    | 7    |
      | GEBINDEPFL | -0.5 | Paar  | -1       | 0       | B_MATERIAL1    | 8    |
      | GEBINDE    | 10   | Stück | 4        | 6       | B_MATERIAL2    | 9    |
      | GEBINDEPFL | 3    | Paar  | 4        | 2       | B_MATERIAL2    | 10   |
      | GEBINDEPFL | 2    | Paar  | 0        | 4       | B_MATERIAL1    | 11   |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | behaelter  | ja      |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 2      | Stück    | B_MATERIAL1     |
      | 2      | Stück    | B_MATERIAL2     |
    And I set fields
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    Then the table has 4 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^such |
      | 1      | Stück    | B_MATERIAL1     |
      | 1      | Stück    | B_MATERIAL2     |
      | 0.5    | Paar     | B_MATERIAL1     |
      | 0.5    | Paar     | B_MATERIAL2     |
    And I close the current editor

# BA abschließen, Behälter und Bestand prüfen, Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme1              |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | einh  | behaelter       |
      | 1    | 2      | Stück | !B_MATERIAL1^id |
      | +2   | 2      | Stück | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "MZ"
    And I modify table
      | !row | zuomge | einh  | behaelter       |
      | 1    | 1      | Stück | !B_MATERIAL1^id |
      | +2   | 1      | Stück | !B_MATERIAL2^id |
      | +3   | 0.5    | Paar  | !B_MATERIAL1^id |
      | +4   | 0.5    | Paar  | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEINHEIT_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | behaelter  | ja      |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-23"
