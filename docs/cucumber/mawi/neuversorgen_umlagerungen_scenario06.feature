# *****************************************************************************
#  Name             : neuversorgen_umlagerungen_scenario06.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Neuversorgung von umgelagerten Bestaenden
#                     nach bei neuem Zugang
#
# Test zu Scenario aus BW2-1083
#
# *****************************************************************************
@persistent
Feature: neuversorgen_umlagerungen_scenario06.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: Bestaende fuer Bauteile auf 0 setzen, Fertigteil kopieren
And I set StorageQuantity to zero for Product "RAHMEN" on StorageLocation "MLF01" with document "Scenario6"
And I set StorageQuantity to zero for Product "RAD" on StorageLocation "MLF01" with document "Scenario6"
And I set StorageQuantity to zero for Product "SATTEL" on StorageLocation "MLF01" with document "Scenario6"
And I set StorageQuantity to zero for Product "PEDALE" on StorageLocation "MLF01" with document "Scenario6"

# Fertigteil FAHRRAD kopieren
Given I open an editor "Fahrrad" from table "(Part):(Product)" with command "COPY" for record "FAHRRAD"
And I set field "such" to "FAHRRAD-06"
And I save the current editor

Scenario: Verkaufsauftag fuer Fahrrad anlegen und Bedarfe einkaufen
Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I append rows
| artikel    | mge | platz |
| FAHRRAD-06 | 10  | MLF01 |
| FAHRRAD-06 | 10  | ABLA  |
| FAHRRAD-06 | 10  | ZLQM  |
And I save the current editor

# Bedarfe einkaufen
Given I open an editor "Rechnung1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | PUKY      |
    | vom    | .         |
    | ebeleg | Scenario6 |
    | ueb    | ja        |
    | fakt   | ja        |
And I append rows
| artikel | mge | he     |
| RAHMEN  | 50  | kg     |
| RAD     | 10  | Paar   |
| SATTEL  | 10  | Stück |
| PEDALE  | 10  | Paar   |

And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario Outline: Bestaende fuer Bauteile pruefen
Given I open the infosystem "BESTAND"
And I set fields
    | artikel 		| <artikel> |
    | klplatz 		| MLF01     |
	| verdichten 	| nein		|
	| details       | nein      |
And I press start
And I press button "taufzu" in row 1

Then field "gebmge" has value "<gmenge>" in row 2
Then field "geinheit" has value "<geinheit>" in row 2
#Then field "lemge" has value "<lmenge>" in row 1
#Then field "leinheit" has value "<leinheit>" in row 1
Then field "kopfzugvorg^id" in row 2 has value equal to field "id" from editor "Rechnung1" in row 0
And I close the current editor

Examples:
| artikel | lmenge | leinheit | gmenge | geinheit |
| RAHMEN  | 10     | Stück   | 50     | kg       |
| RAD     | 20     | Stück   | 20     | Stück   |
| SATTEL  | 10     | Stück   | 10     | Stück   |
| PEDALE  | 20     | Stück   | 10     | Paar     |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: Fahrrad fertigen (10 Stueck - Zugang)
# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel    | netmge | bisuch | mfreig |
    | FAHRRAD-06 | 10     | RAD06_ | ja     |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Rueckmeldung auf Betriebsauftrag
Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RAD06_000"
And I set field "mgr" to "101"
And I set field "sofort" to "1"
And I set field "gutmge" to "10" in row 1
And I set field "erbtext1" to "Rueckmeldung1" in row 1
And I save the current editor

# Journaleintrag pruefen
Given I open StockMovementJournal "Journal1" for Product "FAHRRAD-06" and cause of entry "Rückmeldung Fertigung" and transaction "Rueckmeldung1" with command "VIEW"
Then field "buarta" has value "Zugang"
Then field "mge" has value "10"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "FAHRRAD-06" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | lj^id        | orig^id      | bewmge | bewlj^id     | beworig^id   |
    | 10     | !Journal1^id | !Journal1^id | 10     | !Journal1^id | !Journal1^id |
