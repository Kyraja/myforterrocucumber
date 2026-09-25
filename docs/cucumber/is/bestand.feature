@persistent
Feature: Infosystem BESTAND - Darstellung von Beständen
Background:
Given I set the fake date to "12.01.1995" 
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

# Projektkostenrechnung einschalten
Given I open an editor "config" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "projekt" to "ja"
And I save the current editor


Scenario Outline: STAMMDATEN - neue Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "bsart" to "<bsart>"
And I set field "dispoa" to "<dispoa>"
And I set field "le" to "<le>"
And I set field "lief" to "<lief>"
And I set field "epr" to "<epr>"
And I set field "efrist" to "<efrist>"
And I save the current editor

Examples: Artikel
| such            | namebspr                    | vkbez     | vbez       | ebez      | vpr    | bsart             | dispoa          |le    | lief | epr  | efrist   |
| NORMAL          | bedarfsbezogener Artikel    | normal    | normal     | normal    | 10     | Fremdbeschaffung  | bedarfsbezogen  |Stück | reus | 5    | 15       | 
| VERWENDUNG      | auftragsbezogener Artikel   | Auftrag   | Auftrag    | Auftrag   | 10     | Fremdbeschaffung  | auftragsbezogen |Stück | reus | 5    | 15       | 
| EINHEIT         | verschiedene Einheiten      | Einheit   | Einheit    | Einheit   | 10     | Fremdbeschaffung  | bedarfsbezogen  |kg    | reus | 5    | 15       |
| CHARGE          | Artikel mit Chargen         | Charge    | Charge     | Charge    | 10     | Fremdbeschaffung  | bedarfsbezogen  |Stück | reus | 5    | 15       |
| BEHAELTER-ART   | Artikel mit Behältern       | Behälter  | Behälter   | Behälter  | 10     | Fremdbeschaffung  | bedarfsbezogen  |Stück | reus | 5    | 15       |
| PROJEKT         | Artikel mit Projekten       | Projekt   | Projekt    | Projekt   | 10     | Fremdbeschaffung  | bedarfsbezogen  |Stück | reus | 5    | 15       | 
| KOMPLEX         | Verwendung, Charge, Projekt | komplex   | komplex    | komplex   | 10     | Fremdbeschaffung  | auftragsbezogen |Stück | reus | 5    | 15       |                         
| GESPERRT        | gesperrter Artikel          | gesperrt  | gesperrt   | gesperrt  | 10     | Fremdbeschaffung  | bedarfsbezogen  |Stück | reus | 5    | 15       | 
| NULLBESTAND     | Artikel mit Nullbestand     | Nullbest  | Nullbest   | Nullbest  | 10     | Fremdbeschaffung  | bedarfsbezogen  |Stück | reus | 5    | 15       |  
| VERD-EBENEN     | Verdichtung vers. Ebenen    | Verdicht  | Verdicht   | Verdich   | 10     | Fremdbeschaffung  | auftragsbezogen |Stück | reus | 5    | 15       |

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
|  2   | BEHAELTER_2 |
|  3   | BEHAELTER_3 |

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
| PROJEKT4  | Projekt 4 |
| PROJEKT5  | Projekt 5 |

Scenario: 1 BESTAND prüfen für den Artikel NORMAL

# Infosystem BESTAND ohne Artikelbestand
Given I open the infosystem "BESTAND"
And I set field "artikel" to "NORMAL"
And I press start
Then the table has 0 rows
And I close the current editor


# manuelle Lagerzugänge für den Artikel NORMAL
Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | NORMAL   |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge   | platz2 | 
      | +1    | 10    | F1     | 
      | +2    | 40    | F1     |
      | +3    | 50    | F1     |
      | +4    | 100   | F2     | 
      | +5    | 100   | L3F1   |  
And I save the current editor

# Infosystem BESTAND mit 3 Artikelbeständen, 2 auf der internen LG, 1 auf der exteren LG
Given I open the infosystem "BESTAND"
And I set field "artikel" to "NORMAL"
Then field "details" has value "ja"
And I set field "details" to "nein"
And I press start
Then the table has 2 rows
Then table has values
 |lgruppe    |lager|lplatz |tartikel| lemge | leinheit |
 |KARLSRUHE  | L1  | F1    | NORMAL | 100   | Stück    |
 |KARLSRUHE  | L1  | F2    | NORMAL | 100   | Stück    |
And I close the current editor

Given I open the infosystem "BESTAND"
And I set field "artikel" to "NORMAL"
And I set field "klgruppe" to ""
Then field "details" has value "ja"
And I press start
Then the table has 6 rows
Then table has values             
 | taufzu             |lgruppe    |lager|lplatz | dispo |tartikel| lemge | leinheit  | gebmge | geinheit | gebf |
 | icon:folder_opened |KARLSRUHE  | L1  | F1    |  ja   | NORMAL | 100   | Stück    |        |           |      |
 |                    |           |     | F1    |  ja   | NORMAL |       |          | 100    | Stück     |  1   |
 | icon:folder_opened |KARLSRUHE  | L1  | F2    |  nein | NORMAL | 100   | Stück    |        |           |      |
 |                    |           |     | F2    |  nein | NORMAL |       |          | 100    | Stück     |  1   |
 | icon:folder_opened |BERLIN     | L3  | L3F1  |   ja  | NORMAL | 100   | Stück    |        |           |      |
 |                    |           |     | L3F1  |   ja  | NORMAL |       |          | 100    | Stück     |  1   |
And I close the current editor

Given I open the infosystem "BESTAND"
And I set field "artikel" to "NORMAL"
And I set field "klgruppe" to "BERLIN"
Then field "details" has value "ja"
And I set field "details" to "nein"
And I press start
Then the table has 1 rows
Then table has values
 |lgruppe    |lager|lplatz | dispo | tartikel| lemge | leinheit |
 |BERLIN     | L3  | L3F1  |  ja   | NORMAL  | 100   | Stück    |
And I close the current editor

# Verdichten und nicht Verdichten testen

Given I open the infosystem "BESTAND"
And I set field "artikel" to "NORMAL"
Then field "details" has value "ja"
And I set field "details" to "nein"
And I press start
Then the table has 2 rows
Then field "taufzu" has value "icon:folder_closed" in row 1 
And I press button "taufzu" in row 1
Then the table has 3 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel| lemge | leinheit | gebmge | geinheit|
|icon:folder_opened |KARLSRUHE  | L1  | F1    | NORMAL | 100   | Stück   |        |         |
|                   |           |     | F1    | NORMAL |       |          | 100    | Stück  |
|icon:folder_closed |KARLSRUHE  | L1  | F2    | NORMAL | 100   | Stück   |        |         |
And I close the current editor

Given I open the infosystem "BESTAND"
And I set field "artikel" to "NORMAL"
And I set field "verdichten" to "nein"
Then field "details" has value "ja"
And I press start
Then the table has 6 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel| lemge | leinheit | gebmge | geinheit|
|icon:folder_opened |KARLSRUHE  | L1  | F1    | NORMAL | 100   | Stück   |        |         |
|                   |           |     | F1    | NORMAL |       |          | 10     | Stück  |
|                   |           |     | F1    | NORMAL |       |          | 40     | Stück  | 
|                   |           |     | F1    | NORMAL |       |          | 50     | Stück  | 
|icon:folder_opened |KARLSRUHE  | L1  | F2    | NORMAL | 100   | Stück   |        |         |
|                   |           |     | F2    | NORMAL |       |          | 100    | Stück  | 
And I close the current editor

Scenario: 2 BESTAND prüfen für den Artikel VERWENDUNG
#Einkaufsrechnung anlegen
Given I open an editor "ekrechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
#EK-Rechnung mit 9 Zeilen
#300 Stück mit Verwendung 200001_1 auf F1
#100 Stück mit Verwendung 200001_1 auf L3F1
#200 Stück mit Verwendung 200002_1 auf F1
#100 Stück OHNE Verwendung auf F1
#100 Stück OHNE Verwendung auf F2
#100 Stück OHNE Verwendung auf L3F1

