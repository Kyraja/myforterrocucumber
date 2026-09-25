@persistent
Feature: allocatestock.feature

# **********************************************************************************
#  Name             : allocatestock.feature
#  Autor            : tiwe
#  Verantwortlich   : teaminfosysteme
#  Kontrolle        : cl
#  Funktion         : Testet Infosystem ALLOCATESTOCK (Bestand zuordnen)
#
# **********************************************************************************

Background:
Given I set the fake date to "02.01.1995"
Given I enable the flag 39

Scenario: STAMMDATEN - Neuen Lieferanten anlegen
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "REUS"
And I set field "such" to "REUS"
And I set field "namebspr" to "Reus Werkzeugbau, Rastatt"
And I set field "ans" to "Reus Werkzeugbau GmbH"
And I set field "str" to "Riedstr. 24-28"
And I set field "plz" to "76437"
And I set field "nort" to "Rastatt"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@bayram-corp.de"
And I set field "betreuer" to "."
And I set field "ans2" to "Reus Fussball GmbH"
And I set field "str2" to "Bvbstr. 24-28"
And I set field "plz2" to "33333"
And I set field "nort2" to "Dortmund"
And I set field "ustid" to "DE56454651"
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I save the current editor

Scenario: STAMMDATEN - Neuen Kunden anlegen UNSERE FIRMA
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "DUEMMEL"
And I set field "such" to "DUEMMEL"
And I set field "namebspr" to "Dümmel - wir verkaufen alles"
And I set field "ans" to "Dümmel - wir kaufen alles"
And I set field "str" to "Musterweg"
And I set field "plz" to "71263"
And I set field "nort" to "Weil der Stadt"
And I set field "staat" to "Deutschland"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@unserefirma.de"
And I set field "betreuer" to "."
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I set field "ustid" to "DE123456"
And I save the current editor

# Projektkostenrechnung einschalten
Given I open an editor "config" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "projekt" to "ja"
And I save the current editor

Scenario Outline: Projekte anlegen
Given I open an editor "<such>" from table "(Transaction):(Project)" with command "STORE" for record "<such>"
And I set fields
    | such     | <such>     |
    | namebspr | <namebspr> |
And I save the current editor

Examples: Projekte
| such      | namebspr  |
| PROJEKT1  | Projekt 1 |
| PROJEKT2  | Projekt 2 |
| PROJEKT3  | Projekt 3 |

Scenario Outline: STAMMDATEN - neue Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "bsart" to "<bsart>"
And I set field "earta" to "<earta>"
And I set field "dispoa" to "<dispoa>"
And I set field "lief" to "<lief>"
And I set field "epr" to "<epr>"
And I set field "efrist" to "<efrist>"
And I save the current editor

Examples: Artikel
| such            | namebspr                         | vkbez        |    vbez       | ebez          | vpr    | bsart             | earta          |dispoa                   | lief | epr  | efrist   |
| RAD             | 28 Zoll Rad                      | 28 Zoll Rad  | 28 Zoll Rad   | 28 Zoll Rad   | 100    | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| KLINGEL         | Klingel                          | Klingel      | Klingel       | Klingel       | 10     | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| RAHMEN          | Rahmen                           | Rahmen       | Rahmen        | Rahmen        | 150    | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| SATTEL          | Sattel                           | Sattel       | Sattel        | Sattel        | 50     | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| KOMP1           | Komponente 1                     | Komponente 1 | Komponente 1  | Komponente 1  | 10     | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| KOMP2           | Komponente 2                     | Komponente 2 | Komponente 2  | Komponente 2  | 20     | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| KOMP3           | Komponente 3                     | Komponente 3 | Komponente 3  | Komponente 3  | 30     | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| DRAHT           | Draht                            | Draht        | Draht         | Draht         | 40     | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| AUFTRAG         | Auftrag                          | Auftrag      | Auftrag       | Auftrag       | 40     | Fremdbeschaffung  | über Artikel   | auftragsbezogen         | reus | 9000 | 15       |
| PROJEKT         | Projekt                          | Projekt      | Projekt       | Projekt       | 40     | Fremdbeschaffung  | über Artikel   | projektbezogen          | reus | 9000 | 15       |
| ARTBEH          | Artikel im Behälter              | Behälter     | Behälter      | Behälter      | 40     | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| NEGBEST         | Negative Bestände                | Negativ      | Negativ       | Negativ       | 10     | Fremdbeschaffung  | über Artikel   | auftragsbezogen         | reus | 9000 | 15       |
| KEINE1          | Entnahmeart keine und Mindest    | Keine        | Keine         | Keine         | 15     | Fremdbeschaffung  | Keine          | mindestbestandsbezogen  | reus | 9000 | 15       |
| KEINE2          | Entnahmeart keine und Restmge    | Keine        | Keine         | Keine         | 15     | Fremdbeschaffung  | Keine          | restmengenbezogen       | reus | 9000 | 15       |
| KEINE3          | Entnahmeart keine und leer       | Keine        | Keine         | Keine         | 15     | Fremdbeschaffung  | Keine          |                         | reus | 9000 | 15       |
| KOPPEL          | Koppelprodukte                   | Koppel       | Koppel        | Koppel        | 15     | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| UMBAU           | Umbauartikel                     | Umbau        | Umbau         | Umbau         | 15     | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| EINHEITEN       | Artikel mit vers. Einheiten      | Einheiten    | Einheiten     | Einheiten     | 15     | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| CHARGEN         | Artikel mit Chargenpflicht       | Charge       | Charge        | Charge        | 15     | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| CHARGENREIN     | Artikel Chargenrein              | Chargenrein  | Chargenrein   | Chargenrein   | 15     | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| BGCHARGE        | Baugruppe mit Chargen in FL      | BG mit CH    | BG mit CH     | BG mit CH     | 15     | Eigenfertigung    | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |
| SERIENNR        | Seriennnummernpflicht            | SNR          | SNR           | SNR           | 15     | Fremdbeschaffung  | über Artikel   | bedarfsbezogen          | reus | 9000 | 15       |

Scenario Outline: Behälter anlegen
Given I open an editor "<such>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set fields
    | nummer | <nummer>  |
    | such   | <such>    |
    | packm  | BEHAELTER |
And I save the current editor

Examples:
|nummer| such        |
|  1   | BEHAELTER_1 |

Scenario: Eigenfertigungsartikel Fahrad anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "Fahrrad"
And I set fields
    | such      | Fahrrad         |
    | namebspr  | Fahrrad         |
    | dispoa    | bedarfsbezogen  |
    | bsart     | Eigenfertigung  |
    | earta     | über Artikel    |
And I delete all rows
And I append rows
    | elex       | elanzahl |  kompeig        |
    | RAD        | 2        |                 |
    | KLINGEL    | 1        |                 |
    | RAHMEN     | 1        |                 |
    | KOPPEL     | 1        | Koppelprodukt   |
    | UMBAU      | 1        | Umbauartikel    |
    | A AG1      | 1        |                 |
And I save the current editor

Scenario: Setartikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "Setartikel"
And I set fields
    | such      | SETARTIKEL      |
    | namebspr  | Setartikel      |
    | dispoa    | bedarfsbezogen  |
    | bsart     | Eigenfertigung  |
    | earta     | über Stückliste |
And I delete all rows
And I append rows
    | elex       | elanzahl |
    | KOMP1      | 1        |
    | KOMP2      | 2        |
    | KOMP3      | 3        |
And I save the current editor

Scenario: Setkomponenten anlegen
Given I open an editor "KOMP1" from table "(Part):(Product)" with command "COPY" for record "KOMP1"
And I set fields
    | such      | KOMP1CHA_KG       |
    | namebspr  | Charge und LE kg  |
    | le        | kg                |
And I save the current editor

Given I open an editor "KOMP2" from table "(Part):(Product)" with command "COPY" for record "KOMP2"
And I set fields
    | such      | KOMP2STUECK               |
    | namebspr  | keine Charge und Stueck   |
And I save the current editor

Given I open an editor "KOMP3" from table "(Part):(Product)" with command "COPY" for record "KOMP3"
And I set fields
    | such      | KOMP3CHA_MT       |
    | namebspr  | Charge und LE mt  |
    | le        | m                 |
And I save the current editor

Scenario Outline: Artikel CHARGENREIN updaten - Chargenverfolgung einstellen
Given I open an editor "<such>" from table "(Part):(Product)" with command "UPDATE" for record "<such>"
And I set fields
    | chverfolgung   | Chargenverfolgung    |
    | chimlager      | ja                   |
    | chargenreinstd | ja                   |
And I save the current editor

Examples:
    | such          |
    | Chargenrein   |
    | KOMP1CHA_KG   |
    | KOMP3CHA_MT   |

