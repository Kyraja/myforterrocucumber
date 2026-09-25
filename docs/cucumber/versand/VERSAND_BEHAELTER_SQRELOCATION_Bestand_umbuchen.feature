@persistent
Feature: VERSAND_BEHAELTER_SQRELOCATION_Bestand_umbuchen.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_SQRELOCATION_Bestand_umbuchen.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Umbuchen mit Behaelter ueber IS SQRELOCATION
#  ref              : ref_la_sqrelocation_cu
# *****************************************************************************

Background:
Given I set the fake date to "01.03.95"


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
    | such         | <such>            |
    | namebspr     | <namebspr>        |
    | dispoa       | <dispoa>          |
    | chverfolgung | Chargenverfolgung |
    | chimlager    | ja                |
And I save the current editor

Examples: Artikel
    | such            | namebspr                         | dispoa          |
    | SQRELOC-1       | Umlagerungsartikel 1             | auftragsbezogen |
    | SQRELOC-2       | Umlagerungsartikel 2             | auftragsbezogen |
    | SQRELOC-3       | Fehlermeldungen pruefen          | auftragsbezogen |
    | SQ-ARTIKEL      | Artikel fuer Baugruppe           | bedarfsbezogen  |
    | SQRELOC-NEG     | Negative Bestaende               | auftragsbezogen |
    | SQRELOC_BEH-1   | Umlagerungsartikel1 in Behaelter | auftragsbezogen |
    | SQRELOC_BEH-2   | Umlagerungsartikel2 in Behaelter | auftragsbezogen |
    | SQRELOC_BEH-3   | Fehlermeldungen Behaelter        | auftragsbezogen |
    | SQRELOC_BEH-NEG | Negative Bestaende Behaelter     | auftragsbezogen |
    | SQRELOC-VERFDAT | Umlagerungsartikel nach Datum    | auftragsbezogen |
    
@testvorbereitung
Scenario: Eigenfertigungsartikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "SQ-BAUGRUPPE"
And I set fields
    | such         | SQ-BAUGRUPPE      |
    | namebspr     | Baugruppe         |
    | dispoa       | auftragsbezogen   |
    | bsart        | Eigenfertigung    |
    | chverfolgung | Chargenverfolgung |
    | chimlager    | ja                |
And I delete all rows
And I append rows
    | elex       | elanzahl |
    | SQ-ARTIKEL | 1        |
    | A AG1      | 1        |
And I save the current editor

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

@testvorbereitung
Scenario: Chargen anlegen
Given I create a Lot "CH_SQRELOC-1.2" for Product "SQRELOC-1"
Given I create a Lot "CH_SQRELOC-2.2" for Product "SQRELOC-2"
Given I create a Lot "CH_SQRELOC-3.2" for Product "SQRELOC-3"
Given I create a Lot "CH_SQRELOC-NEG.2" for Product "SQRELOC-NEG"
#Given I create a Lot "CH_SQRELOC_BEH-1" for Product "SQRELOC_BEH-1"
#Given I create a Lot "CH_SQRELOC_BEH-2" for Product "SQRELOC_BEH-2"
#Given I create a Lot "CH_SQRELOC_BEH-3" for Product "SQRELOC_BEH-3"
#Given I create a Lot "CH_SQRELOC_BEH-NEG" for Product "SQRELOC_BEH-NEG"

Scenario Outline: Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such         | <such>            |
    | namebspr     | <namebspr>        |
    | dispoa       | <dispoa>          |
And I save the current editor

Examples: Artikel
    | such            | namebspr                         | dispoa          |
    | SQREL_1         | Artikel 1 SQRELOCATION           | auftragsbezogen |
    | SQREL_2         | Artikel 2 SQRELOCATION           | auftragsbezogen |
    | SQREL_ENTMAT_1  | Entnahmematerial SQRELOCATION    | auftragsbezogen |
    | SETKOMP_SQR_1   | Setkomponente 1 SQRELOCATION     | auftragsbezogen |
    | SETKOMP_SQR_2   | Setkomponente 2 SQRELOCATION     | auftragsbezogen |


Scenario: Eigenfertigungsartikel und Setartikel anlegen

Given I open an editor "BG_SQREL" from table "(Part):(Product)" with command "STORE" for record "BG_SQREL"
And I set fields
    | such         | BG_SQREL               |
    | namebspr     | Baugruppe SQRELOCATION |
    | dispoa       | auftragsbezogen        |
    | bsart        | Eigenfertigung         |
And I delete all rows
And I append rows
    | elex              | elanzahl |
    | SQREL_ENTMAT_1    | 1        |
    | A AG1             | 1        |
And I save the current editor

Given I open an editor "SET_SQREL" from table "(Part):(Product)" with command "STORE" for record "SET_SQREL"
And I set fields
    | such          | SET_SQREL                 |
    | namebspr      | Setartikel SQRELOCATION   |
    | earta         | über Stückliste           |
    | dispoa        | auftragsbezogen           |
And I delete all rows
And I append rows
    | elex          | elanzahl  |
    | SETKOMP_SQR_1 | 1         |
    | SETKOMP_SQR_2 | 2         |
And I save the current editor

##################################################################################################################


Scenario: 01 Artikel mit unterschiedlichen Auspraegungen von verschieden Lagerplaetzen auf einen Lagerplatz umbuchen 
# Lagerzugaenge buchen
Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
    | artikel     | SQRELOC-1  |
    | buart       | Zugang     |
    | beleg       | Z01        |
    | beldat      | .          |
And I modify table
    | !row  | mge   | platz2 | verw    | charge2         | projekt     |
    | +1    | 10    | F1     | 100000  | !CH_SQRELOC-1.2 | !UMBUCHUNG1 |
    | +2    | 10    | F1     | 100000  | !CH_SQRELOC-1.2 | !UMBUCHUNG2 |
    | +3    | 10    | F2     | 100000  | !CH_SQRELOC-1.2 | !UMBUCHUNG1 |
And I save the current editor

# Umbuchung
Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel  | SQRELOC-1        |
    | charge   | !CH_SQRELOC-1.2    |
    | verw     | 100000           |
    | workflow | Bestand umbuchen |
    | belnr    | SQ01             |