And I set field "lief" to "reus"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "ebeleg" to "Zug1 Verwendung"
And I create a new row at the end of the table
And I set field "artex" to id from editor "VERWENDUNG" in row 1
And I set field "mge" to "100" in row 1
And I set field "platz" to "F1" in row 1
And I set field "verw" to "200001_1" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "VERWENDUNG" in row 2
And I set field "mge" to "100" in row 2
And I set field "platz" to "F1" in row 2
And I set field "verw" to "200001_1" in row 2
And I create a new row at the end of the table
And I set field "artex" to id from editor "VERWENDUNG" in row 3
And I set field "mge" to "100" in row 3
And I set field "platz" to "F1" in row 3
And I set field "verw" to "200001_1" in row 3
And I create a new row at the end of the table
And I set field "artex" to id from editor "VERWENDUNG" in row 4
And I set field "mge" to "100" in row 4
And I set field "platz" to "F1" in row 4
And I set field "verw" to "200002_1" in row 4
And I create a new row at the end of the table
And I set field "artex" to id from editor "VERWENDUNG" in row 5
And I set field "mge" to "100" in row 5
And I set field "platz" to "F1" in row 5
And I set field "verw" to "200002_1" in row 5
And I create a new row at the end of the table
And I set field "artex" to id from editor "VERWENDUNG" in row 6
And I set field "mge" to "100" in row 6
And I set field "platz" to "F1" in row 6
And I create a new row at the end of the table
And I set field "artex" to id from editor "VERWENDUNG" in row 7
And I set field "mge" to "100" in row 7
And I set field "platz" to "F2" in row 7
And I create a new row at the end of the table
And I set field "artex" to id from editor "VERWENDUNG" in row 8
And I set field "mge" to "100" in row 8
And I set field "platz" to "L3F1" in row 8
And I create a new row at the end of the table
And I set field "artex" to id from editor "VERWENDUNG" in row 9
And I set field "mge" to "100" in row 9
And I set field "platz" to "L3F1" in row 9
And I set field "verw" to "200001_1" in row 9
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open the infosystem "BESTAND"
And I set field "artikel" to "VERWENDUNG"
And I set field "klgruppe" to ""
Then field "details" has value "ja"
Then field "verdichten" has value "ja"
And I set field "details" to "nein"
And I press start
Then the table has 3 rows
Then table has values
 |lgruppe    |lager|lplatz |tartikel    | lemge | leinheit | tinfo |
 |KARLSRUHE  | L1  | F1    | VERWENDUNG | 600   | Stück    |       |
 |KARLSRUHE  | L1  | F2    | VERWENDUNG | 100   | Stück    |       |
 |BERLIN     | L3  | L3F1  | VERWENDUNG | 200   | Stück    |       |
Then field "taufzu" has value "icon:folder_closed" in row 1
And I press button "taufzu" in row 1
Then the table has 6 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel    | lemge | leinheit | gebmge | geinheit| verw     | tinfo   |
|icon:folder_opened |KARLSRUHE  | L1  | F1    | VERWENDUNG | 600   | Stück    |        |         |          |         |
|                   |           |     | F1    | VERWENDUNG |       |          | 100    | Stück   |          |         |
|                   |           |     | F1    | VERWENDUNG |       |          | 300    | Stück   | 200001_1 |         |
|                   |           |     | F1    | VERWENDUNG |       |          | 200    | Stück   | 200002_1 |         |
|icon:folder_closed |KARLSRUHE  | L1  | F2    | VERWENDUNG | 100   | Stück    |        |         |          |         |
|icon:folder_closed |BERLIN     | L3  | L3F1  | VERWENDUNG | 200   | Stück    |        |         |          |         |
And I press button "taufzu" in row 1
Then the table has 3 rows
Then field "taufzu" has value "icon:folder_closed" in row 3
And I press button "taufzu" in row 3
Then the table has 5 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel    | lemge | leinheit | gebmge | geinheit| verw     | tinfo   |
|icon:folder_closed |KARLSRUHE  | L1  | F1    | VERWENDUNG | 600   | Stück    |        |         |          |         |
|icon:folder_closed |KARLSRUHE  | L1  | F2    | VERWENDUNG | 100   | Stück    |        |         |          |         |
|icon:folder_opened |BERLIN     | L3  | L3F1  | VERWENDUNG | 200   | Stück    |        |         |          |         |
|                   |           |     | L3F1  | VERWENDUNG |       |          | 100    | Stück   |          |         |
|                   |           |     | L3F1  | VERWENDUNG |       |          | 100    | Stück   | 200001_1 |         |
And I set field "verdichten" to "nein"
Then field "details" has value "ja"
And I set field "details" to "nein"
Then the table has 0 rows
And I press start
Then the table has 3 rows
Then field "taufzu" has value "icon:folder_closed" in row 1
And I press button "taufzu" in row 1
Then the table has 9 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel    | lemge | leinheit | gebmge | geinheit| verw     | tinfo   |
|icon:folder_opened |KARLSRUHE  | L1  | F1    | VERWENDUNG | 600   | Stück    |        |         |          |         |
|                   |           |     | F1    | VERWENDUNG |       |          | 100    | Stück   |200001_1  |         |
|                   |           |     | F1    | VERWENDUNG |       |          | 100    | Stück   |200001_1  |         |
|                   |           |     | F1    | VERWENDUNG |       |          | 100    | Stück   |200001_1  |         |
|                   |           |     | F1    | VERWENDUNG |       |          | 100    | Stück   |200002_1  |         |
|                   |           |     | F1    | VERWENDUNG |       |          | 100    | Stück   |200002_1  |         |
|                   |           |     | F1    | VERWENDUNG |       |          | 100    | Stück   |          |         |
|icon:folder_closed |KARLSRUHE  | L1  | F2    | VERWENDUNG | 100   | Stück    |        |         |          |         |
|icon:folder_closed |BERLIN     | L3  | L3F1  | VERWENDUNG | 200   | Stück    |        |         |          |         |
And I set field "kverw" to "200001_1 "
Then the table has 0 rows
And I press start
Then the table has 4 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel    | gebmge | geinheit| verw     |  tinfo    |
|                   |KARLSRUHE  | L1  | F1    | VERWENDUNG | 100    | Stück   |200001_1  |           |
|                   |KARLSRUHE  | L1  | F1    | VERWENDUNG | 100    | Stück   |200001_1  |           |
|                   |KARLSRUHE  | L1  | F1    | VERWENDUNG | 100    | Stück   |200001_1  |           |
|                   |BERLIN     | L3  | L3F1  | VERWENDUNG | 100    | Stück   |200001_1  |           |
And I close the current editor
# Manuelle Lagerbuchung: Verwendung umbuchen, dadurch weicht erster Zugang und letzte Lagerbewegung ab
Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | VERWENDUNG  |
      | beleg       | UMB         |
      | beldat      | .           |
      | buart       | Umbuchung   |
And I modify table
# Zugang von 3000 kg
      | !row  | mge     |ze      |platz | platz2 | verw     | verw2      |
      | +1    | 300     | Stück  | F1   | F1     | 200001_1 | 200001_1XX |
And I save the current editor

    # LJ oeffnen von der EK-Rechnung (Originalzugang) und der manuellen Lagerbuchung (letzter Beweger), um dann im Infosystem in der Zeilenlupe zu vergleichen
    Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==VERWENDUNG;buarta==Zugang;platz==F1;ebeleg==Zug1 Verwendung;@richtung=vorwärts;@maxordtreffer=1"
Then fields have values
    | artikel       | VERWENDUNG            |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 100                   |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
And I close the current editor

    Given I open an editor "JournalZu1Um" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==VERWENDUNG;buarta==Zugang;detursache=Manuelle Umbuchung;platz==F1;verw==200001_1XX"
Then fields have values
    | artikel       | VERWENDUNG            |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 300                   |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | erfasst               |
    | detursache    | Manuelle Umbuchung    |
And I close the current editor