Scenario: Setartikel mit verschiedenen Einheiten anlegen
Given I open an editor "SETEINHEITEN" from table "(Part):(Product)" with command "STORE" for record "SETEINHEITEN"
And I set fields
    | such      | SETEINHEITEN          |
    | namebspr  | Setartikel kg und mt  |
    | le        | kg                    |
    | dispoa    | bedarfsbezogen        |
    | bsart     | Eigenfertigung        |
    | earta     | über Stückliste       |
And I delete all rows
And I append rows
    | elex          | elanzahl | pverlust   |
    | KOMP1CHA_KG   | 1        | 10         |
    | KOMP2STUECK   | 2        |            |
    | KOMP3CHA_MT   | 3        |            |
And I save the current editor

Scenario: Baugruppe mit chargenpflichtigen Komponenten
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "bgcharge"
And I delete all rows
And I append rows
    | elex        | elanzahl |
    | CHARGENREIN | 1        |
    | A AG1       | 1        |
And I save the current editor


Scenario: EK-Artikel mit Lieferantenbeistellung
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "Bremse"
And I set fields
    | such      | BREMSE          |
    | namebspr  | Bremse          |
    | dispoa    | bedarfsbezogen  |
    | bsart     | Eigenfertigung  |
    | earta     | über Artikel |
And I delete all rows
And I append rows
    | elex       | elanzahl | bua                    |
    | DRAHT      | 1        | Lieferantenbeistellung |
And I save the current editor

Scenario: Artikel EINHEITEN updaten - verschiedene Einheiten einstellen
Given I open an editor "<such>" from table "(Part):(Product)" with command "UPDATE" for record "Einheiten"
# Lagereinheit ist Stück
# andere Einheiten sind Paar (1 Paar -> 2 Stück) und Tonne (1 Tonne  -> 500 Stück)
And I set fields
        | vhe      | Paar    |
        | gebvhe   | ja      |
        | ehe      | t       |
        | fehle    | 500     |
        | gebehe   | ja      |
And I save the current editor

Scenario: Artikel CHARGEN updaten - Chargenverfolgung einstellen
Given I open an editor "<such>" from table "(Part):(Product)" with command "UPDATE" for record "Chargen"
And I set fields
        | chverfolgung  | Chargenverfolgung    |
        | chimlager     | ja                   |
And I save the current editor

Scenario: Artikel SERIENNR updaten - Seriennummernverfolgung einstellen
Given I open an editor "<such>" from table "(Part):(Product)" with command "UPDATE" for record "Seriennr"
And I set fields
        | chverfolgung  | Seriennummernverfolgung |
        | chimlager     | ja                      |
And I save the current editor



Scenario: Artikel Blech 2mm neu  anlegen
Given I open an editor "BLECH2MM" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
        | such      | BLECH2MM               |
        | namebspr  | Blech Edelstahl 2 mm   |
        | name14    | Sheet Stainless Steel  |
        | bsart     | Fremdbeschaffung       |
        | mindest   | 50   |
        | lief      | Reus |
        | efrist    | 25   |
        | epr       | 10   |
        | le        | m2   |
        | vhe       | m2   |
        | fvhle     | 1    |
        | vpe       | m2   |
        | fvple     | 1    |
        | ehe       | kg   |
        | fehle     | 2.3  |
        | epe       | kg   |
        | feple     | 2.3  |
        | ve        | m2   |
        | fvele     | 1    |
        | ge        | m2   |
        | flme      | 1000 |
        | fbme      | 1000 |
        | gebehe    | ja   |
        | gebepe    | ja   |
And I save the current editor

Scenario: Gehäuse (Casing) anlegen
    Given I open an editor "CASING" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
    | such2   | CASING-T           |
    | name    | Casing Pumpe Terra |
    | name2   | Casing Pump Terra  |
    |bsart    | Eigenfertigung     |
    | losgr   | 12                 |
    And I append rows
    | elem      |  anzahl  |   lge    |  breite   |
    | BLECH2MM  | 1        | 1250     |    675    |
    | A AG1     | 1        | 12       |    7      |
    And I save the current editor

# Bestände für die Artikel zubuchen
Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | RAD   |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge   | platz2 |
      | +1    | 100   | F1     |
      | +2    | 100   | F2     |
      | +3    | 100   | L3F1   |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | KLINGEL   |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge   | platz2 |
      | +1    | 10    | F1     |
      | +2    | 40    | F2     |
And I save the current editor


Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | KOMP1    |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge   | platz2 |
      | +1    | 100   | F1     |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | KOMP2    |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge   | platz2 |
      | +1    | 100   | F1     |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | KOMP3    |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge   | platz2 |
      | +1    | 100   | F1     |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | AUFTRAG  |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge   | platz2 | verw       |
      | +1    | 100   | F1     | 123456     |
      | +2    | 10    | F1     | A          |
      | +3    | 10    | F1     | 12345      |
      | +4    | 10    | F1     |            |
And I save the current editor


Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | PROJEKT  |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge   | platz2 | projekt    |
      | +1    | 1     | F1     | PROJEKT1   |
      | +2    | 1     | F1     | PROJEKT2   |
      | +3    | 1     | F1     | PROJEKT3   |
      | +4    | 1     | F1     |            |
And I save the current editor


Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | ARTBEH  |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge   | platz2 | behaelter    |
      | +1    | 10   | F1      | BEHAELTER_1  |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | NEGBEST  |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge   | platz2 |  verw     |
      | +1    | 10   | F1      |  1111     |
      | +2    | 10   | F2      |  1111     |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | NEGBEST  |
      | beleg       | ABG      |
      | beldat      | .        |
      | buart       | Abgang   |
And I modify table
      | !row  | mge   | platz |  verw   |
      | +1    | 10    | F2    |  2222   |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | KEINE1   |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge   | platz2 |
      | +1    | 10   | F1      |
      | +2    | 10   | F2      |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | KEINE2   |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge  | platz2 |
      | +1    | 10   | F1      |
      | +2    | 10   | F2      |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | KEINE3   |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge  | platz2 |
      | +1    | 10   | F1      |
      | +2    | 10   | F2      |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | KOPPEL   |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge  | platz2 |
      | +1    | 10   | F1     |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | UMBAU   |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge  | platz2 |
      | +1    | 10   | F1     |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | EINHEITEN |
      | beleg       | ZUG       |
      | beldat      | .         |
      | buart       | Zugang    |
And I modify table
      | !row  | mge  | ze    |  platz2 |
      | +1    | 1    | t     |  F1     |
      | +2    | 1    | Stück |  F1     |
      | +3    | 1    | Paar  |  F1     |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | CHARGEN   |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge  | platz2  | tcharge2 |
      | +1    | 100  | F1      | 1111     |
      | +2    | 100  | F1      | 2222     |
      | +3    | 20   | F2      | 3333     |
      | +4    | 20   | F2      | 4444     |
      | +5    | 20   | F2      | 5555     |
      | +6    | 20   | F2      | 6666     |
      | +7    | 20   | F2      | 7777     |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | CHARGENREIN |
      | beleg       | ZUG         |
      | beldat      | .           |
      | buart       | Zugang      |
And I modify table
      | !row  | mge  | platz2  | tcharge2 |
      | +1    | 100  | F1      | 1111     |
      | +2    | 100  | F1      | 2222     |
      | +3    | 50   | F2      | 1111     |
      | +4    | 20   | F2      | 4444     |
      | +5    | 20   | F2      | 5555     |
      | +6    | 20   | F2      | 6666     |
      | +7    | 50   | F2      | 1111     |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | SERIENNR    |
      | beleg       | ZUG         |
      | beldat      | .           |
      | buart       | Zugang      |
And I modify table
      | !row  | mge  | platz2  | tcharge2 |
      | +1    | 1    | F1      | S1       |
      | +2    | 1    | F1      | S2       |
      | +3    | 1    | F2      | S3       |
      | +4    | 1    | F2      | S4       |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | KOMP1CHA_KG   |
      | beleg       | ZUGANG_CHA1   |
      | beldat      | .             |
      | buart       | Zugang        |
And I append rows
      | mge  | platz2  | tcharge2 |
      | 10   | F1      | CHA1     |
      | 5    | F2      | CHA2     |
      | 7    | F3      | CHA3     |
      | 12   | F2      | CHA4     |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | KOMP2STUECK   |
      | beleg       | ZUGANG_2      |
      | beldat      | .             |
      | buart       | Zugang        |
And I append rows
      | mge  | platz2  |
      | 10   | F1      |
      | 40   | F2      |
      | 21   | F3      |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | KOMP3CHA_MT   |
      | beleg       | ZUGANG_CHA3   |
      | beldat      | .             |
      | buart       | Zugang        |
