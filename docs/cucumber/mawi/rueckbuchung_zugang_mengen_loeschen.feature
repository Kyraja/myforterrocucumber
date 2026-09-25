# *****************************************************************************
#  Name             : rueckbuchung_zugang_mengen_loeschen.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Bestaende in Journaleintraegen zur Bewertungsmengenkorrektur
#                     nach Rueckbuchung und Storno-Rueckbuchung
#
# Getestet wird das Scenario:
#  - Artikel und Lager haben "Mengen loeschen" aktiv
#  - Zugang auf Platz F1, 100 Paar
#  - Umbuchung auf Platz F2, 100 Paar
#  - Abgang von Platz F2, 100 Paar
#  - Ruecklieferung von Platz F1, -51 Paar
#  - Storno der Ruecklieferung
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_zugang_mengen_loeschen.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: 01 Artikel kopieren, Lagerplatz anlegen
Given I open an editor "RAD-04" from table "(Part):(Product)" with command "COPY" for record "RAD"
And I set field "such" to "RAD-04"
And I set field "chverfolgung" to ""
And I set field "lnullm" to "ja"
And I set field "zuplatz" to "MGEL1"
And I set field "abplatz" to "MGEL2"
And I save the current editor


# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 02 Rad einkaufen
Given I open an editor "RechnungmLZu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 4zu      |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang04 |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | he   | preis | platz |
    | RAD-04  | 100 | Paar | 10.00 | MGEL1 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Journaleintraege pruefen
Given I open an editor "JournalZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-04;buarta==Zugang;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MGEL1"
Then field "gmge" has value "100"
Then field "mge" has value "200"
And I close the current editor


# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-04" on StorageLocation "MGEL1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 200    | Stück  | !JournalZu^id | !JournalZu^id | 200    | !JournalZu^id | !JournalZu^id |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 03 100 Paar umlagern nach MGEL2
Given I transfer StorageQuantity of "100" "Paar" for Product "RAD-04" from StorageLocation "MGEL1" to "MGEL2" with document "4Um"


# Journaleintraege pruefen
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-04;buarta==Abgang;detursache==Manuelle Umbuchung;such==L4UM;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "100"
Then field "mge" has value "200"
Then field "platz" has value "MGEL1"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 200 | !JournalZu^id | !JournalZu^id | 200    | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-04;buarta==Zugang;detursache==Manuelle Umbuchung;such==L4UM;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "100"
Then field "mge" has value "200"
Then field "platz" has value "MGEL2"
And I close the current editor


# Platzmengen pruefen
# Auf Platz MGEL1 gibt es keine Platzmenge mehr
Given I query "artikel, platz, lemge" from table "(StorageQuantity):(LocationQuantity)" where "artikel==RAD-04;platz==MGEL1"
Then query has no hits

Given I query StorageQuantity for Product "RAD-04" on StorageLocation "MGEL2"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id        | bewmge | bewlj^id        | beworig^id    |
    | 200    | Stück  | !JournalUmZu^id | !JournalZu^id  | 200    | !JournalUmZu^id | !JournalZu^id |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 04 Artikel von MGEL2 in voller Menge verkaufen
Given I create a SalesOrder "Auftrag" for Customer "RADSHOP" with Product "RAD-04" and quantity "100"

Given I open an editor "VKLieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to "id" from editor "Auftrag"
And I set field "ueb" to "ja"
And I set field "mge" to "100" in row 1
And I set field "platz" to "MGEL2" in row 1
And I save the current editor


# Journaleintrag pruefen
Given I open an editor "JournalAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-04;buarta==Abgang;detursache==Lieferschein Verkauf;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "100"
Then field "mge" has value "200"
Then field "platz" has value "MGEL2"
Then table has values
    | mge | lj^id           | orig^id       | bewmge | bewlj^id        | beworig^id    |
    | 200 | !JournalUmZu^id | !JournalZu^id | 200    | !JournalUmZu^id | !JournalZu^id |
And I close the current editor


# Keine Platzmengen mehr fuer den Artikel vorhanden, da Mengen loeschen aktiviert ist
Given I query "artikel, platz, lemge" from table "(StorageQuantity):(LocationQuantity)" where "artikel==RAD-04;platz<>`"
Then query has no hits

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 05 Ruecklieferung auf Zugang von Orignialplatz
Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set field "nummer" to "4rueck"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-60" in row 1
And I set field "he" to "Paar" in row 1
And I save the current editor


# Journaleintraege pruefen
Given I open an editor "JournalRueck" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-04;buarta==Zugang;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "-60"
Then field "mge" has value "-120"
Then field "platz" has value "MGEL1"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu"
And I close the current editor


# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-04" on StorageLocation "MGEL1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id | bewmge | bewlj^id        | beworig^id |
    | -120   | Stück  | !JournalUmAb^id | (0,0,0) | -120   | !JournalUmAb^id | (0,0,0)    |

# Auf Platz MGEL2 gibt es keine Platzmengen 
Given I query "artikel, platz, lemge" from table "(StorageQuantity):(LocationQuantity)" where "artikel==RAD-04;platz==MGEL2"
Then query has no hits

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 06 Ruecklieferung auf Zugang von Orignialplatz stornieren
Given I open an editor "Storno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung"
And I set field "nummer" to "4storno"
And I save the current editor


# Journaleintraege pruefen
Given I open an editor "JournalStorno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-04;buarta==Zugang;detursache==Storno-Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "60"
Then field "mge" has value "120"
Then field "platz" has value "MGEL1"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck"
And I close the current editor


# Keine Platzmengen mehr fuer den Artikel vorhanden, da Mengen loeschen aktiviert ist
Given I query "artikel, platz, lemge" from table "(StorageQuantity):(LocationQuantity)" where "artikel==RAD-04;platz<>`"
Then query has no hits

