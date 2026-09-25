@persistent
Feature: VERSAND_BEHAELTER_SQRELOCATION_Behaelterentnahme.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_SQRELOCATION_Behaelterentnahme.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Entnahmen aus Behaeltern ueber IS SQRELOCATION
#  ref              : ref_la_sqrelocation_cu
# *****************************************************************************

Background:
Given I set the fake date to "01.02.95"


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
| Lagerplatz | (Location):(Location) | LP1-PACK  | Packmittelplatz                  | L1    |

@testvorbereitung
Scenario Outline: Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such          | <such>            |
    | namebspr      | <namebspr>        |
    | dispoa        | <dispoa>          |
    | chverfolgung  | Chargenverfolgung |
    | chimlager     | ja                |
And I save the current editor

Examples: Artikel
| such            | namebspr                        | dispoa          |
| SQRELOC-1       | Umlagerungsartikel 1            | auftragsbezogen |
| SQRELOC-2       | Umlagerungsartikel 2            | auftragsbezogen |
| SQRELOC-3       | Fehlermeldungen pruefen         | auftragsbezogen |
| SQRELOC-NEG     | Negative Bestaende              | auftragsbezogen |
| SQRELOC_BEH-1   | Artikel 1 in Behaelter          | auftragsbezogen |
| SQRELOC_BEH-2   | Artikel 2 in Behaelter          | auftragsbezogen |
| SQRELOC_BEH-3   | Fehlermeldung Behaelter         | auftragsbezogen |
| SQRELOC_BEH-NEG | Negative Bestaende Behaelter    | auftragsbezogen |

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
#Neues Chargenhandling: Es darf eine externe Chargennummer nur einmal geben
#Given I create a Lot "CH_SQRELOC-1" for Product "SQRELOC-1"
#Given I create a Lot "CH_SQRELOC-2" for Product "SQRELOC-2"
#Given I create a Lot "CH_SQRELOC-3" for Product "SQRELOC-3"
#Given I create a Lot "CH_SQRELOC-NEG" for Product "SQRELOC-NEG"
Given I create a Lot "CH_SQRELOC_BEH-1.1" for Product "SQRELOC_BEH-1"
#Given I create a Lot "CH_SQRELOC_BEH-2" for Product "SQRELOC_BEH-2"
Given I create a Lot "CH_SQRELOC_BEH-3.1" for Product "SQRELOC_BEH-3"
#Given I create a Lot "CH_SQRELOC_BEH-NEG" for Product "SQRELOC_BEH-NEG"

@testvorbereitung
Scenario: Packmittelplatz als Standardplatz festlegen
Given I open an editor "Behaelter" from table "(Part):(Product)" with command "UPDATE" for record "BEHAELTER"
And I set field "abplatz" to "LP1-PACK"
And I set field "zuplatz" to "LP1-PACK"
And I save the current editor

##################################################################################################################


Scenario: 01 Feld Zugangsbehaelter tbehzugang ist schreibgeschuetzt
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "SCHREIBSCHUTZ" for packaging material "BEHAELTER" and search word "SCHREIBSCHUTZ"

Given I post a receipt via ManualStockAdjustment for Product "SQRELOC_BEH-1" and quantity "10" on StorageLocation "F1" with document "01" and Container "!SCHREIBSCHUTZ^id"

# Schreibschutz pruefen
Given I open the infosystem "SQRELOCATION"
And I set fields
    | container     | !SCHREIBSCHUTZ^id |
    | workflow      | Behaelterentnahme |
    | belnr         | SQ-B01            |
    | beldat        | .                 |
And I press start
Then field "tbehzugang" is not modifiable in row 1
And I close the current editor


Scenario: 02 Behaelter mit je einem Artikel auf diesem Lagerplatz entnehmen
Given I set the fake date to "02.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "LEEREN_EINARTIKEL_1" for packaging material "BEHAELTER" and search word "LEEREN_EINARTIKEL_1"
Given I create a Container "LEEREN_EINARTIKEL_2" for packaging material "BEHAELTER" and search word "LEEREN_EINARTIKEL_2"
Given I create a Container "LEEREN_EINARTIKEL_3" for packaging material "BEHAELTER" and search word "LEEREN_EINARTIKEL_3"
Given I create a Container "LEEREN_EINARTIKEL_4" for packaging material "BEHAELTER" and search word "LEEREN_EINARTIKEL_4"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SQRELOC_BEH-1 |
    | buart   | Zugang        |
    | beleg   | 02            |
    | beldat  | .             |
And I append rows
    | platz2    | mge | verw       | charge2             | projekt         | behaelter            |
    | LP-TAUSCH | 10  | TAUSCH_B02 | !CH_SQRELOC_BEH-1.1 |                 | !LEEREN_EINARTIKEL_1 |
    | LP-TAUSCH | 10  | TAUSCH_B02 |                     |                 | !LEEREN_EINARTIKEL_2 |
    | LP-TAUSCH | 10  | TAUSCH_B02 |                     |                 | !LEEREN_EINARTIKEL_3 |
    | LP-TAUSCH | 10  | TAUSCH_B02 |                     | !UMBUCHUNG_BEH1 | !LEEREN_EINARTIKEL_4 |
And I save the current editor

# Artikel entnehmen
Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel  | SQRELOC_BEH-1     |
    | verw     | TAUSCH_B02        |
    | workflow | Behaelterentnahme |
    | belnr    | SQ-B02            |
    | beldat   | .                 |
And I press start
And I modify table
    | !row  | tlplatzzu |
    | 1     | LP-TAUSCH |
    | 2     | LP-TAUSCH |
    | 3     | LP-TAUSCH |
    | 4     | LP-TAUSCH |
And I press button "allmark"
And I press button "umbuch"
And I save the current editor

# Lagerjournal pruefen
And I open the infosystem "LJ"
And I set fields
    | adatum    | .             |
    | beleg     | SQ-B02        |
    | richtung  | rueckwaerts   |
And I press start
Then table has values
    | art       | nplatz   | detursache                       |
    | BEHAELTER | LP1-PACK | Automatische Packmittelkorrektur |
    | BEHAELTER | LP1-PACK | Automatische Packmittelkorrektur |
    | BEHAELTER | LP1-PACK | Automatische Packmittelkorrektur |
    | BEHAELTER | LP1-PACK | Automatische Packmittelkorrektur |
And I close the current editor

# Behaelter pruefen
Then Container "LEEREN_EINARTIKEL_1" is empty
Then Container "LEEREN_EINARTIKEL_2" is empty
Then Container "LEEREN_EINARTIKEL_3" is empty
Then Container "LEEREN_EINARTIKEL_4" is empty


Scenario: 03 Behaelter mit mehreren gleichen Artikeln auf diesem Lagerplatz entnehmen
Given I set the fake date to "03.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "LEEREN_MEHRARTIKEL_1" for packaging material "BEHAELTER" and search word "LEEREN_MEHRARTIKEL_1"
Given I create a Container "LEEREN_MEHRARTIKEL_2" for packaging material "BEHAELTER" and search word "LEEREN_MEHRARTIKEL_2"
Given I create a Container "LEEREN_MEHRARTIKEL_3" for packaging material "BEHAELTER" and search word "LEEREN_MEHRARTIKEL_3"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SQRELOC_BEH-1 |
    | buart   | Zugang        |
    | beleg   | 03            |
    | beldat  | .             |
