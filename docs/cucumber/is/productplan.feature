@persistent
Feature: productplan.feature

Background:
And I set the fake date to "02.01.95"

# *****************************************************************************
#  Name             : productplan.feature
#  Autor            : bschiga
#  Verantwortlich   : teaminfosysteme
#  Kontrolle        : cl
#  Funktion         : Testet das Infosystem PRODUCTPLAN
#                     Planung für mindestbestandsbezogene Artikel
#  ref              : ref_la_infosys_productplan_cu
#
# *****************************************************************************

Scenario Outline: Stammdaten anlegen

Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such                  | <such>              |
    | namebspr              | <namebspr>          |
    | bsart                 | Fremdbeschaffung    |
    | dispoa                | <dispoa>            |
    | lief                  | <lief>              |
    | efrist                | <efrist>            |
    | epr                   | <epr>               |
    | mindest               | <mindest>           |
And I save the current editor

Examples: Artikel
    | such          | namebspr                         | dispoa                   | lief  | efrist | epr | mindest    |
    | EK-MINDEST    | Kaufteil mindestbestandsbezogen  | mindestbestandsbezogen   | TEST  | 50     | 10  | 1000       |
    | EK-BEDARF     | Kaufteil bedarfsbezogen          | bedarfsbezogen           | TEST  | 100    | 10  | 500        |

Scenario Outline: Stammdaten anlegen

Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such              | <such>                |
    | namebspr          | <namebspr>            |
    | dispoa            | auftragsbezogen       |
    | bsart             | Eigenfertigung        |
And I delete all rows
And I append rows
    | elex      | anzahl    | kompeig   |
    | <elex1>   | <anzahl1> |           |
    | <ag1>     | 1         |           |
    | <elex2>   | <anzahl2> | <kompeig> |
    | <ag2>     | 1         |           |
And I save the current editor

Examples:
    | such              | namebspr                  | elex1         | anzahl1   | ag1   | elex2      | anzahl2   | kompeig               | ag2      |
    | BG2-MINDEST       | Baugruppe MINDEST         | EK-MINDEST    | 2         | A AG1 | EK-BEDARF  | 1         |                       | A AG2    |
    | BG2-KOPPEL        | Baugruppe MINDEST Koppel  | EINK          | 2         | A AG1 | EK-MINDEST | 1         | Koppelprodukt         | A AG2    |

Scenario: Lagergruppeneigenschaften anlegen

Given I open an editor "EK-MINDEST" from table "(Part):(Product)" with command "UPDATE" for record "EK-MINDEST"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | bfrist    | mindest   | bsart     | dispoa                    | zuplatz    | abplatz   | umllg        |
    | BERLIN    | 40        | 200       | Umlagern  | mindestbestandsbezogen    | L3F1       | L3F1      | KARLSRUHE    |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Scenario: Artikel kalkulieren wegen bfrist

Given I open an editor "EK-MINDEST" from table "(Part):(Product)" with command "UPDATE" for record "EK-MINDEST"
And I press button "kalkul" to open a subeditor for "kalkulieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "EK-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "EK-BEDARF"
And I press button "kalkul" to open a subeditor for "kalkulieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Scenario: Bedarfe und Beschaffungen anlegen

Given I create a SalesOrder "SO1" for Customer "1" with Product "BG2-MINDEST" and quantity "50"
Given I create a SalesOrder "SO2" for Customer "1" with Product "BG2-MINDEST" and quantity "10"
Given I create a SalesOrder "SO3" for Customer "1" with Product "BG2-MINDEST" and quantity "15"
Given I create a SalesOrder "SO4" for Customer "1" with Product "EK-MINDEST" and quantity "10"

Given I create a PurchaseOrder "PO1" for Vendor "TEST" with Product "EK-MINDEST" and quantity "100"

Given I create a work order "WO1" for Product "BG2-KOPPEL" with quantity "10" and search word "FV01_"

# Bedarf andere Lagergruppe anlegen
Given I open an editor "AUF_LG_EXT" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | 1         |
    | such  | AUF_EXT   |
    | vom   | .         |
