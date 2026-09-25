# *****************************************************************************
#  Name             : rueckbuchung_zu_ab_prozess01.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet die Rueckbuchung bei Zugang mit mehreren
#                     Abgaengen, Umlagerungen und Storno-Rueckbuchung
#
# Ablauf:
#    1. Zugang buchen: 10 Paar auf Platz WELA (Preis 10.00 DEM)
#    2. Umbuchen:      10 Paar von Platz WELA nach ABLA (ohne Transportkosten)
#    3. Abgang buchen: 10 Paar von Platz ABLA
#    4. Zugang rueckbuchen: -4 Paar von Platz WELA
#    5. Zweiten Zugang buchen: 4 Paar auf Platz WELA (Preis 12.00 DEM)
#    6. Zweiten Zugang wieder stornieren: -4 Paar von Platz WELA
#    7. Rueckbuchung auf ersten Zugang stornieren: 4 Paar auf Platz WELA
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_zu_ab_prozess01.feature

Background:
Given I set the fake date to "12.01.95"

Scenario: 01 Artikel kopieren
Given I open an editor "RAD-01" from table "(Part):(Product)" with command "COPY" for record "RAD"
And I set field "such" to "RAD-01"
And I set field "chverfolgung" to ""
And I set field "dispoa" to "bedarfsbezogen"
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 02 Rad einkaufen
Given I open an editor "RechnungmLZu1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 1zu02    |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang01 |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | he   | preis | platz |
    | RAD-01  | 10  | Paar | 10.00 | WELA  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Zugang;ebeleg==Zugang01"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "10"
Then field "mge" has value "20"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-01" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 20     | Stück  | !JournalZu1^id | !JournalZu1^id | 20     | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

# Bewertungen pruefen
Given I open an editor "BewertungZu1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Zugang;"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 03 Rad umlagern auf Warenabgangsplatz (ohne Transportkosten)
Given I transfer StorageQuantity of "20" for Product "RAD-01" from StorageLocation "WELA" to "ABLA" with document "Umlagern01"

# Journaleintraege pruefen
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Abgang;detursache==Manuelle Umbuchung;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "20"
Then field "mge" has value "20"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 20  | !JournalZu1^id | !JournalZu1^id | 20     | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open an editor "JournalUmZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Zugang;detursache==Manuelle Umbuchung;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "20"
Then field "mge" has value "20"
Then field "platz" has value "ABLA"
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "RAD-01" on StorageLocation "WELA"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "RAD-01" on StorageLocation "ABLA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id        | bewmge | bewlj^id        | beworig^id     |
    | 20     | Stück  | !JournalUmZu^id | !JournalZu1^id | 20     | !JournalUmZu^id | !JournalZu1^id |
And I close the current editor

# Bewertungen pruefen
Given I open an editor "BewertungUmAb1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Abgang;detursache==Manuelle Umbuchung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmZu1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Zugang;detursache==Manuelle Umbuchung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 04 Rad verkaufen
Given I create a SalesOrder "Auftrag" for Customer "RADSHOP" with Product "RAD-01" and quantity "10"

Given I open an editor "VKLieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to "id" from editor "Auftrag"
And I set field "ueb" to "ja"
And I set field "mge" to "10" in row 1
And I set field "platz" to "ABLA" in row 1
And I save the current editor

# Journaleintrag pruefen
Given I open an editor "JournalAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Abgang;detursache==Lieferschein Verkauf;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "ABLA"
Then table has values
    | mge | lj^id           | orig^id        | bewmge | bewlj^id        | beworig^id     |
    | 20  | !JournalUmZu^id | !JournalZu1^id | 20     | !JournalUmZu^id | !JournalZu1^id |
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-01" on StorageLocation "ABLA"
Then StorageQuantity is zero
And I close the current editor

# Bewertung pruefen
Given I open an editor "BewertungAb1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Abgang;detursache==Lieferschein Verkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Lieferschein Verkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalAb"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 05 Rueckbuchung auf den ersten Zugang
Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu1"
And I set field "nummer" to "1rueck"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-4" in row 1
And I save the current editor

# Nachbewerten
And I run Revaluation

# Journaleintrag Zugang
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu1"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "rueckmge" has value "8"
Then field "rueckgmge" has value "4"
And I close the current editor

# Journaleintrag Rueckbuchung
Given I open an editor "JournalRueck" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Zugang;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "-4"
Then field "mge" has value "-8"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu1"
And I close the current editor

# Journal Umlagerungsabgang
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "20"
Then field "mge" has value "20"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 12  | !JournalZu1^id | !JournalZu1^id | 12     | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