And I append rows
    | platz2    | mge | verw       | charge2             | projekt         | behaelter             |
    | LP-TAUSCH | 10  | TAUSCH_B03 | !CH_SQRELOC_BEH-1.1 | !dontChange     | !LEEREN_MEHRARTIKEL_1 |
    | LP-TAUSCH | 10  | TAUSCH_B03 | !dontChange         | !dontChange     | !LEEREN_MEHRARTIKEL_1 |
    | LP-TAUSCH | 10  | TAUSCH_B03 | !dontChange         | !UMBUCHUNG_BEH1 | !LEEREN_MEHRARTIKEL_2 |
    | LP-TAUSCH | 10  | TAUSCH_B03 | !dontChange         | !dontChange     | !LEEREN_MEHRARTIKEL_2 |
    | LP-TAUSCH | 10  | TAUSCH_B03 | !dontChange         | !UMBUCHUNG_BEH1 | !LEEREN_MEHRARTIKEL_3 |
    | LP-TAUSCH | 10  | TAUSCH_B03 | !dontChange         | !dontChange     | !LEEREN_MEHRARTIKEL_3 |
    | LP-TAUSCH | 10  | TAUSCH_B03 | !CH_SQRELOC_BEH-1.1 | !dontChange     | !LEEREN_MEHRARTIKEL_3 |
And I save the current editor

# Artikel entnehmen
Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel  | SQRELOC_BEH-1     |
    | verw     | TAUSCH_B03        |
    | workflow | Behaelterentnahme |
    | belnr    | SQ-B03            |
    | beldat   | .                 |
And I press start
And I modify table
    | !row  | tlplatzzu | tmark |
    | 1     | LP-TAUSCH | ja    |
    | 2     | LP-TAUSCH | ja    |
    | 3     | LP-TAUSCH | ja    |
And I press button "umbuch"

Then table has values
    |tartikel      | tbehzugang | tlplatz   | gebmge | !row  |
    |SQRELOC_BEH-1 |            | LP-TAUSCH | 30     |  1    |
    |SQRELOC_BEH-1 |            | LP-TAUSCH | 20     |  2    |
    |SQRELOC_BEH-1 |            | LP-TAUSCH | 20     |  3    |       
And I save the current editor

# Behaelter pruefen
Then Container "LEEREN_MEHRARTIKEL_1" is empty
Then Container "LEEREN_MEHRARTIKEL_2" is empty
Then Container "LEEREN_MEHRARTIKEL_3" is empty


Scenario Outline: 04 Behaelter mit verschiedenen Artikeln auf diesem Lagerplatz entnehmen
Given I set the fake date to "04.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | 04        |
    | beldat  | .         |
And I append rows
    | mge   | platz2    | verw          | charge2   | projekt   | behaelter             |
    | 10    | LP-TAUSCH | TAUSCH_B04    | <charge2> | <projekt> | <behaelter_editor>    |
And I save the current editor

Examples: Lagerbuchung
| behaelter            | artikel       | charge2                | projekt         | behaelter_editor     |
| LEEREN_04_ARTIKEL_1  | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.1    | !UMBUCHUNG1     | !LEEREN_04_ARTIKEL_1 |
| LEEREN_04_ARTIKEL_2  | SQRELOC_BEH-2 | !dontChange            | !dontChange     | !LEEREN_04_ARTIKEL_2 |
| LEEREN_04_ARTIKEL_3  | SQRELOC_BEH-3 | !CH_SQRELOC_BEH-3.1    | !dontChange     | !LEEREN_04_ARTIKEL_3 |
| LEEREN_04_ARTIKEL_4  | SQRELOC_BEH-2 | !dontChange            | !UMBUCHUNG_BEH1 | !LEEREN_04_ARTIKEL_4 |

Scenario: 04 Behaelter mit verschiedenen Artikeln auf diesem Lagerplatz entnehmen
Given I set the fake date to "04.02.95"
# Inhalte umbuchen
Given I open the infosystem "SQRELOCATION"
And I set fields
    | verw     | TAUSCH_B04        |
    | workflow | Behaelterentnahme |
    | belnr    | SQ-B04            |
    | beldat   | .                 |
And I press start
And I modify table
    | !row  | tlplatzzu | tmark |
    | 1     | LP-TAUSCH | ja    |
    | 2     | LP-TAUSCH | ja    |
    | 3     | LP-TAUSCH | ja    |
    | 4     | LP-TAUSCH | ja    |
And I press button "umbuch"
And I save the current editor

# Lagerjournal pruefen
And I open the infosystem "LJ"
And I set fields
    | adatum    | .             |
    | beleg     | SQ-B04        |
    | richtung  | rueckwaerts   |
And I press start
Then table has values
    | art       | nplatz   | detursache                       |
    | BEHAELTER | LP1-PACK | Automatische Packmittelkorrektur |
    | BEHAELTER | LP1-PACK | Automatische Packmittelkorrektur |
    | BEHAELTER | LP1-PACK | Automatische Packmittelkorrektur |
    | BEHAELTER | LP1-PACK | Automatische Packmittelkorrektur |
And I close the current editor

# Behaelter pruefen
Then Container "LEEREN_04_ARTIKEL_1" is empty
Then Container "LEEREN_04_ARTIKEL_2" is empty
Then Container "LEEREN_04_ARTIKEL_3" is empty
Then Container "LEEREN_04_ARTIKEL_4" is empty


Scenario Outline: 05 Behaelter mit mehreren Artikeln auf diesem Lagerplatz entnehmen
Given I set the fake date to "05.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | 05        |
    | beldat  | .         |
And I append rows
    | mge   | platz2    | verw          | charge2   | projekt   | behaelter             |
    | 10    | LP-TAUSCH | TAUSCH_B05    | <charge2> | <projekt> | <behaelter_editor>    |
And I save the current editor

Examples: Lagerbuchung
| behaelter              | artikel       | charge2             | projekt         | behaelter_editor        |
| LEEREN_VERSCHARTIKEL_1 | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG_BEH1 | !LEEREN_VERSCHARTIKEL_1 |
| LEEREN_VERSCHARTIKEL_1 | SQRELOC_BEH-2 | !dontChange         | !UMBUCHUNG_BEH1 | !LEEREN_VERSCHARTIKEL_1 |
| LEEREN_VERSCHARTIKEL_2 | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG_BEH2 | !LEEREN_VERSCHARTIKEL_2 |
| LEEREN_VERSCHARTIKEL_2 | SQRELOC_BEH-3 | !dontChange         | !dontChange     | !LEEREN_VERSCHARTIKEL_2 |
| LEEREN_VERSCHARTIKEL_3 | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG_BEH1 | !LEEREN_VERSCHARTIKEL_3 |
| LEEREN_VERSCHARTIKEL_3 | SQRELOC_BEH-2 | !dontChange         | !UMBUCHUNG_BEH2 | !LEEREN_VERSCHARTIKEL_3 |

Scenario: 05 Behaelter mit mehreren Artikeln auf diesem Lagerplatz entnehmen
Given I set the fake date to "05.02.95"
# Artikel entnehmen
Given I open the infosystem "SQRELOCATION"
And I set fields
    | verw     | TAUSCH_B05        |
    | workflow | Behaelterentnahme |
    | belnr    | SQ-B05            |
    | beldat   | .                 |