And I close the current editor

# Bewertung pruefen
Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=FAHRRAD-06;detursache=Rückmeldung Fertigung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsref^id" has value equal to field "id" from editor "Journal1"
Then field "tmge" has value "10" in row 1
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: Artikel ausliefern - mehrere Abgaenge
Given I open an editor "VKLieferschein" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag"
And I set field "ueb" to "ja"
And I modify table
    | !row | mge |
    | 1    | 5   |
    | 2    | 3   |
    | 3    | 7   |
And I save the current editor

# Journaleintraege fuer Abgaenge pruefen
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-06;detursache==Lieferschein Verkauf;platz==MLF01"
Then field "buarta" has value "Abgang"
Then field "mge" has value "5"
Then table has values
    | !row | mge | orig^id      | bewmge | beworig^id   |
    | 1    | 5   | !Journal1^id | 5      | !Journal1^id |
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-06;detursache==Lieferschein Verkauf;platz==ABLA"
Then field "buarta" has value "Abgang"
Then field "mge" has value "3"
Then the table has 0 rows
And I close the current editor

Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-06;detursache==Lieferschein Verkauf;platz==ZLQM"
Then field "buarta" has value "Abgang"
Then field "mge" has value "7"
Then the table has 0 rows
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "FAHRRAD-06" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | lj^id        | orig^id      | bewmge | bewlj^id     | beworig^id   |
    | 5      | !Journal1^id | !Journal1^id | 5      | !Journal1^id | !Journal1^id |
And I close the current editor

Given I query StorageQuantity for Product "FAHRRAD-06" on StorageLocation "ABLA"
Then StorageQuantities have values
    | gebmge | lj^id          | orig^id | bewmge | bewlj^id       | beworig^id |
    | -3     | !JournalAb2^id | (0,0,0) | -3     | !JournalAb2^id | (0,0,0)    |
And I close the current editor

Given I query StorageQuantity for Product "FAHRRAD-06" on StorageLocation "ZLQM"
Then StorageQuantities have values
    | gebmge | lj^id          | orig^id | bewmge | bewlj^id       | beworig^id |
    | -7     | !JournalAb3^id | (0,0,0) | -7     | !JournalAb3^id | (0,0,0)    |
And I close the current editor

# Bewertung pruefen
Given I open an editor "BewertungAb1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==FAHRRAD-06;detursache==Lieferschein Verkauf;mge==5;@ablageart=lebendig;"
Then field "ppsref^id" has value equal to field "id" from editor "JournalAb1"
Then field "tmge" has value "5" in row 1
Then field "beworig^id" in row 1 has value equal to field "id" from editor "Journal1" in row 0
And I close the current editor

Given I open an editor "BewertungAb2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==FAHRRAD-06;detursache==Lieferschein Verkauf;mge==3;@ablageart=lebendig;"
Then field "ppsref^id" has value equal to field "id" from editor "JournalAb2"
Then field "tmge" has value "3" in row 1
Then field "beworig" is empty in row 1
And I close the current editor

Given I open an editor "BewertungAb3" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==FAHRRAD-06;detursache==Lieferschein Verkauf;mge==7;@ablageart=lebendig;"
Then field "ppsref^id" has value equal to field "id" from editor "JournalAb3"
Then field "tmge" has value "7" in row 1
Then field "beworig" is empty in row 1
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: Erste Umlagerung
And I transfer StorageQuantity of "10" for Product "FAHRRAD-06" from StorageLocation "MLF01" to "ABLA" with document "Umlagern6-1"

# Zugangsjournal der Umlagerung
Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-06;detursache==Manuelle Umbuchung;buarta==Zugang;mge==10"
Then field "buarta" has value "Zugang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "platz" has value "ABLA"
Then field "lj" is not empty
Then field "mge" has value "10"
And I close the current editor

