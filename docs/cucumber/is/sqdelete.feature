@persistent
Feature: Infosystem SQDELETE - Löschen von Platzmengen

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

Scenario: STAMMDATEN - Lagergruppe VW Frankreich

Given I open an editor "Volkswagen_LG" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "Vw"
And I set field "such" to "Vw"
And I set field "namebspr" to "VW Frankreich"
And I save the current editor


Scenario Outline: STAMMDATEN - Lager
Given I open an editor "<lager>" from table "(Warehouse):(Warehouse)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lgruppe" to id from editor "<lgruppe>"
And I save the current editor

Examples: Lager
| lager           | such    | namebspr           | lgruppe          |
| VOLKSWAGEN_LA   | VW      | VW Frankreich      | Volkswagen_LG    |


Scenario Outline: STAMMDATEN - Lagerplatz
Given I open an editor "<lagerplatz>" from table "(Location):(Location)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lager" to id from editor "<lager>"
And I save the current editor

Examples: Lagerplatz
| lagerplatz      | such   | namebspr            | lager           |
| VW              | VW     | VW Frankreich       | VOLKSWAGEN_LA   |

Scenario Outline: STAMMDATEN - Fuenf neue Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "chverfolgung" to "<chverfolgung>"
And I set field "chimlager" to "<chimlager>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "bsart" to "<bsart>"
And I set field "dispoa" to "<dispoa>"
And I set field "lief" to "<lief>"
And I set field "epr" to "<epr>"
And I set field "efrist" to "<efrist>"
And I save the current editor 

Examples: Artikel
| such            | namebspr         | chverfolgung     |chimlager    | vkbez            | vbez            | ebez            | vpr    | bsart             | dispoa          | lief | epr  | efrist   |
| BESTAND         | normale Bestand  |                  |  nein       | normale Bestand  | normale Bestand | normale Bestand | 10000  | Fremdbeschaffung  | bedarfsbezogen  | reus | 9000 | 15       | 
| NULL1           | Nullbestand      |                  |  nein       | Nullbestand      | Nullbestand     | Nullbestand     | 10000  | Fremdbeschaffung  | bedarfsbezogen  | reus | 9000 | 15       |
| NULL2           | Nullbestand      |                  |  nein       | Nullbestand      | Nullbestand     | Nullbestand     | 10000  | Fremdbeschaffung  | bedarfsbezogen  | reus | 9000 | 15       |
| PLATZELEMENTE   | Platzelemente    | Chargenverfolgung|  ja         | Platzelemente    | Platzelemente   | Platzelemente   | 10000  | Fremdbeschaffung  | bedarfsbezogen  | reus | 9000 | 15       |
| INVENTUR        | Inventur         |                  |  nein       | Inventur         | Inventur        | Inventur        | 10000  | Fremdbeschaffung  | bedarfsbezogen  | reus | 9000 | 15       |

Scenario Outline: Chargen anlegen
Given I open an editor "<such>" from table "(Lots):(Lots)" with command "STORE" for record "<such>"
And I set fields
    | such    | <such>    |
    | exnum   | <exnum>   |
    | artikel | <artikel> |
And I save the current editor

Examples: Chargen
| such               | exnum    | artikel         |
| CH_SQDELETE1       | 1-CHARGE | PLATZELEMENTE   |

Scenario: 01 SQDELETE prüfen - keine Zeilen leerer Lagerplatz 
Given I open the infosystem "SQDELETE"
And I set field "lplatz" to "VW"
And I press start
Then the table has 0 rows
And I close the current editor

Scenario: 02 SQDELETE prüfen - Bestand auf dem Lagerplatz
# Lagerbuchung Zugang für den Artikel Bestand
Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | BESTAND    |
      | buart       | Zugang     |
      | beleg       | Z01        |
      | beldat      | .          |
      
And I modify table
      | !row  | mge   | platz2 |
      | +1    | 10    | VW     |
      | +2    | 90    | VW     |
And I save the current editor

Given I open the infosystem "SQDELETE"
And I set field "lplatz" to "VW"
And I press start
Then the table has 0 rows
And I close the current editor

Scenario: 03 SQDELETE prüfen - Es gibt Nullbestaende

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | NULL1    |
      | buart       | Zugang     |
      | beleg       | Z02        |
      | beldat      | .          |
      
And I modify table
      | !row  | mge   | platz2 |
      | +1    | 100    | VW     |
And I save the current editor

Given I open an editor "manLagerabgang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | NULL1      |
      | buart       | Abgang     |
      | beleg       | A01        |
      | beldat      | .          |
      
And I modify table
      | !row  | mge   | platz  |
      | +1    | 100   | VW     |
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | NULL2    |
      | buart       | Zugang     |
      | beleg       | Z03        |
      | beldat      | .          |
      
And I modify table
      | !row  | mge   | platz2 |
      | +1    | 500   | VW     |
And I save the current editor

Given I open an editor "manLagerabgang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | NULL2      |
      | buart       | Abgang     |
      | beleg       | A02        |
      | beldat      | .          |
      