And I press start
And I modify table
    | !row  | tlplatzzu    |
    | 1     | LP-TAUSCH    |
    | 2     | LP-TAUSCH    |
    | 3     | LP-TAUSCH    |
    | 4     | LP-TAUSCH    |
    | 5     | LP-TAUSCH    |
    | 6     | LP-TAUSCH    |
And I press button "allmark"
And I press button "umbuch"
And I save the current editor

# Behaelter pruefen
Then Container "LEEREN_VERSCHARTIKEL_1" is empty
Then Container "LEEREN_VERSCHARTIKEL_2" is empty
Then Container "LEEREN_VERSCHARTIKEL_3" is empty


Scenario: 06 Behaelter mit einem Artikel auf anderen Lagerplatz entnehmen
Given I set the fake date to "06.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "LEEREN_EINARTIKEL_1" for packaging material "BEHAELTER" and search word "LEEREN_EINARTIKEL_1"
Given I create a Container "LEEREN_EINARTIKEL_2" for packaging material "BEHAELTER" and search word "LEEREN_EINARTIKEL_2"
Given I create a Container "LEEREN_EINARTIKEL_3" for packaging material "BEHAELTER" and search word "LEEREN_EINARTIKEL_3"
Given I create a Container "LEEREN_EINARTIKEL_4" for packaging material "BEHAELTER" and search word "LEEREN_EINARTIKEL_4"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SQRELOC_BEH-1 |
    | buart   | Zugang        |
    | beleg   | 06            |
    | beldat  | .             |
And I append rows
    | platz2 | mge | verw       | charge2             | projekt         | behaelter            |
    | F1     | 10  | TAUSCH_B06 | !CH_SQRELOC_BEH-1.1 | !dontChange     | !LEEREN_EINARTIKEL_1 |
    | F1     | 10  | TAUSCH_B06 | !dontChange         | !dontChange     | !LEEREN_EINARTIKEL_2 |
    | F1     | 10  | TAUSCH_B06 | !dontChange         | !dontChange     | !LEEREN_EINARTIKEL_3 |
    | F1     | 10  | TAUSCH_B06 | !dontChange         | !UMBUCHUNG_BEH1 | !LEEREN_EINARTIKEL_4 |
And I save the current editor

# Artikel entnehmen
Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel  | SQRELOC_BEH-1     |
    | verw     | TAUSCH_B06        |
    | workflow | Behaelterentnahme |
    | belnr    | SQ-B06            |
    | beldat   | .                 |
And I press start
And I modify table
    | !row  | tlplatzzu | tmark |
    | 1     | LP-ZU     | ja    |
    | 2     | LP-ZU     | ja    |
    | 3     | LP-ZU     | ja    |
    | 4     | LP-ZU     | ja    |
And I press button "umbuch"
And I save the current editor

# Lagerjournal pruefen
And I open the infosystem "LJ"
And I set fields
    | adatum    | .             |
    | beleg     | SQ-B06        |
    | richtung  | rueckwaerts   |
And I press start
Then table has values
    | !row  | art           | detursache            | nplatz    |
    | 2     | SQRELOC_BEH-1 | Manuelle Umbuchung    | LP-ZU     |
    | 5     | SQRELOC_BEH-1 | Manuelle Umbuchung    | LP-ZU     |
    | 8     | SQRELOC_BEH-1 | Manuelle Umbuchung    | LP-ZU     |
    | 11    | SQRELOC_BEH-1 | Manuelle Umbuchung    | LP-ZU     |
And I close the current editor

# Behaelter pruefen
Then Container "LEEREN_EINARTIKEL_1" is empty
Then Container "LEEREN_EINARTIKEL_2" is empty
Then Container "LEEREN_EINARTIKEL_3" is empty
Then Container "LEEREN_EINARTIKEL_4" is empty


Scenario: 07 Behaelter mit mehreren gleichen Artikeln auf anderen Lagerplatz entnehmen
Given I set the fake date to "07.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "LEEREN_MEHRARTIKEL_1" for packaging material "BEHAELTER" and search word "LEEREN_MEHRARTIKEL_1"
Given I create a Container "LEEREN_MEHRARTIKEL_2" for packaging material "BEHAELTER" and search word "LEEREN_MEHRARTIKEL_2"
Given I create a Container "LEEREN_MEHRARTIKEL_3" for packaging material "BEHAELTER" and search word "LEEREN_MEHRARTIKEL_3"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SQRELOC_BEH-1 |
    | buart   | Zugang        |
    | beleg   | 07            |
    | beldat  | .             |
And I append rows
    | platz2 | mge | verw       | charge2             | projekt         | behaelter             |
    | F1     | 10  | TAUSCH_B07 | !CH_SQRELOC_BEH-1.1 | !dontChange     | !LEEREN_MEHRARTIKEL_1 |
    | F1     | 10  | TAUSCH_B07 | !dontChange         | !dontChange     | !LEEREN_MEHRARTIKEL_1 |
    | F1     | 10  | TAUSCH_B07 | !dontChange         | !UMBUCHUNG_BEH1 | !LEEREN_MEHRARTIKEL_2 |
    | F1     | 10  | TAUSCH_B07 | !dontChange         | !dontChange     | !LEEREN_MEHRARTIKEL_2 |
    | F1     | 10  | TAUSCH_B07 | !dontChange         | !UMBUCHUNG_BEH1 | !LEEREN_MEHRARTIKEL_3 |
    | F1     | 10  | TAUSCH_B07 | !dontChange         | !dontChange     | !LEEREN_MEHRARTIKEL_3 |
    | F1     | 10  | TAUSCH_B07 | !CH_SQRELOC_BEH-1.1 | !dontChange     | !LEEREN_MEHRARTIKEL_3 |
And I save the current editor

# Artikel entnehmen
Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel  | SQRELOC_BEH-1     |
    | verw     | TAUSCH_B07        |
    | workflow | Behaelterentnahme |
    | belnr    | SQ-B07            |
    | beldat   | .                 |
And I press start
And I modify table
    | !row  | tlplatzzu | tmark |
    | 1     | LP-ZU     | ja    |
    | 2     | LP-ZU     | ja    |
    | 3     | LP-ZU     | ja    |
    | 4     | LP-ZU     | ja    |
    | 5     | LP-ZU     | ja    |
    | 6     | LP-ZU     | ja    |
    | 7     | LP-ZU     | ja    |
And I press button "umbuch"
And I save the current editor

# Lagerjournal pruefen
And I open the infosystem "LJ"
And I set fields
    | adatum    | .             |
    | beleg     | SQ-B07        |
    | richtung  | rueckwaerts   |
And I press start
Then table has values
    | !row  | art           | detursache            | nplatz    |
    | 2     | SQRELOC_BEH-1 | Manuelle Umbuchung    | LP-ZU     |
    | 5     | SQRELOC_BEH-1 | Manuelle Umbuchung    | LP-ZU     |
    | 7     | SQRELOC_BEH-1 | Manuelle Umbuchung    | LP-ZU     |
And I close the current editor

