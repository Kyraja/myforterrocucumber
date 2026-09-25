# *****************************************************************************
#  Name             : behaelter_ekls_mit_mz_scenario03.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Beistellung in Behaeltern buchen ueber Einkaufslieferschein
#
# *****************************************************************************
@persistent
Feature: behaelter_ekls_mit_mz_scenario03.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario Outline: 01 Beistellung in Behaeltern - Stammdaten anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "dispoa" to "auftragsbezogen"
And I set field "abplatz" to "F2"
And I set field "lief" to "KETTLER"
And I set field "efrist" to "<efrist>"
And I set field "vorlauf" to "<vorlauf>"
And I set field "bstnr" to "<bstnr>"
And I set field "epr" to "<epr>"
And I set field "chimlager" to "<chimlager>"
And I set field "packanwstdla" to "<packanwstdla>"
And I set field "fmengestdla" to "<fmengestdla>"
And I create a new row at the end of the table
And I set field "elex" to "<elex>" in row 1
And I set field "bua" to "<bua>" in row 1
And I set field "anzahl" to "<anzahl>" in row 1
And I save the current editor

Examples: Artikel
| such           | namebspr                        | chimlager | efrist | vorlauf | bstnr | epr | packanwstdla | fmengestdla | elex           | bua                    | anzahl |
| PROD_BEIST_M03 | Beistell-Teil                   |           | 6      | 6       | tnr.3 | 80  |              |             |                |                        |        |
| PROD_LIEF_M03  | Artikel Lief-Beist in Behälter | ja        | 3      | 3       | tnr.2 | 32  | PACKA2       | 10          | PROD_BEIST_M03 | Lieferantenbeistellung | 2      |


Scenario: 02 Auftrag anlegen
Given I open an editor "Auftrag04" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I create a new row at the end of the table
And I set field "artikel" to "PROD_LIEF_M03" in row 1
And I set field "mge" to "160" in row 1
And I set field "verw" to "AUFTRAG_M03" in row 1
And I save the current editor


Scenario: 03 Behaelter erzeugen
And I create a Container "BEH_BEISTELLUNG_1" for packaging material "KLT"
And I create a Container "BEH_BEISTELLUNG_2" for packaging material "KLT"


Scenario: 03 Behaelter mit Beistellung befuellen
Given I open an editor "Lagerbuchung03" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | PROD_BEIST_M03 |
    | buart   | Zugang         |
    | beleg   | LZU_03         |
    | beldat  | .              |
And I append rows
    | mge | platz2 | behaelter             | verw        |
    | 320 | F1     | !BEH_BEISTELLUNG_1^id | AUFTRAG_M03 |
And I save the current editor


Scenario: 04 Dispo starten
And I run Scheduling


Scenario: 05 Bestellung anlegen mit Beistellung
Given I open an editor "Bestellung03" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | KETTLER |
And I append rows
    | artikel       | mge | verw        |
    | PROD_LIEF_M03 | 160 | AUFTRAG_M03 |
And I press button "mzabsm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | behaelter             |
    | F1     | 320    | !BEH_BEISTELLUNG_1^id |
And I save the current subeditor to switch back to the parent editor
And I save the current editor


Scenario: 06 Lieferschein anlegen
Given I open an editor "Lieferschein03" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung03"
And I set fields
    | ebeleg | LS_M03 |
    | vom    | .      |
And I modify table
    | !row | mge | verw        |
    | 1    | 160 | AUFTRAG_M03 |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | !dialogId                                     | !dialogAnswer | exbehnum                  | verw        |
    | F1     | 160    | Externe Behälternummer ist bereits vergeben. | nein          | !BEH_BEISTELLUNG_2^nummer | AUFTRAG_M03 |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 07 Behaelter pruefen
Then Container from editor "BEH_BEISTELLUNG_1" is empty

And I switch the current editor to editor "BEH_BEISTELLUNG_2"
Then table has values
    | artikel       | mge | verw        |
    | PROD_LIEF_M03 | 160 | AUFTRAG_M03 |
And I close the current editor

