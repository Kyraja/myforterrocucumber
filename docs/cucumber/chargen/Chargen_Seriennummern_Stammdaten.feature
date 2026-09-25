@persistent
Feature: Chargen_Seriennummern_Stammdaten.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Chargen_Seriennummern_Stammdaten.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Chargen-/Seriennummernverwaltung
#  ref              : ref_chargen_seriennr_cu
#
# **********************************************************************************

# Scenario 01 - 05 => Chargen automatisch anlegen
# Scenario P01 - P21 => Chargenpflichtangabe / Plausi
# Scenario V01 - V03 und V01MZ => Verfallsdatum
# Scenario R01 - R07 => Chargenreine BA
# Scenario SN01 - SN08 => Umstellen auf Seriennummernpflicht / Plausi
# Scenario BEI01CH - BEI02CH => Beistellung mit Zugangscharge, auch Teilmengen der MZ
# Scenario BEI01 - BEI05 => Einkauf mit Beistellung, nur Menge 1
# Scenario ZT01 - A1F8 => Zugangscharge in der Fertigung

Scenario: Chargenpflicht in Konfiguration einschalten

Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set fields
    | chpflicht   | ja  |
And I save the current editor

    # Lagerstruktur fuer Kundenanlieferung und Umlagerungslieferschein
Scenario Outline: Lagergruppen, Lager und Lagerplätze
Given I open an editor "<such>" from table "<table>" with command "STORE" for record "<such>"
And I set fields
  | such              | <such>                |
  | namebspr          | <namebspr>            |
  | zkonsilg          | <zkonsilg>            |
  | <lager>           | <lager2>              |
  | <ruecklieferung>  | <vkruecklieferung>    |
  | <kundenanliefer>  | <vkkundenanlieferung> |
And I save the current editor
Examples:
  | table                         | Hinweis     | such        | namebspr                  | lager   | lager2    | ruecklieferung    | vkruecklieferung  | kundenanliefer      | vkkundenanlieferung | zkonsilg    |
  | (Warehouse):(WarehouseGroup)  | LAGERGRUPPE | KONSI       | Konsignationslagergruppe  | ans     | KONSI     | staat             | Deutschland       | !dontChange         | !dontChange         | ja          |
  | (Warehouse):(Warehouse)       | LAGER       | K1          | Konsignationslager        | lgruppe | !KONSI^id | staat             | Deutschland       | !dontChange         | !dontChange         | !dontChange |
  | (Location):(Location)         | LAGERPLATZ  | KONSI1      | Konsignationslagerplatz 1 | lager   | !K1^id    | lplaenge          | 5                 | !dontChange         | !dontChange         | !dontChange |
  | (Location):(Location)         | LAGERPLATZ  | KONSI2      | Konsignationslagerplatz 2 | lager   | !K1^id    | lplaenge          | 5                 | !dontChange         | !dontChange         | !dontChange |
  | (Location):(Location)         | LAGERPLATZ  | L2F3        | Lagerplatz Hongkong 3     | lager   | L2        | lplaenge          | 5                 | !dontChange         | !dontChange         | !dontChange |
  | (Warehouse):(WarehouseGroup)  | LAGERGRUPPE | KARLSRUHE   | !dontChange               | ans     | KARLSRUHE | vkruecklieferung  | F3                | vkkundenanlieferung | KONSI1              | !dontChange |

Scenario Outline: Lieferanten und Kunden
Given I open an editor "<such>" from table "<table>" with command "STORE" for record "<such>"
And I set fields
    | such        | <such>        |
    | namebspr    | <namebspr>    |
    | ans         | <ans>         |
    | str         | <str>         |
    | plz         | <plz>         |
    | nort        | <nort>        |
    | staat       | <staat>       |
    | konsi       | <konsi>       |
    | zbed        | <zbed>        |
    | waehr       | <waehr>       |
And I save the current editor
Examples:
    | table                   | such       | namebspr              | ans      | str                 | plz         | nort            | staat       | konsi       | zbed      | waehr       |
    | (Vendor):(Vendor)       | LIEFCHA1   | Lieferant 1 Chargen  | LIEFCHA1  | Chargen Straße 1    | 12345       | Chargenstadt    | !dontChange | !dontChange | ZSOFORT   | !dontChange |
    | (Vendor):(Vendor)       | LIEFCHA2   | Lieferant 2 Chargen  | LIEFCHA2  | Chargen Straße 2    | 23456       | Chargenstadt    | !dontChange | !dontChange | Z10.3     | !dontChange |
    | (Customer):(Customer)   | KUNDECH1   | Kunde 1 Chargen      | KUNDECH1  | CHSN Straße 1       | 56789       | CHSNstadt       | !dontChange | !dontChange | ZSOFORT   | !dontChange |
    | (Customer):(Customer)   | KUNDECH2   | Kunde 2 Chargen      | KUNDECH1  | CHSN Straße 2       | 67890       | CHSNstadt       | !dontChange | KONSI2      | Z10.3     | !dontChange |