# Behaelter pruefen
Then Container "LEEREN_MEHRARTIKEL_1" is empty
Then Container "LEEREN_MEHRARTIKEL_2" is empty
Then Container "LEEREN_MEHRARTIKEL_3" is empty


Scenario Outline: 08 Behaelter mit verschiedenen Artikeln auf anderen Lagerplatz entnehmen
Given I set the fake date to "08.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | SQ-BEH08  |
    | beldat  | .         |
And I append rows
    | mge   | platz2    | verw          | charge2   | projekt   | behaelter             |
    | 10    | F1        | TAUSCH_B08    | <charge2> | <projekt> | <behaelter_editor>    |
And I save the current editor

Examples: Lagerbuchung
| behaelter           | artikel       | charge2             | projekt         | behaelter_editor     |
| LEEREN_08_ARTIKEL_1 | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG1     | !LEEREN_08_ARTIKEL_1 |
| LEEREN_08_ARTIKEL_2 | SQRELOC_BEH-2 | !dontChange         | !dontChange     | !LEEREN_08_ARTIKEL_2 |
| LEEREN_08_ARTIKEL_3 | SQRELOC_BEH-3 | !CH_SQRELOC_BEH-3.1 | !dontChange     | !LEEREN_08_ARTIKEL_3 |
| LEEREN_08_ARTIKEL_4 | SQRELOC_BEH-2 | !dontChange         | !UMBUCHUNG_BEH1 | !LEEREN_08_ARTIKEL_4 |

Scenario: 08 Behaelter mit verschiedenen Artikeln auf anderen Lagerplatz entnehmen
Given I set the fake date to "08.02.95"
# Artikel entnehmen
Given I open the infosystem "SQRELOCATION"
And I set fields
    | verw     | TAUSCH_B08        |
    | workflow | Behaelterentnahme |
    | belnr    | SQ-B08            |
    | beldat   | .                 |
And I press start
And I modify table
    | !row  | tlplatzzu | tmark |
    | 1     | LP-ZU     | ja    |
    | 2     | LP-ZU     | ja    |
    | 3     | LP-ZU     | ja    |
    | 4     | LP-ZU     | ja    |
And I press button "umbuch"
And I save the current editor

# Lagerjournal pruefen
And I open the infosystem "LJ"
And I set fields
    | adatum    | .             |
    | beleg     | SQ-B08        |
    | richtung  | rueckwaerts   |
And I press start
Then table has values
    | !row  | art           | detursache                            | nplatz    |
    | 1     | BEHAELTER     | Automatische Packmittelkorrektur      | LP1-PACK  |
    | 2     | SQRELOC_BEH-3 | Manuelle Umbuchung                    | LP-ZU     |
And I close the current editor

# Behaelter pruefen
Then Container "!LEEREN_08_ARTIKEL_1" is empty
Then Container "!LEEREN_08_ARTIKEL_2" is empty
Then Container "!LEEREN_08_ARTIKEL_3" is empty
Then Container "!LEEREN_08_ARTIKEL_4" is empty


Scenario Outline: 09 Behaelter mit mehreren verschiedenen Artikeln auf anderen Lagerplatz entnehmen
# Behaelter anlegen und Lagerzugaenge buchen
Given I set the fake date to "09.02.95"
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | 09        |
    | beldat  | .         |
And I append rows
    | mge   | platz2    | verw          | charge2   | projekt       | behaelter             |
    | 10    | F1        | TAUSCH_B09    | <charge2> | <projekt>     | <behaelter_editor>    |
And I save the current editor

Examples: Lagerbuchung
| behaelter              | artikel       | charge2             | projekt         | behaelter_editor        |
| LEEREN_VERSCHARTIKEL_1 | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG_BEH1 | !LEEREN_VERSCHARTIKEL_1 |
|                        | SQRELOC_BEH-2 | !dontChange         | !UMBUCHUNG_BEH1 | !LEEREN_VERSCHARTIKEL_1 |
| LEEREN_VERSCHARTIKEL_2 | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG_BEH2 | !LEEREN_VERSCHARTIKEL_2 |
|                        | SQRELOC_BEH-3 | !dontChange         | !dontChange     | !LEEREN_VERSCHARTIKEL_2 |
| LEEREN_VERSCHARTIKEL_3 | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG_BEH1 | !LEEREN_VERSCHARTIKEL_3 |
|                        | SQRELOC_BEH-2 | !dontChange         | !UMBUCHUNG_BEH2 | !LEEREN_VERSCHARTIKEL_3 |

Scenario: 09 Behaelter mit mehreren verschiedenen Artikeln auf anderen Lagerplatz entnehmen
Given I set the fake date to "09.02.95"
# Artikel entnehmen
Given I open the infosystem "SQRELOCATION"
And I set fields
    | verw     | TAUSCH_B09        |
    | workflow | Behaelterentnahme |
    | belnr    | SQ-B09            |
    | beldat   | .                 |
And I press start
And I modify table
    | !row  | tlplatzzu     | tmark     |
    | 1     | LP-ZU         | ja        |
    | 2     | LP-ZU         | ja        |
    | 3     | LP-ZU         | ja        |
    | 4     | LP-ZU         | ja        |
    | 5     | LP-ZU         | ja        |
    | 6     | LP-ZU         | ja        |
And I press button "umbuch"
And I save the current editor

# Lagerjournal pruefen
And I open the infosystem "LJ"
And I set fields
    | adatum    | .             |
    | beleg     | SQ-B09        |
    | richtung  | rueckwaerts   |
And I press start
# 15 Zeilen: 3 Zeilen Zugang fuer den Beheaelter, 12 Umlagerungszeilen
Then table has values
    | !row  | art           | detursache                            | nplatz    |
    | 1     | BEHAELTER     | Automatische Packmittelkorrektur      | LP1-PACK  |
    | 2     | SQRELOC_BEH-3 | Manuelle Umbuchung                    | LP-ZU     |
And I close the current editor

# Behaelter pruefen
Then Container "LEEREN_VERSCHARTIKEL_1" is empty
Then Container "LEEREN_VERSCHARTIKEL_2" is empty
Then Container "LEEREN_VERSCHARTIKEL_3" is empty


Scenario: 10 Behaelter mit einem Artikel teilweise auf diesen Lagerplatz entnehmen
Given I set the fake date to "10.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "TEILLEEREN_EINARTIKEL_1" for packaging material "BEHAELTER" and search word "TEILLEEREN_EINARTIKEL_1"
Given I create a Container "TEILLEEREN_EINARTIKEL_2" for packaging material "BEHAELTER" and search word "TEILLEEREN_EINARTIKEL_2"
Given I create a Container "TEILLEEREN_EINARTIKEL_3" for packaging material "BEHAELTER" and search word "TEILLEEREN_EINARTIKEL_3"
Given I create a Container "TEILLEEREN_EINARTIKEL_4" for packaging material "BEHAELTER" and search word "TEILLEEREN_EINARTIKEL_4"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SQRELOC_BEH-1 |
    | buart   | Zugang        |
    | beleg   | 10            |
    | beldat  | .             |
