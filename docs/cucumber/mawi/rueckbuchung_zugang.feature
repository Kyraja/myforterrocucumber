# *****************************************************************************
#  Name             : rueckbuchung_zugang.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet die Rueckbuchung fuer Zugaenge
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_zugang.feature
Background:
Given I set the fake date to "12.01.95"

Scenario Outline: Stammdaten anlegen

Given I open an editor "<artikel>" from table "(Part):(Product)" with command "STORE" for record "<artikel>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I save the current editor

Examples:
| artikel     | such        | namebspr           |
| ZURUECK_001 | ZURUECK_001 | Ruecklieferartikel |

Scenario: Zugang auf Platz buchen
Given I open an editor "EKLS01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "vom" to "."
And I set field "ebeleg" to "Originallieferung_001"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "ZURUECK_001" in row 1
And I set field "mge" to "100" in row 1
And I set field "platz" to "F3" in row 1
And I set field "preis" to "34,56" in row 1
And I set field "ueb" to "JA"
And I save the current editor

# Journaleintrag pruefen
Given I open an editor "JournalZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==ZURUECK_001;buarta==Zugang;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "F3"
Then field "gmge" has value "100"
Then field "mge" has value "100"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "ZURUECK_001" on StorageLocation "F3"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 100    | Stück  | !JournalZu^id | !JournalZu^id | 100    | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I query StorageQuantity for Product "ZURUECK_001" in WarehouseGroup "KARLSRUHE"
Then StorageQuantities have values
	| gebmge	|
	|  100		|
And I close the current editor

Given I query StorageQuantity for Product "ZURUECK_001"
Then StorageQuantities have values
	| gebmge	|
	|  100		|
And I close the current editor

# Bewertung pruefen
Given I open an editor "BewertungZu" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=ZURUECK_001;buart==Zugang;"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr  | addkosten |
    | 100  | !JournalZu^id | !JournalZu^id | 34.5600 | 0.0000    |
And I close the current editor

Scenario: Rueckbuchung auf Originallieferschein
Given I open an editor "EKLS02" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EKLS01"
And I set field "vom" to "."
And I set field "ebeleg" to "Ruecklieferung_001"
And I set field "ueb" to "JA"
And I set field "mge" to "-20" in row 1
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalZu" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu"
Then field "buarta" has value "Zugang"
Then field "platz" has value "F3"
Then field "gmge" has value "100"
Then field "mge" has value "100"
Then field "rueckmge" has value "20"
And I close the current editor

Given I open an editor "JournalRueck" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==ZURUECK_001;buarta==Zugang;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "-20"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "ZURUECK_001" on StorageLocation "F3"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 80     | Stück  | !JournalZu^id | !JournalZu^id | 80     | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I query StorageQuantity for Product "ZURUECK_001" in WarehouseGroup "KARLSRUHE"
Then StorageQuantities have values
	| gebmge	|
	|  80		|
And I close the current editor

Given I query StorageQuantity for Product "ZURUECK_001"
Then StorageQuantities have values
	| gebmge	|
	| 80		|
And I close the current editor

# Bewertung pruefen
Given I open an editor "BewertungRueck" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=ZURUECK_001;buart==Zugang;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr  | addkosten |
    | 80   | !JournalZu^id | !JournalZu^id | 34.5600 | 0.0000    |
And I close the current editor