And I modify table
      | !row  | mge   | platz  |
      | +1    | 500   | VW     |
And I save the current editor


Given I open the infosystem "SQDELETE"
And I set field "lplatz" to "VW"
And I press start
Then the table has 2 rows
Then table has values
    | telemvorh    | tartikel | tlplatz    | tinv  | tstatus |
    |              | NULL1    | VW         |       |         |
    |              | NULL2    | VW         |       |         |
Then field "tshowmenge" is not empty in row 1
Then field "tshowmenge" is not empty in row 2
And I close the current editor

Scenario: 04 SQDELETE prüfen - Es gibt Nullbestaende mit Platzmengenelementen

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | PLATZELEMENTE    |
      | buart       | Zugang           |
      | beleg       | Z04              |
      | beldat      | .                |
      
And I modify table
      | !row  | mge   | platz2 | charge2    |
      | +1    | 100   | VW     |CH_SQDELETE1|
And I save the current editor

Given I open an editor "manLagerabgang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | PLATZELEMENTE |
      | buart       | Abgang        |
      | beleg       | A03           |
      | beldat      | .             |
      
And I modify table
      | !row  | mge   | platz  |
      | +1    | 100   | VW     |
And I save the current editor

Given I open the infosystem "SQDELETE"
And I set field "lplatz" to "VW"
And I press start
Then the table has 3 rows
Then table has values
    | telemvorh    | tartikel      | tlplatz    | tinv  | tstatus |
    |              | NULL1         | VW         |       |         |
    |              | NULL2         | VW         |       |         |
    | icon:view    | PLATZELEMENTE | VW         |       |         |
Then field "tshowmenge" is not empty in row 1
Then field "tshowmenge" is not empty in row 2
Then field "tshowmenge" is not empty in row 3
And I close the current editor

Scenario: 05 SQDELETE prüfen - Es gibt Nullbestaende und noch eine aktive Zählliste

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | INVENTUR   |
      | buart       | Zugang     |
      | beleg       | Z05        |
      | beldat      | .          |
      
And I modify table
      | !row  | mge   | platz2 |
      | +1    | 100    | VW    |
And I save the current editor

Given I open an editor "manLagerabgang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | INVENTUR      |
      | buart       | Abgang     |
      | beleg       | A04        |
      | beldat      | .          |
      
And I modify table
      | !row  | mge   | platz  |
      | +1    | 100   | VW     |
And I save the current editor


Given I open an editor "Zaehlliste" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "ZL1"
And I append rows
    | artikel  | platz    |
    | INVENTUR | VW       |
And I save the current editor

# Inventur eroeffnen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "RELEASE" for record "ZL1" and menu choice "Ja"
And I save the current editor

Given I open the infosystem "SQDELETE"
And I set field "lplatz" to "VW"
And I press start
Then the table has 4 rows
Then table has values
    | telemvorh    | tartikel      | tlplatz    | tinv  | tshowzliste |
    |              | NULL1         | VW         |       |             |
    |              | NULL2         | VW         |       |             |
    | icon:view    | PLATZELEMENTE | VW         |       |             |
    |              | INVENTUR      | VW         |   Z   | (153,56,0)  |
Then field "tshowmenge" is not empty in row 1
Then field "tshowmenge" is not empty in row 2
Then field "tshowmenge" is not empty in row 3
Then field "tshowmenge" is not empty in row 4
And I close the current editor

Scenario: 06 SQDELETE prüfen - Loeschen der Platzbestaende
Given I open the infosystem "SQDELETE"
And I set field "lplatz" to "VW"
And I press start
And I press button "allean"
Then table has values
   |tauswahl | telemvorh    | tartikel      | tlplatz    | tinv  | tstatus |
   | ja      |              | NULL1         | VW         |       |         |
   | ja      |              | NULL2         | VW         |       |         |
   | nein    | icon:view    | PLATZELEMENTE | VW         |       |         |
   | nein    |              | INVENTUR      | VW         |   Z   |         |
Then field "tshowmenge" is not empty in row 1
Then field "tshowmenge" is not empty in row 2
Then field "tshowmenge" is not empty in row 3
Then field "tshowmenge" is not empty in row 4
And I press button "auswahlloeschen"   
Then table has values
   |tauswahl |telemvorh     | tartikel      | tlplatz    | tinv  | tstatus |
   | ja      |              | NULL1         | VW         |       | icon:ok |
   | ja      |              | NULL2         | VW         |       | icon:ok |
   | nein    | icon:view    | PLATZELEMENTE | VW         |       |         |
   | nein    |              | INVENTUR      | VW         |   Z   |         |
Then field "tshowmenge" is not empty in row 1
Then field "tshowmenge" is not empty in row 2
Then field "tshowmenge" is not empty in row 3
Then field "tshowmenge" is not empty in row 4
And I press start
Then table has values
   |tauswahl | telemvorh    | tartikel      | tlplatz    | tinv  | tstatus |
   | nein    | icon:view    | PLATZELEMENTE | VW         |       |         |
   | nein    |              | INVENTUR      | VW         |   Z   |         |
