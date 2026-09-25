# *****************************************************************************
#  Name             : rueckbuchung_um_mit_mz_scenario02.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Ruecklieferung und Storno-Ruecklieferung
#                     nach Umlagerung mit MZs
#
# Getestet wird das Scenario aus BW2-1146:
#  - Zugang EK-Rechnung mit Lagerbewegung und MZ auf 2 Plaetze
#  - Zugaenge Umlagern auf 2 verschiedene Plaetze
#  - Teilweise Ruecklieferung des Zugangs von Originalzugangsplaetzen
#  - Storno der Ruecklieferung
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_um_mit_mz_scenario02.feature
Background:
Given I set the fake date to "12.01.95"

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 01 Artikel kopieren
Given I open an editor "RAD-02" from table "(Part):(Product)" with command "COPY" for record "RAD"
And I set field "such" to "RAD-02"
And I set field "chverfolgung" to ""
# Bewertunsgverfahren "Preis des Zugangs/Vorgangspreis" setzen
And I set field "ekbewverf" to "5"
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 02 Rad einkaufen
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
    | artikel | mge | he   | preis |
    | RAD-02  | 50  | Paar | 10.00 |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | MLF01  | 25     |
    | WELA   | 25     |
And I save the current subeditor to switch back to the parent editor
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;platz==MLF01;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "25"
Then field "mge" has value "50"
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;platz==WELA;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "25"
Then field "mge" has value "50"
And I close the current editor


# Platzmengen
Given I query StorageQuantity for Product "RAD-02" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh  | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 50     | Stück   | !JournalZu1^id | !JournalZu1^id | 50     | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I query StorageQuantity for Product "RAD-02" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh  | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 50     | Stück   | !JournalZu2^id | !JournalZu2^id | 50     | !JournalZu2^id | !JournalZu2^id |
And I close the current editor


# Bewertungen
Given I open latest Valuation "BewertungZu1-1" for Product "RAD-02" and valuation transaction "JournalZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 50   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungZu2-1" for Product "RAD-02" and valuation transaction "JournalZu2" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu2"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 50   | !JournalZu2^id | !JournalZu2^id | 5.0000 | 0.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 03 Bestaende umlagern mit MZs fuer Abgaenge und Zugaenge
Given I open an editor "Bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | nummer   | 2be        |
    | bsart    | Umlagern   |
    | lief     | PUKY       |
    | vom      | .          |
    | ebeleg   | Umlagern02 |
    | erfwaehr | DEM        |
And I append rows
    | artikel | mge | he   | preis | abplatz | platz |
    | RAD-02  | 25  | Paar | 2.00  | MLF01   | L3F1  |
	| RAD-02  | 25  | Paar | 2.00  | WELA    | L3F1  |
# 1428 Für Beschaffungsart Umlagern nicht erlaubt
Then pressing button "mzabsm" in row 1 to open a subeditor throws the exception "1428"
And I press button "mzsubm" to open a subeditor for "MzZu" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | einh |
    | L3F1   | 25     | Paar |
# lpsuch ist Zugangsplatz; umplatz ist Abgangsplatz und wird aus Postion uebernommen, ist nicht aenderbar
Then field "umplatz" has value "MLF01" in row 1
Then field "umplatz" is not modifiable in row 1
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "MzZu" in row 2
And I delete all rows
And I append rows
    | lpsuch | zuomge | einh |
    | L3F1   | 10     | Paar |
    | L3F2   | 15     | Paar |
# Abgangsplatz aus Postion uebernommen, ist nicht aenderbar
Then field "umplatz" has value "WELA" in row 1
Then field "umplatz" is not modifiable in row 1
Then field "umplatz" has value "WELA" in row 2
Then field "umplatz" is not modifiable in row 2
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Bestellung ausliefern
Given I open an editor "ReMLUm" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "Bestellung"
And I set fields
    | nummer   | 1um        |
    | fakt     | ja         |
    | ueb      | ja         |
    | vom      | .          |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Journaleintraege
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Abgang;detursache==Umlagerungsrechnung Einkauf;platz==MLF01;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "25"
Then field "mge" has value "50"
Then field "platz" has value "MLF01"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 50  | !JournalZu1^id | !JournalZu1^id | 50     | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;detursache==Umlagerungsrechnung Einkauf;platz==L3F1;mge=50;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "L3F1"
Then field "gmge" has value "25"
Then field "mge" has value "50"
Then field "lj^id" has value equal to field "id" from editor "JournalUmAb1"
And I close the current editor

