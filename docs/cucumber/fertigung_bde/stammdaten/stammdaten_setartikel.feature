@persistent
Feature: stammdaten_setartikel.feature

  Background:
    And I set the fake date to "12.02.1995"


# *****************************************************************************
#  Name             : stammdaten_setartikel
#  Autor            : lschneider
#  Verantwortlich   : bheim
#  Kontrolle        : amk
#  Funktion         : Testet die Prozesse rund um Setartikel
#  Jira-Issue       : FDA-785
#  ref              : ref_fe_set_stammdaten_cu
# *****************************************************************************


  Scenario: 01 bsart = Eigenfertigung und schreibgeschützt, wenn Entnahmeart über Stückliste

    Given I open an editor "SETARTIKEL_TEST" from table "(Part):(Product)" with command "NEW" for record ""
    And I set field "earta" to "über Stückliste"
    Then field "bsart" has value "Eigenfertigung"
    Then field "bsart" is not modifiable
    And I close the current editor


  Scenario: 02 Mindestbestand, Losgröße, Losbildungsfrist, minimale und maximale Beschaffmenge sind schreibgeschützt

    Given I open an editor "SETARTIKEL_TEST" from table "(Part):(Product)" with command "NEW" for record ""
    And I set field "earta" to "über Stückliste"
    Then fields are modifiable
      | mindest  | nein |
      | losgr    | nein |
      | losbild  | nein |
      | minbsmge | nein |
      | maxbsmge | nein |
    And I close the current editor


#Scenario: 03 mindest, losgr, losbild, minbsmge, maxbsmge werden beim Ändern auf Entnahmeart über Stückliste geleert
           # entfällt, da nicht mehr möglich. Feldprüfungen in Scenario 4 integriert


  Scenario: 04 Wechsel der Entnahmeart bei Set ohne Lagergruppeneigenschaften möglich, mindest, losgr, losbild, minbsmge, maxbsmge werden beim Ändern geleert

    Given I open an editor "SET-ARTIKEL" from table "(Part):(Product)" with command "UPDATE" for record "SET-ARTIKEL"
    And I set field "earta" to "Über Artikel"
    Then field "earta" has value "Über Artikel"
    And I set fields
      | mindest  | 100  |
      | losgr    | 20   |
      | maxbsmge | 1000 |
    And I set field "earta" to "Über Stückliste"
    Then field "earta" has value "Über Stückliste"
    Then fields are modifiable
      | mindest  | nein |
      | losgr    | nein |
      | losbild  | nein |
      | minbsmge | nein |
      | maxbsmge | nein |
    Then fields have values
      | mindest  | 0 |
      | losgr    | 0 |
      | losbild  | 0 |
      | minbsmge | 0 |
      | maxbsmge | 0 |
    And I close the current editor


  Scenario: 05 Lagergruppeneigenschaften für Setartikel haben Vorbelegung Eigenfertigung und über Stückliste, Angaben müssen gleich sein

    Given I open an editor "SET-LAGERGR2" from table "(Part):(Product)" with command "COPY" for record "SET-LAGERGR"
    And I set field "such" to "SET-LAGERGR2"
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I create a new row at the end of the table
    And I set field "lgruppe" to "HONGKONG" in row 1
    Then field "earta" has value "Über Stückliste" in row 1

# Dialog 1359: Der Artikel wird oder war ein Setartikel, diese Eigenschaft wird dann für alle Lagergruppen gültig sein.
# muss dann über Fehlermeldung geprüft werden: über Artikel ist in diesem Zusammenhang ein ungültiger Feldwert
# daher Prüfung der Fehlermeldung 1361 | Ungültiger Feldwert
    And I respond with answer "nein" to the dialog with id "1359"
    Then setting field "earta" to "Über Stückliste" in row 1 throws the exception "1361"
    Then field "earta" has value "Über Stückliste" in row 1