Given I open the infosystem "BESTAND"
And I set field "artikel" to "VERWENDUNG"
And I set field "klgruppe" to ""
Then field "details" has value "ja"
Then field "verdichten" has value "ja"
And I set field "details" to "nein"
And I press start
Then the table has 3 rows
Then table has values
 |lgruppe    |lager|lplatz |tartikel    | lemge | leinheit | tinfo |
 |KARLSRUHE  | L1  | F1    | VERWENDUNG | 600   | Stück    |       |
 |KARLSRUHE  | L1  | F2    | VERWENDUNG | 100   | Stück    |       |
 |BERLIN     | L3  | L3F1  | VERWENDUNG | 200   | Stück    |       |
And I press button "taufzu" in row 1
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel    | lemge | leinheit | gebmge | geinheit| verw     | tinfo   | vorgtyp  | vorgtyp2 |
|icon:folder_opened |KARLSRUHE  | L1  | F1    | VERWENDUNG | 600   | Stück    |        |         |          |         |          |          |
|                   |           |     | F1    | VERWENDUNG |       |          | 100    | Stück   |          |         |          |          |
|                   |           |     | F1    | VERWENDUNG |       |          | 300    | Stück   |200001_1XX|         |          |          |
|                   |           |     | F1    | VERWENDUNG |       |          | 200    | Stück   |200002_1  |         |          |          |
|icon:folder_closed |KARLSRUHE  | L1  | F2    | VERWENDUNG | 100   | Stück    |        |         |          |         |          |          |
|icon:folder_closed |BERLIN     | L3  | L3F1  | VERWENDUNG | 200   | Stück    |        |         |          |         |          |          |
And I set field "verdichten" to "nein"
And I set field "details" to "ja"
And I press start
Then the table has 12 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel    | lemge | leinheit | gebmge | geinheit| verw      | tinfo             | vorgtyp  | vorgtyp2              |
|icon:folder_opened |KARLSRUHE  | L1  | F1    | VERWENDUNG | 600   | Stück    |        |         |           |                   |          |                       |
|                   |           |     | F1    | VERWENDUNG |       |          | 100    | Stück   |200002_1   |                   | Rechnung | Rechnung              |
|                   |           |     | F1    | VERWENDUNG |       |          | 100    | Stück   |200002_1   |                   | Rechnung | Rechnung              |
|                   |           |     | F1    | VERWENDUNG |       |          | 100    | Stück   |           |                   | Rechnung | Rechnung              |
|                   |           |     | F1    | VERWENDUNG |       |          | 100    | Stück   |200001_1XX | icon:information  | Rechnung | Manuelle Lagerbuchung |
|                   |           |     | F1    | VERWENDUNG |       |          | 100    | Stück   |200001_1XX | icon:information  | Rechnung | Manuelle Lagerbuchung |
|                   |           |     | F1    | VERWENDUNG |       |          | 100    | Stück   |200001_1XX | icon:information  | Rechnung | Manuelle Lagerbuchung |
|icon:folder_opened |KARLSRUHE  | L1  | F2    | VERWENDUNG | 100   | Stück    |        |         |           |                   |          |                       |
|                   |           |     | F2    | VERWENDUNG |       |          | 100    | Stück   |           |                   | Rechnung | Rechnung              |
|icon:folder_opened |BERLIN     | L3  | L3F1  | VERWENDUNG | 200   | Stück    |        |         |           |                   |          |                       |
|                   |           |     | L3F1  | VERWENDUNG |       |          | 100    | Stück   |           |                   | Rechnung | Rechnung              |
|                   |           |     | L3F1  | VERWENDUNG |       |          | 100    | Stück   |200001_1   |                   | Rechnung | Rechnung              |
And I set field "kverw" to "200001_1"
And I press start
Then the table has 4 rows
Then table has values
|lgruppe    |lager|lplatz |tartikel    | gebmge | geinheit| verw       |  tinfo           |vorgtyp  | vorgtyp2              |
|KARLSRUHE  | L1  | F1    | VERWENDUNG | 100    | Stück   |200001_1XX  | icon:information |Rechnung | Manuelle Lagerbuchung |
|KARLSRUHE  | L1  | F1    | VERWENDUNG | 100    | Stück   |200001_1XX  | icon:information |Rechnung | Manuelle Lagerbuchung |
|KARLSRUHE  | L1  | F1    | VERWENDUNG | 100    | Stück   |200001_1XX  | icon:information |Rechnung | Manuelle Lagerbuchung |
|BERLIN     | L3  | L3F1  | VERWENDUNG | 100    | Stück   |200001_1    |                  |Rechnung | Rechnung              |
# Felder letzter Beweger (lj), Originalzugang (orig) und Bewertungszugang (beworig) werden gefuellt, damit Bewertungsnachweis aus dem IS BESTAND heraus aufgerufen werden kann
Then field "lj^id" has value "!JournalZu1Um^id" in row 1
Then field "orig^id" has value "!JournalZu1^id" in row 1
Then field "beworig^id" has value "!JournalZu1^id" in row 1
And I close the current editor

Scenario: 3 BESTAND prüfen für den Artikel EINHEIT

Given I open an editor "VERSEINHEITEN" from table "(Part):(Product)" with command "UPDATE" for record "EINHEIT"
# Lagereinheit kg
# EK-Handelseinheit t
# VK-Handelseinheit g
# keine Gebindehaken, es wird alles in kg gebucht
And I set field "vhe" to "kg"
And I set field "vpe" to "kg" 
And I set field "ehe" to "kg" 
And I set field "epe" to "kg" 
And I set field "ve" to "kg" 
And I set field "ge" to "kg" 
And I set field "ehe" to "t"
And I set field "gebehe" to "nein" 
And I set field "vhe" to "g"
And I set field "gebvhe" to "nein"
And I save the current editor

# manuelle Lagerzugänge für den Artikel EINHEIT
Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | EINHEIT   |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
# Zugang von 3000 kg
      | !row  | mge     |ze  | platz2 | 
      | +1    | 1       | t  | F1     | 
      | +2    | 1000    | kg | F1     |
      | +3    | 1000000 | g  | F1     | 
And I save the current editor


Given I open the infosystem "BESTAND"
And I set field "artikel" to "EINHEIT"
Then field "details" has value "ja"
And I set field "details" to "nein"
And I press start
Then the table has 1 rows
Then table has values
 |lgruppe    |lager|lplatz |tartikel    | lemge | leinheit |
 |KARLSRUHE  | L1  | F1    | EINHEIT    | 3000  | kg       |
Then field "taufzu" has value "icon:folder_closed" in row 1 
And I press button "taufzu" in row 1
Then the table has 2 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel | lemge | leinheit | gebmge | geinheit|
|icon:folder_opened |KARLSRUHE  | L1  | F1    | EINHEIT | 3000  | kg       |        |         |
|                   |           |     | F1    | EINHEIT |       |          | 3000   | kg      |
And I set field "verdichten" to "nein"
Then field "details" has value "ja"
And I set field "details" to "nein"
Then the table has 0 rows
And I press start
Then the table has 1 rows
Then field "taufzu" has value "icon:folder_closed" in row 1 
And I press button "taufzu" in row 1
Then the table has 4 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel | lemge | leinheit | gebmge | geinheit|
|icon:folder_opened |KARLSRUHE  | L1  | F1    | EINHEIT | 3000  | kg       |        |         |
|                   |           |     | F1    | EINHEIT |       |          | 1000   | kg      |
|                   |           |     | F1    | EINHEIT |       |          | 1000   | kg      |
|                   |           |     | F1    | EINHEIT |       |          | 1000   | kg      |
And I close the current editor

Given I open an editor "VERSEINHEITEN" from table "(Part):(Product)" with command "UPDATE" for record "EINHEIT"
# Nun die Gebindehaken setzen
And I set field "gebehe" to "ja" 
And I set field "gebvhe" to "ja"
And I save the current editor