# Journaleintrag Abgang
Given I open an editor "JournalAb" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalAb"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "ABLA"
Then table has values
    | mge | lj^id           | orig^id        | bewmge | bewlj^id        | beworig^id     |
    | 12  | !JournalUmZu^id | !JournalZu1^id | 12     | !JournalUmZu^id | !JournalZu1^id |
    | 8   | !JournalUmZu^id | (0,0,0)        | 8      | !JournalUmZu^id | (0,0,0)        |
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "RAD-01" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id | bewmge | bewlj^id        | beworig^id |
    | -8     | Stück  | !JournalUmAb^id | (0,0,0) | -8     | !JournalUmAb^id |  (0,0,0)   |
And I close the current editor

Given I query StorageQuantity for Product "RAD-01" on StorageLocation "ABLA"
Then StorageQuantity is zero
And I close the current editor

# Bewertung zu Rueckbuchung pruefen
Given I open an editor "BewertungRueck" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Zugang;detursache==Rücklieferung Einkauf;"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu1"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 12   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

# Umlagerungsbewertungen pruefen
Given I open an editor "BewertungUmAb2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Abgang;detursache==Manuelle Umbuchung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmAb1"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 12   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
    | 8    | (0,0,0)        | (0,0,0)        | 5.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmZu2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Zugang;detursache==Manuelle Umbuchung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu1"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 12   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
    | 8    | (0,0,0)        | (0,0,0)        | 5.0000 | 0.0000    |
And I close the current editor

# Abgangsbewertung pruefen
Given I open an editor "BewertungAb2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Abgang;detursache==Lieferschein Verkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Lieferschein Verkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalAb"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungAb1"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 12   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
    | 8    | (0,0,0)        | (0,0,0)        | 5.0000 | 0.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 06 Zweiten Zugang buchen
Given I open an editor "RechnungmLZu2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 2zu      |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang02 |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | he   | preis | platz |
    | RAD-01  | 4   | Paar | 12.00 | WELA  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintrag zweiter Zugang
Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Zugang;ebeleg==Zugang02;"
Then field "buarta" has value "Zugang"
Then field "detursache" has value "Rechnung"
Then field "platz" has value "WELA"
Then field "gmge" has value "4"
Then field "mge" has value "8"
And I close the current editor

# Journaleintrag Umlagerungsabgang
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "20"
Then field "mge" has value "20"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 12  | !JournalZu1^id | !JournalZu1^id | 12     | !JournalZu1^id | !JournalZu1^id |
    | 8   | !JournalZu2^id | !JournalZu2^id | 8      | !JournalZu2^id | !JournalZu2^id |
And I close the current editor

# Journaleintrag Abgang
Given I open an editor "JournalAb" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalAb"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "ABLA"
Then table has values
    | mge | lj^id           | orig^id        | bewmge | bewlj^id        | beworig^id     |
    | 12  | !JournalUmZu^id | !JournalZu1^id | 12     | !JournalUmZu^id | !JournalZu1^id |
    | 8   | !JournalUmZu^id | !JournalZu2^id | 8      | !JournalUmZu^id | !JournalZu2^id |
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-01" on StorageLocation "WELA"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "RAD-01" on StorageLocation "ABLA"
Then StorageQuantity is zero
And I close the current editor

# Bewertung zu zweitem Zugang
Given I open an editor "BewertungZu2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Zugang;detursache==Rechnung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu2"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 8    | !JournalZu2^id | !JournalZu2^id | 6.0000 | 0.0000    |
And I close the current editor

# Umlagerungsbewertungen pruefen
Given I open an editor "BewertungUmAb3" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Abgang;detursache==Manuelle Umbuchung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmAb2"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 12   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
    | 8    | !JournalZu2^id | !JournalZu2^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmZu3" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Zugang;detursache==Manuelle Umbuchung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu2"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 12   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
    | 8    | !JournalZu2^id | !JournalZu2^id | 5.0000 | 0.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 07 Zweiten Zugang wieder stornieren
Given I open an editor "Zugang2Storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RechnungmLZu2"
And I set field "nummer" to "2storno"
And I save the current editor

# Nachbewerten
And I run Revaluation

# Journaleintrag zweiter Zugang
Given I open an editor "JournalZu2Storno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Zugang;detursache==Storno-Rechnung Einkauf"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "-4"
Then field "mge" has value "-8"
Then field "stornolj^id" has value equal to field "id" from editor "JournalZu2"
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu2"
Then field "storniert" has value "ja"
And I close the current editor

