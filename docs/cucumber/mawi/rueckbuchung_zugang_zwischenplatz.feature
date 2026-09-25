# *****************************************************************************
#  Name             : rueckbuchung_zugang_zwischenplatz.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Rueckbuchung und Storno-Rueckbuchung
#                     nach mehreren Umlagerungen und Rueckbuchung von
#                     einem Zwischenplatz, auf dem die Menge einmal lag
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_zugang_zwischenplatz.feature
Background:
Given I set the fake date to "12.01.95"

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 01 Artikel kopieren
Given I open an editor "FAHRRAD-01" from table "(Part):(Product)" with command "COPY" for record "FAHRRAD"
And I set field "such" to "FAHRRAD-01"
And I set field "chverfolgung" to ""
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 02 Fertigung fuer FAHRRAD-01, Rueckmeldung auf letzten Arbeitsgang
# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel    | netmge | bisuch   | mfreig |
    | FAHRRAD-01 | 100    | RBPLATZ_ | ja     |
And I press button "mzsubm" to open a subeditor for "MZFertig" in row 1
And I delete all rows
And I append rows
    | zuomge |
    | 24     |
    | 26     |
And I save the current editor
And I switch the current editor to editor "fvor"
And I set field "bisuch" to "RBPLATZ01_" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor


# Rueckmeldung auf letzten Arbeitsgang
Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RBPLATZ01_002"
And I set field "sofort" to "1"
And I set field "gutmge" to "50" in row 1
And I set field "erbtext1" to "Rueckmeldung1" in row 1
And I save the current editor


# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==MLF01;mge==24"
Then field "detursache" has value "Rückmeldung Fertigung"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "24"
Then field "mge" has value "24"
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==MLF01;mge==26"
Then field "detursache" has value "Rückmeldung Fertigung"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "26"
Then field "mge" has value "26"
And I close the current editor


# Platzmengen
Given I query StorageQuantity for Product "FAHRRAD-01" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 24     | Stück  | !JournalZu1^id | !JournalZu1^id | 24     | !JournalZu1^id | !JournalZu1^id |
    | 26     | Stück  | !JournalZu2^id | !JournalZu2^id | 26     | !JournalZu2^id | !JournalZu2^id |


# Bewertungen
Given I open latest Valuation "BewertungZu1-1" for Product "FAHRRAD-01" and valuation transaction "JournalZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 24   | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open latest Valuation "BewertungZu2-1" for Product "FAHRRAD-01" and valuation transaction "JournalZu2" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu2"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 26   | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 03 Bestaende umbuchen von MLF01 nach ZLQM
And I transfer StorageQuantity of "40" for Product "FAHRRAD-01" from StorageLocation "MLF01" to "ZLQM" with document "1um01"
And I transfer StorageQuantity of "10" for Product "FAHRRAD-01" from StorageLocation "MLF01" to "ZLQM" with document "1um02"


# Journaleintraege Umbuchung
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Abgang;platz==MLF01;mge==40"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "buarta" has value "Abgang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "40"
Then field "mge" has value "40"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
	| 24  | !JournalZu1^id | !JournalZu1^id | 24     | !JournalZu1^id | !JournalZu1^id |
    | 16  | !JournalZu2^id | !JournalZu2^id | 16     | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==ZLQM;mge==40"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ZLQM"
Then field "gmge" has value "40"
Then field "mge" has value "40"
And I close the current editor

Given I open an editor "JournalUmAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Abgang;platz==MLF01;mge==10"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "buarta" has value "Abgang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "10"
Then field "mge" has value "10"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 10  | !JournalZu2^id | !JournalZu2^id | 10     | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open an editor "JournalUmZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==ZLQM;mge==10"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ZLQM"
Then field "gmge" has value "10"
Then field "mge" has value "10"
And I close the current editor


# Platzmengen
Given I query StorageQuantity for Product "FAHRRAD-01" on StorageLocation "ZLQM"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id     |
    | 24     | Stück  | !JournalUmZu1^id | !JournalZu1^id | 24     | !JournalUmZu1^id | !JournalZu1^id |
    | 16     | Stück  | !JournalUmZu1^id | !JournalZu2^id | 16     | !JournalUmZu1^id | !JournalZu2^id |
    | 10     | Stück  | !JournalUmZu2^id | !JournalZu2^id | 10     | !JournalUmZu2^id | !JournalZu2^id |