# Dialog 1359: Der Artikel wird oder war ein Setartikel, diese Eigenschaft wird dann für alle Lagergruppen gültig sein.
    And I respond with answer "ja" to the dialog with id "1359"
    And I set field "earta" to "Über Artikel" in row 1
    Then field "earta" has value "Über Artikel" in row 1
    And I save the current editor
    And I switch the current editor to editor "SET-LAGERGR2"
    Then field "earta" has value "Über Artikel"
    And I close the current editor


  Scenario Outline: 06 Setartikel können in Einkaufsbelegen nicht verwendet werden

    Given I open an editor "<Beleg>" from table "<table>" with command "NEW" for record ""
    And I set fields
      | lief | <lief> |
    And I create a new row at the end of the table
    Then setting field "artikel" to "SET-ARTIKEL" in row !lastRow throws the exception "1674"
    And I close the current editor

    Examples:
      | Beleg         | table                             | lief        |
      | Ausschreibung | (BiddingProcess):(BiddingProcess) | !dontChange |
      | Anfrage       | (Purchasing):(Request)            | KETTLER     |
      | Rahmenauftrag | (Purchasing):(BlanketOrder)       | KETTLER     |
      | Bestellung    | (Purchasing):(PurchaseOrder)      | KETTLER     |
      | Lieferschein  | (Purchasing):(PackingSlip)        | KETTLER     |
      | Rechnung      | (Purchasing):(Invoice)            | KETTLER     |


  Scenario: 07 Setartikel kann im Umlagerungsvorschlag nicht verwendet werden

    Given I open an editor "Umlagerungsvorschlag" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
    Then setting field "artikel" to "SET-ARTIKEL" in row !lastRow throws the exception "1674"
    And I close the current editor


  Scenario: 08 Setartikel können in einer Kundenanlieferung nicht verwendet werden

    Given I open an editor "Kundenanlieferung" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | lsart | Kundenanlieferung |
      | kunde | RADSHOP           |
    And I create a new row at the end of the table
    Then setting field "artikel" to "SET-ARTIKEL" in row !lastRow throws the exception "1674"
    And I close the current editor


  Scenario: 09 Setartikel ohne Stückliste kann nicht gespeichert werden

    Given I open an editor "SETARTIKEL_TEST" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such  | SETARTIKEL_TEST |
      | earta | über Stückliste |
# 1368 de      |Die Stückliste darf bei einem Setartikel nicht leer sein.
# 2743 Vorgang abgebrochen
    Then saving the current editor throws the exception "1368"
    And I close the current editor


  Scenario: 10 Manuelle Lagerbuchung von Setartikeln Zugang nicht möglich

    Given I open an editor "Lagerbuchung" for tip command "Lbuchung" and arguments ""
    And I set fields
      | artikel | SET-ARTIKEL |
    Then setting field "buart" to "Zugang" throws the exception "10680"
    And I close the current editor


  Scenario: 11 Sets/Pseudobaugruppe sind in einem Fertigungsvorschlag nicht erlaubt

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
    Then setting field "artikel" to "SET-ARTIKEL" in row !lastRow throws the exception "1674"
    And I close the current editor


  Scenario: 12 Setartikel können in der Materialentnahme nicht zugefügt und entnommen werden

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I modify table
      | artikel     | mge | bisuch   | mfreig | !row |
      | M_BAUGRUPPE | 10  | SETENTN_ | ja     | +1   |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SETENTN_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I create a new row at the end of the table
    Then setting field "elex" to "SET-ARTIKEL" in row !lastRow throws the exception "10680"
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SETENTN_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 13 Setartikel können in einer Rückmeldung nicht zugefügt und entnommen werden

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I modify table
      | artikel   | mge | bisuch    | mfreig | !row |
      | BAUGRUPPE | 10  | SETRUECK_ | ja     | +1   |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SETRUECK_001"
    And I create a new row at the end of the table
    Then setting field "artikel" to "SET-ARTIKEL" in row !lastRow throws the exception "10680"
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SETRUECK_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 14 Setartikel können in Rückmeldung neu nicht zugefügt und entnommen werden

    Given I open an editor "Rückmeldung_neu" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
    And I set fields
      | barmex  | 100       |
      | mgr     | 112       |
      | artikel | BAUGRUPPE |
      | kstelle | 100       |
    And I create a new row at the end of the table
    Then setting field "artikel" to "SET-ARTIKEL" in row 1 throws the exception "10680"
    And I close the current editor


  Scenario: 15 Setartikel dürfen selbst in der AFL keine Filterangabe erhalten

    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
    And I modify table
      | artikel   | mge | !row |
      | BAUGRUPPE | 10  | +1   |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I create a new row at position 1
    And I set field "elex" to "SET-ARTIKEL" in row 1
    Then field "filter" is not modifiable in row 1
    And I close the current editor
    And I switch the current editor to editor "Auftrag"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 16 Setartikel können keine Auslaufartikel sein

    Given I open an editor "SET-ARTIKEL" from table "(Part):(Product)" with command "UPDATE" for record "SET-ARTIKEL"
    Then field "nachfolgeartikel" is not modifiable
    And I close the current editor


  Scenario: 17 Beim Eintrag eines Sets in eine AFL wird die STL des Sets aufgelöst, die Setangabe verschwindet

    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
    And I modify table
      | artikel   | mge | !row |
      | BAUGRUPPE | 10  | +1   |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I create a new row at position 1
    And I set field "elex" to "SET-ARTIKEL" in row 1
    And I respond with answer "nein" to the dialog with id "1537"
    Then setting field "elanzahl" to "1" in row 1 throws the exception "1361"
    Then field "elex" has value "SET-ARTIKEL" in row 1
    And I respond with answer "ja" to the dialog with id "1537"
    And I set field "elanzahl" to "1" in row 1
