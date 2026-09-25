@persistent
Feature: VERSAND_BEHAELTER_SQRELOCATION_Behaelter_umlagern.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_SQRELOCATION_Behaelter_umlagern.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Umlagern mit Behaelter ueber IS SQRELOCATION
#  ref				: ref_la_sqrelocation_cu
# *****************************************************************************

Background:
Given I set the fake date to "02.01.95"


@testvorbereitung
Scenario Outline: Lagerplaetze
Given I open an editor "<editor>" from table "<table>" with command "STORE" for record "<such>"
And I set fields
    | such     | <such>     |
    | namebspr | <namebspr> |
    | lager    | <lager>    |
    | abplatz  | ja         |
And I save the current editor

Examples: Lagerplaetze
| editor     | table                 | such      | namebspr                         | lager |
| Lagerplatz | (Location):(Location) | LP-ZU     | Neuer Zugangslagerplatz          | L3    |
| Lagerplatz | (Location):(Location) | LP-AB     | Neuer Abgangslagerplatz          | L3    |
| Lagerplatz | (Location):(Location) | LP-TAUSCH | Artikel auf gleichen LP umbuchen | L1    |

@testvorbereitung
Scenario Outline: Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such         | <such>             |
    | namebspr     | <namebspr>         |
    | dispoa       | <dispoa>           |
    | chverfolgung | Chargenverfolgung  |
    | chimlager    | ja                 |
And I save the current editor

Examples: Artikel
| such            | namebspr                     | dispoa          |
| SQRELOC-1       | Umlagerungsartikel 1         | auftragsbezogen |
| SQRELOC-2       | Umlagerungsartikel 2         | auftragsbezogen |
| SQRELOC-3       | Fehlermeldungen pruefen      | auftragsbezogen |
| SQRELOC-NEG     | Negative Bestaende           | auftragsbezogen |
| SQRELOC_BEH-1   | Artikel 1 in Behaelter       | auftragsbezogen |
| SQRELOC_BEH-2   | Artikel 2 in Behaelter       | auftragsbezogen |
| SQRELOC_BEH-3   | Fehler Behaelter pruefen     | auftragsbezogen |
| SQRELOC_BEH-NEG | Negative Bestaende Behaelter | auftragsbezogen |

@testvorbereitung
Scenario: Baugruppe mit zwei Komponenten und zwei Arbeitsgaengen
Given I open an editor "BG3-BEDARF" from table "(Part):(Product)" with command "STORE" for record "BG3-BEDARF"
And I set fields
    | such      | BG3-BEDARF             |
    | namebspr  | Zwei Komp und zwei AGs |
    | bsart     | Eigenfertigung         |
And I delete all rows
And I append rows
    | elex         | anzahl    |
    | EK1-BEDARF   | 1         |
    | A AG-LOHN1   | 1         |
    | EK2-BEDARF   | 1         |
    | A AG-LOHN2   | 1         |
And I save the current editor

@testvorbereitung
Scenario Outline: Projekte anlegen
Given I open an editor "<such>" from table "(Transaction):(Project)" with command "STORE" for record "<such>"
And I set fields
    | such     | <such>     |
    | namebspr | <namebspr> |
And I save the current editor

Examples: Projekte
| such           | namebspr               |
| UMBUCHUNG1     | Umbuchung SQRELOCATION |
| UMBUCHUNG2     | Umbuchung SQRELOCATION |
| UMBUCHUNG_BEH1 | Umbuchung SQRELOCATION |
| UMBUCHUNG_BEH2 | Umbuchung SQRELOCATION |

