@persistent
Feature: stammdaten_funktionen.feature

# *****************************************************************************
#  Name             : stammdaten_funktionen
#  Autor            : lschneider
#  Verantwortlich   : bheim
#  Kontrolle        : drpf
#  Funktion         : Testet Funktionen in den Stammdaten
#  ref              : ref_stammdaten_funktionen_cu
# *****************************************************************************

  Background:
    And I set the fake date to "02.01.1995"

#  Jira-Issue       : FDA-3679
  Scenario: 1 In der Fertigungsliste im Artikel und der AFL bekommt jede Zeile eine Zeilen-ID
    Given I open an editor "BG-LZID" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such  | BG-LZID        |
      | bsart | Eigenfertigung |
    And I append rows
      | elex       | elanzahl    |
      | EK1-BEDARF | 1           |
      | A AG1      | !dontChange |
      | A AG2      | !dontChange |
    And I save the current editor
    And I switch the current editor to editor "BG-LZID" with command "UPDATE"
    Then field "lzid" has value "3"
    Then table has values
      | tzid | !row |
      | 1    | 1    |
      | 2    | 2    |
      | 3    | 3    |
    And I modify table
      | !row | elex       | elanzahl |
      | +1   | SETARTIKEL | 1        |
    And I save the current editor
    Then field "lzid" has value "4"
    Then table has values
      | tzid | !row |
      | 4    | 1    |
      | 1    | 2    |
      | 2    | 3    |
      | 3    | 4    |

    And I switch the current editor to editor "BG-LZID" with command "UPDATE"
    And I modify table
      | elex        | elanzahl    | lfbeist     | !row |
      | EK3-BEDARF  | 1           | !dontChange | +1   |
      | EK-BEISTELL | 1           | ja          | +6   |
      | LOHNFERT    | 1           | !dontChange | +7   |
      | EK-AUSLAUF  | 1           | !dontChange | +8   |
      | A AG3       | !dontChange | !dontChange | +9   |
    And I save the current editor
    Then field "lzid" has value "9"

    Given I create a work order "LZID" for Product "BG-LZID" with quantity "10" and search word "LZID"
    And I run Scheduling

# flzid der Lohnfertigung pruefen, Halbfabrikat lfzid=1 und Beisetllteil lfzid=6
    Given I open an editor "Reserv_BG" from table "(Purchasing):(Reservations)" with command "VIEW" for search criteria "$,,elex=EK3-BEDARF;@richtung=rueckwaerts;@maxtreffer=1"
    Then field "artikel" has value "BG-LZID"
    Then the table has 11 rows
    Then table has values
      | !row | flzid |
      | 1    | 5     |
      | 2    | 4     |
      | 3    | 4     |
      | 4    | 4     |
      | 5    | 1     |
      | 6    | 2     |
      | 7    | 3     |
      | 8    | 6     |
      | 9    | 7     |
      | 10   | 8     |
      | 11   | 9     |
    And I descend to a lower level of the BOM in row 9
    Then table has values
      | flzid | !row |
      | 1     | 1    |
      | 6     | 2    |
    And I ascend to a higher level of the BOM
    And I close the current editor

# Nachfolgeartikel und Auslaufteils haben die gleich flzid
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge |
      | BG-LZID | 10     |
    And I save the current editor

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-LZID"
    And I press button "ladetab"
    And I press button "absteig" to open a subeditor for "AFL" in row 2
    Then the table has 12 rows
    Then table has values
      | flzid | !row |
      | 8     | 10   |
      | 8     | 11   |
    And I close the current subeditor to switch back to the parent editor
    And I set field "netmge" to "0" in row 2
    And I save the current editor

# Betriebsauftrag loeschen
    Given I open an editor "BA_LZID" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=LZID000;@richtung=rueckwaerts;@maxtreffer=1"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 2 Wird ein Artikel mit Komponenteneigenschaft in einen Set-Artikel geändert, wird die Komponenteneigenschaft gelöscht
    Given I open an editor "BG-KOMEIG" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such  | BG-KOMPEIG     |
      | bsart | Eigenfertigung |
    And I append rows
      | elex       | elanzahl | kompeig |
      | EK1-BEDARF | 1        | Koppel  |
    And I set field "elex" to "SETARTIKEL" in row 1
    Then table has values
      | elex       | elanzahl | kompeig |
      | SETARTIKEL | 1        |         |
    And I save the current editor


#  Jira-Issue       : FDA-4718
 Scenario: 3 Kennzeichen Arbeitsschein nicht mehr entfernen, wenn im AG te geleert wird
    Given I open an editor "AG-LOETEN" from table "(Operation):(Operation)" with command "NEW" for record ""
    And I set fields
      | such    | AG-LOETEN |
      | aschein | ja        |
      | mgr     | 111       |
      | tr      | 2.5       |
      | te      | 1.5       |
    And I save the current editor

    Given I open an editor "AG-TE-TEST" from table "(Operation):(Operation)" with command "UPDATE" for record "AG-LOETEN"
    And I set field "te" to "0"
    Then field "aschein" has value "ja"
    And I save the current editor


  Scenario: 4 Artikel Lagergruppeneigenschaften anlegen, eine löschen. Die gelöschte wird nicht mehr angezeigt
    Given I open an editor "ALGELOESCHEN" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such  | ALGELOESCHEN     |
      | bsart | Fremdbeschaffung  |
    And I save the current editor

    And I switch the current editor to editor "ALGELOESCHEN" with command "UPDATE"
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I delete all rows
    And I append rows
      | lgruppe   | bsart            |
      | BERLIN    | Fremdbeschaffung |
      | HONGKONG  | Fremdbeschaffung |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    And I switch the current editor to editor "ALGELOESCHEN" with command "UPDATE"
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I delete row at position 2
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    And I switch the current editor to editor "ALGELOESCHEN" with command "UPDATE"
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    Then the table has 1 rows
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor
    And I close the current editor

    Given I open an editor "ABLAGE-ALGE" from table "(Warehouse):(WarehouseGroupProperty)" with command "VIEW" for record "$,,art==ALGELOESCHEN;lgruppe=BERLIN;@ablageart=abgelegt"
    Then field "ablagef" has value "ja"
    And I close the current editor

    Given I open an editor "ALGE" from table "(Warehouse):(WarehouseGroupProperties)" with command "VIEW" for record ""
    And I set field "art" to "ALGELOESCHEN"
    Then the table has 1 rows
    And I close the current editor

  Scenario: 5 Artikel mit bsart Umlagern und Lagergruppeneigenschaften anlegen und kopieren
    Given I open an editor "ALGE-UML-B" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such     | ALGE-UML-B                        |
      | namebspr | Artikel Umlagern aus Berlin       |
      | bsart    | Umlagern                          |
      | umllg    | BERLIN                            |
    Then saving the current editor throws the exception "4284"
    And I set fields
      | bsart    | Fremdbeschaffung                  |
    And I save the current editor

    And I switch the current editor to editor "ALGE-UML-B" with command "UPDATE"
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I delete all rows
    And I append rows
      | lgruppe | bsart            |
      | BERLIN  | Fremdbeschaffung |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    Given I open an editor "ALGE-UML-B" from table "(Part):(Product)" with command "UPDATE" for record "ALGE-UML-B"
    And I set fields
      | bsart    | Umlagern                          |
      | umllg    | BERLIN                            |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    Given I open an editor "ALGE-UML-B" from table "(Part):(Product)" with command "COPY" for record "ALGE-UML-B"
    And I set fields
      | such     | ALGE-UML-B-KOPIE |
      | namebspr | Kopie Umlagern Berlin |