And I append rows
    | platz2    | mge | verw       | charge2             | projekt         | behaelter                |
    | LP-TAUSCH | 10  | TAUSCH_B10 | !CH_SQRELOC_BEH-1.1 | !dontChange     | !TEILLEEREN_EINARTIKEL_1 |
    | LP-TAUSCH | 10  | TAUSCH_B10 | !dontChange         | !dontChange     | !TEILLEEREN_EINARTIKEL_2 |
    | LP-TAUSCH | 10  | TAUSCH_B10 | !dontChange         | !dontChange     | !TEILLEEREN_EINARTIKEL_3 |
    | LP-TAUSCH | 10  | TAUSCH_B10 | !dontChange         | !UMBUCHUNG_BEH1 | !TEILLEEREN_EINARTIKEL_4 |
And I save the current editor

# Artikel entnehmen
Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel  | SQRELOC_BEH-1     |
    | verw     | TAUSCH_B10        |
    | workflow | Behaelterentnahme |
    | belnr    | SQ-B10            |
    | beldat   | .                 |
And I press start
And I modify table
    | !row  | tmge  | tlplatzzu | tmark |
    | 1     | 3     | LP-TAUSCH | ja    |
    | 2     | 3     | LP-TAUSCH | ja    |
    | 3     | 3     | LP-TAUSCH | ja    |
    | 4     | 3     | LP-TAUSCH | ja    |
And I press button "umbuch"
And I save the current editor

# Behaelter pruefen
And I switch the current editor to editor "TEILLEEREN_EINARTIKEL_1"
Then field "mge" has value "7" in row 1
And I close the current editor

And I switch the current editor to editor "TEILLEEREN_EINARTIKEL_2"
Then field "mge" has value "7" in row 1
And I close the current editor

And I switch the current editor to editor "TEILLEEREN_EINARTIKEL_3"
Then field "mge" has value "7" in row 1
And I close the current editor


Scenario: 11 Behaelter mit mehreren gleichen Artikeln teilweise auf diesem Lagerplatz entnehmen
Given I set the fake date to "11.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "TEILLEEREN_MEHRARTIKEL_1" for packaging material "BEHAELTER" and search word "TEILLEEREN_MEHRARTIKEL_1"
Given I create a Container "TEILLEEREN_MEHRARTIKEL_2" for packaging material "BEHAELTER" and search word "TEILLEEREN_MEHRARTIKEL_2"
Given I create a Container "TEILLEEREN_MEHRARTIKEL_3" for packaging material "BEHAELTER" and search word "TEILLEEREN_MEHRARTIKEL_3"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SQRELOC_BEH-1 |
    | buart   | Zugang        |
    | beleg   | 11            |
    | beldat  | .             |
And I append rows
    | platz2    | mge | verw       | charge2             | projekt         | behaelter                 |
    | LP-TAUSCH | 10  | TAUSCH_B11 | !CH_SQRELOC_BEH-1.1 | !dontChange     | !TEILLEEREN_MEHRARTIKEL_1 |
    | LP-TAUSCH | 10  | TAUSCH_B11 | !dontChange         | !dontChange     | !TEILLEEREN_MEHRARTIKEL_1 |
    | LP-TAUSCH | 10  | TAUSCH_B11 | !dontChange         | !UMBUCHUNG_BEH1 | !TEILLEEREN_MEHRARTIKEL_2 |
    | LP-TAUSCH | 10  | TAUSCH_B11 | !dontChange         | !dontChange     | !TEILLEEREN_MEHRARTIKEL_2 |
    | LP-TAUSCH | 10  | TAUSCH_B11 | !dontChange         | !UMBUCHUNG_BEH1 | !TEILLEEREN_MEHRARTIKEL_3 |
    | LP-TAUSCH | 10  | TAUSCH_B11 | !dontChange         | !dontChange     | !TEILLEEREN_MEHRARTIKEL_3 |
    | LP-TAUSCH | 10  | TAUSCH_B11 | !CH_SQRELOC_BEH-1.1 | !dontChange     | !TEILLEEREN_MEHRARTIKEL_3 |
And I save the current editor

# Artikel entnehmen
Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel  | SQRELOC_BEH-1     |
    | verw     | TAUSCH_B11        |
    | workflow | Behaelterentnahme |
    | belnr    | SQ-B11            |
    | beldat   | .                 |
And I press start
And I modify table
    | !row  | tmge  | tlplatzzu     |
    | 1     | 3     | LP-TAUSCH     |
    | 2     | 3     | LP-TAUSCH     |
    | 3     | 3     | LP-TAUSCH     |
    | 4     | 3     | LP-TAUSCH     |
    | 5     | 3     | LP-TAUSCH     |
    | 6     | 3     | LP-TAUSCH     |
    | 7     | 3     | LP-TAUSCH     |
And I press button "allmark"
And I press button "umbuch"
And I save the current editor

# Behaelter pruefen
And I switch the current editor to editor "TEILLEEREN_MEHRARTIKEL_1"
Then field "mge" has value "7" in row 1
Then field "mge" has value "7" in row 2
And I close the current editor

And I switch the current editor to editor "TEILLEEREN_MEHRARTIKEL_2"
Then field "mge" has value "7" in row 1
Then field "mge" has value "7" in row 2
And I close the current editor

And I switch the current editor to editor "TEILLEEREN_MEHRARTIKEL_3"
Then field "mge" has value "7" in row 1
Then field "mge" has value "7" in row 2
And I close the current editor


Scenario Outline: 12 Behaelter mit verschiedenen Artikeln teilweise auf diesem Lagerplatz entnehmen
Given I set the fake date to "12.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | 12        |
    | beldat  | .         |
And I append rows
    | mge   | platz2    | verw          | charge2   | projekt   | behaelter             |
    | 10    | LP-TAUSCH | TAUSCH_B12    | <charge2> | <projekt> | <behaelter_editor>    |
And I save the current editor

Examples: Lagerbuchung
| behaelter               | artikel       | charge2             | projekt         | behaelter_editor         |
| TEILLEEREN_12_ARTIKEL_1 | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG1     | !TEILLEEREN_12_ARTIKEL_1 |
| TEILLEEREN_12_ARTIKEL_2 | SQRELOC_BEH-2 | !dontChange         | !dontChange     | !TEILLEEREN_12_ARTIKEL_2 |
| TEILLEEREN_12_ARTIKEL_3 | SQRELOC_BEH-3 | !CH_SQRELOC_BEH-3.1 | !dontChange     | !TEILLEEREN_12_ARTIKEL_3 |
| TEILLEEREN_12_ARTIKEL_4 | SQRELOC_BEH-2 | !dontChange         | !UMBUCHUNG_BEH1 | !TEILLEEREN_12_ARTIKEL_4 |

Scenario: 12 Behaelter mit verschiedenen Artikeln teilweise auf diesem Lagerplatz entnehmen
Given I set the fake date to "12.02.95"
# Artikel entnehmen
Given I open the infosystem "SQRELOCATION"
And I set fields
    | verw     | TAUSCH_B12        |
    | workflow | Behaelterentnahme |
    | belnr    | SQ-B12            |
    | beldat   | .                 |
And I press start
And I modify table
    | !row  | tmge  | tlplatzzu     |
    | 1     | 3     | LP-TAUSCH     |
    | 2     | 3     | LP-TAUSCH     |
    | 3     | 3     | LP-TAUSCH     |
    | 4     | 3     | LP-TAUSCH     |