Then field "tshowmenge" is not empty in row 1
Then field "tshowmenge" is not empty in row 2
And I close the current editor


Scenario: 07 SQDELETE pruefen - Loeschen der Lagergruppenmengen

Given I open the infosystem "SQDELETE"
And I set field "lgrmge" to "ja"
Then field "lplatz" is not modifiable
And I press start
Then field "tauswahl" is not modifiable in row 3
Then field "tauswahl" is not modifiable in row 4
And I press button "allean"
Then field "tauswahl" is not modifiable in row 3
Then field "tauswahl" is not modifiable in row 4
Then table has values
   |tauswahl | telemvorh    | tuntermge | tartikel      | tlplatz    | tlgruppe   | tstatus |
   | ja      |              |           | NULL1         |            | VW         |         |
   | ja      |              |           | NULL2         |            | VW         |         |
   | nein    |              | icon:view | PLATZELEMENTE |            | VW         |         |
   | nein    |              | icon:view | INVENTUR      |            | VW         |         |
Then field "tshowmenge" is not empty in row 1
Then field "tshowmenge" is not empty in row 2
Then field "tshowmenge" is not empty in row 3
Then field "tshowmenge" is not empty in row 4
And I respond with answer "ja" to the dialog with id "Durch das Löschen der Objekte wird der Lagergruppenmischpreis gelöscht."
And I press button "auswahlloeschen"
Then table has values
   | tauswahl | telemvorh   | tuntermge | tartikel      | tlplatz    | tlgruppe   | tstatus |
   | ja       |             |           | NULL1         |            | VW         | icon:ok |
   | ja       |             |           | NULL2         |            | VW         | icon:ok |
   | nein     |             | icon:view | PLATZELEMENTE |            | VW         |         |
   | nein     |             | icon:view | INVENTUR      |            | VW         |         |
Then field "tshowmenge" is not empty in row 1
Then field "tshowmenge" is not empty in row 2
Then field "tshowmenge" is not empty in row 3
Then field "tshowmenge" is not empty in row 4
And I press start
Then table has values
   | tauswahl | telemvorh   | tuntermge | tartikel      | tlplatz    | tlgruppe   | tstatus |
   | nein     |             | icon:view | PLATZELEMENTE |            | VW         |         |
   | nein     |             | icon:view | INVENTUR      |            | VW         |         |
Then field "tshowmenge" is not empty in row 1
Then field "tshowmenge" is not empty in row 2
Then field "tauswahl" is not modifiable in row 1
Then field "tauswahl" is not modifiable in row 2
And I close the current editor


Scenario: 08 SQDELETE pruefen - Loeschen der Artikelmengen

Given I open the infosystem "SQDELETE"
And I set field "artmge" to "ja"
Then field "lplatz" is not modifiable
Then field "lgruppe" is not modifiable
And I press start
Then field "tauswahl" is not modifiable in row 3
Then field "tauswahl" is not modifiable in row 4
And I press button "allean"
Then field "tauswahl" is not modifiable in row 3
Then field "tauswahl" is not modifiable in row 4
Then table has values
   | tauswahl | telemvorh   | tuntermge | tartikel      | tlplatz    | tlgruppe   | tstatus |
   | ja       |             |           | NULL1         |            |            |         |
   | ja       |             |           | NULL2         |            |            |         |
   | nein     |             | icon:view | PLATZELEMENTE |            |            |         |
   | nein     |             | icon:view | INVENTUR      |            |            |         |
Then field "tshowmenge" is not empty in row 1
Then field "tshowmenge" is not empty in row 2
Then field "tshowmenge" is not empty in row 3
Then field "tshowmenge" is not empty in row 4
And I respond with answer "ja" to the dialog with id "Durch das Löschen der Objekte wird der Artikelmischpreis gelöscht."
And I press button "auswahlloeschen"
Then table has values
   | tauswahl | telemvorh   | tuntermge | tartikel      | tlplatz    | tlgruppe   | tstatus |
   | ja       |             |           | NULL1         |            |            | icon:ok |
   | ja       |             |           | NULL2         |            |            | icon:ok |
   | nein     |             | icon:view | PLATZELEMENTE |            |            |         |
   | nein     |             | icon:view | INVENTUR      |            |            |         |
Then field "tshowmenge" is not empty in row 1
Then field "tshowmenge" is not empty in row 2
Then field "tshowmenge" is not empty in row 3
Then field "tshowmenge" is not empty in row 4
Then field "tauswahl" is not modifiable in row 3
Then field "tauswahl" is not modifiable in row 4
And I press start
Then table has values
   | tauswahl | telemvorh   | tuntermge | tartikel      | tlplatz    | tlgruppe   | tstatus |
   | nein     |             | icon:view | PLATZELEMENTE |            |            |         |
   | nein     |             | icon:view | INVENTUR      |            |            |         |
Then field "tshowmenge" is not empty in row 1
Then field "tshowmenge" is not empty in row 2
Then field "tauswahl" is not modifiable in row 1
Then field "tauswahl" is not modifiable in row 2
And I close the current editor
