# *****************************************************************************
#  Name             : rueckbuchung_folgeplatz_scenario03.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Ruecklieferung vom Folgeplatz
#
# Testszenario:
#  - Bewertungsverfahren LIFO
#  - Zugang EK-Rechnung mit Lagerbewegung auf Platz WELA
#  - Umbuchung je 2x auf MLF01 und 2x auf ZLQM
#  - Umlagerung je 1x 50 Stueck von MLF01 nach L3F1 und 1x 50 Stueck von ZLQM nach L3F1
#  - Ruecklieferung des Zugangs von L3F1
#  - Storno der Ruecklieferung
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_folgeplatz_scenario03.feature
Background:
Given I set the fake date to "12.01.95"

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 01 Artikel kopieren
Given I open an editor "RAD-03" from table "(Part):(Product)" with command "COPY" for record "RAD"
And I set field "such" to "RAD-03"
And I set field "chverfolgung" to ""
# Bewertunsgverfahren LIFO setzen
And I set field "ekbewverf" to "4"
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 02 Rad einkaufen
Given I open an editor "RechnungmLZu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 3zu      |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang03 |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | he   | preis | platz |
    | RAD-03  | 100 | Paar | 10.00 | WELA  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;platz==WELA;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "100"
Then field "mge" has value "200"
And I close the current editor


# Platzmengen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "RAD-03" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 200    | Stück  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 200    | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario Outline: 03-1 Bestaende umlagern
Given I set the fake date to "<datum>"
And I transfer StorageQuantity of "<menge>" "Paar" for Product "RAD-03" from StorageLocation "<abplatz>" to "<zuplatz>" with document "<beleg>"

Examples:
    | datum   | beleg | menge | abplatz | zuplatz |
    | 13.1.95 | 3um1  | 20    | WELA    | MLF01   |
    | 14.1.95 | 3um2  | 30    | WELA    | MLF01   |
    | 15.1.95 | 3um3  | 29    | WELA    | ZLQM    |
    | 16.1.95 | 3um4  | 21    | WELA    | ZLQM    |


Scenario: 03-2 Journaleintraege und Platzmengen pruefen fuer manuelle Umbuchung
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Abgang;detursache==Manuelle Umbuchung;platz==WELA;mge==40;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "20"
Then field "mge" has value "40"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 40  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;detursache==Manuelle Umbuchung;platz==MLF01;mge==40;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "20"
Then field "mge" has value "40"
And I close the current editor

Given I open an editor "JournalUmAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Abgang;detursache==Manuelle Umbuchung;platz==WELA;mge==60;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "30"
Then field "mge" has value "60"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 60  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
And I close the current editor

Given I open an editor "JournalUmZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;detursache==Manuelle Umbuchung;platz==MLF01;mge==60;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "30"
Then field "mge" has value "60"
And I close the current editor

Given I open an editor "JournalUmAb3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Abgang;detursache==Manuelle Umbuchung;platz==WELA;mge==58;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "29"
Then field "mge" has value "58"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 58  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
And I close the current editor

Given I open an editor "JournalUmZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;detursache==Manuelle Umbuchung;platz==ZLQM;mge==58;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ZLQM"
Then field "gmge" has value "29"
Then field "mge" has value "58"
And I close the current editor

Given I open an editor "JournalUmAb4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Abgang;detursache==Manuelle Umbuchung;platz==WELA;mge==42;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "21"
Then field "mge" has value "42"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 42  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
And I close the current editor

Given I open an editor "JournalUmZu4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;detursache==Manuelle Umbuchung;platz==ZLQM;mge==42;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ZLQM"
Then field "gmge" has value "21"
Then field "mge" has value "42"
And I close the current editor


# Platzmengen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "RAD-03" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id   | orig^id | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 0      | Stück  | (0,0,0) | (0,0,0) |            | 200    | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |

Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "RAD-03" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 40     | Stück  | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
    | 60     | Stück  | !JournalUmZu2^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |

Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "RAD-03" on StorageLocation "ZLQM"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 58     | Stück  | !JournalUmZu3^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
    | 42     | Stück  | !JournalUmZu4^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 04 Weitere Umlagerung ueber Lieferschein
