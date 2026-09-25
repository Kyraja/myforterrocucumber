# *****************************************************************************
#  Name             : bewertung_bei_lbuch.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Verarbeitet manuelle Lagerbuchungen und prueft die Bewertungen
#
# *****************************************************************************
@persistent
Feature: bewertung_bei_lbuch
Background:
Given I set the fake date to "02.01.95"

# Neuen Artikel anlegen mit Bewertungsverfahren Preis des Zugangs/Nullbewertung
Scenario: 01 Bewertungsverfahren konfigurieren
Given I open an editor "firma" from table "(Company):(ValuationConfiguration)" with command "UPDATE" for record "10"
And I append rows
  | bewverf | bewab             | bewzu         |
  | 5       | Preis des Zugangs | Nullbewertung |
And I save the current editor


Scenario: 02 Stammdaten anlegen - Lager
Given I open an editor "MATERIAL" from table "(Warehouse):(Warehouse)" with command "STORE" for record "MATERIAL"
And I set fields
    | such     | MATERIAL                |
    | namebspr | Materiallager Fertigung |
    | lgruppe  | KARLSRUHE               |
    | disporel | ja                      |
    | lnullm   | nein                    |
And I save the current editor


Scenario Outline: 03 Stammdaten anlegen - Lagerplaetze
Given I open an editor "<suchw>" from table "(Location):(Location)" with command "STORE" for record "<suchw>"
And I set fields
    | such     | <suchw>   |
    | namebspr | <name>    |
    | lager    | <lager>   |
    | disporel | <dispo>   |
    | zuplatz  | <zuplatz> |
    | abplatz  | <abplatz> |
And I save the current editor

Examples:
| suchw | name               | lager     | dispo | zuplatz | abplatz |
| LP1   | Material, Platz 01 | !MATERIAL | ja    | ja      | ja      |
| LP2   | Material, Platz 02 | !MATERIAL | nein  | nein    | nein    |
| LP3   | Material, Platz 03 | !MATERIAL | nein  | nein    | nein    |


Scenario: 04 Stammdaten anlegen - Artikel
Given I open an editor "BANANE" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
    | such      | BANANE     |
    | ekbewverf | 5          |
And I save the current editor


Scenario: 05 Zugaenge auf LP1 buchen
And I post a receipt via ManualStockAdjustment for Product "BANANE" and quantity "1" on StorageLocation "LP1" with document "Z10" and price "0.0"
And I post a receipt via ManualStockAdjustment for Product "BANANE" and quantity "3" on StorageLocation "LP1" with document "Z11" and price "0.0"
And I post a receipt via ManualStockAdjustment for Product "BANANE" and quantity "4" on StorageLocation "LP1" with document "Z12" and price "0.0"
And I post a receipt via ManualStockAdjustment for Product "BANANE" and quantity "2" on StorageLocation "LP1" with document "Z13" and price "0.0"


Scenario: 06 Umbuchung von LP1 auf LP3
Given I open an editor "UM10" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BANANE    |
    | buart     | Umbuchung |
    | beleg     | UM10      |
    | beldat    | .         |
And I append rows
    | mge | platz | platz2 |
    | 10  | LP1   | LP3    |
And I save the current editor


Scenario: 07 Abgaenge von LP3 buchen
Given I open an editor "AB10" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BANANE |
    | buart     | Abgang |
    | beleg     | AB10   |
    | beldat    | .      |
And I append rows
    | mge   | platz |
    | 3     | LP3   |
And I save the current editor

Given I open an editor "AB11" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BANANE |
    | buart     | Abgang |
    | beleg     | AB11   |
    | beldat    | .      |
And I append rows
    | mge   | platz |
    | 4     | LP3   |
And I save the current editor

Given I open an editor "AB12" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BANANE |
    | buart     | Abgang |
    | beleg     | AB12   |
    | beldat    | .      |
And I append rows
    | mge   | platz |
    | 3     | LP3   |
And I save the current editor
