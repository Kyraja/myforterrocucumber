# *****************************************************************************
#  Name             : rueckbuchung_mit_umbuchung_scenario5.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Ruecklieferung und Storno-Ruecklieferung
#                     nach Umlagerungen mit Charge und Verwendung
#
# Getestet wird das fehlerhafte Scenario aus BW2-1141:
#  - Zugang EK-Rechnung mit Lagerbewegung (10 Stueck auf MLF01, 3 Chargen und 3 Verwendungen)
#  - Abgang ueber VK-Lieferschein (10 Stueck von MLF01 mit passender Charge und Verwendung)
#  - Ruecklieferung auf Zugang (-6 Stueck von MLF01)
#  - Storno der Ruecklieferung
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_mit_umbuchung_scenario5.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: 01 Artikel kopieren
Given I open an editor "RAD-05" from table "(Part):(Product)" with command "COPY" for record "RAD"
And I set field "such" to "RAD-05"
And I set field "chverfolgung" to ""
And I set field "chimlager" to "j"
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario Outline: 02 Chargen anlegen
Given I open an editor "<suchw>" from table "(Lots):(Lots)" with command "STORE" for record "<suchw>"
And I set fields
    | such      | <suchw>     |
    | chname    | <name>      |
    | exnum     | <exnum>     |
    | artikel   | <artikel>   |
    | lief      | <lieferant> |
    | eigcharge | <eigen>     |

And I save the current editor

Examples: Chargen
| suchw      | name                 | exnum         | artikel  | lieferant   | eigen       |
| RAD777     | Reifenset Roadrunner | 777777        | !RAD-05  | PUKY        | !dontChange |
| RAD888     | Reifenset Roadrunner | 888888        | !RAD-05  | PUKY        | !dontChange |
| RAD999     | Reifenset Roadrunner | 999999        | !RAD-05  | PUKY        | !dontChange |

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 03 Rad einkaufen
Given I open an editor "RechnungmL" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 5zu      |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang05 |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | he   | preis |
    | RAD-05  | 10  | Paar | 10.00 |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | platz | zuomge | charge | verw  |
    | MLF01 | 2      | RAD777 | rad01 |
    | MLF01 | 3      | RAD888 | rad02 |
    | MLF01 | 5      | RAD999 | rad03 |
And I save the current editor
And I switch the current editor to editor "RechnungmL"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;verw==rad01"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "2"
Then field "verw" has value "rad01"
Then field "verwla" has value "rad01"
Then table has values
    | mge | ncharge^such | tncharge |
    | 4   | RAD777       | 777777   |
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;verw==rad02"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "3"
Then field "verw" has value "rad02"
Then field "verwla" has value "rad02"
Then table has values
    | mge | ncharge^such | tncharge |
    | 6   | RAD888       | 888888   |
And I close the current editor

Given I open an editor "JournalZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;verw==rad03"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "5"
Then field "verw" has value "rad03"
Then field "verwla" has value "rad03"
Then table has values
    | mge | ncharge^such | tncharge |
    | 10  | RAD999       | 999999   |
And I close the current editor

# Platzmenge pruefen
Given I query "gebmge,gebeinh,lj^id,orig^id,bewmge,bewlj^id,beworig^id,charge^such,tcharge,verw" from StorageQuantity for Product "RAD-05" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     | charge^such | tcharge | verw  |
    | 4      | Stück  | !JournalZu1^id | !JournalZu1^id | 4      | !JournalZu1^id | !JournalZu1^id | RAD777      | 777777  | rad01 |
    | 6      | Stück  | !JournalZu2^id | !JournalZu2^id | 6      | !JournalZu2^id | !JournalZu2^id | RAD888      | 888888  | rad02 |
    | 10     | Stück  | !JournalZu3^id | !JournalZu3^id | 10     | !JournalZu3^id | !JournalZu3^id | RAD999      | 999999  | rad03 |
And I close the current editor

# Bewertungen pruefen
Given I open an editor "BewertungZu1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-05;buart==Zugang;mge==4"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 4    | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open an editor "BewertungZu2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-05;buart==Zugang;mge==6"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu2"
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 6    | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open an editor "BewertungZu3" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-05;buart==Zugang;mge==10"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu3"
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 10   | !JournalZu3^id | !JournalZu3^id |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 04 Rad weiter verkaufen
Given I open an editor "VerkaufLs" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "5vkls"
And I set field "kunde" to "RADSHOP"
And I set field "ueb" to "ja"
And I append rows
    | artikel | mge | platz |
    | RAD-05  | 10  | MLF01 |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | platz | zuomge | charge | verw  |
    | MLF01 | 2      | RAD777 | rad01 |
    | MLF01 | 3      | RAD888 | rad02 |
    | MLF01 | 5      | RAD999 | rad03 |
And I save the current editor
And I switch the current editor to editor "VerkaufLs"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Abgang;verw==rad01;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "2"
Then field "verw" has value "rad01"
Then field "verwla" has value "rad01"
Then table has values
    | !row | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     | vcharge^such | tvcharge |
    | 1    | 4   | (0,0,0)        | (0,0,0)        | 0      | (0,0,0)        | (0,0,0)        | RAD777       | 777777   |
    | 2    | 4   | !JournalZu1^id | !JournalZu1^id | 4      | !JournalZu1^id | !JournalZu1^id |              |          |
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Abgang;verw==rad02;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "3"
Then field "verw" has value "rad02"
Then field "verwla" has value "rad02"
Then table has values
    | !row | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     | vcharge^such | tvcharge |
    | 1    | 6   | (0,0,0)        | (0,0,0)        | 0      | (0,0,0)        | (0,0,0)        | RAD888       | 888888   |
    | 2    | 6   | !JournalZu2^id | !JournalZu2^id | 6      | !JournalZu2^id | !JournalZu2^id |              |          |