Given I set the fake date to "17.1.95"
Given I open an editor "LieferscheinUm1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | nummer   | 3um5         |
    | bsart    | Umlagern     |
    | lief     | PUKY         |
    | vom      | .            |
    | ebeleg   | Umlagern03-5 |
    | ueb      | ja           |
    | erfwaehr | DEM          |
And I append rows
    | artikel | mge | he   | abplatz | platz |
    | RAD-03  | 50  | Paar | MLF01   | L3F1  |
And I save the current editor


# Journaleintraege
Given I open an editor "JournalUmAb5" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Abgang;detursache==Umlagerungslieferschein Einkauf;platz==MLF01;budat==17.1.95;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "50"
Then field "mge" has value "100"
Then field "platz" has value "MLF01"
Then table has values
    | mge | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 40  | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
    | 60  | !JournalUmZu2^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
And I close the current editor

Given I open an editor "JournalUmZu5" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;detursache==Umlagerungslieferschein Einkauf;platz==L3F1;budat==17.1.95;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "L3F1"
Then field "gmge" has value "50"
Then field "mge" has value "100"
And I close the current editor


# Zweite Umlagerung
Given I set the fake date to "18.1.95"

Given I open an editor "LieferscheinUm2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | nummer   | 3um6         |
    | bsart    | Umlagern     |
    | lief     | PUKY         |
    | vom      | .            |
    | ebeleg   | Umlagern03-6 |
    | ueb      | ja           |
    | erfwaehr | DEM          |
And I append rows
    | artikel | mge | he   | abplatz | platz |
    | RAD-03  | 50  | Paar | ZLQM    | L3F1  |
And I save the current editor


# Journaleintraege
Given I open an editor "JournalUmAb6" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Abgang;detursache==Umlagerungslieferschein Einkauf;platz==ZLQM;budat==18.1.95;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "50"
Then field "mge" has value "100"
Then field "platz" has value "ZLQM"
Then table has values
    | mge | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 58  | !JournalUmZu3^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
    | 42  | !JournalUmZu4^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
And I close the current editor

Given I open an editor "JournalUmZu6" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;detursache==Umlagerungslieferschein Einkauf;platz==L3F1;budat==18.1.95"
Then field "buarta" has value "Zugang"
Then field "platz" has value "L3F1"
Then field "gmge" has value "50"
Then field "mge" has value "100"
And I close the current editor


# Platzmengen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "RAD-03" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id   | orig^id | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 0      | Stück  | (0,0,0) | (0,0,0) |            | 200    | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |

Given I query StorageQuantity for Product "RAD-03" on StorageLocation "MLF01"
Then StorageQuantity is zero

Given I query StorageQuantity for Product "RAD-03" on StorageLocation "ZLQM"
Then StorageQuantity is zero

Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "RAD-03" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 40     | Stück  | !JournalUmZu5^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
    | 60     | Stück  | !JournalUmZu5^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
    | 58     | Stück  | !JournalUmZu6^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
    | 42     | Stück  | !JournalUmZu6^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 05-1 Vollstaendige Ruecklieferung des Zugangs
Given I set the fake date to "19.1.95"

Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set fields
    | nummer   | 3rueck     |
    | vom      | .          |
    | ueb      | ja         |
And I set field "mge" to "-100" in row 1
And I set field "platz" to "L3F1" in row 1
And I save the current editor


# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu1"
Then field "rueckgmge" has value "100"
Then field "rueckmge" has value "200"
And I close the current editor

Given I open an editor "JournalRueck1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;platz==L3F1;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "L3F1"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "rueckgmge" has value "-100"
Then field "rueckmge" has value "-200"
And I close the current editor


