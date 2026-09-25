# *****************************************************************************
#  Name             : rueckbuchung_mit_bbuchung.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet die Rueckbuchung von Folgeplatz mit Behaelterlagerbuchung
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_mit_bbuchung.feature
Background:
Given I set the fake date to "12.01.1995"

##################################################################################################################

@Behaelterlagerbuchung
Scenario: 01 Behaelter anlegen und befuellen
# Behaelter anlegen
Given I create a Container "rueck_01" for packaging material "BEHAELTER"

Given I open an editor "RechnungmLZu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 1rzu     |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang1R |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | preis | platz | !dialogId                                     | !dialogAnswer | exbehnum         |
    | SATTEL  | 10  | 10.00 | F3    | Externe Behälternummer ist bereits vergeben. | nein          | !rueck_01^nummer |
    | KLINGEL | 11  |  8.00 | F3    | Externe Behälternummer ist bereits vergeben. | nein          | !rueck_01^nummer |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SATTEL;buarta==Zugang;platz==F3;ebeleg=Zugang1R"
Then field "buarta" has value "Zugang"
Then field "platz" has value "F3"
Then field "gmge" has value "10"
Then field "mge" has value "10"
Then field "behaelter^id" has value equal to field "id" from editor "rueck_01"
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==KLINGEL;buarta==Zugang;platz==F3;ebeleg=Zugang1R"
Then field "buarta" has value "Zugang"
Then field "platz" has value "F3"
Then field "gmge" has value "11"
Then field "mge" has value "11"
Then field "behaelter^id" has value equal to field "id" from editor "rueck_01"
And I close the current editor

# Platzmengen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "SATTEL" on StorageLocation "F3"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 10     | Stück  | !JournalZu1^id | !JournalZu1^id | 12.01.1995 | 10     | !JournalZu1^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "KLINGEL" on StorageLocation "F3"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id          | orig^id        | verfdat    | bewmge | bewlj^id       | beworig^id     | bewdat     |
    | 11     | Stück  | !JournalZu2^id | !JournalZu2^id | 12.01.1995 | 11     | !JournalZu2^id | !JournalZu2^id | 12.01.1995 |
And I close the current editor

# Behaelter pruefen
And I switch the current editor to editor "rueck_01"
Then field "platz" has value "F3"
Then table has values
   | !row | artikel | mge |
   | 1    | SATTEL  | 10  |
   | 2    | KLINGEL | 11  |
And I close the current editor


Scenario: 02 Behaelter umlagern mit Behaelterlagerbuchung
# Behaelter umbuchen
Given I open an editor "BBuchung01" for tip command "(ContainerAdjustment)" and arguments ""
And I set field "behaelter" to id from editor "rueck_01"
Then the table has 2 rows
And I set field "zuplatz" to "F4"
And I set field "beleg" to "BB01"
And I set field "beldat" to "."
And I save the current editor

# Journaleintraege
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SATTEL;buarta==Abgang;platz==F3;"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Behälterlagerbuchung"
Then field "platz" has value "F3"
Then field "gmge" has value "10"
Then field "mge" has value "10"
Then field "behaelter^id" has value equal to field "id" from editor "rueck_01"
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SATTEL;buarta==Zugang;platz==F4;"
Then field "buarta" has value "Zugang"
Then field "detursache" has value "Behälterlagerbuchung"
Then field "platz" has value "F4"
Then field "gmge" has value "10"
Then field "mge" has value "10"
Then field "behaelter^id" has value equal to field "id" from editor "rueck_01"
And I close the current editor

Given I open an editor "JournalUmAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==KLINGEL;buarta==Abgang;platz==F3;"
Then field "buarta" has value "Abgang"
Then field "detursache" has value "Behälterlagerbuchung"
Then field "platz" has value "F3"
Then field "gmge" has value "11"
Then field "mge" has value "11"
Then field "behaelter^id" has value equal to field "id" from editor "rueck_01"
And I close the current editor

Given I open an editor "JournalUmZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==KLINGEL;buarta==Zugang;platz==F4;"
Then field "buarta" has value "Zugang"
Then field "detursache" has value "Behälterlagerbuchung"
Then field "platz" has value "F4"
Then field "gmge" has value "11"
Then field "mge" has value "11"
Then field "behaelter^id" has value equal to field "id" from editor "rueck_01"
And I close the current editor