And I close the current editor

Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Abgang;verw==rad03;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "5"
Then field "verw" has value "rad03"
Then field "verwla" has value "rad03"
Then table has values
     | !row | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     | vcharge^such | tvcharge |
     | 1    | 10  | (0,0,0)        | (0,0,0)        | 0      | (0,0,0)        | (0,0,0)        | RAD999       | 999999   |
     | 2    | 10  | !JournalZu3^id | !JournalZu3^id | 10     | !JournalZu3^id | !JournalZu3^id |              |          |
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-05" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 05 Ruecklieferung auf Zugang
Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmL"
And I set field "nummer" to "5rueck"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-6" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | platz | zuomge  | charge | verw  |
    | MLF01 | -2      | RAD777 | rad01 |
    | MLF01 | -3      | RAD888 | rad02 |
    | MLF01 | -1      | RAD999 | rad03 |
And I save the current editor
And I switch the current editor to editor "Ruecklieferung"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalRueck1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;verw==rad01;mge<0"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "-2"
Then field "rueckgmge" has value "-2"
Then field "verw" has value "rad01"
Then field "verwla" has value "rad01"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu1"
Then table has values
    | mge | ncharge^such | tncharge |
    | 0   | RAD777       | 777777   |
And I close the current editor

Given I open an editor "JournalRueck2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;verw==rad02;mge<0"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "-3"
Then field "rueckgmge" has value "-3"
Then field "verw" has value "rad02"
Then field "verwla" has value "rad02"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu2"
Then table has values
    | mge | ncharge^such | tncharge |
    | 0   | RAD888       | 888888   |
And I close the current editor

Given I open an editor "JournalRueck3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;verw==rad03;mge<0"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "-1"
Then field "rueckgmge" has value "-1"
Then field "verw" has value "rad03"
Then field "verwla" has value "rad03"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu3"
Then table has values
    | mge | ncharge^such | tncharge |
    | 0   | RAD999       | 999999   |
And I close the current editor

# Platzmenge pruefen
Given I query "gebmge,gebeinh,lj^id,orig^id,bewmge,bewlj^id,beworig^id,charge^such,tcharge,verw" from StorageQuantity for Product "RAD-05" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id          | orig^id | bewmge | bewlj^id       | beworig^id | charge^such | tcharge | verw  |
    | -4     | Stück  | !JournalAb1^id | (0,0,0) | -4     | !JournalAb1^id | (0,0,0)    | RAD777      | 777777  | rad01 |
    | -6     | Stück  | !JournalAb2^id | (0,0,0) | -6     | !JournalAb2^id | (0,0,0)    | RAD888      | 888888  | rad02 |
    | -2     | Stück  | !JournalAb3^id | (0,0,0) | -2     | !JournalAb3^id | (0,0,0)    | RAD999      | 999999  | rad03 |
And I close the current editor

# Bewertungen pruefen
Given I open an editor "BewertungRueck1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-05;buart==Zugang;ppsref^verw==rad01;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck1"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu1"
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 0    | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open an editor "BewertungRueck2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-05;buart==Zugang;ppsref^verw==rad02;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu2"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck2"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu2"
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 0    | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open an editor "BewertungRueck3" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-05;buart==Zugang;ppsref^verw==rad03;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu3"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck3"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu3"
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 8    | !JournalZu3^id | !JournalZu3^id |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 06 Ruecklieferung stornieren
Given I open an editor "RueckStorno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung"
And I set field "nummer" to "5storno"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalStorno1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;verw==rad01;detursache==Storno-Rücklieferung Einkauf"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "2"
Then field "verw" has value "rad01"
Then field "verwla" has value "rad01"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck1"
Then table has values
    | mge | ncharge^such | tncharge |
    | 0   | RAD777       | 777777   |
And I close the current editor

Given I open an editor "JournalStorno2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;verw==rad02;detursache==Storno-Rücklieferung Einkauf"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "3"
Then field "verw" has value "rad02"
Then field "verwla" has value "rad02"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck2"
Then table has values
    | mge | ncharge^such | tncharge |
    | 0   | RAD888       | 888888   |
And I close the current editor

Given I open an editor "JournalStorno3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-05;buarta==Zugang;verw==rad03;detursache==Storno-Rücklieferung Einkauf"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "1"
Then field "verw" has value "rad03"
Then field "verwla" has value "rad03"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck3"
Then table has values
    | mge | ncharge^such | tncharge |
    | 0   | RAD999       | 999999   |
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-05" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

# Bewertungen pruefen
Given I open an editor "BewertungStorno1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-05;buart==Zugang;ppsref^verw==rad01;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "stornoverur^id" has value equal to field "id" from editor "JournalStorno1"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungRueck1"
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 4    | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open an editor "BewertungStorno2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-05;buart==Zugang;ppsref^verw==rad02;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu2"
Then field "stornoverur^id" has value equal to field "id" from editor "JournalStorno2"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungRueck2"
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 6    | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open an editor "BewertungStorno3" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-05;buart==Zugang;ppsref^verw==rad03;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu3"
Then field "stornoverur^id" has value equal to field "id" from editor "JournalStorno3"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungRueck3"
Then table has values
    | tmge | orig^id        | beworig^id     |
    | 10   | !JournalZu3^id | !JournalZu3^id |
And I close the current editor