And I press start
And I modify table
    | !row  | tlplatzzu | tmark  |
    | 1     | LP-ZU     | ja     |
    | 2     | LP-ZU     | ja     |
    | 3     | LP-ZU     | ja     |
And I press button "umbuch"
And I save the current editor

#Lagerjournal pruefen
And I open the infosystem "LJ"
And I set fields
    | adatum   |.            |
    | richtung | rueckwaerts |
    | beleg    | SQ01        |
And I press start
Then table has values
    | art       | detursache         | nplatz | projekt              |
    | SQRELOC-1 | Manuelle Umbuchung | LP-ZU  | !UMBUCHUNG1^such     |
    | SQRELOC-1 | Manuelle Umbuchung |        | !UMBUCHUNG1^such     |
    | SQRELOC-1 | Manuelle Umbuchung | LP-ZU  | !UMBUCHUNG2^such     |
    | SQRELOC-1 | Manuelle Umbuchung |        | !UMBUCHUNG2^such     |
    | SQRELOC-1 | Manuelle Umbuchung | LP-ZU  | !UMBUCHUNG1^such     |
    | SQRELOC-1 | Manuelle Umbuchung |        | !UMBUCHUNG1^such     |
And I close the current editor


Scenario: 02 Artikel mit untertschiedlichen Auspraegungen teilweise von verschiedenen Lagerpplaetzen auf einen Lagerplatz umbuchen
Given I set the fake date to "02.03.95"
# Lagerzugaenge buchen
Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | SQRELOC-1  |
      | buart       | Zugang     |
      | beleg       | Z02        |
      | beldat      | .          |
And I modify table
      | !row  | mge   | platz2 | verw    | charge2         | projekt     |
      | +1    | 10    | F1     | 222221  | !dontChange     | !dontChange |
      | +2    | 10    | F1     | 222221  | !CH_SQRELOC-1.2 | !dontChange |
      | +3    | 10    | F2     | 222221  | !CH_SQRELOC-1.2 | !UMBUCHUNG1 |
And I save the current editor

# Umbuchung
Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel  | SQRELOC-1        |
    | verw     | 222221           |
    | workflow | Bestand umbuchen |
    | belnr    | SQ02             |
And I press start
And I modify table
    | !row  | tmge  | tlplatzzu  | tmark  |
    | 1     | 1     |  LP-ZU     | ja     |
    | 2     | 1     |  LP-ZU     | ja     |
    | 3     | 1     |  LP-ZU     | ja     |
And I press button "umbuch"
And I save the current editor

# Lagerjournal pruefen
And I open the infosystem "LJ"
And I set fields
    | adatum   | .           |
    | richtung | rueckwaerts |
    | beleg    | SQ02        |
And I press start
Then table has values
    | art       | detursache         | nplatz | vcharge^such         | projekt            |
    | SQRELOC-1 | Manuelle Umbuchung | LP-ZU  | !CH_SQRELOC-1.2^such | !UMBUCHUNG1^such   |
    | SQRELOC-1 | Manuelle Umbuchung |        | !CH_SQRELOC-1.2^such | !UMBUCHUNG1^such   |
    | SQRELOC-1 | Manuelle Umbuchung | LP-ZU  | !CH_SQRELOC-1.2^such |                    |
    | SQRELOC-1 | Manuelle Umbuchung |        | !CH_SQRELOC-1.2^such |                    |
    | SQRELOC-1 | Manuelle Umbuchung | LP-ZU  |                      |                    |
    | SQRELOC-1 | Manuelle Umbuchung |        |                      |                    |
And I close the current editor


Scenario Outline: 03 Artikel mit verschiedenen Auspraegungen auf einen anderen Lagerplatz umbuchen
Given I set the fake date to "03.03.95"
# Lagerzugaenge buchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | 03        |
    | beldat  | .         |
And I append rows
    | platz2 | mge | verw   | charge2   | projekt   |
    | F1     | 10  | <verw> | <charge2> | <projekt> |
And I save the current editor

Examples: Lagerzugang
| artikel   | verw   | charge2       | projekt      |
| SQRELOC-1 | 333333 | !CH_SQRELOC-1.2 | !dontChange  |
| SQRELOC-2 | 333333 | !dontChange   | !dontChange  |
| SQRELOC-2 | 333333 | !dontChange   | !UMBUCHUNG1  |

Scenario: 03 Artikel mit verschiedenen Auspraegungen auf einen anderen Lagerplatz umbuchen
Given I set the fake date to "03.03.95"
#Umbuchung
Given I open the infosystem "SQRELOCATION"
And I set fields
    | verw     | 333333           |
    | lplatz   | F1               |
    | workflow | Bestand umbuchen |
    | belnr    | SQ03             |
And I press start
And I modify table
    | !row  | tlplatzzu  | tmark  |
    | 1     |  LP-ZU     | ja     |
    | 2     |  LP-ZU     | ja     |
    | 3     |  LP-ZU     | ja     |
And I press button "umbuch"
And I save the current editor

# Lagerjournal pruefen
Given I open the infosystem "LJ"
And I set fields
    | adatum   | .             |
    | richtung | rueckwaerts   |
    | beleg    | SQ03          |
And I press start
Then table has values
    | art       | detursache         | nplatz | vcharge                | projekt              |
    | SQRELOC-2 | Manuelle Umbuchung | LP-ZU  |                        | !UMBUCHUNG1^such     |
    | SQRELOC-2 | Manuelle Umbuchung |        |                        | !UMBUCHUNG1^such     |
    | SQRELOC-2 | Manuelle Umbuchung | LP-ZU  |                        |                      |
    | SQRELOC-2 | Manuelle Umbuchung |        |                        |                      |
    | SQRELOC-1 | Manuelle Umbuchung | LP-ZU  | !CH_SQRELOC-1.2^nummer |                      |
    | SQRELOC-1 | Manuelle Umbuchung |        | !CH_SQRELOC-1.2^nummer |                      |
And I close the current editor


