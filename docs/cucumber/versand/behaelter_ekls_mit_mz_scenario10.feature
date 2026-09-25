# *****************************************************************************
#  Name             : behaelter_ekls_mit_mz_scenario10.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Artikel im Behaelter umlagern ueber Einkaufslieferschein umplatz
#
# *****************************************************************************
@persistent
Feature: behaelter_ekls_mit_mz_scenario10.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Bestaende auf 0 setzen und Behaelter anlegen
# Bestandskorrektur auf 0
Given I set StorageQuantity to zero for Product "SATTEL" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "SATTEL" on StorageLocation "F2"
Given I set StorageQuantity to zero for Product "SATTEL" on StorageLocation "L2F1"

# Behaelter anlegen
Given I create a Container "LS_UMPLATZ" for packaging material "KLT"


Scenario: 02 Behaelter befuellen
Given I open an editor "Lagerbuchung10" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SATTEL |
    | buart   | Zugang |
    | beleg   | LZU10  |
    | beldat  | .      |
And I append rows
    | mge | behaelter      |
    | 5   | !LS_UMPLATZ^id |
And I save the current editor


Scenario: 03 Lieferschein anlegen und buchen
Given I open an editor "EKLS10" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief    | KETTLER |
    | vom     | .       |
    | ebeleg  | EKLS10  |
    | umplatz | F1      |
And I append rows
    | artikel | mge | platz |
    | SATTEL  | 5   | L2F1  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row | lpsuch | behaelter      |
    | 1    | L2F1   | !LS_UMPLATZ^id |
Then table has values
    | umplatz | behaelterzu^id |
    | F1      | !LS_UMPLATZ^id |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 04 Behaelter pruefen
And I switch the current editor to editor "LS_UMPLATZ"
Then field "platz" has value "L2F1"
Then the table has 1 rows
And I close the current editor


Scenario: 05 Bestand pruefen
Given I open the infosystem "BESTAND"
And I set fields
    | artikel   | SATTEL |
    | klgruppe  |        |
    | klplatz   | L2F1   |
    | behaelter | ja     |
And I press start
Then table has values
    | gebmge | tbehaelter^id  |
    | 5      | !LS_UMPLATZ^id |
And I close the current editor

