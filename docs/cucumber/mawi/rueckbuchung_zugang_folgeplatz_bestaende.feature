# *****************************************************************************
#  Name             : rueckbuchung_zugang_folgeplatz_bestaende.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Bestaende in Journaleintraegen zur Bewertungsmengenkorrektur
#                     nach Rueckbuchung und Storno-Rueckbuchung
#
# Getestet wird das Scenario:
#  - Zugang EK-Rechnung mit Lagerbewegung (150 Paar auf WELA, Preis 10.00)
#  - Umbuchung auf Platz ZLQM, 125 Paar
#  - Ruecklieferung auf Zugang (-60 Paar von WELA)
#  - Ruecklieferung auf Zugang (-80 Paar von ZLQM)
#  - Storno der zweiten Ruecklieferung
#  - Storno der ersten Ruecklieferung
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_zugang_folgeplatz_bestaende.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: 01 Artikel kopieren
Given I open an editor "RAD-03" from table "(Part):(Product)" with command "COPY" for record "RAD"
And I set field "such" to "RAD-03"
And I set field "chverfolgung" to ""
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
    | RAD-03  | 150 | Paar | 10.00 | WELA  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Journaleintraege pruefen
Given I open an editor "JournalZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "150"
Then field "mge" has value "300"
Then field "bestand" has value "300"
Then field "lgrbest" has value "300"
Then field "artbest" has value "300"
And I close the current editor


# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-03" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 300    | Stück  | !JournalZu^id | !JournalZu^id | 300    | !JournalZu^id | !JournalZu^id |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 03 125 Paar umlagern nach ZLQM
Given I transfer StorageQuantity of "125" "Paar" for Product "RAD-03" from StorageLocation "WELA" to "ZLQM" with document "3Um-01"


# Journaleintraege pruefen
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Abgang;detursache==Manuelle Umbuchung;such==L3UM-01;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "125"
Then field "mge" has value "250"
Then field "platz" has value "WELA"
Then field "bestand" has value "50"
Then field "lgrbest" has value "300"
Then field "artbest" has value "300"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 250 | !JournalZu^id | !JournalZu^id | 250    | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;detursache==Manuelle Umbuchung;such==L3UM-01;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "125"
Then field "mge" has value "250"
Then field "platz" has value "ZLQM"
Then field "bestand" has value "250"
Then field "lgrbest" has value "300"
Then field "artbest" has value "300"
And I close the current editor


# Platzmengen pruefen
Given I query StorageQuantity for Product "RAD-03" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 50     | Stück  | !JournalZu^id | !JournalZu^id | 50     | !JournalZu^id | !JournalZu^id |

Given I query StorageQuantity for Product "RAD-03" on StorageLocation "ZLQM"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id    |
    | 250    | Stück  | !JournalUmZu1^id | !JournalZu^id  | 250    | !JournalUmZu1^id | !JournalZu^id |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 04 Ruecklieferung auf Zugang von Orignialplatz
Given I open an editor "Ruecklieferung1" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set field "nummer" to "3rueck1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-60" in row 1
And I set field "he" to "Paar" in row 1
And I save the current editor


# Journaleintraege pruefen
Given I open an editor "JournalRueck1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "-60"
Then field "mge" has value "-120"
Then field "platz" has value "WELA"
Then field "bestand" has value "-70"
Then field "lgrbest" has value "180"
Then field "artbest" has value "180"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu"
And I close the current editor


# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-03" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id | bewmge | bewlj^id         | beworig^id |
    | -70    | Stück  | !JournalUmAb1^id | (0,0,0) | -70    | !JournalUmAb1^id | (0,0,0)    |

Given I query StorageQuantity for Product "RAD-03" on StorageLocation "ZLQM"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id    |
    | 180    | Stück  | !JournalUmZu1^id | !JournalZu^id  | 180    | !JournalUmZu1^id | !JournalZu^id |
    | 70     | Stück  | !JournalUmZu1^id | (0,0,0)        | 70     | !JournalUmZu1^id | (0,0,0)       |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 05 Ruecklieferung auf Zugang von Folgeplatz
Given I open an editor "Ruecklieferung2" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set field "nummer" to "3rueck2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-80" in row 1
And I set field "he" to "Paar" in row 1
And I set field "platz" to "ZLQM" in row 1
And I save the current editor


# Journaleintraege pruefen
Given I open an editor "JournalRueck2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;detursache==Rücklieferung Einkauf;platz==ZLQM"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "-80"
Then field "mge" has value "-160"
Then field "platz" has value "ZLQM"
Then field "bestand" has value "90"
Then field "lgrbest" has value "20"
Then field "artbest" has value "20"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu"
And I close the current editor


