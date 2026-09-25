# *****************************************************************************
#  Name             : rueckbuchung_mit_umbuchung_scenario4.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet vollstaendigen Rueckbau und Neufertigung bei
#                     umgelagerten Bestaenden
#
# Getestet wird das fehlerhafte Scenarion aus BW2-1010:
#  - Artikel Fahrrad wird gefertigt auf MLF01 (RM1)
#  - Gutmenge wird auf ABLA umgelagert
#  - Menge wird vollstaendig von MLF01 rueckgebaut (RB1)
#  - Menge wird mit Verkaufslieferschein ausgeliefert von ABLA
#  - Menge wird erneut auf MLF01 gefertigt (RM2)
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_mit_umbuchung_scenario4.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: 01 Bestaende fuer Bauteile auf 0 setzen, Fertigteil kopieren
And I set StorageQuantity to zero for Product "RAHMEN" on StorageLocation "MLF01" with document "Scenario4"
And I set StorageQuantity to zero for Product "RAD" on StorageLocation "MLF01" with document "Scenario4"
And I set StorageQuantity to zero for Product "SATTEL" on StorageLocation "MLF01" with document "Scenario4"
And I set StorageQuantity to zero for Product "PEDALE" on StorageLocation "MLF01" with document "Scenario4"

# Fertigteil FAHRRAD kopieren
Given I open an editor "Fahrrad" from table "(Part):(Product)" with command "COPY" for record "FAHRRAD"
And I set field "such" to "FAHRRAD-04"
And I save the current editor

Scenario: 02 Verkaufsauftag fuer Fahrrad anlegen und Bedarfe einkaufen
Given I create a SalesOrder "Auftrag" for Customer "RADSHOP" with Product "FAHRRAD-04" and quantity "10"

# Bedarfe einkaufen
Given I open an editor "Rechnung1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | PUKY      |
    | vom    | .         |
    | ebeleg | Rueckbau4 |
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

Scenario Outline: 03 Bestaende fuer Bauteile pruefen
Given I open the infosystem "BESTAND"
And I set fields
    | artikel | <artikel> |
    | klplatz | MLF01     |
	| verdichten	| nein	|
	| details       | nein  |
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

Scenario: 04 Fahrrad fertigen
# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel    | netmge | bisuch | mfreig |
    | FAHRRAD-04 | 10     | RAD04_ | ja     |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Rueckmeldung auf Betriebsauftrag
Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RAD04_000"
And I set field "mgr" to "101"
And I set field "sofort" to "1"
And I set field "gutmge" to "5" in row 1
And I set field "erbtext1" to "Rueckmeldung1" in row 1
And I save the current editor

# Journaleintrag pruefen
Given I open StockMovementJournal "Journal1" for Product "FAHRRAD-04" and cause of entry "Rückmeldung Fertigung" and transaction "Rueckmeldung1" with command "VIEW"
Then field "buarta" has value "Zugang"
Then field "mge" has value "5"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "FAHRRAD-04" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | lj^id        | orig^id      | bewmge | bewlj^id     | beworig^id   |
    | 5      | !Journal1^id | !Journal1^id | 5      | !Journal1^id | !Journal1^id |
And I close the current editor

# Bewertung pruefen
Given I open latest Valuation "Bewertung1" for Product "FAHRRAD-04" and valuation transaction "Journal1" with command "VIEW"
Then field "ppsref^id" has value equal to field "id" from editor "Journal1"
Then table has values
    | tmge | orig^id      | beworig^id   |
    | 5    | !Journal1^id | !Journal1^id |
And I close the current editor


# ------------------------------------------------------------------------------------------------------------------------ #

# 05 Gutmenge umlagern
And I transfer StorageQuantity of "5" for Product "FAHRRAD-04" from StorageLocation "MLF01" to "ABLA" with document "Umlagern1"

# Zugangsjournal der Umlagerung
Given I open an editor "JournalUmZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-04;detursache==Manuelle Umbuchung;buarta==Zugang"
Then field "buarta" has value "Zugang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "platz" has value "ABLA"
Then field "lj" is not empty
Then field "mge" has value "5"
And I close the current editor

