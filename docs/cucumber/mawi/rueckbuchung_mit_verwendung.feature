# *****************************************************************************
#  Name             : rueckbuchung_mit_verwendung.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Rueckbuchung mit scharfer, unscharfer Verwednung und Jokerbestand
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_mit_verwendung.feature
Background:
Given I set the fake date to "02.01.1995"
Given I enable the flag 39

Scenario: 000 MKV einschalten 
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "bew" to "ja"
# 2539 : ACHTUNG Langläufer: Stammdaten werden geprüft - o.k.?
And I respond with answer "ja" to the dialog with id "2539"
# 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
And I respond with answer "ja" to the dialog with id "2540"
And I save the current editor


# Vorbereitung: Stammdaten fuer Test anlegen
Scenario Outline: 00 Stamdaten anlegen - Lieferant und Kunde
Given I open an editor "<such>" from table "<table>" with command "STORE" for record "<such>"
And I set fields
    | such     | <such>     |
    | namebspr | <namebspr> |
    | ans      | <ans>      |
    | str      | <str>      |
    | plz      | <plz>      |
    | nort     | <nort>     |
    | zbed     | 201        |
And I save the current editor

Examples:
| table                 | such    | namebspr               | ans             | str             | plz   | nort     |
| (Vendor):(Vendor)     | KETTLER | Kettler Fahrrad        | Kettler Fahrrad | Industreistr. 3 | 12345 | Neustadt |
| (Customer):(Customer) | RADSHOP | Radshop Maier, Rastatt | Radshop Maier   | Riedstr. 24     | 76137 | Rastatt  |

Scenario Outline: 00 Stamdaten anlegen - Artikel, Komponenten
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such      | <such>      |
    | namebspr  | <namebspr>  |
    | dispoa    | <dispoa>    |
    | lief      | KETTLER     |
    | efrist    | 2           |
    | epr       | 25          |
    | zuplatz   | <zuplatz>   |
And I save the current editor

Examples:
| such      | namebspr       | zuplatz     | dispoa          |
| EINKAUF-1 | Einkaufsteil 1 | !dontChange | auftragsbezogen |
| EINKAUF-2 | Einkaufsteil 2 | !dontChange | auftragsbezogen |


Scenario Outline: 00 Stamdaten anlegen - Arbeitsgang
Given I open an editor "<such>" from table "(Operation):(Operation)" with command "STORE" for record "<such>"
And I set fields
    | such       | <such>       |
    | namebspr   | <namebspr>   |
    | mgr        | 112          |
    | lgr        | <lgr>        |
    | lgrruesten | <lgrruesten> |
    | aschein    | ja           |
    | tr         | <tr>         |
    | te         | <te>         |
    | skostfix   | 10           |
    | skostvar   | 20           |
And I save the current editor

Examples:
| such      | namebspr  | lgr | lgrruesten | tr | te |
| SCHRAUBEN | Schrauben | 1   | 2          | 5  | 10 |


Scenario: 00 Stamdaten anlegen - Baugruppe, 1 AG
Given I open an editor "Baugruppe" from table "(Part):(Product)" with command "STORE" for record "BAUGRUPPE"
And I set fields
    | such      | BAUGRUPPE          |
    | namebspr  | Einfache Baugruppe |
    | dispoa    | auftragsbezogen    |
    | bsart     | Eigenfertigung     |
    | chverfolgung |                 |
And I delete all rows
And I append rows
    | elex        | anzahl | manbu |
    | EINKAUF-1   | 2      | nein  |
    | EINKAUF-2   | 1      | nein  |
    | A SCHRAUBEN | 1      |       |
And I save the current editor


Scenario: 01 Buchen mit unterschiedlichen Verwendungen - Autrag anlegen
# Auftrag anlegen
Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP |
And I append rows
    | artikel   | mge     | verw   |
    | BAUGRUPPE | 60      | 1111_1 |
And I save the current editor

# Dispolauf
And I run Scheduling

# Teil der Bedarfe einkaufen (Verwendung)
Scenario: 02a Bauteile einkaufen - mit scharfer Verwendung
Given I open an editor "RechnungmL" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER |
    | vom       | .       |
    | fakt      | ja      |
    | ebeleg    | 01R     |
    | ueb       | ja      |
    | budat     | 2.1.95  |
And I append rows
    | artikel   | mge     |
    | EINKAUF-1 | 60      |
    | EINKAUF-2 | 30      |
And I set field "verw" in row 1 to "verw" from editor "Auftrag" in row 1
And I set field "verw" in row 2 to "verw" from editor "Auftrag" in row 1
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

Scenario Outline: 02b Lagerbestand mit unscharfer Verwendung und Joker zubuchen
Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | <artikel> |
    | beleg   | R01       |
    | buart   | Zugang    |
    | beldat  | .         |
And I delete all rows
And I append rows
    | mge      | verw    |
    | <mge1>   | <verw1> |
    | <mge2>   |         |
And I save the current editor

And I run Scheduling

Examples:
    | artikel   | mge1 | verw1 | mge2 |
    | EINKAUF-1 | 40   | 1111  | 20   |
    | EINKAUF-2 | 20   | 1111  | 10   |

Scenario: 03a Fertigungsvorschlag fuer Baugruppe freigeben
# Fertigungsvorschlag freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
    | artikel | BAUGRUPPE |
And I press button "ladetab"
And I modify table
    | !row                      | bisuch | mfreig |
    | mfreig=='nein' && mge==60 | JOKER_ | ja     |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Rueckmeldung auf ersten Arbeitsgang
Scenario: 03b Rueckmeldung auf ersten Arbeitsgang - Scharfe und unscharfe Verwendung, Jokerbestand
Given I open an editor "Rueckmeldung01" from table "(Workorder):(WorkOrders)" with command "DONE" for record "JOKER_001"
And I set fields
    | sofort | ja |