Scenario Outline: 04 Artikel mit unterschiedlichen Auspraegungen von verschiedenen Lagerplaetzen auf einen Lagerplatz umbuchen 
Given I set the fake date to "04.03.95"
# Lagerzugaenge buchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | 04        |
    | beldat  | .         |
And I append rows
    | platz2   | mge | verw   | charge2   | projekt   |
    | <platz2> | 10  | 444444 | <charge2> | <projekt> |
And I save the current editor

Examples: Lagerzugang
| artikel   | platz2 | charge2       | projekt      |
| SQRELOC-1 | F1     | !CH_SQRELOC-1.2 | !dontChange  |
| SQRELOC-2 | F2     | !dontChange   | !dontChange  |
| SQRELOC-2 | F3     | !dontChange   | !UMBUCHUNG1  |

Scenario: 04 Artikel mit unterschiedlichen Auspraegungen von verschiedenen Lagerplaetzen auf einen Lagerplatz umbuchen 
Given I set the fake date to "04.03.95"
# Umbuchung
Given I open the infosystem "SQRELOCATION"
And I set fields
    | verw     | 444444           |
    | workflow | Bestand umbuchen |
    | belnr    | SQ04             |
And I press start
And I modify table
    | !row  | tlplatzzu  | tmark  |
    | 1     |  LP-ZU     | ja     |
    | 2     |  LP-ZU     | ja     |
    | 3     |  LP-ZU     | ja     |
And I press button "umbuch"
And I save the current editor

# Lagerjournal pruefen
And I open the infosystem "LJ"
And I set fields
    | adatum   | .             |
    | richtung | rueckwaerts   |
    | beleg    | SQ04          |
And I press start
Then table has values
    | art       | detursache         | nplatz | vcharge                | projekt            |
    | SQRELOC-2 | Manuelle Umbuchung | LP-ZU  |                        | !UMBUCHUNG1^such   |
    | SQRELOC-2 | Manuelle Umbuchung |        |                        | !UMBUCHUNG1^such   |
    | SQRELOC-2 | Manuelle Umbuchung | LP-ZU  |                        |                    |
    | SQRELOC-2 | Manuelle Umbuchung |        |                        |                    |
    | SQRELOC-1 | Manuelle Umbuchung | LP-ZU  | !CH_SQRELOC-1.2^nummer |                    |
    | SQRELOC-1 | Manuelle Umbuchung |        | !CH_SQRELOC-1.2^nummer |                    |
And I close the current editor


Scenario Outline: 05 Artikel mit unterschiedlichen Auspraegungen auf einen Lagerplatz umbuchen 
Given I set the fake date to "05.03.95"
# Lagerzugaenge buchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | 05        |
    | beldat  | .         |
And I append rows
    | platz2 | mge | verw   | charge2   | projekt   |
    | F1     | 10  | <verw> | <charge2> | <projekt> |
And I save the current editor

Examples: Lagerzugang
| artikel   | verw   | charge2         | projekt      |
| SQRELOC-1 | 555555 | !CH_SQRELOC-1.2 | !UMBUCHUNG1  |
| SQRELOC-2 | 555555 | !CH_SQRELOC-2.2 | !UMBUCHUNG2  |
| SQRELOC-2 | 555555 | !CH_SQRELOC-2.2 | !dontChange  |

Scenario: 05 Artikel mit unterschiedlichen Auspraegungen auf einen Lagerplatz umbuchen
Given I set the fake date to "05.03.95"
# Umbuchung
Given I open the infosystem "SQRELOCATION"
And I set fields
    | verw     | 555555           |
    | workflow | Bestand umbuchen |
    | belnr    | SQ05             |
And I press start
And I modify table
    | !row  | tmge  | tlplatzzu  | tmark  |
    | 1     | 1     |  LP-ZU     | ja     |
    | 2     | 1     |  LP-ZU     | ja     |
    | 3     | 1     |  LP-ZU     | ja     |
And I press button "umbuch"
And I close the current editor

# Lagerjournal pruefen
Given I open the infosystem "LJ"
And I set fields
    | adatum   | .           |
    | richtung | rueckwaerts |
    | beleg    | SQ05        |
And I press start
Then table has values
    | art       | detursache         | nplatz | vcharge                 | projekt            |
    | SQRELOC-2 | Manuelle Umbuchung | LP-ZU  | !CH_SQRELOC-2.2^nummer  | !UMBUCHUNG2^such   |
    | SQRELOC-2 | Manuelle Umbuchung |        | !CH_SQRELOC-2.2^nummer  | !UMBUCHUNG2^such   |
    | SQRELOC-2 | Manuelle Umbuchung | LP-ZU  | !CH_SQRELOC-2.2^nummer  |                    |
    | SQRELOC-2 | Manuelle Umbuchung |        | !CH_SQRELOC-2.2^nummer  |                    |
    | SQRELOC-1 | Manuelle Umbuchung | LP-ZU  | !CH_SQRELOC-1.2^nummer  | !UMBUCHUNG1^such   |
    | SQRELOC-1 | Manuelle Umbuchung |        | !CH_SQRELOC-1.2^nummer  | !UMBUCHUNG1^such   |
And I close the current editor


Scenario: 06 Es kann nicht mehr umgebucht werden als der Artikel Bestand hat
Given I set the fake date to "06.03.95"
# Lagerzugaenge buchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SQRELOC-3 |
    | buart   | Zugang    |
    | beleg   | 06        |
    | beldat  | .         |
And I append rows
    | mge | platz2 | verw        | charge2         |
    | 1   | F1     | 06-3333     | !CH_SQRELOC-3.2 |
    | 1   | F2     | 06-2222     | !dontChange     |
    | 1   | LP-ZU  | !dontChange | !dontChange     |
And I save the current editor

# Umbuchung
Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel  | SQRELOC-3        |
    | lgruppe  |                  |
    | workflow | Bestand umbuchen |
    | belnr    | SQ06             |