And I append rows
      | mge  | platz2  | tcharge2 |
      | 30   | F1      | CHA5     |
      | 15   | F2      | CHA6     |
      | 21   | F3      | CHA7     |
      | 40   | F2      | CHA8     |
And I save the current editor


Scenario: 01 Auftrag anlegen und Lieferschein erzeugen, dann ALLOCATESTOCK öffnen

# Auftrag
Given I open an editor "AUF001" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | DUEMMEL  |
   | such   | AUF001   |
And I append rows
   | artikel    | he    | mge |
   | RAD        | Stück | 100 |
   | SETARTIKEL | Stück | 100 |
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "AUF001"
Then field "abgelegt" has value "nein"
Then field "auftrag" has value "ja"
Then field "vkposition" has value "nein"
Then field "vkkopf^id" has value "!AUF001^id"
Then field "vkkunde^id" has value "!AUF001^kunde^id"
And I press start
Then the table has 4 rows
    Then table has values
    | tartikel    | tbedarfsausloeser | tmge    | teinheit     | tlgruppe     |  taufklappen       | tbemerkung   |
    | RAD         |                   | 100     | Stück        | KARLSRUHE    | icon:folder_closed |              |
    | KOMP1       | SETARTIKEL        | 100     | Stück        | KARLSRUHE    | icon:folder_closed |              |
    | KOMP2       | SETARTIKEL        | 200     | Stück        | KARLSRUHE    | icon:folder_closed |              |
    | KOMP3       | SETARTIKEL        | 300     | Stück        | KARLSRUHE    | icon:folder_closed |              |
And I close the current editor

# Lieferschein LSVK001 aus Auftrag AUF001
Given I open an editor "LSVK001" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AUF001"
And I set fields
   | such   | LSVK001  |
   | vom    | .        |
Then the table has 2 rows
And I set field "mge" to "100" in row 1
And I set field "mge" to "100" in row 2
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "LSVK001"
Then field "abgelegt" has value "nein"
Then field "vkls" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 4 rows
Then table has values
    | tartikel    | tmge    | teinheit     | tlgruppe     |  taufklappen       | tbemerkung   |
    | RAD         | 100     | Stück        | KARLSRUHE    | icon:folder_closed |              |
    | KOMP1       | 100     | Stück        | KARLSRUHE    | icon:folder_closed |              |
    | KOMP2       | 200     | Stück        | KARLSRUHE    | icon:folder_closed |              |
    | KOMP3       | 300     | Stück        | KARLSRUHE    | icon:folder_closed |              |
And I close the current editor

Scenario: 02 Einkaufsbestellung anlegen und Lieferschein erzeugen, dann ALLOCATESTOCK öffnen

# Bestellung
Given I open an editor "BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | REUS  |
   | such   | BE001   |
And I append rows
   | artikel    | he    | mge  |
   | RAD        | Stück | 100  |
   | BREMSE     | Stück | 100  |
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "BE001"
Then field "abgelegt" has value "nein"
Then field "bestellung" has value "ja"
Then field "ekposition" has value "nein"
Then field "ekkopf^id" has value "!BE001^id"
Then field "eklief^id" has value "!BE001^lief^id"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel | tbedarfsausloeser | tmge    | teinheit     | tlgruppe     |  taufklappen       | tbemerkung                 |
    | DRAHT    | BREMSE            | 100     | Stück        | KARLSRUHE    |  icon:stop         | Kein Bestand vorhanden.    |
And I close the current editor

# Lieferschein LSEK001 aus Auftrag BE001
Given I open an editor "LSEK001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE001"
And I set fields
   | such   | LSEK001  |
   | ebeleg | LSEK001  |
   | vom    | .        |
Then the table has 2 rows
And I set field "mge" to "100" in row 1
And I set field "mge" to "100" in row 2
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "LSEK001"
Then field "abgelegt" has value "nein"
Then field "ekls" has value "ja"
Then field "ekposition" has value "nein"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel    | tmge    | teinheit     | tlgruppe     |  taufklappen       | tbemerkung                  |
    | DRAHT       | 100     | Stück        | KARLSRUHE    |  icon:stop         | Kein Bestand vorhanden.     |

And I close the current editor

Scenario: 03 Belege ohne eres anlegen über Lieferschein neu

# Lieferschein neu im Einkauf
Given I open an editor "LSEK002" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | REUS         |
   | such   | LSEK002      |
   | vom    | .            |
   | ebeleg | LSEK002      |
And I append rows
   | artikel    | he    | mge  |
   | RAD        | Stück | 100  |
   | BREMSE     | Stück | 100  |
And I save the current editor

# Im Infosystem erscheint nur eine Zeile für die Lieferantenbeistellung
# Diese Zeile kann nicht bearbeitet werden da es keinen eres gibt
Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "LSEK002"
Then field "abgelegt" has value "nein"
Then field "ekls" has value "ja"
Then field "ekposition" has value "nein"
And I press start
Then the table has 1 rows
Then table has values
# Bei tartikel steht nun die Bremse und nicht die Lieferantenbeistellung Draht
# über den eres würde man den Draht sehen, man hat hat aber keinen eres
    | tartikel       | tmge     |teinheit   |taufklappen    | tbemerkung                  |
    | BREMSE         | 100      | Stück     | icon:stop     | Keine Reservierung gefunden.|
And I close the current editor


# Lieferschein neu im Verkauf
Given I open an editor "LSVK002" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | DUEMMEL   |
   | such   | LSVK002   |
And I append rows
   | artikel    | he    | mge |
   | RAD        | Stück | 100 |
   | SETARTIKEL | Stück | 100  |
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "LSVK002"
Then field "abgelegt" has value "nein"
Then field "vkls" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 2 rows
Then table has values
# Bei tartikel steht nun die Bremse und nicht die Lieferantenbeistellung Draht
# über den eres würde man den Draht sehen, man hat hat aber keinen eres
    | tartikel       | tmge     |teinheit   |taufklappen    | tbemerkung                  |
    | RAD            | 100      | Stück     | icon:stop     | Keine Reservierung gefunden.|
    | SETARTIKEL     | 100      | Stück     | icon:stop     | Keine Reservierung gefunden.|
And I close the current editor
    
    
Scenario: 04 Vorgang ist bereits abgeschlossen, der Lieferschein wurde bereits gebucht.
    
# Auftrag
Given I open an editor "AUF002" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | DUEMMEL  |
   | such   | AUF002   |
And I append rows
   | artikel    | he    | mge |
   | RAD        | Stück | 100 |
And I save the current editor
    
Given I open an editor "LSVK003" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AUF002"
And I set fields
   | such   | LSVK003  |
   | vom    | .        |
   | ueb    | ja       |
Then the table has 1 rows
And I set field "mge" to "100" in row 1
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "LSVK003"
Then field "abgelegt" has value "ja"
Then field "vkls" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 0 rows
And I close the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "AUF002"
Then field "abgelegt" has value "ja"
Then field "auftrag" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 0 rows
And I close the current editor

    # Bestellung
Given I open an editor "BE002" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | REUS  |
   | such   | BE002   |
And I append rows
   | artikel    | he    | mge  |
   | BREMSE     | Stück | 100  |
And I save the current editor

Given I open an editor "LSEK003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE002"
And I set fields
   | such   | LSEK003  |
   | ebeleg | LSEK003  |
   | vom    | .        |
   | ueb    | ja       |
Then the table has 1 rows
And I set field "mge" to "100" in row 1
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "LSEK003"
Then field "abgelegt" has value "ja"
Then field "ekls" has value "ja"
Then field "ekposition" has value "nein"
And I press start
Then the table has 0 rows
And I close the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "BE002"
Then field "abgelegt" has value "ja"
Then field "bestellung" has value "ja"
Then field "ekposition" has value "nein"
And I press start
Then the table has 0 rows
And I close the current editor


Scenario: 05 Fertigungsvorschlag
# nur FV anlegen
Given I open an editor "FVOR" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | FAHRRAD        | 10         | FR1       | nein      |
And I save the current editor
And I run Scheduling

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "FVOR"
Then field "abgelegt" has value "nein"
Then field "fv" has value "ja"
Then field "ekposition" has value "nein"
Then field "vkposition" has value "nein"
Then field "banr" is empty
Then field "baugruppe^id" has value "!FVOR^artikel^id"
And I press start
Then the table has 3 rows
Then table has values
    | tartikel       | tmge     |teinheit   |taufklappen           | tbemerkung                    |
    | RAD            |  20      | Stück     | icon:folder_closed   |                               |
    | KLINGEL        |  10      | Stück     | icon:folder_closed   |                               |
    | RAHMEN         |  10      | Stück     | icon:stop            | Kein Bestand vorhanden.       |
