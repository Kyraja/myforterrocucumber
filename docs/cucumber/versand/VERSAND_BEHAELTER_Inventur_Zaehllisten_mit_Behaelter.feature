        @persistent
Feature: VERSAND_BEHAELTER_Inventur_Zaehllisten_mit_Behaelter.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Inventur_Zaehllisten_mit_Behaelter.feature
#  Autor            : lschneider/bschiga
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Inventur mit Behaeltern
#  ref              : ref_behaelter_inventur_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"

@testvorbereitung
Scenario Outline: Behaelter anlegen

Given I create a Container "<such>" for packaging material "KLT"

Examples:
    | such                    |
    | ACHARGE_AUFTRAG1        |
    | ACHARGE_CHARGE_PROJEKT1 |
    | ACHARGE_CHARGE1         |
    | ACHARGE_PROJEKT1        |
    | AEINH_EKTEIL_ERWBED1    |
    | AEINH_LOHNF_PROJEKT1    |
    | AEINHEIT_CHARGE1        |
    | AEINHEIT_MINDESTB1      |
    | AEINHEIT_PROJEKT1       |
    | AEINHEIT1               |
    | AEINHEIT2               |
    | AUFTRAG1                |
    | AUFTRAG2                |
    | AUFTRAG3                |
    | BAUGR_ERWBEDARF1        |
    | BAUGRUPPE1              |
    | BAUGRUPPE2              |
    | EINHEIT1                |
    | EINHEIT2                |
    | EKTEIL_EINHEIT1         |
    | EKTEIL1                 |
    | ERWBEDARF1              |
    | LOHNFERT1               |
    | LOHNFERT2               |
    | MINDESTB1               |
    | PROJEKT1                |
    | PROJEKT2                |
    | EINKAUFTEIL             |
    | MIXBEHAELTER1           |
    | MIXBEHAELTER2           |


@testvorbereitung
Scenario: Bestaende anlegen

# Bestaende LOHNFERT mit Fertigteil VERSAND und BAUGRUPPE
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | LOHNFERT_3001 |
    | buart   | Zugang        |
    | beleg   | TEST_3001     |
    | beldat  | .             |
And I append rows
    | mge | platz2  | lffert         | projekt     | behaelter                |
    |  9  | LP_INV7 | VERKAUF_3001   |             |                          |
    |  7  | LP_INV7 | VERKAUF_3001   | T3ESTP_3001 | !LOHNFERT1^id            |
    |  5  | LP_INV7 | BAUGRUPPE_3001 | T2ESTP_3001 | !AEINH_LOHNF_PROJEKT1^id |
    |  9  | LP_INV7 | VERKAUF_3001   | T2ESTP_3001 | !LOHNFERT2^id            |
    |  3  | LP_INV7 | BAUGRUPPE_3001 |             | !LOHNFERT1^id            |
And I save the current editor

# Bestaende EKTEIL
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | EKTEIL_3001 |
    | buart   | Zugang      |
    | beleg   | TEST_3001   |
    | beldat  | .           |
And I append rows
    | mge | platz2  | behaelter                |
    |  10 | LP_INV7 | !AEINH_EKTEIL_ERWBED1^id |
    |  20 | LP_INV7 | !EKTEIL1^id              |
    |  15 | LP_INV8 |                          |
And I save the current editor

# Bestaende EINKAUFTEIL
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | EINKAUF_3001 |
    | buart   | Zugang       |
    | beleg   | TEST_EK3001  |
    | beldat  | .            |
And I append rows
    | mge | platz2  | behaelter       |
    |  10 | LP_INV7 | !EINKAUFTEIL^id |
    |  20 | LP_INV7 |                 |
    |  15 | LP_INV8 |                 |
And I save the current editor

# Bestaende BAUGRUPPE
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | BAUGRUPPE_3001 |
    | buart   | Zugang         |
    | beleg   | TEST_3001      |
    | beldat  | .              |
And I append rows
    | mge | platz2  | projekt     | behaelter            |
    |  9  | LP_INV7 |             | !BAUGRUPPE1^id       |
    |  15 | LP_INV7 | TESTP_3001  | !BAUGRUPPE2^id       |
    |  10 | LP_INV8 | T2ESTP_3001 | !BAUGR_ERWBEDARF1^id |
And I save the current editor

# Bestaende ERWBEDARF
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | ERWBEDARF_3001 |
    | buart   | Zugang         |
    | beleg   | TEST_3001      |
    | beldat  | .              |
And I append rows
    | mge | platz2  | verw            | projekt     | behaelter                |
    |  12 | LP_INV7 | Sicherheit_3001 |             | !AEINH_EKTEIL_ERWBED1^id |
    |  12 | LP_INV7 | Sicherheit_3001 | T3ESTP_3001 | !ERWBEDARF1^id           |
    |   2 | LP_INV8 | Sicherheit_3001 | T3ESTP_3001 | !BAUGR_ERWBEDARF1^id     |
    |  10 | LP_INV7 | VW1_3001        | T2ESTP_3001 | !AEINH_EKTEIL_ERWBED1^id |
And I save the current editor

# Bestaende AUFTRAG
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | AUFTRAG_3001 |
    | buart   | Zugang       |
    | beleg   | TEST_3001    |
    | beldat  | .            |
And I append rows
    | mge | platz2  | verw         | projekt     | behaelter            |
    |  25 | LP_INV7 | 12345_3001   |             | !ACHARGE_AUFTRAG1^id |
    |  15 | LP_INV7 | 6789_25_3001 |             | !AUFTRAG1^id         |
    |  15 | LP_INV7 | 123_3001     |             | !AUFTRAG1^id         |
    |  15 | L2F1    | 12345_3001   | T2ESTP_3001 | !AUFTRAG2^id         |
    |   7 | L2F2    |              | T2ESTP_3001 | !AUFTRAG3^id         |
    |   3 | L3F1    | 12345_3001   |             |                      |
And I save the current editor

# Bestaende PROJEKT
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | PROJEKT_3001 |
    | buart   | Zugang       |
    | beleg   | TEST_3001    |
    | beldat  | .            |
And I append rows
    | mge | platz2  | projekt     | behaelter                   |
    |   9 | LP_INV7 | TESTP_3001  | !AEINH_LOHNF_PROJEKT1^id    |
    |  15 | LP_INV7 | TESTP_3001  | !PROJEKT2^id                |
    |   9 | LP_INV7 | TESTP_3001  | !ACHARGE_PROJEKT1^id        |
    |   9 | LP_INV7 | TESTP_3001  |                             |
    |  15 | LP_INV7 | T2ESTP_3001 |                             |
    |  12 | LP_INV7 | T3ESTP_3001 | !AEINHEIT_PROJEKT1^id       |
    |   9 | LP_INV8 | TESTP_3001  | !ACHARGE_CHARGE_PROJEKT1^id |
And I save the current editor

# Bestaende CHARGE
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | CHARGE_3001 |
    | buart   | Zugang      |
    | beleg   | TEST_3001   |
    | beldat  | .           |
And I append rows
    | mge | platz2  | charge2  | behaelter                   |
    |  12 | LP_INV7 | CH1_3001 | !ACHARGE_CHARGE1^id         |
    |   5 | LP_INV7 | CH1_3001 | !AEINHEIT_CHARGE1^id        |
    |  25 | LP_INV8 | CH1_3001 | !ACHARGE_CHARGE_PROJEKT1^id |
And I save the current editor

# Bestaende ACHARGE
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | ACHARGE_3001 |
    | buart   | Zugang       |
    | beleg   | TEST_3001    |
    | beldat  | .            |
And I append rows
    | mge | platz2  | verw     | charge2   | behaelter                   |
    |   2 | LP_INV7 | VW1_3001 | CHA1_3001 | !ACHARGE_PROJEKT1^id        |
    |   5 | LP_INV8 | VW2_3001 | CHA1_3001 | !ACHARGE_CHARGE_PROJEKT1^id |
    |   5 | LP_INV7 | VW1_3001 | CHA2_3001 | !ACHARGE_CHARGE1^id         |
    |   5 | LP_INV7 | VW2_3001 | CHA2_3001 | !ACHARGE_AUFTRAG1^id        |
    |   5 | LP_INV7 | VW1_3001 | CHA2_3001 |                             |
And I save the current editor