# Umlagerungsbewertungen
Given I open latest Valuation "BewertungUmAb1-1" for Product "FAHRRAD-01" and valuation transaction "JournalUmAb1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb1"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 24   | !JournalZu1^id | !JournalZu1^id |
    | 16   | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open latest Valuation "BewertungUmZu1-1" for Product "FAHRRAD-01" and valuation transaction "JournalUmZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu1"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 24   | !JournalZu1^id | !JournalZu1^id |
    | 16   | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open latest Valuation "BewertungUmAb2-1" for Product "FAHRRAD-01" and valuation transaction "JournalUmAb2" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb2"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 10   | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open latest Valuation "BewertungUmZu2-1" for Product "FAHRRAD-01" and valuation transaction "JournalUmZu2" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu2"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 10   | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 04 Weitere Umbuchung von ZLQM nach ABLA
And I transfer StorageQuantity of "50" for Product "FAHRRAD-01" from StorageLocation "ZLQM" to "ABLA" with document "1um03"


# Journaleintraege Umbuchung
Given I open an editor "JournalUmAb3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Abgang;platz==ZLQM;mge==50"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "buarta" has value "Abgang"
Then field "platz" has value "ZLQM"
Then field "gmge" has value "50"
Then field "mge" has value "50"
Then table has values
    | mge | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id     |
	| 24  | !JournalUmZu1^id | !JournalZu1^id | 24     | !JournalUmZu1^id | !JournalZu1^id |
    | 16  | !JournalUmZu1^id | !JournalZu2^id | 16     | !JournalUmZu1^id | !JournalZu2^id |
    | 10  | !JournalUmZu2^id | !JournalZu2^id | 10     | !JournalUmZu2^id | !JournalZu2^id |
And I close the current editor

Given I open an editor "JournalUmZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==ABLA;mge==50"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ABLA"
Then field "gmge" has value "50"
Then field "mge" has value "50"
And I close the current editor


# Platzmengen
Given I query StorageQuantity for Product "FAHRRAD-01" on StorageLocation "ABLA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id     |
    | 24     | Stück  | !JournalUmZu3^id | !JournalZu1^id | 24     | !JournalUmZu3^id | !JournalZu1^id |
    | 16     | Stück  | !JournalUmZu3^id | !JournalZu2^id | 16     | !JournalUmZu3^id | !JournalZu2^id |
    | 10     | Stück  | !JournalUmZu3^id | !JournalZu2^id | 10     | !JournalUmZu3^id | !JournalZu2^id |



# Umlagerungsbewertungen
Given I open latest Valuation "BewertungUmAb3-1" for Product "FAHRRAD-01" and valuation transaction "JournalUmAb3" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb3"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 24   | !JournalZu1^id | !JournalZu1^id |
    | 16   | !JournalZu2^id | !JournalZu2^id |
    | 10   | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open latest Valuation "BewertungUmZu3-1" for Product "FAHRRAD-01" and valuation transaction "JournalUmZu3" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu3"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 24   | !JournalZu1^id | !JournalZu1^id |
    | 16   | !JournalZu2^id | !JournalZu2^id |
	| 10   | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 05 Rueckbau auf den letzten Arbeitsschein
Given I open an editor "Rueckbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RBPLATZ01_002"
And I set field "sofort" to "ja"
And I set field "gutmge" to "-45" in row 1
And I set field "buplatz" to "ZLQM" in row 1
And I set field "erbtext1" to "Rueckbau1" in row 1
And I save the current editor


# Journaleintraege, auch fuer Bewertungsmengenkorrektur
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu1"
Then field "rueckgmge" has value "24"
Then field "rueckmge" has value "24"
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu2"
Then field "rueckgmge" has value "21"
Then field "rueckmge" has value "21"
And I close the current editor