# Abgangsjournal der Umlagerung
Given I open an editor "JournalUmAb1" via ID from editor "JournalUmZu1" from field "lj" in row 0 for table "(Journal):(Journal)" with command "VIEW"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "platz" has value "MLF01"
Then field "mge" has value "10"
Then table has values
    | !row | mge | lj^id        | orig^id      | bewmge | bewlj^id     | beworig^id   |
    | 1    | 5   | !Journal1^id | !Journal1^id | 5      | !Journal1^id | !Journal1^id |
And I close the current editor

# Journaleintrag zu Abgang 2
Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalAb2"
Then field "buarta" has value "Abgang"
Then field "mge" has value "3"
Then table has values
    | !row | mge | orig^id      | lj^id            | bewmge | beworig^id   | bewlj^id         |
    | 1    | 3   | !Journal1^id | !JournalUmZu1^id | 3      | !Journal1^id | !JournalUmZu1^id |
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "FAHRRAD-06" on StorageLocation "MLF01"
Then StorageQuantities have values
    | !row | gebmge | orig^id | lj^id            | bewmge | beworig^id | bewlj^id         |
    | 1    | -5     | (0,0,0) | !JournalUmAb1^id | -5     | (0,0,0)    | !JournalUmAb1^id |
And I close the current editor

Given I query StorageQuantity for Product "FAHRRAD-06" on StorageLocation "ABLA"
Then StorageQuantities have values
    | !row | gebmge | orig^id      | lj^id            | bewmge | beworig^id   | bewlj^id         |
    | 1    | 2      | !Journal1^id | !JournalUmZu1^id | 2      | !Journal1^id | !JournalUmZu1^id |
    | 2    | 5      | (0,0,0)      | !JournalUmZu1^id | 5      | (0,0,0)      | !JournalUmZu1^id |
And I close the current editor

# Nachbewerten
And I run Revaluation

# Umlagerungsbewertungen
Given I open an editor "BewertungUmZu1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==FAHRRAD-06;detursache==Manuelle Umbuchung;buart==Zugang;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu1"
Then table has values
    | !row | tmge | orig^id      | beworig^id   |
    | 1    | 5    | !Journal1^id | !Journal1^id |
    | 2    | 5    | (0,0,0)      | (0,0,0)      |
And I close the current editor

Given I open an editor "BewertungUmAb1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==FAHRRAD-06;detursache==Manuelle Umbuchung;buart==Abgang;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb1"
Then table has values
    | !row | tmge | orig^id      | beworig^id   |
    | 1    | 5    | !Journal1^id | !Journal1^id |
    | 2    | 5    | (0,0,0)      | (0,0,0)      |
And I close the current editor

# Bewertung zu Abgang 2
Given I open an editor "BewertungAb2b" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==FAHRRAD-06;detursache==Lieferschein Verkauf;mge==3;@ablageart=lebendig;"
Then field "ppsref^id" has value equal to field "id" from editor "JournalAb2"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungAb2"
Then table has values
    | !row | tmge | orig^id      | beworig^id   |
    | 1    | 3    | !Journal1^id | !Journal1^id |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: Zweite Umlagerung
And I transfer StorageQuantity of "7" for Product "FAHRRAD-06" from StorageLocation "ABLA" to "ZLQM" with document "Umlagern6-2"

# Zugangsjournal der Umlagerung
Given I open an editor "JournalUmZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-06;detursache==Manuelle Umbuchung;buarta==Zugang;mge==7"
Then field "buarta" has value "Zugang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "platz" has value "ZLQM"
Then field "lj" is not empty
Then field "mge" has value "7"
And I close the current editor

# Abgangsjournal der Umlagerung
Given I open an editor "JournalUmAb2" via ID from editor "JournalUmZu2" from field "lj" in row 0 for table "(Journal):(Journal)" with command "VIEW"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "platz" has value "ABLA"
Then field "mge" has value "7"
Then table has values
    | !row | mge | lj^id            | orig^id      | bewmge | bewlj^id         | beworig^id   |
    | 1    | 2   | !JournalUmZu1^id | !Journal1^id | 2      | !JournalUmZu1^id | !Journal1^id |
    | 2    | 5   | !JournalUmZu1^id | (0,0,0)      | 5      | !JournalUmZu1^id | (0,0,0)      |