# Bestaende MINDESTB
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | MINDESTB_3001 |
    | buart   | Zugang        |
    | beleg   | TEST_3001     |
    | beldat  | .             |
And I append rows
    | mge | platz2  | behaelter              |
    |  70 | LP_INV7 | !AEINHEIT_MINDESTB1^id |
    |  20 | LP_INV7 | !MINDESTB1^id          |
And I save the current editor

# Bestaende EINHEIT ze=m, zele=1
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | EINHEIT_3001 |
    | buart   | Zugang       |
    | beleg   | TEST_3001    |
    | beldat  | .            |
And I append rows
    | mge | platz2  | ze     | zele | behaelter           |
    | 10  | LP_INV7 | m      | 1    | !EINHEIT2^id        |
    | 20  | LP_INV7 | m      | 1    | !EINHEIT1^id        |
    |  5  | LP_INV7 | kg     | 1    | !EINHEIT1^id        |
    | 17  | LP_INV7 | Stück | 2    | !EKTEIL_EINHEIT1^id |
And I save the current editor

# Bestaende AEINHEIT ze=Stueck, zele=2, verw
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | AEINHEIT_3001 |
    | buart   | Zugang        |
    | beleg   | TEST_3001     |
    | beldat  | .             |
And I append rows
    | mge | platz2  | verw    | projekt     | ze     | zele | behaelter                |
    |  4  | LP_INV7 | V2_3001 |             | Stück | 2    |                          |
    | 10  | LP_INV7 | V1_3001 |             | m      | 1    | !AEINHEIT2^id            |
    | 20  | LP_INV7 | V1_3001 |             | m      | 1    | !AEINHEIT_PROJEKT1^id    |
    | 15  | LP_INV7 | V2_3001 |             | m      | 1    | !AEINHEIT_CHARGE1^id     |
    | 15  | LP_INV7 |         | TESTP_3001  | m      | 1    | !AEINH_EKTEIL_ERWBED1^id |
    | 15  | LP_INV7 |         | T2ESTP_3001 | m      | 1    | !AEINHEIT_PROJEKT1^id    |
    | 10  | LP_INV7 |         | TESTP_3001  | m      | 1    | !AEINH_LOHNF_PROJEKT1^id |
    |  5  | LP_INV7 | VW_3001 | TESTP_3001  | m      | 1    | !AEINHEIT_MINDESTB1^id   |
    |  5  | LP_INV7 | V1_3001 |             | kg     | 1    | !AEINHEIT1^id            |
And I save the current editor

#########################################################################################################################

Scenario: 02 Auftragsbezogener Artikel, versch Lagerplaetze, Bestandskorrektur in jeder Position und alle Behaelter korrigieren

Given I open an editor "Zaehlliste_AUFTRAG" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "AUFTRAG_ZAEHL_3001"
And I append rows
    | artikel      | platz   |
    | AUFTRAG_3001 | LP_INV7 |
    | AUFTRAG_3001 | L2F1    |
    | AUFTRAG_3001 | L2F2    |
    | AUFTRAG_3001 | L3F1    |
And I save the current editor

Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "AUFTRAG_ZAEHL_3001"
Then table has values
    | gebeinh  | gebf | verw         | projekt     | behaelter^such   |
    | Stück   | 1    | 12345_3001   |             |                  |
    | Stück   | 1    |              | T2ESTP_3001 | AUFTRAG3         |
    | Stück   | 1    | 12345_3001   | T2ESTP_3001 | AUFTRAG2         |
    | Stück   | 1    | 6789_25_3001 |             | AUFTRAG1         |
    | Stück   | 1    | 123_3001     |             | AUFTRAG1         |
    | Stück   | 1    | 12345_3001   |             | ACHARGE_AUFTRAG1 |
And I close the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "AUFTRAG_ZAEHL_3001" and menu choice "Ja"
And I save the current editor

Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "AUFTRAG_ZAEHL_3001"
Then the table has 6 rows
Then table has values
    | platz   | ibest | gebeinh  | verw         | projekt     | behaelter^such   |
    | L3F1    | 3     | Stück   | 12345_3001   |             |                  |
    | L2F2    | 7     | Stück   |              | T2ESTP_3001 | AUFTRAG3         |
    | L2F1    | 15    | Stück   | 12345_3001   | T2ESTP_3001 | AUFTRAG2         |
    | LP_INV7 | 15    | Stück   | 6789_25_3001 |             | AUFTRAG1         |
    | LP_INV7 | 15    | Stück   | 123_3001     |             | AUFTRAG1         |
    | LP_INV7 | 25    | Stück   | 12345_3001   |             | ACHARGE_AUFTRAG1 |
Then I modify table
    | !row | nbest |
    |  1   |  5    |
    |  2   |  10   |
    |  3   |  11   |
    |  4   |  13   |
    |  5   |  7    |
    |  6   |  13   |
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "AUFTRAG_ZAEHL_3001" and menu choice "Ja"
And I save the current editor

# Zaehlliste AUFTRAG Aenderungen schreibgeschuetzt
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "AUFTRAG_ZAEHL_3001"
Then field "nbest" is not modifiable in row 1
Then field "behaelter" is not modifiable in row 1
Then field "nbest" is not modifiable in row 2
Then field "behaelter" is not modifiable in row 2
Then field "nbest" is not modifiable in row 4
Then field "behaelter" is not modifiable in row 4
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .              |
    | kursache   | Inventur       |
    | artikel    | AUFTRAG_3001   |
And I press start
Then table has values
    | kmge | mei    | detursache                       | zmge | amge   | behaelter^such   |
    | 2    | Stück | Bestandskorrektur durch Inventur |      |        |                  |
    | 3    | Stück | Bestandskorrektur durch Inventur |      |        | AUFTRAG3         |
    | -4   | Stück | Bestandskorrektur durch Inventur |      |        | AUFTRAG2         |
    | -2   | Stück | Bestandskorrektur durch Inventur |      |        | AUFTRAG1         |
    | -8   | Stück | Bestandskorrektur durch Inventur |      |        | AUFTRAG1         |
    | -12  | Stück | Bestandskorrektur durch Inventur |      |        | ACHARGE_AUFTRAG1 |
And I close the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | AUFTRAG_3001 |
    | klgruppe   |              |
    | nullmge    | nein         |
    | behaelter  | ja           |
And I press button "bstart"
Then the table has 6 rows
Then table has values
    | !row | gebmge | geinheit  | gebf | verw         | projekt     | tbehaelter^such  |
    | 1    |  13    | Stück    | 1    | 12345_3001   |             | ACHARGE_AUFTRAG1 |
    | 2    |   7    | Stück    | 1    | 123_3001     |             | AUFTRAG1         |
    | 3    |  13    | Stück    | 1    | 6789_25_3001 |             | AUFTRAG1         |
    | 4    |  11    | Stück    | 1    | 12345_3001   | T2ESTP_3001 | AUFTRAG2         |
    | 5    |  10    | Stück    | 1    |              | T2ESTP_3001 | AUFTRAG3         |
    | 6    |   5    | Stück    | 1    | 12345_3001   |             |                  |
And I close the current editor

Scenario Outline: 02 Behaelter pruefen
Given I open an editor "behaelter02" from table "(Container):(ContainerShell)" with command "VIEW" for record "<record>"
Then field "platz" has value "<platz>"
Then the table has <sollrows> rows
Then table has values
    | !row   | artikel   | mge   | gebf   | gebeinh   | verw   |
    | <row>  | <artikel> | <mge> | <gebf> | <gebeinh> | <verw> |
And I close the current editor

Examples: 02 Behaelter pruefen
    | record                  | platz   | sollrows | row | artikel       | mge | gebf | gebeinh  | verw         |
    | AUFTRAG1                | LP_INV7 | 2        | 1   | AUFTRAG_3001  |  7  | 1    | Stück   | 123_3001     |
    | AUFTRAG1                | LP_INV7 | 2        | 2   | AUFTRAG_3001  | 13  | 1    | Stück   | 6789_25_3001 |
    | AUFTRAG2                | L2F1    | 1        | 1   | AUFTRAG_3001  | 11  | 1    | Stück   | 12345_3001   |
    | AUFTRAG3                | L2F2    | 1        | 1   | AUFTRAG_3001  | 10  | 1    | Stück   |              |
    | ACHARGE_AUFTRAG1        | LP_INV7 | 2        | 1   | AUFTRAG_3001  | 13  | 1    | Stück   | 12345_3001   |
    | ACHARGE_AUFTRAG1        | LP_INV7 | 2        | 2   | ACHARGE_3001  |  5  | 1    | Stück   | VW2_3001     |