Scenario Outline: Einkaufsartikel
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such          | <such>            |
    | namebspr      | <namebspr>        |
    | bsart         | Fremdbeschaffung  |
    | dispoa        | <dispoa>          |
    | chverfolgung  | <chverfolgung>    |
    | chimlager     | <chimlager>       |
    | lief          | <lief>            |
    | efrist        | <efrist>          |
    | epr           | <epr>             |
    | vpr           | <vpr>             |
And I save the current editor

Examples:
    | such            | namebspr                            | dispoa            | chverfolgung            | chimlager     | lief        | efrist      | epr         | vpr         |
    | EK01_CHARGE     | chargenpflichtiges Teil 1           | bedarfsbezogen    | Chargenverfolgung       | ja            | LIEFCHA1    | 3           | 5           | 10          |
    | EK02_CHARGE     | chargenpflichtiges Teil 2           | bedarfsbezogen    | Chargenverfolgung       | ja            | LIEFCHA2    | 3           | 5           | 10          |
    | EK03_CHARGE     | chargenpflichtiges Teil 3           | bedarfsbezogen    | Chargenverfolgung       | ja            | LIEFCHA1    | 3           | 5           | 10          |
    | EK04_SN         | seriennummernpflichtiges Teil 4     | bedarfsbezogen    | Seriennummernverfolgung | ja            | LIEFCHA1    | 3           | 5           | 10          |
    | CHIMLAGERNEIN   | chargenpflicht ohne chimlager       | bedarfsbezogen    | Chargenverfolgung       | nein          | LIEFCHA2    | 3           | 5           | 10          |
    | NOCHARGE        | ohne Chargenpflicht                 | bedarfsbezogen    |                         | !dontChange   | TEST        | 3           | 5           | 10          |
    | NOCHARGE2       | ohne Chargenpflicht                 | bedarfsbezogen    |                         | !dontChange   | TEST        | 3           | 5           | 10          |
    | EK-UMLAGER      | chargenpflichtiges Teil umlagern    | bedarfsbezogen    | Chargenverfolgung       | ja            | LIEFCHA1    | 3           | 5           | 10          |
    | INVCHIMLAGERNO  | Inventur chimlager nein             | auftragsbezogen   |                         | !dontChange   | TEST        | 3           | 5           | 10          |
    | INVCHIMLAGERYES | Inventur chimlager ja               | auftragsbezogen   |                         | !dontChange   | TEST        | 3           | 5           | 10          |
    | INVNOCHARGE     | Inventur ohne Charge                | auftragsbezogen   |                         | !dontChange   | TEST        | 3           | 5           | 10          |
    | KOPPELCHARGE    | Koppelprodukt mit Charge            | bedarfsbezogen    | Chargenverfolgung       | !dontChange   | TEST        | 3           | 5           | 10          |
    | EKBEI           | chargenpflichtiges Beistellteil     | bedarfsbezogen    | Chargenverfolgung       | ja            | TEST        | 3           | 5           | 10          |
    | SET_KOMP01_CH   | chargenpflichtig Setkomponente 1    | bedarfsbezogen    | Chargenverfolgung       | ja            | TEST        | 3           | 5           | 10          |
    | SET_KOMP02_CH   | chargenpflichtig Setkomponente 2    | bedarfsbezogen    | Chargenverfolgung       | ja            | TEST        | 3           | 5           | 10          |


Scenario Outline: Baugruppen mit zwei Komponenten und zwei Arbeitsgängen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such          | <such>            |
    | namebspr      | <namebspr>        |
    | dispoa        | <dispoa>          |
    | bsart         | Eigenfertigung    |
    | chverfolgung  | <chverfolgung>    |
And I delete all rows
And I append rows
    | elex      | anzahl    | ikompeig      | manbu         |
    | <elex1>   | <anzahl1> | !dontChange   | <manbu>       |
    | <elex2>   | <anzahl2> | <ikompeig>    | !dontChange   |
    | <elex3>   | <anzahl3> | !dontChange   | !dontChange   |
    | <elex4>   | <anzahl4> | !dontChange   | !dontChange   |