# Beim Eintrag eines weiteren Sets in die AFL wird die STL des Sets nicht  aufgelöst, die Setangabe bleibt
    And I create a new row at position 1
    And I set field "elex" to "SET-ARTIKEL" in row 1
    And I set field "elanzahl" to "0" in row 1
    Then table has values
      | elex        | elanzahl |
      | SET-ARTIKEL | 0        |
      | EINKAUF-1   | 1        |
      | EINKAUF-2   | 1        |
      | EINKAUF-1   | 2        |
      | EINKAUF-2   | 1        |
    And I save the current editor
    And I switch the current editor to editor "Auftrag"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then table has values
      | elex        | elanzahl |
      | SET-ARTIKEL | 0        |
      | EINKAUF-1   | 1        |
      | EINKAUF-2   | 1        |
      | EINKAUF-1   | 2        |
      | EINKAUF-2   | 1        |
    And I close the current editor
    And I switch the current editor to editor "Auftrag"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 18 Lagergruppeneigenschaften werden beim Auflösen des Sets der AFL berücksichtigt

# Auftrag für VK_LAGERGR
    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
    And I modify table
      | artikel    | mge | platz | !row |
      | VK-LAGERGR | 10  | L2F1  | +1   |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I create a new row at position 1
    And I set field "elex" to "SET-LAGERGR" in row 1
#    1537 de   |Es wurde ein Setartikel eingetragen, soll dieser aufgelöst werden?
    And I respond with answer "ja" to the dialog with id "1537"
    And I set field "elanzahl" to "1" in row 1
    Then table has values
      | elex       | elanzahl | !row |
      | EINKAUF-1  | 5        | 1    |
      | EINKAUF-2  | 5        | 2    |
      | EINKAUF-1  | 5        | 3    |
      | A MONTAGE1 | 1        | 4    |
    And I close the current editor
    And I switch the current editor to editor "Auftrag"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 19 Entsteht für Setartikel ohne Lagergruppeneigenschaften extern ein Bedarf, werden die Stammdaten herangezogen

# Auftrag VK-LAGERGR
    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
    And I modify table
      | artikel    | mge | platz | !row |
      | VK-LAGERGR | 10  | L3F1  | +1   |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I create a new row at position 1
    And I set field "elex" to "SET-LAGERGR" in row 1
#    1537 de   |Es wurde ein Setartikel eingetragen, soll dieser aufgelöst werden?
    And I respond with answer "ja" to the dialog with id "1537"
    And I set field "elanzahl" to "1" in row 1
    Then table has values
      | elex       | elanzahl | !row |
      | EINKAUF-1  | 1        | 1    |
      | EINKAUF-2  | 1        | 2    |
      | EINKAUF-1  | 1        | 3    |
      | A MONTAGE1 | 1        | 4    |
    And I close the current editor
    And I switch the current editor to editor "Auftrag"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: P01 Manuelle Lagerbuchung Abgang von Setartikeln

# Bestände auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-S1"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "KORR-S1"

# Manuelle Lagerbuchung Abgang
    Given I open an editor "Lagerbuchung" for tip command "Lbuchung" and arguments ""
    And I set fields
      | artikel | SET-ARTIKEL |
      | buart   | Abgang      |
      | beldat  | .           |
      | beleg   | AB01        |
    Then field "stl" has value "ja"
    Then field "stl" is not modifiable
    And I modify table
      | mge | platz | !row |
      | 10  | F1    | 1    |
    And I save the current editor

    Given I open the infosystem "LJ"
    And I set field "beleg" to "Ab01"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | nplatz | vplatz | detursache           |
      | SET-ARTIKEL | 10   | 10   |        | F1     | Durchgang Setartikel |
      | EINKAUF-2   |      | 10   |        | F1     | Manueller Abgang     |
      | EINKAUF-1   |      | 10   |        | F1     | Manueller Abgang     |
    And I close the current editor