And I press start
And I set field "tmge" to "9999" in row 1
Then field "tmge" in row 1 has value equal to field "gebmge" from editor "SQRELOCATION" in row 1
And I set field "tmge" to "9999" in row 2
Then field "tmge" in row 2 has value equal to field "gebmge" from editor "SQRELOCATION" in row 2
And I set field "tmge" to "9999" in row 3
Then field "tmge" in row 3 has value equal to field "gebmge" from editor "SQRELOCATION" in row 3
And I close the current editor


Scenario: 07 Negative Bestaende koennen nicht umgebucht werden
Given I set the fake date to "07.03.95"
# Negative Bestaende erzeugen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SQRELOC-NEG |
    | buart   | Abgang      |
    | beleg   | 07          |
    | beldat  | .           |
And I append rows
    | mge | platz | verw    | charge1           |
    | 10  | F1    | 07-2222 | !CH_SQRELOC-NEG.2 |
    | 10  | F2    | 07-1111 | !dontChange       |
    | 10  | LP-ZU | 07-1111 | !dontChange       |
And I save the current editor

# Umbuchung
Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel  | SQRELOC-NEG      |
    | lgruppe  |                  |
    | workflow | Bestand umbuchen |
    | belnr    | SQ07             |
And I press start
Then field "tmark" is not modifiable in row 1
Then field "tmark" is not modifiable in row 2
Then field "tmark" is not modifiable in row 3
Then field "tmge" is not modifiable in row 1
Then field "tmge" is not modifiable in row 2
Then field "tmge" is not modifiable in row 3
Then field "tlplatzzu" is not modifiable in row 1
Then field "tlplatzzu" is not modifiable in row 2
Then field "tlplatzzu" is not modifiable in row 3
And I close the current editor

Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F2"
Given I set StorageQuantity to zero for Product "EK2-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK2-BEDARF" on StorageLocation "F2"


Scenario: 08 Selektion nach Betriebsauftrag zeigt benoetigtes Material an, Teile werden umgebucht
Given I set the fake date to "08.03.95"
# Lagerzugaenge buchen, Betriebsauftrag erstellen
Given I create a Container "MATERIAL1" for packaging material "BEHAELTER"

Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "20" on StorageLocation "F2" with document "SQ-101" and Container "!MATERIAL1"
Given I post a receipt via ManualStockAdjustment for Product "EK2-BEDARF" and quantity "20" on StorageLocation "F2" with document "SQ-102"

Given I create a work order "GUTMGE8" for Product "BG3-BEDARF" with quantity "20" and search word "GUTMGE8"

# Die Felder tmge, tlplatzzu und tbehzugang sind schreibgeschuetzt fuer Material mit Behaelter
# Fuer Material ohne Behaelter ist tbehzugang schreibgeschuetzt
Given I open the infosystem "SQRELOCATION"
And I set fields
    | workflow  | Bestand umbuchen  |
    | ba        | GUTMGE8000        |
And I press start
Then field "tmge" is not modifiable in row 1
Then field "tlplatzzu" is not modifiable in row 1
Then field "tbehzugang" is not modifiable in row 1
Then field "tbehzugang" is not modifiable in row 2
And I modify table
    | tmge  | tlplatzzu | !row  |
    | 15    | F1        | 2     |
And I press button "allmark"
And I press button "umbuch"

Then table has values
    | gebmge    | tlplatz   | tbehabgang        |
    | 20        | F2        | !MATERIAL1^nummer |
    | 15        | F1        |                   |
    | 5         | F2        |                   |
And I close the current editor

# BA loeschen, Material auf 0 setzen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "GUTMGE8000"
And I respond with answer "JA" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor

Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F2"
Given I set StorageQuantity to zero for Product "EK2-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK2-BEDARF" on StorageLocation "F2"


Scenario: 09 Selektion nach Auftrag zeigt benoetigtes Material an, Teile werden umgebucht
Given I set the fake date to "09.03.95"
# Lagerzugaenge buchen und Auftrag erstellen
Given I create a Container "AUFTRAG1" for packaging material "BEHAELTER"

Given I post a receipt via ManualStockAdjustment for Product "BG3-BEDARF" and quantity "10" on StorageLocation "F2" with document "SQ-111" and Container "!AUFTRAG1"
Given I post a receipt via ManualStockAdjustment for Product "BG3-BEDARF" and quantity "30" on StorageLocation "F2" with document "SQ-112"

Given I create a SalesOrder "Auftrag1" for Customer "KUNDE1" with Product "BG3-BEDARF" and quantity "20"

# Die Felder tmge, tlplatzzu und tbehzugang sind schreibgeschuetzt fuer Material mit Behaelter
# Fuer Material ohne Behaelter ist tbehzugang schreibgeschuetzt
Given I open the infosystem "SQRELOCATION"
And I set fields
    | workflow  | Bestand umbuchen  |
    | auftrag   | !Auftrag1         |
And I press start
Then field "tmge" is not modifiable in row 2
Then field "tlplatzzu" is not modifiable in row 2
Then field "tbehzugang" is not modifiable in row 2
Then field "tbehzugang" is not modifiable in row 1
And I modify table
    | tmge  | tlplatzzu | !row  |
    | 20    | F1        | 1     |
And I press button "allmark"
And I press button "umbuch"

Then table has values
    | gebmge    | tlplatz   | tbehabgang        |
    | 20        | F1        |                   |
    | 10        | F2        |                   |
    | 10        | F2        | !AUFTRAG1^nummer  |
And I close the current editor

# Auftrag liefern und Menge auf 0 setzen
And I deliver the SalesOrder "Auftrag1" with PackingSlip "Liefers1"
Given I set StorageQuantity to zero for Product "BG3-BEDARF" on StorageLocation "F2"


# über Materialzuordnung im Lieferschein gebuchte Mengen in Behälter: werden nicht angezeigt, die Felder in der Tabelle sind daher schreibgeschützt   
# Grund ist, dass der Behäter nicht in die Platzmenge integriert ist 
# Scenario: 10 Selektion nach Einkaufszugang zeigt Artikel, Artikel werden umgebucht