Scenario: 02 Zaehlliste abschliessen

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "AUFTRAG_ZAEHL_3001" and menu choice "Ja"
And I save the current editor


Scenario: 03 Zaehlliste fuer Artikel versch Gebindeeinheiten, teilw Bestandskorrektur, teilw Behaelterkorrektur, neue Zeile ohne Behaelter

Given I open an editor "Zaehlliste_AEINHEIT" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "AEINHEIT_ZAEHL_3001"
And I append rows
    | artikel        | platz   |
    | AEINHEIT_3001  | LP_INV7 |
And I save the current editor

Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "AEINHEIT_ZAEHL_3001"
Then the table has 9 rows
Then table has values
    | gebeinh | gebf | verw    | projekt     | behaelter^such       |
    | m       | 1    |         | T2ESTP_3001 | AEINHEIT_PROJEKT1    |
    | m       | 1    | VW_3001 | TESTP_3001  | AEINHEIT_MINDESTB1   |
    | m       | 1    |         | TESTP_3001  | AEINH_LOHNF_PROJEKT1 |
    | m       | 1    |         | TESTP_3001  | AEINH_EKTEIL_ERWBED1 |
    | Stück  | 2    | V2_3001 |             |                      |
    | m       | 1    | V2_3001 |             | AEINHEIT_CHARGE1     |
    | kg      | 1    | V1_3001 |             | AEINHEIT1            |
    | m       | 1    | V1_3001 |             | AEINHEIT2            |
    | m       | 1    | V1_3001 |             | AEINHEIT_PROJEKT1    |
And I close the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "AEINHEIT_ZAEHL_3001" and menu choice "Ja"
And I save the current editor

Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "AEINHEIT_ZAEHL_3001"
Then the table has 9 rows
Then table has values
    | platz   | ibest | gebeinh | gebf | verw    | projekt     | behaelter^such       |
    | LP_INV7 | 15    | m       | 1    |         | T2ESTP_3001 | AEINHEIT_PROJEKT1    |
    | LP_INV7 | 5     | m       | 1    | VW_3001 | TESTP_3001  | AEINHEIT_MINDESTB1   |
    | LP_INV7 | 10    | m       | 1    |         | TESTP_3001  | AEINH_LOHNF_PROJEKT1 |
    | LP_INV7 | 15    | m       | 1    |         | TESTP_3001  | AEINH_EKTEIL_ERWBED1 |
    | LP_INV7 | 4     | Stück  | 2    | V2_3001 |             |                      |
    | LP_INV7 | 15    | m       | 1    | V2_3001 |             | AEINHEIT_CHARGE1     |
    | LP_INV7 | 5     | kg      | 1    | V1_3001 |             | AEINHEIT1            |
    | LP_INV7 | 10    | m       | 1    | V1_3001 |             | AEINHEIT2            |
    | LP_INV7 | 20    | m       | 1    | V1_3001 |             | AEINHEIT_PROJEKT1    |
Then I modify table
    | !row | nbest |
    |  1   |   17  |
    |  2   |   5   |
    |  3   |  21   |
    |  4   |  15   |
    |  5   |  10   |
    |  6   |  15   |
    |  7   |  7,5  |
    |  8   |   0   |
    |  9   |   0   |
And I save the current editor

# Zaehlliste AEINHEIT bearbeiten, neue Zeilen mit unterschiedlichen Gebindeeinheiten koennen angehaengt werden
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "AEINHEIT_ZAEHL_3001"
And I append rows
    | artikel       | platz   |
    | AEINHEIT_3001 | LP_INV7 |
And I respond with answer "3" to the dialog with id "Einheit"
And I press button "einhbut" in row !lastRow
Then field "gebeinh" has value "kg" in row !lastRow
And I set field "gebf" to "2" in row !lastRow
And I set field "nbest" to "5" in row !lastRow
And I set field "verw" to "V1_3001" in row !lastRow
And I append rows
    | artikel       | platz   |
    | AEINHEIT_3001 | LP_INV7 |
And I respond with answer "2" to the dialog with id "Einheit"
And I press button "einhbut" in row !lastRow
Then field "gebeinh" has value "Stück" in row !lastRow
And I set field "gebf" to "3" in row !lastRow
And I set field "nbest" to "5" in row !lastRow
And I set field "verw" to "V1_3001" in row !lastRow
And I set field "projekt" to "TESTP_3001" in row !lastRow
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "AEINHEIT_ZAEHL_3001" and menu choice "Ja"
And I save the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .              |
    | kursache   | Inventur       |
    | artikel    | AEINHEIT_3001  |
And I press start
Then the table has 9 rows
Then table has values
    | kmge | mei    | detursache                       | behaelter^such       |
    | 2    | m      | Bestandskorrektur durch Inventur | AEINHEIT_PROJEKT1    |
    |      | m      | Bestandskorrektur durch Inventur | AEINHEIT_MINDESTB1   |
    | 11   | m      | Bestandskorrektur durch Inventur | AEINH_LOHNF_PROJEKT1 |
    | 6    | Stück | Bestandskorrektur durch Inventur |                      |
    |      | m      | Bestandskorrektur durch Inventur | AEINHEIT_CHARGE1     |
    | 2.5  | kg     | Bestandskorrektur durch Inventur | AEINHEIT1            |
    | -30  | m      | Bestandskorrektur durch Inventur | AEINHEIT2            |
    | 5    | Stück | Bestandskorrektur durch Inventur |                      |
    | 5    | kg     | Bestandskorrektur durch Inventur |                      |
And I close the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | AEINHEIT_3001 |
    | klgruppe   |               |
    | nullmge    | nein          |
    | behaelter  | ja            |
And I press button "bstart"
Then the table has 9 rows
Then table has values
    | !row | gebmge | geinheit | gebf | verw    | projekt     | tbehaelter^such      |
    | 1    | 7.5    | kg       | 1    | V1_3001 |             | AEINHEIT1            |
    | 2    | 5      | kg       | 2    | V1_3001 |             |                      |
    | 3    | 15     | m        | 1    | V2_3001 |             | AEINHEIT_CHARGE1     |
    | 4    | 10     | Stück   | 2    | V2_3001 |             |                      |
    | 5    | 15     | m        | 1    |         | TESTP_3001  | AEINH_EKTEIL_ERWBED1 |
    | 6    | 21     | m        | 1    |         | TESTP_3001  | AEINH_LOHNF_PROJEKT1 |
    | 7    | 5      | Stück   | 3    | V1_3001 | TESTP_3001  |                      |
    | 8    | 5      | m        | 1    | VW_3001 | TESTP_3001  | AEINHEIT_MINDESTB1   |
    | 9    | 17     | m        | 1    |         | T2ESTP_3001 | AEINHEIT_PROJEKT1    |
And I close the current editor

Scenario Outline: 03 Behaelter pruefen
Given I open an editor "behaelter03" from table "(Container):(ContainerShell)" with command "VIEW" for record "<record>"
Then field "platz" has value "<platz>"
Then the table has <sollrows> rows
Then table has values
    | !row   | artikel   | mge   | gebf   | gebeinh   | verw   |
    | <row>  | <artikel> | <mge> | <gebf> | <gebeinh> | <verw> |
And I close the current editor

