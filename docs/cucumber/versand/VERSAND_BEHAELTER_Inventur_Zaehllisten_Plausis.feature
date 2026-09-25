@persistent
Feature: VERSAND_BEHAELTER_Inventur_Zaehllisten_Plausis.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Inventur_Zaehllisten_Plausis.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : carue
#  Funktion         : Testet Inventur Plausi
#  ref              : ref_behaelter_inventur_plausi_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"

@testvorbereitung
Scenario: Behaelter anlegen

Given I create a Container "EKTEIL1A" for packaging material "KLT"
Given I create a Container "EINKAUFTEIL1" for packaging material "KLT"

@testvorbereitung
Scenario: Bestaende zubuchen

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EKTEIL_3001   |
    | buart     | Zugang        |
    | beleg     | TEST_3000     |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   | behaelter     |
    | 10     | F1       | !EKTEIL1A^id  |
    | 20     | F1       | !EKTEIL1A^id  |
    | 15     | F2       |               |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EINKAUF_3001  |
    | buart     | Zugang        |
    | beleg     | TEST_EK3000   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   | behaelter         |
    | 10     | F1       | !EINKAUFTEIL1^id  |
    | 20     | F1       |                   |
    | 15     | F2       |                   |
    | 20     | F1       | !EKTEIL1A^id      |
And I save the current editor


Scenario: 1 Behaelter kann nicht mit abweichendem Lagerplatz auf Zaehlliste erfasst werden

Given I open an editor "ZAEHL_1" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "ZAEHL_1"
And I append rows
    | artikel      | platz   |
    | EINKAUF_3001 | F1      |
    | EINKAUF_3001 | F2      |
And I save the current editor

Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "ZAEHL_1"
Then the table has 4 rows
Then table has values
| !row | gebeinh | gebf | behaelter^such     | platz    |
| 1    | Stück   | 1    |                    | F2       |
| 2    | Stück   | 1    | !EINKAUFTEIL1^such | F1       |
| 3    | Stück   | 1    | !EKTEIL1A^such     | F1       |
| 4    | Stück   | 1    |                    | F1       |
And I close the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "ZAEHL_1" and menu choice "Ja"
And I save the current editor

# Zaehlliste bearbeiten, weitere Inventurposition fuer gleichen Behaelter, aber abweichendem Platz erfassen bringt Fehler
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL_1"
And I append rows
    | artikel      | platz   | behaelter        |
    | EINKAUF_3001 | F2      | !EINKAUFTEIL1^id |
And I set field "nbest" to "10" in row 2
# 8479 Der Behälter wird bereits in einer anderen Inventurposition auf einem abweichenden Platz mit einer Menge größer 0 verwendet.
And setting field "nbest" to "5" in row !lastRow throws the exception "8479"
And setting field "addmge" to "5" in row !lastRow throws the exception "8479"
And I close the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ZAEHL_1" and menu choice "Ja"
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "TRANSFER" for record "ZAEHL_1" and menu choice "Ja"
And I save the current editor


## bschiga - Scenario war schon auskommentiert vor dem Test Refactoring
#@Zaehllisten
#Scenario: 2 Zaehlliste anlegen AUFTRAG (versch Lagerplaetze; Behaelter wechselt Lagerplatz)
#Given I open an editor "ZAEHL_2" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
#And I set field "such" to "ZAEHL_2"
#And I create a new row at the end of the table
#And I set field "artikel" to "EINKAUF_3001" in row !lastRow
#And I set field "platz" to "F1" in row !lastRow
#And I create a new row at the end of the table
#And I set field "artikel" to "EINKAUF_3001" in row !lastRow
#And I set field "platz" to "F2" in row !lastRow
#And I save the current editor
#
#Scenario Outline: 2 Zaehlliste AUFTRAG pruefen
#Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "ZAEHL_2"
#Then the table has 2 rows
#
#Then field "gebeinh" has value "<gebeinh>" in rowspec "<row>"
#Then field "gebf" has value "<gebf>" in rowspec "<row>"
#Then field "behaelter^such" has value "<behaelter>" in row <row>
#Then field "platz" has value "<platz>" in row <row>
#And I close the current editor
#
#Examples: 2 Zaehlliste AUFTRAG pruefen
#| row | gebeinh | gebf | behaelter        | platz     |
#| 1   | Stück      | 1    |                   | F2       |
#| 2   | Stück      | 1    |                   | F1        |
#
#
#Scenario: 2 Inventur eroeffnen
#Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "ZAEHL_2" and menu choice "Ja"
#And I save the current editor
#
#Scenario: 2 Zaehlliste AUFTRAG bearbeiten
#Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL_2"
#
#And I create a new row at the end of the table
#And I set field "artikel" to "EINKAUF_3001" in row !lastRow
#And I set field "platz" to "F2" in row !lastRow
#And setting field "behaelter" to "EKTEIL1A" in row !lastRow throws the exception "8472"
#And I close the current editor
#
#Scenario: 2 Bestandsabschluss AUFTRAG
#Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ZAEHL_2" and menu choice "Ja"
#And I save the current editor
#
#Scenario: 2 Abschluss AUFTRAG
#Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "TRANSFER" for record "ZAEHL_2" and menu choice "Ja"
#And I save the current editor