# manuelle Lagerzugänge für den Artikel EINHEIT
Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | EINHEIT   |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
# Zugang von insgesamt 9.000 kg, gebucht wird aber in verschiedenen Einheiten
      | !row  | mge     |ze  | platz2 | 
      | +1    | 1       | t  | F2     | 
      | +2    | 1       | t  | F2     |
      | +3    | 1       | t  | F2     | 
      | +4    | 1000    | kg | F2     |   
      | +5    | 1000    | kg | F2     |   
      | +6    | 1000    | kg | F2     |  
      | +7    | 1000000 | g  | F2     |
      | +8    | 1000000 | g  | F2     |  
      | +9    | 1000000 | g  | F2     |                
And I save the current editor

Given I open the infosystem "BESTAND"
And I set field "artikel" to "EINHEIT"
And I press start
Then field "details" has value "ja"
Then the table has 6 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel | lemge | leinheit | gebmge  | geinheit|  gebf  |
|icon:folder_opened |KARLSRUHE  | L1  | F1    | EINHEIT | 3000  | kg       |         |         |        |
|                   |           |     | F1    | EINHEIT |       |          | 3000    | kg      |   1    |
|icon:folder_opened |KARLSRUHE  | L1  | F2    | EINHEIT | 9000  | kg       |         |         |        |
|                   |           |     | F2    | EINHEIT |       |          | 3000    | kg      |   1    |
|                   |           |     | F2    | EINHEIT |       |          | 3000000 | g       | 0.001  |
|                   |           |     | F2    | EINHEIT |       |          | 3       | t       |  1000  |
And I set field "verdichten" to "nein"
Then the table has 0 rows
And I press start
Then the table has 14 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel | lemge | leinheit | gebmge  | geinheit|  gebf  |
|icon:folder_opened |KARLSRUHE  | L1  | F1    | EINHEIT | 3000  | kg       |         |         |        |
|                   |           |     | F1    | EINHEIT |       |          | 1000    | kg      |   1    |
|                   |           |     | F1    | EINHEIT |       |          | 1000    | kg      |   1    |
|                   |           |     | F1    | EINHEIT |       |          | 1000    | kg      |   1    |
|icon:folder_opened |KARLSRUHE  | L1  | F2    | EINHEIT | 9000  | kg       |         |         |        |
|                   |           |     | F2    | EINHEIT |       |          | 1       | t       |  1000  |
|                   |           |     | F2    | EINHEIT |       |          | 1       | t       |  1000  |
|                   |           |     | F2    | EINHEIT |       |          | 1       | t       |  1000  |
|                   |           |     | F2    | EINHEIT |       |          | 1000    | kg      |   1    |
|                   |           |     | F2    | EINHEIT |       |          | 1000    | kg      |   1    |
|                   |           |     | F2    | EINHEIT |       |          | 1000    | kg      |   1    |
|                   |           |     | F2    | EINHEIT |       |          | 1000000 | g       | 0.001  |
|                   |           |     | F2    | EINHEIT |       |          | 1000000 | g       | 0.001  |
|                   |           |     | F2    | EINHEIT |       |          | 1000000 | g       | 0.001  |
And I close the current editor

Scenario: 4 BESTAND prüfen für den Artikel CHARGE
Given I open an editor "ARTCHARGE" from table "(Part):(Product)" with command "UPDATE" for record "CHARGE"
# Chargenfelder im Artikel CHARGE setzen
And I set field "chverfolgung" to "Chargenverfolgung"  
And I save the current editor

#Chargen anlegen
Given I open an editor "CH_1111" from table "(Lots):(Lots)" with command "STORE" for record "C1111"
And I set fields
    | such      | C1111     |
    | exnum     | 1111      |
    | artikel   | CHARGE    |
And I save the current editor
Given I open an editor "CH_2222" from table "(Lots):(Lots)" with command "STORE" for record "C2222"
And I set fields
    | such      | C2222     |
    | exnum     | 2222      |
    | artikel   | CHARGE    |
And I save the current editor
Given I open an editor "CH_3333" from table "(Lots):(Lots)" with command "STORE" for record "C3333"
And I set fields
    | such      | C3333     |
    | exnum     | 3333     |
    | artikel   | CHARGE    |
And I save the current editor

# manuelle Lagerzugänge für den Artikel CHARGE
Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | CHARGE   |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
# Zugang von 100 Stück auf Charge C1111
# Zugang von 200 Stück auf Charge C2222
# Zugang von 300 Stück auf Charge C3333
# Zugang von 66  Stück ohne Charge
      | !row  | mge     |charge2  | platz2 | 
      | +1    | 100     | C1111   | F1     | 
      | +2    | 100     | C2222   | F1     |
      | +3    | 100     | C2222   | F1     | 
      | +4    | 100     | C3333   | F1     |
      | +5    | 100     | C3333   | F1     | 
      | +6    | 100     | C3333   | L3F1   |
      | +7    | 10      |         | F1     | 
      | +8    | 1       |         | F1     |
      | +9    | 20      |         | F1     |  
      | +10   | 2       |         | F1     |        
      | +11   | 30      |         | F1     |            
      | +12   | 3       |         | F1     |                 
And I save the current editor

Given I open the infosystem "BESTAND"
And I set field "artikel" to "CHARGE"
And I set field "klgruppe" to ""
Then field "details" has value "ja"
And I set field "details" to "nein"
And I press start
Then the table has 2 rows
Then table has values
 |lgruppe    |lager|lplatz |tartikel    | lemge | leinheit |
 |KARLSRUHE  | L1  | F1    | CHARGE     | 566   | Stück    |
 |BERLIN     | L3  | L3F1  | CHARGE     | 100   | Stück    |
Then field "taufzu" has value "icon:folder_closed" in row 1 
And I press button "taufzu" in row 1
Then the table has 6 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel | lemge | leinheit | gebmge  | geinheit| exnum   |
|icon:folder_opened |KARLSRUHE  | L1  | F1    | CHARGE  | 566   | Stück    |         |         |         |
|                   |           |     | F1    | CHARGE  |       |          | 66      | Stück   |         |
|                   |           |     | F1    | CHARGE  |       |          | 100     | Stück   | 1111    |
|                   |           |     | F1    | CHARGE  |       |          | 200     | Stück   | 2222    |
|                   |           |     | F1    | CHARGE  |       |          | 200     | Stück   | 3333    |
|icon:folder_closed |BERLIN     | L3  | L3F1  | CHARGE  | 100   | Stück    |         |         |         |
And I set field "verdichten" to "nein"
And I set field "kcharge" to "C3333"
And I press start
Then the table has 3 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel    |gebmge | geinheit| exnum  |
|                   |KARLSRUHE  | L1  | F1    | CHARGE     | 100   | Stück   | 3333   |         
|                   |KARLSRUHE  | L1  | F1    | CHARGE     | 100   | Stück   | 3333   |
|                   |BERLIN     | L3  | L3F1  | CHARGE     | 100   | Stück   | 3333   |
And I close the current editor

Given I open the infosystem "BESTAND"
And I set field "klgruppe" to ""
And I set field "verdichten" to "nein"
And I set field "kexnum" to "3333"
And I press start
Then the table has 3 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel    |gebmge | geinheit| exnum  |
|                   |KARLSRUHE  | L1  | F1    | CHARGE     | 100   | Stück   | 3333   |
|                   |KARLSRUHE  | L1  | F1    | CHARGE     | 100   | Stück   | 3333   |
|                   |BERLIN     | L3  | L3F1  | CHARGE     | 100   | Stück   | 3333   |
And I set field "klgruppe" to "BERLIN"
And I press start
Then the table has 1 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel    |gebmge | geinheit| exnum  |
|                   |BERLIN     | L3  | L3F1  | CHARGE     | 100   | Stück   | 3333   |
And I close the current editor

Given I open the infosystem "BESTAND"
And I set field "artikel" to "CHARGE"
And I set field "klgruppe" to "BERLIN"
Then field "details" has value "ja"
And I set field "details" to "nein"
And I press start
Then the table has 1 rows
Then table has values
 |lgruppe    |lager|lplatz |tartikel    | lemge | leinheit |
 |BERLIN     | L3  | L3F1  | CHARGE     | 100   | Stück    |