And I save the current editor
Examples:
    | such              | namebspr                        | dispoa          | chverfolgung            | elex1          | anzahl1 | manbu | elex2          | ikompeig      | anzahl2   | elex3          | anzahl3   | elex4   | anzahl4 |
    | BG01_CHARGE       | chargenpflichtige Baugruppe 1   | bedarfsbezogen  | Chargenverfolgung       | EK01_CHARGE    | 1       | nein  | A AG2          | !dontChange   | 1         | EK02_CHARGE    | 1         | A AG3   | 1       |
    | BG02_CHARGE       | chargenpflichtige Baugruppe 2   | bedarfsbezogen  | Chargenverfolgung       | EINK           | 1       | nein  | A AG2          | !dontChange   | 1         | BAUT           | 1         | A AG3   | 1       |
    | BG_CHARGE_KOPPEL  | chargenpflicht BG Koppelprodukt | bedarfsbezogen  | Chargenverfolgung       | EK01_CHARGE    | 1       | nein  | KOPPELCHARGE   | Koppelprodukt | 1         | A AG2          | 1         | A AG3   | 1       |
    | BG_M_CHARGE       | chargenpflichtige Baugruppe 1   | bedarfsbezogen  | Chargenverfolgung       | EK01_CHARGE    | 1       | ja    | A AG2          | !dontChange   | 1         | EK02_CHARGE    | 1         | A AG3   | 1       |
    | BG03_SN           | seriennrpflichtige Baugruppe 3  | bedarfsbezogen  | Seriennummernverfolgung | EK04_SN        | 1       | nein  | A AG2          | !dontChange   | 1         | BAUT           | 1         | A AG3   | 1       |
    | BG04_SN           | seriennrpflichtige Baugruppe 4  | bedarfsbezogen  | Seriennummernverfolgung | EK04_SN        | 1       | nein  | A AG2          | !dontChange   | 1         | BAUT           | 1         | A AG3   | 1       |

Scenario Outline: Baugruppen chargenrein mit einer Komponente und zwei Arbeitsgängen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such              | <such>            |
    | namebspr          | <namebspr>        |
    | dispoa            | <dispoa>          |
    | bsart             | Eigenfertigung    |
    | chverfolgung      | <chverfolgung>    |
    | chargenreinstd    | <chargenreinstd>  |
And I delete all rows
And I append rows
    | elex      | anzahl    |
    | <elex1>   | <anzahl1> |
    | <elex2>   | <anzahl2> |
    | <elex3>   | <anzahl3> |
And I save the current editor
Examples:
    | such              | namebspr              | dispoa          | chverfolgung        | chargenreinstd    | elex1 | anzahl1 | elex2   | anzahl2   | elex3   | anzahl3 |
    | BG_CHA_REIN_MANBU | chargenrein manbu     | bedarfsbezogen  | Chargenverfolgung   | ja                | EINK  | 1       | A AG2   | 1         | A AG3   | 1       |
    | BG_CHA_REIN_RETRO | chargenrein retrograd | bedarfsbezogen  | Chargenverfolgung   | ja                | EINK  | 1       | A AG2   | 1         | A AG3   | 1       |

Scenario: Einkaufsartikel mit Beistellung und Setartikel anlegen

Given I open an editor "KT-BEISTELL" from table "(Part):(Product)" with command "STORE" for record "KT-BEISTELL"
And I set fields
    | such          | KT-BEISTELL                |
    | namebspr      | Kaufteil mit Beistellung   |
    | bsart         | Fremdbeschaffung           |
    | lief          | LIEFCHA2                   |
    | chverfolgung  | Chargenverfolgung          |
And I delete all rows
And I append rows
    | elex  | elanzahl  | bua                       |
    | EKBEI | 1         | Lieferantenbeistellung    |
And I save the current editor

Given I open an editor "SET-CHARGE" from table "(Part):(Product)" with command "STORE" for record "SET-CHARGE"
And I set fields
    | such          | SET-CHARGE                    |
    | namebspr      | chargenpflichtiger Setartikel |
    | earta         | über Stückliste               |
    | chverfolgung  | Chargenverfolgung             |
And I delete all rows
And I append rows
    | elex          | elanzahl  |
    | SET_KOMP01_CH | 1         |
    | SET_KOMP02_CH | 2         |
And I save the current editor

Scenario: Baugruppe anlegen

# Baugruppe mit 2 Komponenten und 3 Arbeitsgaengen anlegen
Given I open an editor "BG01_CHARGE" from table "(Part):(Product)" with command "COPY" for record "BG01_CHARGE"
And I set fields
    | such          | BG03_CHARGE                |
    | namebspr      | Baugruppe 3 Arbeitsgaenge  |
    | bsart         | Eigenfertigung             |
    | chverfolgung  | Chargenverfolgung          |
And I append rows
    | elex  | elanzahl  |
    | A AG2 | 1         |
And I save the current editor

# Baugruppe mit 2 Komponenten und unterschiedlichem Faktor anlegen
Given I open an editor "BG01_CHARGE" from table "(Part):(Product)" with command "COPY" for record "BG01_CHARGE"
And I set fields
    | such          | BG04_CHARGE                |
    | namebspr      | Baugruppe 4 Faktor         |
    | bsart         | Eigenfertigung             |
    | chverfolgung  | Chargenverfolgung          |
And I set field "elanzahl" to "2" in row 3
And I save the current editor

# Baugruppe mit 1 Komponente retrograd und 1 Arbeitsgang anlegen
Given I open an editor "BG01_CHARGE" from table "(Part):(Product)" with command "COPY" for record "BG01_CHARGE"
And I set fields
    | such          | BG11_CHARGE                |
    | namebspr      | Baugruppe 1 Mat und 1 AG   |
    | bsart         | Eigenfertigung             |
    | chverfolgung  | Chargenverfolgung          |
And I delete row at position 4
And I delete row at position 3
And I save the current editor