And I set field "gutmge" to "55" in row 1
And I save the current editor

# Rueckbau zu Betriebsauftrag
Scenario: 03c Rueckbau der Rueckmeldung - Material wird mit wie in 3b zurueckgelegt
Given I open an editor "Rueckbau01" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "JOKER_001"
And I set field "mgr" to "101"
And I set field "sofort" to "ja"
And I set field "gutmge" to "-55" in row 1
And I save the current editor

# Lagerbewegungsjournal zu 3b und 3c pruefen
# Storno muss gleiche Buchungen zum Orignalbeleg erzeugen, nur mit negativer Menge
Given I open the infosystem "LJ"
And I set fields
    | adatum    | .           |
    | richtung  | rückwärts |
And I set field "beleg" to "barmex" from editor "Rueckmeldung01"
And I press start
Then table has values
    | art       | zmge | amge | rueckmge | restmge | verw   | verwla  |
    | BAUGRUPPE | -55  |      | -55      | 0       | 1111_1 | 1111_1  |
    | EINKAUF-1 |      | -60  | -60      | 0       | 1111_1 | 1111_1  |
    | EINKAUF-1 |      | -40  | -40      | 0       | 1111_1 | 1111    |
    | EINKAUF-1 |      | -10  | -10      | 0       | 1111_1 |         |
    | EINKAUF-2 |      | -30  | -30      | 0       | 1111_1 | 1111_1  |
    | EINKAUF-2 |      | -20  | -20      | 0       | 1111_1 | 1111    |
    | EINKAUF-2 |      | -5   | -5       | 0       | 1111_1 |         |
    | BAUGRUPPE | 55   |      | 55       | 0       | 1111_1 | 1111_1  |
    | EINKAUF-1 |      | 10   | 10       | 0       | 1111_1 |         |
    | EINKAUF-1 |      | 40   | 40       | 0       | 1111_1 | 1111    |
    | EINKAUF-1 |      | 60   | 60       | 0       | 1111_1 | 1111_1  |
    | EINKAUF-2 |      | 5    | 5        | 0       | 1111_1 |         |
    | EINKAUF-2 |      | 20   | 20       | 0       | 1111_1 | 1111    |
    | EINKAUF-2 |      | 30   | 30       | 0       | 1111_1 | 1111_1  |
And I close the current editor

# Lagerjournal pruefen
Given I open an editor "LJ_Baugruppe1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;mge=-55;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
    | rueckmge | -55     |
    | restmge  | 0       |
Then field "rueckorig" is not empty
Then field "vorgang^id" has value equal to field "id" from editor "Rueckbau01"
And I close the current editor

And I open an editor "LJ_Baugruppe_Orig" via ID from editor "LJ_Baugruppe1" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
Then fields have values
    | mge       | 55 |
    | rueckmge  | 55 |
    | restmge   | 0  |
Then field "vorgang^id" has value equal to field "id" from editor "Rueckmeldung01"
And I close the current editor

Scenario: 04 Betriebsauftrag abschliessen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "JOKER_000"
And I set fields
	| gut		| ja	|
	| sofort	| ja	|
	| mgr		| 112	|
And I save the current editor


Scenario: 05 Umbuchen eines Teils Gutmenge auf unscharfe Verwendung und Jokerbestand
Given I open an editor "Lagerbuchung05" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | BAUGRUPPE |
    | beleg   | UM05      |
    | buart   | Umbuchung |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | verw   | verw2 |
    | F1    | F1     | 20  | 1111_1 | 1111  |
    | F1    | F1     | 10  | 1111_1 |       |
And I save the current editor

And I run Scheduling

# Lagerbewegungsjournal pruefen
Given I open the infosystem "LJ"
And I set fields
    | adatum    | .         |
    | beleg     | UM05      |
And I press start
Then table has values
    | art       | zmge | amge | verw   |
    | BAUGRUPPE |      | 20   | 1111_1 |
    | BAUGRUPPE | 20   |      | 1111   |
    | BAUGRUPPE |      | 10   | 1111_1 |
    | BAUGRUPPE | 10   |      |        |
And I close the current editor

Scenario: 06 Auftrag ausliefern - Abgang mit scharfer und unscharfer Verwendung, Jokerbestand
Given I open an editor "Lieferschein" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag"
And I set field "ueb" to "ja"
And I set field "mge" to "55" in row 1
And I save the current editor

# Lagerbewegungsjournal pruefen
Given I open the infosystem "LJ"
And I set fields
    | adatum    | . |
And I set field "beleg" to "nummer" from editor "Lieferschein"
And I press start
Then table has values
    | art       | amge | verw   | verwla |
    | BAUGRUPPE | 30   | 1111_1 | 1111_1 |
    | BAUGRUPPE | 20   | 1111_1 | 1111   |
    | BAUGRUPPE | 5    | 1111_1 |        |
And I close the current editor


Scenario: 07 Lieferschein wieder rueckliefern - Buchung aus 06 wird zurueckgedreht
Given I open an editor "RueckLS" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Lieferschein"
And I set field "mge" to "-55" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Lagerbewegungsjournal pruefen
Given I open the infosystem "LJ"
And I set fields
    | adatum    | .           |
    | richtung  | rückwärts |
And I set field "beleg" to "nummer" from editor "RueckLS"
And I press start
Then table has values
    | art       | amge  | verw   | verwla |
    | BAUGRUPPE | -30   | 1111_1 | 1111_1 |
    | BAUGRUPPE | -20   | 1111_1 | 1111   |
    | BAUGRUPPE | -5    | 1111_1 |        |
And I close the current editor