# Fehlermeldung nicht prüfbar - CUCU-253
#Scenario: 11 Selektion nach Fertigunngs- und Einkaufszugang ohne Gutmenge oder Teile bringt Fehlermeldung
#Given I set the fake date to "11.03.95"
## Betriebsauftrag und nicht gebuchten Lieferschein anlegen
#Given I create a work order "LEER1" for Product "BG3-BEDARF" with quantity "10" and search word "LEER1"
#Given I open an editor "BA_LEER1000" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "LEER1000"
#And I close the current editor
#
#Given I open an editor "Liefer2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
#And I set fields
#    | lief      | LIEFER1       |
#    | ebeleg    | Liefer2       |
#    | vom       | .             |
#And I append rows
#    | artikel   | mge   |
#    | EK1-BEDARF| 10    |
#And I save the current editor
## nicht gebuchter Lieferschein?
#
## Fehlermeldung im IS
## Fertigungszugang: Keine Zugaenge fuer den Betriebsauftrag gefunden! 5234
## Einkaufszugang: Dieser EK-Beleg wurde noch nicht gebucht. 5238
#Given I open the infosystem "SQRELOCATION"
#And I set field "workflow" to "Bestand umbuchen"
#Then setting field "fertigung" to "!BA_LEER1000^nummer" throws the exception "5234"
#
#Then setting field "auftrag" to "!Liefer2" throws the exception "5238"
#
#And I close the current editor
#
## BA und Lieferschein loeschen
#Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "LEER1000"
#And I respond with answer "JA" to the dialog with id "345"
#And I set field "status" to "s"
#And I save the current editor
#
#And I switch the current editor to editor "Liefer2" with command "UPDATE"
#And I set field "mge" to "0" in row 1
#And I save the current editor


Scenario: 12 Bestand nach Datum umbuchen, beruecksichtigt das Verbrauchsfolgedatum

And I set the fake date to "15.03.95"

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
    | artikel     | SQRELOC-VERFDAT |
    | buart       | Zugang          |
    | beleg       | Z01             |
    | beldat      | .               |
And I modify table
    | !row  | mge   | platz2 | verw    |
    | +1    | 10    | F1     | 1111    |
    | +2    | 10    | F1     | 2222    |
    | +3    | 10    | F2     | 2222    |
    | +4    | 10    | F1     | 3333    |
    | +5    | 10    | F2     | 4444    |
And I save the current editor

Given I open an editor "Lieferung" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | TEST     |
    | vom    | .        |
    | ebeleg | LS01     |
    | ueb    | ja       |
And I append rows
    | artikel         | mge | verw    | verfdat   | platz |
    | SQRELOC-VERFDAT | 100 | 1111    | 01.01.95  | F1    |
    | SQRELOC-VERFDAT | 50  | 1111    | 01.02.95  | F1    |
    | SQRELOC-VERFDAT | 50  | 1111    | 15.02.95  | F1    |
    | SQRELOC-VERFDAT | 200 | 1111    | 01.01.95  | F2    |
    | SQRELOC-VERFDAT | 100 | 1111    | 15.01.95  | F2    |
    | SQRELOC-VERFDAT | 50  | 2222    | 20.01.95  | F2    |
    | SQRELOC-VERFDAT | 100 | 2222    | 01.01.95  | F1    |
    | SQRELOC-VERFDAT | 50  | 3333    | 01.02.95  | F1    |
    | SQRELOC-VERFDAT | 50  |         | 15.02.95  | F1    |
    | SQRELOC-VERFDAT | 200 |         | 01.01.95  | F2    |
    | SQRELOC-VERFDAT | 100 |         | 15.01.95  | F2    |
    | SQRELOC-VERFDAT | 50  | 4444    | 20.01.95  | F2    |
And I save the current editor

Given I open the infosystem "SQRELOCATION"
And I set fields
    | workflow  | Bestand umbuchen  |
    | artikel   | SQRELOC-VERFDAT   |
And I press start
Then the table has 8 rows
And I set fields
    | workflow  | Bestand nach Datum umbuchen  |
    | kzugang   | !Lieferung^id                |
And I press start
Then the table has 12 rows
Then table has values
    | gebmge    | tlplatz   | tverw | verfdat     |
    | 100       | F1        | 1111  | 01.01.1995  |
    | 50        | F1        | 1111  | 01.02.1995  |
    | 50        | F1        | 1111  | 15.02.1995  |
    | 200       | F2        | 1111  | 01.01.1995  |
    | 100       | F2        | 1111  | 15.01.1995  |
    | 50        | F2        | 2222  | 20.01.1995  |
    | 100       | F1        | 2222  | 01.01.1995  |
    | 50        | F1        | 3333  | 01.02.1995  |
    | 50        | F1        |       | 15.02.1995  |
    | 200       | F2        |       | 01.01.1995  |
    | 100       | F2        |       | 15.01.1995  |
    | 50        | F2        | 4444  | 20.01.1995  |
And I set field "kzugang" to ""
And I set field "artikel" to "SQRELOC-VERFDAT"
And I press start
Then the table has 17 rows
# Datum ist gefuellt und aufsteigend sortiert nach verfdat, unabhängig vom Lagerplatz
Then table has values
    | gebmge    | tlplatz   | tverw | verfdat     |
    | 100       | F1        | 1111  | 01.01.1995  |
    | 200       | F2        | 1111  | 01.01.1995  |
    | 100       | F1        | 2222  | 01.01.1995  |
    | 200       | F2        |       | 01.01.1995  |
    | 100       | F2        | 1111  | 15.01.1995  |
    | 100       | F2        |       | 15.01.1995  |
    | 50        | F2        | 2222  | 20.01.1995  |
    | 50        | F2        | 4444  | 20.01.1995  |
    | 50        | F1        | 1111  | 01.02.1995  |
    | 50        | F1        | 3333  | 01.02.1995  |
    | 50        | F1        | 1111  | 15.02.1995  |
    | 50        | F1        |       | 15.02.1995  |
    | 10        | F1        | 1111  | 15.03.1995  |
    | 10        | F1        | 2222  | 15.03.1995  |
    | 10        | F2        | 2222  | 15.03.1995  |
    | 10        | F1        | 3333  | 15.03.1995  |
    | 10        | F2        | 4444  | 15.03.1995  |