# Platzmengen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "SATTEL" on StorageLocation "F3"
Then StorageQuantity is zero

Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "KLINGEL" on StorageLocation "F3"
Then StorageQuantity is zero

Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "SATTEL" on StorageLocation "F4"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id         | beworig^id     | bewdat     |
    | 10     | Stück  | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 | 10     | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "KLINGEL" on StorageLocation "F4"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id         | beworig^id     | bewdat     |
    | 11     | Stück  | !JournalUmZu2^id | !JournalZu2^id | 12.01.1995 | 11     | !JournalUmZu2^id | !JournalZu2^id | 12.01.1995 |
And I close the current editor

# Behaelter pruefen
And I switch the current editor to editor "rueck_01"
Then field "platz" has value "F4"
Then table has values
   | !row | artikel | mge |
   | 1    | SATTEL  | 10  |
   | 2    | KLINGEL | 11  |
And I close the current editor


Scenario: 03-1 Ruecklieferung des Zugangs
Given I set the fake date to "13.1.95"

Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set fields
    | nummer   | 1rueck     |
    | vom      | .          |
    | ueb      | ja         |
And I modify table
    | !row | mge | platz | behaelter    |
    | 1    | -10 | F4    | !rueck_01^id |
    | 2    | -11 | F4    | !rueck_01^id |
And I save the current editor

# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu1"
Then field "rueckgmge" has value "10"
Then field "rueckmge" has value "10"
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu2"
Then field "rueckgmge" has value "11"
Then field "rueckmge" has value "11"
And I close the current editor

Given I open an editor "JournalRueck1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SATTEL;buarta==Zugang;platz==F4;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "F4"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "rueckgmge" has value "-10"
Then field "rueckmge" has value "-10"
And I close the current editor

Given I open an editor "JournalRueck2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==KLINGEL;buarta==Zugang;platz==F4;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "F4"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu2"
Then field "rueckgmge" has value "-11"
Then field "rueckmge" has value "-11"
And I close the current editor

# Platzmengen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "SATTEL" on StorageLocation "F4"
Then StorageQuantity is zero

Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "KLINGEL" on StorageLocation "F4"
Then StorageQuantity is zero

# Behaelter pruefen
And I switch the current editor to editor "rueck_01"
Then field "behstatusaz" has value "Rücklieferung"
Then field "platz" is empty
Then the table has 0 rows
And I close the current editor

Scenario Outline: 03-2 Journaleintraege zu Umbuchungen pruefen
Given I open an editor "<editor>" from table "(Journal):(Journal)" with command "VIEW" for record from editor "<editor>"
Then field "buarta" has value "<buart>"
Then field "rueckmge" has value "<rueckmge>"
Then field "rueckgmge" has value "<rueckgmge>"
Then field "platz" has value "<platz>"
Then the table has 0 rows
And I close the current editor

Examples:
    | editor       | buart  | rueckmge | rueckgmge | platz |
    | JournalUmAb1 | Abgang | 10       | 10        | F3    |
    | JournalUmZu1 | Zugang | 10       | 10        | F4    |
    | JournalUmAb2 | Abgang | 11       | 11        | F3    |
    | JournalUmZu2 | Zugang | 11       | 11        | F4    |

Scenario Outline: 03-3 Journaleintraege zur Bewertungsmengenkorrketur pruefen
Given I set the fake date to "13.1.95"
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
    | select                                                                      | editor         | buart  | rueckmge | rueckgmge | platz | detursache                                      | umeditor     |
    | $,,artikel==SATTEL;buarta==Abgang;redrueckorig<>`;platz==F3;rueckmge==-10;  | JournalUmAb1-2 | Abgang | -10      | -10       | F3    | Bewertungsmengenkorrektur Behälterlagerbuchung | JournalUmAb1 |
    | $,,artikel==SATTEL;buarta==Zugang;redrueckorig<>`;platz==F4;rueckmge==-10;  | JournalUmZu1-2 | Zugang | -10      | -10       | F4    | Bewertungsmengenkorrektur Behälterlagerbuchung | JournalUmZu1 |
    | $,,artikel==KLINGEL;buarta==Abgang;redrueckorig<>`;platz==F3;rueckmge==-11; | JournalUmAb2-2 | Abgang | -11      | -11       | F3    | Bewertungsmengenkorrektur Behälterlagerbuchung | JournalUmAb2 |
    | $,,artikel==KLINGEL;buarta==Zugang;redrueckorig<>`;platz==F4;rueckmge==-11; | JournalUmZu2-2 | Zugang | -11      | -11       | F4    | Bewertungsmengenkorrektur Behälterlagerbuchung | JournalUmZu2 |