And I append rows
    | artikel       | mge   | einplan | platz    | tterm    |
    | EK-MINDEST    | 80    |  ja     | L3F1     | +15      |
    | EK-MINDEST    | 20    |  ja     | L3F1     | +30      |
And I save the current editor

# Bedarfe mit unterschiedlichen Terminen, auch welche spaeter als Betrachtungszeitraum
Given I open an editor "AUF_TERM" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | 1         |
    | such  | AUF_TERM  |
    | vom   | .         |
And I append rows
    | artikel       | mge   | einplan | tterm   |
    | BG2-MINDEST   | 20    |  ja     | +15     |
    | EK-MINDEST    | 30    |  ja     | +15     |
    | BG2-MINDEST   | 20    |  ja     | +30     |
    | EK-MINDEST    | 30    |  ja     | +30     |
    | BG2-MINDEST   | 50    |  ja     | +15     |
    | EK-MINDEST    | 5     |  ja     | +15     |
    | BG2-MINDEST   | 100   |  ja     | +30     |
    | EK-MINDEST    | 15    |  ja     | +30     |
    | BG2-MINDEST   | 50    |  ja     | +40     |
    | EK-MINDEST    | 30    |  ja     | +40     |
    | BG2-MINDEST   | 100   |  ja     | +160    |
    | EK-MINDEST    | 80    |  ja     | +160    |
And I save the current editor

Given I open an editor "BE_TERM" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | TEST       |
    | such | BEST_TERM  |
    | vom  | .          |
And I append rows
    | artikel       | mge | einplan | term  |
    | EK-MINDEST    | 50  | ja      | +30   |
    | EK-MINDEST    | 75  | ja      | +40   |
    | EK-MINDEST    | 100 | ja      | +75   |
And I save the current editor

Given I open an editor "BE_EXT" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | TEST       |
    | such | BEST_EXT   |
    | vom  | .          |
And I append rows
    | artikel       | mge | einplan | platz  | term     |
    | EK-MINDEST    | 250 | ja      | L3F1   | 15.04.95 |
And I save the current editor

And I run Scheduling


Scenario: 01 PRODUCTPLAN pruefen - Felder und Handhabung

Given I open the infosystem "PRODUCTPLAN"
# planungbis wird vorbelegt +60 Kalendertage und dann Monatsende
# wird aufgrund der Beschaffungsfrist des Artikels automatisch errechnet, 2 Mal Beschaffungsfrist und dann Monatsende
Then field "planungbis" has value "31.03.95"
And I set field "artikel" to "EK-MINDEST"
And I press start
Then fields have values
    | planungbis    | 31.05.95          |
    | lgruppe       | KARLSRUHE         |
    | mindest       | 1000              |
    | bfrist        | 50                |
    | bsart         | Fremdbeschaffung  |
    | verdtag       | ja                |
Then fields are modifiable
    | planungbis    | ja    |
    | lgruppe       | ja    |
    | mindest       | nein  |
    | bfrist        | nein  |
    | bsart         | nein  |
And I set field "verdtag" to "nein"
    ## es muss eine Verdichtungsstufe gewählt werden, Meldung kann nicht abgefragt werden, ist zwar ERROR aber gefolgt von ACK anstatt NAK
    ## es wird auf jeden Fall nichts geladen
    #Then pressing button "bstart" throws the exception "Verdichtungsstufe wählen."
And I press start
Then the table has 0 rows
And I set field "verdwoche" to "ja"
And I press start
Then the table has more than 0 rows
# bei Aendern der Lagergruppe wird planungbis direkt neu berechnet
And I set field "lgruppe" to "BERLIN"
Then field "planungbis" has value "30.04.95"
And I close the current editor


Scenario: 02 PRODUCTPLAN prüfen - Artikel EK-MINDEST und Lagergruppe BERLIN

# Umlagerungsvorschlag oeffnen, um die ID zu speichern
Given I open an editor "UML_INT_EXT" from table "(Purchasing):(RelocationSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-MINDEST"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | ablgruppe | lgruppe   | mge   | fix   |
    | KARLSRUHE | BERLIN    | 200   | nein  |
