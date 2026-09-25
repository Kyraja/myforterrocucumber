# *****************************************************************************
#  Name             : rueckbuchung_folgeplatz_scenario05.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Ruecklieferung vom Folgeplatz
#
# Testszenario:
#  - Zugang EK-Rechnung mit Lagerbewegung auf Platz WELA mit Verwendung puky_01
#  - Umbuchung je 2x auf Verwendung puky_02 und 2x auf Verwendung puky_03
#  - Umlagerung 2x 50 Stueck auf Verwendung puky_rueck von jeweils aktueller Verwendung
#  - Teil-Ruecklieferung des Zugangs mit Verwendung puky_rueck
#  - Storno der Teil-Ruecklieferung
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_folgeplatz_scenario05.feature
Background:
Given I set the fake date to "12.01.95"

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 01 Artikel kopieren
Given I open an editor "RAD-05" from table "(Part):(Product)" with command "COPY" for record "RAD"
And I set field "such" to "RAD-05"
And I set field "chverfolgung" to ""
And I set field "dispoa" to "auftragsbezogen"
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 02 Rad einkaufen
Given I open an editor "RechnungmLZu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 5zu      |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang05 |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | he   | preis | platz | verw    |
    | RAD-05  | 100 | Paar | 10.00 | WELA  | puky_01 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;platz==WELA;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "100"
Then field "mge" has value "200"
And I close the current editor


# Platzmengen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat,verw" from StorageQuantity for Product "RAD-05" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     | verw    |
    | 200    | Stück  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 200    | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | puky_01 |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario Outline: 03-1 Bestaende umlagern - Platz bleibt gleich aber Gebindeinfos aendern sich
Given I set the fake date to "<datum>"

Given I open an editor "Lagerbuchung" for tip command "Lbuchung" and arguments ""
And I set field "artikel" to "RAD-05"
And I set field "buart" to "Umbuchung"
And I set field "beldat" to "."
And I set field "beleg" to "<beleg>"

And I set field "mge" to "<menge>" in row 1
And I set field "platz" to "<abplatz>" in row 1
And I set field "platz2" to "<zuplatz>" in row 1
And I set field "verw" to "<abverw>" in row 1
And I set field "verw2" to "<zuverw>" in row 1
And I set field "ze" to "Paar" in row 1
And I save the current editor

Examples:
    | datum   | beleg | menge | abplatz | zuplatz | abverw  | zuverw  |
    | 13.1.95 | 5um1  | 20    | WELA    | WELA    | puky_01 | puky_02 |
    | 14.1.95 | 5um2  | 30    | WELA    | WELA    | puky_01 | puky_02 |
    | 15.1.95 | 5um3  | 29    | WELA    | WELA    | puky_01 | puky_03 |
    | 16.1.95 | 5um4  | 21    | WELA    | WELA    | puky_01 | puky_03 |


Scenario: 03-2 Journaleintraege und Platzmengen pruefen fuer manuelle Umbuchung
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Abgang;detursache==Manuelle Umbuchung;verw==puky_01;mge==40;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "20"
Then field "mge" has value "40"
Then field "platz" has value "WELA"
Then field "verwla" has value "puky_01"
Then field "verw" has value "puky_01"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 40  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 40     | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;detursache==Manuelle Umbuchung;verw==puky_02;mge==40;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "20"
Then field "mge" has value "40"
Then field "verwla" has value "puky_02"
Then field "verw" has value "puky_02"
And I close the current editor

Given I open an editor "JournalUmAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Abgang;detursache==Manuelle Umbuchung;verw==puky_01;mge==60;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "30"
Then field "mge" has value "60"
Then field "platz" has value "WELA"
Then field "verwla" has value "puky_01"
Then field "verw" has value "puky_01"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 60  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 60     | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I open an editor "JournalUmZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;detursache==Manuelle Umbuchung;verw==puky_02;mge==60;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "30"
Then field "mge" has value "60"
Then field "verwla" has value "puky_02"
Then field "verw" has value "puky_02"
And I close the current editor

Given I open an editor "JournalUmAb3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Abgang;detursache==Manuelle Umbuchung;verw==puky_01;mge==58;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "29"
Then field "mge" has value "58"
Then field "platz" has value "WELA"
Then field "verwla" has value "puky_01"
Then field "verw" has value "puky_01"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 58  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 58     | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I open an editor "JournalUmZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;detursache==Manuelle Umbuchung;verw==puky_03;mge==58;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "29"
Then field "mge" has value "58"
Then field "verwla" has value "puky_03"
Then field "verw" has value "puky_03"
And I close the current editor

