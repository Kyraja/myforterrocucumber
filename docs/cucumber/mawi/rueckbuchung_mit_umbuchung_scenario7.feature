# *****************************************************************************
#  Name             : rueckbuchung_mit_umbuchung_scenario7.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Ruecklieferung und Storno-Ruecklieferung
#                     nach Umlagerung in andere Lagergruppe
#
# Getestet wird das Scenario aus BW2-1149:
#  - Zugang EK-Rechnung mit Lagerbewegung (10 Paar auf MLF01, Preis 10.00)
#  - 10 Paar Umlagern ueber Rechnung in externe Lagergruppe mit Transportkosten 
#  - Ruecklieferung auf Zugang (-10 Paar von MLF01)
#  - Neuer Zugang (10 Paar auf MLF01, Preis 12.00)
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_mit_umbuchung_scenario7.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: 01 Artikel kopieren
Given I open an editor "RAD-07" from table "(Part):(Product)" with command "COPY" for record "RAD"
And I set field "such" to "RAD-07"
And I set field "chverfolgung" to ""
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 02 Rad einkaufen
Given I open an editor "RechnungmLZu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 7zu      |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang07 |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | he   | preis |
    | RAD-07  | 10  | Paar | 10.00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-07;buarta==Zugang;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "10"
Then field "mge" has value "20"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-07" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 20     | Stück  | !JournalZu1^id | !JournalZu1^id | 20     | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

# Bewertungen pruefen
Given I open an editor "BewertungZu1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-07;buart==Zugang;"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 03 Rad umlagern in externe Lagergruppe mit Transportkosten
Given I open an editor "RechnungmLUm" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 7um        |
    | bsart    | Umlagern   |
    | lief     | PUKY       |
    | vom      | .          |
    | ebeleg   | Umlagern07 |
    | ueb      | ja         |
    | fakt     | ja         |
    | erfwaehr | DEM        |
And I append rows
    | artikel | mge | he   | preis | abplatz | platz |
    | RAD-07  | 10  | Paar |  2.00 | MLF01   | L3F1  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-07;buarta==Abgang;detursache==Umlagerungsrechnung Einkauf;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "MLF01"
Then table has values
    | mge | lj^id          | orig^id        | bewmge | bewlj^id       | beworig^id     |
    | 20  | !JournalZu1^id | !JournalZu1^id | 20     | !JournalZu1^id | !JournalZu1^id |
And I close the current editor

Given I open an editor "JournalUmZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-07;buarta==Zugang;detursache==Umlagerungsrechnung Einkauf"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "L3F1"
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "RAD-07" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "RAD-07" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id        | bewmge | bewlj^id        | beworig^id     |
    | 20     | Stück  | !JournalUmZu^id | !JournalZu1^id | 20     | !JournalUmZu^id | !JournalZu1^id |
And I close the current editor

Given I open an editor "BewertungUmAb1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-07;buart==Abgang;detursache==Umlagerungsrechnung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

# Umlagerungsbewertungen pruefen - wichtig sind die additiven Kosten
Given I open an editor "BewertungUmZu1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-07;buart==Zugang;detursache==Umlagerungsrechnung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu1^id | !JournalZu1^id | 6.0000 | 1.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 04 Ruecklieferung auf Zugang
Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set field "nummer" to "7rueck"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-10" in row 1
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalRueck" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-07;buarta==Zugang;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "-10"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu1"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-07" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id | bewmge | bewlj^id        | beworig^id |
    | -20    | Stück  | !JournalUmAb^id | (0,0,0) | -20    | !JournalUmAb^id | (0,0,0)    |
And I close the current editor

Given I query StorageQuantity for Product "RAD-07" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id | bewmge | bewlj^id        | beworig^id |
    | 20     | Stück  | !JournalUmZu^id | (0,0,0) | 20     | !JournalUmZu^id | (0,0,0)    |
And I close the current editor

# Bewertungen pruefen
Given I open an editor "BewertungRueck" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-07;buart==Zugang;detursache==Rücklieferung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu1"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu1"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 0    | !JournalZu1^id | !JournalZu1^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmAb1" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmAb1"
Then field "ablagef" has value "ja"
Then field "nachfolger" is not empty
And I close the current editor

Given I open an editor "BewertungUmZu1" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmZu1"
Then field "ablagef" has value "ja"
Then field "nachfolger" is not empty
And I close the current editor

Given I open an editor "BewertungUmAb2" via ID from editor "BewertungUmAb1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmAb1"
Then field "nachfolger" is not empty
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck"
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id | beworig^id | tbewpr | addkosten | koreso | koreha |
    | 20   | (0,0,0) | (0,0,0)    | 6.0000 | 0.0000    | 5aoz   | 7aoz   |
And I close the current editor

Given I open an editor "BewertungUmZu2" via ID from editor "BewertungUmZu1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu1"
Then field "nachfolger" is not empty
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck"
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id | beworig^id | tbewpr | addkosten | koreso | koreha |
    | 20   | (0,0,0) | (0,0,0)    | 7.0000 | 1.0000    | 7aoz   | 5aoz   |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 05 Neuen Zugang buchen mit anderem Preis
Given I open an editor "RechnungmLZu2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 6zu2       |
    | lief     | PUKY       |
    | vom      | .          |
    | ebeleg   | Zugang07-2 |
    | ueb      | ja         |
    | fakt     | ja         |
    | erfwaehr | DEM        |
And I append rows
    | artikel | mge | he   | preis | konto |
    | RAD-07  | 10  | Paar | 12.00 | 10012 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten
And I run Revaluation

# Journaleintraege pruefen
Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-07;buarta==Zugang;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-07" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "RAD-07" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id        | bewmge | bewlj^id        | beworig^id     |
    | 20     | Stück  | !JournalUmZu^id | !JournalZu2^id | 20     | !JournalUmZu^id | !JournalZu2^id |
And I close the current editor

# Bewertungen pruefen
Given I open an editor "BewertungZu2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-07;buart==Zugang;detursache==Rechnung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu2"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu2^id | !JournalZu2^id | 6.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmAb3" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-07;buart==Abgang;detursache==Umlagerungsrechnung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten | koreha |
    | 20   | !JournalZu2^id | !JournalZu2^id | 5.0000 | 0.0000    | 10012  |
And I close the current editor

Given I open an editor "BewertungUmZu3" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-07;buart==Zugang;detursache==Umlagerungsrechnung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten | koreso |
    | 20   | !JournalZu2^id | !JournalZu2^id | 6.0000 | 1.0000    | 10012  |
And I close the current editor