And I modify table
    | !row  | tmge          | tlplatzzu | tmark |
    | 1     | !dontChange   | F3        | ja    |
    | 2     | !dontChange   | F3        | ja    |
    | 3     | !dontChange   | F3        | ja    |
    | 4     | 100           | F3        | ja    |
    | 5     | !dontChange   | F3        | ja    |
And I press button "umbuch"
# die umgebuchten Bestaende behalten das verfdat und die Restmenge von Zeile 4 bleibt wie vorher
Then table has values
    | gebmge    | tlplatz   | tverw | verfdat       |
    | 100       | F2        |       | 01.01.1995    |
    | 100       | F3        | 1111  | 01.01.1995    |
    | 200       | F3        | 1111  | 01.01.1995    |
    | 100       | F3        | 2222  | 01.01.1995    |
    | 100       | F3        |       | 01.01.1995    |
    | 100       | F2        |       | 15.01.1995    |
    | 100       | F3        | 1111  | 15.01.1995    |
    | 50        | F2        | 2222  | 20.01.1995    |
    | 50        | F2        | 4444  | 20.01.1995    |
    | 50        | F1        | 1111  | 01.02.1995    |
    | 50        | F1        | 3333  | 01.02.1995    |
    | 50        | F1        | 1111  | 15.02.1995    |
    | 50        | F1        |       | 15.02.1995    |
    | 10        | F1        | 1111  | 15.03.1995    |
    | 10        | F1        | 2222  | 15.03.1995    |
    | 10        | F2        | 2222  | 15.03.1995    |
    | 10        | F1        | 3333  | 15.03.1995    |
    | 10        | F2        | 4444  | 15.03.1995    |
And I set field "verw" to "2222"
And I press start
Then table has values
    | gebmge    | tlplatz   | tverw | verfdat       |
    | 100       | F3        | 2222  | 01.01.1995    |
    | 50        | F2        | 2222  | 20.01.1995    |
    | 10        | F1        | 2222  | 15.03.1995    |
    | 10        | F2        | 2222  | 15.03.1995    |
And I modify table
    | !row  | tmge          | tlplatzzu | tmark |
    | 2     | !dontChange   | F3        | ja    |
And I press button "umbuch"
And I press start
Then table has values
    | gebmge    | tlplatz   | tverw | verfdat       |
    | 100       | F3        | 2222  | 01.01.1995    |
    | 50        | F3        | 2222  | 20.01.1995    |
    | 10        | F1        | 2222  | 15.03.1995    |
    | 10        | F2        | 2222  | 15.03.1995    |
And I close the current editor


Scenario: 01 Selektion nach Betriebsauftrag zeigt benoetigtes Material an, Teile werden umgebucht

#Given I set the fake date to "08.03.95"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SQREL_ENTMAT_1    |
    | buart     | Zugang            |
    | beleg     | LBU_SCEN01        |
    | beldat    | .                 |
    | wert      | 10.0000           |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 20     | LP-AB    |
And I save the current editor

Given I create a work order "SCEN01A" for Product "BG_SQREL" with quantity "20" and search word "SCEN01A_"

Given I open an editor "RM1_SCEN01A" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SCEN01A_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | bem       | RM1_SCEN01    |
And I set field "gutmge" to "5" in row 1
And I save the current editor

Given I open the infosystem "SQRELOCATION"
And I set fields
    | ba        | SCEN01A_000       |
    | workflow  | Bestand umbuchen  |
And I press start
Then the table has 2 rows
Then table has values
    | tartikel          | gebmge    | tlplatz   | tverw |
    | SQREL_ENTMAT_1    | -5        | LP-TAUSCH |       |
    | SQREL_ENTMAT_1    | 20        | LP-AB     |       |
And I modify table
    | !row  | tmge  | tlplatzzu |
    | 2     |  5    | LP-TAUSCH |
And I set field "tmark" to "ja" in row 2
And I press button "umbuch"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel          | gebmge    | tlplatz   | tverw |
    | SQREL_ENTMAT_1    | 15        | LP-AB     |       |
And I close the current editor

# BA loeschen, Material auf 0 setzen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCEN01A_000"
And I respond with answer "JA" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor

Given I set StorageQuantity to zero for Product "SQREL_ENTMAT_1" on StorageLocation "LP-AB"


Scenario: 02 Selektion nach Auftrag zeigt benoetigtes Material an, Teile werden umgebucht

#Given I set the fake date to "09.03.95"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SQREL_1       |
    | buart     | Zugang        |
    | beleg     | LBU_SCEN01    |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 30     | LP-AB    |
And I save the current editor

Given I create a SalesOrder "Auftrag1" for Customer "TEST" with Product "SQREL_1" and quantity "20"

Given I open an editor "Auftrag1_LS" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag1"
And I set fields
    | such   | LS_SCEN02    |
    | vom    | .            |
    | ueb    | ja           |
And I set field "mge" to "5" in row 1
And I set field "verw" to "" in row 1
And I save the current editor

Given I open the infosystem "SQRELOCATION"
And I set fields
    | auftrag   | Auftrag1  |
And I press start
Then the table has 2 rows
Then table has values
    | tartikel  | gebmge    | tlplatz   | tverw |
    | SQREL_1   | -5        | LP-TAUSCH |       |
    | SQREL_1   | 30        | LP-AB     |       |
And I modify table
    | tmge  | tlplatzzu | !row  |
    | 5     | LP-TAUSCH | 2     |
And I set field "tmark" to "ja" in row 2
And I press button "umbuch"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel  | gebmge    | tlplatz   | tverw |
    | SQREL_1   | 25        | LP-AB     |       |
And I close the current editor

# Auftrag liefern und Menge auf 0 setzen
And I deliver the SalesOrder "Auftrag1" with PackingSlip "Liefers1"
Given I set StorageQuantity to zero for Product "SQREL_1" on StorageLocation "LP-AB"


Scenario: 03 Setartikel - Selektion nach Auftrag zeigt benoetigtes Material an, Teile werden umgebucht