And I close the current editor
 
 Scenario: 5 BESTAND prüfen für den Artikel BEHAELTER
 
Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | BEHAELTER-ART|
      | beleg       | ZUG          |
      | beldat      | .            |
      | buart       | Zugang       |
And I modify table
# Zugang von 100 Stück in den Behälter 1
# Zugang von 200 Stück in den Behälter 2
# Zugang von 300 Stück in den Behälter 3
# Zugang von 250 Stück OHNE Behälter
      | !row  | mge     | platz2 | behaelter   |
      | +1    | 100     | F1     |             |
      | +2    | 100     | F1     | BEHAELTER_1 |
      | +3    | 200     | F1     | BEHAELTER_2 |
      | +4    | 100     | L3F1   |             |
      | +5    | 50      | L3F1   |             |
      | +6    | 300     | L3F1   | BEHAELTER_3 |                    
And I save the current editor

Given I open the infosystem "BESTAND"
And I set field "artikel" to "BEHAELTER-ART"
And I set field "klgruppe" to ""
Then field "details" has value "ja"
And I set field "details" to "nein"
And I press start
Then the table has 2 rows
Then table has values
 |lgruppe    |lager|lplatz  |tartikel       | lemge | leinheit |
 |KARLSRUHE  | L1  | F1     | BEHAELTER-ART | 400   | Stück    |
 |BERLIN     | L3  | L3F1   | BEHAELTER-ART | 450   | Stück    |
Then field "taufzu" has value "icon:folder_closed" in row 1 
And I press button "taufzu" in row 1
Then the table has 5 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel        | lemge | leinheit | gebmge  | geinheit| tbehaelter |
|icon:folder_opened |KARLSRUHE  | L1  | F1    | BEHAELTER-ART  | 400   | Stück    |         |         |            |
|                   |           |     | F1    | BEHAELTER-ART  |       |          | 100     | Stück   |            |
|                   |           |     | F1    | BEHAELTER-ART  |       |          | 100     | Stück   | 1          |
|                   |           |     | F1    | BEHAELTER-ART  |       |          | 200     | Stück   | 2          |
|icon:folder_closed |BERLIN     | L3  | L3F1  | BEHAELTER-ART  | 450   | Stück    |         |         |            |
And I set field "artikel" to ""
And I set field "behaelter" to "ja"
And I set field "selbehaelter" to "3"
Then field "details" has value "nein"
Then field "klplatz" has value "L3F1"
Then field "details" has value "nein"
And I press start
Then the table has 1 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel       | gebmge | geinheit| tbehaelter   |
|                   | BERLIN    | L3  | L3F1  | BEHAELTER-ART | 300    | Stück   |   3          |
And I close the current editor

Scenario: 6 BESTAND prüfen für den Artikel PROJEKT

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | PROJEKT      |
      | beleg       | ZUG          |
      | beldat      | .            |
      | buart       | Zugang       |
And I modify table
# Zugang von 100 Stück auf Projekt 1
# Zugang von 200 Stück auf Projekt 2
# Zugang von 300 Stück auf Projekt 3
# Zugang von 100 Stück OHNE Projekt
      | !row  | mge     | projekt     | platz2 | 
      | +1    | 100     |             | F1     | 
      | +2    | 100     | PROJEKT1    | F1     |
      | +3    | 100     | PROJEKT3    | F1     |
      | +4    | 100     | PROJEKT2    | F2     | 
      | +5    | 100     | PROJEKT2    | F2     |
      | +6    | 100     | PROJEKT3    | L3F1   | 
      | +7    | 100     | PROJEKT3    | L3F1   |                         
And I save the current editor

Given I open the infosystem "BESTAND"
And I set field "artikel" to "PROJEKT"
And I set field "klgruppe" to ""
Then field "details" has value "ja"
And I set field "details" to "nein"
And I press start
Then the table has 3 rows
Then table has values
 |lgruppe    |lager|lplatz  |tartikel  | lemge | leinheit |
 |KARLSRUHE  | L1  | F1     | PROJEKT  | 300   | Stück    |
 |KARLSRUHE  | L1  | F2     | PROJEKT  | 200   | Stück    |
 |BERLIN     | L3  | L3F1   | PROJEKT  | 200   | Stück    |
Then field "taufzu" has value "icon:folder_closed" in row 3 
And I press button "taufzu" in row 3
Then the table has 4 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel  | lemge | leinheit | gebmge  | geinheit| projekt    |
|icon:folder_closed |KARLSRUHE  | L1  | F1    | PROJEKT  | 300   | Stück    |         |         |            |
|icon:folder_closed |KARLSRUHE  | L1  | F2    | PROJEKT  | 200   | Stück    |         |         |            |
|icon:folder_opened |BERLIN     | L3  | L3F1  | PROJEKT  | 200   | Stück    |         |         |            |
|                   |           |     | L3F1  | PROJEKT  |       |          | 200     | Stück   | PROJEKT3   |
And I set field "verdichten" to "nein"
And I set field "kprojekt" to "PROJEKT3"
And I press start
Then the table has 3 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel  | gebmge | geinheit| projekt  |
|                   | KARLSRUHE | L1  | F1    | PROJEKT  | 100    | Stück   | PROJEKT3 |         
|                   | BERLIN    | L3  | L3F1  | PROJEKT  | 100    | Stück   | PROJEKT3 |
|                   | BERLIN    | L3  | L3F1  | PROJEKT  | 100    | Stück   | PROJEKT3 |
And I close the current editor

Scenario: 7 BESTAND prüfen für den Artikel KOMPLEX

Given I open an editor "KOMPLEX" from table "(Part):(Product)" with command "UPDATE" for record "KOMPLEX"
# Chargenfelder im Artikel KOMPLEX setzen
And I set field "chverfolgung" to "Chargenverfolgung" 
And I save the current editor

#Chargen anlegen
Given I open an editor "CH_KOMPL_1" from table "(Lots):(Lots)" with command "STORE" for record "C_K_1"
And I set fields
    | such      | C_K_1     |
    | exnum     | Komplex 1 |
    | artikel   | KOMPLEX   |
And I save the current editor
Given I open an editor "CH_KOMPL_2" from table "(Lots):(Lots)" with command "STORE" for record "C_K_2"
And I set fields
    | such      | C_K_2     |
    | exnum     | Komplex 2 |
    | artikel   | KOMPLEX   | 
And I save the current editor

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | KOMPLEX      |
      | beleg       | ZUG          |
      | beldat      | .            |
      | buart       | Zugang       |
And I modify table
# Zugang von insgesamt 800 Stück auf F1
# -> es lässt sich nichts verdichten
# -> jede Ausprägung ist unterschiedlich
      | !row  | mge     | verw    | charge2  | projekt    | platz2 | 
      | +1    | 100     |         |          |            | F1     | 
      | +2    | 100     | 20099_9 |          |            | F1     |
      | +3    | 100     |         | C_K_1    |            | F1     |
      | +4    | 100     |         |          |PROJEKT4    | F1     | 
      | +5    | 100     | 20099_9 | C_K_1    |            | F1     |
      | +6    | 100     | 20099_9 |          |PROJEKT4    | F1     |  
      | +7    | 100     |         | C_K_1    |PROJEKT4    | F1     |
      | +8    | 100     | 20099_9 | C_K_1    |PROJEKT4    | F1     |                          
And I save the current editor

Given I open the infosystem "BESTAND"
And I set field "artikel" to "KOMPLEX"
And I set field "klplatz" to "F1"
Then field "details" has value "ja"
And I set field "details" to "nein"
And I press start
Then the table has 1 rows
Then table has values
 |lgruppe    |lager|lplatz  |tartikel  | lemge | leinheit |
 |KARLSRUHE  | L1  | F1     | KOMPLEX  | 800   | Stück    |