Scenario Outline: 05-2 Journaleintraege zu Umbuchungen pruefen
Given I open an editor "<editor>" from table "(Journal):(Journal)" with command "VIEW" for record from editor "<editor>"
Then field "buarta" has value "<buart>"
Then field "rueckmge" has value "<rueckmge>"
Then field "rueckgmge" has value "<rueckgmge>"
Then field "platz" has value "<platz>"
Then the table has 0 rows
And I close the current editor

Examples:
    | editor       | buart  | rueckmge | rueckgmge | platz |
    | JournalUmAb1 | Abgang | 40       | 20        | WELA  |
    | JournalUmZu1 | Zugang | 40       | 20        | MLF01 |
    | JournalUmAb2 | Abgang | 60       | 30        | WELA  |
    | JournalUmZu2 | Zugang | 60       | 30        | MLF01 |
    | JournalUmAb3 | Abgang | 58       | 29        | WELA  |
    | JournalUmZu3 | Zugang | 58       | 29        | ZLQM  |
    | JournalUmAb4 | Abgang | 42       | 21        | WELA  |
    | JournalUmZu4 | Zugang | 42       | 21        | ZLQM  |
    | JournalUmAb5 | Abgang | 100      | 50        | MLF01 |
    | JournalUmZu5 | Zugang | 100      | 50        | L3F1  |
    | JournalUmAb6 | Abgang | 100      | 50        | ZLQM  |
    | JournalUmZu6 | Zugang | 100      | 50        | L3F1  |


Scenario Outline: 05-3 Journaleintraege zur Bewertungsmengenkorrketur pruefen
Given I open an editor "<editor>" from table "(Journal):(Journal)" with command "VIEW" for record "<select>"
Then field "buarta" has value "<buart>"
Then field "detursache" has value "<detursache>"
Then field "rueckmge" has value "<rueckmge>"
Then field "rueckgmge" has value "<rueckgmge>"
Then field "platz" has value "<platz>"
Then field "rueckorig^id" has value equal to field "id" from editor "<umeditor>"
Then field "bewmgekorrektur" has value "ja"
Then the table has 0 rows
And I close the current editor

Examples:
    | select                                                                        | editor         | buart  | rueckmge | rueckgmge | platz | detursache                                                | umeditor     |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;platz==WELA;rueckmge==-40;  | JournalUmAb1-2 | Abgang | -40      | -20       | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung              | JournalUmAb1 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;platz==MLF01;rueckmge==-40; | JournalUmZu1-2 | Zugang | -40      | -20       | MLF01 | Bewertungsmengenkorrektur Manuelle Umbuchung              | JournalUmZu1 |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;platz==WELA;rueckmge==-60;  | JournalUmAb2-2 | Abgang | -60      | -30       | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung              | JournalUmAb2 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;platz==MLF01;rueckmge==-60; | JournalUmZu2-2 | Zugang | -60      | -30       | MLF01 | Bewertungsmengenkorrektur Manuelle Umbuchung              | JournalUmZu2 |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;platz==WELA;rueckmge==-58;  | JournalUmAb3-2 | Abgang | -58      | -29       | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung              | JournalUmAb3 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;platz==ZLQM;rueckmge==-58;  | JournalUmZu3-2 | Zugang | -58      | -29       | ZLQM  | Bewertungsmengenkorrektur Manuelle Umbuchung              | JournalUmZu3 |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;platz==WELA;rueckmge==-42;  | JournalUmAb4-2 | Abgang | -42      | -21       | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung              | JournalUmAb4 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;platz==ZLQM;rueckmge==-42;  | JournalUmZu4-2 | Zugang | -42      | -21       | ZLQM  | Bewertungsmengenkorrektur Manuelle Umbuchung              | JournalUmZu4 |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;platz==MLF01;rueckmge==-60; | JournalUmAb5-2 | Abgang | -60      | -30       | MLF01 | Bewertungsmengenkorrektur Umlagerungslieferschein Einkauf | JournalUmAb5 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;platz==L3F1;rueckmge==-60;  | JournalUmZu5-2 | Zugang | -60      | -30       | L3F1  | Bewertungsmengenkorrektur Umlagerungslieferschein Einkauf | JournalUmZu5 |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;platz==MLF01;rueckmge==-40; | JournalUmAb5-3 | Abgang | -40      | -20       | MLF01 | Bewertungsmengenkorrektur Umlagerungslieferschein Einkauf | JournalUmAb5 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;platz==L3F1;rueckmge==-40;  | JournalUmZu5-3 | Zugang | -40      | -20       | L3F1  | Bewertungsmengenkorrektur Umlagerungslieferschein Einkauf | JournalUmZu5 |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;platz==ZLQM;rueckmge==-58;  | JournalUmAb6-2 | Abgang | -58      | -29       | ZLQM  | Bewertungsmengenkorrektur Umlagerungslieferschein Einkauf | JournalUmAb6 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;platz==L3F1;rueckmge==-58;  | JournalUmZu6-2 | Zugang | -58      | -29       | L3F1  | Bewertungsmengenkorrektur Umlagerungslieferschein Einkauf | JournalUmZu6 |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;platz==ZLQM;rueckmge==-42;  | JournalUmAb6-3 | Abgang | -42      | -21       | ZLQM  | Bewertungsmengenkorrektur Umlagerungslieferschein Einkauf | JournalUmAb6 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;platz==L3F1;rueckmge==-42;  | JournalUmZu6-3 | Zugang | -42      | -21       | L3F1  | Bewertungsmengenkorrektur Umlagerungslieferschein Einkauf | JournalUmZu6 |