# Abgangsjournal der Umlagerung
Given I open an editor "JournalUmAb" via ID from editor "JournalUmZu" from field "lj" in row 0 for table "(Journal):(Journal)" with command "VIEW"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "platz" has value "MLF01"
Then field "mge" has value "5"
Then table has values
    | mge | lj^id        | orig^id      | bewmge | bewlj^id     | beworig^id   |
    | 5   | !Journal1^id | !Journal1^id | 5      | !Journal1^id | !Journal1^id |
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "FAHRRAD-04" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "FAHRRAD-04" on StorageLocation "ABLA"
Then StorageQuantities have values
    | gebmge | lj^id           | orig^id      | bewmge | bewlj^id        | beworig^id   |
    | 5      | !JournalUmZu^id | !Journal1^id | 5      | !JournalUmZu^id | !Journal1^id |
And I close the current editor

# Bewertungen pruefen
Given I open latest Valuation "BewertungUmZu1" for Product "FAHRRAD-04" and valuation transaction "JournalUmZu" with command "VIEW"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then table has values
    | tmge | orig^id      | beworig^id   |
    | 5    | !Journal1^id | !Journal1^id |
And I close the current editor

Given I open latest Valuation "BewertungUmAb1" for Product "FAHRRAD-04" and valuation transaction "JournalUmAb" with command "VIEW"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then table has values
    | tmge | orig^id      | beworig^id   |
    | 5    | !Journal1^id | !Journal1^id |
And I close the current editor


# ------------------------------------------------------------------------------------------------------------------------ #


# 06 Rueckbau auf Betriebsauftrag
Given I open an editor "Rueckbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RAD04_000"
And I set field "mgr" to "101"
And I set field "sofort" to "ja"
And I set field "gutmge" to "-5" in row 1
And I set field "erbtext1" to "Rueckbau1" in row 1
And I save the current editor

# Journaleintrag zur Rueckbau
Given I open StockMovementJournal "JournalRueck1" for Product "FAHRRAD-04" and cause of entry "Rückbau Fertigung" and transaction "Rueckbau1" with command "VIEW"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MLF01"
Then field "mge" has value "-5"
Then field "rueckorig^id" has value equal to field "id" from editor "Journal1"
And I close the current editor

# Abgangsjournal der Umlagerung pruefen => Tabelle muss leer sein
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "platz" has value "MLF01"
Then field "mge" has value "5"
Then the table has 0 rows
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "FAHRRAD-04" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | lj^id           | orig^id | bewmge | bewlj^id        | beworig^id |
    | -5     | !JournalUmAb^id | (0,0,0) | -5     | !JournalUmAb^id | (0,0,0)    |
And I close the current editor

Given I query StorageQuantity for Product "FAHRRAD-04" on StorageLocation "ABLA"
Then StorageQuantities have values
    | gebmge | lj^id           | orig^id | bewmge | bewlj^id        | beworig^id |
    | 5      | !JournalUmZu^id | (0,0,0) | 5      | !JournalUmZu^id | (0,0,0)    |
And I close the current editor

# Bewertungen pruefen
Given I open latest Valuation "BewertungRueck1" for Product "FAHRRAD-04" and valuation transaction "Journal1" with command "VIEW"
Then field "ppsref^id" has value equal to field "id" from editor "Journal1"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck1"
Then field "tmge" has value "0" in row 1
And I close the current editor

# Umlagerungsbewertungen pruefen
Given I open latest Valuation "BewertungUmZu2" for Product "FAHRRAD-04" and valuation transaction "JournalUmZu" with command "VIEW"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu1"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck1"
Then table has values
    | tmge | orig^id | beworig^id |
    | 5    | (0,0,0) | (0,0,0)    |
And I close the current editor

Given I open latest Valuation "BewertungUmAb2" for Product "FAHRRAD-04" and valuation transaction "JournalUmAb" with command "VIEW"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmAb1"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck1"
Then table has values
    | tmge | orig^id | beworig^id |
    | 5    | (0,0,0) | (0,0,0)    |
And I close the current editor


# ------------------------------------------------------------------------------------------------------------------------ #


# 07 Artikel ausliefern
Given I open an editor "VKLieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to "id" from editor "Auftrag"
And I set field "ueb" to "ja"
And I set field "mge" to "5" in row 1
And I set field "platz" to "ABLA" in row 1
And I save the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "FAHRRAD-04" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | lj^id           | orig^id | bewmge | bewlj^id        | beworig^id |
    | -5     | !JournalUmAb^id | (0,0,0) | -5     | !JournalUmAb^id | (0,0,0)    |