Examples: 03 Behaelter pruefen
    | record                  | platz   | sollrows | row | artikel        | mge  | gebf | gebeinh | verw            |
    | AEINHEIT1               | LP_INV7 | 1        | 1   | AEINHEIT_3001  | 7.5  | 1    | kg      | V1_3001         |
    | AEINHEIT_CHARGE1        | LP_INV7 | 2        | 1   | AEINHEIT_3001  | 15   | 1    | m       | V2_3001         |
    | AEINHEIT_CHARGE1        | LP_INV7 | 2        | 2   | CHARGE_3001    |  5   | 1    | Stück  |                 |
    | AEINHEIT_PROJEKT1       | LP_INV7 | 2        | 1   | AEINHEIT_3001  | 17   | 1    | m       |                 |
    | AEINHEIT_PROJEKT1       | LP_INV7 | 2        | 2   | PROJEKT_3001   | 12   | 1    | Stück  |                 |
    | AEINHEIT_MINDESTB1      | LP_INV7 | 2        | 1   | MINDESTB_3001  | 70   | 1    | Stück  |                 |
    | AEINHEIT_MINDESTB1      | LP_INV7 | 2        | 2   | AEINHEIT_3001  |  5   | 1    | m       | VW_3001         |
    | AEINH_EKTEIL_ERWBED1    | LP_INV7 | 4        | 1   | EKTEIL_3001    | 10   | 1    | Stück  |                 |
    | AEINH_EKTEIL_ERWBED1    | LP_INV7 | 4        | 2   | AEINHEIT_3001  | 15   | 1    | m       |                 |
    | AEINH_EKTEIL_ERWBED1    | LP_INV7 | 4        | 3   | ERWBEDARF_3001 | 12   | 1    | Stück  | Sicherheit_3001 |
    | AEINH_EKTEIL_ERWBED1    | LP_INV7 | 4        | 4   | ERWBEDARF_3001 | 10   | 1    | Stück  | VW1_3001        |
    | AEINH_LOHNF_PROJEKT1    | LP_INV7 | 3        | 1   | LOHNFERT_3001  |  5   | 1    | Stück  |                 |
    | AEINH_LOHNF_PROJEKT1    | LP_INV7 | 3        | 2   | AEINHEIT_3001  | 21   | 1    | m       |                 |
    | AEINH_LOHNF_PROJEKT1    | LP_INV7 | 3        | 3   | PROJEKT_3001   |  9   | 1    | Stück  |                 |

Scenario: 03 Behaelter pruefen und Zaehlliste abschliessen

Then Container "AEINHEIT2" is empty

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "AEINHEIT_ZAEHL_3001" and menu choice "Ja"
And I save the current editor


Scenario: 04 Zaehlliste fuer Artikel PROJEKT, ACHARGE, EINHEIT, teilw Bestandskorrektur, teilw Behaelter, neue Behaelter

# Zaehlliste anlegen PROJEKT, ACHARGE, EINHEIT (teilw Bestandskorrektur, teilw Behaelter, neue Behaelter)
Given I open an editor "Zaehlliste_PPRO_ACH_EINH" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "P_ACH_EIN_ZAEHL_3001"
And I append rows
    | artikel       | platz   |
    | PROJEKT_3001  | LP_INV7 |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "einhbut" in row !lastRow
And I append rows
    | artikel       | platz   |
    | ACHARGE_3001  | LP_INV7 |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "einhbut" in row !lastRow
And I append rows
    | artikel       | platz   |
    | EINHEIT_3001  | LP_INV7 |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "einhbut" in row !lastRow
And I save the current editor

Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "P_ACH_EIN_ZAEHL_3001"
Then the table has 14 rows
Then table has values
    | gebeinh  | gebf | tcharge     | verw     | projekt     | behaelter^such       |
    | m        | 1    |             |          |             | EKTEIL_EINHEIT1      |
    | kg       | 1    |             |          |             | EINHEIT1             |
    | m        | 1    |             |          |             | EINHEIT2             |
    | m        | 1    |             |          |             | EINHEIT1             |
    | Stück   | 1    | 67zu99_3001 | VW2_3001 |             | ACHARGE_AUFTRAG1     |
    | Stück   | 1    | 67zu99_3001 | VW1_3001 |             | ACHARGE_CHARGE1      |
    | Stück   | 1    | 67zu99_3001 | VW1_3001 |             |                      |
    | Stück   | 1    | 89639_3001  | VW1_3001 |             | ACHARGE_PROJEKT1     |
    | Stück   | 1    |             |          | T3ESTP_3001 | AEINHEIT_PROJEKT1    |
    | Stück   | 1    |             |          | T2ESTP_3001 |                      |
    | Stück   | 1    |             |          | TESTP_3001  | PROJEKT2             |
    | Stück   | 1    |             |          | TESTP_3001  | AEINH_LOHNF_PROJEKT1 |
    | Stück   | 1    |             |          | TESTP_3001  | ACHARGE_PROJEKT1     |
    | Stück   | 1    |             |          | TESTP_3001  |                      |
And I close the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "P_ACH_EIN_ZAEHL_3001" and menu choice "Ja"
And I save the current editor

Given I create a Container "INV_KLTNEU_3001" for packaging material "KLT"
Given I create a Container "INV_KARTONNEU_3001" for packaging material "DE-KARTON"

Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "P_ACH_EIN_ZAEHL_3001"
Then the table has 15 rows
Then table has values
    | artikel       | platz     | ibest | gebeinh  | gebf | charge^exnum | verw     | projekt     | behaelter^such       |
    | EINHEIT_3001  | LP_INV7   | 0     | m        | 1    |              |          |             | EKTEIL_EINHEIT1      |
    | EINHEIT_3001  | LP_INV7   | 5     | kg       | 1    |              |          |             | EINHEIT1             |
    | EINHEIT_3001  | LP_INV7   | 10    | m        | 1    |              |          |             | EINHEIT2             |
    | EINHEIT_3001  | LP_INV7   | 20    | m        | 1    |              |          |             | EINHEIT1             |
    | ACHARGE_3001  | LP_INV7   | 5     | Stück   | 1    | 67zu99_3001  | VW2_3001 |             | ACHARGE_AUFTRAG1     |
    | ACHARGE_3001  | LP_INV7   | 5     | Stück   | 1    | 67zu99_3001  | VW1_3001 |             | ACHARGE_CHARGE1      |
    | ACHARGE_3001  | LP_INV7   | 5     | Stück   | 1    | 67zu99_3001  | VW1_3001 |             |                      |
    | ACHARGE_3001  | LP_INV7   | 2     | Stück   | 1    | 89639_3001   | VW1_3001 |             | ACHARGE_PROJEKT1     |
    | PROJEKT_3001  | LP_INV7   | 12    | Stück   | 1    |              |          | T3ESTP_3001 | AEINHEIT_PROJEKT1    |
    | PROJEKT_3001  | LP_INV7   | 15    | Stück   | 1    |              |          | T2ESTP_3001 |                      |
    | PROJEKT_3001  | LP_INV7   | 15    | Stück   | 1    |              |          | TESTP_3001  | PROJEKT2             |
    | PROJEKT_3001  | LP_INV7   | 9     | Stück   | 1    |              |          | TESTP_3001  | AEINH_LOHNF_PROJEKT1 |
    | PROJEKT_3001  | LP_INV7   | 9     | Stück   | 1    |              |          | TESTP_3001  | ACHARGE_PROJEKT1     |
    | PROJEKT_3001  | LP_INV7   | 9     | Stück   | 1    |              |          | TESTP_3001  |                      |
    | EINHEIT_3001  | LP_INV7   | 0     | Stück   | 2    |              |          |             |                      |
Then I modify table
    | !row | nbest |
    |  1   |  17   |
    |  2   |  10   |
    |  3   |   7   |
    |  4   |  20   |
    |  5   |  50   |
    |  6   |   5   |
    |  7   |   5   |
    |  8   |   2   |
    |  9   |  12   |
    | 10   |  15   |
    | 11   |  10   |
    | 12   |   9   |
    | 13   |   9   |
    | 14   |  100  |
    | 15   |  50   |
And I save the current editor

# Zaehlliste PROJEKT, ACHARGE, EINHEIT bearbeiten NEUE ZEILEN mit unterschiedlichen Gebindeeinheiten einfuegen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "P_ACH_EIN_ZAEHL_3001"
And I append rows
    | artikel       | platz   |
    | ACHARGE_3001  | LP_INV7 |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "einhbut" in row !lastRow
And I set field "gebf" to "1" in row !lastRow
Then field "gebeinh" has value "Stück" in row !lastRow
### !lastRow funktioniert in der Tabelle nicht CUCU-249
#And I modify table
#    | !row      | nbest | tcharge      | verw      | behaelter           |
#    | !lastRow  | 5     | 67zu99_3001  | 123_3001  | !INV_KLTNEU_3001^id |
And I set field "nbest" to "5" in row !lastRow
And I set field "tcharge" to "67zu99_3001" in row !lastRow
And I set field "verw" to "123_3001" in row !lastRow
And I set field "behaelter" to "INV_KLTNEU_3001" in row !lastRow
And I append rows
    | artikel       | platz   |
    | ACHARGE_3001  | LP_INV7 |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "einhbut" in row !lastRow
