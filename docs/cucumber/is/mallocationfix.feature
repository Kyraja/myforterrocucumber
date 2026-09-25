@persistent
Feature: Infosystem MALLOCATIONFIX - Fixierte Materialzuordnungen
Scenario Outline: Einkaufsartikel
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such      | <such>        |
    | namebspr  | <namebspr>    |
    | dispoa    | <dispoa>      |
    | efrist    | 2             |
    | epr       | <epr>         |
    | zuplatz   | <zuplatz>     |
    | chpflicht | <chpflicht>   |
    | wgruppe   | 56            |
    | erlgrp    | 66            |
    | le        | <le>          |
And I save the current editor
Examples: 
| such       | namebspr                    | epr   | zuplatz       | chpflicht   | dispoa            |  le         |
| KOMP-1     | Komponente 1                | 4,50  | !dontChange   | nein        | bedarfsbezogen    | !dontChange | 
| KOMP-2     | Komponente 2                | 6     | !dontChange   | nein        | bedarfsbezogen    | !dontChange |
| KOMP-3     | Komponente 3                | 5,30  | !dontChange   | nein        | bedarfsbezogen    | !dontChange |

Scenario Outline: Maschinengruppen
Given I open an editor "<such>" from table "(Capacity):(WorkCenter)" with command "STORE" for record "<such>"
And I set fields
    | such       | <such>        |
    | namebspr   | <namebspr>    |
    | abtlg      | 1             |
    | kstelle    | 101           |
And I save the current editor
Examples:
| such      | namebspr           | 
| MGR1      | Maschinengruppe 1  | 
| MGR2      | Maschinengruppe 2  | 
| MGR3      | Maschinengruppe 3  | 

Scenario Outline: Arbeitsgänge
Given I open an editor "<such>" from table "(Operation):(Operation)" with command "STORE" for record "<such>"
And I set fields
    | such      | <such>        |
    | namebspr  | <namebspr>    |
    | mgr       | <mgr>         |
    | lgr       | <lgr>         |
    | lgrruesten| <lgrruesten>  |
    | aschein   | ja            |
    | tr        | <tr>          |
    | te        | <te>          |
    | skostfix  | 10            |
    | skostvar  | 20            |
And I save the current editor
Examples:
| such          | namebspr           |mgr | lgr   | lgrruesten    | tr    | te |
| AG-MGR1       | Arbeitsgang MGR1   |MGR1| 1     | 2             | 5     | 10 |
| AG-MGR2       | Arbeitsgang MGR2   |MGR2| 1     | 2             | 15    | 6  | 
| AG-MGR3       | Arbeitsgang MGR3   |MGR3| 1     | 2             | 0     | 20 | 

Scenario Outline: Baugruppen, 3 AG
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such              | <such>                |
    | namebspr          | <namebspr>            |
    | dispoa            | auftragsbezogen       |
    | bsart             | Eigenfertigung        |
    | gemein            | GK2.14.3              |
    | chpflicht         | nein                  |
    | flbasis           | <flbasis>             |
    | wgruppe           | 56                    |
    | erlgrp            | 66                    |
And I delete all rows
And I append rows
    | elex      | anzahl    | kompeig   | manbu     | nutzen    | pverlust      |
    | <elex1>   | <anzahl1> |           | <manbu>   | <nutzen>  |               |
    | <ag1>     | 1         |           |           |           | <pverlust>    |
    | <elex2>   | <anzahl2> | <kompeig> |           |           |               |
    | <ag2>     | 1         |           |           |           |               |
    | <elex3>   | <anzahl3> |           |           |           |               |
    | <ag3>     | 1         |           |           |           |               |
And I save the current editor
Examples:
| such              | namebspr                  | flbasis   | elex1     | anzahl1   | manbu | nutzen    | ag1           | elex2         | anzahl2   | kompeig               | ag2               | pverlust  | elex3     | anzahl3   | ag3           |
| BG3-FIX           | Baugruppe fixiert         |           | KOMP-1    | 1         |       |           | A AG-MGR1     | KOMP-2        | 1         |                       | A AG-MGR2         |           | KOMP-3    | 1         | A AG-MGR3     |

Scenario: 01 Fixierte Lagerbestand für KOMP-2
# manuelle Lagerzugänge für den Artikel KOMP-2
Given I open an editor "manLagerzugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
And I set fields
      | artikel     | KOMP-2   |
      | beleg       | ZUG      |
      | beldat      | .        |
      | buart       | Zugang   |
And I modify table
      | !row  | mge   | platz2 | 
      | +1    | 500   | F1     | 
And I save the current editor
# FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_FIX" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |fixlbestand|
    | BG3-FIX        | 100        | FIX1_     | ja        | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FIX"
And I save the current editor
# Dispo  starten
And I run Scheduling
# Infosystem PLANKARTE hat 2 Zeilen
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "KOMP-2"
And I press start
Then the table has 2 rows
Then table has values
   |fixmz    | zugang | abgang | art     |  vart          | vkopf^such|
   |icon:view| 500    |        |         | Lager          |           |
   |         |        | 100    | BG3-FIX | Eigenfertigung | FIX1_000  | 
And I close the current editor   

# Infosystem MALLOVATIONFIX hat eine Zeile für den fixierten Lagerbestand
Given I open the infosystem "MALLOCATIONFIX"
And I set field "artikel" to "KOMP-2"
And I set field "lgruppe" to "KARLSRUHE"
And I press start
Then the table has 1 rows
Then table has values
    | tvorgang^such     | tvart          | tmge           |teinheit | tbis  | tverwend   |tlffert |
    | FIX1_000          |Eigenfertigung  | 100            | Stück   |       |            |        |
And I close the current editor

