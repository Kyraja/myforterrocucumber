# *****************************************************************************
#  Name             : rueckbuchung_zugang_orignialplatz_attribute.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Rueckbuchung und Storno-Rueckbuchung
#                     nach mehreren Umlagerungen, bei denen sich nur die Verwendung aendert
#                     und Rueckbuchung von Originalplatz
#
# Getestet wird das Scenario:
#  - Zugang EK-Rechnung mit Lagerbewegung (94 Paar auf MLF01, Preis 10.00)
#  - Mehrfache Umbuchungen, bei denen sich nur die Verwendung aendert
#  - Ruecklieferung auf Zugang (-22 Paar mit Originalverwendung)
#  - Storno der Ruecklieferung
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_zugang_orignialplatz_attribute.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: 01 Artikel kopieren
Given I open an editor "RAD-02" from table "(Part):(Product)" with command "COPY" for record "RAD"
And I set field "such" to "RAD-02"
And I set field "chverfolgung" to ""
And I set field "dispoa" to "auftragsbezogen"
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 02 Rad einkaufen
Given I open an editor "RechnungmLZu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 2zu      |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang01 |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | he   | preis | verw    |
    | RAD-02  | 94  | Paar | 10.00 | puky_02 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "94"
Then field "mge" has value "188"
Then field "verw" has value "puky_02"
And I close the current editor

# Platzmenge pruefen
Given I query "gebmge,gebeinh,lj^id,orig^id,bewmge,bewlj^id, beworig^id,verw" from StorageQuantity for Product "RAD-02" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    | verw    |
    | 188    | Stück  | !JournalZu^id | !JournalZu^id | 188    | !JournalZu^id | !JournalZu^id | puky_02 |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario Outline: 03a Rad umlagern in mehreren Teilmengen
Given I open an editor "LBuchung" for tip command "Lbuchung" and arguments ""
And I set fields
  | artikel     | RAD-02    |
  | beleg       | <beleg>   |
  | beldat      | .         |
  | buart       | Umbuchung |

And I set field "mge" to "<menge>" in row 1
And I set field "ze" to "Paar" in row 1
And I set field "platz" to "MLF01" in row 1
And I set field "platz2" to "MLF01" in row 1
And I set field "verw" to "<verw>" in row 1
And I set field "verw2" to "<verw2>" in row 1
And I save the current editor

Examples:
    | beleg | menge | verw    | verw2    |
    | 2um1  | 22    | puky_02 | puky_xy1 |
    | 2um2  | 23    | puky_02 | puky_xy2 |
    | 2um3  | 24    | puky_02 | puky_xy3 |
    | 2um4  | 25    | puky_02 | puky_xy4 |


Scenario: 03b Journaleintraege zu Umbuchungen pruefen

# Journaleintraege pruefen
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Abgang;detursache==Manuelle Umbuchung;such==L2UM1;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "22"
Then field "mge" has value "44"
Then field "platz" has value "MLF01"
Then field "verwla" has value "puky_02"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 44  | !JournalZu^id | !JournalZu^id | 44     | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Abgang;detursache==Manuelle Umbuchung;such==L2UM2;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "23"
Then field "mge" has value "46"
Then field "platz" has value "MLF01"
Then field "verwla" has value "puky_02"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 46  | !JournalZu^id | !JournalZu^id | 46     | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmAb3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Abgang;detursache==Manuelle Umbuchung;such==L2UM3;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "24"
Then field "mge" has value "48"
Then field "platz" has value "MLF01"
Then field "verwla" has value "puky_02"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 48  | !JournalZu^id | !JournalZu^id | 48     | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmAb4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Abgang;detursache==Manuelle Umbuchung;such==L2UM4;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "25"
Then field "mge" has value "50"
Then field "platz" has value "MLF01"
Then field "verwla" has value "puky_02"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 50  | !JournalZu^id | !JournalZu^id | 50     | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;detursache==Manuelle Umbuchung;such==L2UM1;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "22"
Then field "mge" has value "44"
Then field "platz" has value "MLF01"
Then field "verwla" has value "puky_xy1"
And I close the current editor

Given I open an editor "JournalUmZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;detursache==Manuelle Umbuchung;such==L2UM2;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "23"
Then field "mge" has value "46"
Then field "platz" has value "MLF01"
Then field "verwla" has value "puky_xy2"
And I close the current editor

Given I open an editor "JournalUmZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;detursache==Manuelle Umbuchung;such==L2UM3;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "24"
Then field "mge" has value "48"
Then field "platz" has value "MLF01"
Then field "verwla" has value "puky_xy3"
And I close the current editor

Given I open an editor "JournalUmZu4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;detursache==Manuelle Umbuchung;such==L2UM4;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "25"
Then field "mge" has value "50"
Then field "platz" has value "MLF01"
Then field "verwla" has value "puky_xy4"
And I close the current editor

# Platzmengen pruefen
Given I query "gebmge,gebeinh,lj^id,orig^id,bewmge,bewlj^id, beworig^id,verw" from StorageQuantity for Product "RAD-02" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id    | verw     |
    | 44     | Stück  | !JournalUmZu1^id | !JournalZu^id  | 44     | !JournalUmZu1^id | !JournalZu^id | puky_xy1 |
    | 46     | Stück  | !JournalUmZu2^id | !JournalZu^id  | 46     | !JournalUmZu2^id | !JournalZu^id | puky_xy2 |
    | 48     | Stück  | !JournalUmZu3^id | !JournalZu^id  | 48     | !JournalUmZu3^id | !JournalZu^id | puky_xy3 |
    | 50     | Stück  | !JournalUmZu4^id | !JournalZu^id  | 50     | !JournalUmZu4^id | !JournalZu^id | puky_xy4 |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 04 Ruecklieferung auf Zugang
Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set field "nummer" to "2rueck"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-24" in row 1
And I set field "he" to "Paar" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I append rows
    | platz  | zuomge | einh | verw    |
    | MLF01  | -24    | Paar | puky_02 |
And I save the current editor
And I switch the current editor to editor "Ruecklieferung"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalRueck" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "-24"
Then field "mge" has value "-48"
Then field "platz" has value "MLF01"
Then field "verwla" has value "puky_02"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu"
And I close the current editor

# Platzmenge pruefen
Given I query "gebmge,gebeinh,lj^id,orig^id,bewmge,bewlj^id,beworig^id,verw" from StorageQuantity for Product "RAD-02" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id       | bewmge | bewlj^id         | beworig^id    | verw     |
    | 44     | Stück  | !JournalUmZu1^id | !JournalZu^id | 44     | !JournalUmZu1^id | !JournalZu^id | puky_xy1 |
    | 46     | Stück  | !JournalUmZu2^id | !JournalZu^id | 46     | !JournalUmZu2^id | !JournalZu^id | puky_xy2 |
    | 48     | Stück  | !JournalUmZu3^id | !JournalZu^id | 48     | !JournalUmZu3^id | !JournalZu^id | puky_xy3 |
    |  2     | Stück  | !JournalUmZu4^id | !JournalZu^id |  2     | !JournalUmZu4^id | !JournalZu^id | puky_xy4 |


# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 05 Ruecklieferung stornieren
Given I open an editor "RueckStorno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung"
And I set field "nummer" to "2storno"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalStorno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;detursache==Storno-Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "24"
Then field "mge" has value "48"
Then field "verwla" has value "puky_02"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck"
And I close the current editor

# Platzmenge pruefen
Given I query "gebmge,gebeinh,lj^id,orig^id,bewmge,bewlj^id,beworig^id,verw" from StorageQuantity for Product "RAD-02" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id    | verw     |
    | 44     | Stück  | !JournalUmZu1^id | !JournalZu^id  | 44     | !JournalUmZu1^id | !JournalZu^id | puky_xy1 |
    | 46     | Stück  | !JournalUmZu2^id | !JournalZu^id  | 46     | !JournalUmZu2^id | !JournalZu^id | puky_xy2 |
    | 48     | Stück  | !JournalUmZu3^id | !JournalZu^id  | 48     | !JournalUmZu3^id | !JournalZu^id | puky_xy3 |
    |  2     | Stück  | !JournalUmZu4^id | !JournalZu^id  |  2     | !JournalUmZu4^id | !JournalZu^id | puky_xy4 |
    | 48     | Stück  | !JournalUmZu4^id | !JournalZu^id  | 48     | !JournalUmZu4^id | !JournalZu^id | puky_02  |