#Given I set the fake date to "09.03.95"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SETKOMP_SQR_1 |
    | buart     | Zugang        |
    | beleg     | LBU_SCEN03    |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 15     | LP-AB    |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SETKOMP_SQR_2 |
    | buart     | Zugang        |
    | beleg     | LBU2_SCEN03   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 20     | LP-AB    |
And I save the current editor

Given I create a SalesOrder "AUF_SET" for Customer "TEST" with Product "SET_SQREL" and quantity "10"

Given I open an editor "AUF_SET_LS" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AUF_SET"
And I set fields
    | such   | LS_SCEN03    |
    | vom    | .            |
    | ueb    | ja           |
And I set field "mge" to "5" in row 1
And I set field "verw" to "" in row 1
And I save the current editor

Given I open the infosystem "SQRELOCATION"
And I set fields
    | auftrag   | AUF_SET   |
And I press start
Then the table has 4 rows
Then table has values
    | gebmge    | tartikel      | tlplatz   | tverw         |
    | -5        | SETKOMP_SQR_1 | LP-TAUSCH |               |
    | 15        | SETKOMP_SQR_1 | LP-AB     |               |
    | -10       | SETKOMP_SQR_2 | LP-TAUSCH |               |
    | 20        | SETKOMP_SQR_2 | LP-AB     |               |
And I modify table
    | !row  | tmge  | tlplatzzu | tmark |
    | 2     | 5     | LP-TAUSCH | ja    |
    | 4     | 10    | LP-TAUSCH | ja    |
And I press button "umbuch"
And I press start
Then the table has 2 rows
Then table has values
    | gebmge    | tartikel      | tlplatz   | tverw |
    | 10        | SETKOMP_SQR_1 | LP-AB     |       |
    | 10        | SETKOMP_SQR_2 | LP-AB     |       |
And I close the current editor

# Auftrag liefern und Menge auf 0 setzen
And I deliver the SalesOrder "AUF_SET" with PackingSlip "LS4"
Given I set StorageQuantity to zero for Product "SETKOMP_SQR_1" on StorageLocation "LP-AB"
Given I set StorageQuantity to zero for Product "SETKOMP_SQR_2" on StorageLocation "LP-AB"
Given I set StorageQuantity to zero for Product "SETKOMP_SQR_1" on StorageLocation "LP-TAUSCH"
Given I set StorageQuantity to zero for Product "SETKOMP_SQR_2" on StorageLocation "LP-TAUSCH"

Scenario: 04 Selektion fuer Zugang aus Betriebsauftrag zeigt Bestaende aus diesem Zugang

#Given I set the fake date to "08.03.95"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BG_SQREL      |
    | buart     | Zugang        |
    | beleg     | LBU_ZU_SC04   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | verw          |
    | 2      | LP-ZU    | LBUZU_SCEN04  |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BG_SQREL      |
    | buart     | Abgang        |
    | beleg     | LBU_AB_SC04   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | verw          |
    | 2      | LP-AB    | LBUAB_SCEN04  |
And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge | bisuch    | verw         | mfreig |
    | BG_SQREL  | 10     | SCEN04_   | RM_SCEN04    | ja     |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "RM1_SCEN04" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SCEN04_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | bem       | RM1_SCEN04    |
And I set field "gutmge" to "5" in row 1
And I set field "erbtext1" to "RM1_SCEN04" in row 1
And I save the current editor

Given I open an editor "RM2_SCEN04" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SCEN04_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | bem       | RM2_SCEN04    |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM2_SCEN04" in row 1
And I save the current editor

# Journal zum Zugang selektieren
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==BG_SQREL;buarta==Zugang;erbtext1==RM1_SCEN04"
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==BG_SQREL;buarta==Zugang;erbtext1==RM2_SCEN04"
And I close the current editor

Given I open the infosystem "SQRELOCATION"
And I set fields
    | fertigung | 1006  |
And I press start
# nur die Zugaenge zu diesem Betriebsauftrag werden angezeigt, nicht alle Bestaende
Then the table has 2 rows
Then table has values
    | tartikel  | gebmge    | zugang^id         | tverw         |
    | BG_SQREL  | 5         | !JournalZu1^id    | RM_SCEN04     |
    | BG_SQREL  | 1         | !JournalZu2^id    | RM_SCEN04     |
And I set fields
    | artikel   | BG_SQREL      |
    | fertigung |               |
And I press start
Then the table has 4 rows
And I close the current editor

# BA loeschen, Material auf 0 setzen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCEN04_000"
And I respond with answer "JA" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor


Scenario: 05 Selektion fuer Zugang aus Einkaufsvorgang zeigt Bestaende aus diesem Zugang

#Given I set the fake date to "08.03.95"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SQREL_2       |
    | buart     | Zugang        |
    | beleg     | LBU_ZU_SC05   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | verw          |
    | 2      | LP-ZU    | LBUZU_SCEN05  |
And I save the current editor

Given I open an editor "BE_SCEN05" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | TEST       |
    | such | BE_SCEN05  |
    | vom  | .          |
And I append rows
    | artikel   | mge | einplan | verw          |
    | SQREL_2   | 3   | ja      | EKLS_SCEN05   |
And I save the current editor

And I deliver the PurchaseOrder "BE_SCEN05" with PackingSlip "LS_SCEN05"

# Journal zum Zugang selektieren
Given I open an editor "JournalZuLS1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SQREL_2;buarta==Zugang;ebeleg==LS_SCEN05"
And I close the current editor

Given I open the infosystem "SQRELOCATION"
And I set fields
    | kzugang | LS_SCEN05   |
And I press start
# nur die Zugaenge zu diesem EInakufsvorgang werden angezeigt, nicht alle Bestaende
Then the table has 1 rows
Then table has values
    | gebmge    | zugang^id         | tverw         |
    | 3         | !JournalZuLS1^id  | EKLS_SCEN05   |
And I set fields
    | artikel   | SQREL_2   |
    | kzugang   |           |
And I press start
Then the table has 2 rows
Then table has values
    | gebmge    | tverw         |
    | 3         | EKLS_SCEN05   |
    | 2         | LBUZU_SCEN05  |