@testvorbereitung
Scenario: Chargen anlegen
Given I create a Lot "CH_SQRELOC-1" for Product "SQRELOC-1"
Given I create a Lot "CH_SQRELOC-2" for Product "SQRELOC-2"
Given I create a Lot "CH_SQRELOC-3" for Product "SQRELOC-3"
Given I create a Lot "CH_SQRELOC-NEG" for Product "SQRELOC-NEG"
Given I create a Lot "CH_SQRELOC_BEH-1" for Product "SQRELOC_BEH-1"
Given I create a Lot "CH_SQRELOC_BEH-2" for Product "SQRELOC_BEH-2"
Given I create a Lot "CH_SQRELOC_BEH-3" for Product "SQRELOC_BEH-3"
Given I create a Lot "CH_SQRELOC_BEH-NEG" for Product "SQRELOC_BEH-NEG"

    
##################################################################################################################


Scenario Outline: 01 Bestaende ohne Behaelter koennen nicht umgelagert werden
# Lagerzugaenge buchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | SQ-01     |
    | beldat  | .         |
And I append rows
    | mge | platz2 | verw        |
    | 10  | LP-ZU  | KEINECHANCE |
And I save the current editor

Examples:
| artikel   |
| SQRELOC-1 |
| SQRELOC-2 |
| SQRELOC-3 |

Scenario: 01 Bestaende ohne Behaelter koennen nicht umgelagert werden
# Schreibschutz auf Feldern in SQRELOCATION
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr    | SQ-01              |
    | lplatz   | LP-ZU              |
    | verw     | KEINECHANCE        |
    | workflow | Behaelter umlagern |
And I press start
Then field "tmge" is not modifiable in row 1
Then field "tmge" is not modifiable in row 2
Then field "tmge" is not modifiable in row 3
Then field "tlplatzzu" is not modifiable in row 1
Then field "tlplatzzu" is not modifiable in row 2
Then field "tlplatzzu" is not modifiable in row 3
And I close the current editor


Scenario Outline: 02 Bestaende koennen nicht auf den Lagerplatz umgelagert werden, auf dem sie bereits liegen
Given I set the fake date to "03.01.95"
# Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | SQ-02     |
    | beldat  | .         |
And I append rows
    | mge | platz2 | verw          | charge2  | behaelter          |
    | 10  | LP-ZU  | GLEICHERPLATZ | <charge> | <behaelter_editor> |
And I save the current editor

Examples:
| artikel       | charge            | behaelter          | behaelter_editor     |
| SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1 | GLEICHERPLATZ_1    | !GLEICHERPLATZ_1^id  |
| SQRELOC_BEH-2 |                   | GLEICHERPLATZ_2    | !GLEICHERPLATZ_2^id  |
| SQRELOC_BEH-3 |                   | GLEICHERPLATZ_3    | !GLEICHERPLATZ_3^id  |

Scenario: 02 Bestaende koennen nicht auf den Lagerplatz umgelagert werden, auf dem sie bereits liegen
# Schreibschutz auf Feldern in SQRELOCATION
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr    | SQ-02              |
    | lplatz   | LP-ZU              |
    | verw     | GLEICHERPLATZ      |
    | workflow | Behaelter umlagern  |
And I press start
And I set field "tlplatzzu" to "LP-ZU" in row 1
And I set field "tmark" to "ja" in row 1
Then field "tlplatzzu" is empty in row 1
And I set field "tlplatzzu" to "LP-ZU" in row 2
And I set field "tmark" to "ja" in row 2
Then field "tlplatzzu" is empty in row 2
And I set field "tlplatzzu" to "LP-ZU" in row 3
And I set field "tmark" to "ja" in row 3
Then field "tlplatzzu" is empty in row 3
And I close the current editor


Scenario Outline: 03 Ein Behaelter mit mehreren gleichen Artikeln umlagern
Given I set the fake date to "04.01.95"
# Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SQRELOC_BEH-1 |
    | buart   | Zugang        |
    | beleg   | SQ-04         |
    | beldat  | .             |
And I append rows
    | mge | platz2 | verw   | charge2   | projekt   | behaelter          |
    | 10  | F1     | <verw> | <charge2> | <projekt> | <behaelter_editor> |