And I save value from field "id" in row 1
And I close the current editor

# Bestellung oeffnen um Zugriff auf die ID zu haben
Given I open an editor "BEST_EXT" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BEST_EXT"
#Then table has values
#    | artikel       | mge | platz  |
#    | EK-MINDEST    | 250 | L3F1   |
And I close the current editor

Given I open the infosystem "PRODUCTPLAN"
And I set field "artikel" to "EK-MINDEST"
And I set field "lgruppe" to "BERLIN"
And I press start
# Mindestbestand und Beschaffungsfrist aus den Lagergruppeneigenschaften wird angezeigt
Then fields have values
    | planungbis    | 30.04.95  |
    | lgruppe       | BERLIN    |
    | mindest       | 200       |
    | bfrist        | 40        |
    | bsart         | Umlagern  |
    | verdtag       | ja        |
Then the table has 5 rows
# Bestand, Zu- und Abgänge nur aus dieser Lagergruppe
Then table has values
    | typ                   | anfzeitraum   | endzeitraum   | tterm     | abgang    | zugang    | verfuegbar    | beschaffung       |
    | icon:cubes_blue       |               |               |           |           |           | 0             | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 26.12.94  |           | 200       | 200           |                   |
    | icon:arrow_blue_down  |  17.01.95     | 17.01.95      |           | 80        |           | 120           | icon:alarmclock   |
    | icon:arrow_blue_down  |  01.02.95     | 01.02.95      |           | 20        |           | 100           | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 15.04.95  |           | 250       | 350           |                   |
# Feld vorgang enthaelt die ID des Umlagerungsvorschlags
Then field "vorgang" in row 2 equals saved value
#Then field "vorgang" in row 5 has value equal to field "id" from editor "BEST_EXT" in row 1
And I close the current editor

Given I post a receipt via ManualStockAdjustment "LBU_INT" for Product "EK-MINDEST" and quantity "50" on StorageLocation "F1" with document "LBUINT01"
# Lagerplatz F4 ist nicht disporelevant, dieser Bestand wird im Infosystem PRODUCTPLAN nicht beruecksichtigt
Given I post a receipt via ManualStockAdjustment "LBU_INTF4" for Product "EK-MINDEST" and quantity "444" on StorageLocation "F4" with document "LBUINTF4"
# Zugang auf externen Lagerplatz
Given I post a receipt via ManualStockAdjustment "LBU_EXT" for Product "EK-MINDEST" and quantity "20" on StorageLocation "L3F1" with document "LBUEXT01"

Given I open the infosystem "PRODUCTPLAN"
And I set field "artikel" to "EK-MINDEST"
And I set field "lgruppe" to "BERLIN"
And I press start
Then table has values
    | typ                   | anfzeitraum   | endzeitraum   | tterm     | abgang    | zugang    | verfuegbar    | beschaffung       |
    | icon:cubes_blue       |               |               |           |           |           | 20            | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 26.12.94  |           | 200       | 220           |                   |
    | icon:arrow_blue_down  | 17.01.95      | 17.01.95      |           | 80        |           | 140           | icon:alarmclock   |
    | icon:arrow_blue_down  | 01.02.95      | 01.02.95      |           | 20        |           | 120           | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 15.04.95  |           | 250       | 370           |                   |
And I close the current editor

# bfrist aendern in den Lagergruppeneigenschaften, um die Berechnung des Termins planungbis zu testen
Given I open an editor "EK-MINDEST" from table "(Part):(Product)" with command "UPDATE" for record "EK-MINDEST"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I set field "bfrist" to "5" in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# wenn bfrist kuerzer ist, dann ist planungbis +60 und dann Monatsende
Given I open the infosystem "PRODUCTPLAN"
And I set field "artikel" to "EK-MINDEST"
And I set field "lgruppe" to "BERLIN"
And I press start
Then fields have values
    | planungbis    | 31.03.95  |
    | lgruppe       | BERLIN    |
    | mindest       | 200       |
    | bfrist        | 5         |
    | bsart         | Umlagern  |
    | verdtag       | ja        |