Given I open an editor "JournalUmAb2a" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Abgang;detursache==Umlagerungsrechnung Einkauf;platz==WELA;mge=20;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 20  | !JournalZu2^id | !JournalZu2^id | 20     | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open an editor "JournalUmAb2b" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Abgang;detursache==Umlagerungsrechnung Einkauf;platz==WELA;mge=30;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "15"
Then field "mge" has value "30"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 30  | !JournalZu2^id | !JournalZu2^id | 30     | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open an editor "JournalUmZu2a" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;detursache==Umlagerungsrechnung Einkauf;platz==L3F1;mge=20;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "L3F1"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "lj^id" has value equal to field "id" from editor "JournalUmAb2a"
And I close the current editor

Given I open an editor "JournalUmZu2b" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;detursache==Umlagerungsrechnung Einkauf;platz==L3F2;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "L3F2"
Then field "gmge" has value "15"
Then field "mge" has value "30"
Then field "lj^id" has value equal to field "id" from editor "JournalUmAb2b"
And I close the current editor


# Platzmengen
Given I query StorageQuantity for Product "RAD-02" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh  | lj^id             | orig^id        | bewmge | bewlj^id          | beworig^id     |
    | 50     | Stück   | !JournalUmZu1^id  | !JournalZu1^id | 50     | !JournalUmZu1^id  | !JournalZu1^id |
    | 20     | Stück   | !JournalUmZu2a^id | !JournalZu2^id | 20     | !JournalUmZu2a^id | !JournalZu2^id |
And I close the current editor

Given I query StorageQuantity for Product "RAD-02" on StorageLocation "L3F2"
Then StorageQuantities have values
    | gebmge | gebeinh  | lj^id             | orig^id        | bewmge | bewlj^id          | beworig^id     |
    | 30     | Stück   | !JournalUmZu2b^id | !JournalZu2^id | 30     | !JournalUmZu2b^id | !JournalZu2^id |
And I close the current editor


# Bewertungen
Given I open latest Valuation "BewertungUmAb1-1" for Product "RAD-02" and valuation transaction "JournalUmAb1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb1"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 50   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmZu1-1" for Product "RAD-02" and valuation transaction "JournalUmZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu1"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 50   | !JournalZu1^id | !JournalZu1^id | 6.0000 | 1.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmAb2a-1" for Product "RAD-02" and valuation transaction "JournalUmAb2a" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb2a"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu2^id | !JournalZu2^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmZu2a-1" for Product "RAD-02" and valuation transaction "JournalUmZu2a" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu2a"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu2^id | !JournalZu2^id | 6.0000 | 1.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmAb2b-1" for Product "RAD-02" and valuation transaction "JournalUmAb2b" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb2b"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 30   | !JournalZu2^id | !JournalZu2^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmZu2b-1" for Product "RAD-02" and valuation transaction "JournalUmZu2b" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu2b"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 30   | !JournalZu2^id | !JournalZu2^id | 6.0000 | 1.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 04 Teilweise Ruecklieferung des Zugangs
Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set fields
    | nummer   | 2rueck     |
    | vom      | .          |
    | ueb      | ja         |
And I set field "mge" to "-30" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | MLF01  | -10    |
    | WELA   | -20    |
And I save the current subeditor to switch back to the parent editor
And I save the current editor


# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu1"
Then field "rueckgmge" has value "10"
Then field "rueckmge" has value "20"
And I close the current editor

Given I open an editor "JournalRueck1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;platz==MLF01;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MLF01"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "rueckgmge" has value "-10"
Then field "rueckmge" has value "-20"
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu2"
Then field "rueckgmge" has value "20"
Then field "rueckmge" has value "40"
And I close the current editor

Given I open an editor "JournalRueck2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;platz==WELA;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu2"
Then field "rueckgmge" has value "-20"
Then field "rueckmge" has value "-40"
And I close the current editor

Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb1"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "25"
Then field "mge" has value "50"
Then field "platz" has value "MLF01"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 30  | !JournalZu1^id | !JournalZu1^id | 30     | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open an editor "JournalUmAb2a" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb2a"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "WELA"
Then the table has 0 rows
And I close the current editor

Given I open an editor "JournalUmAb2b" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb2b"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "15"
Then field "mge" has value "30"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 10  | !JournalZu2^id | !JournalZu2^id | 10     | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu1"
And I close the current editor

Given I open an editor "JournalUmZu2a" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu2a"
And I close the current editor

Given I open an editor "JournalUmZu2b" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu2b"
And I close the current editor