Then field "taufzu" has value "icon:folder_closed" in row 1 
And I press button "taufzu" in row 1
Then the table has 9 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel  | lemge | leinheit | gebmge  | geinheit|   verw   | exnum     | projekt  |
|icon:folder_opened |KARLSRUHE  | L1  | F1    | KOMPLEX  | 800   | Stück   |         |         |          |           |          |
|                   |           |     | F1    | KOMPLEX  |       |          | 100     | Stück   |          |           |          |
|                   |           |     | F1    | KOMPLEX  |       |          | 100     | Stück   | 20099_9  |           |          |
|                   |           |     | F1    | KOMPLEX  |       |          | 100     | Stück   |          |           | PROJEKT4 |
|                   |           |     | F1    | KOMPLEX  |       |          | 100     | Stück   | 20099_9  |           | PROJEKT4 |
|                   |           |     | F1    | KOMPLEX  |       |          | 100     | Stück   |          | Komplex 1 |          |
|                   |           |     | F1    | KOMPLEX  |       |          | 100     | Stück   | 20099_9  | Komplex 1 |          |
|                   |           |     | F1    | KOMPLEX  |       |          | 100     | Stück   |          | Komplex 1 | PROJEKT4 |
|                   |           |     | F1    | KOMPLEX  |       |          | 100     | Stück   | 20099_9  | Komplex 1 | PROJEKT4 |
And I close the current editor 

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | KOMPLEX      |
      | beleg       | ZUG          |
      | beldat      | .            |
      | buart       | Zugang       |
And I modify table
# Zugang von insgesamt 800 Stück auf F2
# -> man kann verdichten
# -> 200 Stück Verwendung und Charge
# -> 200 Stück Charge und Projekt
# -> 200 Stück Verwendung, Charge und Projekt
      | !row  | mge     | verw    | charge2  | projekt    | platz2 | 
      | +1    | 100     |         |          |            | F2     | 
      | +2    | 100     | 20099_9 | C_K_2    |            | F2     |
      | +3    | 100     | 20099_9 | C_K_2    |            | F2     |
      | +4    | 100     |         |          |PROJEKT5    | F2     | 
      | +5    | 100     |         | C_K_2    |PROJEKT5    | F2     |
      | +6    | 100     |         | C_K_2    |PROJEKT5    | F2     |  
      | +7    | 100     | 20099_9 | C_K_2    |PROJEKT5    | F2     |
      | +8    | 100     | 20099_9 | C_K_2    |PROJEKT5    | F2     |                          
And I save the current editor

Given I open the infosystem "BESTAND"
And I set field "artikel" to "KOMPLEX"
And I set field "klplatz" to "F2"
Then field "details" has value "ja"
And I set field "details" to "nein"
And I press start
Then the table has 1 rows
Then table has values
 |lgruppe    |lager|lplatz  |tartikel  | lemge | leinheit |
 |KARLSRUHE  | L1  | F2     | KOMPLEX  | 800   | Stück    |
Then field "taufzu" has value "icon:folder_closed" in row 1 
And I press button "taufzu" in row 1
Then the table has 6 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel  | lemge | leinheit | gebmge  | geinheit|   verw   | exnum     | projekt  |  vorgang  | vorgtyp  | 
|icon:folder_opened |KARLSRUHE  | L1  | F2    | KOMPLEX  | 800   | Stück    |         |         |          |           |          |           |          |
|                   |           |     | F2    | KOMPLEX  |       |          | 100     | Stück   |          |           |          |           |          | 
|                   |           |     | F2    | KOMPLEX  |       |          | 100     | Stück   |          |           | PROJEKT5 |           |          | 
|                   |           |     | F2    | KOMPLEX  |       |          | 200     | Stück   | 20099_9  | Komplex 2 |          |           |          |
|                   |           |     | F2    | KOMPLEX  |       |          | 200     | Stück   |          | Komplex 2 | PROJEKT5 |           |          | 
|                   |           |     | F2    | KOMPLEX  |       |          | 200     | Stück   | 20099_9  | Komplex 2 | PROJEKT5 |           |          |
And I set field "verdichten" to "nein"
Then field "details" has value "ja"
And I set field "details" to "nein"
And I press start
Then the table has 1 rows
Then table has values
 |lgruppe    |lager|lplatz  |tartikel  | lemge | leinheit |
 |KARLSRUHE  | L1  | F2     | KOMPLEX  | 800   | Stück    |
Then field "taufzu" has value "icon:folder_closed" in row 1 
And I press button "taufzu" in row 1
Then the table has 9 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel  | lemge | leinheit | gebmge  | geinheit|   verw   | exnum     | projekt  | vorgtyp               |
|icon:folder_opened |KARLSRUHE  | L1  | F2    | KOMPLEX  | 800   | Stück    |         |         |          |           |          |                       |
|                   |           |     | F2    | KOMPLEX  |       |          | 100     | Stück   |          |           |          | Manuelle Lagerbuchung |
|                   |           |     | F2    | KOMPLEX  |       |          | 100     | Stück   | 20099_9  | Komplex 2 |          | Manuelle Lagerbuchung |
|                   |           |     | F2    | KOMPLEX  |       |          | 100     | Stück   | 20099_9  | Komplex 2 |          | Manuelle Lagerbuchung |
|                   |           |     | F2    | KOMPLEX  |       |          | 100     | Stück   |          |           | PROJEKT5 | Manuelle Lagerbuchung |
|                   |           |     | F2    | KOMPLEX  |       |          | 100     | Stück   |          | Komplex 2 | PROJEKT5 | Manuelle Lagerbuchung |
|                   |           |     | F2    | KOMPLEX  |       |          | 100     | Stück   |          | Komplex 2 | PROJEKT5 | Manuelle Lagerbuchung |
|                   |           |     | F2    | KOMPLEX  |       |          | 100     | Stück   | 20099_9  | Komplex 2 | PROJEKT5 | Manuelle Lagerbuchung |
|                   |           |     | F2    | KOMPLEX  |       |          | 100     | Stück   | 20099_9  | Komplex 2 | PROJEKT5 | Manuelle Lagerbuchung |
Then field "vorgang" is empty in row 1
Then field "vorgang" is not empty in row 2
Then field "vorgang" is not empty in row 3
Then field "vorgang" is not empty in row 4
Then field "vorgang" is not empty in row 5
Then field "vorgang" is not empty in row 6
Then field "vorgang" is not empty in row 7
Then field "vorgang" is not empty in row 8
Then field "vorgang" is not empty in row 9

And I close the current editor 

Given I open the infosystem "BESTAND"
And I set field "artikel" to "KOMPLEX"
And I set field "klplatz" to "F2"
Then field "details" has value "ja"
And I press start
Then the table has 6 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel  | lemge | leinheit | gebmge  | geinheit|   verw   | exnum     | projekt  |  vorgang  | vorgtyp  | 
|icon:folder_opened |KARLSRUHE  | L1  | F2    | KOMPLEX  | 800   | Stück    |         |         |          |           |          |           |          |
|                   |           |     | F2    | KOMPLEX  |       |          | 100     | Stück   |          |           |          |           |          | 
|                   |           |     | F2    | KOMPLEX  |       |          | 100     | Stück   |          |           | PROJEKT5 |           |          | 
|                   |           |     | F2    | KOMPLEX  |       |          | 200     | Stück   | 20099_9  | Komplex 2 |          |           |          |
|                   |           |     | F2    | KOMPLEX  |       |          | 200     | Stück   |          | Komplex 2 | PROJEKT5 |           |          | 
|                   |           |     | F2    | KOMPLEX  |       |          | 200     | Stück   | 20099_9  | Komplex 2 | PROJEKT5 |           |          |
And I close the current editor

Scenario: 8 Infosystem Bestand Selektions-Felder Nur Packmittel, Nur gesperrte Artikel, nur negative Bestände
# gesperrten Artikel anlegen
Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | GESPERRT     |
      | beleg       | ZUG          |
      | beldat      | .            |
      | buart       | Zugang       |
And I modify table
      | !row  | mge     | verw    | charge2  | projekt    | platz2 | 
      | +1    | 100     |         |          |            | F1     |                
