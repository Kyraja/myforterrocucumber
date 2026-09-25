# *****************************************************************************
#  Name             : rueckbuchung_mit_umbuchung_scenario3.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet vollstaendigen Rueckbau und Neufertigung bei
#                     umgelagerten Bestaenden
#
# Getestet wird das fehlerhafte Scenario aus BW2-1010:
#  - Artikel Fahrrad wird gefertigt auf MLF01 (RM1)
#  - Gutmenge wird auf ABLA umgelagert
#  - Menge wird vollstaendig von ABLA rueckgebaut (RB1)
#  - dabei werden Umlagerungsbewertungen reduziert
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_mit_umbuchung_scenario3.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: 01 Bestaende fuer Bauteile auf 0 setzen, Fertigteil kopieren
And I set StorageQuantity to zero for Product "RAHMEN" on StorageLocation "MLF01" with document "Scenario3"
And I set StorageQuantity to zero for Product "RAD" on StorageLocation "MLF01" with document "Scenario3"
And I set StorageQuantity to zero for Product "SATTEL" on StorageLocation "MLF01" with document "Scenario3"
And I set StorageQuantity to zero for Product "PEDALE" on StorageLocation "MLF01" with document "Scenario3"

# Fertigteil FAHRRAD kopieren
Given I open an editor "Fahrrad" from table "(Part):(Product)" with command "COPY" for record "FAHRRAD"
And I set field "such" to "FAHRRAD-03"
And I save the current editor

Scenario: 02 Verkaufsauftag fuer Fahrrad anlegen und Bedarfe einkaufen
Given I create a SalesOrder "Auftrag" for Customer "RADSHOP" with Product "FAHRRAD-03" and quantity "10"

# Bedarfe einkaufen
Given I open an editor "Rechnung1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | PUKY      |
    | vom    | .         |
    | ebeleg | Rueckbau3 |
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
    | artikel 		| <artikel> |
    | klplatz 		| MLF01     |
	| verdichten	| nein		|
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

Scenario: 04 Fahrrad fertigen
# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel    | netmge | bisuch | mfreig |
    | FAHRRAD-03 | 10     | RAD03_ | ja     |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Rueckmeldung auf Betriebsauftrag
Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RAD03_000"
And I set field "mgr" to "101"
And I set field "sofort" to "1"
And I set field "gutmge" to "5" in row 1
And I set field "erbtext1" to "Rueckmeldung1" in row 1
And I save the current editor

# Journaleintrag pruefen
Given I open StockMovementJournal "Journal1" for Product "FAHRRAD-03" and cause of entry "Rückmeldung Fertigung" and transaction "Rueckmeldung1" with command "VIEW"
Then field "buarta" has value "Zugang"
Then field "mge" has value "5"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "FAHRRAD-03" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | lj^id        | orig^id      | bewmge | bewlj^id     | beworig^id   |
    | 5      | !Journal1^id | !Journal1^id | 5      | !Journal1^id | !Journal1^id |
And I close the current editor

# Bewertung pruefen
Given I open latest Valuation "Bewertung1" for Product "FAHRRAD-03" and valuation transaction "Journal1" with command "VIEW"
Then field "ppsref^id" has value equal to field "id" from editor "Journal1"
Then table has values
    | tmge | orig^id      | beworig^id   |
    | 5    | !Journal1^id | !Journal1^id |
And I close the current editor


# ------------------------------------------------------------------------------------------------------------------------ #


# 05 Gutmenge umlagern
And I transfer StorageQuantity of "5" for Product "FAHRRAD-03" from StorageLocation "MLF01" to "ABLA" with document "Umlagern3"

# Zugangsjournal der Umlagerung
Given I open an editor "JournalUmZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-03;detursache==Manuelle Umbuchung;buarta==Zugang"
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
Given I query StorageQuantity for Product "FAHRRAD-03" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "FAHRRAD-03" on StorageLocation "ABLA"
Then StorageQuantities have values
    | gebmge | lj^id           | orig^id      | bewmge | bewlj^id        | beworig^id   |
    | 5      | !JournalUmZu^id | !Journal1^id | 5      | !JournalUmZu^id | !Journal1^id |
And I close the current editor