# Journaleintrag Umlagerungsabgang
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "20"
Then field "mge" has value "20"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 12  | !JournalZu1^id | !JournalZu1^id | 12     | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

# Journaleintrag Abgang
Given I open an editor "JournalAb" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalAb"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "ABLA"
Then table has values
    | mge | lj^id           | orig^id        | bewmge | bewlj^id        | beworig^id     |
    | 12  | !JournalUmZu^id | !JournalZu1^id | 12     | !JournalUmZu^id | !JournalZu1^id |
    | 8   | !JournalUmZu^id | (0,0,0)        | 8      | !JournalUmZu^id | (0,0,0)        |
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "RAD-01" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id | bewmge | bewlj^id        | beworig^id |
    | -8     | Stück  | !JournalUmAb^id | (0,0,0) | -8     | !JournalUmAb^id |  (0,0,0)   |
And I close the current editor

Given I query StorageQuantity for Product "RAD-01" on StorageLocation "ABLA"
Then StorageQuantity is zero
And I close the current editor

# Bewertung zu Rueckbuchung pruefen
Given I open an editor "BewertungStornoZu2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Zugang;detursache==Storno-Rechnung Einkauf;"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu2"
Then field "stornoverur^id" has value equal to field "id" from editor "JournalZu2Storno"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu2"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id | beworig^id | tbewpr | addkosten |
    | 0    | (0,0,0) | (0,0,0)    | 6.0000 | 0.0000    |
And I close the current editor

# Umlagerungsbewertungen pruefen
Given I open an editor "BewertungUmAb4" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Abgang;detursache==Manuelle Umbuchung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmAb3"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 12   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
    | 8    | (0,0,0)        | (0,0,0)        | 5.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmZu4" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Zugang;detursache==Manuelle Umbuchung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu3"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 12   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
    | 8    | (0,0,0)        | (0,0,0)        | 5.0000 | 0.0000    |
And I close the current editor

# Abgangsbewertung pruefen
Given I open an editor "BewertungAb3" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Abgang;detursache==Lieferschein Verkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Lieferschein Verkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalAb"
# Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungAb2"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 12   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
    | 8    | (0,0,0)        | (0,0,0)        | 5.0000 | 0.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 08 Ruecklieferung auf ersten Zugang wieder stornieren
Given I open an editor "StornoRb" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung"
And I set field "nummer" to "1rbs"
And I save the current editor

# Nachbewerten
And I run Revaluation

# Journaleintrag des ersten Zugangs
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalZu1"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "mge" has value "20"
Then field "rueckmge" has value "0"
And I close the current editor

# Journaleintrag Rueckbuchung
Given I open an editor "JournalRueck" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalRueck"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "-4"
Then field "mge" has value "-8"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu1"
Then field "storniert" has value "ja"
And I close the current editor

# Journaleintrag der Storno-Rueckbuchung
Given I open an editor "JournalStornoRb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-01;buarta==Zugang;detursache==Storno-Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "4"
Then field "mge" has value "8"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck"
And I close the current editor

# Journaleintraege Umlagerung
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmAb"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "20"
Then field "mge" has value "20"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 20  | !JournalZu1^id | !JournalZu1^id | 20     | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open an editor "JournalUmZu" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalUmZu"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "20"
Then field "mge" has value "20"
Then field "platz" has value "ABLA"
And I close the current editor

# Journaleintrag Abgang
Given I open an editor "JournalAb" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalAb"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "ABLA"
Then table has values
    | mge | lj^id           | orig^id        | bewmge | bewlj^id        | beworig^id     |
    | 20  | !JournalUmZu^id | !JournalZu1^id | 20     | !JournalUmZu^id | !JournalZu1^id |
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "RAD-01" on StorageLocation "WELA"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "RAD-01" on StorageLocation "ABLA"
Then StorageQuantity is zero
And I close the current editor

# Bewertung zu Storno der Rueckbuchung pruefen
Given I open an editor "BewertungStornoRb" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Zugang;detursache==Storno-Rücklieferung Einkauf;"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "stornoverur^id" has value equal to field "id" from editor "JournalStornoRb"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungRueck"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

# Umlagerungsbewertungen pruefen
Given I open an editor "BewertungUmAb5" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Abgang;detursache==Manuelle Umbuchung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmAb4"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmZu5" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Zugang;detursache==Manuelle Umbuchung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Manuelle Umbuchung"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu4"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 12   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
    | 8    | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

# Abgangsbewertung pruefen
Given I open an editor "BewertungAb4" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-01;buart==Abgang;detursache==Lieferschein Verkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Lieferschein Verkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalAb"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungAb3"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor
