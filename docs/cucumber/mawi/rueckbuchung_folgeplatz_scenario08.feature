# *****************************************************************************
#  Name             : rueckbuchung_folgeplatz_scenario08.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Ruecklieferung vom Folgeplatz
#
# Testszenario:
#  - Zugang EK-Rechnung mit Lagerbewegung auf Platz WELA
#  - Umlagerung auf Platz L3F1 mit Transportkosten
#  - Ruecklieferung des Zugangs von L3F1
#  - Abgang von L3F1 (Menge > verbleibende Menge)
#  - Storno der Ruecklieferung
#
# Testet auch BW2-1304/FDA-1906 - additive Kosten bei RB vom Folgeplatz
# *****************************************************************************
@persistent
Feature: rueckbuchung_folgeplatz_scenario08.feature
Background:
Given I set the fake date to "12.01.95"

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 01 Artikel kopieren
Given I open an editor "RAD-08" from table "(Part):(Product)" with command "COPY" for record "RAD"
And I set field "such" to "RAD-08"
And I set field "chverfolgung" to ""
# Bewertungsverfahren "Preis des Zugangs/Vorgangspreis"
And I set field "ekbewverf" to "5"
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 02 Rad einkaufen
Given I open an editor "RechnungmLZu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 8zu      |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang08 |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | he   | preis | platz |
    | RAD-08  | 100 | Paar | 10.00 | WELA  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-08;buarta==Zugang;platz==WELA;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "100"
Then field "mge" has value "200"
And I close the current editor


# Platzmengen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "RAD-08" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 200    | Stück  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 200    | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |


# Bewertung
Given I open latest Valuation "BewertungZu1-1" for Product "RAD-08" and valuation transaction "JournalZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 200  | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 03 Umlagerung ueber Umlagerungsrechnung mit Transportkosten
Given I set the fake date to "13.1.95"
Given I open an editor "RechnungmLUm1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 8um1         |
    | bsart    | Umlagern     |
    | lief     | PUKY         |
    | vom      | .            |
    | ebeleg   | Umlagern08   |
    | ueb      | ja           |
    | fakt     | ja           |
    | erfwaehr | DEM          |
And I append rows
    | artikel | mge | he   | preis | abplatz | platz |
    | RAD-08  | 100 | Paar |  2.00 | WELA    | L3F1  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Journaleintraege
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-08;buarta==Abgang;detursache==Umlagerungsrechnung Einkauf;platz==WELA;budat==13.1.95;"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "buarta" has value "Abgang"
Then field "platz" has value "WELA"
Then field "gmge" has value "100"
Then field "mge" has value "200"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 200 | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 200    | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-08;buarta==Zugang;detursache==Umlagerungsrechnung Einkauf;platz==L3F1;budat==13.1.95;"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "buarta" has value "Zugang"
Then field "platz" has value "L3F1"
Then field "gmge" has value "100"
Then field "mge" has value "200"
And I close the current editor


# Platzmengen
Given I query StorageQuantity for Product "RAD-08" on StorageLocation "WELA"
Then StorageQuantity is zero

Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "RAD-08" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id         | beworig^id     | bewdat     |
    | 200    | Stück  | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 | 200    | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 |


# Bewertungen
Given I open latest Valuation "BewertungUmAb1-1" for Product "RAD-08" and valuation transaction "JournalUmAb1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb1"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 200  | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmZu1-1" for Product "RAD-08" and valuation transaction "JournalUmZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu1"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 200  | !JournalZu1^id | !JournalZu1^id | 6.0000 | 1.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 04 Ruecklieferung des Zugangs
Given I set the fake date to "14.1.95"

Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set fields
    | nummer   | 8rueck     |
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

Given I open an editor "JournalRueck1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-08;buarta==Zugang;platz==L3F1;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "L3F1"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "rueckgmge" has value "-100"
Then field "rueckmge" has value "-200"
And I close the current editor

Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb1"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "buarta" has value "Abgang"
Then field "platz" has value "WELA"
Then field "rueckgmge" has value "100"
Then field "rueckmge" has value "200"
Then the table has 0 rows
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu1"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "buarta" has value "Zugang"
Then field "platz" has value "L3F1"
Then field "rueckgmge" has value "100"
Then field "rueckmge" has value "200"
And I close the current editor


# Journaleintraege Bewertungsmengenkorrektur
Given I open an editor "JournalUmAbBmk1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-08;buarta==Abgang;detursache==Bewertungsmengenkorrektur Umlagerungsrechnung Einkauf;platz==WELA;budat==14.1.95;"
Then field "detursache" has value "Bewertungsmengenkorrektur Umlagerungsrechnung Einkauf"
Then field "buarta" has value "Abgang"
Then field "platz" has value "WELA"
Then field "rueckgmge" has value "-100"
Then field "rueckmge" has value "-200"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalUmAb1"
Then field "redrueckorig^id" has value equal to field "id" from editor "JournalRueck1"
Then field "redorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "redbeworig^id" has value equal to field "id" from editor "JournalZu1"
And I close the current editor

Given I open an editor "JournalUmZuBmk1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-08;buarta==Zugang;detursache==Bewertungsmengenkorrektur Umlagerungsrechnung Einkauf;platz==L3F1;budat==14.1.95;"
Then field "detursache" has value "Bewertungsmengenkorrektur Umlagerungsrechnung Einkauf"
Then field "buarta" has value "Zugang"
Then field "platz" has value "L3F1"
Then field "rueckgmge" has value "-100"
Then field "rueckmge" has value "-200"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalUmZu1"
Then field "redrueckorig^id" has value equal to field "id" from editor "JournalRueck1"
Then field "redorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "redbeworig^id" has value equal to field "id" from editor "JournalZu1"
And I close the current editor


# Platzmengen
Given I query StorageQuantity for Product "RAD-08" on StorageLocation "WELA"
Then StorageQuantity is zero

Given I query StorageQuantity for Product "RAD-08" on StorageLocation "L3F1"
Then StorageQuantity is zero


# Bewertungen
Given I open latest Valuation "BewertungZu1-2" for Product "RAD-08" and valuation transaction "JournalZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck1"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 0    | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmAb1-2" for Product "RAD-08" and valuation transaction "JournalUmAb1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb1"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalUmAbBmk1"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 0    | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmZu1-2" for Product "RAD-08" and valuation transaction "JournalUmZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu1"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalUmZuBmk1"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr  | addkosten |
    | 0    | !JournalZu1^id | !JournalZu1^id | 6.0000  | 1.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 05 Abgang von L3F1 fuer Artikel RAD-08
Given I set the fake date to "16.1.95"

Given I open an editor "VkLieferschein1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | nummer   | 8abgang      |
    | kunde    | RADSHOP      |
    | ueb      | ja           |
And I append rows
    | artikel | mge | he   | preis | platz |
    | RAD-08  | 50  | Paar | 20.00 | L3F1  |
And I save the current editor


# Journaleintrag Abgang
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-08;buarta==Abgang;detursache==Lieferschein Verkauf;platz==L3F1;budat==16.1.95;"
Then field "detursache" has value "Lieferschein Verkauf"
Then field "buarta" has value "Abgang"
Then field "platz" has value "L3F1"
Then field "gmge" has value "50"
Then field "mge" has value "100"
Then the table has 0 rows
And I close the current editor

# Platzmenge
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "RAD-08" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id          | orig^id | verfdat    | bewmge | bewlj^id       | beworig^id | bewdat     |
    | -100   | Stück  | !JournalAb1^id | (0,0,0) | 16.01.1995 | -100   | !JournalAb1^id | (0,0,0)    | 16.01.1995 |


# Bewertung
Given I open latest Valuation "BewertungAb1-1" for Product "RAD-08" and valuation transaction "JournalAb1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalAb1"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr  | addkosten |
    | 100  | (0,0,0)        | (0,0,0)        | 6.0000  | 0.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 06 Teil-Ruecklieferung des Zugangs stornieren
Given I set the fake date to "20.1.95"
Given I open an editor "StornoRueck" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung"
And I set fields
    | nummer | 8strueck |
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

Given I open an editor "JournalStorno1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-08;buarta==Zugang;platz==L3F1;detursache==Storno-Rücklieferung Einkauf;"
Then field "gmge" has value "100"
Then field "mge" has value "200"
Then field "platz" has value "L3F1"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck1"
And I close the current editor

# Journaleintraege Umlagerung
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb1"
Then field "rueckgmge" has value "0"
Then field "rueckmge" has value "0"
Then table has values
    | mge | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 200 | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 200    | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu1"
Then field "rueckgmge" has value "0"
Then field "rueckmge" has value "0"
And I close the current editor


# Journaleintraege Bewertungsmengenkorrektur und Storno-Bewertungsmengenkorrektur
Given I open an editor "JournalUmAbBmk1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAbBmk1"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalUmZuBmk1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZuBmk1"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalUmAbSBmk1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-08;buarta==Abgang;detursache==Storno-Bewertungsmengenkorrektur Umlagerungsrechnung Ek;platz==WELA;budat==20.1.95;"
Then field "detursache" has value "Storno-Bewertungsmengenkorrektur Umlagerungsrechnung Ek"
Then field "gmge" has value "100"
Then field "mge" has value "200"
Then field "stornolj^id" has value equal to field "id" from editor "JournalUmAbBmk1"
And I close the current editor

Given I open an editor "JournalUmZuSBmk1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-08;buarta==Zugang;detursache==Storno-Bewertungsmengenkorrektur Umlagerungsrechnung Ek;platz==L3F1;budat==20.1.95;"
Then field "detursache" has value "Storno-Bewertungsmengenkorrektur Umlagerungsrechnung Ek"
Then field "gmge" has value "100"
Then field "mge" has value "200"
Then field "stornolj^id" has value equal to field "id" from editor "JournalUmZuBmk1"
And I close the current editor


# Journaleintrag Abgang
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalAb1"
Then field "gmge" has value "50"
Then field "mge" has value "100"
Then table has values
    | mge | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id         | beworig^id     | bewdat     |
    | 100 | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 | 100    | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor


# Platzmengen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "RAD-08" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id         | beworig^id     | bewdat     |
    | 100    | Stück  | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 | 100    | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 |


# Bewertungen
Given I open latest Valuation "BewertungZu1-3" for Product "RAD-08" and valuation transaction "JournalZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "stornoverur^id" has value equal to field "id" from editor "JournalStorno1"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 200  | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmAb1-3" for Product "RAD-08" and valuation transaction "JournalUmAb1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb1"
Then field "stornoverur^id" has value equal to field "id" from editor "JournalUmAbSBmk1"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 200  | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmZu1-3" for Product "RAD-08" and valuation transaction "JournalUmZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu1"
Then field "stornoverur^id" has value equal to field "id" from editor "JournalUmZuSBmk1"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 200  | !JournalZu1^id | !JournalZu1^id | 6.0000 | 1.0000    |
And I close the current editor

# Nachbewerten, damit die Abgangsbewertung vervollstaendigt wird
And I run Revaluation

# Abgangsbewertung
Given I open latest Valuation "BewertungAb1-2" for Product "RAD-08" and valuation transaction "JournalAb1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalAb1"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 100  | !JournalZu1^id | !JournalZu1^id | 6.0000 | 0.0000    |
And I close the current editor

# Andere Bewertungen sollen keinen Nachfolger bekommen
Given I open an editor "BewertungZu1-3" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungZu1-3"
Then field "nachfolger" is empty
And I close the current editor

Given I open an editor "BewertungUmAb1-3" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmAb1-3"
Then field "nachfolger" is empty
And I close the current editor

Given I open an editor "BewertungUmZu1-3" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmZu1-3"
Then field "nachfolger" is empty
And I close the current editor