Scenario: 05-4 Platzmengen pruefen
Given I query StorageQuantity for Product "RAD-03" on StorageLocation "WELA"
Then StorageQuantity is zero

Given I query StorageQuantity for Product "RAD-03" on StorageLocation "MLF01"
Then StorageQuantity is zero

Given I query StorageQuantity for Product "RAD-03" on StorageLocation "ZLQM"
Then StorageQuantity is zero

Given I query StorageQuantity for Product "RAD-03" on StorageLocation "L3F1"
Then StorageQuantity is zero

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 06-1 Vollstaendige Ruecklieferung des Zugangs stornieren
Given I set the fake date to "20.1.95"
Given I open an editor "StornoRueck" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung"
And I set fields
    | nummer | 3strueck |
And I save the current editor


# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu1"
Then field "rueckgmge" has value "0"
Then field "rueckmge" has value "0"
And I close the current editor

Given I open an editor "JournalRueck1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalRueck1"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "rueckgmge" has value "-100"
Then field "rueckmge" has value "-200"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalStorno1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;platz==L3F1;detursache==Storno-Rücklieferung Einkauf;"
Then field "gmge" has value "100"
Then field "mge" has value "200"
Then field "platz" has value "L3F1"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck1"
And I close the current editor


Scenario Outline: 06-2 Journaleintraege zu Umbuchungen pruefen
Given I open an editor "<editor>" from table "(Journal):(Journal)" with command "VIEW" for record from editor "<editor>"
Then field "buarta" has value "<buart>"
Then field "rueckmge" has value "<rueckmge>"
Then field "rueckgmge" has value "<rueckgmge>"
Then field "platz" has value "<platz>"
Then field "storniert" has value "ja"
Then field "bewmgekorrektur" has value "ja"
Then the table has 0 rows
And I close the current editor