Then the table has 4 rows
And I close the current editor


Scenario: 03 PRODUCTPLAN prüfen - Artikel EK-MINDEST und Lagergruppe KARLSRUHE

Given I open the infosystem "PRODUCTPLAN"
And I set field "artikel" to "EK-MINDEST"
And I set field "lgruppe" to "KARLSRUHE"
And I press start
Then fields have values
    | planungbis    | 31.05.95          |
    | lgruppe       | KARLSRUHE         |
    | mindest       | 1000              |
    | bfrist        | 50                |
    | bsart         | Fremdbeschaffung  |
    | verdtag       | ja                |
Then the table has 15 rows
Then table has values
    | typ                   | anfzeitraum   | endzeitraum   | tterm     | abgang    | zugang    | verfuegbar    | beschaffung       |
    | icon:cubes_blue       |               |               |           |           |           | 50            | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 30.12.94  |           | 10        | 60            | icon:alarmclock   |
    | icon:arrow_blue_down  |               | 02.01.95      |           | 210       |           | -150          | icon:alarmclock   |
    | icon:arrow_blue_down  | 17.01.95      | 17.01.95      |           |  35       |           | -185          | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 01.02.95  |           | 50        | -135          | icon:alarmclock   |
    | icon:arrow_blue_down  | 01.02.95      | 01.02.95      |           |  45       |           | -180          | icon:alarmclock   |
    | icon:arrow_blue_down  | 10.02.95      | 10.02.95      |           |  30       |           | -210          | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 11.02.95  |           |  75       | -135          | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 07.03.95  |           | 875       | 740           | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 14.03.95  |           | 100       | 840           | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 18.03.95  |           | 100       | 940           | icon:alarmclock   |
    | icon:arrow_blue_down  | 11.05.95      | 11.05.95      |           | 200       |           | 740           | icon:alarmclock   |
    | icon:arrow_blue_down  | 16.05.95      | 16.05.95      |           | 300       |           | 440           | icon:alarmclock   |
    | icon:arrow_blue_down  | 17.05.95      | 17.05.95      |           | 280       |           | 160           | icon:alarmclock   |
    | icon:arrow_blue_down  | 18.05.95      | 18.05.95      |           |  50       |           | 110           | icon:alarmclock   |
And I set field "verdwoche" to "ja"
And I press start
Then the table has 13 rows
Then table has values
    | typ                   | anfzeitraum   | endzeitraum   | tterm     | abgang    | zugang    | verfuegbar    | beschaffung       |
    | icon:cubes_blue       |               |               |           |           |           | 50            | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 30.12.94  |           | 10        | 60            | icon:alarmclock   |
    | icon:arrow_blue_down  |               | 08.01.95      |           | 210       |           | -150          | icon:alarmclock   |
    | icon:arrow_blue_down  | 16.01.95      | 22.01.95      |           |  35       |           | -185          | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 01.02.95  |           | 50        | -135          | icon:alarmclock   |
    | icon:arrow_blue_down  | 30.01.95      | 05.02.95      |           |  45       |           | -180          | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 11.02.95  |           | 75        | -105          | icon:alarmclock   |
    | icon:arrow_blue_down  | 06.02.95      | 12.02.95      |           |  30       |           | -135          | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 07.03.95  |           | 875       | 740           | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 14.03.95  |           | 100       | 840           | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 18.03.95  |           | 100       | 940           | icon:alarmclock   |
    | icon:arrow_blue_down  | 08.05.95      | 14.05.95      |           | 200       |           | 740           | icon:alarmclock   |
    | icon:arrow_blue_down  | 15.05.95      | 21.05.95      |           | 630       |           | 110           | icon:alarmclock   |
And I close the current editor

# Bestellvorschlag anlegen, wird ebenfalls als Zugang angezeigt
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel    | mge  | wtterm    |
    | EK-MINDEST | 1000 | 07.03.95  |
And I save the current editor

Given I open an editor "PO1" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "PO1"
And I save value from field "id" in row 1
And I close the current editor