And I close the current editor

# Journaleintrag zu Abgang 3
Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalAb3"
Then field "buarta" has value "Abgang"
Then field "mge" has value "7"
Then table has values
    | !row | mge | orig^id      | lj^id            | bewmge | beworig^id   | bewlj^id         |
    | 1    | 2   | !Journal1^id | !JournalUmZu2^id | 2      | !Journal1^id | !JournalUmZu2^id |
    | 2    | 5   | (0,0,0)      | !JournalUmZu2^id | 5      | (0,0,0)      | !JournalUmZu2^id |
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "FAHRRAD-06" on StorageLocation "MLF01"
Then StorageQuantities have values
    | !row | gebmge | orig^id | lj^id            | bewmge | beworig^id | bewlj^id         |
    | 1    | -5     | (0,0,0) | !JournalUmAb1^id | -5     | (0,0,0)    | !JournalUmAb1^id |
And I close the current editor

Given I query StorageQuantity for Product "FAHRRAD-06" on StorageLocation "ABLA"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "FAHRRAD-06" on StorageLocation "ZLQM"
Then StorageQuantity is zero
And I close the current editor

# Nachbewerten
And I run Revaluation

# Umlagerungsbewertungen
Given I open an editor "BewertungUmZu2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==FAHRRAD-06;detursache==Manuelle Umbuchung;buart==Zugang;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu2"
Then table has values
    | !row | tmge | orig^id      | beworig^id   |
    | 1    | 2    | !Journal1^id | !Journal1^id |
    | 2    | 5    | (0,0,0)      | (0,0,0)      |
And I close the current editor

Given I open an editor "BewertungUmAb2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==FAHRRAD-06;detursache==Manuelle Umbuchung;buart==Abgang;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb2"
Then table has values
    | !row | tmge | orig^id      | beworig^id   |
    | 1    | 2    | !Journal1^id | !Journal1^id |
    | 2    | 5    | (0,0,0)      | (0,0,0)      |
And I close the current editor

# Bewertung zu Abgang 3
Given I open an editor "BewertungAb3a" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==FAHRRAD-06;detursache==Lieferschein Verkauf;mge==7;@ablageart=lebendig;"
Then field "ppsref^id" has value equal to field "id" from editor "JournalAb3"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungAb3"
Then table has values
    | !row | tmge | orig^id      | beworig^id   |
    | 1    | 2    | !Journal1^id | !Journal1^id |
	| 2    | 5    | (0,0,0)      | (0,0,0)      |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: Neue Lieferung auf Platz MLF01 um negativen Bestand auszugleichen
Given I open an editor "Lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "PUKY"
And I set field "ebeleg" to "EK-06"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I append rows
| artikel    | mge | platz |
| FAHRRAD-06 | 5   | MLF01 |
And I save the current editor

# Journaleintrag fuer neuen Zugang
Given I open an editor "Journal2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-06;detursache==Lieferschein Einkauf;buarta==Zugang;ebeleg==EK-06"
Then field "buarta" has value "Zugang"
Then field "detursache" has value "Lieferschein Einkauf"
Then field "ebeleg" has value "EK-06"
Then field "platz" has value "MLF01"
Then field "mge" has value "5"
And I close the current editor

# Journaleintraege fuer Abgaenge pruefen
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalAb1"
Then field "buarta" has value "Abgang"
Then field "mge" has value "5"
Then table has values
    | !row | mge | orig^id      | bewmge | beworig^id   |
    | 1    | 5   | !Journal1^id | 5      | !Journal1^id |
And I close the current editor

# Abgangsjournal der ersten Umlagerung pruefen
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb1"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "platz" has value "MLF01"
Then field "mge" has value "10"
Then table has values
    | !row | mge | lj^id        | orig^id      | bewmge | bewlj^id     | beworig^id   |
    | 1    | 5   | !Journal1^id | !Journal1^id | 5      | !Journal1^id | !Journal1^id |
    | 2    | 5   | !Journal2^id | !Journal2^id | 5      | !Journal2^id | !Journal2^id |