# Platzmengen
Given I query StorageQuantity for Product "RAD-02" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id | bewmge | bewlj^id         | beworig^id |
    | -20    | Stück   | !JournalUmAb1^id | (0,0,0) | -20    | !JournalUmAb1^id | (0,0,0)    |
And I close the current editor

Given I query StorageQuantity for Product "RAD-02" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh  | lj^id             | orig^id | bewmge | bewlj^id          | beworig^id |
    | -20    | Stück   | !JournalUmAb2a^id | (0,0,0) | -20    | !JournalUmAb2a^id | (0,0,0)    |
	| -20    | Stück   | !JournalUmAb2b^id | (0,0,0) | -20    | !JournalUmAb2b^id | (0,0,0)    |
And I close the current editor

Given I query StorageQuantity for Product "RAD-02" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id             | orig^id        | bewmge | bewlj^id          | beworig^id     |
    | 30     | Stück  | !JournalUmZu1^id  | !JournalZu1^id | 30     | !JournalUmZu1^id  | !JournalZu1^id |
    | 20     | Stück  | !JournalUmZu2a^id | (0,0,0)        | 20     | !JournalUmZu2a^id | (0,0,0)        |
    | 20     | Stück  | !JournalUmZu1^id  | (0,0,0)        | 20     | !JournalUmZu1^id  | (0,0,0)        |
And I close the current editor

Given I query StorageQuantity for Product "RAD-02" on StorageLocation "L3F2"
Then StorageQuantities have values
    | gebmge | gebeinh  | lj^id             | orig^id        | bewmge | bewlj^id          | beworig^id     |
    | 10     | Stück   | !JournalUmZu2b^id | !JournalZu2^id | 10     | !JournalUmZu2b^id | !JournalZu2^id |
    | 20     | Stück   | !JournalUmZu2b^id | (0,0,0)        | 20     | !JournalUmZu2b^id | (0,0,0)        |
And I close the current editor


# Bewertungen
Given I open latest Valuation "BewertungZu1-2" for Product "RAD-02" and valuation transaction "JournalZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu1-1"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 30   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungZu2-2" for Product "RAD-02" and valuation transaction "JournalZu2" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu2"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu2-1"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 10   | !JournalZu2^id | !JournalZu2^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmAb1-2" for Product "RAD-02" and valuation transaction "JournalUmAb1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb1"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 30   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
    | 20   | (0,0,0)        | (0,0,0)        | 5.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmZu1-2" for Product "RAD-02" and valuation transaction "JournalUmZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu1"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 30   | !JournalZu1^id | !JournalZu1^id | 6.0000 | 1.0000    |
    | 20   | (0,0,0)        | (0,0,0)        | 6.0000 | 1.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmAb2a-2" for Product "RAD-02" and valuation transaction "JournalUmAb2a" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb2a"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | (0,0,0)        | (0,0,0)        | 5.5000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmZu2a-2" for Product "RAD-02" and valuation transaction "JournalUmZu2a" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu2a"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 10   | !JournalZu2^id | !JournalZu2^id | 5.6667 | 0.6667    |
And I close the current editor

Given I open latest Valuation "BewertungUmAb2b-2" for Product "RAD-02" and valuation transaction "JournalUmAb2b" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb2b"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 10   | !JournalZu2^id | !JournalZu2^id | 5.0000 | 0.0000    |
    | 20   | (0,0,0)        | (0,0,0)        | 5.5000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmZu2b-2" for Product "RAD-02" and valuation transaction "JournalUmZu2b" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu2b"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 10   | !JournalZu2^id | !JournalZu2^id | 6.0000 | 1.0000    |
    | 20   | (0,0,0)        | (0,0,0)        | 6.5000 | 1.0000    |
And I close the current editor


Scenario: 05 Teil-Ruecklieferung des Zugangs stornieren
Given I open an editor "StornoRueck" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung"
And I set fields
    | nummer | 2strueck |
And I save the current editor


# Journaleintraege
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu1"
Then field "rueckgmge" has value "0"
Then field "rueckmge" has value "0"
And I close the current editor

Given I open an editor "JournalRueck1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalRueck1"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "rueckgmge" has value "-10"
Then field "rueckmge" has value "-20"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalStorno1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;platz==MLF01;detursache==Storno-Rücklieferung Einkauf;"
Then field "platz" has value "MLF01"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck1"
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu2"
Then field "rueckgmge" has value "0"
Then field "rueckmge" has value "0"
And I close the current editor