And I save the current editor

# Hier Sperrzustand wieder integrieren
#Given I open an editor "GESPERRT" from table "(Part):(Product)" with command "UPDATE" for record "GESPERRT"
#And I set field "objektstatus" to "gesperrt" 
#And I save the current editor
# das Packmittel Behälter ist schon im Mandanten enthalten 
Given I open the infosystem "BESTAND"
And I set field "klgruppe" to ""
And I set field "packm" to "ja"
And I press start
Then the table has 2 rows
Then table has values
 |lgruppe    |lager|lplatz  |tartikel    | lemge | leinheit |
 | KARLSRUHE | L1  | F1     | BEHAELTER  | -2    | Stück    |
 | BERLIN    | L3  | L3F1   | BEHAELTER  | -1    | Stück    |
And I set field "nurnegativ" to "ja"
And I press start
Then the table has 3 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz |tartikel    | gebmge | geinheit|
|                   | KARLSRUHE | L1  | F1    | BEHAELTER  | -1     | Stück   |        
|                   | KARLSRUHE | L1  | F1    | BEHAELTER  | -1     | Stück   |
|                   | BERLIN    | L3  | L3F1  | BEHAELTER  | -1     | Stück    |
And I close the current editor
#And I set field "nurnegativ" to "nein"
#And I set field "packm" to "nein"
#And I set field "gesperrt" to "ja"
#And I press start
#Then the table has 1 rows
#Then table has values
# |lgruppe    |lager|lplatz  |tartikel   | objektstatus | lemge | leinheit |
# |KARLSRUHE  | L1  | F1     | GESPERRT  | icon:stop    | 100   | Stück    |
#And I close the current editor

Scenario: 9 Nullbestände im Infosystem BESTAND 

Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | NULLBESTAND  |
      | beleg       | ZUG          |
      | beldat      | .            |
      | buart       | Zugang       |
And I modify table
      | !row  | mge     | platz2 | 
      | +1    | 100     | F1     | 
      | +2    | 100     | F2     |               
And I save the current editor

Given I open an editor "manLagerabgang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | NULLBESTAND  |
      | beleg       | ABG          |
      | beldat      | .            |
      | buart       | Abgang       |
And I modify table
      | !row  | mge     |  platz  | 
      | +1    | 100     |  F1     | 
And I save the current editor   

Given I open the infosystem "BESTAND"
And I set field "artikel" to "NULLBESTAND"
Then field "details" has value "ja"
And I press start
Then the table has 3 rows
Then table has values
|taufzu             |lgruppe    |lager|lplatz  |tartikel     | lemge | leinheit  | gebmge | geinheit | gebf |
|                   |KARLSRUHE  | L1  | F1     | NULLBESTAND |       | Stück    |        |          |      |
|icon:folder_opened |KARLSRUHE  | L1  | F2     | NULLBESTAND | 100   | Stück    |        |          |      |
|                   |           |     | F2     | NULLBESTAND |       |           | 100    | Stück   |  1   |
And I save the current editor
   
Scenario: 10 Verdichtung auf verschiedenen Ebenen 
Given I open an editor "ARTVERDICHTUNG" from table "(Part):(Product)" with command "UPDATE" for record "VERD-EBENEN"
# Chargenfelder im Artikel CHARGE setzen
And I set field "chverfolgung" to "Chargenverfolgung" 
# Handelseinheit auf m
And I set field "ehe" to "m"
And I set field "gebehe" to "ja"
And I save the current editor
#Chargen anlegen
Given I open an editor "CH_A" from table "(Lots):(Lots)" with command "STORE" for record "A"
And I set fields
    | such      | A           |
    | exnum     | A           |
    | artikel   | VERD-EBENEN |
And I save the current editor
Given I open an editor "CH_B" from table "(Lots):(Lots)" with command "STORE" for record "B"
And I set fields
    | such      | B           |
    | exnum     | B           |
    | artikel   | VERD-EBENEN |
And I save the current editor
# Es werden nun Bestände auf 3 Plätzen in 3 verschiedenen Lagergruppen angelegt
# In Summe sind es über alle 3 Plätze 600 Stück
# auf F1 100 Stück (interne Lagergruppe)
Given I open an editor "manLagerabgang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | VERD-EBENEN  |
      | beleg       | Zug          |
      | beldat      | .            |
      | buart       | Zugang       |
And I modify table
      | !row  | mge     | ze    |  platz2  | verw | charge2  |
      | +1    | 10      | Stück |  F1     |      |          |
      | +2    | 10      | Stück |  F1     |      |          |
      | +3    | 10      | m     |  F1     |      |          |
      | +4    | 10      | m     |  F1     |      |          |
      | +5    | 10      | Stück |  F1     |  A   |  A       |
      | +6    | 10      | Stück |  F1     |      |  A       |
      | +7    | 10      | Stück |  F1     |      |  A       |
      | +8    | 10      | Stück |  F1     |  B   |  B       |
      | +9    | 10      | Stück |  F1     |      |  B       |
      | +10   | 10      | Stück |  F1     |      |  B       |
And I save the current editor
# auf L2F1 200 Stück (externe Lagergruppe HONGKONG)
Given I open an editor "manLagerabgang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | VERD-EBENEN  |
      | beleg       | Zug          |
      | beldat      | .            |
      | buart       | Zugang       |
And I modify table
      | !row  | mge     | ze    |  platz2  | verw | charge2  |
      | +1    | 100      | Stück |  L2F1   |      |          |
      | +2    | 100      | m     |  L2F1   |      |          |
And I save the current editor
    # auf L3F1 300 Stück (externe Lagergruppe BERLIN)
Given I open an editor "manLagerabgang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | VERD-EBENEN  |
      | beleg       | Zug          |
      | beldat      | .            |
      | buart       | Zugang       |
And I modify table
      | !row  | mge     | ze    |  platz2  | verw | charge2  |
      | +1    | 100     | Stück |  L3F1    |      |          |
      | +2    | 100     | m     |  L3F1    |      |          |
      | +3    | 25      | Stück |  L3F1    |  A   |          |
      | +4    | 25      | Stück |  L3F1    |  A   |          |
      | +5    | 25      | Stück |  L3F1    |  B   |          |
      | +6    | 25      | Stück |  L3F1    |  B   |          |
And I save the current editor
# unverdichteten Bestand anzeigen
Given I open the infosystem "BESTAND"
And I set field "artikel" to "VERD-EBENEN"
And I set field "klgruppe" to ""
And I set field "verdichten" to "nein"
And I set field "artverdichten" to "nein"
And I set field "lagerverdichten" to "nein"
And I set field "lgruppeverdichten" to "nein"
Then field "details" has value "ja"
And I press start
Then the table has 21 rows
Then table has values
    |taufzu             |lgruppe    |lager|lplatz  |tartikel     | lemge | leinheit  | gebmge | geinheit | gebf | verw | exnum  |
    |icon:folder_opened |KARLSRUHE  | L1  | F1     | VERD-EBENEN | 100   | Stück     |        |          |      |      |        |
    |                   |           |     | F1     | VERD-EBENEN |       |           | 10     | Stück    |  1   |      |        |
    |                   |           |     | F1     | VERD-EBENEN |       |           | 10     | Stück    |  1   |      |        |
    |                   |           |     | F1     | VERD-EBENEN |       |           | 10     | m        |  1   |      |        |
    |                   |           |     | F1     | VERD-EBENEN |       |           | 10     | m        |  1   |      |        |
    |                   |           |     | F1     | VERD-EBENEN |       |           | 10     | Stück    |  1   |   A  |   A    |
    |                   |           |     | F1     | VERD-EBENEN |       |           | 10     | Stück    |  1   |      |   A    |
    |                   |           |     | F1     | VERD-EBENEN |       |           | 10     | Stück    |  1   |      |   A    |
    |                   |           |     | F1     | VERD-EBENEN |       |           | 10     | Stück    |  1   |   B  |   B    |
    |                   |           |     | F1     | VERD-EBENEN |       |           | 10     | Stück    |  1   |      |   B    |
    |                   |           |     | F1     | VERD-EBENEN |       |           | 10     | Stück    |  1   |      |   B    |
    |icon:folder_opened |HONGKONG   | L2  | L2F1   | VERD-EBENEN | 200   | Stück     |        |          |      |      |        |
    |                   |           |     | L2F1   | VERD-EBENEN |       |           | 100    | Stück    |  1   |      |        |
    |                   |           |     | L2F1   | VERD-EBENEN |       |           | 100    | m        |  1   |      |        |
    |icon:folder_opened |BERLIN     | L3  | L3F1   | VERD-EBENEN | 300   | Stück     |        |          |      |      |        |
    |                   |           |     | L3F1   | VERD-EBENEN |       |           | 100    | Stück    |  1   |      |        |
    |                   |           |     | L3F1   | VERD-EBENEN |       |           | 100    | m        |  1   |      |        |
    |                   |           |     | L3F1   | VERD-EBENEN |       |           | 25     | Stück    |  1   |   A  |        |
    |                   |           |     | L3F1   | VERD-EBENEN |       |           | 25     | Stück    |  1   |   A  |        |
    |                   |           |     | L3F1   | VERD-EBENEN |       |           | 25     | Stück    |  1   |   B  |        |
    |                   |           |     | L3F1   | VERD-EBENEN |       |           | 25     | Stück    |  1   |   B  |        |