And I set field "gebf" to "5" in row !lastRow
Then field "gebeinh" has value "Stück" in row !lastRow
#And I modify table
#    | !row     | nbest | tcharge      | verw      |
#    | !lastRow | 5     | 67zu99_3001  | VW2_3001  |
And I set field "nbest" to "5" in row !lastRow
And I set field "tcharge" to "67zu99_3001" in row !lastRow
And I set field "verw" to "VW2_3001" in row !lastRow
And I append rows
    | artikel       | platz   |
    | EINHEIT_3001  | LP_INV7 |
And I respond with answer "2" to the dialog with id "Einheit"
And I press button "einhbut" in row !lastRow
And I set field "gebf" to "3" in row !lastRow
Then field "gebeinh" has value "Stück" in row !lastRow
#And I modify table
#    | !row     | nbest | projekt      | verw      | behaelter              |
#    | !lastRow | 5     | TESTP_3001   | 123_3001  | !INV_KARTONNEU_3001^id |
And I set field "nbest" to "5" in row !lastRow
And I set field "projekt" to "TESTP_3001" in row !lastRow
And I set field "behaelter" to "INV_KARTONNEU_3001" in row !lastRow
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "P_ACH_EIN_ZAEHL_3001" and menu choice "Ja"
And I save the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .              |
    | kursache   | Inventur       |
    | artikel    | PROJEKT_3001   |
And I press start
Then table has values
    | kmge | mei    | verw | projekt     |
    |      | Stück |      | T3ESTP_3001 |
    |      | Stück |      | T2ESTP_3001 |
    | 86   | Stück |      | TESTP_3001  |
And I set field "artikel" to "ACHARGE_3001"
And I press start
Then table has values
    | kmge | mei    | verw     | tncharge    | projekt |
    | 45   | Stück | VW2_3001 | 67zu99_3001 |         |
    |      | Stück | VW1_3001 | 67zu99_3001 |         |
    |      | Stück | VW1_3001 | 89639_3001  |         |
    | 5    | Stück | VW2_3001 | 67zu99_3001 |         |
    | 5    | Stück | 123_3001 | 67zu99_3001 |         |
And I set field "artikel" to "EINHEIT_3001"
And I press start
Then table has values
    | kmge | mei    | verw     | projekt     |
    | 14   | m      |          |             |
    | 5    | kg     |          |             |
    | 50   | Stück |          |             |
    | 5    | Stück |          | TESTP_3001  |
And I close the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | AEINHEIT_3001 |
    | klgruppe   |               |
    | nullmge    | nein          |
    | behaelter  | ja            |
And I press button "bstart"
Then the table has 9 rows
Then table has values
    | !row | gebmge | geinheit | gebf | verw    | projekt     | tbehaelter^such      |
    | 1    | 7.5    | kg       | 1    | V1_3001 |             | AEINHEIT1            |
    | 2    | 5      | kg       | 2    | V1_3001 |             |                      |
    | 3    | 15     | m        | 1    | V2_3001 |             | AEINHEIT_CHARGE1     |
    | 4    | 10     | Stück   | 2    | V2_3001 |             |                      |
    | 5    | 15     | m        | 1    |         | TESTP_3001  | AEINH_EKTEIL_ERWBED1 |
    | 6    | 21     | m        | 1    |         | TESTP_3001  | AEINH_LOHNF_PROJEKT1 |
    | 7    | 5      | Stück   | 3    | V1_3001 | TESTP_3001  |                      |
    | 8    | 5      | m        | 1    | VW_3001 | TESTP_3001  | AEINHEIT_MINDESTB1   |
    | 9    | 17     | m        | 1    |         | T2ESTP_3001 | AEINHEIT_PROJEKT1    |
And I close the current editor

Scenario Outline: 04 Bestand PROJEKT, ACHARGE, EINHEIT pruefen
Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | <artikel>     |
    | klgruppe   |               |
    | nullmge    | nein          |
    | behaelter  | ja            |
And I press button "bstart"
Then the table has <sollrows> rows
Then table has values
    | !row  | gebmge   | geinheit   | gebf   | charge^exnum  | verw    | projekt     | tbehaelter^such      |
    | <row> | <gebmge> | <geinheit> | <gebf> | <charge>      | <verw>  | <projekt>   | <behaelter>          |
And I close the current editor

Examples: 04 Bestand PROJEKT, ACHARGE, EINHEIT pruefen
    | artikel      | sollrows | row | gebmge | geinheit  | gebf | charge      | verw     | projekt     | behaelter               |
    | PROJEKT_3001 | 7        | 1   |  100   | Stück    | 1    |             |          | TESTP_3001  |                         |
    | PROJEKT_3001 | 7        | 2   |    9   | Stück    | 1    |             |          | TESTP_3001  | ACHARGE_PROJEKT1        |
    | PROJEKT_3001 | 7        | 3   |    9   | Stück    | 1    |             |          | TESTP_3001  | AEINH_LOHNF_PROJEKT1    |
    | PROJEKT_3001 | 7        | 4   |   10   | Stück    | 1    |             |          | TESTP_3001  | PROJEKT2                |
    | PROJEKT_3001 | 7        | 5   |   15   | Stück    | 1    |             |          | T2ESTP_3001 |                         |
    | PROJEKT_3001 | 7        | 6   |   12   | Stück    | 1    |             |          | T3ESTP_3001 | AEINHEIT_PROJEKT1       |
    | PROJEKT_3001 | 7        | 7   |    9   | Stück    | 1    |             |          | TESTP_3001  | ACHARGE_CHARGE_PROJEKT1 |
    | ACHARGE_3001 | 7        | 1   |    2   | Stück    | 1    | 89639_3001  | VW1_3001 |             | ACHARGE_PROJEKT1        |
    | ACHARGE_3001 | 7        | 2   |    5   | Stück    | 1    | 67zu99_3001 | 123_3001 |             | INV_KLTNEU_3001         |
    | ACHARGE_3001 | 7        | 3   |    5   | Stück    | 1    | 67zu99_3001 | VW1_3001 |             |                         |
    | ACHARGE_3001 | 7        | 4   |    5   | Stück    | 1    | 67zu99_3001 | VW1_3001 |             | ACHARGE_CHARGE1         |
    | ACHARGE_3001 | 7        | 5   |   50   | Stück    | 1    | 67zu99_3001 | VW2_3001 |             | ACHARGE_AUFTRAG1        |
    | ACHARGE_3001 | 7        | 6   |    5   | Stück    | 5    | 67zu99_3001 | VW2_3001 |             |                         |
    | ACHARGE_3001 | 7        | 7   |    5   | Stück    | 1    | 89639_3001  | VW2_3001 |             | ACHARGE_CHARGE_PROJEKT1 |
    | EINHEIT_3001 | 7        | 1   |   20   | m         | 1    |             |          |             | EINHEIT1                |
    | EINHEIT_3001 | 7        | 2   |    7   | m         | 1    |             |          |             | EINHEIT2                |
    | EINHEIT_3001 | 7        | 3   |   17   | m         | 1    |             |          |             | EKTEIL_EINHEIT1         |
    | EINHEIT_3001 | 7        | 4   |   10   | kg        | 1    |             |          |             | EINHEIT1                |
    | EINHEIT_3001 | 7        | 5   |   50   | Stück    | 2    |             |          |             |                         |
    | EINHEIT_3001 | 7        | 6   |   17   | Stück    | 2    |             |          |             | EKTEIL_EINHEIT1         |
    | EINHEIT_3001 | 7        | 7   |    5   | Stück    | 3    |             |          | TESTP_3001  | INV_KARTONNEU_3001      |


Scenario Outline: 04 Behaelter PROJEKT, ACHARGE, EINHEIT pruefen
Given I open an editor "behaelter04" from table "(Container):(ContainerShell)" with command "VIEW" for record "<record>"
Then field "platz" has value "<platz>"
Then the table has <sollrows> rows
Then table has values
    | !row   | artikel   | mge   | gebf   | gebeinh   | charge^exnum    | verw   |
    | <row>  | <artikel> | <mge> | <gebf> | <gebeinh> | <charge>        | <verw> |
And I close the current editor