And I close the current editor


Scenario: 06 Betriebsauftrag
# FV anlaegen und zu BA freigeben

Given I open an editor "BA" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | FAHRRAD        | 20         | FR2       | ja        |
    | FAHRRAD        | 30         | FR3       | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "BA"
And I save the current editor
And I run Scheduling

Given I open the infosystem "ALLOCATESTOCK"
#Datenbank 9 mit BA FR2000
And I set field "vorgang" to "9 FR2000"
Then field "abgelegt" has value "nein"
Then field "ba" has value "ja"
Then field "ekposition" has value "nein"
Then field "vkposition" has value "nein"
Then field "banr^id" is not empty
Then field "baugruppe^id" is not empty
And I press start
Then the table has 3 rows
Then table has values
    | tartikel       | tmge     |teinheit   |taufklappen           | tbemerkung                    |
    | RAD            |  40      | Stück     | icon:folder_closed   |                               |
    | KLINGEL        |  20      | Stück     | icon:folder_closed   |                               |
    | RAHMEN         |  20      | Stück     | icon:stop            | Kein Bestand vorhanden.       |
And I press button "taufklappen" in row 1
Then the table has 4 rows
Then table has values
    | tartikel       | tmge     |teinheit   |taufklappen           | tlpmge    | tlpeinheit  | tlp    | tbemerkung                |
    | RAD            |  40      | Stück     | icon:folder_opened   |           |             |        |                           |
    |                |          |           |                      |  100      | Stück       | F2     |                           |
    | KLINGEL        |  20      | Stück     | icon:folder_closed   |           |             |        |                           |
    | RAHMEN         |  20      | Stück     | icon:stop            |           |             |        | Kein Bestand vorhanden.   |
And I press button "taufklappen" in row 1
Then the table has 3 rows
    Then table has values
    | tartikel       | tmge     |teinheit   |taufklappen           | tlpmge    | tlpeinheit  | tlp    | tbemerkung                |
    | RAD            |  40      | Stück     | icon:folder_closed   |           |             |        |                           |
    | KLINGEL        |  20      | Stück     | icon:folder_closed   |           |             |        |                           |
    | RAHMEN         |  20      | Stück     | icon:stop            |           |             |        | Kein Bestand vorhanden.   |
And I close the current editor

# Nun eine MZ für die Reservierungen von BA FR2000 anlegen
Given I open an editor "FR2000" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FR2000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   |
    | +1    | F2     | 40       |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   |
    | +1    | F1     | 10       |
    | +1    | F2     | 10       |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "FR2000"
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
#Datenbank 9 mit BA FR2000
And I set field "vorgang" to "9 FR2000"
Then field "abgelegt" has value "nein"
Then field "ba" has value "ja"
Then field "ekposition" has value "nein"
Then field "vkposition" has value "nein"
And I press start
Then the table has 3 rows
Then table has values
    | tartikel       | tmge     |teinheit   |taufklappen           | tbemerkung                    |
    | RAD            |  40      | Stück     | icon:ok              | Vollständige Materialzuordnung vorhanden.  |
    | KLINGEL        |  20      | Stück     | icon:ok              | Vollständige Materialzuordnung vorhanden.  |
    | RAHMEN         |  20      | Stück     | icon:stop            | Kein Bestand vorhanden.       |
#Datenbank 9 mit BA FR3000
And I set field "vorgang" to "9 FR3000"
Then field "abgelegt" has value "nein"
Then field "ba" has value "ja"
Then field "ekposition" has value "nein"
Then field "vkposition" has value "nein"
And I press start
Then the table has 3 rows
Then table has values
    | tartikel       | tmge     |teinheit   |taufklappen           | tbemerkung                    |
    | RAD            |  60      | Stück     | icon:folder_closed   |                               |
    | KLINGEL        |  30      | Stück     | icon:folder_closed   |                               |
    | RAHMEN         |  30      | Stück     | icon:stop            | Kein Bestand vorhanden.       |
And I press button "taufklappen" in row 1
Then the table has 4 rows
Then table has values
    | tartikel       | tmge     |teinheit   |taufklappen           | tbemerkung                    |   tlpmge      | tlpeinheit    | tlpgebf   |  tlp   | tdispo      | treservmge      |
    | RAD            |  60      | Stück     | icon:folder_opened   |                               |               |               |           |        | nein        |                 |
    |                |          |           |                      |                               |   100         | Stück         |   1       |  F2    | nein        |  40             |
    | KLINGEL        |  30      | Stück     | icon:folder_closed   |                               |               |               |           |        | nein        |                 |
    | RAHMEN         |  30      | Stück     | icon:stop            | Kein Bestand vorhanden.       |               |               |           |        | nein        |                 |
And I press button "taufklappen" in row 3
Then the table has 6 rows
Then table has values
    | tartikel       | tmge     |teinheit   |taufklappen           | tbemerkung                    |   tlpmge      | tlpeinheit    | tlpgebf   |  tlp   | tdispo      | treservmge      |
    | RAD            |  60      | Stück     | icon:folder_opened   |                               |               |               |           |        | nein        |                 |
    |                |          |           |                      |                               |   100         | Stück         |   1       |  F2    | nein        |  40             |
    | KLINGEL        |  30      | Stück     | icon:folder_opened   |                               |               |               |           |        | nein        |                 |
    |                |          |           |                      |                               |   10          | Stück         |   1       |  F1    | ja          |  10             |
    |                |          |           |                      |                               |   40          | Stück         |   1       |  F2    | nein        |  10             |
    | RAHMEN         |  30      | Stück     | icon:stop            | Kein Bestand vorhanden.       |               |               |           |        | nein        |                 |
And I close the current editor

Scenario: 07 Verkaufsauftrag mit Verwendung, Projekt und Behältern

# Auftrag
Given I open an editor "AUF003" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | DUEMMEL  |
   | such   | AUF003   |
And I append rows
   | artikel    | he    | mge |  verw      | projekt      |
   | AUFTRAG    | Stück | 100 | 123456     |              |
   | PROJEKT    | Stück | 1   |            | PROJEKT1     |
   | ARTBEH     | Stück | 10  |            |              |
And I save the current editor

Given I open an editor "LSVK004" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AUF003"
And I set fields
   | such   | LSVK004  |
   | vom    | .        |
Then the table has 3 rows
And I set field "mge" to "100" in row 1
And I set field "mge" to "1" in row 2
And I set field "mge" to "10" in row 3
And I set field "behaelter" to "BEHAELTER_1" in row 3
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "LSVK004"
Then field "abgelegt" has value "nein"
Then field "vkls" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 3 rows
Then table has values
    | tartikel       | tmge     |teinheit   | tverw     | tprojekt    | taufklappen          | tbemerkung                    |
    | AUFTRAG        |  100     | Stück     | 123456    |             | icon:folder_closed   |                               |
    | PROJEKT        |  1       | Stück     |           | PROJEKT1    | icon:folder_closed   |                               |
    | ARTBEH         |  10      | Stück     |           |             | icon:folder_closed   |                               |
And I press button "taufklappen" in row 1
Then the table has 7 rows
And I press button "taufklappen" in row 6
Then the table has 11 rows
And I press button "taufklappen" in row 11
Then the table has 12 rows
Then table has values
    | tartikel       | tmge     |teinheit   | tverw     | tprojekt    | taufklappen          | tbemerkung    | tlpmge    | tlpeinheit | tlpgebf    |  tlpverw      | tlpprojekt | tlpbehaelter  | tlplffert |
    | AUFTRAG        |  100     | Stück     | 123456    |             | icon:folder_opened   |               |           |            |            |               |            |               |           |
    |                |          |           |           |             |                      |               | 10        | Stück      |    1       |               |            |               |           |
    |                |          |           |           |             |                      |               | 10        | Stück      |    1       | 12345         |            |               |           |
    |                |          |           |           |             |                      |               | 100       | Stück      |    1       | 123456        |            |               |           |
    |                |          |           |           |             |                      |               | 10        | Stück      |    1       | A             |            |               |           |
    | PROJEKT        |  1       | Stück     |           | PROJEKT1    | icon:folder_opened   |               |           |            |            |               |            |               |           |
    |                |          |           |           |             |                      |               | 1         | Stück      |    1       |               |            |               |           |
    |                |          |           |           |             |                      |               | 1         | Stück      |    1       |               | PROJEKT1   |               |           |
    |                |          |           |           |             |                      |               | 1         | Stück      |    1       |               | PROJEKT2   |               |           |
    |                |          |           |           |             |                      |               | 1         | Stück      |    1       |               | PROJEKT3   |               |           |
    | ARTBEH         |  10      | Stück     |           |             | icon:folder_opened   |               |           |            |            |               |            |               |           |
    |                |          |           |           |             |                      |               | 10        | Stück      |    1       |               |            |  1            |           |