Scenario: 04-1 Vollstaendige Ruecklieferung des Zugangs stornieren
Given I set the fake date to "14.1.95"
Given I open an editor "StornoRueck" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung"
And I set fields
    | nummer | 1strueck |
And I save the current editor

# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu1"
Then field "rueckgmge" has value "0"
Then field "rueckmge" has value "0"
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu2"
Then field "rueckgmge" has value "0"
Then field "rueckmge" has value "0"
And I close the current editor

Given I open an editor "JournalRueck1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalRueck1"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "rueckgmge" has value "-10"
Then field "rueckmge" has value "-10"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalRueck2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalRueck2"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu2"
Then field "rueckgmge" has value "-11"
Then field "rueckmge" has value "-11"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalStorno1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SATTEL;buarta==Zugang;platz==F4;detursache==Storno-Rücklieferung Einkauf;"
Then field "gmge" has value "10"
Then field "mge" has value "10"
Then field "platz" has value "F4"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck1"
And I close the current editor

Given I open an editor "JournalStorno2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==KLINGEL;buarta==Zugang;platz==F4;detursache==Storno-Rücklieferung Einkauf;"
Then field "gmge" has value "11"
Then field "mge" has value "11"
Then field "platz" has value "F4"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck2"
And I close the current editor

# Platzmengen
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "SATTEL" on StorageLocation "F4"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id         | beworig^id     | bewdat     |
    | 10     | Stück  | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 | 10     | !JournalUmZu1^id | !JournalZu1^id | 12.01.1995 |
And I close the current editor

Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "KLINGEL" on StorageLocation "F4"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | verfdat    | bewmge | bewlj^id         | beworig^id     | bewdat     |
    | 11     | Stück  | !JournalUmZu2^id | !JournalZu2^id | 12.01.1995 | 11     | !JournalUmZu2^id | !JournalZu2^id | 12.01.1995 |
And I close the current editor

# Behaelter pruefen
And I switch the current editor to editor "rueck_01"
Then field "platz" has value "F4"
Then table has values
   | !row | artikel | mge |
   | 1    | SATTEL  | 10  |
   | 2    | KLINGEL | 11  |
And I close the current editor

Scenario Outline: 04-2 Journaleintraege zu Umbuchungen pruefen
Given I set the fake date to "14.1.95"
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
    | JournalUmAb1-2  | Abgang | -10      | -10       | F3    |
    | JournalUmZu1-2  | Zugang | -10      | -10       | F4    |
    | JournalUmAb2-2  | Abgang | -11      | -11       | F3    |
    | JournalUmZu2-2  | Zugang | -11      | -11       | F4    |

Scenario Outline: 04-3 Zugangsjournaleintraege zur Bewertungsmengenkorrketur bei Storno pruefen
Given I set the fake date to "14.1.95"
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
    | select                                                                            | editor          | buart  | mge | gmge | platz | detursache                                              | umeditor       |
    | $,,artikel==SATTEL;buarta==Abgang;redrueckorig<>`;stornolj<>`;platz==F3;mge==10;  | JournalUmAb1-2s | Abgang | 10  | 10   | F3    | Storno-Bewertungsmengenkorrektur Behälterlagerbuchung  | JournalUmAb1-2 |
    | $,,artikel==SATTEL;buarta==Zugang;redrueckorig<>`;stornolj<>`;platz==F4;mge==10;  | JournalUmZu1-2s | Zugang | 10  | 10   | F4    | Storno-Bewertungsmengenkorrektur Behälterlagerbuchung  | JournalUmZu1-2 |
    | $,,artikel==KLINGEL;buarta==Abgang;redrueckorig<>`;stornolj<>`;platz==F3;mge==11; | JournalUmAb2-2s | Abgang | 11  | 11   | F3    | Storno-Bewertungsmengenkorrektur Behälterlagerbuchung  | JournalUmAb2-2 |
    | $,,artikel==KLINGEL;buarta==Zugang;redrueckorig<>`;stornolj<>`;platz==F4;mge==11; | JournalUmZu2-2s | Zugang | 11  | 11   | F4    | Storno-Bewertungsmengenkorrektur Behälterlagerbuchung  | JournalUmZu2-2 |