Examples: 04 Behaelter PROJEKT, ACHARGE, EINHEIT pruefen
    | record                  | platz   | sollrows | row | artikel       | mge | gebf | gebeinh  | charge      | verw       |
    | ACHARGE_AUFTRAG1        | LP_INV7 | 2        | 1   | AUFTRAG_3001  | 13  | 1    | Stück   |             | 12345_3001 |
    | ACHARGE_AUFTRAG1        | LP_INV7 | 2        | 2   | ACHARGE_3001  | 50  | 1    | Stück   | 67zu99_3001 | VW2_3001   |
    | ACHARGE_CHARGE1         | LP_INV7 | 2        | 1   | CHARGE_3001   | 12  | 1    | Stück   | 887799_3001 |            |
    | ACHARGE_CHARGE1         | LP_INV7 | 2        | 2   | ACHARGE_3001  | 5   | 1    | Stück   | 67zu99_3001 | VW1_3001   |
    | ACHARGE_CHARGE_PROJEKT1 | LP_INV8 | 3        | 1   | PROJEKT_3001  | 9   | 1    | Stück   |             |            |
    | ACHARGE_CHARGE_PROJEKT1 | LP_INV8 | 3        | 2   | CHARGE_3001   | 25  | 1    | Stück   | 887799_3001 |            |
    | ACHARGE_CHARGE_PROJEKT1 | LP_INV8 | 3        | 3   | ACHARGE_3001  | 5   | 1    | Stück   | 89639_3001  | VW2_3001   |
    | AEINH_LOHNF_PROJEKT1    | LP_INV7 | 3        | 1   | LOHNFERT_3001 | 5   | 1    | Stück   |             |            |
    | AEINH_LOHNF_PROJEKT1    | LP_INV7 | 3        | 2   | AEINHEIT_3001 | 21  | 1    | m        |             |            |
    | AEINH_LOHNF_PROJEKT1    | LP_INV7 | 3        | 3   | PROJEKT_3001  | 9   | 1    | Stück   |             |            |
    | EINHEIT1                | LP_INV7 | 2        | 1   | EINHEIT_3001  | 20  | 1    | m        |             |            |
    | EINHEIT1                | LP_INV7 | 2        | 2   | EINHEIT_3001  | 10  | 1    | kg       |             |            |
    | EINHEIT2                | LP_INV7 | 1        | 1   | EINHEIT_3001  | 7   | 1    | m        |             |            |
    | PROJEKT2                | LP_INV7 | 1        | 1   | PROJEKT_3001  | 10  | 1    | Stück   |             |            |
    | INV_KLTNEU_3001         | LP_INV7 | 1        | 1   | ACHARGE_3001  | 5   | 1    | Stück   | 67zu99_3001 | 123_3001   |
    | INV_KARTONNEU_3001      | LP_INV7 | 1        | 1   | EINHEIT_3001  | 5   | 3    | Stück   |             |            |

Scenario: 04 Behaelter PROJEKT1 pruefen leer
Then Container "PROJEKT1" is empty

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "P_ACH_EIN_ZAEHL_3001" and menu choice "Ja"
And I save the current editor


Scenario: 05 Pruefungen Zaehlliste bearbeiten VOR und NACH der Eroeffnung

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "SKARTON"
And I set fields
    | such      | SKARTON           |
    | namebspr  | KARTON Standard   |
    | packmit   | ja                |
    | pmtyp     | Behaelter         |
And I save the current editor

Given I open an editor "Zaehlliste_PRUEF" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "PRUEF_ZAEHL05_3001"
And I append rows
   | artikel        | platz   |
   | ERWBEDARF_3001 | LP_INV7 |
And I save the current editor

Given I create a Container "INVPRUEF_KLTNEU_3001" for packaging material "KLT"
Given I create a Container "INVPRUEF_KARTONNEU_3001" for packaging material "SKARTON"

# Pruefung nicht freigegebene Zaehlliste (Zeile anfuegen, loeschen, neuer Behaelter)
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "PRUEF_ZAEHL05_3001"
And I append rows
    | artikel        | platz   | gebeinh    | behaelter                |
    | ERWBEDARF_3001 | LP_INV7 | Stück     | !INVPRUEF_KLTNEU_3001^id |
And I delete row at position !lastRow
And I close the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "PRUEF_ZAEHL05_3001" and menu choice "Ja"
And I save the current editor

# Pruefung freigegebene Zaehlliste (Zeile anfuegen, loeschen, neuer Behaelter)
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "PRUEF_ZAEHL05_3001"
And I append rows
    | artikel        | platz   | behaelter                |
    | ERWBEDARF_3001 | LP_INV7 | !INVPRUEF_KLTNEU_3001^id |
And I delete row at position !lastRow
And I create a new row at position 1
And I set field "artikel" to "ERWBEDARF_3001" in row 1
And I delete row at position 1
Then field "le" is not modifiable in row 1
And I close the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "PRUEF_ZAEHL05_3001" and menu choice "Ja"
And I save the current editor

# Pruefung Zaehlliste nach Bestandsabschluss (Zeile anfuegen, loeschen, Einheiten wechseln)
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "PRUEF_ZAEHL05_3001"
#   3794 de   |Zeile kann nicht eingefuegt werden
And creating a new row at position 1 throws the exception "3794"
#   3885 de   |Zeile kann nicht geloescht werden
And deleting the row at position 1 throws the exception "3885"
And I close the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "PRUEF_ZAEHL05_3001" and menu choice "Ja"
And I save the current editor


Scenario: 06 Zaehlliste Artikel BAUGRUPPE, Gefuellter Behaelter wird leer, Zubuchung vor Freigabe einer Zaehlliste

Given I open an editor "Zaehlliste_Baugruppe" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "BAUGRUPPE_3001"
And I append rows
    | artikel        | platz   |
    | BAUGRUPPE_3001 | LP_INV7 |
    | BAUGRUPPE_3001 | LP_INV8 |
And I save the current editor

# Zaehlliste BAUGRUPPE vor Buchungen pruefen
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "BAUGRUPPE_3001"
Then table has values
    | gebeinh  | gebf | projekt     | behaelter^such   |
    | Stück   | 1    | T2ESTP_3001 | BAUGR_ERWBEDARF1 |
    | Stück   | 1    | TESTP_3001  | BAUGRUPPE2       |
    | Stück   | 1    |             | BAUGRUPPE1       |
And I close the current editor

# Abgangsbuchung BAUGRUPPE aus Behaelter
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | BAUGRUPPE_3001 |
    | buart   | Abgang         |
    | beleg   | A_3001         |
    | beldat  | .              |
And I append rows
    | mge | projekt    | platz   | behaelter      |
    | 15  | TESTP_3001 | LP_INV7 | !BAUGRUPPE2^id |
And I save the current editor

# Zugangsbuchung BAUGRUPPE in Behaelter
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | BAUGRUPPE_3001 |
    | buart   | Zugang         |
    | beleg   | A_3001         |
    | beldat  | .              |
And I append rows
    | mge | projekt     | platz2  | behaelter            |
    |  7  | T2ESTP_3001 | LP_INV8 | !BAUGR_ERWBEDARF1^id |
And I save the current editor

# Zaehlliste BAUGRUPPE nach Buchungen pruefen (vor Inv)
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "BAUGRUPPE_3001"
Then table has values
    | gebeinh  | gebf | projekt     | behaelter^such   |
    | Stück   | 1    | T2ESTP_3001 | BAUGR_ERWBEDARF1 |
    | Stück   | 1    | TESTP_3001  | BAUGRUPPE2       |
    | Stück   | 1    |             | BAUGRUPPE1       |
And I close the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "BAUGRUPPE_3001" and menu choice "Ja"
And I save the current editor

# Zaehlliste BAUGRUPPE nach Buchungen pruefen (nach Inv)
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "BAUGRUPPE_3001"
Then table has values
    | platz   | ibest | gebeinh  | gebf | projekt     | behaelter^such   |
    | LP_INV8 | 17    | Stück   | 1    | T2ESTP_3001 | BAUGR_ERWBEDARF1 |
    | LP_INV7 | 0     | Stück   | 1    | TESTP_3001  | BAUGRUPPE2       |
    | LP_INV7 | 9     | Stück   | 1    |             | BAUGRUPPE1       |
And I close the current editor

Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "DELETE" for record "BAUGRUPPE_3001"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor


Scenario: 07 Zaehlliste CHARGE Artikel mit gleichen Auspraegungen

Given I open an editor "Zaehlliste_Charge" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "CHARGE_VORINV_3001"
And I append rows
    | artikel        | platz   |
    | CHARGE_3001    | LP_INV7 |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "einhbut" in row !lastRow
