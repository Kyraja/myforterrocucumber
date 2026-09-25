# *****************************************************************************
#  Name             : rueckbuchung_mit_verwendung2.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Rueckbuchung mit Verwendung und Umbuchung
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_mit_verwendung2.feature
Background:
Given I set the fake date to "12.01.1995"

Scenario: 01 Artikel kopieren
Given I open an editor "RAD-02" from table "(Part):(Product)" with command "COPY" for record "RAD"
And I set field "such" to "RAD-02"
And I set field "chverfolgung" to ""
And I save the current editor


Scenario: 02 Artikel einkaufen
Given I open an editor "RechnungmLZu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 2zu      |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang02 |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | he   | preis | verw    |
    | RAD-02  | 10  | Paar | 10.00 | puky_02 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "verw" has value "puky_02"
Then field "verwla" has value "puky_02"
And I close the current editor

# Platzmenge pruefen
Given I query "gebmge,gebeinh,lj^id,orig^id,bewmge,bewlj^id,beworig^id,verw" from StorageQuantity for Product "RAD-02" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    | verw    |
    | 20     | Stück  | !JournalZu^id | !JournalZu^id | 20     | !JournalZu^id | !JournalZu^id | puky_02 |
And I close the current editor


Scenario: 03 Rad umbuchen auf unscharfe Verwendung
Given I open an editor "LBuchung" for tip command "Lbuchung" and arguments ""
And I set fields
    | artikel     | RAD-02     |
    | beleg       | Umlagern02 |
    | beldat      | .          |
    | buart       | Umbuchung  |
And I modify table
    | !row  | mge | ze   | platz | platz2 | verw    | verw2 |
    | 1     | 6   | Paar | MLF01 | ABLA   | puky_02 | puky  |
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Abgang;detursache==Manuelle Umbuchung;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "6"
Then field "mge" has value "12"
Then field "platz" has value "MLF01"
Then field "verw" has value "puky_02"
Then field "verwla" has value "puky_02"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 12  | !JournalZu^id | !JournalZu^id | 12     | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;detursache==Manuelle Umbuchung"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "6"
Then field "mge" has value "12"
Then field "platz" has value "ABLA"
Then field "verw" has value "puky"
Then field "verwla" has value "puky"
And I close the current editor

# Platzmengen pruefen
Given I query "gebmge,gebeinh,lj^id,orig^id,bewmge,bewlj^id,beworig^id,verw" from StorageQuantity for Product "RAD-02" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    | verw    |
    | 8      | Stück  | !JournalZu^id | !JournalZu^id | 8      | !JournalZu^id | !JournalZu^id | puky_02 |
And I close the current editor

Given I query "gebmge,gebeinh,lj^id,orig^id,bewmge,bewlj^id,beworig^id,verw" from StorageQuantity for Product "RAD-02" on StorageLocation "ABLA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id       | bewmge | bewlj^id        | beworig^id    | verw |
    | 12     | Stück  | !JournalUmZu^id | !JournalZu^id | 12     | !JournalUmZu^id | !JournalZu^id | puky |
And I close the current editor


Scenario: 04 Ruecklieferung auf Zugang
Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set field "nummer" to "2rueck"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-6" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "zuomge" to "-6" in row 1
And I set field "platz" to "ABLA" in row 1
And I set field "verw" to "puky" in row 1
And I save the current editor
And I switch the current editor to editor "Ruecklieferung"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalRueck" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "-6"
Then field "mge" has value "-12"
Then field "verw" has value "puky"
Then field "verwla" has value "puky"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu"
And I close the current editor

# Platzmengen pruefen
Given I query "gebmge,gebeinh,lj^id,orig^id,bewmge,bewlj^id,beworig^id,verw" from StorageQuantity for Product "RAD-02" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    | verw    |
    | 8      | Stück  | !JournalZu^id | !JournalZu^id | 8      | !JournalZu^id | !JournalZu^id | puky_02 |
And I close the current editor

Given I query StorageQuantity for Product "RAD-02" on StorageLocation "ABLA"
Then StorageQuantity is zero
And I close the current editor


Scenario: 05 Ruecklieferung wieder stornieren
Given I open an editor "RueckStorno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung"
And I set field "nummer" to "2storno"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalStorno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;detursache==Storno-Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "6"
Then field "mge" has value "12"
Then field "verw" has value "puky"
Then field "verwla" has value "puky"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck"
And I close the current editor

# Platzmengen pruefen
Given I query "gebmge,gebeinh,lj^id,orig^id,bewmge,bewlj^id,beworig^id,verw" from StorageQuantity for Product "RAD-02" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    | verw    |
    | 8      | Stück  | !JournalZu^id | !JournalZu^id | 8      | !JournalZu^id | !JournalZu^id | puky_02 |
And I close the current editor

Given I query "gebmge,gebeinh,lj^id,orig^id,bewmge,bewlj^id,beworig^id,verw" from StorageQuantity for Product "RAD-02" on StorageLocation "ABLA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id       | bewmge | bewlj^id        | beworig^id    | verw |
    | 12     | Stück  | !JournalUmZu^id | !JournalZu^id | 12     | !JournalUmZu^id | !JournalZu^id | puky |
And I close the current editor