And I close the current editor

Given I query StorageQuantity for Product "FAHRRAD-04" on StorageLocation "ABLA"
Then StorageQuantity is zero
And I close the current editor

# Journaleintrag pruefen
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-04;detursache==Lieferschein Verkauf;"
Then field "buarta" has value "Abgang"
Then field "vorgang^kopf^id" has value equal to field "id" from editor "VKLieferschein"
Then field "mge" has value "5"
Then table has values
    | mge | lj^id           | orig^id | bewmge | bewlj^id        | beworig^id |
    | 5   | !JournalUmZu^id | (0,0,0) | 5      | !JournalUmZu^id | (0,0,0)    |
And I close the current editor

# Bewertung pruefen
Given I open latest Valuation "BewertungAb1" for Product "FAHRRAD-04" and valuation transaction "JournalAb1" with command "VIEW"
Then field "ppsref^id" has value equal to field "id" from editor "JournalAb1"
Then table has values
    | tmge | orig^id | beworig^id |
    | 5    | (0,0,0) | (0,0,0)    |
And I close the current editor


# ------------------------------------------------------------------------------------------------------------------------ #


# 08 Artikel erneut fertigen
Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RAD04_000"
And I set field "mgr" to "101"
And I set field "sofort" to "1"
And I set field "gutmge" to "5" in row 1
And I set field "buplatz" to "MLF01" in row 1
And I set field "erbtext1" to "Rueckmeldung2" in row 1
And I save the current editor

# Journaleintraege pruefen
Given I open StockMovementJournal "Journal2" for Product "FAHRRAD-04" and cause of entry "Rückmeldung Fertigung" and transaction "Rueckmeldung2" with command "VIEW"
Then field "buarta" has value "Zugang"
Then field "vorgang^id" has value equal to field "id" from editor "Rueckmeldung2"
Then field "mge" has value "5"
And I close the current editor

# Abgangsjournal der Umlagerung
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "platz" has value "MLF01"
Then field "mge" has value "5"
Then table has values
    | mge | lj^id        | orig^id      | bewmge | bewlj^id     | beworig^id   |
    | 5   | !Journal2^id | !Journal2^id | 5      | !Journal2^id | !Journal2^id |
And I close the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalAb1"
Then field "buarta" has value "Abgang"
Then field "vorgang^kopf^id" has value equal to field "id" from editor "VKLieferschein"
Then field "mge" has value "5"
Then table has values
    | mge | lj^id           | orig^id      | bewmge | bewlj^id        | beworig^id   |
    | 5   | !JournalUmZu^id | !Journal2^id | 5      | !JournalUmZu^id | !Journal2^id |
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "FAHRRAD-04" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "FAHRRAD-04" on StorageLocation "ABLA"
Then StorageQuantity is zero
And I close the current editor

# Nachbewerten starten
And I run Revaluation

# Bewertung pruefen
Given I open latest Valuation "Bewertung2" for Product "FAHRRAD-04" and valuation transaction "Journal2" with command "VIEW"
Then field "ppsref^id" has value equal to field "id" from editor "Journal2"
Then field "tmge" has value "5" in row 1
Then table has values
    | tmge | orig^id      | beworig^id   |
    | 5    | !Journal2^id | !Journal2^id |
And I close the current editor

Given I open latest Valuation "BewertungAb1b" for Product "FAHRRAD-04" and valuation transaction "JournalAb1" with command "VIEW"
Then field "ppsref^id" has value equal to field "id" from editor "JournalAb1"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungAb1"
Then table has values
    | tmge | orig^id      | beworig^id   |
    | 5    | !Journal2^id | !Journal2^id |
And I close the current editor

# Umlagerungsbewertungen pruefen
Given I open latest Valuation "BewertungUmZu3" for Product "FAHRRAD-04" and valuation transaction "JournalUmZu" with command "VIEW"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu2"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "rueckverur" is empty
Then table has values
    | tmge | orig^id      | beworig^id   |
    | 5    | !Journal2^id | !Journal2^id |
And I close the current editor

Given I open latest Valuation "BewertungUmAb3" for Product "FAHRRAD-04" and valuation transaction "JournalUmAb" with command "VIEW"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmAb2"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "rueckverur" is empty
Then table has values
    | tmge | orig^id      | beworig^id   |
    | 5    | !Journal2^id | !Journal2^id |
And I close the current editor