And I press button "allmark"
And I press button "umbuch"
And I save the current editor

# Behaelter pruefen
And I switch the current editor to editor "TEILLEEREN_12_ARTIKEL_1"
Then field "mge" has value "7" in row 1
And I close the current editor

And I switch the current editor to editor "TEILLEEREN_12_ARTIKEL_2"
Then field "mge" has value "7" in row 1
And I close the current editor

And I switch the current editor to editor "TEILLEEREN_12_ARTIKEL_3"
Then field "mge" has value "7" in row 1
And I close the current editor

And I switch the current editor to editor "TEILLEEREN_12_ARTIKEL_4"
Then field "mge" has value "7" in row 1
And I close the current editor


Scenario Outline: 13 Behaelter mir verschiedenen Artikeln teilweise auf diesen Lagerplatz entnehmen
Given I set the fake date to "13.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | 13        |
    | beldat  | .         |
And I append rows
    | mge   | platz2    | verw          | charge2   | projekt   | behaelter             |
    | 10    | LP-TAUSCH | TAUSCH_B13    | <charge2> | <projekt> | <behaelter_editor>    |
And I save the current editor

Examples: Lagerbuchung
| behaelter                  | artikel       | charge2             | projekt         | behaelter_editor            |
| TEILLEEREN_VERSCHARTIKEL_1 | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG_BEH1 | !TEILLEEREN_VERSCHARTIKEL_1 |
|                            | SQRELOC_BEH-2 | !dontChange         | !UMBUCHUNG_BEH1 | !TEILLEEREN_VERSCHARTIKEL_1 |
| TEILLEEREN_VERSCHARTIKEL_2 | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG_BEH2 | !TEILLEEREN_VERSCHARTIKEL_2 |
|                            | SQRELOC_BEH-3 | !dontChange         | !dontChange     | !TEILLEEREN_VERSCHARTIKEL_2 |
| TEILLEEREN_VERSCHARTIKEL_3 | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG_BEH1 | !TEILLEEREN_VERSCHARTIKEL_3 |
|                            | SQRELOC_BEH-2 | !dontChange         | !UMBUCHUNG_BEH2 | !TEILLEEREN_VERSCHARTIKEL_3 |

Scenario: 13 Behaelter mir verschiedenen Artikeln teilweise auf diesen Lagerplatz entnehmen
Given I set the fake date to "13.02.95"
# Artikel entnehmen
Given I open the infosystem "SQRELOCATION"
And I set fields
    | verw     | TAUSCH_B13        |
    | workflow | Behaelterentnahme |
    | belnr    | SQ-B13            |
    | beldat   | .                 |
And I press start
And I modify table
    | !row  | tmge  | tlplatzzu     |
    | 1     | 3     | LP-TAUSCH     |
    | 2     | 3     | LP-TAUSCH     |
    | 3     | 3     | LP-TAUSCH     |
    | 4     | 3     | LP-TAUSCH     |
    | 5     | 3     | LP-TAUSCH     |
    | 6     | 3     | LP-TAUSCH     |
And I press button "allmark"
And I press button "umbuch"
And I save the current editor

# Behaelter pruefen
And I switch the current editor to editor "TEILLEEREN_VERSCHARTIKEL_1"
Then field "mge" has value "7" in row 1
Then field "mge" has value "7" in row 2
And I close the current editor

And I switch the current editor to editor "TEILLEEREN_VERSCHARTIKEL_2"
Then field "mge" has value "7" in row 1
Then field "mge" has value "7" in row 2
And I close the current editor

And I switch the current editor to editor "TEILLEEREN_VERSCHARTIKEL_3"
Then field "mge" has value "7" in row 1
Then field "mge" has value "7" in row 2
And I close the current editor


Scenario: 14 Behaelter mit einem Artikel teilweise auf anderen Lagerplatz entnehmen
Given I set the fake date to "14.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "TEILLEEREN_EINARTIKEL_1" for packaging material "BEHAELTER" and search word "TEILLEEREN_EINARTIKEL_1"
Given I create a Container "TEILLEEREN_EINARTIKEL_2" for packaging material "BEHAELTER" and search word "TEILLEEREN_EINARTIKEL_2"
Given I create a Container "TEILLEEREN_EINARTIKEL_3" for packaging material "BEHAELTER" and search word "TEILLEEREN_EINARTIKEL_3"
Given I create a Container "TEILLEEREN_EINARTIKEL_4" for packaging material "BEHAELTER" and search word "TEILLEEREN_EINARTIKEL_4"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SQRELOC_BEH-1 |
    | buart   | Zugang        |
    | beleg   | 14            |
    | beldat  | .             |
And I append rows
    | platz2    | mge | verw       | charge2             | projekt         | behaelter                |
    | LP-TAUSCH | 10  | TAUSCH_B14 | !CH_SQRELOC_BEH-1.1 | !dontChange     | !TEILLEEREN_EINARTIKEL_1 |
    | LP-TAUSCH | 10  | TAUSCH_B14 | !dontChange         | !dontChange     | !TEILLEEREN_EINARTIKEL_2 |
    | LP-TAUSCH | 10  | TAUSCH_B14 | !dontChange         | !dontChange     | !TEILLEEREN_EINARTIKEL_3 |
    | LP-TAUSCH | 10  | TAUSCH_B14 | !dontChange         | !UMBUCHUNG_BEH1 | !TEILLEEREN_EINARTIKEL_4 |
And I save the current editor

# Artikel entnehmen
Scenario Outline: 14 Behaelter mit einem Artikel teilweise auf anderen Lagerplatz entnehmen
Given I set the fake date to "14.02.95"
Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel   | SQRELOC_BEH-1     |
    | verw      | TAUSCH_B14        |
    | workflow  | Behaelterentnahme |
    | container | <container>       |
    | belnr     | SQ-B14            |
    | beldat    | .                 |
And I press start
And I modify table
    | !row  | tmge  | tlplatzzu | tmark |
    | 1     | 3     | LP-ZU     | ja    |
And I press button "umbuch"
And I save the current editor

Examples:
| container                |
| !TEILLEEREN_EINARTIKEL_1 |
| !TEILLEEREN_EINARTIKEL_2 |
| !TEILLEEREN_EINARTIKEL_3 |
| !TEILLEEREN_EINARTIKEL_4 |

# Behaelter pruefen
Scenario: 14 Behaelter mit einem Artikel teilweise auf anderen Lagerplatz entnehmen
Given I set the fake date to "14.02.95"
Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel | SQRELOC_BEH-1 |
    | verw    | TAUSCH_B14    |
    | lplatz  | LP-TAUSCH     |
    | beldat  | .             |
And I press start
Then table has values
    | tmge |
    | 7    |
    | 7    |
    | 7    |
    | 7    |
And I close the current editor


Scenario: 15 Behaelter mit mehreren gleichen Artikeln teilweise auf anderen Lagerplatz entnehmen
Given I set the fake date to "15.02.95"
#  Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "TEILLEEREN_MEHRARTIKEL" for packaging material "BEHAELTER" and search word "TEILLEEREN_MEHRARTIKEL"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SQRELOC_BEH-1 |
    | buart   | Zugang        |
    | beleg   | 15            |
    | beldat  | .             |