Given I open an editor "JournalRueckZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==ZLQM;detursache==Rückbau Fertigung;mge==-24"
Then field "detursache" has value "Rückbau Fertigung"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ZLQM"
Then field "gmge" has value "-24"
Then field "mge" has value "-24"
And I close the current editor

Given I open an editor "JournalRueckZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==ZLQM;detursache==Rückbau Fertigung;mge==-21"
Then field "detursache" has value "Rückbau Fertigung"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu2"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ZLQM"
Then field "gmge" has value "-21"
Then field "mge" has value "-21"
And I close the current editor


# Journaleintrag Umbuchungsabgang von ZLQM nach ABLA - hier werden die Bindungen angepasst und eine wartende Menge erzeugt
Given I open an editor "JournalUmAb3" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb3"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "buarta" has value "Abgang"
Then field "platz" has value "ZLQM"
Then field "gmge" has value "50"
Then field "mge" has value "50"
Then table has values
    | mge | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id     |
    | 5   | !JournalUmZu2^id | !JournalZu2^id | 5      | !JournalUmZu2^id | !JournalZu2^id |
And I close the current editor

Given I open an editor "JournalUmZu3" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu3"
And I close the current editor


# Journaleintraege vorgelagerte Umbuchungen und LJs zur Bewertungsmengenkorrektur
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb1"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "buarta" has value "Abgang"
Then field "platz" has value "MLF01"
Then field "rueckgmge" has value "40"
Then field "rueckmge" has value "40"
Then the table has 0 rows
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu1"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ZLQM"
Then field "rueckgmge" has value "40"
Then field "rueckmge" has value "40"
And I close the current editor


# Bewertungsmengenkorrektur zur 1. Umbuchung
Given I open an editor "JournalUmAbBmk1a" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Abgang;platz==MLF01;mge==-24;bewmgekorrektur==ja"
Then field "detursache" has value "Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "buarta" has value "Abgang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "-24"
Then field "mge" has value "-24"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalUmAb1"
Then field "redorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "redrueckorig^id" has value equal to field "id" from editor "JournalRueckZu1"
And I close the current editor

Given I open an editor "JournalUmZuBmk1a" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==ZLQM;mge==-24;bewmgekorrektur==ja"
Then field "detursache" has value "Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ZLQM"
Then field "gmge" has value "-24"
Then field "mge" has value "-24"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalUmZu1"
Then field "redorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "redrueckorig^id" has value equal to field "id" from editor "JournalRueckZu1"
And I close the current editor

Given I open an editor "JournalUmAbBmk1b" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Abgang;platz==MLF01;mge==-16;bewmgekorrektur==ja"
Then field "detursache" has value "Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "buarta" has value "Abgang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "-16"
Then field "mge" has value "-16"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalUmAb1"
Then field "redorig^id" has value equal to field "id" from editor "JournalZu2"
Then field "redrueckorig^id" has value equal to field "id" from editor "JournalRueckZu2"
And I close the current editor

Given I open an editor "JournalUmZuBmk1b" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==ZLQM;mge==-16;bewmgekorrektur==ja"
Then field "detursache" has value "Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ZLQM"
Then field "gmge" has value "-16"
Then field "mge" has value "-16"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalUmZu1"
Then field "redorig^id" has value equal to field "id" from editor "JournalZu2"
Then field "redrueckorig^id" has value equal to field "id" from editor "JournalRueckZu2"
And I close the current editor


# 2. Umbuchung 10 Stueck
Given I open an editor "JournalUmAb2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb2"
Then field "rueckgmge" has value "5"
Then field "rueckmge" has value "5"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 5   | !JournalZu2^id | !JournalZu2^id | 5      | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open an editor "JournalUmZu2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu2"
Then field "rueckgmge" has value "5"
Then field "rueckmge" has value "5"
And I close the current editor

Given I open an editor "JournalUmAbBmk2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Abgang;platz==MLF01;mge==-5;bewmgekorrektur==ja"
Then field "detursache" has value "Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "buarta" has value "Abgang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "-5"
Then field "mge" has value "-5"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalUmAb2"
Then field "redorig^id" has value equal to field "id" from editor "JournalZu2"
Then field "redrueckorig^id" has value equal to field "id" from editor "JournalRueckZu2"
And I close the current editor

Given I open an editor "JournalUmZuBmk2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==ZLQM;mge==-5;bewmgekorrektur==ja"
Then field "detursache" has value "Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ZLQM"
Then field "gmge" has value "-5"
Then field "mge" has value "-5"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalUmZu2"
Then field "redorig^id" has value equal to field "id" from editor "JournalZu2"
And I close the current editor


# Platzmengen
Given I query StorageQuantity for Product "FAHRRAD-01" on StorageLocation "ZLQM"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id     |
    | -24    | Stück  | !JournalUmAb3^id | (0,0,0)        | -24    | !JournalUmAb3^id | (0,0,0)        |
    | -21    | Stück  | !JournalUmAb3^id | (0,0,0)        | -21    | !JournalUmAb3^id | (0,0,0)        |


Given I query StorageQuantity for Product "FAHRRAD-01" on StorageLocation "ABLA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id     |
    | 24     | Stück  | !JournalUmZu3^id | (0,0,0)        | 24     | !JournalUmZu3^id | (0,0,0)        |
    | 16     | Stück  | !JournalUmZu3^id | (0,0,0)        | 16     | !JournalUmZu3^id | (0,0,0)        |
    | 5      | Stück  | !JournalUmZu3^id | !JournalZu2^id | 5      | !JournalUmZu3^id | !JournalZu2^id |
    | 5      | Stück  | !JournalUmZu3^id | (0,0,0)        | 5      | !JournalUmZu3^id | (0,0,0)        |


# Bewertungen
Given I open latest Valuation "BewertungZu1-2" for Product "FAHRRAD-01" and valuation transaction "JournalZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu1-1"
Then field "nachfolger" is empty
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueckZu1"
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 0    | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open latest Valuation "BewertungZu2-2" for Product "FAHRRAD-01" and valuation transaction "JournalZu2" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu2"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu2-1"
Then field "nachfolger" is empty
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueckZu2"
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 5    | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

# Umlagerungsbewertungen
Given I open latest Valuation "BewertungUmAb3-2" for Product "FAHRRAD-01" and valuation transaction "JournalUmAb3" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb3"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 5    | !JournalZu2^id | !JournalZu2^id |
    | 45   | (0,0,0)        | (0,0,0)        |
And I close the current editor

Given I open latest Valuation "BewertungUmZu3-2" for Product "FAHRRAD-01" and valuation transaction "JournalUmZu3" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu3"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 5    | !JournalZu2^id | !JournalZu2^id |
    | 45   | (0,0,0)        | (0,0,0)        |
And I close the current editor


# Bewertungen zur Bewertungsmengenkorrektur
Given I open latest Valuation "BewertungUmAb1-2" for Product "FAHRRAD-01" and valuation transaction "JournalUmAb1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb1"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalUmAbBmk1b"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 0    | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open latest Valuation "BewertungUmZu1-2" for Product "FAHRRAD-01" and valuation transaction "JournalUmZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu1"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalUmZuBmk1b"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 0    | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open latest Valuation "BewertungUmAb2-2" for Product "FAHRRAD-01" and valuation transaction "JournalUmAb2" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb2"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalUmAbBmk2"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 5    | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open latest Valuation "BewertungUmZu2-2" for Product "FAHRRAD-01" and valuation transaction "JournalUmZu2" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu2"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalUmZuBmk2"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 5    | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 06 Rueckbau wieder stornieren
Given I open an editor "Storno1" via ID from editor "Rueckbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
And I set field "erbtext1" to "Storno1" in row 1
And I save the current editor

# Nachbewerten
And I run Revaluation

# Journaleintraege, auch fuer Bewertungsmengenkorrektur
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu1"
Then field "rueckgmge" has value "0"
Then field "rueckmge" has value "0"
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu2"
Then field "rueckgmge" has value "0"
Then field "rueckmge" has value "0"
And I close the current editor

Given I open an editor "JournalRueckZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalRueckZu1"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalRueckZu2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalRueckZu2"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalStornoZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==ZLQM;detursache==Storno-Rückbau Fertigung;mge==24"
Then field "detursache" has value "Storno-Rückbau Fertigung"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueckZu1"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ZLQM"
Then field "gmge" has value "24"
Then field "mge" has value "24"
And I close the current editor

Given I open an editor "JournalStornoZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==ZLQM;detursache==Storno-Rückbau Fertigung;mge==21"
Then field "detursache" has value "Storno-Rückbau Fertigung"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueckZu2"
Then field "buarta" has value "Zugang"
Then field "platz" has value "ZLQM"
Then field "gmge" has value "21"
Then field "mge" has value "21"
And I close the current editor


# Journaleintraege Umbuchung
Given I open an editor "JournalUmAb3" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb3"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "buarta" has value "Abgang"
Then field "platz" has value "ZLQM"
Then field "gmge" has value "50"
Then field "mge" has value "50"
Then table has values
    | mge | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id     |
    | 10  | !JournalUmZu2^id | !JournalZu2^id | 10     | !JournalUmZu2^id | !JournalZu2^id |
    | 16  | !JournalUmZu1^id | !JournalZu2^id | 16     | !JournalUmZu1^id | !JournalZu2^id |
    | 24  | !JournalUmZu1^id | !JournalZu1^id | 24     | !JournalUmZu1^id | !JournalZu1^id |
And I close the current editor

Given I open an editor "JournalUmZu3" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu3"
And I close the current editor


# Journaleintraege Bewertungsmengenkorrektur zu 1. Umbuchung - 40 Stueck
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb1"
Then field "rueckgmge" has value "0"
Then field "rueckmge" has value "0"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 16  | !JournalZu2^id | !JournalZu2^id | 16     | !JournalZu2^id | !JournalZu2^id |
    | 24  | !JournalZu1^id | !JournalZu1^id | 24     | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu1"
Then field "rueckgmge" has value "0"
Then field "rueckmge" has value "0"
And I close the current editor


# Bewertungsmengenkorrektur zu 1. Umbuchung
Given I open an editor "JournalUmAbBmk1a" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAbBmk1a"
Then field "detursache" has value "Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalUmZuBmk1a" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZuBmk1a"
Then field "detursache" has value "Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalUmAbSBmk1a" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Abgang;platz==MLF01;mge==24;detursache==Storno-Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "detursache" has value "Storno-Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "gmge" has value "24"
Then field "mge" has value "24"
Then field "stornolj^id" has value equal to field "id" from editor "JournalUmAbBmk1a"
And I close the current editor

Given I open an editor "JournalUmZuSBmk1a" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==ZLQM;mge==24;detursache==Storno-Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "detursache" has value "Storno-Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "gmge" has value "24"
Then field "mge" has value "24"
Then field "stornolj^id" has value equal to field "id" from editor "JournalUmZuBmk1a"
And I close the current editor

Given I open an editor "JournalUmAbBmk1b" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAbBmk1b"
Then field "detursache" has value "Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalUmZuBmk1b" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZuBmk1b"
Then field "detursache" has value "Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalUmAbSBmk1b" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Abgang;platz==MLF01;mge==16;detursache==Storno-Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "detursache" has value "Storno-Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "gmge" has value "16"
Then field "mge" has value "16"
Then field "stornolj^id" has value equal to field "id" from editor "JournalUmAbBmk1b"
And I close the current editor

Given I open an editor "JournalUmZuSBmk1b" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==ZLQM;mge==16;detursache==Storno-Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "detursache" has value "Storno-Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "gmge" has value "16"
Then field "mge" has value "16"
Then field "stornolj^id" has value equal to field "id" from editor "JournalUmZuBmk1b"
And I close the current editor


# Journaleintraege Bewertungsmengenkorrektur zu 2. Umbuchung - 10 Stueck
Given I open an editor "JournalUmAb2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb2"
Then field "rueckgmge" has value "0"
Then field "rueckmge" has value "0"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 10  | !JournalZu2^id | !JournalZu2^id | 10     | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open an editor "JournalUmZu2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu2"
Then field "rueckgmge" has value "0"
Then field "rueckmge" has value "0"
And I close the current editor