And I append rows
    | artikel        | platz   |
    | CHARGE_3001    | LP_INV8 |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "einhbut" in row !lastRow
And I save the current editor

# Artikel mit gleichen Auspraegungen auf der selben Zaehlliste CHARGE (vor Inv)
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "CHARGE_VORINV_3001"
Then the table has 3 rows
And I append rows
    | artikel        | platz   | gebeinh     | gebf  | charge    |
    | CHARGE_3001    | LP_INV7 | Stück      | 1     | CH1_3001  |
And I set field "behaelter" to "!AEINHEIT_CHARGE1^id" in row 4
# 2938 de   |Inventurposition gibt es schon
Then saving the current editor throws the exception "2938"
And I close the current editor

# Artikel mit gleichen Auspraegungen auf anderer Zaehlliste (vor Inv)
Given I open an editor "Zaehlliste_Charge" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I append rows
    | artikel        |
    | CHARGE_3001    |
# QSW-499
# 2607 de |Der Artikel auf diesem Platz ist schon in anderer Zaehlliste gefuehrt
#And setting field "platz" to "LP_INV7" in row 4 throws the exception "2607"
And setting field "platz" to "LP_INV7" in row 4 throws the exception ""
And I close the current editor

Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "DELETE" for record "CHARGE_VORINV_3001"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor


Scenario: 08 In der Zaehlliste wird in le die Lagereinheit angezeigt

Given I open an editor "Zaehlliste_Gebinde" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "Gebinde_3001"
And I append rows
   | artikel       | platz   |
   | EINHEIT_3001  | LP_INV7 |
   | AEINHEIT_3001 | LP_INV7 |
Then table has values
    | le |
    | m  |
    | m  |
    | m  |
    | m  |
    | m  |
    | m  |
    | m  |
    | m  |
    | m  |
    | m  |
    | m  |
    | m  |
    | m  |
    | m  |
    | m  |
    | m  |
And I close the current editor


Scenario: 09 neu gefuellte Behaelter ueber Zaehlliste bekommt Belegnummer der Inventur

Given I create a Container "BELEGNUMMER_KLT" for packaging material "KLT"
Given I create a Container "BELEGNUMMER_KARTON" for packaging material "SKARTON"

Given I open an editor "Zaehlliste_BELEG" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "BELEG_3001"
And I set field "nummer" to "3001"
And I append rows
    | artikel     | platz   |
    | EKTEIL_3001 | LP_INV7 |
And I save the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "BELEG_3001" and menu choice "Ja"
And I save the current editor

# Zaehlliste BELEG bearbeiten
Given I open an editor "Invbearb02" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "BELEG_3001"
And I modify table
    | !row | nbest |
    | 1    | 20    |
    | 2    | 10    |
And I append rows
    | artikel        | platz   | behaelter              | nbest    | gebeinh    | gebf  |
    | EKTEIL_3001    | LP_INV8 | !BELEGNUMMER_KLT^id    | 7        | Stück     | 1     |
    | EKTEIL_3001    | LP_INV7 | !BELEGNUMMER_KARTON^id | 9        | Stück     | 1     |
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "BELEG_3001" and menu choice "Ja"
And I save the current editor

# Lagerjournal mit Belegnummer pruefen
And I open the infosystem "LJ"
And I set fields
    | adatum      | .         |
    | beleg       | I.3001    |
And I press start
Then table has values
    | art         | buart     | ursache         | detursache                       | amge | kmge | behaelter^id             |
    | SKARTON     | Abgang    | Behälterstatus | Automatische Packmittelkorrektur | 1    |      | !BELEGNUMMER_KARTON^id   |
    | EKTEIL_3001 | Korrektur | Inventur        | Bestandskorrektur durch Inventur |      | 9    | !EKTEIL1^id              |
    | EKTEIL_3001 | Korrektur | Inventur        | Bestandskorrektur durch Inventur |      | 7    | !BELEGNUMMER_KLT^id      |
    | KLT         | Abgang    | Behälterstatus | Automatische Packmittelkorrektur | 1    |      | !BELEGNUMMER_KLT^id      |
And I close the current editor

Given I open an editor "Abschluss" from table "(Stocktaking)" with command "TRANSFER" for record "BELEG_3001" and menu choice "Ja"
And I save the current editor


Scenario: 10 Zaehlliste anlegen, versch Lagerplaetze, Behaelter wechselt Lagerplatz

# Zaehlliste mit 2 Lagerplaetzen anlegen
Given I open an editor "ZAEHL_10" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "ZAEHL_10"
And I append rows
    | artikel      | platz   |
    | EINKAUF_3001 | LP_INV7 |
    | EINKAUF_3001 | LP_INV8 |
And I save the current editor

Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "ZAEHL_10"
Then table has values
    | gebeinh  | gebf | behaelter^such   | platz   |
    | Stück   | 1    |                  | LP_INV8 |
    | Stück   | 1    | EINKAUFTEIL      | LP_INV7 |
    | Stück   | 1    |                  | LP_INV7 |
And I close the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "ZAEHL_10" and menu choice "Ja"
And I save the current editor

Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL_10"
And I append rows
    | artikel        | platz   | behaelter          | gebeinh   | gebf  |
    | EINKAUF_3001   | LP_INV8 | !EINKAUFTEIL^id    | Stück    | 1     |
Then field "gebeinh" has value "Stück" in row !lastRow
And I set field "nbest" to "15" in row !lastRow
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ZAEHL_10" and menu choice "Ja"
And I save the current editor

Given I open an editor "behaelter10" from table "(Container):(ContainerShell)" with command "VIEW" for record "EINKAUFTEIL"
Then field "platz" has value "LP_INV8"
Then the table has 1 rows
Then table has values
    | artikel         | mge   | gebf | gebeinh |
    | EINKAUF_3001    | 15    | 1    | Stück  |
And I close the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "TRANSFER" for record "ZAEHL_10" and menu choice "Ja"
And I save the current editor


Scenario: 11 Zwei Zaehllisten versch Lagerplaetze; Behaelter wechselt Lagerplatz, auf zwei Zaehllisten

Given I open an editor "ZAEHL_11_A" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "ZAEHL_11_A"
And I append rows
    | artikel      | platz   |
    | EINKAUF_3001 | LP_INV7 |
And I save the current editor

Given I open an editor "ZAEHL_11_B" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "ZAEHL_11_B"
And I append rows
    | artikel      | platz   |
    | EINKAUF_3001 | LP_INV8 |
And I save the current editor

Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "ZAEHL_11_A"
Then table has values
    | gebeinh  | gebf | platz   |
    | Stück   | 1    | LP_INV7 |
And I close the current editor

Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "ZAEHL_11_B"
Then table has values
    | gebeinh  | gebf | behaelter^such | platz   |
    | Stück   | 1    | EINKAUFTEIL    | LP_INV8 |
And I close the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "ZAEHL_11_A" and menu choice "Ja"
And I save the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "ZAEHL_11_B" and menu choice "Ja"
And I save the current editor

# Zaehlliste bearbeiten
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL_11_A"
And I append rows
    | artikel        | platz   | behaelter          | gebeinh    | gebf  | nbest |
    | EINKAUF_3001   | LP_INV7 | !EINKAUFTEIL^id    | Stück     | 1     | 30    |
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ZAEHL_11_A" and menu choice "Ja"
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ZAEHL_11_B" and menu choice "Ja"
And I save the current editor

Given I open an editor "behaelter10" from table "(Container):(ContainerShell)" with command "VIEW" for record "EINKAUFTEIL"
Then field "platz" has value "LP_INV7"
Then the table has 1 rows
Then table has values
    | artikel      | mge | gebf | gebeinh |
    | EINKAUF_3001 | 30  | 1    | Stück  |
And I close the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "TRANSFER" for record "ZAEHL_11_A" and menu choice "Ja"
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "TRANSFER" for record "ZAEHL_11_B" and menu choice "Ja"
And I save the current editor


Scenario: 12 Zaehlliste anlegen versch Lagerplaetze; Behaelter wechselt Lagerplatz, auf zwei Zaehllisten

Given I open an editor "ZAEHL_12_A" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "ZAEHL_12_A"
And I append rows
    | artikel      | platz   |
    | EINKAUF_3001 | LP_INV7 |
And I save the current editor