And I append rows
    | platz2 | mge | verw       | charge2             | projekt         | behaelter               |
    | F1     | 10  |            | !CH_SQRELOC_BEH-1.1 | !dontChange     | !TEILLEEREN_MEHRARTIKEL |
    | F1     | 10  |            | !dontChange         | !dontChange     | !TEILLEEREN_MEHRARTIKEL |
    | F1     | 10  | TAUSCH_B15 | !dontChange         | !UMBUCHUNG_BEH1 | !TEILLEEREN_MEHRARTIKEL |
    | F1     | 10  | TAUSCH_B15 | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG_BEH1 | !TEILLEEREN_MEHRARTIKEL |
And I save the current editor

# Artikel entnehmen
Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel   | SQRELOC_BEH-1              |
    | container | !TEILLEEREN_MEHRARTIKEL^id |
    | lplatz    | F1                         |
    | workflow  | Behaelterentnahme          |
    | belnr     | SQ-B15                     |
    | beldat    | .                          |
And I press start
And I modify table
    | !row  | tmge  | tlplatzzu     |
    | 1     | 3     | LP-ZU         |
    | 2     | 3     | LP-ZU         |
    | 3     | 3     | LP-ZU         |
    | 4     | 3     | LP-ZU         |
And I press button "allmark"
And I press button "umbuch"
And I save the current editor

# Behaelter pruefen
And I switch the current editor to editor "TEILLEEREN_MEHRARTIKEL"
Then field "behstatusaz" is empty
Then table has values
    | mge |
    | 7   |
    | 7   |
    | 7   |
    | 7   |
And I close the current editor


Scenario Outline: 16 Behaelter mit verschiedenen Artikeln teilweise auf anderen Lagerplatz entnehmen
Given I set the fake date to "16.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | 16        |
    | beldat  | .         |
And I append rows
    | mge   | platz2    | verw      | charge2   | projekt   | behaelter                 |
    | 10    | F1        | <verw>    | <charge2> | <projekt> | !TEILLEEREN_16_ARTIKEL^id |
And I save the current editor

Examples: Lagerbuchung
| behaelter             | artikel       | verw       | charge2             | projekt         |
| TEILLEEREN_16_ARTIKEL | SQRELOC_BEH-1 | TAUSCH_B16 | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG1     |
|                       | SQRELOC_BEH-2 | TAUSCH_B16 | !dontChange         | !UMBUCHUNG_BEH1 |
|                       | SQRELOC_BEH-2 |            | !dontChange         | !dontChange     |
|                       | SQRELOC_BEH-3 | TAUSCH_B16 | !CH_SQRELOC_BEH-3.1 | !dontChange     |

# Artikel entnehmen
Scenario: 16 Behaelter mit verschiedenen Artikeln teilweise auf anderen Lagerplatz entnehmen
Given I set the fake date to "16.02.95"
Given I open the infosystem "SQRELOCATION"
And I set fields
    | container | !TEILLEEREN_16_ARTIKEL^id |
    | workflow  | Behaelterentnahme         |
    | belnr     | SQ-B16                    |
    | beldat    | .                         |
And I press start
And I modify table
    | !row  | tmge  | tlplatzzu     |
    | 1     | 3     | LP-ZU         |
    | 2     | 3     | LP-ZU         |
    | 3     | 3     | LP-ZU         |
    | 4     | 3     | LP-ZU         |
And I press button "allmark"
And I press button "umbuch"
And I save the current editor

# Behaelter pruefen
And I switch the current editor to editor "TEILLEEREN_16_ARTIKEL"
Then field "behstatusaz" is empty
Then table has values
    | mge |
    | 7   |
    | 7   |
    | 7   |
    | 7   |
And I close the current editor


Scenario Outline: 17 Behaelter mit verschiedenen Artikeln teilweise auf anderen Lagerplatz entnehmen
Given I set the fake date to "17.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | 17        |
    | beldat  | .         |
And I append rows
    | mge   | platz2    | verw      | charge2   | projekt   | behaelter                     |
    | 10    | F1        | <verw>    | <charge2> | <projekt> | !TEILLEEREN_VERSCHARTIKEL^id  |
And I save the current editor

Examples: Lagerbuchung
| behaelter                 | artikel       | verw       | charge2             | projekt         |
| TEILLEEREN_VERSCHARTIKEL  | SQRELOC_BEH-1 | TAUSCH_B17 | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG_BEH1 |
|                           | SQRELOC_BEH-1 |            | !CH_SQRELOC_BEH-1.1 | !UMBUCHUNG_BEH2 |
|                           | SQRELOC_BEH-2 | TAUSCH_B17 | !dontChange         | !dontChange     |
|                           | SQRELOC_BEH-2 |            | !dontChange         | !UMBUCHUNG_BEH2 |
|                           | SQRELOC_BEH-3 |            | !dontChange         | !dontChange     |

# Artikel entnehmen
Scenario: 17 Behaelter mit verschiedenen Artikeln teilweise auf anderen Lagerplatz entnehmen
Given I set the fake date to "17.02.95"
Given I open the infosystem "SQRELOCATION"
And I set fields
    | container | !TEILLEEREN_VERSCHARTIKEL^id |
    | workflow  | Behaelterentnahme            |
    | belnr     | SQ-B17                       |
    | beldat    | .                            |
And I press start
And I modify table
    | !row  | tmge  | tlplatzzu     |
    | 1     | 3     | LP-ZU         |
    | 2     | 3     | LP-ZU         |
    | 3     | 3     | LP-ZU         |
    | 4     | 3     | LP-ZU         |
    | 5     | 3     | LP-ZU         |
And I press button "allmark"
And I press button "umbuch"
And I save the current editor

# Behaelter pruefen
And I switch the current editor to editor "TEILLEEREN_VERSCHARTIKEL"
Then field "behstatusaz" is empty
Then table has values
    | mge |
    | 7   |
    | 7   |
    | 7   |
    | 7   |
    | 7   |
And I close the current editor


Scenario: 18 Es kann aus einem Behaelter nicht mehr entnommen werden, als drin ist
Given I set the fake date to "18.02.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "MENGEZUGROSS" for packaging material "BEHAELTER" and search word "MENGEZUGROSS"

Given I post a receipt via ManualStockAdjustment for Product "SQRELOC_BEH-1" and quantity "10" on StorageLocation "F1" with document "18" and Container "!MENGEZUGROSS"

# Groessere Menge kann nciht engegeben werden, Wert springt auf maximal zu entnehmende Menge zurueck
Given I open the infosystem "SQRELOCATION"
And I set fields
    | container | !MENGEZUGROSS^id   |
    | workflow  | Behaelterentnahme  |
    | belnr     | SQ-B18             |
    | beldat    | .                  |
And I press start
Then field "tmge" has value "10" in row 1
And I set field "tmge" to "20" in row 1
Then field "tmge" has value "10" in row 1
And I close the current editor


Scenario: 19 Selektion nach Betriebsauftrag zeigt das benoetigte Material in Behaeltern an, Material wird entnommen
Given I set the fake date to "19.02.95"
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F2"
Given I set StorageQuantity to zero for Product "EK2-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK2-BEDARF" on StorageLocation "F2"