Then field "tauswahl" is not modifiable in row 3
Then field "tauswahl" is not modifiable in row 5
Then field "tauswahl" is not modifiable in row 9
Then field "tauswahl" is not modifiable in row 10
And I set field "tauswahl" to "ja" in row 4
Then field "tauswahl" is not modifiable in row 2
Then field "tauswahl" is not modifiable in row 3
Then field "tauswahl" is not modifiable in row 5
And I set field "tauswahl" to "nein" in row 4
Then field "tauswahl" is not modifiable in row 3
Then field "tauswahl" is not modifiable in row 5
And I set field "tauswahl" to "ja" in row 7
Then field "tauswahl" is not modifiable in row 8
Then field "tauswahl" is not modifiable in row 9
Then field "tauswahl" is not modifiable in row 10
And I set field "tauswahl" to "nein" in row 7
Then field "tauswahl" is not modifiable in row 9
Then field "tauswahl" is not modifiable in row 10
And I close the current editor



Scenario: 08 Sonderfälle negativer Bestand und Entnahmeart keine

# Auftrag
Given I open an editor "AUF004" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | DUEMMEL  |
   | such   | AUF004   |
And I append rows
   | artikel    | he    | mge |
   | KEINE1     | Stück | 10  |
   | KEINE2     | Stück | 10  |
   | KEINE3     | Stück | 10  |
   | NEGBEST    | Stück | 10  |
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "AUF004"
Then field "abgelegt" has value "nein"
Then field "auftrag" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 4 rows
Then table has values
    | tartikel       | tmge     |teinheit   | taufklappen        | tbemerkung                             |
    | KEINE1         |  10      | Stück     | icon:stop          | Entnahmeart keine ist eingestellt.     |
    | KEINE2         |  10      | Stück     | icon:stop          | Entnahmeart keine ist eingestellt.     |
    | KEINE3         |  10      | Stück     | icon:stop          | Keine Reservierung gefunden.           |
    | NEGBEST        |  10      | Stück     | icon:folder_closed |                                        |
And I press button "taufklappen" in row 4
Then the table has 7 rows
Then table has values
    | tartikel       | tmge     |teinheit   | taufklappen          | tbemerkung                             | tlpmge    | tlpeinheit | tlp  | tlpgebf    |  tlpverw      | tlpprojekt | tlpbehaelter  | tlplffert |
    | KEINE1         |  10     | Stück      | icon:stop            | Entnahmeart keine ist eingestellt.     |           |            |      |            |               |            |               |           |
    | KEINE2         |  10     | Stück      | icon:stop            | Entnahmeart keine ist eingestellt.     |           |            |      |            |               |            |               |           |
    | KEINE3         |  10     | Stück      | icon:stop            | Keine Reservierung gefunden.           |           |            |      |            |               |            |               |           |
    | NEGBEST        |  10     | Stück      | icon:folder_opened   |                                        |           |            |      |            |               |            |               |           |
    |                |         |            |                      |                                        |  10       | Stück      |  F1  |  1         |  1111         |            |               |           |
    |                |         |            |                      |                                        |  10       | Stück      |  F2  |  1         |  1111         |            |               |           |
    |                |         |            |                      |                                        |  -10      | Stück      |  F2  |  1         |  2222         |            |               |           |
And I close the current editor


Scenario: 09 Rechnnung mit Lagerbewegung  Auftrag -> Rechnung im Verkauf
 # Zuerst die Kette im Verkauf
 # Auftrag
Given I open an editor "AUF005" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | DUEMMEL  |
   | such   | AUF005   |
And I append rows
   | artikel    | he    | mge |
   | RAD        | Stück | 100 |
   | SETARTIKEL | Stück | 100 |
And I save the current editor

# Rechnung RE001 aus Auftrag AUF005
Given I open an editor "RE001" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AUF005"
And I set fields
   | such   | RE001  |
Then the table has 2 rows
And I set field "mge" to "100" in row 1
And I set field "mge" to "100" in row 2
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "RE001"
Then field "abgelegt" has value "nein"
Then field "vkre" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 4 rows
Then table has values
    | tartikel    | tmge    | teinheit     | tlgruppe     |  taufklappen       | tbemerkung   |
    | RAD         | 100     | Stück        | KARLSRUHE    | icon:folder_closed |              |
    | KOMP1       | 100     | Stück        | KARLSRUHE    | icon:folder_closed |              |
    | KOMP2       | 200     | Stück        | KARLSRUHE    | icon:folder_closed |              |
    | KOMP3       | 300     | Stück        | KARLSRUHE    | icon:folder_closed |              |
And I close the current editor

# Rechnung neu anlegen
Given I open an editor "RE002" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | DUEMMEL  |
   | such   | RE002    |
And I append rows
   | artikel    | he    | mge |
   | RAD        | Stück | 100 |
   | SETARTIKEL | Stück | 100 |
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "RE002"
Then field "abgelegt" has value "nein"
Then field "vkre" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 2 rows
Then table has values
    | tartikel    | tmge    | teinheit     | tlgruppe     |  taufklappen       | tbemerkung                     |
    | RAD         | 100     | Stück        | KARLSRUHE    | icon:stop          | Keine Reservierung gefunden.   |
    | SETARTIKEL  | 100     | Stück        | KARLSRUHE    | icon:stop          | Keine Reservierung gefunden.   |
And I close the current editor

    # Nun die Kette im Einkauf
    # Bestellung
Given I open an editor "BE003" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | REUS  |
   | such   | BE003   |
And I append rows
   | artikel    | he    | mge  |
   | RAD        | Stück | 100  |
   | BREMSE     | Stück | 100  |
And I save the current editor

    # Rechnung REEK001 aus Auftrag BE003
Given I open an editor "REEK001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE003"
And I set fields
   | such   | REEK001  |
   | ebeleg | REEK001  |
   | fakt   | ja       |
   | vom    | .        |
Then the table has 2 rows
And I set field "mge" to "100" in row 1
And I set field "mge" to "100" in row 2
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "REEK001"
Then field "abgelegt" has value "nein"
Then field "ekre" has value "ja"
Then field "ekposition" has value "nein"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel    | tmge    | teinheit     | tlgruppe     |  taufklappen       | tbemerkung                  |
    | DRAHT       | 100     | Stück        | KARLSRUHE    |  icon:stop         | Kein Bestand vorhanden.     |
And I close the current editor

    # Rechnung neu im Einkauf
    Given I open an editor "REEK002" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | lief   | REUS      |
   | such   | REEK002   |
   | ebeleg | REEK002  |
   | vom    | .         |
And I append rows
   | artikel    | he    | mge  |
   | RAD        | Stück | 100  |
   | BREMSE     | Stück | 100  |
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "REEK002"
Then field "abgelegt" has value "nein"
Then field "ekre" has value "ja"
Then field "ekposition" has value "nein"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel    | tmge    | teinheit     | tlgruppe     |  taufklappen       | tbemerkung                  |
    | BREMSE      | 100     | Stück        | KARLSRUHE    |  icon:stop         | Keine Reservierung gefunden.|
And I close the current editor


Scenario: 10 Umlagerungsbestellung im Einkauf
Given I open an editor "BE004" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief     | REUS      |
   | such     | BE003     |
   | bsart    | Umlagern  |
And I append rows
   | artikel    | he    | mge  | lgruppe |
   | RAD        | Stück | 100  | BERLIN  |
   | BREMSE     | Stück | 100  | BERLIN  |
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "BE004"
Then field "abgelegt" has value "nein"
Then field "bestellung" has value "nein"
Then field "ekposition" has value "nein"
And I press start
Then the table has 0 rows
And I close the current editor

Scenario: 10 Rücklieferscheine nicht im Infosystem berücksichtigen

   # Rücklieferscheine im Einkauf

Given I open an editor "BE005" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief     | REUS      |
   | such     | BE005     |
And I append rows
   | artikel    | he    | mge  |
   | RAD        | Stück | 100  |
   | BREMSE     | Stück | 100  |
And I save the current editor

Given I open an editor "LSEK004" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE005"
And I set fields
   | such   | LSEK004  |
   | ebeleg | LSEK004  |
   | vom    | .        |
   | ueb    | ja       |
Then the table has 2 rows
And I set field "mge" to "100" in row 1
And I set field "mge" to "100" in row 2
And I save the current editor