And I close the current editor

Given I set StorageQuantity to zero for Product "SQREL_2" on StorageLocation "LP-ZU"
Given I set StorageQuantity to zero for Product "SQREL_2" on StorageLocation "F1"


Scenario: 06 Setartikel - Selektion nach Auftrag, Setartikel Menge 0 wird uebersprungen

#Given I set the fake date to "09.03.95"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SETKOMP_SQR_1 |
    | buart     | Zugang        |
    | beleg     | LBU_SCEN06    |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 10     | LP-AB    |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SETKOMP_SQR_2 |
    | buart     | Zugang        |
    | beleg     | LBU2_SCEN06   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 20     | LP-AB    |
And I save the current editor

Given I create a SalesOrder "AUF_SET06" for Customer "TEST" with Product "SET_SQREL" and quantity "10"

# Auftrag erweitern um 1 Position mit Setartikel und Menge 0
Given I open an editor "AUF_SET06" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AUF_SET06"
And I modify table
    | !row |  artikel   | mge |
    | +1   | SET_SQREL  | 0   |
And I save the current editor

Given I open the infosystem "SQRELOCATION"
And I set fields
    | auftrag   | AUF_SET06 |
And I press start
Then the table has 2 rows
Then table has values
    | gebmge    | tartikel      | tlplatz   | tverw         |
    | 10        | SETKOMP_SQR_1 | LP-AB     |               |
    | 20        | SETKOMP_SQR_2 | LP-AB     |               |
And I close the current editor

# Auftrag liefern und Menge auf 0 setzen
And I deliver the SalesOrder "AUF_SET06" with PackingSlip "LS06"
Given I set StorageQuantity to zero for Product "SETKOMP_SQR_1" on StorageLocation "LP-AB"
Given I set StorageQuantity to zero for Product "SETKOMP_SQR_2" on StorageLocation "LP-AB"


Scenario: 07 Materialzuordnung zuerst buchen wird vorbelegt, kann ueberstimmt werden

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SQREL_2       |
    | buart     | Zugang        |
    | beleg     | LBU_ZU_SC07   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | verw      |
    | 2      | LP-ZU    | SCEN07_1  |
    | 5      | LP-AB    | SCEN07_2  |
And I save the current editor

Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel   | SQREL_2   |
    | lgruppe   | BERLIN    |
    | ljtext    | SCEN07_1  |
And I press start
Then the table has 2 rows
Then table has values
    | tartikel  | gebmge    | tlplatz   | tverw     | tmzzuerst |
    | SQREL_2   | 2         | LP-ZU     | SCEN07_1  | ja        |
    | SQREL_2   | 5         | LP-AB     | SCEN07_2  | ja        |
Then field "tmzzuerst" is modifiable in row 1
Then field "tmzzuerst" is modifiable in row 2
And I modify table
    | !row  | tmge  | tlplatzzu | tmzzuerst |
    | 1     | 1     | LP-TAUSCH | nein      |
And I set field "tmark" to "ja" in row 1
And I press button "umbuch"
And I set field "lgruppe" to ""
And I set field "ljtext" to "SCEN07_2"
And I press start
Then the table has 3 rows
Then table has values
    | tartikel  | gebmge    | tlplatz   | tverw     | tmzzuerst |
    | SQREL_2   | 1         | LP-TAUSCH | SCEN07_1  | ja        |
    | SQREL_2   | 1         | LP-ZU     | SCEN07_1  | ja        |
    | SQREL_2   | 5         | LP-AB     | SCEN07_2  | ja        |
And I modify table
    | !row  | tmge  | tlplatzzu |
    | 3     | 2     | LP-TAUSCH |
Then field "tmzzuerst" has value "ja" in row 3
And I set field "tmark" to "ja" in row 3
And I press button "umbuch"
And I close the current editor

Given I open an editor "LBUPRUEF1" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "VIEW" for record "$,,artikel==SQREL_2;buart==Umbuchung;ljtext1==SCEN07_1;@ablageart=abgelegt"
Then field "mzzuerst" has value "nein"
And I close the current editor

Given I open an editor "LBUPRUEF2" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "VIEW" for record "$,,artikel==SQREL_2;buart==Umbuchung;ljtext1==SCEN07_2;@ablageart=abgelegt"
Then field "mzzuerst" has value "ja"
And I close the current editor


Scenario: NEU08 Bestand umbuchen mit SQRELOCATION verwendet Gebindefaktor aus Platzmenge

# in MZ vom Artikelstamm abweichenden Gebindefaktor eintragen
Given I open an editor "EKBE08" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | TEST       |
    | such | EKBE08     |
    | vom  | .          |
And I append rows
    | artikel       | mge | einplan |
    | EK-GEBINDEPFL | 20  | ja      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge | faktor  |
    | 1     | F1     | 12     | 3       |
    | +2    | F2     | 8      | 1       |
And I save the current editor
And I switch the current editor to editor "EKBE08"
And I save the current editor

And I deliver the PurchaseOrder "EKBE08" with PackingSlip "LS01"

Given I open the infosystem "SQRELOCATION"
And I set fields
    | artikel   | EK-GEBINDEPFL |
And I press start
Then the table has 2 rows
Then table has values
    | tartikel      | gebmge    | tlplatz   | tle   | tfaktor   |
    | EK-GEBINDEPFL | 12        | F1        | Paar  | 3         |
    | EK-GEBINDEPFL | 8         | F2        | Paar  | 1         |
And I modify table
    | !row  | tmge  | tlplatzzu |
    | 1     | 3     | F3        |
And I set field "tmark" to "ja" in row 1
And I press button "umbuch"
And I press start
Then the table has 3 rows
Then table has values
    | tartikel      | gebmge    | tlplatz   | tle   | tfaktor   |
    | EK-GEBINDEPFL | 9         | F1        | Paar  | 3         |
    | EK-GEBINDEPFL | 8         | F2        | Paar  | 1         |
    | EK-GEBINDEPFL | 3         | F3        | Paar  | 3         |
And I close the current editor
