# *****************************************************************************
#  Name             : storno_lbuch_mit_behaelter.feature
#  Autor            : sih
#  Verantwortlich   : sih
#  Kontrolle        : carue
#  Funktion         : Testet Storno von Lagerbuchungen mit Behaeltern
#
# *****************************************************************************
@persistent
Feature: Storno manuelle Lagerbuchung eines Artikel mit Behaelter

Background:
Given I set the fake date to "02.01.1995"
#  Test der manuellen Lagerbuchung mit Behaelter und des Stornos derselbigen

Scenario: Storno von LBuchungen mit behaelter
# Vorbereitung: Platzmengen E1 löschen, Behälter erstellen
Given I set StorageQuantity to zero for Product "E1" on StorageLocation "F1" with document "KORR1"
Given I create a Container "BEHAELTER_1" for packaging material "BEHAELTER" and search word "BEHAELTER_1"

# Lagerbuchungen 
Given I open an editor "LBuchung" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
    | nummer  | 1lbuch |
    | artikel | E1     |
    | buart   | Zugang |
    | beleg   | ZU1    |
    | beldat  | .      |
And I modify table
    | !row | mge | verw | behaelter    |
    | 1    | 10  | sih  | !BEHAELTER_1 |
And I save the current editor

## Lagerbuchung stornieren
And I switch the current editor to editor "LBuchung" with command "REVERSAL"
And I set field "beleg" to "storno"
And I save the current editor

Given I query StorageQuantity for Product "E1" on StorageLocation "F1"
Then StorageQuantity is zero

Then Container "BEHAELTER_1" is empty

