# *****************************************************************************
#  Name             : behaelter_ekls_mit_mz_scenario05.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Behaelter anlegen und fuellen ueber Einkaufslieferschein
#                     Artikel mit Charge
#
# *****************************************************************************
@persistent
Feature: behaelter_ekls_mit_mz_scenario05.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Chargen anlegen
And I create a Lot "CH_1M05" for Product "SATTEL"
And I create a Lot "CH_2M05" for Product "SATTEL"
And I create a Lot "CH_3M05" for Product "SATTEL"
And I create a Lot "CH_4M05" for Product "SATTEL"
And I create a Lot "CH_5M05" for Product "SATTEL"
And I create a Lot "CH_6M05" for Product "SATTEL"
And I create a Lot "CH_7M05" for Product "SATTEL"
And I create a Lot "CH_8M05" for Product "SATTEL"
And I create a Lot "CH_9M05" for Product "SATTEL"


Scenario: 02 Behaelter anlegen
And I create a Container "M05A" for packaging material "KLT"
And I create a Container "M05B" for packaging material "KLT"
And I create a Container "M05C" for packaging material "KLT"


Scenario: 03 Einkaufslieferschein mehrere Artikel in Behaelter mit Charge
Given I open an editor "EKLS05" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | ebeleg | EKLS_M05 |
    | vom    | .        |
And I append rows
    | artikel | mge |
    | SATTEL  | 5   |
    | SATTEL  | 5   |
    | SATTEL  | 5   |

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | verw  | charge  | !dialogId                                     | !dialogAnswer | exbehnum     |
    | F1     | 2      | M05AP | CH_1M05 | Externe Behälternummer ist bereits vergeben. | nein          | !M05A^nummer |
    | F2     | 2      | M05BP | CH_2M05 | Externe Behälternummer ist bereits vergeben. | nein          | !M05B^nummer |
    | F3     | 1      | M05CP | CH_3M05 | Externe Behälternummer ist bereits vergeben. | nein          | !M05C^nummer |
And I save the current subeditor to switch back to the parent editor

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I delete all rows
And I append rows
    | lpsuch | zuomge | verw  | charge  | !dialogId                                     | !dialogAnswer | exbehnum     |
    | F1     | 2      | M05AR | CH_4M05 | Externe Behälternummer ist bereits vergeben. | nein          | !M05A^nummer |
    | F2     | 2      | M05BR | CH_5M05 | Externe Behälternummer ist bereits vergeben. | nein          | !M05B^nummer |
    | F3     | 1      | M05CR | CH_6M05 | Externe Behälternummer ist bereits vergeben. | nein          | !M05C^nummer |
And I save the current subeditor to switch back to the parent editor

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I delete all rows
And I append rows
    | lpsuch | zuomge | verw  | charge  | !dialogId                                     | !dialogAnswer | exbehnum     |
    | F1     | 2      | M05AS | CH_7M05 | Externe Behälternummer ist bereits vergeben. | nein          | !M05A^nummer |
    | F2     | 2      | M05BS | CH_8M05 | Externe Behälternummer ist bereits vergeben. | nein          | !M05B^nummer |
    | F3     | 1      | M05CS | CH_9M05 | Externe Behälternummer ist bereits vergeben. | nein          | !M05C^nummer |
And I save the current subeditor to switch back to the parent editor

And I set field "ueb" to "ja"
And I save the current editor


Scenario: 04 Lagerjournal pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "EKLS05"
And I press start
Then table has values
    | art    | zmge | verw  | ncharge^id  |
    | SATTEL | 2    | M05AP | !CH_1M05^id |
    | SATTEL | 2    | M05BP | !CH_2M05^id |
    | SATTEL | 1    | M05CP | !CH_3M05^id |
    | SATTEL | 2    | M05AR | !CH_4M05^id |
    | SATTEL | 2    | M05BR | !CH_5M05^id |
    | SATTEL | 1    | M05CR | !CH_6M05^id |
    | SATTEL | 2    | M05AS | !CH_7M05^id |
    | SATTEL | 2    | M05BS | !CH_8M05^id |
    | SATTEL | 1    | M05CS | !CH_9M05^id |
And I close the current editor


Scenario Outline: 05 Behaelter pruefen
And I open an editor "behaelter" from table "(Container):(ContainerShell)" with command "VIEW" for record "<behaelter>"
Then field "platz" has value "<platz>"
Then field "artikel" has value "SATTEL" in row <row>
Then field "mge" has value "<mge>" in row <row>
Then field "verw" has value "<verw>" in row <row>
Then field "charge^such" has value "<charge>" in row <row>
And I close the current editor

Examples:
| behaelter | platz | row | mge | verw  | charge  |
| M05A      | F1    |  1  | 2   | M05AP | CH_1M05 |
| M05A      | F1    |  2  | 2   | M05AR | CH_4M05 |
| M05A      | F1    |  3  | 2   | M05AS | CH_7M05 |
| M05B      | F2    |  1  | 2   | M05BP | CH_2M05 |
| M05B      | F2    |  2  | 2   | M05BR | CH_5M05 |
| M05B      | F2    |  3  | 2   | M05BS | CH_8M05 |
| M05C      | F3    |  1  | 1   | M05CP | CH_3M05 |
| M05C      | F3    |  2  | 1   | M05CR | CH_6M05 |
| M05C      | F3    |  3  | 1   | M05CS | CH_9M05 |