# Bestände prüfen
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
      | lemge | gebmge |
      | -10   |        |
      |       | -10    |
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge |
      | -10   |        |
      |       | -10    |
    And I set fields
      | artikel | SET-ARTIKEL |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: P02 Manuelle Lagerbuchung Umbuchung von Setartikeln

# Bestände auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-S2"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "KORR-S2"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "KORR-S2"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F2" with document "KORR-S2"

# Manuelle Lagerbuchung Umbuchung
    Given I open an editor "Lagerbuchung" for tip command "Lbuchung" and arguments ""
    And I set fields
      | artikel | SET-ARTIKEL |
      | buart   | Umbuchung   |
      | beldat  | .           |
      | beleg   | UM01        |
    Then field "stl" has value "ja"
    Then field "stl" is not modifiable
    And I modify table
      | mge | platz2 | platz | !row |
      | 10  | F2     | F1    | 1    |
    And I save the current editor

    Given I open the infosystem "LJ"
    And I set field "beleg" to "UM01"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | nplatz | vplatz | detursache           |
      | SET-ARTIKEL | 10   | 10   |        | F1     | Durchgang Setartikel |
      | EINKAUF-2   | 10   |      | F2     |        | Manuelle Umbuchung   |
      | EINKAUF-2   |      | 10   |        | F1     | Manuelle Umbuchung   |
      | EINKAUF-1   | 10   |      | F2     |        | Manuelle Umbuchung   |
      | EINKAUF-1   |      | 10   |        | F1     | Manuelle Umbuchung   |
    And I close the current editor

# Bestände prüfen
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
      | F1     | -10   |        |
      | F1     |       | -10    |
      | F2     | 10    |        |
      | F2     |       | 10     |
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lplatz | lemge | gebmge |
      | F1     | -10   |        |
      | F1     |       | -10    |
      | F2     | 10    |        |
      | F2     |       | 10     |
    And I set fields
      | artikel | SET-ARTIKEL |
      | details | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor

  Scenario: 20 Wechsel der Entnahmeart von Entnahmeart "über Artikel" oder "keine" ist nicht möglich wenn gebuchgt oder verwendet

    Given I open an editor "SET-ARTIKEL" from table "(Part):(Product)" with command "COPY" for record "SET-ARTIKEL"
    And I set fields
      | such   | ART-TO-SET-TEST     |
      | earta  | über Artikel        |
      | dispoa | restmengenbezogen   |
      | name   | Artikel zu Set Test |
    And I save the current editor

# Manuelle Lagerbuchung
    Given I open an editor "Lagerbuchung" for tip command "Lbuchung" and arguments ""
    And I set fields
      | artikel | ART-TO-SET-TEST |
      | buart   | Zugang          |
      | beldat  | .               |
      | beleg   | ZU01            |
    And I modify table
      | mge | !row |
      | 10  | 1    |
    And I save the current editor

    Given I open an editor "SET-ARTIKEL" from table "(Part):(Product)" with command "UPDATE" for record "ART-TO-SET-TEST"
    Then setting field "earta" to "über Stückliste" throws the exception "1543"
    And I set field "earta" to "keine"
    And I save the current editor

    Given I open an editor "SET-ARTIKEL" from table "(Part):(Product)" with command "UPDATE" for record "ART-TO-SET-TEST"
    Then setting field "earta" to "über Stückliste" throws the exception "1543"
    And I close the current editor

# Artikel der nicht gebucht und nicht verwendet wurde, darf umgestellt werden
    Given I open an editor "SET-ARTIKEL" from table "(Part):(Product)" with command "COPY" for record "SET-ARTIKEL"
    And I set fields
      | such  | ART-TO-SET-TEST2     |
      | earta | über Artikel         |
      | name  | Artikel zu Set Test2 |
    And I save the current editor

    Given I open an editor "SET-ARTIKEL" from table "(Part):(Product)" with command "UPDATE" for record "ART-TO-SET-TEST2"
    And I set field "earta" to "über Stückliste"
    And I save the current editor


  Scenario: 21 Ein Setartikel mit AG in der FL ist im rueckgemeldeten Bereich nicht erlaubt

