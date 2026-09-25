# *****************************************************************************
#  Name             : rueckbuchung_zugang_orignialplatz.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Rueckbuchung und Storno-Rueckbuchung
#                     nach mehreren Umlagerungen und Rueckbuchung von
#                     Originalplatz
#
# Getestet wird das Scenario:
#  - Zugang EK-Rechnung mit Lagerbewegung (94 Paar auf MLF01, Preis 10.00)
#  - Mehrfache Umlagerungen auf verschiedene Plaetze
#  - Ruecklieferung auf Zugang (-22 Paar von MLF01)
#  - Storno der Ruecklieferung
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_zugang_orignialplatz.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: 01 Artikel kopieren
Given I open an editor "RAD-01" from table "(Part):(Product)" with command "COPY" for record "RAD"
And I set field "such" to "RAD-01"
And I set field "chverfolgung" to ""
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 02 Rad einkaufen
Given I open an editor "RechnungmLZu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 1zu      |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang01 |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | he   | preis |
    | RAD-01  | 94  | Paar | 10.00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Zugang;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "94"
Then field "mge" has value "188"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-01" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 188    | Stück  | !JournalZu^id | !JournalZu^id | 188    | !JournalZu^id | !JournalZu^id |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 03 Rad umlagern in mehreren Teilmengen
Given I transfer StorageQuantity of "22" "Paar" for Product "RAD-01" from StorageLocation "MLF01" to "ABLA" with document "Um-01"
Given I transfer StorageQuantity of "23" "Paar" for Product "RAD-01" from StorageLocation "MLF01" to "ABLA" with document "Um-02"
Given I transfer StorageQuantity of "24" "Paar" for Product "RAD-01" from StorageLocation "MLF01" to "ABLA" with document "Um-03"
Given I transfer StorageQuantity of "25" "Paar" for Product "RAD-01" from StorageLocation "MLF01" to "ABLA" with document "Um-04"

# Journaleintraege pruefen
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Abgang;detursache==Manuelle Umbuchung;such==LUM-01;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "22"
Then field "mge" has value "44"
Then field "platz" has value "MLF01"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 44  | !JournalZu^id | !JournalZu^id | 44     | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Abgang;detursache==Manuelle Umbuchung;such==LUM-02;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "23"
Then field "mge" has value "46"
Then field "platz" has value "MLF01"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 46  | !JournalZu^id | !JournalZu^id | 46     | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmAb3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Abgang;detursache==Manuelle Umbuchung;such==LUM-03;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "24"
Then field "mge" has value "48"
Then field "platz" has value "MLF01"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 48  | !JournalZu^id | !JournalZu^id | 48     | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmAb4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Abgang;detursache==Manuelle Umbuchung;such==LUM-04;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "25"
Then field "mge" has value "50"
Then field "platz" has value "MLF01"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 50  | !JournalZu^id | !JournalZu^id | 50     | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Zugang;detursache==Manuelle Umbuchung;such==LUM-01;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "22"
Then field "mge" has value "44"
Then field "platz" has value "ABLA"
And I close the current editor

Given I open an editor "JournalUmZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Zugang;detursache==Manuelle Umbuchung;such==LUM-02;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "23"
Then field "mge" has value "46"
Then field "platz" has value "ABLA"
And I close the current editor

Given I open an editor "JournalUmZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Zugang;detursache==Manuelle Umbuchung;such==LUM-03;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "24"
Then field "mge" has value "48"
Then field "platz" has value "ABLA"
And I close the current editor

Given I open an editor "JournalUmZu4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Zugang;detursache==Manuelle Umbuchung;such==LUM-04;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "25"
Then field "mge" has value "50"
Then field "platz" has value "ABLA"
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "RAD-01" on StorageLocation "MLF01"
Then StorageQuantity is zero

Given I query StorageQuantity for Product "RAD-01" on StorageLocation "ABLA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id    |
	| 44     | Stück  | !JournalUmZu1^id | !JournalZu^id  | 44     | !JournalUmZu1^id | !JournalZu^id |
    | 46     | Stück  | !JournalUmZu2^id | !JournalZu^id  | 46     | !JournalUmZu2^id | !JournalZu^id |
    | 48     | Stück  | !JournalUmZu3^id | !JournalZu^id  | 48     | !JournalUmZu3^id | !JournalZu^id |
    | 50     | Stück  | !JournalUmZu4^id | !JournalZu^id  | 50     | !JournalUmZu4^id | !JournalZu^id |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 04 Ruecklieferung auf Zugang
Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set field "nummer" to "1rueck"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-24" in row 1
And I set field "he" to "Paar" in row 1
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalRueck" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Zugang;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "-24"
Then field "mge" has value "-48"
Then field "platz" has value "MLF01"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-01" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id | bewmge | bewlj^id         | beworig^id |
    | -44    | Stück  | !JournalUmAb1^id | (0,0,0) | -44    | !JournalUmAb1^id | (0,0,0)    |
    | -4     | Stück  | !JournalUmAb2^id | (0,0,0) | -4     | !JournalUmAb2^id | (0,0,0)    |

Given I query StorageQuantity for Product "RAD-01" on StorageLocation "ABLA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id       | bewmge | bewlj^id         | beworig^id    |
    | 44     | Stück  | !JournalUmZu1^id | (0,0,0)       | 44     | !JournalUmZu1^id | (0,0,0)       |
    | 42     | Stück  | !JournalUmZu2^id | !JournalZu^id | 42     | !JournalUmZu2^id | !JournalZu^id |
    | 48     | Stück  | !JournalUmZu3^id | !JournalZu^id | 48     | !JournalUmZu3^id | !JournalZu^id |
    | 50     | Stück  | !JournalUmZu4^id | !JournalZu^id | 50     | !JournalUmZu4^id | !JournalZu^id |
    | 4      | Stück  | !JournalUmZu2^id | (0,0,0)       | 4      | !JournalUmZu2^id | (0,0,0)       |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 05 Ruecklieferung stornieren
Given I open an editor "RueckStorno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung"
And I set field "nummer" to "1storno"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalStorno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Zugang;detursache==Storno-Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "24"
Then field "mge" has value "48"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-01" on StorageLocation "MLF01"
Then StorageQuantity is zero

Given I query StorageQuantity for Product "RAD-01" on StorageLocation "ABLA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id    |
    | 44     | Stück  | !JournalUmZu1^id | !JournalZu^id  | 44     | !JournalUmZu1^id | !JournalZu^id |
    | 42     | Stück  | !JournalUmZu2^id | !JournalZu^id  | 42     | !JournalUmZu2^id | !JournalZu^id |
    | 48     | Stück  | !JournalUmZu3^id | !JournalZu^id  | 48     | !JournalUmZu3^id | !JournalZu^id |
    | 50     | Stück  | !JournalUmZu4^id | !JournalZu^id  | 50     | !JournalUmZu4^id | !JournalZu^id |
    | 4      | Stück  | !JournalUmZu2^id | !JournalZu^id  | 4      | !JournalUmZu2^id | !JournalZu^id |