# Material in Behaelter zubuchen und Betriebsauftrag erstellen
Given I create a Container "MATERIAL11" for packaging material "BEHAELTER"
Given I create a Container "MATERIAL22" for packaging material "BEHAELTER"
Given I create a Container "MATERIAL33" for packaging material "BEHAELTER"

Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F2" with document "SQ-191" and Container "!MATERIAL11"
Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F2" with document "SQ-192" and Container "!MATERIAL22"
Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F2" with document "SQ-193"

Given I post a receipt via ManualStockAdjustment for Product "EK2-BEDARF" and quantity "10" on StorageLocation "F2" with document "SQ-194" and Container "!MATERIAL22"
Given I post a receipt via ManualStockAdjustment for Product "EK2-BEDARF" and quantity "10" on StorageLocation "F2" with document "SQ-195" and Container "!MATERIAL33"

Given I create a work order "GUTMGE11" for Product "BG3-BEDARF" with quantity "20" and search word "GUTMGE11"

# Die Felder tmge, tlplatzzu und tbehzugang sind schreibgeschuetzt fuer Material ohne Behaelter
# Fuer Material in Behaeltern ist tbehzugang schreibgeschuetzt
Given I open the infosystem "SQRELOCATION"
And I set fields
    | workflow  | Behaelterentnahme |
    | ba        | GUTMGE11000       |
And I press start
Then field "tmge" is not modifiable in row 1
Then field "tlplatzzu" is not modifiable in row 1
Then field "tbehzugang" is not modifiable in row 1
Then field "tbehzugang" is not modifiable in row 2
And I modify table
    | tmge  | tlplatzzu | !row  |
    | 10    | F1        | 2     |
    | 7     | F2        | 3     |
    | 5     | F1        | 4     |
    | 5     | F2        | 5     |
And I press button "allmark"
And I press button "umbuch"

Then table has values
    | tartikel      | gebmge    | tlplatz   | tbehabgang         |
    | EK1-BEDARF    | 10        | F1        |                    |
    | EK1-BEDARF    | 17        | F2        |                    |
    | EK1-BEDARF    | 3         | F2        | !MATERIAL22^nummer |
    | EK2-BEDARF    | 5         | F1        |                    |
    | EK2-BEDARF    | 5         | F2        |                    |
    | EK2-BEDARF    | 5         | F2        | !MATERIAL22^nummer |
    | EK2-BEDARF    | 5         | F2        | !MATERIAL33^nummer |
And I close the current editor

# Bheaelter pruefen
Then Container "!MATERIAL11" is empty

# BA loeschen, Material auf 0 setzen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "GUTMGE11000"
And I respond with answer "JA" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor

Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F2"
Given I set StorageQuantity to zero for Product "EK2-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK2-BEDARF" on StorageLocation "F2"


Scenario: 20 Selektion nach Auftrag zeigt die benoetigten Teile in Behaeltern an, Teile werden entnommen
Given I set the fake date to "20.02.95"
# Behaelter anlegen, Lagerzgaenge buchen und Auftrag erstellen
Given I create a Container "AUFTRAG11" for packaging material "BEHAELTER"
Given I create a Container "AUFTRAG12" for packaging material "BEHAELTER"

Given I post a receipt via ManualStockAdjustment for Product "BG3-BEDARF" and quantity "20" on StorageLocation "F2" with document "SQ201" and Container "!AUFTRAG11"
Given I post a receipt via ManualStockAdjustment for Product "BG3-BEDARF" and quantity "10" on StorageLocation "F2" with document "SQ202" and Container "!AUFTRAG12"
Given I post a receipt via ManualStockAdjustment for Product "BG3-BEDARF" and quantity "10" on StorageLocation "F1" with document "SQ203"
Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F2" with document "SQ202" and Container "!AUFTRAG12"

Given I create a SalesOrder "Auftrag1" for Customer "KUNDE1" with Product "BG3-BEDARF" and quantity "25"

# Die Felder tmge, tlplatzzu und tbehzugang sind schreibgeschuetzt fuer Material ohne Behaelter
# Fuer Material in Behaeltern ist tbehzugang schreibgeschuetzt
Given I open the infosystem "SQRELOCATION"
And I set fields
    | workflow  | Behaelterentnahme |
    | auftrag   | !Auftrag1         |
And I press start
Then field "tmge" is not modifiable in row 1
Then field "tlplatzzu" is not modifiable in row 1
Then field "tbehzugang" is not modifiable in row 1
Then field "tbehzugang" is not modifiable in row 2
And I modify table
    | !row  | tmge  | tlplatzzu  |
    | 2     | 10    | F1         |
    | 3     | 5     | F1         |
And I press button "allmark"
And I press button "umbuch"

Then table has values
    | gebmge  | tlplatz | tbehabgang          |
    | 25      | F1      |                     |
    | 10      | F2      | !AUFTRAG11^nummer   |
    | 5       | F2      | !AUFTRAG12^nummer   |
And I close the current editor

# Auftrag liefern und Menge auf 0 setzen
And I deliver the SalesOrder "Auftrag1" with PackingSlip "Liefers1"
Given I set StorageQuantity to zero for Product "BG3-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "BG3-BEDARF" on StorageLocation "F2"
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F2"


# über Materialzuordnung im Lieferschein gebuchte Mengen in Behälter: werden nicht angezeigt, die Felder in der Tabelle sind daher schreibgeschützt   
# Grund ist, dass der Behäter nicht in die Platzmenge integriert ist 
# Scenario: 21 Selektion nach Einkaufszugang Teile in Behaeltern an, Teile werden entnommen


# Fehlermeldung nicht prüfbar - CUCU-253
#Scenario: 22 Selektion nach Fertigungs- und Einkaufszugang ohne Gutmenge oder Teile bringt Fehlermeldung
#Given I set the fake date to "22.02.95"
## Betriebsauftrag und nicht gebuchten Lieferschein anlegen
#Given I create a work order "LEER1" for Product "BG3-BEDARF" with quantity "10" and search word "LEER1"
#Given I open an editor "BA_LEER1000" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "LEER1000"
#And I close the current editor
#
#Given I open an editor "Lieferschein3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
#And I set fields
#    | lief      | LIEFER1       |
#    | such      | LIEFER3       |
#    | ebeleg    | Liefer3       |
#    | vom       | .             |
#And I append rows
#    | artikel   | mge   |
#    | EK1-BEDARF| 10    |
#And I save the current editor
#
## Fehlermeldung im IS
## Fertigungszugang: Keine Zugaenge fuer den Betriebsauftrag gefunden!
## Einkaufszugang: Dieser EK-Beleg wurde noch nicht gebucht.
#Given I open the infosystem "SQRELOCATION"
#And I set field "workflow" to "Behaelterentnahme"
#Then setting field "fertigung" to "!BA_LEER1000^nummer" throws the exception "Keine Zugänge für den Betriebsauftrag gefunden!"
#
#Then setting field "kzugang" to "LIEFER3" throws the exception "Dieser EK-Beleg wurde noch nicht gebucht."
#And I close the current editor
#
## BA und Lieferschein loeschen
#Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "LEER1000"
#And I respond with answer "JA" to the dialog with id "345"
#And I set field "status" to "s"
#And I save the current editor
#
#And I switch the current editor to editor "Lieferschein3" with command "UPDATE"
#And I set field "mge" to "0" in row 1
#And I save the current editor