# Setartikel mit Arbeitsgang und BA mit Zeit-Rueckmeldung, keine Gutmengenbuchung
    Given I open an editor "SET-MIT-AG" from table "(Part):(Product)" with command "STORE" for record "SET2-MIT-AG"
    And I set fields
      | such     | SET2-MIT-AG2      |
      | namebspr | Set2 mit AG2      |
      | bsart    | Eigenfertigung    |
      | earta    | ueber Stueckliste |
    And I delete all rows
    And I append rows
      | elex  | elanzahl    |
      | E2    | 1           |
      | E3    | 1           |
      | A AG1 | !dontChange |
    And I save the current editor

    Given I open an editor "SET-MIT-AG" from table "(Part):(Product)" with command "STORE" for record "SET-MIT-AG"
    And I set fields
      | such     | SET-MIT-AG        |
      | namebspr | Set mit AG        |
      | bsart    | Eigenfertigung    |
      | earta    | ueber Stueckliste |
    And I delete all rows
    And I append rows
      | elex        | elanzahl    |
      | SET2-MIT-AG | 1           |
    And I save the current editor

    Given I create a work order "SETAG" for Product "BG1" with quantity "100" and search word "SETAG"

    Given I open an editor "SETAG_RM1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SETAG001"
    And I set fields
      | sofort | ja |
      | bzeit  | 1  |
      | mzeit  | 1  |
    And I save the current editor

# Setartikel mit Arbeitsgang kann im rueckgemeldeten Bereich einer FL nicht eingefügt werden
# 2056 de      |Setartikel mit Arbeitsgängen sind im rückgemeldeten Bereich nicht erlaubt.
    Given I open an editor "Reserv_SETAG" from table "(Purchasing):(Reservations)" with command "UPDATE" for search criteria "$,,elex=E1;@richtung=rueckwaerts;@maxtreffer=1"
    And I create a new row at position 1
    Then setting field "elex" to "!SET-MIT-AG" in row 1 throws the exception "2056"
    And I close the current editor

# BA stornieren
    Given I open an editor "SETAG" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SETAG000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: 22 Setartikel als Beistellung Lohnfertigung anfuegen in AFL
# FDA-3667

# Halbfabrikat und Lohnfertigung anlegen
    Given I open an editor "HALBFAB22" from table "(Part):(Product)" with command "STORE" for record "HALBFAB22"
    And I set fields
      | such     | HALBFAB22      |
      | namebspr | Halbfabrikat   |
      | bsart    | Eigenfertigung |
      | dispoa   |                |
    And I save the current editor

    Given I open an editor "LOHNFERT" from table "(Part):(Product)" with command "STORE" for record "LOHNFERT"
    And I set fields
      | such     | LOHNFERT      |
      | namebspr | Lohnfertigung |
      | bsart    | Lohnfertigung |
      | lief     | TEST          |
      | efrist   | 2             |
      | epr      | 3             |
    And I delete all rows
    And I append rows
      | elex      | elanzahl | kompeig      | bua                    |
      | HALBFAB22 | 1        | Halbfabrikat | Lieferantenbeistellung |
    And I save the current editor

# Baugruppe mit Lohnfertigung und Setartikel als Beistellung anlegen
    Given I open an editor "BG_LOHNF_SET" from table "(Part):(Product)" with command "STORE" for record "BG_LOHNF_SET"
    And I set fields
      | such     | BG_LOHNF_SET                    |
      | namebspr | BG Lohnfertigung und Setartikel |
      | dispoa   | bedarfsbezogen                  |
      | bsart    | Eigenfertigung                  |
      | wgruppe  | 55                              |
      | erlgrp   | 66                              |
    And I delete all rows
    And I append rows
      | elex           | anzahl | lfbeist |
      | EINKAUF-3      | 1      |         |
      | A VORBEREITUNG | 1      |         |
      | SET-ARTIKEL    | 1      | ja      |
      | LOHNFERT       | 1      |         |
      | A MONTAGE1     | 1      |         |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | mge | bisuch    | mfreig |
      | BG_LOHNF_SET | 10  | LOHNFSET_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor

    And I run Scheduling

# in AFL absteigen und zwischenspeichern oder weiter absteigen in die Stufe der Lohnfertigung ist trotz Setartikel erlaubt
    Given I open an editor "BA_AFL" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=LOHNFSET_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL"
    And I press button "schreib"
    And I close the current editor
    And I switch the current editor to editor "BA_AFL"
    And I close the current editor

    Given I open an editor "BA_AFL" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=LOHNFSET_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "elex" has value "LOHNFERT" in row 4
    And I press button "absteig" to open a subeditor for "AFL_LF" in row 4