And I save the current editor
#
Examples:
| verw        | charge2           | projekt        | behaelter   | behaelter_editor    |
| GLEICHERBEH | !CH_SQRELOC_BEH-1 |                | GLEICHERBEH | !GLEICHERBEH^id     |
| GLEICHERBEH |                   | UMBUCHUNG_BEH1 |             | !GLEICHERBEH^id     |
|             |                   |                |             | !GLEICHERBEH^id     |


Scenario Outline: 04 Ein Behaelter mit mehreren unterschiedlichen Artikeln umlagern
Given I set the fake date to "05.01.95"
# Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | SQ-05     |
    | beldat  | .         |
And I append rows
    | mge | platz2 | verw   | charge2   | projekt   | behaelter             |
    | 10  | F1     | <verw> | <charge2> | <projekt> | <behaelter_editor>    |
And I save the current editor

Examples:
| artikel       | verw       | charge2           | projekt        | behaelter    | behaelter_editor  |
| SQRELOC_BEH-1 | VERARTIKEL | !CH_SQRELOC_BEH-1 |                | VERARTIKEL   | !VERARTIKEL       |
| SQRELOC_BEH-2 | VERARTIKEL |                   | UMBUCHUNG_BEH1 |              | !VERARTIKEL       |
| SQRELOC_BEH-3 |            |                   |                |              | !VERARTIKEL       |

Scenario: 04 Ein Behaelter mit mehreren unterschiedlichen Artikeln umlagern
Given I set the fake date to "05.01.95"
# Umbuchung SQRELOCATION
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr     | SQ-05              |
    | container | !VERARTIKEL^id     |
    | lplatz    | F1                 |
    | workflow  | Behaelter umlagern |
And I press start
And I set field "tlplatzzu" to "LP-ZU" in row 1
Then field "tlplatzzu" has value "LP-ZU" in row 2
Then field "tlplatzzu" has value "LP-ZU" in row 3
And I set field "tmark" to "ja" in row 1
And I press button "umbuch"
And I close the current editor

# Behaelter pruefen
Given I switch the current editor to editor "VERARTIKEL" with command "VIEW"
Then field "platz" has value "LP-ZU"
Then table has values
    | charge^such            | projekt        | verw       |
    | !CH_SQRELOC_BEH-1^such |                | VERARTIKEL |
    |                        | UMBUCHUNG_BEH1 | VERARTIKEL |
    |                        |                |            |
And I close the current editor

Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "LP-ZU"
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK2-BEDARF" on StorageLocation "LP-ZU"
Given I set StorageQuantity to zero for Product "EK2-BEDARF" on StorageLocation "F1"


Scenario Outline: 05 Mehrere Artikel in einem Behaelter koennen nicht auf zwei unterschiedliche Lagerplaetze umgelagert werden
Given I set the fake date to "06.01.95"
# Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | SQ-06     |
    | beldat  | .         |
And I append rows
    | mge | platz2 | verw   | charge2   | behaelter          |
    | 10  | F1     | <verw> | <charge2> | <behaelter_editor> |
And I save the current editor

Examples:
| artikel       | verw       | charge2           | behaelter     | behaelter_editor   |
| SQRELOC_BEH-1 | VERARTIKEL | !CH_SQRELOC_BEH-1 | ZWEIPLAETZE   | !ZWEIPLAETZE^id    |
| SQRELOC_BEH-2 | VERARTIKEL |                   |               | !ZWEIPLAETZE^id    |

Scenario: 05 Mehrere Artikel in einem Behaelter koennen nicht auf zwei unterschiedliche Lagerplaetze umgelagert werden
Given I set the fake date to "06.01.95"
# Umbuchung SQRELOCATION
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr     | SQ-06                 |
    | container | !ZWEIPLAETZE^id       |
    | lplatz    | F1                    |
    | workflow  | Behaelter umlagern    |
And I press start
And I set field "tlplatzzu" to "LP-ZU" in row 1
And I set field "tlplatzzu" to "LP-TAUSCH" in row 2
Then field "tlplatzzu" has value "LP-TAUSCH" in row 1
And I close the current editor