Given I open an editor "JournalUmAb4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Abgang;detursache==Manuelle Umbuchung;verw==puky_01;mge==42;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "21"
Then field "mge" has value "42"
Then field "platz" has value "WELA"
Then field "verwla" has value "puky_01"
Then field "verw" has value "puky_01"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 42  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 42     | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I open an editor "JournalUmZu4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;detursache==Manuelle Umbuchung;verw==puky_03;mge==42;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "21"
Then field "mge" has value "42"
Then field "verwla" has value "puky_03"
Then field "verw" has value "puky_03"
And I close the current editor


# Platzmengen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat,verw" from StorageQuantity for Product "RAD-05" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id         | beworig^id     | bewdat     | verw    |
    | 40     | Stück  | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 | 40     | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 | puky_02 |
    | 60     | Stück  | !JournalUmZu2^id | !JournalZu1^id | 12.01.1995 | 60     | !JournalUmZu2^id | !JournalZu1^id | 12.01.1995 | puky_02 |
    | 58     | Stück  | !JournalUmZu3^id | !JournalZu1^id | 12.01.1995 | 58     | !JournalUmZu3^id | !JournalZu1^id | 12.01.1995 | puky_03 |
    | 42     | Stück  | !JournalUmZu4^id | !JournalZu1^id | 12.01.1995 | 42     | !JournalUmZu4^id | !JournalZu1^id | 12.01.1995 | puky_03 |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario Outline: 04-01 Weitere Umlagerungen, nur Verwendung aendern
Given I set the fake date to "<datum>"

Given I open an editor "Lagerbuchung" for tip command "Lbuchung" and arguments ""
And I set field "artikel" to "RAD-05"
And I set field "buart" to "Umbuchung"
And I set field "beldat" to "."
And I set field "beleg" to "<beleg>"

And I set field "mge" to "<menge>" in row 1
And I set field "platz" to "<abplatz>" in row 1
And I set field "platz2" to "<zuplatz>" in row 1
And I set field "verw" to "<abverw>" in row 1
And I set field "verw2" to "<zuverw>" in row 1
And I set field "ze" to "Paar" in row 1
And I save the current editor

Examples:
    | datum   | beleg | menge | abplatz | zuplatz | abverw  | zuverw     |
    | 17.1.95 | 5um5  | 50    | WELA    | WELA    | puky_02 | puky_rueck |
    | 18.1.95 | 5um6  | 50    | WELA    | WELA    | puky_03 | puky_rueck |


Scenario: 04-2 Journaleintraege und Platzmengen pruefen fuer manuelle Umbuchung
Given I open an editor "JournalUmAb5" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Abgang;detursache==Manuelle Umbuchung;verw==puky_02;budat==17.1.95;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "50"
Then field "mge" has value "100"
Then field "platz" has value "WELA"
Then field "verwla" has value "puky_02"
Then field "verw" has value "puky_02"
Then table has values
    | mge | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id         | beworig^id     | bewdat     |
    | 40  | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 | 40     | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 |
    | 60  | !JournalUmZu2^id | !JournalZu1^id | 12.01.1995 | 60     | !JournalUmZu2^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I open an editor "JournalUmZu5" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;detursache==Manuelle Umbuchung;verw==puky_rueck;budat==17.1.95;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "50"
Then field "mge" has value "100"
Then field "verwla" has value "puky_rueck"
Then field "verw" has value "puky_rueck"
And I close the current editor

Given I open an editor "JournalUmAb6" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Abgang;detursache==Manuelle Umbuchung;verw==puky_03;budat==18.1.95;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "50"
Then field "mge" has value "100"
Then field "platz" has value "WELA"
Then field "verwla" has value "puky_03"
Then field "verw" has value "puky_03"
Then table has values
    | mge | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id         | beworig^id     | bewdat     |
    | 58  | !JournalUmZu3^id | !JournalZu1^id | 12.01.1995 | 58     | !JournalUmZu3^id | !JournalZu1^id | 12.01.1995 |
    | 42  | !JournalUmZu4^id | !JournalZu1^id | 12.01.1995 | 42     | !JournalUmZu4^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I open an editor "JournalUmZu6" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;detursache==Manuelle Umbuchung;verw==puky_rueck;budat==18.1.95"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "50"