#Then field "elex" has value "HALBFAB21" in row 1
#And I close the current subeditor to switch back to the parent editor
#And I close the current editor
    And I close the current editor
    And I switch the current editor to editor "AFL"
    And I close the current editor
    And I switch the current editor to editor "BA_AFL"
    And I close the current editor

# in AFL absteigen und Menge Setartikel aendern ist erlaubt und muss nicht aufgeloest werden
    Given I open an editor "BA_AFL" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=LOHNFSET_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL"
# Setartikel muss nicht aufgeloest werden, Dialog 1537 erscheint NICHT
    Then field "elex" has value "SET-ARTIKEL" in row 3
    And I set field "elanzahl" to "2" in row 3
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

# Betriebsauftrag loeschen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "LOHNFSET_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 23 Verwendung in einer Verkaufsposition mit Setartikel, der einen Arbeitsgang hat, nach dem Speichern nochmal aendern

# Setartikel mit Arbeitsgang anlegen
    Given I open an editor "SET-ARTIKEL" from table "(Part):(Product)" with command "COPY" for record "SET-ARTIKEL"
    And I set fields
      | such   | SETARTIKEL-AG   |
      | dispoa | auftragsbezogen |
    And I append rows
      | elex       | elanzahl |
      | A MONTAGE1 | 1        |
    And I save the current editor

    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
      | such  | AUF23   |
    And I delete all rows
    And I append rows
      | artikel       | mge | verw  |
      | SETARTIKEL-AG | 10  | test1 |
    And I save the current editor

    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF23"
    And I modify table
      | !row | verw |
      | 1    | neu1 |
    And I save the current editor

    Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF23"
    And I modify table
      | !row | verw |
      | 1    | neu2 |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then table has values
      | elex       | elanzahl | verw |
      | EINKAUF-1  | 1        | neu2 |
      | EINKAUF-2  | 1        | neu2 |
      | A MONTAGE1 | 1        | neu2 |
    And I save the current editor
    And I switch the current editor to editor "Auftrag"
    And I save the current editor


  Scenario: 24 Beim Eintrag eines Sets in eine AFL wird die STL des Sets aufgelöst und die Fertigungslistenbasis wird beruecksichtigt

# Setartikel mit Fertigungslistenbasis 8 und Anzahl der Komponenten 6 anlegen
    Given I open an editor "SET_FLBASIS" from table "(Part):(Product)" with command "COPY" for record "SET-ARTIKEL"
    And I set fields
      | such    | SET_FLBASIS   |
      | flbasis | 8             |
    And I delete all rows
    And I append rows
      | elex        | elanzahl  |
      | EINKAUF-1   | 6         |
      | EINKAUF-2   | 8         |
    And I save the current editor

# Fertigungsvorschlag fuer Baugruppe anlegen, den Setartikel eintragen mit Anzahl 2 und aufloesen
    Given I open an editor "FV_24" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | mge |
      | BG1     | 1   |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I create a new row at position 1
    And I set field "elex" to "SET_FLBASIS" in row 1
#    1537 de   |Es wurde ein Setartikel eingetragen, soll dieser aufgelöst werden?
    And I respond with answer "ja" to the dialog with id "1537"
    And I set field "elanzahl" to "2" in row 1
    Then table has values
      | elex        | elanzahl  |
      | EINKAUF-1   | 1.5       |
      | EINKAUF-2   | 2         |
    And I save the current editor
    And I switch the current editor to editor "FV_24"
    And I save the current editor



  Scenario: 25 Setartikel in Stückliste einer Dienstleistung nutzen

# Dienstleistung mit Setartikel anlegen
    Given I open an editor "DL_MIT_SET" from table "(Part):(Service)" with command "NEW" for record ""
    And I set fields
      | such     | DL_MIT_SET                    |
      | namebspr | Dienstleistung mit Setartikel |
    And I append rows
      | elex           | anzahl |
      | EINKAUF-3      |   1    |
      | A VORBEREITUNG |   1    |
      | SET-ARTIKEL    |  10    |
    And I save the current editor

# Fertigungsvorschlag fuer Dienstleistung anlegen, in der AFL ist dann der Setartikel aufgeloest
    Given I open an editor "FV_DL" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge |
      | DL_MIT_SET  | 2   |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then table has values
      | elex           | elanzahl  |
      | EINKAUF-3      |   1       |
      | A VORBEREITUNG |   1       |
      | EINKAUF-1      |   10      |
      | EINKAUF-2      |   10      |
    And I save the current editor
    And I switch the current editor to editor "FV_DL"
    And I save the current editor