Given I open an editor "ZAEHL_12_B" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "ZAEHL_12_B"
And I append rows
    | artikel      | platz   |
    | EINKAUF_3001 | LP_INV8 |
And I save the current editor

Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "ZAEHL_12_A"
Then table has values
    | gebeinh  | gebf | behaelter^such | platz   |
    | Stück   | 1    | EINKAUFTEIL    | LP_INV7 |
And I close the current editor

Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "ZAEHL_12_B"
Then table has values
    | gebeinh  | gebf | platz   |
    | Stück   | 1    | LP_INV8 |
And I close the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "ZAEHL_12_A" and menu choice "Ja"
And I save the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "ZAEHL_12_B" and menu choice "Ja"
And I save the current editor

# Zaehlliste bearbeiten
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL_12_B"
And I append rows
    | artikel        | platz   | behaelter          | gebf  | gebeinh  | nbest |
    | EINKAUF_3001   | LP_INV8 | !EINKAUFTEIL^id    | 1     | Stück   | 25    |
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ZAEHL_12_A" and menu choice "Ja"
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ZAEHL_12_B" and menu choice "Ja"
And I save the current editor

Given I open an editor "behaelter12" from table "(Container):(ContainerShell)" with command "VIEW" for record "EINKAUFTEIL"
Then field "platz" has value "LP_INV8"
Then the table has 1 rows
Then table has values
    | artikel      | mge | gebf | gebeinh  |
    | EINKAUF_3001 | 25  | 1    | Stück   |
And I close the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "TRANSFER" for record "ZAEHL_12_A" and menu choice "Ja"
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "TRANSFER" for record "ZAEHL_12_B" and menu choice "Ja"
And I save the current editor


Scenario: 13 Zaehllisten versch Lageplaetze, Bestand in Behaelter aendern

# Neue Bestaende in Behaelter legen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | EKTEIL_3001 |
    | buart   | Zugang      |
    | beleg   | TEST_3001   |
    | beldat  | .           |
And I append rows
    | mge | platz2  | behaelter       |
    |  15 | LP_INV7 | MIXBEHAELTER1   |
    |  10 | LP_INV7 | MIXBEHAELTER2   |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | EKTEIL_3001 |
    | buart   | Abgang      |
    | beleg   | TEST_3001_1 |
    | beldat  | .           |
And I append rows
    | mge | platz   | behaelter       |
    |  7  | LP_INV8 | BELEGNUMMER_KLT |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | EINKAUF_3001 |
    | buart   | Zugang       |
    | beleg   | TEST_EK3001  |
    | beldat  | .            |
And I append rows
    | mge | platz2  | behaelter     |
    |  17 | LP_INV7 | MIXBEHAELTER1 |
    |  20 | LP_INV7 | MIXBEHAELTER2 |
And I save the current editor

# Bestaende EKTEIL in Behaelter entfernen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | EKTEIL_3001 |
    | buart   | Abgang      |
    | beleg   | TEST_3001   |
    | beldat  | .           |
And I append rows
    | mge | platz   | behaelter          |
    |  9  | LP_INV7 | BELEGNUMMER_KARTON |
And I save the current editor

Given I open an editor "ZAEHL_13_A" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "ZAEHL_13_A"
And I append rows
    | artikel      | platz   |
    | EINKAUF_3001 | LP_INV7 |
    | EKTEIL_3001  | LP_INV7 |
And I save the current editor

Given I open an editor "ZAEHL_13_B" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "ZAEHL_13_B"
And I append rows
    | artikel      | platz   |
    | EINKAUF_3001 | LP_INV8 |
    | EKTEIL_3001  | LP_INV8 |
And I save the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "ZAEHL_13_A" and menu choice "Ja"
And I save the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "ZAEHL_13_B" and menu choice "Ja"
And I save the current editor

Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "ZAEHL_13_A"
Then table has values
    | gebeinh  | gebf | behaelter^such       | platz   | ibest |
    | Stück   | 1    | MIXBEHAELTER2        | LP_INV7 | 10    |
    | Stück   | 1    | MIXBEHAELTER1        | LP_INV7 | 15    |
    | Stück   | 1    | EKTEIL1              | LP_INV7 | 20    |
    | Stück   | 1    | AEINH_EKTEIL_ERWBED1 | LP_INV7 | 10    |
    | Stück   | 1    | MIXBEHAELTER2        | LP_INV7 | 20    |
    | Stück   | 1    | MIXBEHAELTER1        | LP_INV7 | 17    |
And I close the current editor

Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "ZAEHL_13_B"
Then table has values
    | gebeinh  | gebf | behaelter^such | platz   |
    | Stück   | 1    |                | LP_INV8 |
    | Stück   | 1    | EINKAUFTEIL    | LP_INV8 |
And I close the current editor

# Zaehlliste bearbeiten
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL_13_B"
# Bestand in Behaelter erhalten
And I set field "nbest" to "25" in row 2
And I append rows
    | artikel        | platz   | behaelter          | gebf  | gebeinh  | nbest |
    | EINKAUF_3001   | LP_INV8 | !MIXBEHAELTER1^id  | 1     | Stück   | 3     |
    | EKTEIL_3001    | LP_INV8 | !MIXBEHAELTER1^id  | 1     | Stück   | 4     |
And I save the current editor

Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "ZAEHL_13_B"
Then table has values
    | gebeinh  | gebf | behaelter^such | platz   | ibest | nbest |
    | Stück   | 1    |                | LP_INV8 | 15    |   0   |
    | Stück   | 1    | EINKAUFTEIL    | LP_INV8 | 25    |  25   |
    | Stück   | 1    | MIXBEHAELTER1  | LP_INV8 | 0     |   4   |
    | Stück   | 1    | MIXBEHAELTER1  | LP_INV8 | 0     |   3   |
And I close the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ZAEHL_13_A" and menu choice "Ja"
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ZAEHL_13_B" and menu choice "Ja"
And I save the current editor

Given I open an editor "MIXBEHAELTER1" from table "(Container):(ContainerShell)" with command "VIEW" for record "MIXBEHAELTER1"
Then field "platz" has value "LP_INV8"
Then the table has 2 rows
Then table has values
    | artikel      | mge | gebf | gebeinh  |
    | EKTEIL_3001  |  4  | 1    | Stück   |
    | EINKAUF_3001 |  3  | 1    | Stück   |
And I close the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "TRANSFER" for record "ZAEHL_13_A" and menu choice "Ja"
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "TRANSFER" for record "ZAEHL_13_B" and menu choice "Ja"
And I save the current editor


Scenario: 14 Zaehlliste fuer versch Lagerplaetze; Bestand in Behaelter buchen

# Zaehlliste anlegen fuer 2 Lagerplaetze
Given I open an editor "ZAEHL_14" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "ZAEHL_14"
And I append rows
    | artikel      | platz   |
    | EINKAUF_3001 | LP_INV7 |
    | EINKAUF_3001 | LP_INV8 |
And I save the current editor

Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "ZAEHL_14"
Then the table has 3 rows
Then table has values
    | gebeinh  | gebf | behaelter^such | platz   |
    | Stück   | 1    | MIXBEHAELTER1  | LP_INV8 |
    | Stück   | 1    | EINKAUFTEIL    | LP_INV8 |
    | Stück   | 1    |                | LP_INV7 |
And I close the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "ZAEHL_14" and menu choice "Ja"
And I save the current editor

# Zaehlliste ZAEHL_14 bearbeiten
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL_14"
And I append rows
    | artikel        | platz   | behaelter        | gebeinh  | gebf | nbest |
    | EINKAUF_3001   | LP_INV7 | !EINKAUFTEIL^id  | Stück   | 1    | 30    |
    | EKTEIL_3001    | LP_INV7 | !EINKAUFTEIL^id  | Stück   | 1    | 17    |
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ZAEHL_14" and menu choice "Ja"
And I save the current editor

Given I open an editor "behaelter14" from table "(Container):(ContainerShell)" with command "VIEW" for record "EINKAUFTEIL"
Then field "platz" has value "LP_INV7"
Then the table has 2 rows
Then table has values
    | artikel      | mge | gebf | gebeinh  |
    | EKTEIL_3001  |  17 | 1    | Stück   |
    | EINKAUF_3001 |  30 | 1    | Stück   |
And I close the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "TRANSFER" for record "ZAEHL_14" and menu choice "Ja"
And I save the current editor