Then field "mge" has value "100"
Then field "verwla" has value "puky_rueck"
Then field "verw" has value "puky_rueck"
And I close the current editor


# Platzmengen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat,verw" from StorageQuantity for Product "RAD-05" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id         | beworig^id     | bewdat     | verw       |
    | 40     | Stück  | !JournalUmZu5^id | !JournalZu1^id | 12.01.1995 | 40     | !JournalUmZu5^id | !JournalZu1^id | 12.01.1995 | puky_rueck |
    | 60     | Stück  | !JournalUmZu5^id | !JournalZu1^id | 12.01.1995 | 60     | !JournalUmZu5^id | !JournalZu1^id | 12.01.1995 | puky_rueck |
    | 58     | Stück  | !JournalUmZu6^id | !JournalZu1^id | 12.01.1995 | 58     | !JournalUmZu6^id | !JournalZu1^id | 12.01.1995 | puky_rueck |
    | 42     | Stück  | !JournalUmZu6^id | !JournalZu1^id | 12.01.1995 | 42     | !JournalUmZu6^id | !JournalZu1^id | 12.01.1995 | puky_rueck |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 05-1 Teil-Ruecklieferung des Zugangs
Given I set the fake date to "19.1.95"

Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set fields
    | nummer   | 5rueck     |
    | vom      | .          |
    | ueb      | ja         |
And I set field "mge" to "-85" in row 1
And I set field "platz" to "WELA" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "-85" in row 1
And I set field "verw" to "puky_rueck" in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor


# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu1"
Then field "rueckgmge" has value "85"
Then field "rueckmge" has value "170"
Then field "verwla" has value "puky_01"
Then field "verw" has value "puky_01"
And I close the current editor

Given I open an editor "JournalRueck1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;platz==WELA;verw==puky_rueck;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "verwla" has value "puky_rueck"
Then field "verw" has value "puky_rueck"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "rueckgmge" has value "-85"
Then field "rueckmge" has value "-170"
And I close the current editor


Scenario Outline: 05-2 Journaleintraege zu Umbuchungen pruefen
Given I open an editor "<editor>" from table "(Journal):(Journal)" with command "VIEW" for record from editor "<editor>"
Then field "buarta" has value "<buart>"
Then field "rueckmge" has value "<rueckmge>"
Then field "rueckgmge" has value "<rueckgmge>"
Then field "platz" has value "<platz>"
Then field "verwla" has value "<verwendung>"
Then the table has <rows> rows
And I close the current editor

Examples:
    | editor       | buart  | rueckmge | rueckgmge | platz | verwendung | rows |
    | JournalUmAb1 | Abgang | 10       | 5         | WELA  | puky_01    | 1    |
    | JournalUmZu1 | Zugang | 10       | 5         | WELA  | puky_02    | 0    |
    | JournalUmAb2 | Abgang | 60       | 30        | WELA  | puky_01    | 0    |
    | JournalUmZu2 | Zugang | 60       | 30        | WELA  | puky_02    | 0    |
    | JournalUmAb3 | Abgang | 58       | 29        | WELA  | puky_01    | 0    |
    | JournalUmZu3 | Zugang | 58       | 29        | WELA  | puky_03    | 0    |
    | JournalUmAb4 | Abgang | 42       | 21        | WELA  | puky_01    | 0    |
    | JournalUmZu4 | Zugang | 42       | 21        | WELA  | puky_03    | 0    |
    | JournalUmAb5 | Abgang | 70       | 35        | WELA  | puky_02    | 1    |
    | JournalUmZu5 | Zugang | 70       | 35        | WELA  | puky_rueck | 0    |
    | JournalUmAb6 | Abgang | 100      | 50        | WELA  | puky_03    | 0    |
    | JournalUmZu6 | Zugang | 100      | 50        | WELA  | puky_rueck | 0    |


Scenario Outline: 05-3 Journaleintraege zur Bewertungsmengenkorrketur pruefen
Given I open an editor "<editor>" from table "(Journal):(Journal)" with command "VIEW" for record "<select>"
Then field "buarta" has value "<buart>"
Then field "detursache" has value "<detursache>"
Then field "rueckmge" has value "<rueckmge>"
Then field "rueckgmge" has value "<rueckgmge>"
Then field "platz" has value "<platz>"
Then field "verwla" has value "<verwendung>"
Then field "rueckorig^id" has value equal to field "id" from editor "<umeditor>"
Then field "bewmgekorrektur" has value "ja"
Then the table has 0 rows
And I close the current editor