Given I open an editor "RLSEK001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LSEK004"
And I set field "such" to "RLSEK001"
And I set field "vom" to "."
And I set field "mge" to "-100" in row 1
And I set field "mge" to "-100" in row 2
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "RLSEK001"
Then field "abgelegt" has value "nein"
Then field "ekls" has value "nein"
Then field "ekposition" has value "nein"
And I press start
Then the table has 0 rows
And I close the current editor

     # Rücklieferscheine im Verkauf

    # Auftrag
Given I open an editor "AUF006" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | DUEMMEL  |
   | such   | AUF006   |
And I append rows
   | artikel    | he    | mge |
   | RAD        | Stück | 100 |
   | SETARTIKEL | Stück | 100 |
And I save the current editor

Given I open an editor "LSVK005" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AUF006"
And I set fields
   | such   | LSVK005  |
   | vom    | .        |
   | ueb    | ja       |
Then the table has 2 rows
And I set field "mge" to "100" in row 1
And I set field "mge" to "100" in row 2
And I save the current editor

Given I open an editor "RLSVK001" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LSVK005"
And I set field "such" to "RLSVK001"
And I set field "vom" to "."
And I set field "mge" to "-100" in row 1
And I set field "mge" to "-100" in row 2
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "RLSVK001"
Then field "abgelegt" has value "nein"
Then field "vkls" has value "nein"
Then field "vkposition" has value "nein"
And I press start
Then the table has 0 rows
And I close the current editor

Scenario: 11 verschiedene Einheiten im in den VK-Belegen mit Umrechnung zur Lagereinheit und Teillieferung

Given I open an editor "AUF007" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | DUEMMEL  |
   | such   | AUF007   |
And I append rows
   | artikel    | he    | mge |
   | EINHEITEN  | Paar  | 5   |
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "AUF007"
Then field "abgelegt" has value "nein"
Then field "auftrag" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 1 rows
And I press button "taufklappen" in row 1
Then the table has 4 rows
Then table has values
    | tartikel       | tmge    | teinheit   | taufklappen          | tbemerkung                             | tlpmge    | tlpeinheit | tlp  | tlpgebf    | tfreiemge     | tfreiemgele  |
    | EINHEITEN      |  10     | Stück      | icon:folder_opened   |                                        |           |            |      |            |               |              |
    |                |         |            |                      |                                        |  1        | t          |  F1  |  500       |      1        |   500        |
    |                |         |            |                      |                                        |  1        | Stück      |  F1  |  1         |      1        |   1          |
    |                |         |            |                      |                                        |  1        | Paar       |  F1  |  2         |      1        |   2          |
And I close the current editor

Given I open an editor "LSVK006" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AUF007"
And I set fields
   | such   | LSVK006  |
   | vom    | .        |
Then the table has 1 rows
And I set field "mge" to "3" in row 1
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "LSVK006"
Then field "abgelegt" has value "nein"
Then field "vkls" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 1 rows
And I press button "taufklappen" in row 1
Then the table has 4 rows
Then table has values
    | tartikel       | tmge    |teinheit    | taufklappen          | tbemerkung                             | tlpmge    | tlpeinheit | tlp  | tlpgebf    | tfreiemge     | tfreiemgele  |
    | EINHEITEN      |  6      | Stück      | icon:folder_opened   |                                        |           |            |      |            |               |              |
    |                |         |            |                      |                                        |  1        | t          |  F1  |  500       |      1        |   500        |
    |                |         |            |                      |                                        |  1        | Stück      |  F1  |  1         |      1        |   1          |
    |                |         |            |                      |                                        |  1        | Paar       |  F1  |  2         |      1        |   2          |
And I set field "tauswahl" to "ja" in row 4
And I set field "tauswahl" to "ja" in row 3
And I set field "tauswahl" to "ja" in row 2
Then table has values
    | tartikel       | tmge    |teinheit    | taufklappen          | tbemerkung                             | tlpmge    | tlpeinheit | tlp  | tlpgebf    | tfreiemge     | tfreiemgele  | tneuzuordnenmge  | tneuzuordnenmgele |
    | EINHEITEN      |  6      | Stück      | icon:folder_opened   |                                        |           |            |      |            |               |              |                  |                   |
    |                |         |            |                      |                                        |  1        | t          |  F1  |  500       |      1        |   500        |        0.006     |       3           |
    |                |         |            |                      |                                        |  1        | Stück      |  F1  |  1         |      1        |   1          |        1         |       1           |
    |                |         |            |                      |                                        |  1        | Paar       |  F1  |  2         |      1        |   2          |        1         |       2           |
And I press button "tmzerstellen" in row 1
Then the table has 1 rows
Then table has values
    | tartikel    | tmge    | teinheit     | tlgruppe     |  taufklappen       | tbemerkung                                  |
    | EINHEITEN   | 6       | Stück        | KARLSRUHE    |  icon:ok           | Vollständige Materialzuordnung vorhanden.   |
And I close the current editor

    # nun die entstandene MZ am LS prüfen
Given I open an editor "LSVK006" from table "(Sales):(PackingSlip)" with command "VIEW" for record "LSVK006"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
Then the table has 3 rows
Then table has values
       | lpsuch  | zuomge  | einh   | lzuomge   |
       | F1      | 0.006   |  t     |  3        |
       | F1      | 1       | Stück  |  1        |
       | F1      | 1       | Paar   |  2        |
And I save the current editor
    # wie sieht nun ALLOCATESTOCK aus der Sicht vom Auftrag aus
    # das muss noch besprochen werden: Aus Sicht des Auftrags hängt nun auch die MZ über 6 Stück dran

Scenario: 12 verschiedene Einheiten und spezieller Faktor aus dem Vorgang

    # Rechnung im Einkauf neu anlegen
Given I open an editor "EKRE001" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | num4  | 17845RE   |
   | lief  | REUS      |
   | such   | EKRE001  |
   | vom    | .        |
   | ueb    | ja       |
And I append rows
   | artikel    | mge  | preis |  tterm |  lehe   |
   | BLECH2MM   | 30   | 10    |  .     |  2.1    |
   | BLECH2MM   | 30   | 10    |  .     |  2.3    |
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor
    # Fertigungsvorschlag anlegen
Given I open an editor "BA2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | CASING-T       | 12         | CAS1      | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "BA2"
And I save the current editor
And I run Scheduling

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "9 CAS1000"
Then field "abgelegt" has value "nein"
Then field "ba" has value "ja"
Then field "ekposition" has value "nein"
Then field "vkposition" has value "nein"
Then field "banr" is not empty
And I press start
Then the table has 1 rows
And I press button "taufklappen" in row 1
Then the table has 3 rows
Then table has values
    | tartikel       | tmge     |teinheit   |taufklappen           | tbemerkung  | tlpmge  | tlp      |  tfreiemge | tfreiemgele |
    | BLECH2MM       |  10.125  | m²        | icon:folder_opened   |             |         |          |            |             |
    |                |          |           |                      |             | 30      |  F1      |  30        |  63         |
    |                |          |           |                      |             | 30      |  F1      |  30        |  69         |
And I set field "tauswahl" to "ja" in row 2
Then table has values
    | tartikel       | tmge     |teinheit  |tmzerstellen   |taufklappen           | tbemerkung  | tlpmge  | tlp      |  tfreiemge | tfreiemgele | tauswahl | tneuzuordnenmge | tneuzuordnenmgele  | tlpgebf   |
    | BLECH2MM       |  10.125  | m²       | icon:plus     | icon:folder_opened   |             |         |          |            |             | nein     |                 |                    |           |
    |                |          |          |               |                      |             | 30      |  F1      |  30        |  63         | ja       |  4.821          |       10.125       |  2.1      |
    |                |          |          |               |                      |             | 30      |  F1      |  30        |  69         | nein     |                 |                    |  2.3      |
And I press button "tmzerstellen" in row 1
    Then the table has 1 rows
    Then table has values
    | tartikel       | tmge     |teinheit   |taufklappen           | tbemerkung                                             | tlpmge  | tlp      |  tfreiemge | tfreiemgele |
    | BLECH2MM       |  10.125  | m²        | icon:folder_closed   | Unvollständige Materialzuordnung vorhanden.            |         |          |            |             |
And I close the current editor

    # Nun die entstandene MZ an der Reservierung prüfen

Given I open an editor "MZUORDNUNG" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "CAS1000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
    Then the table has 1 rows
    Then table has values
    | lpsuch   | zuomge | einh   | faktor       | lzuomge  |
    | F1       | 4.821  | kg     | 2.1          | 10.124   |
And I save the current editor

Scenario: 13 chargenpflichtiger Artikel

Given I open an editor "AUF008" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | DUEMMEL  |
   | such   | AUF008   |