Given I open an editor "JournalRueck2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalRueck2"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu2"
Then field "rueckgmge" has value "-20"
Then field "rueckmge" has value "-40"
Then field "storniert" has value "ja"
And I close the current editor

Given I open an editor "JournalStorno2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-02;buarta==Zugang;platz==WELA;detursache==Storno-Rücklieferung Einkauf;"
Then field "platz" has value "WELA"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck2"
And I close the current editor

Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb1"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "25"
Then field "mge" has value "50"
Then field "platz" has value "MLF01"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 50  | !JournalZu1^id | !JournalZu1^id | 50     | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open an editor "JournalUmAb2a" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb2a"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 20  | !JournalZu2^id | !JournalZu2^id | 20     | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open an editor "JournalUmAb2b" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb2b"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "15"
Then field "mge" has value "30"
Then field "platz" has value "WELA"
Then table has values
   | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
   | 30  | !JournalZu2^id | !JournalZu2^id | 30     | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu1"
And I close the current editor

Given I open an editor "JournalUmZu2a" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu2a"
And I close the current editor

Given I open an editor "JournalUmZu2b" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu2b"
And I close the current editor

# Platzmengen
Given I query StorageQuantity for Product "RAD-02" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh  | lj^id             | orig^id        | bewmge | bewlj^id          | beworig^id     |
    | 30     | Stück   | !JournalUmZu1^id  | !JournalZu1^id | 30     | !JournalUmZu1^id  | !JournalZu1^id |
    | 20     | Stück   | !JournalUmZu2a^id | !JournalZu2^id | 20     | !JournalUmZu2a^id | !JournalZu2^id |
    | 20     | Stück   | !JournalUmZu1^id  | !JournalZu1^id | 20     | !JournalUmZu1^id  | !JournalZu1^id |
And I close the current editor

Given I query StorageQuantity for Product "RAD-02" on StorageLocation "L3F2"
Then StorageQuantities have values
    | gebmge | gebeinh  | lj^id             | orig^id        | bewmge | bewlj^id          | beworig^id     |
    | 10     | Stück   | !JournalUmZu2b^id | !JournalZu2^id | 10     | !JournalUmZu2b^id | !JournalZu2^id |
    | 20     | Stück   | !JournalUmZu2b^id | !JournalZu2^id | 20     | !JournalUmZu2b^id | !JournalZu2^id |
And I close the current editor


# Bewertungen
Given I open latest Valuation "BewertungZu1-3" for Product "RAD-02" and valuation transaction "JournalZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu1-2"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 50   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungZu2-3" for Product "RAD-02" and valuation transaction "JournalZu2" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu2"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu2-2"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 50   | !JournalZu2^id | !JournalZu2^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmAb1-3" for Product "RAD-02" and valuation transaction "JournalUmAb1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb1"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 30   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
    | 20   | !JournalZu1^id | !JournalZu1^id | 0.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmZu1-3" for Product "RAD-02" and valuation transaction "JournalUmZu1" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu1"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 30   | !JournalZu1^id | !JournalZu1^id | 6.0000 | 1.0000    |
    | 20   | !JournalZu1^id | !JournalZu1^id | 1.0000 | 1.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmAb2a-3" for Product "RAD-02" and valuation transaction "JournalUmAb2a" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb2a"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 10   | !JournalZu2^id | !JournalZu2^id | 5.0000 | 0.0000    |
    | 10   | !JournalZu2^id | !JournalZu2^id | 0.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmZu2a-3" for Product "RAD-02" and valuation transaction "JournalUmZu2a" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu2a"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 10   | !JournalZu2^id | !JournalZu2^id | 5.6667 | 0.6667    |
    | 10   | !JournalZu2^id | !JournalZu2^id | 0.6667 | 0.6667    |
And I close the current editor

Given I open latest Valuation "BewertungUmAb2b-3" for Product "RAD-02" and valuation transaction "JournalUmAb2b" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmAb2b"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 10   | !JournalZu2^id | !JournalZu2^id | 5.0000 | 0.0000    |
    | 20   | !JournalZu2^id | !JournalZu2^id | 0.0000 | 0.0000    |
And I close the current editor

Given I open latest Valuation "BewertungUmZu2b-3" for Product "RAD-02" and valuation transaction "JournalUmZu2b" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalUmZu2b"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 10   | !JournalZu2^id | !JournalZu2^id | 6.0000 | 1.0000    |
    | 20   | !JournalZu2^id | !JournalZu2^id | 1.0000 | 1.0000    |
And I close the current editor