Examples:
    | select                                                                              | editor         | buart  | rueckmge | rueckgmge | verwendung | platz | detursache                                   | umeditor     |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;verwla==puky_01;rueckmge==-10;    | JournalUmAb1-2 | Abgang | -10      | -5        | puky_01    | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb1 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;verwla==puky_02;rueckmge==-10;    | JournalUmZu1-2 | Zugang | -10      | -5        | puky_02    | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu1 |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;verwla==puky_01;rueckmge==-60;    | JournalUmAb2-2 | Abgang | -60      | -30       | puky_01    | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb2 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;verwla==puky_02;rueckmge==-60;    | JournalUmZu2-2 | Zugang | -60      | -30       | puky_02    | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu2 |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;verwla==puky_01;rueckmge==-58;    | JournalUmAb3-2 | Abgang | -58      | -29       | puky_01    | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb3 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;verwla==puky_03;rueckmge==-58;    | JournalUmZu3-2 | Zugang | -58      | -29       | puky_03    | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu3 |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;verwla==puky_01;rueckmge==-42;    | JournalUmAb4-2 | Abgang | -42      | -21       | puky_01    | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb4 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;verwla==puky_03;rueckmge==-42;    | JournalUmZu4-2 | Zugang | -42      | -21       | puky_03    | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu4 |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;verwla==puky_02;rueckmge==-60;    | JournalUmAb5-2 | Abgang | -60      | -30       | puky_02    | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb5 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;verwla==puky_rueck;rueckmge==-60; | JournalUmZu5-2 | Zugang | -60      | -30       | puky_rueck | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu5 |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;verwla==puky_02;rueckmge==-10;    | JournalUmAb5-3 | Abgang | -10      | -5        | puky_02    | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb5 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;verwla==puky_rueck;rueckmge==-10; | JournalUmZu5-3 | Zugang | -10      | -5        | puky_rueck | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu5 |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;verwla==puky_03;rueckmge==-58;    | JournalUmAb6-2 | Abgang | -58      | -29       | puky_03    | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb6 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;verwla==puky_rueck;rueckmge==-58; | JournalUmZu6-2 | Zugang | -58      | -29       | puky_rueck | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu6 |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;verwla==puky_03;rueckmge==-42;    | JournalUmAb6-3 | Abgang | -42      | -21       | puky_03    | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb6 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;verwla==puky_rueck;rueckmge==-42; | JournalUmZu6-3 | Zugang | -42      | -21       | puky_rueck | WELA  | Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu6 |


Scenario: 05-4 Platzmengen pruefen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat,verw" from StorageQuantity for Product "RAD-05" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id         | beworig^id     | bewdat     | verw       |
    | 30     | Stück  | !JournalUmZu5^id | !JournalZu1^id | 12.01.1995 | 30     | !JournalUmZu5^id | !JournalZu1^id | 12.01.1995 | puky_rueck |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 06-1 Vollstaendige Ruecklieferung des Zugangs stornieren
Given I set the fake date to "20.1.95"
Given I open an editor "StornoRueck" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung"
And I set fields
    | nummer | 5strueck |
And I save the current editor


# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu1"
Then field "rueckgmge" has value "0"
Then field "rueckmge" has value "0"
Then field "verwla" has value "puky_01"
Then field "verw" has value "puky_01"
And I close the current editor

Given I open an editor "JournalRueck1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalRueck1"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "rueckgmge" has value "-85"
Then field "rueckmge" has value "-170"
Then field "storniert" has value "ja"
Then field "verwla" has value "puky_rueck"
Then field "verw" has value "puky_rueck"
And I close the current editor

Given I open an editor "JournalStorno1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;platz==WELA;detursache==Storno-Rücklieferung Einkauf;"
Then field "gmge" has value "85"
Then field "mge" has value "170"
Then field "platz" has value "WELA"
Then field "verwla" has value "puky_rueck"
Then field "verw" has value "puky_rueck"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck1"
And I close the current editor


Scenario Outline: 06-2 Journaleintraege zu Umbuchungen pruefen
Given I open an editor "<editor>" from table "(Journal):(Journal)" with command "VIEW" for record from editor "<editor>"
Then field "buarta" has value "<buart>"
Then field "rueckmge" has value "<rueckmge>"
Then field "rueckgmge" has value "<rueckgmge>"
Then field "platz" has value "<platz>"
Then field "verwla" has value "<verwendung>"
Then field "storniert" has value "ja"
Then field "bewmgekorrektur" has value "ja"
Then the table has 0 rows
And I close the current editor