And I append rows
   | artikel    | he     | mge   |
   | CHARGEN    | Stück  | 150   |
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "AUF008"
Then field "abgelegt" has value "nein"
Then field "auftrag" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel       | tmge    | teinheit   | taufklappen          | tbemerkung                             | tlpmge    | tlpeinheit | tlp  | tlpgebf    | tfreiemge     | tfreiemgele  |
    | CHARGEN        |  150    | Stück      | icon:folder_closed   |                                        |           |            |      |            |               |              |
And I press button "taufklappen" in row 1
Then the table has 8 rows
Then table has values
        | tartikel       | tmge    | teinheit   | taufklappen          | tbemerkung                             | tlpmge    | tlpeinheit | tlp  | tlpgebf    | texnum   | tfreiemge     | tfreiemgele  |
        | CHARGEN        |  150    | Stück      | icon:folder_opened   |                                        |           |            |      |            |          |               |              |
        |                |         |            |                      |                                        |  100      | Stück      |  F1  |  1         | 1111     |   100         |   100        |
        |                |         |            |                      |                                        |  100      | Stück      |  F1  |  1         | 2222     |   100         |   100        |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 3333     |   20          |   20         |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 4444     |   20          |   20         |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 5555     |   20          |   20         |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 6666     |   20          |   20         |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 7777     |   20          |   20         |
And I set field "tauswahl" to "ja" in row 2
And I set field "tauswahl" to "ja" in row 8
And I set field "tauswahl" to "ja" in row 7
And I set field "tauswahl" to "ja" in row 6
Then table has values
        | tartikel       | tmge    | teinheit   | taufklappen          | tbemerkung                             | tlpmge    | tlpeinheit | tlp  | tlpgebf    | texnum   | tfreiemge     | tfreiemgele  | tneuzuordnenmge   |
        | CHARGEN        |  150    | Stück      | icon:folder_opened   |                                        |           |            |      |            |          |               |              |                   |
        |                |         |            |                      |                                        |  100      | Stück      |  F1  |  1         | 1111     |   100         |   100        |  100              |
        |                |         |            |                      |                                        |  100      | Stück      |  F1  |  1         | 2222     |   100         |   100        |                   |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 3333     |   20          |   20         |                   |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 4444     |   20          |   20         |                   |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 5555     |   20          |   20         | 10                |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 6666     |   20          |   20         | 20                |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 7777     |   20          |   20         | 20                |
And I press button "tmzerstellen" in row 1
Then the table has 1 rows
Then table has values
    | tartikel       | tmge     |teinheit   |taufklappen           | tbemerkung                                 |
    | CHARGEN        |  150     | Stück     | icon:ok              | Vollständige Materialzuordnung vorhanden.  |
And I close the current editor
# nun die entstandene MZ prüfen
Given I open an editor "AUF008" from table "(Sales):(SalesOrder)" with command "VIEW" for record "AUF008"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
Then the table has 4 rows
Then table has values
       | lpsuch  | zuomge  | einh    | tcharge    |
       | F1      | 100     | Stück   | 1111       |
       | F2      | 10      | Stück   | 5555       |
       | F2      | 20      | Stück   | 6666       |
       | F2      | 20      | Stück   | 7777       |
And I close the current editor
And I switch the current editor to editor "AUF008"
And I save the current editor
# neuer Auftrag über 150 Stück, die Chargen 1111, 5555, 6666 und 7777 dürfen nicht mehr zugeordnet werden

Given I open an editor "AUF009" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | DUEMMEL  |
   | such   | AUF009   |
And I append rows
   | artikel    | he     | mge   |
   | CHARGEN    | Stück  | 150   |
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "AUF009"
Then field "abgelegt" has value "nein"
Then field "auftrag" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel       | tmge    | teinheit   | taufklappen          | tbemerkung                             | tlpmge    | tlpeinheit | tlp  | tlpgebf    | tfreiemge     | tfreiemgele  |
    | CHARGEN        |  150    | Stück      | icon:folder_closed   |                                        |           |            |      |            |               |              |
And I press button "taufklappen" in row 1
Then the table has 8 rows
Then table has values
        | tartikel       | tmge    | teinheit   | taufklappen          | tbemerkung                             | tlpmge    | tlpeinheit | tlp  | tlpgebf    | texnum   | tfreiemge     | tfreiemgele  |
        | CHARGEN        |  150    | Stück      | icon:folder_opened   |                                        |           |            |      |            |          |               |              |
        |                |         |            |                      |                                        |  100      | Stück      |  F1  |  1         | 1111     |               |              |
        |                |         |            |                      |                                        |  100      | Stück      |  F1  |  1         | 2222     |   100         |   100        |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 3333     |   20          |   20         |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 4444     |   20          |   20         |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 5555     |   10          |   10         |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 6666     |               |              |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 7777     |               |              |
Then field "tauswahl" is not modifiable in row 2
Then field "tauswahl" is not modifiable in row 7
Then field "tauswahl" is not modifiable in row 8
And I close the current editor

Scenario: 14 Baugruppe mit chargenreinen Komponenten

Given I open an editor "FVOR2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BGCHARGE       | 200        | BGCH      | nein      |
And I save the current editor
And I run Scheduling

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "FVOR2"
Then field "abgelegt" has value "nein"
Then field "fv" has value "ja"
Then field "ekposition" has value "nein"
Then field "vkposition" has value "nein"
Then field "banr" is empty
Then field "baugruppe^id" has value "!FVOR2^artikel^id"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel       | tmge     |teinheit   |taufklappen           | tbemerkung                    | tchargenrein   |
    | CHARGENREIN    |  200     | Stück     | icon:folder_closed   |                               | ja             |
And I press button "taufklappen" in row 1
Then the table has 7 rows
Then table has values
        | tartikel       | tmge    | teinheit   | taufklappen          | tbemerkung                             | tlpmge    | tlpeinheit | tlp  | tlpgebf    | texnum   | tfreiemge     | tfreiemgele  |
        | CHARGENREIN    |  200    | Stück      | icon:folder_opened   |                                        |           |            |      |            |          |               |              |
        |                |         |            |                      |                                        |  100      | Stück      |  F1  |  1         | 1111     |   100         |   100        |
        |                |         |            |                      |                                        |  100      | Stück      |  F1  |  1         | 2222     |   100         |   100        |
        |                |         |            |                      |                                        |  100      | Stück      |  F2  |  1         | 1111     |   100         |   100        |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 4444     |   20          |   20         |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 5555     |   20          |   20         |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 6666     |   20          |   20         |
And I set field "tauswahl" to "ja" in row 2
Then field "tauswahl" is not modifiable in row 3
Then field "tauswahl" is modifiable in row 4
Then field "tauswahl" is not modifiable in row 5
Then field "tauswahl" is not modifiable in row 6
Then field "tauswahl" is not modifiable in row 7
And I set field "tauswahl" to "ja" in row 4
Then table has values
        | tartikel       | tmge    | teinheit   | taufklappen          | tbemerkung                             | tlpmge    | tlpeinheit | tlp  | tlpgebf    | texnum   | tfreiemge     | tfreiemgele  | tneuzuordnenmge  | tchargenrein |
        | CHARGENREIN    |  200    | Stück      | icon:folder_opened   |                                        |           |            |      |            |          |               |              |                  | ja           |
        |                |         |            |                      |                                        |  100      | Stück      |  F1  |  1         | 1111     |   100         |   100        |  100             | ja           |
        |                |         |            |                      |                                        |  100      | Stück      |  F1  |  1         | 2222     |   100         |   100        |                  | ja           |
        |                |         |            |                      |                                        |  100      | Stück      |  F2  |  1         | 1111     |   100         |   100        |  100             | ja           |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 4444     |   20          |   20         |                  | ja           |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 5555     |   20          |   20         |                  | ja           |
        |                |         |            |                      |                                        |  20       | Stück      |  F2  |  1         | 6666     |   20          |   20         |                  | ja           |
And I close the current editor

Scenario: 15 Artikel mit Seriennummernverfolgung

Given I open an editor "AUF010" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | DUEMMEL  |
   | such   | AUF010   |
And I append rows
   | artikel     | he     | mge   |
   | SERIENNR    | Stück  | 2     |
And I save the current editor

Given I open an editor "AUF011" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | DUEMMEL  |
   | such   | AUF011   |