# Bewertungsmengenkorrektur zu 2. Umbuchung
Given I open an editor "JournalUmAbBmk2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAbBmk2"
Then field "detursache" has value "Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalUmZuBmk2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZuBmk2"
Then field "detursache" has value "Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalUmAbSBmk2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Abgang;platz==MLF01;mge==5;bewmgekorrektur==ja"
Then field "detursache" has value "Storno-Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "gmge" has value "5"
Then field "mge" has value "5"
Then field "stornolj^id" has value equal to field "id" from editor "JournalUmAbBmk2"
And I close the current editor

Given I open an editor "JournalUmZuSBmk2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==FAHRRAD-01;buarta==Zugang;platz==ZLQM;mge==5;bewmgekorrektur==ja"
Then field "detursache" has value "Storno-Bewertungsmengenkorrektur Manuelle Umbuchung"
Then field "gmge" has value "5"
Then field "mge" has value "5"
Then field "stornolj^id" has value equal to field "id" from editor "JournalUmZuBmk2"
And I close the current editor


# Platzmengen
Given I query StorageQuantity for Product "FAHRRAD-01" on StorageLocation "ZLQM"
Then StorageQuantity is zero


Given I query StorageQuantity for Product "FAHRRAD-01" on StorageLocation "ABLA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id     |
    | 5      | Stück  | !JournalUmZu3^id | !JournalZu2^id | 5      | !JournalUmZu3^id | !JournalZu2^id |
    | 16     | Stück  | !JournalUmZu3^id | !JournalZu2^id | 16     | !JournalUmZu3^id | !JournalZu2^id |
    | 5      | Stück  | !JournalUmZu3^id | !JournalZu2^id | 5      | !JournalUmZu3^id | !JournalZu2^id |
    | 3      | Stück  | !JournalUmZu3^id | !JournalZu1^id | 3      | !JournalUmZu3^id | !JournalZu1^id |
    | 19     | Stück  | !JournalUmZu3^id | !JournalZu1^id | 19     | !JournalUmZu3^id | !JournalZu1^id |
    | 2      | Stück  | !JournalUmZu3^id | !JournalZu1^id | 2      | !JournalUmZu3^id | !JournalZu1^id |


# Bewertungen nach Storno des Rueckbaus fehlen
Given I open latest Valuation "BewertungZu1-3" for Product "FAHRRAD-01" and valuation transaction "JournalZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 24   | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open latest Valuation "BewertungZu2-3" for Product "FAHRRAD-01" and valuation transaction "JournalZu2" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu2"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 26   | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

# Umlagerungsbewertungen
Given I open latest Valuation "BewertungUmAb1-3" for Product "FAHRRAD-01" and valuation transaction "JournalUmAb1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb1"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 16   | !JournalZu2^id | !JournalZu2^id |
    | 24   | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open latest Valuation "BewertungUmZu1-3" for Product "FAHRRAD-01" and valuation transaction "JournalUmZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu1"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 16   | !JournalZu2^id | !JournalZu2^id |
    | 24   | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open latest Valuation "BewertungUmAb2-3" for Product "FAHRRAD-01" and valuation transaction "JournalUmAb2" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb2"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 10   | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open latest Valuation "BewertungUmZu2-3" for Product "FAHRRAD-01" and valuation transaction "JournalUmZu2" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu2"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 10   | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open latest Valuation "BewertungUmAb3-3" for Product "FAHRRAD-01" and valuation transaction "JournalUmAb3" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb3"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 10   | !JournalZu2^id | !JournalZu2^id |
    | 16   | !JournalZu2^id | !JournalZu2^id |
    | 24   | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open latest Valuation "BewertungUmZu3-3" for Product "FAHRRAD-01" and valuation transaction "JournalUmZu3" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu3"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 5    | !JournalZu2^id | !JournalZu2^id |
    | 5    | !JournalZu2^id | !JournalZu2^id |
    | 16   | !JournalZu2^id | !JournalZu2^id |
    | 24   | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

 Scenario: 07 Betriebsauftrag abschliessen
Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RBPLATZ01_002"
And I set fields
    | sofort | ja  |
    | gut    | ja  |
    | mgr    | 112 |
And I save the current editor