Examples:
    | editor          | buart  | rueckmge | rueckgmge | platz | verwendung |
    | JournalUmAb1-2  | Abgang | -10      | -5        | WELA  | puky_01    |
    | JournalUmZu1-2  | Zugang | -10      | -5        | WELA  | puky_02    |
    | JournalUmAb2-2  | Abgang | -60      | -30       | WELA  | puky_01    |
    | JournalUmZu2-2  | Zugang | -60      | -30       | WELA  | puky_02    |
    | JournalUmAb3-2  | Abgang | -58      | -29       | WELA  | puky_01    |
    | JournalUmZu3-2  | Zugang | -58      | -29       | WELA  | puky_03    |
    | JournalUmAb4-2  | Abgang | -42      | -21       | WELA  | puky_01    |
    | JournalUmZu4-2  | Zugang | -42      | -21       | WELA  | puky_03    |
    | JournalUmAb5-2  | Abgang | -60      | -30       | WELA  | puky_02    |
    | JournalUmZu5-2  | Zugang | -60      | -30       | WELA  | puky_rueck |
    | JournalUmAb5-3  | Abgang | -10      | -5        | WELA  | puky_02    |
    | JournalUmZu5-3  | Zugang | -10      | -5        | WELA  | puky_rueck |
    | JournalUmAb6-2  | Abgang | -58      | -29       | WELA  | puky_03    |
    | JournalUmZu6-2  | Zugang | -58      | -29       | WELA  | puky_rueck |
    | JournalUmAb6-3  | Abgang | -42      | -21       | WELA  | puky_03    |
    | JournalUmZu6-3  | Zugang | -42      | -21       | WELA  | puky_rueck |


Scenario Outline: 05-3 Zugangsjournaleintraege zur Bewertungsmengenkorrketur bei Storno pruefen
Given I open an editor "<editor>" from table "(Journal):(Journal)" with command "VIEW" for record "<select>"
Then field "buarta" has value "<buart>"
Then field "detursache" has value "<detursache>"
Then field "mge" has value "<mge>"
Then field "gmge" has value "<gmge>"
Then field "platz" has value "<platz>"
Then field "verwla" has value "<verwendung>"
Then field "stornolj^id" has value equal to field "id" from editor "<umeditor>"
Then field "bewmgekorrektur" has value "ja"
Then the table has 0 rows
And I close the current editor

Examples:
    | select                                                                                         | editor          | buart  | mge | gmge | verwendung | platz | detursache                                          | umeditor       |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;stornolj<>`;verwla==puky_01;rueckmge==10;    | JournalUmAb1-2s | Abgang | 10  | 5    | puky_01    | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb1-2 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;stornolj<>`;verwla==puky_02;rueckmge==10;    | JournalUmZu1-2s | Zugang | 10  | 5    | puky_02    | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu1-2 |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;stornolj<>`;verwla==puky_01;rueckmge==60;    | JournalUmAb2-2s | Abgang | 60  | 30   | puky_01    | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb2-2 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;stornolj<>`;verwla==puky_02;rueckmge==60;    | JournalUmZu2-2s | Zugang | 60  | 30   | puky_02    | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu2-2 |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;stornolj<>`;verwla==puky_01;rueckmge==58;    | JournalUmAb3-2s | Abgang | 58  | 29   | puky_01    | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb3-2 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;stornolj<>`;verwla==puky_03;rueckmge==58;    | JournalUmZu3-2s | Zugang | 58  | 29   | puky_03    | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu3-2 |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;stornolj<>`;verwla==puky_01;rueckmge==42;    | JournalUmAb4-2s | Abgang | 42  | 21   | puky_01    | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb4-2 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;stornolj<>`;verwla==puky_03;rueckmge==42;    | JournalUmZu4-2s | Zugang | 42  | 21   | puky_03    | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu4-2 |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;stornolj<>`;verwla==puky_02;rueckmge==60;    | JournalUmAb5-2s | Abgang | 60  | 30   | puky_02    | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb5-2 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;stornolj<>`;verwla==puky_rueck;rueckmge==60; | JournalUmZu5-2s | Zugang | 60  | 30   | puky_rueck | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu5-2 |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;stornolj<>`;verwla==puky_02;rueckmge==10;    | JournalUmAb5-3s | Abgang | 10  | 5    | puky_02    | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb5-3 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;stornolj<>`;verwla==puky_rueck;rueckmge==10; | JournalUmZu5-3s | Zugang | 10  | 5    | puky_rueck | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu5-3 |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;stornolj<>`;verwla==puky_03;rueckmge==58;    | JournalUmAb6-2s | Abgang | 58  | 29   | puky_03    | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb6-2 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;stornolj<>`;verwla==puky_rueck;rueckmge==58; | JournalUmZu6-2s | Zugang | 58  | 29   | puky_rueck | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu6-2 |
    | $,,artikel==RAD-05;buarta==Abgang;redrueckorig<>`;stornolj<>`;verwla==puky_03;rueckmge==42;    | JournalUmAb6-3s | Abgang | 42  | 21   | puky_03    | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmAb6-3 |
    | $,,artikel==RAD-05;buarta==Zugang;redrueckorig<>`;stornolj<>`;verwla==puky_rueck;rueckmge==42; | JournalUmZu6-3s | Zugang | 42  | 21   | puky_rueck | WELA  | Storno-Bewertungsmengenkorrektur Manuelle Umbuchung | JournalUmZu6-3 |