Scenario: 05 Selektion nach Betriebsauftrag Material in Behaeltern an, Behaelter wierden umgelagert
Given I set the fake date to "06.01.95"
# Lagerzugaenge buchen und Betreiebsauftrag erstellen
Given I create a Container "MATERIAL1" for packaging material "BEHAELTER"
Given I create a Container "MATERIAL2" for packaging material "BEHAELTER"

Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "20" on StorageLocation "F2" with document "SQ-051" and Container "!MATERIAL1"
Given I post a receipt via ManualStockAdjustment for Product "EK2-BEDARF" and quantity "10" on StorageLocation "F2" with document "SQ-052" and Container "!MATERIAL2"
Given I post a receipt via ManualStockAdjustment for Product "EK2-BEDARF" and quantity "10" on StorageLocation "F2" with document "SQ-053"

Given I create a work order "GUTMGE1" for Product "BG3-BEDARF" with quantity "20" and search word "GUTMGE1"

# Für Material in Behaeltern ist tlplatzzu schreibbar, tmge und tbehzugang sind schreibgeschützt
# Für Material ohne Behaelter sind alle Felder schreibgeschützt
Given I open the infosystem "SQRELOCATION"
And I set fields
    | workflow  | Behaelter umlagern |
    | ba        | GUTMGE1000        |
And I press start
Then field "tmge" is not modifiable in row 2
Then field "tlplatzzu" is not modifiable in row 2
Then field "tbehzugang" is not modifiable in row 2
And I modify table
    | tlplatzzu | !row  |
    | F1        | 1     |
    | F1        | 3     |
And I press button "allmark"
And I press button "umbuch"

Then table has values
| tartikel      | tlplatz   | tbehzugang            |
| EK1-BEDARF    | F1        | !MATERIAL1^nummer     |
| EK2-BEDARF    | F1        | !MATERIAL2^nummer     |
| EK2-BEDARF    | F2        |                       |
And I close the current editor

# BA loeschen, Material auf 0 setzen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "GUTMGE1000"
And I respond with answer "JA" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor

Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F2"
Given I set StorageQuantity to zero for Product "EK2-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK2-BEDARF" on StorageLocation "F2"


Scenario: 06 Ein gemischter Behaelter kann nicht umgelagert werden
Given I set the fake date to "07.01.95"
# Lagerzugaenge buchen und Betriebsauftrag erstellen
Given I create a Container "MATERIAL3" for packaging material "BEHAELTER"
Given I create a Container "MATERIAL4" for packaging material "BEHAELTER"

Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "SQ-061" and Container "!MATERIAL3"
Given I post a receipt via ManualStockAdjustment for Product "EK2-BEDARF" and quantity "10" on StorageLocation "F1" with document "SQ-062" and Container "!MATERIAL3"
Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "SQ-063" and Container "!MATERIAL4"
Given I post a receipt via ManualStockAdjustment for Product "EK3-BEDARF" and quantity "10" on StorageLocation "F1" with document "SQ-064" and Container "!MATERIAL4"

Given I create a work order "GUTMGE2" for Product "BG3-BEDARF" with quantity "20" and search word "GUTMGE2"

# Bei gemischten Behaeltern sind die Felder tmge, tlplatzzu und tbehzugang schreibgeschuetzt
Given I open the infosystem "SQRELOCATION"
And I set fields
    | workflow  | Behaelter umlagern |
    | ba        | GUTMGE2000         |
And I press start
Then field "tlplatzzu" is not modifiable in row 1
Then field "tgembehaelter" has value "ja" in row 1
Then field "tlplatzzu" is not modifiable in row 2
Then field "tgembehaelter" has value "ja" in row 2
Then field "tlplatzzu" is not modifiable in row 3
Then field "tgembehaelter" has value "ja" in row 3
And I close the current editor

# BA loeschen, Material auf 0 setzen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "GUTMGE2000"
And I respond with answer "JA" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor
