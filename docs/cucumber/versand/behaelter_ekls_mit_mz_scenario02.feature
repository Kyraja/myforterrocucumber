# *****************************************************************************
#  Name             : behaelter_ekls_mit_mz_scenario02.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Artikel von Behaelter in anderen Behaelter umlagern
#                     ueber Einkaufslieferschein
#
# *****************************************************************************
@persistent
Feature: behaelter_ekls_mit_mz_scenario02.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelter erstellen
And I create a Container "BEH_UMLAGERN" for packaging material "KLT"
And I create a Container "BEH_UMLAGERN_A" for packaging material "KLT"
And I create a Container "BEH_UMLAGERN_B" for packaging material "KLT"
And I create a Container "BEH_UMLAGERN_C" for packaging material "KLT"


Scenario: 02 Artikel PEDALE-01 kopieren und anpassen
Given I open an editor "PEDALE-01" from table "(Part):(Product)" with command "COPY" for record "PEDALE"
And I set field "such" to "PEDALE-01"
And I press button "alge" to open a subeditor for "Lgruppen" in row 0
And I append rows
    | lgruppe  | bsart            | dispoa          |
    | HONGKONG | Fremdbeschaffung | auftragsbezogen |
And I save the current subeditor to switch back to the parent editor
And I set field "bsart" to "Umlagern"
And I set field "umllg" to "HONGKONG"
And I save the current editor


Scenario: 03 Auftrag anlegen
Given I open an editor "auftrag02" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I append rows
    | artikel   | mge | verw     |
    | PEDALE-01 | 30  | Verw_M02 |
And I save the current editor


Scenario: 04 Zugangsbuchungen in Behaelter
Given I open an editor "Lbuch02" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | PEDALE-01 |
    | buart   | Zugang    |
    | beleg   | Zu02_1    |
    | beldat  | .         |
And I append rows
    | mge | platz2 | behaelter        | verw     |
    | 30  | L2F1   | !BEH_UMLAGERN^id | Verw_M02 |
And I save the current editor

And I run Scheduling

Given I open an editor "Umlagerungsvorschlag" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "PEDALE-01"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row !lastRow
And I press button "freig" to open a subeditor for "Bestellung02"
And I set field "lief" to "KETTLER"
And I save the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: 05 Umlagerung mit Behaelter ueber Einkaufslieferschein
Given I open an editor "EKLS02" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung02"
And I set fields
    | ebeleg  | EKLS_UM02        |
    | vom     | .                |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | behaelterzu      | behaelter          | verw       |
    | F1     | 10     | !BEH_UMLAGERN^id | !BEH_UMLAGERN_A^id | Verw_M02_A |
    | F1     | 10     | !BEH_UMLAGERN^id | !BEH_UMLAGERN_B^id | Verw_M02_B |
    | F1     | 10     | !BEH_UMLAGERN^id | !BEH_UMLAGERN_C^id | Verw_M02_C |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# TODO: Trennung von Buchen und Speichern wieder aufheben. In der GUI funktioniert es korrekt, im epi kommt ein Fehler
Given I open an editor "EKLSO2buchen" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "EKLS02"
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 06 Lagerjournal pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "EKLS02"
And I press start
Then table has values
    | mei  | art       | zmge | amge | nplatz | vplatz |
    | Paar | PEDALE-01 |      | 10   |        | L2F1   |
    | Paar | PEDALE-01 |      | 10   |        | L2F1   |
    | Paar | PEDALE-01 |      | 10   |        | L2F1   |
    | Stück | KLT     |  1   |      | L2F1   |        |
    | Paar | PEDALE-01 | 10   |      | F1     |        |
    | Stück | KLT     |      |   1  |        | L2F1   |
    | Paar | PEDALE-01 | 10   |      | F1     |        |
    | Stück | KLT     |      |   1  |        | L2F1   |
    | Paar | PEDALE-01 | 10   |      | F1     |        |
    | Stück | KLT     |      |   1  |        | L2F1   |
And I close the current editor


Scenario Outline: 07 Behaelter pruefen
And I switch the current editor to editor "<behaelter_editor>"
Then field "platz" has value "<platz>"
Then field "artikel" has value "<artikel>" in row 1
Then field "mge" has value "<mge>" in row 1
Then field "verw" has value "<verw>" in row 1
And I close the current editor

Then Container "BEH_UMLAGERN" is empty

Examples:
| behaelter_editor | platz | artikel   | mge | verw       |
| BEH_UMLAGERN_A   | F1    | PEDALE-01 | 20  | Verw_M02_A |
| BEH_UMLAGERN_B   | F1    | PEDALE-01 | 20  | Verw_M02_B |
| BEH_UMLAGERN_C   | F1    | PEDALE-01 | 20  | Verw_M02_C |