Scenario: Abgangsjournaleintraege mit Tabelle nach Bewertungsmengenkorrketur bei Storno pruefen
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb1"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "rueckmge" has value "0"
Then field "rueckgmge" has value "0"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 40  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 40     | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I open an editor "JournalUmAb2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb2"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "rueckmge" has value "0"
Then field "rueckgmge" has value "0"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 60  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 60     | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I open an editor "JournalUmAb3" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb3"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "rueckmge" has value "0"
Then field "rueckgmge" has value "0"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 58  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 58     | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I open an editor "JournalUmAb4" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb4"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "rueckmge" has value "0"
Then field "rueckgmge" has value "0"
Then field "platz" has value "WELA"
Then field "verwla" has value "puky_01"
Then field "verw" has value "puky_01"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 42  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 42     | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I open an editor "JournalUmAb5" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb5"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "rueckmge" has value "0"
Then field "rueckgmge" has value "0"
Then field "platz" has value "WELA"
Then field "verwla" has value "puky_02"
Then field "verw" has value "puky_02"
Then table has values
    | mge | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id         | beworig^id     | bewdat     |
    | 40  | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 | 40     | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 |
    | 60  | !JournalUmZu2^id | !JournalZu1^id | 12.01.1995 | 60     | !JournalUmZu2^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I open an editor "JournalUmAb6" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb6"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "rueckmge" has value "0"
Then field "rueckgmge" has value "0"
Then field "platz" has value "WELA"
Then field "verwla" has value "puky_03"
Then field "verw" has value "puky_03"
Then table has values
    | mge | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id         | beworig^id     | bewdat     |
    | 42  | !JournalUmZu4^id | !JournalZu1^id | 12.01.1995 | 42     | !JournalUmZu4^id | !JournalZu1^id | 12.01.1995 |
    | 58  | !JournalUmZu3^id | !JournalZu1^id | 12.01.1995 | 58     | !JournalUmZu3^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor


Scenario: 06-5 Platmengen pruefen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat,verw" from StorageQuantity for Product "RAD-05" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id              | orig^id        | verfdat    | bewmge | bewlj^id           | beworig^id     | bewdat     | verw       |
    | 30     | Stück  | !JournalUmZu5^id   | !JournalZu1^id | 12.01.1995 | 30     | !JournalUmZu5^id   | !JournalZu1^id | 12.01.1995 | puky_rueck |
    | 10     | Stück  | !JournalUmZu5^id   | !JournalZu1^id | 12.01.1995 | 10     | !JournalUmZu5^id   | !JournalZu1^id | 12.01.1995 | puky_rueck |
    | 60     | Stück  | !JournalUmZu5^id   | !JournalZu1^id | 12.01.1995 | 60     | !JournalUmZu5^id   | !JournalZu1^id | 12.01.1995 | puky_rueck |
    | 58     | Stück  | !JournalUmZu6^id   | !JournalZu1^id | 12.01.1995 | 58     | !JournalUmZu6^id   | !JournalZu1^id | 12.01.1995 | puky_rueck |
    | 42     | Stück  | !JournalUmZu6^id   | !JournalZu1^id | 12.01.1995 | 42     | !JournalUmZu6^id   | !JournalZu1^id | 12.01.1995 | puky_rueck |