# Journaleintraege Bewertungsmengenkorrektur
Given I open an editor "JournalBmkUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Abgang;detursache==Bewertungsmengenkorrektur Manuelle Umbuchung;such==L3UM-01;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "-80"
Then field "mge" has value "-160"
Then field "platz" has value "WELA"
Then field "bestand" has value "-70"
Then field "lgrbest" has value "20"
Then field "artbest" has value "20"
And I close the current editor

Given I open an editor "JournalBmkUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;detursache==Bewertungsmengenkorrektur Manuelle Umbuchung;such==L3UM-01;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "-80"
Then field "mge" has value "-160"
Then field "platz" has value "ZLQM"
Then field "bestand" has value "90"
Then field "lgrbest" has value "20"
Then field "artbest" has value "20"
And I close the current editor


# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-03" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id | bewmge | bewlj^id         | beworig^id |
    | -70    | Stück  | !JournalUmAb1^id | (0,0,0) | -70    | !JournalUmAb1^id | (0,0,0)    |

Given I query StorageQuantity for Product "RAD-03" on StorageLocation "ZLQM"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id    |
    | 20     | Stück  | !JournalUmZu1^id | !JournalZu^id  | 20     | !JournalUmZu1^id | !JournalZu^id |
    | 70     | Stück  | !JournalUmZu1^id | (0,0,0)        | 70     | !JournalUmZu1^id | (0,0,0)       |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 06 Zweite Ruecklieferung stornieren
Given I open an editor "RueckStorno2" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung2"
And I set field "nummer" to "3storno2"
And I save the current editor


# Journaleintraege pruefen
Given I open an editor "JournalStorno2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;detursache==Storno-Rücklieferung Einkauf;platz==ZLQM"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "80"
Then field "mge" has value "160"
Then field "platz" has value "ZLQM"
Then field "bestand" has value "250"
Then field "lgrbest" has value "180"
Then field "artbest" has value "180"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck2"
And I close the current editor


# Journaleintraege Storno-Bewertungsmengenkorrektur
Given I open an editor "JournalSBmkUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Abgang;detursache==Storno-Bewertungsmengenkorrektur Manuelle Umbuchung;such==L3UM-01;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "80"
Then field "mge" has value "160"
Then field "platz" has value "WELA"
Then field "bestand" has value "-70"
Then field "lgrbest" has value "180"
Then field "artbest" has value "180"
And I close the current editor

Given I open an editor "JournalSBmkUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;detursache==Storno-Bewertungsmengenkorrektur Manuelle Umbuchung;such==L3UM-01;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "80"
Then field "mge" has value "160"
Then field "platz" has value "ZLQM"
Then field "bestand" has value "250"
Then field "lgrbest" has value "180"
Then field "artbest" has value "180"
And I close the current editor


# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-03" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id | bewmge | bewlj^id         | beworig^id |
    | -70    | Stück  | !JournalUmAb1^id | (0,0,0) | -70    | !JournalUmAb1^id | (0,0,0)    |

Given I query StorageQuantity for Product "RAD-03" on StorageLocation "ZLQM"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id    |
    | 20     | Stück  | !JournalUmZu1^id | !JournalZu^id  | 20     | !JournalUmZu1^id | !JournalZu^id |
    | 70     | Stück  | !JournalUmZu1^id | (0,0,0)        | 70     | !JournalUmZu1^id | (0,0,0)       |
    | 160    | Stück  | !JournalUmZu1^id | !JournalZu^id  | 160    | !JournalUmZu1^id | !JournalZu^id |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 06 Erste Ruecklieferung stornieren
Given I open an editor "RueckStorno1" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung1"
And I set field "nummer" to "3storno1"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalStorno1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-03;buarta==Zugang;detursache==Storno-Rücklieferung Einkauf;platz==WELA"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "60"
Then field "mge" has value "120"
Then field "platz" has value "WELA"
Then field "bestand" has value "50"
Then field "lgrbest" has value "300"
Then field "artbest" has value "300"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck1"
And I close the current editor


# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-03" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 50     | Stück  | !JournalZu^id | !JournalZu^id | 50     | !JournalZu^id | !JournalZu^id |

Given I query StorageQuantity for Product "RAD-03" on StorageLocation "ZLQM"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id    |
    | 20     | Stück  | !JournalUmZu1^id | !JournalZu^id  | 20     | !JournalUmZu1^id | !JournalZu^id |
    | 70     | Stück  | !JournalUmZu1^id | !JournalZu^id  | 70     | !JournalUmZu1^id | !JournalZu^id |
    | 160    | Stück  | !JournalUmZu1^id | !JournalZu^id  | 160    | !JournalUmZu1^id | !JournalZu^id |