And I append rows
   | artikel     | he     | mge   |
   | SERIENNR    | Stück  | 2     |
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "AUF010"
Then field "abgelegt" has value "nein"
Then field "auftrag" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 1 rows
And I press button "taufklappen" in row 1
Then the table has 5 rows
Then table has values
    | tartikel       | tmge    | teinheit   | taufklappen          | tbemerkung                             | tlpmge    | tlpeinheit | tlp  | tlpgebf    | tfreiemge     | tfreiemgele  | texnum  | tchverfolgung           | tsnabgangverf  |
    | SERIENNR       |  2      | Stück      | icon:folder_opened   |                                        |           |            |      |            |               |              |         |                         | nein           |
    |                |         |            |                      |                                        | 1         | Stück      | F1   | 1          |  1            |   1          |  S1     | Seriennummernverfolgung | ja             |
    |                |         |            |                      |                                        | 1         | Stück      | F1   | 1          |  1            |   1          |  S2     | Seriennummernverfolgung | ja             |
    |                |         |            |                      |                                        | 1         | Stück      | F2   | 1          |  1            |   1          |  S3     | Seriennummernverfolgung | ja             |
    |                |         |            |                      |                                        | 1         | Stück      | F2   | 1          |  1            |   1          |  S4     | Seriennummernverfolgung | ja             |
And I set field "tauswahl" to "ja" in row 2
And I set field "tauswahl" to "ja" in row 3
And I press button "tmzerstellen" in row 1
And I close the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "AUF011"
Then field "abgelegt" has value "nein"
Then field "auftrag" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 1 rows
And I press button "taufklappen" in row 1
Then the table has 5 rows
Then table has values
    | tartikel       | tmge    | teinheit   | taufklappen          | tbemerkung                             | tlpmge    | tlpeinheit | tlp  | tlpgebf    | tfreiemge     | tfreiemgele  | texnum  | tchverfolgung           | tsnabgangverf  |
    | SERIENNR       |  2      | Stück      | icon:folder_opened   |                                        |           |            |      |            |               |              |         |                         | nein           |
    |                |         |            |                      |                                        | 1         | Stück      | F1   | 1          |               |              |  S1     | Seriennummernverfolgung | nein           |
    |                |         |            |                      |                                        | 1         | Stück      | F1   | 1          |               |              |  S2     | Seriennummernverfolgung | nein           |
    |                |         |            |                      |                                        | 1         | Stück      | F2   | 1          |  1            |   1          |  S3     | Seriennummernverfolgung | ja             |
    |                |         |            |                      |                                        | 1         | Stück      | F2   | 1          |  1            |   1          |  S4     | Seriennummernverfolgung | ja             |
Then field "tauswahl" is not modifiable in row 2
Then field "tauswahl" is not modifiable in row 3
Then field "tauswahl" is modifiable in row 4
Then field "tauswahl" is modifiable in row 5
And I close the current editor


Scenario: 16 chargenpflichtige Komponenten Setartikel, unterschiedliche Einheiten und pverlust

Given I open an editor "AUF016" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde  | DUEMMEL  |
    | such   | AUF016   |
And I append rows
    | artikel        | he     | mge   |
    | SETEINHEITEN   | Stück  | 10    |
And I save the current editor

Given I open the infosystem "ALLOCATESTOCK"
And I set field "vorgang" to "id" from editor "AUF016"
Then field "abgelegt" has value "nein"
Then field "auftrag" has value "ja"
Then field "vkposition" has value "nein"
And I press start
Then the table has 3 rows
Then table has values
    | tartikel      | tmge      | teinheit   | taufklappen          | tlpmge    | tlpeinheit | tlpgebf    | tchargenrein    |
    | KOMP1CHA_KG   | 11.111    | kg         | icon:folder_closed   |           |            |            | ja              |
    | KOMP2STUECK   | 20        | Stück      | icon:folder_closed   |           |            |            | nein            |
    | KOMP3CHA_MT   | 30        | m          | icon:folder_closed   |           |            |            | ja              |
And I press button "taufklappen" in row 1
Then the table has 7 rows
Then table has values
        | tartikel       | tmge    | teinheit   | taufklappen          | tbemerkung | tlpmge    | tlpeinheit | tlp  | tlpgebf    | texnum   | tfreiemge     | tfreiemgele  |
        | KOMP1CHA_KG    | 11.111  | kg         | icon:folder_opened   |            |           |            |      |            |          |               |              |
        |                |         |            |                      |            |  10       | kg         |  F1  |  1         | CHA1     |   10          |   10         |
        |                |         |            |                      |            |  5        | kg         |  F2  |  1         | CHA2     |   5           |   5          |
        |                |         |            |                      |            |  12       | kg         |  F2  |  1         | CHA4     |   12          |   12         |
        |                |         |            |                      |            |  7        | kg         |  F3  |  1         | CHA3     |   7           |   7          |
And I set field "tauswahl" to "ja" in row 2
Then fields in table are modifiable
    | !row  | tauswahl  |
    | 3     | nein      |
    | 4     | nein      |
    | 5     | nein      |
And I set field "tauswahl" to "nein" in row 2
And I set field "tauswahl" to "ja" in row 4
And I press button "taufklappen" in row 6
Then the table has 10 rows
Then table has values
        | !row  | tartikel       | tmge    | teinheit   | taufklappen          | tbemerkung | tlpmge    | tlpeinheit | tlp  | tlpgebf    | texnum   | tfreiemge     | tfreiemgele  |
        | 6     | KOMP2STUECK    | 20      | Stück      | icon:folder_opened   |            |           |            |      |            |          |               |              |
        | 7     |                |         |            |                      |            |  10       | Stück      |  F1  |  1         |          |   10          |   10         |
        | 8     |                |         |            |                      |            |  40       | Stück      |  F2  |  1         |          |   40          |   40         |
        | 9     |                |         |            |                      |            |  21       | Stück      |  F3  |  1         |          |   21          |   21         |
And I press button "taufklappen" in row 10
Then the table has 14 rows
Then table has values
        | !row  | tartikel       | tmge    | teinheit   | taufklappen          | tbemerkung | tlpmge    | tlpeinheit | tlp  | tlpgebf    | texnum   | tfreiemge     | tfreiemgele  |
        | 10    | KOMP3CHA_MT    | 30      | m          | icon:folder_opened   |            |           |            |      |            |          |               |              |
        | 11    |                |         |            |                      |            |  30       | m          |  F1  |  1         | CHA5     |   30          |   30         |
        | 12    |                |         |            |                      |            |  15       | m          |  F2  |  1         | CHA6     |   15          |   15         |
        | 13    |                |         |            |                      |            |  40       | m          |  F2  |  1         | CHA8     |   40          |   40         |
        | 14    |                |         |            |                      |            |  21       | m          |  F3  |  1         | CHA7     |   21          |   21         |
And I close the current editor

## MZ erstellen im Infosystem erst später testen, da momentan noch ein Fehler im Kern und die MZ gar nicht erstellt wird, weil das Feld charge schreibgeschützt ist

#And I press button "tmzerstellen" in row 1
## nach Erstellen der MZ werden alle Zeilen zugeklappt
#And I press button "taufklappen" in row 2
#And I set field "tauswahl" to "ja" in row 3
#And I set field "tauswahl" to "ja" in row 4
#And I press button "tmzerstellen" in row 2
#And I press button "taufklappen" in row 3
#And I set field "tauswahl" to "ja" in row 6
#And I press button "tmzerstellen" in row 3
#Then the table has 3 rows
#Then table has values
#    | tartikel       | tmge    |teinheit   | tmzmge    | taufklappen        | tbemerkung                                    |
#    | KOMP1CHA_KG    | 11.111  | Stück     | 5         | icon:folder_closed | Unvollständige Materialzuordnung vorhanden.   |
#    | KOMP2STUECK    | 20      | Stück     | 20        | icon:ok            | Vollständige Materialzuordnung vorhanden.     |
#    | KOMP3CHA_MT    | 30      | Stück     | 20        | icon:ok            | Vollständige Materialzuordnung vorhanden.     |
#And I close the current editor

## nun die entstandene MZ prüfen
#Given I open an editor "AUF016" from table "(Sales):(SalesOrder)" with command "VIEW" for record "AUF016"
#And I press button "mzabsm" to open a subeditor for "SetartikelMZ" in row 1
#Then field "verteilt" has value "5"
#Then field "resmge" has value "6,111"
#Then the table has 1 rows
#Then table has values
#       | lpsuch  | zuomge  | einh    | tcharge    |
#       | F2      | 5       | kg      | CHA2       |
#And I press button for next product
#Then the table has 2 rows
#Then table has values
#       | lpsuch  | zuomge  | einh    |
#       | F1      | 10      | Stück   |
#       | F2      | 10      | Stück   |
#And I press button for next product
#Then the table has 1 rows
#Then table has values
#       | lpsuch  | zuomge  | einh    | tcharge    |
#       | F2      | 30      | m       | CHA8       |
#And I close the current editor
#And I switch the current editor to editor "AUF016"
#And I save the current editor