Examples:
    | editor          | buart  | rueckmge | rueckgmge | platz |
    | JournalUmAb1-2  | Abgang | -40      | -20       | WELA  |
    | JournalUmZu1-2  | Zugang | -40      | -20       | MLF01 |
    | JournalUmAb2-2  | Abgang | -60      | -30       | WELA  |
    | JournalUmZu2-2  | Zugang | -60      | -30       | MLF01 |
    | JournalUmAb3-2  | Abgang | -58      | -29       | WELA  |
    | JournalUmZu3-2  | Zugang | -58      | -29       | ZLQM  |
    | JournalUmAb4-2  | Abgang | -42      | -21       | WELA  |
    | JournalUmZu4-2  | Zugang | -42      | -21       | ZLQM  |
    | JournalUmAb5-2  | Abgang | -60      | -30       | MLF01 |
    | JournalUmZu5-2  | Zugang | -60      | -30       | L3F1  |
    | JournalUmAb5-3  | Abgang | -40      | -20       | MLF01 |
    | JournalUmZu5-3  | Zugang | -40      | -20       | L3F1  |
    | JournalUmAb6-2  | Abgang | -58      | -29       | ZLQM  |
    | JournalUmZu6-2  | Zugang | -58      | -29       | L3F1  |
    | JournalUmAb6-3  | Abgang | -42      | -21       | ZLQM  |
    | JournalUmZu6-3  | Zugang | -42      | -21       | L3F1  |


Scenario Outline: 05-3 Zugangsjournaleintraege zur Bewertungsmengenkorrketur bei Storno pruefen
Given I open an editor "<editor>" from table "(Journal):(Journal)" with command "VIEW" for record "<select>"
Then field "buarta" has value "<buart>"
Then field "detursache" has value "<detursache>"
Then field "mge" has value "<mge>"
Then field "gmge" has value "<gmge>"
Then field "platz" has value "<platz>"
Then field "stornolj^id" has value equal to field "id" from editor "<umeditor>"
Then field "bewmgekorrektur" has value "ja"
Then the table has 0 rows
And I close the current editor

Examples:
    | select                                                                               | editor          | buart  | mge | gmge | platz | detursache                                                  | umeditor       |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;stornolj<>`;platz==WELA; mge==40;  | JournalUmAb1-2s | Abgang | 40  | 20   | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung         | JournalUmAb1-2 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;stornolj<>`;platz==MLF01;mge==40;  | JournalUmZu1-2s | Zugang | 40  | 20   | MLF01 | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung         | JournalUmZu1-2 |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;stornolj<>`;platz==WELA; mge==60;  | JournalUmAb2-2s | Abgang | 60  | 30   | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung         | JournalUmAb2-2 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;stornolj<>`;platz==MLF01;mge==60;  | JournalUmZu2-2s | Zugang | 60  | 30   | MLF01 | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung         | JournalUmZu2-2 |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;stornolj<>`;platz==WELA; mge==58;  | JournalUmAb3-2s | Abgang | 58  | 29   | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung         | JournalUmAb3-2 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;stornolj<>`;platz==ZLQM; mge==58;  | JournalUmZu3-2s | Zugang | 58  | 29   | ZLQM  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung         | JournalUmZu3-2 |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;stornolj<>`;platz==WELA; mge==42;  | JournalUmAb4-2s | Abgang | 42  | 21   | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung         | JournalUmAb4-2 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;stornolj<>`;platz==ZLQM; mge==42;  | JournalUmZu4-2s | Zugang | 42  | 21   | ZLQM  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung         | JournalUmZu4-2 |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;stornolj<>`;platz==MLF01;mge==60;  | JournalUmAb5-2s | Abgang | 60  | 30   | MLF01 | Storno-Bewertungsmengenkorrektur Umlagerungslieferschein Ek | JournalUmAb5-2 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;stornolj<>`;platz==L3F1; mge==60;  | JournalUmZu5-2s | Zugang | 60  | 30   | L3F1  | Storno-Bewertungsmengenkorrektur Umlagerungslieferschein Ek | JournalUmZu5-2 |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;stornolj<>`;platz==MLF01;mge==40;  | JournalUmAb5-3s | Abgang | 40  | 20   | MLF01 | Storno-Bewertungsmengenkorrektur Umlagerungslieferschein Ek | JournalUmAb5-3 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;stornolj<>`;platz==L3F1; mge==40;  | JournalUmZu5-3s | Zugang | 40  | 20   | L3F1  | Storno-Bewertungsmengenkorrektur Umlagerungslieferschein Ek | JournalUmZu5-3 |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;stornolj<>`;platz==ZLQM; mge==58;  | JournalUmAb6-2s | Abgang | 58  | 29   | ZLQM  | Storno-Bewertungsmengenkorrektur Umlagerungslieferschein Ek | JournalUmAb6-2 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;stornolj<>`;platz==L3F1; mge==58;  | JournalUmZu6-2s | Zugang | 58  | 29   | L3F1  | Storno-Bewertungsmengenkorrektur Umlagerungslieferschein Ek | JournalUmZu6-2 |
    | $,,artikel==RAD-03;buarta==Abgang;redrueckorig<>`;stornolj<>`;platz==ZLQM; mge==42;  | JournalUmAb6-3s | Abgang | 42  | 21   | ZLQM  | Storno-Bewertungsmengenkorrektur Umlagerungslieferschein Ek | JournalUmAb6-3 |
    | $,,artikel==RAD-03;buarta==Zugang;redrueckorig<>`;stornolj<>`;platz==L3F1; mge==42;  | JournalUmZu6-3s | Zugang | 42  | 21   | L3F1  | Storno-Bewertungsmengenkorrektur Umlagerungslieferschein Ek | JournalUmZu6-3 |