# Bewertungen pruefen
Given I open latest Valuation "BewertungUmZu1" for Product "FAHRRAD-03" and valuation transaction "JournalUmZu" with command "VIEW"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then table has values
    | tmge | orig^id      | beworig^id   |
    | 5    | !Journal1^id | !Journal1^id |
And I close the current editor

Given I open latest Valuation "BewertungUmAb1" for Product "FAHRRAD-03" and valuation transaction "JournalUmAb" with command "VIEW"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then table has values
    | tmge | orig^id      | beworig^id   |
    | 5    | !Journal1^id | !Journal1^id |
And I close the current editor


# ------------------------------------------------------------------------------------------------------------------------ #


# 06 Rueckbau auf Betriebsauftrag
Given I open an editor "Rueckbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RAD03_000"
And I set field "mgr" to "101"
And I set field "sofort" to "ja"
And I set field "gutmge" to "-5" in row 1
And I set field "buplatz" to "ABLA" in row 1
And I set field "erbtext1" to "Rueckbau1" in row 1
And I save the current editor

# Journaleintrag zur Rueckbau
Given I open StockMovementJournal "JournalRueck1" for Product "FAHRRAD-03" and cause of entry "Rückbau Fertigung" and transaction "Rueckbau1" with command "VIEW"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ABLA"
Then field "mge" has value "-5"
Then field "rueckorig^id" has value equal to field "id" from editor "Journal1"
And I close the current editor

# Zugangsjournal der Umlagerung muss rueckmge 5 haben
Given I open an editor "JournalUmZu" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu"
Then field "buarta" has value "Zugang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "platz" has value "ABLA"
Then field "mge" has value "5"
Then field "rueckmge" has value "5"
And I close the current editor

# Abgangsjournal der Umlagerung pruefen => Tabelle muss leer sein
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "platz" has value "MLF01"
Then field "mge" has value "5"
Then field "rueckmge" has value "5"
Then the table has 0 rows
And I close the current editor

# Umlagerungsjournale zur Rueckbuchung
Given I open an editor "JournalUmZuRueck" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-03;buarta==Zugang;detursache==Bewertungsmengenkorrektur Manuelle Umbuchung;mge < 0;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ABLA"
Then field "mge" has value "-5"
Then field "rueckmge" has value "-5"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalUmZu"
Then field "redorig^id" has value equal to field "id" from editor "Journal1"
Then field "redbeworig^id" has value equal to field "id" from editor "Journal1"
And I close the current editor

Given I open an editor "JournalUmAbRueck" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-03;buarta==Abgang;detursache==Bewertungsmengenkorrektur Manuelle Umbuchung;mge < 0;"
Then field "buarta" has value "Abgang"
Then field "platz" has value "MLF01"
Then field "mge" has value "-5"
Then field "rueckmge" has value "-5"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalUmAb"
Then field "redorig^id" has value equal to field "id" from editor "Journal1"
Then field "redbeworig^id" has value equal to field "id" from editor "Journal1"
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "FAHRRAD-03" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "FAHRRAD-03" on StorageLocation "ABLA"
Then StorageQuantity is zero
And I close the current editor

# Bewertungen pruefen
Given I open latest Valuation "BewertungRueck1" for Product "FAHRRAD-03" and valuation transaction "Journal1" with command "VIEW"
Then field "ppsref^id" has value equal to field "id" from editor "Journal1"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck1"
Then field "tmge" has value "0" in row 1
And I close the current editor

# Umlagerungsbewertungen pruefen
Given I open latest Valuation "BewertungUmZu2" for Product "FAHRRAD-03" and valuation transaction "JournalUmZu" with command "VIEW"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "vorgaenger" is not empty
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalUmZuRueck"
Then table has values
    | tmge | orig^id      | beworig^id   |
    | 0    | !Journal1^id | !Journal1^id |
And I close the current editor

Given I open latest Valuation "BewertungUmAb2" for Product "FAHRRAD-03" and valuation transaction "JournalUmAb" with command "VIEW"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "vorgaenger" is not empty
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalUmAbRueck"
Then table has values
    | tmge | orig^id      | beworig^id   |
    | 0    | !Journal1^id | !Journal1^id |
And I close the current editor