And I close the current editor
#Artikelmenge über alle Lagergruppen
Given I open the infosystem "BESTAND"
And I set field "artikel" to "VERD-EBENEN"
And I set field "klgruppe" to ""
And I set field "artverdichten" to "ja"
Then field "details" has value "ja"
And I press start
Then the table has 9 rows
    Then table has values
    |taufzu             |lgruppe    |lager|lplatz  |tartikel     | lemge | leinheit  | gebmge | geinheit | gebf | verw | exnum  |
    |icon:folder_opened |           |     |        | VERD-EBENEN | 600   | Stück     |        |          |      |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 220    | m        |  1   |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 220    | Stück    |  1   |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           |  50    | Stück    |  1   |  A   |        |
    |                   |           |     |        | VERD-EBENEN |       |           |  50    | Stück    |  1   |  B   |        |
    |                   |           |     |        | VERD-EBENEN |       |           |  20    | Stück    |  1   |      |   A    |
    |                   |           |     |        | VERD-EBENEN |       |           |  10    | Stück    |  1   |  A   |   A    |
    |                   |           |     |        | VERD-EBENEN |       |           |  20    | Stück    |  1   |      |   B    |
    |                   |           |     |        | VERD-EBENEN |       |           |  10    | Stück    |  1   |  B   |   B    |
And I close the current editor
# Lagergruppenmenge für interne Lagergruppe KARLSRUHE anzeigen
Given I open the infosystem "BESTAND"
And I set field "artikel" to "VERD-EBENEN"
And I set field "klgruppe" to "KARLSRUHE"
And I set field "lgruppeverdichten" to "ja"
Then field "details" has value "ja"
And I press start
Then the table has 7 rows
Then table has values
    |taufzu             |lgruppe    |lager|lplatz  |tartikel     | lemge | leinheit  | gebmge | geinheit | gebf | verw | exnum  |
    |icon:folder_opened |KARLSRUHE  |     |        | VERD-EBENEN | 100   | Stück     |        |          |      |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 20     | m        |  1   |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 20     | Stück    |  1   |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 20     | Stück    |  1   |      |   A    |
    |                   |           |     |        | VERD-EBENEN |       |           | 10     | Stück    |  1   |   A  |   A    |
    |                   |           |     |        | VERD-EBENEN |       |           | 20     | Stück    |  1   |      |   B    |
    |                   |           |     |        | VERD-EBENEN |       |           | 10     | Stück    |  1   |   B  |   B    |
And I close the current editor
#Lagermenge von L1 in Karlsruhe
Given I open the infosystem "BESTAND"
And I set field "artikel" to "VERD-EBENEN"
And I set field "klager" to "L1"
And I set field "lagerverdichten" to "ja"
Then field "details" has value "ja"
And I press start
Then the table has 7 rows
Then table has values
    |taufzu             |lgruppe    |lager|lplatz  |tartikel     | lemge | leinheit  | gebmge | geinheit | gebf | verw | exnum  |
    |icon:folder_opened |KARLSRUHE  | L1  |        | VERD-EBENEN | 100   | Stück     |        |          |      |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 20     | m        |  1   |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 20     | Stück    |  1   |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 20     | Stück    |  1   |      |   A    |
    |                   |           |     |        | VERD-EBENEN |       |           | 10     | Stück    |  1   |   A  |   A    |
    |                   |           |     |        | VERD-EBENEN |       |           | 20     | Stück    |  1   |      |   B    |
    |                   |           |     |        | VERD-EBENEN |       |           | 10     | Stück    |  1   |   B  |   B    |
And I close the current editor
# Verdichtung nach Lager ohne Eingabe des Platzes
Given I open the infosystem "BESTAND"
And I set field "artikel" to "VERD-EBENEN"
And I set field "klager" to ""
And I set field "klgruppe" to ""
And I set field "lagerverdichten" to "ja"
Then field "details" has value "ja"
And I press start
Then the table has 15 rows
Then table has values
    |taufzu             |lgruppe    |lager| lplatz |tartikel     | lemge | leinheit  | gebmge | geinheit | gebf | verw | exnum  |
    |icon:folder_opened |KARLSRUHE  | L1  |        | VERD-EBENEN | 100   | Stück     |        |          |      |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 20     | m        |  1   |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 20     | Stück    |  1   |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 20     | Stück    |  1   |      |   A    |
    |                   |           |     |        | VERD-EBENEN |       |           | 10     | Stück    |  1   |   A  |   A    |
    |                   |           |     |        | VERD-EBENEN |       |           | 20     | Stück    |  1   |      |   B    |
    |                   |           |     |        | VERD-EBENEN |       |           | 10     | Stück    |  1   |   B  |   B    |
    |icon:folder_opened |HONGKONG   | L2  |        | VERD-EBENEN | 200   | Stück     |        |          |      |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 100    | m        |  1   |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 100    | Stück    |  1   |      |        |
    |icon:folder_opened |BERLIN     | L3  |        | VERD-EBENEN | 300   | Stück     |        |          |      |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 100    | m        |  1   |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 100    | Stück    |  1   |      |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 50     | Stück    |  1   |   A  |        |
    |                   |           |     |        | VERD-EBENEN |       |           | 50     | Stück    |  1   |   B  |        |

And I close the current editor
#Platzmenge von F1 in Karlsruhe
Given I open the infosystem "BESTAND"
And I set field "artikel" to "VERD-EBENEN"
And I set field "klplatz" to "F1"
And I set field "verdichten" to "ja"
Then field "details" has value "ja"
And I press start
Then the table has 7 rows
Then table has values
    |taufzu             |lgruppe    |lager|lplatz  |tartikel     | lemge | leinheit  | gebmge | geinheit | gebf | verw | exnum  |
    |icon:folder_opened |KARLSRUHE  | L1  |   F1   | VERD-EBENEN | 100   | Stück     |        |          |      |      |        |
    |                   |           |     |   F1   | VERD-EBENEN |       |           | 20     | m        |  1   |      |        |
    |                   |           |     |   F1   | VERD-EBENEN |       |           | 20     | Stück    |  1   |      |        |
    |                   |           |     |   F1   | VERD-EBENEN |       |           | 20     | Stück    |  1   |      |   A    |
    |                   |           |     |   F1   | VERD-EBENEN |       |           | 10     | Stück    |  1   |   A  |   A    |
    |                   |           |     |   F1   | VERD-EBENEN |       |           | 20     | Stück    |  1   |      |   B    |
    |                   |           |     |   F1   | VERD-EBENEN |       |           | 10     | Stück    |  1   |   B  |   B    |
And I close the current editor