Scenario: Abgangsjournaleintraege mit Tabelle nach Bewertungsmengenkorrketur bei Storno pruefen
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb1"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "rueckmge" has value "0"
Then field "rueckgmge" has value "0"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 40  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
And I close the current editor

Given I open an editor "JournalUmAb2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb2"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "rueckmge" has value "0"
Then field "rueckgmge" has value "0"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 60  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
And I close the current editor

Given I open an editor "JournalUmAb3" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb3"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "rueckmge" has value "0"
Then field "rueckgmge" has value "0"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 58  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
And I close the current editor

Given I open an editor "JournalUmAb4" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb4"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "rueckmge" has value "0"
Then field "rueckgmge" has value "0"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 42  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
And I close the current editor

Given I open an editor "JournalUmAb5" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb5"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Umlagerungslieferschein Einkauf"
Then field "rueckmge" has value "0"
Then field "rueckgmge" has value "0"
Then field "platz" has value "MLF01"
Then table has values
    | mge | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 60  | !JournalUmZu2^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
    | 40  | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
And I close the current editor

Given I open an editor "JournalUmAb6" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb6"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Umlagerungslieferschein Einkauf"
Then field "rueckmge" has value "0"
Then field "rueckgmge" has value "0"
Then field "platz" has value "ZLQM"
Then table has values
    | mge | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
    | 42  | !JournalUmZu4^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
    | 58  | !JournalUmZu3^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
And I close the current editor


Scenario: 06-5 Platmengen pruefen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "RAD-03" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id    | orig^id  | verfdat | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 0      | Stück  | (0,0,0)  | (0,0,0)  |         | 40     | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |
    | 0      | Stück  | (0,0,0)  | (0,0,0)  |         | 60     | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |
    | 0      | Stück  | (0,0,0)  | (0,0,0)  |         | 58     | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |
    | 0      | Stück  | (0,0,0)  | (0,0,0)  |         | 42     | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |

Given I query StorageQuantity for Product "RAD-03" on StorageLocation "MLF01"
Then StorageQuantity is zero

Given I query StorageQuantity for Product "RAD-03" on StorageLocation "ZLQM"
Then StorageQuantity is zero

Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "RAD-03" on StorageLocation "L3F1"
Then StorageQuantities have values
     | gebmge | gebeinh | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id | beworig^id | bewdat |
     | 40     | Stück  | !JournalUmZu5^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
     | 60     | Stück  | !JournalUmZu5^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
     | 58     | Stück  | !JournalUmZu6^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
     | 42     | Stück  | !JournalUmZu6^id | !JournalZu1^id | 12.01.1995 | 0      | (0,0,0)  | (0,0,0)    |        |