# aus einer der Bestellungen einen Teillieferschein erstellen, der aber nicht gebucht wird, es bleibt die Bestellung als Zugang im Infosystem
Given I open an editor "PO1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "PO1"
And I set fields
    | such   | LS1_P01  |
    | ebeleg | LS1_P01  |
    | vom    | .        |
    | ueb    | nein     |
And I set field "mge" to "30" in row 1
And I save the current editor

    # Verdichtung auf Monat
Given I open the infosystem "PRODUCTPLAN"
And I set fields
    | artikel       | EK-MINDEST    |
    | lgruppe       | KARLSRUHE     |
    | verdmonat     | ja            |
And I press start
Then the table has 11 rows
Then table has values
    | typ                   | anfzeitraum   | endzeitraum   | tterm     | abgang    | zugang    | verfuegbar    | beschaffung       |
    | icon:cubes_blue       |               |               |           |           |           | 50            | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 30.12.94  |           | 10        | 60            | icon:alarmclock   |
    | icon:arrow_blue_down  |               | 31.01.95      |           | 245       |           | -185          | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 01.02.95  |           | 50        | -135          | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 11.02.95  |           | 75        | -60           | icon:alarmclock   |
    | icon:arrow_blue_down  | 01.02.95      | 28.02.95      |           |  75       |           | -135          | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 07.03.95  |           | 875       | 740           | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 07.03.95  |           | 1000      | 1740          |                   |
    | icon:arrow_blue_up    |               |               | 14.03.95  |           | 100       | 1840          |                   |
    | icon:arrow_blue_up    |               |               | 18.03.95  |           | 100       | 1940          |                   |
    | icon:arrow_blue_down  | 01.05.95      | 31.05.95      |           | 830       |           | 1110          |                   |
Then field "vorgang" in row 9 equals saved value
And I close the current editor

# aus einer der Bestellungen einen Teillieferschein erstellen, der aber gebucht wird, Restmenge der Bestellung bleibt als Zugang im Infosystem
Given I open an editor "PO1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "PO1"
And I set fields
    | such   | LS2_P01  |
    | ebeleg | LS2_P01  |
    | vom    | .        |
    | ueb    | ja       |
And I set field "mge" to "50" in row 1
And I save the current editor

# Zeitraum erweitern und Bestellung hat noch Restmenge in Zeile 9
# Zeitraum planungbis wird nach Eingabe von Artikel und Lagergruppe berechnet, kann dann manuell beliebig ueberschrieben werden
Given I open the infosystem "PRODUCTPLAN"
And I set fields
    | artikel       | EK-MINDEST    |
    | lgruppe       | KARLSRUHE     |
    | planungbis    | 30.06.95      |
    | verdmonat     | ja            |
And I press start
Then the table has 12 rows
Then table has values
    | typ                   | anfzeitraum   | endzeitraum   | tterm     | abgang    | zugang    | verfuegbar    | beschaffung       |
    | icon:cubes_blue       |               |               |           |           |           | 100           | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 30.12.94  |           | 10        | 110           | icon:alarmclock   |
    | icon:arrow_blue_down  |               | 31.01.95      |           | 245       |           | -135          | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 01.02.95  |           | 50        | -85           | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 11.02.95  |           | 75        | -10           | icon:alarmclock   |
    | icon:arrow_blue_down  | 01.02.95      | 28.02.95      |           |  75       |           | -85           | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 07.03.95  |           | 875       | 790           | icon:alarmclock   |
    | icon:arrow_blue_up    |               |               | 07.03.95  |           | 1000      | 1790          |                   |
    | icon:arrow_blue_up    |               |               | 14.03.95  |           |  50       | 1840          |                   |
    | icon:arrow_blue_up    |               |               | 18.03.95  |           | 100       | 1940          |                   |
    | icon:arrow_blue_down  | 01.05.95      | 31.05.95      |           | 830       |           | 1110          |                   |
    | icon:arrow_blue_down  | 01.06.95      | 30.06.95      |           |  80       |           | 1030          |                   |
Then field "vorgang" in row 9 equals saved value
And I close the current editor