And I close the current editor

# Abgangsjournal der zweiten Umlagerung
Given I open an editor "JournalUmAb2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb2"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "platz" has value "ABLA"
Then field "mge" has value "7"
Then table has values
    | !row | mge | lj^id            | orig^id      | bewmge | bewlj^id         | beworig^id   |
    | 1    | 2   | !JournalUmZu1^id | !Journal1^id | 2      | !JournalUmZu1^id | !Journal1^id |
    | 2    | 5   | !JournalUmZu1^id | !Journal2^id | 5      | !JournalUmZu1^id | !Journal2^id |
And I close the current editor

# Journaleintrag zu Abgang 3
Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalAb3"
Then field "buarta" has value "Abgang"
Then field "mge" has value "7"
Then table has values
    | !row | mge | orig^id      | lj^id            | bewmge | beworig^id   | bewlj^id         |
    | 1    | 2   | !Journal1^id | !JournalUmZu2^id | 2      | !Journal1^id | !JournalUmZu2^id |
    | 2    | 5   | !Journal2^id | !JournalUmZu2^id | 5      | !Journal2^id | !JournalUmZu2^id |
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "FAHRRAD-06" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "FAHRRAD-06" on StorageLocation "ABLA"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "FAHRRAD-06" on StorageLocation "ZLQM"
Then StorageQuantity is zero
And I close the current editor

# Nachbewerten
And I run Revaluation

# Bewertungen pruefen
# Umlagerung 1 Zugang/Abgang
Given I open an editor "BewertungUmZu1" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmZu1"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu1"
And I close the current editor

Given I open an editor "BewertungUmZu1a" via ID from editor "BewertungUmZu1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu1"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu1"
Then table has values
    | !row | tmge | orig^id      | beworig^id   |
    | 1    | 5    | !Journal1^id | !Journal1^id |
    | 2    | 5    | !Journal2^id | !Journal2^id |
And I close the current editor

Given I open an editor "BewertungUmAb1" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmAb1"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb1"
And I close the current editor

Given I open an editor "BewertungUmAb1a" via ID from editor "BewertungUmAb1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb1"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmAb1"
Then table has values
    | !row | tmge | orig^id      | beworig^id   |
    | 1    | 5    | !Journal1^id | !Journal1^id |
    | 2    | 5    | !Journal2^id | !Journal2^id |
And I close the current editor

# Umlagerung 2 Zugang/Abgang
Given I open an editor "BewertungUmZu2" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmZu2"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu2"
And I close the current editor

Given I open an editor "BewertungUmZu2a" via ID from editor "BewertungUmZu2" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu2"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu2"
Then table has values
    | !row | tmge | orig^id      | beworig^id   |
    | 1    | 2    | !Journal1^id | !Journal1^id |
    | 2    | 5    | !Journal2^id | !Journal2^id |
And I close the current editor

Given I open an editor "BewertungUmAb2" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmAb2"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb2"
And I close the current editor

Given I open an editor "BewertungUmAb2a" via ID from editor "BewertungUmAb2" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb2"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmAb2"
Then table has values
    | !row | tmge | orig^id      | beworig^id   |
    | 1    | 2    | !Journal1^id | !Journal1^id |
    | 2    | 5    | !Journal2^id | !Journal2^id |
And I close the current editor

# Bewertung zu Abgang 3
Given I open an editor "BewertungAb3b" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==FAHRRAD-06;detursache==Lieferschein Verkauf;mge==7;@ablageart=lebendig;"
Then field "ppsref^id" has value equal to field "id" from editor "JournalAb3"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungAb3a"
Then table has values
    | !row | tmge | orig^id      | beworig^id   |
    | 1    | 2    | !Journal1^id | !Journal1^id |
    | 2    | 5    | !Journal2^id | !Journal2^id |
And I close the current editor
