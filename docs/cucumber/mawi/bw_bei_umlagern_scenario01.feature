# *****************************************************************************
#  Name             : bw_bei_umlagern_scenario01.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Bewertungen im Umlagerungskontext (mit Transportkosten etc.)
#
# Getestet wird das Scenario aus FDA-1876:
#  - Artikel PEDALE, Bewertungsverfahren: Preis des Zugangs/Vorgangspreis
#  - Bestellung im EK (100 Paar, Preis 15 þ)
#  - EK-Lieferschein (100 Paar, Preis 15 þ)
#  - 30 Paar Umlagern in externe Lagergruppe mit Transportkosten (3 þ/Paar)
#  - EK-Rechnung fuer Zugang (100 Paar, 18 þ)
#
# *****************************************************************************
@persistent
Feature: bw_bei_umlagern_scenario01.feature
Background:
Given I set the fake date to "12.01.95"


Scenario: 01 Artikel kopieren
Given I open an editor "PEDALE-01" from table "(Part):(Product)" with command "COPY" for record "PEDALE"
And I set field "such" to "PEDALE-01"
And I set field "chverfolgung" to ""
# Bewertungsverfahren "Preis des Zugangs/Vorgangspreis"
And I set field "ekbewverf" to "5"
And I set field "zuplatz" to "WELA"
And I set field "abplatz" to "ABLA"
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 02 Pedale einkaufen
And I create a PurchaseOrder "EK_Be_01" for Vendor "PUKY" with Product "PEDALE-01" and quantity "100" and price "15.00"

Given I open an editor "EK_Ls_01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "EK_Be_01"
And I set fields
    | nummer   | 1zu      |
    | vom      | .        |
    | ebeleg   | Zugang01 |
    | ueb      | ja       |
    | erfwaehr | DEM      |
And I modify table
    | !row | mge | preis |
    | 1    | 100 | 15.00 |
And I save the current editor


# Journaleintraege pruefen
Given I open an editor "JournalZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==PEDALE-01;buarta==Zugang;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "100"
Then field "mge" has value "200"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "PEDALE-01" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | gebf | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 100    | Paar    |  2	  | !JournalZu^id | !JournalZu^id | 100    | !JournalZu^id | !JournalZu^id |
And I close the current editor

# Bewertungen pruefen
Given I open latest Valuation "BewertungZu_01" for Product "PEDALE-01" and valuation transaction "JournalZu" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr  | addkosten | bewertet   |
    | 200  | !JournalZu^id | !JournalZu^id | 7.5000  | 0.0000    | vorlÃ¤ufig |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 03 Pedale umlagern in externe Lagergruppe mit Transportkosten
Given I open an editor "RechnungmLUm" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 1um1       |
    | bsart    | Umlagern   |
    | lief     | PUKY       |
    | vom      | .          |
    | ebeleg   | Umlagern01 |
    | ueb      | ja         |
    | fakt     | ja         |
    | budat    | 15.3.95    |
    | erfwaehr | DEM        |
And I append rows
    | artikel   | mge | he   | preis | abplatz | platz |
    | PEDALE-01 | 30  | Paar |  3.00 | WELA    | L3F1  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Journaleintraege pruefen
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==PEDALE-01;buarta==Abgang;detursache==Umlagerungsrechnung Einkauf;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "30"
Then field "mge" has value "60"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 60  | !JournalZu^id | !JournalZu^id | 60     | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==PEDALE-01;buarta==Zugang;detursache==Umlagerungsrechnung Einkauf"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "30"
Then field "mge" has value "60"
Then field "platz" has value "L3F1"
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "PEDALE-01" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 70     | Paar    | !JournalZu^id | !JournalZu^id | 70     | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I query StorageQuantity for Product "PEDALE-01" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id       | bewmge | bewlj^id        | beworig^id    |
    | 30     | Paar    | !JournalUmZu^id | !JournalZu^id | 30     | !JournalUmZu^id | !JournalZu^id |
And I close the current editor

# Umlagerungsbewertungen pruefen - wichtig ist der Status
Given I open latest Valuation "BewertungUmAb_01" for Product "PEDALE-01" and valuation transaction "JournalUmAb" with command "VIEW"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten | bewertet   |
    | 60   | !JournalZu^id | !JournalZu^id | 7.5000 | 0.0000    | vorlÃ¤ufig |
And I close the current editor

# Da der Originalzugang noch nicht berechnet wurde, darf die Zugangsbewertung nicht direkt bewertet sein
# Das darf erst nach Verbuchen der Rechnung auf den Zugang passieren
Given I open latest Valuation "BewertungUmZu_01" for Product "PEDALE-01" and valuation transaction "JournalUmZu" with command "VIEW"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten | bewertet   |
    | 60   | !JournalZu^id | !JournalZu^id | 9.0000 | 1.5000    | vorlÃ¤ufig |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

# Scenario: 04 Zugang berechnent - jetzt darf der Umlagerungszugang auf direkt gehen


