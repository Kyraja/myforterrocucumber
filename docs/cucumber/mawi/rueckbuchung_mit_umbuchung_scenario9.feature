# *****************************************************************************
#  Name             : rueckbuchung_mit_umbuchung_scenario9.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Ruecklieferung und neuen Zugang
#                     nach mehrfacher Umlagerung
#
# Getestet wird das Scenario aus BW2-1222:
#  - Zugang EK-Rechnung mit Lagerbewegung (10 Paar auf MLF01, Preis 10.00)
#  - 10 Paar Umlagern ueber Rechnung in externe Lagergruppe mit Transportkosten
#  - 10 Paar weiter Umlagern auf andere externe Lagergruppe mit Transportkosten
#  - Ruecklieferung auf Zugang (-10 Paar von MLF01)
#  - Neuen Zugang ueber EK-Rechnung mit Lagerbewegung (10 Paar auf MLF01, Preis 11.00)
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_mit_umbuchung_scenario9.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: 01 Artikel kopieren
Given I open an editor "RAD-09" from table "(Part):(Product)" with command "COPY" for record "RAD"
And I set field "such" to "RAD-09"
And I set field "chverfolgung" to ""
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 02 Rad einkaufen
Given I open an editor "RechnungmLZu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 9zu1     |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang91 |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | he   | preis |
    | RAD-09  | 10  | Paar | 10.00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "RAD-09" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Journaleintraege pruefen
Given I open an editor "JournalZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-09;buarta==Zugang;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "10"
Then field "mge" has value "20"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-09" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 20     | Stück  | !JournalZu^id | !JournalZu^id | 20     | !JournalZu^id | !JournalZu^id |
And I close the current editor

# Bewertungen pruefen
Given I open an editor "BewertungZu" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-09;buart==Zugang;"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 20   | !JournalZu^id | !JournalZu^id | 5.0000 | 0.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 03 Rad umlagern in externe Lagergruppe mit Transportkosten
Given I open an editor "RechnungmLUm" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 9um1        |
    | bsart    | Umlagern    |
    | lief     | PUKY        |
    | vom      | .           |
    | ebeleg   | Umlagern091 |
    | ueb      | ja          |
    | fakt     | ja          |
    | erfwaehr | DEM         |
And I append rows
    | artikel | mge | he   | preis | abplatz | platz |
    | RAD-09  | 10  | Paar |  2.00 | MLF01   | L3F1  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "RAD-09" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Journaleintraege pruefen
Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-09;buarta==Abgang;detursache==Umlagerungsrechnung Einkauf;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "MLF01"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 20  | !JournalZu^id | !JournalZu^id | 20     | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-09;buarta==Zugang;detursache==Umlagerungsrechnung Einkauf"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "L3F1"
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "RAD-09" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "RAD-09" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id       | bewmge | bewlj^id         | beworig^id    |
    | 20     | Stück  | !JournalUmZu1^id | !JournalZu^id | 20     | !JournalUmZu1^id | !JournalZu^id |
And I close the current editor

# Umlagerungsbewertungen pruefen - wichtig sind die additiven Kosten
Given I open an editor "BewertungUmAb1a" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-09;buart==Abgang;detursache==Umlagerungsrechnung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb1"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 20   | !JournalZu^id | !JournalZu^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmZu1a" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-09;buart==Zugang;detursache==Umlagerungsrechnung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu1"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 20   | !JournalZu^id | !JournalZu^id | 6.0000 | 1.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 04 Zweite Umlagerung mit Transportkosten
Given I open an editor "RechnungmLUm2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 9um2        |
    | bsart    | Umlagern    |
    | lief     | PUKY        |
    | vom      | .           |
    | ebeleg   | Umlagern092 |
    | ueb      | ja          |
    | fakt     | ja          |
    | erfwaehr | DEM         |
And I append rows
    | artikel | mge | he   | preis | abplatz | platz |
    | RAD-09  | 10  | Paar |  3.00 | L3F1    | L2F1  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "RAD-09" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Journaleintraege pruefen
Given I open an editor "JournalUmAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-09;buarta==Abgang;detursache==Umlagerungsrechnung Einkauf;@richtung=rückwärts;@maxtreffer=1"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "L3F1"
Then table has values
    | mge | lj^id            | orig^id       | bewmge | bewlj^id         | beworig^id    |
    | 20  | !JournalUmZu1^id | !JournalZu^id | 20     | !JournalUmZu1^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-09;buarta==Zugang;detursache==Umlagerungsrechnung Einkauf;@richtung=rückwärts;@maxtreffer=1"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "L2F1"
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "RAD-09" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "RAD-09" on StorageLocation "L3F1"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "RAD-09" on StorageLocation "L2F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id       | bewmge | bewlj^id         | beworig^id    |
    | 20     | Stück  | !JournalUmZu2^id | !JournalZu^id | 20     | !JournalUmZu2^id | !JournalZu^id |
And I close the current editor

# Umlagerungsbewertungen pruefen - wichtig sind die additiven Kosten
Given I open an editor "BewertungUmAb2a" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-09;buart==Abgang;detursache==Umlagerungsrechnung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb2"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 20   | !JournalZu^id | !JournalZu^id | 6.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmZu2a" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-09;buart==Zugang;detursache==Umlagerungsrechnung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu2"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 20   | !JournalZu^id | !JournalZu^id | 7.5000 | 1.5000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 05 Ruecklieferung auf Zugang
Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set field "nummer" to "9rueck"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-10" in row 1
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "RAD-09" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Journaleintraege pruefen
Given I open an editor "JournalRueck" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-09;buarta==Zugang;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "-10"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-09" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id | bewmge | bewlj^id         | beworig^id |
    | -20    | Stück  | !JournalUmAb1^id | (0,0,0) | -20    | !JournalUmAb1^id | (0,0,0)    |
And I close the current editor

Given I query StorageQuantity for Product "RAD-09" on StorageLocation "L3F1"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "RAD-09" on StorageLocation "L2F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id | bewmge | bewlj^id         | beworig^id |
    | 20     | Stück  | !JournalUmZu2^id | (0,0,0) | 20     | !JournalUmZu2^id | (0,0,0)    |
And I close the current editor

# Bewertungen pruefen
Given I open an editor "BewertungRueck" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-09;buart==Zugang;detursache==Rücklieferung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 0    | !JournalZu^id | !JournalZu^id | 5.0000 | 0.0000    |
And I close the current editor

And I open an editor "BewertungUmAb1a" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmAb1a"
Then field "ablagef" has value "ja"
Then field "nachfolger" is not empty
And I close the current editor

And I open an editor "BewertungUmZu1a" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmZu1a"
Then field "ablagef" has value "ja"
Then field "nachfolger" is not empty
And I close the current editor

Given I open an editor "BewertungUmAb1b" via ID from editor "BewertungUmAb1a" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "ablagef" has value "ja"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb1"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmAb1a"
Then field "nachfolger" is not empty
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck"
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id | beworig^id | tbewpr | addkosten |
    | 20   | (0,0,0) | (0,0,0)    | 7.5000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmZu1b" via ID from editor "BewertungUmZu1a" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "ablagef" has value "ja"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu1"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu1a"
Then field "nachfolger" is not empty
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck"
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 20   | (0,0,0)       | (0,0,0)       | 8.5000 | 1.0000    |
    | 20   | !JournalZu^id | !JournalZu^id | 6.0000 | 1.0000    |
And I close the current editor

And I open an editor "BewertungUmAb2a" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmAb2a"
Then field "ablagef" has value "ja"
Then field "nachfolger" is not empty
And I close the current editor

And I open an editor "BewertungUmZu2a" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmZu2a"
Then field "ablagef" has value "ja"
Then field "nachfolger" is not empty
And I close the current editor

# Keine Ruecknahmeverursacher in Bewertungen fuer zweite Umlagerung
Given I open an editor "BewertungUmAb2b" via ID from editor "BewertungUmAb2a" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "ablagef" has value "nein"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb2"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmAb2a"
Then field "nachfolger" is empty
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id | beworig^id | tbewpr | addkosten |
    | 20   | (0,0,0) | (0,0,0)    | 6.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmZu2b" via ID from editor "BewertungUmZu2a" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "ablagef" has value "nein"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu2"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu2a"
Then field "nachfolger" is empty
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 20   | (0,0,0)       | (0,0,0)       | 7.5000 | 1.5000    |
    | 20   | !JournalZu^id | !JournalZu^id | 7.5000 | 1.5000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 06 Neuen Zugang buchen
Given I open an editor "RechnungmLZu2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 9zu2     |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang92 |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | he   | preis |
    | RAD-09  | 10  | Paar | 11.00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "RAD-09" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Journaleintraege pruefen
Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-09;buarta==Zugang;@richtung=rückwärts;@maxtreffer=1"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "10"
Then field "mge" has value "20"
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "RAD-09" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-09" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "RAD-09" on StorageLocation "L3F1"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "RAD-09" on StorageLocation "L2F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id            | orig^id        | bewmge | bewlj^id         | beworig^id     |
    | 20     | Stück  | !JournalUmZu2^id | !JournalZu2^id | 20     | !JournalUmZu2^id | !JournalZu2^id |
And I close the current editor

# Bewertungen pruefen
Given I open an editor "BewertungZu2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-09;buart==Zugang;detursache==Rechnung;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu2"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu2^id | !JournalZu2^id | 5.5000 | 0.0000    |
And I close the current editor

And I open an editor "BewertungUmAb1b" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmAb1b"
Then field "ablagef" has value "ja"
Then field "nachfolger" is not empty
And I close the current editor

And I open an editor "BewertungUmZu1b" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmZu1b"
Then field "ablagef" has value "ja"
Then field "nachfolger" is not empty
And I close the current editor

Given I open an editor "BewertungUmAb1c" via ID from editor "BewertungUmAb1b" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "ablagef" has value "ja"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb1"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmAb1b"
Then field "nachfolger" is not empty
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id | beworig^id | tbewpr | addkosten |
    | 20   | (0,0,0) | (0,0,0)    | 5.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmZu1c" via ID from editor "BewertungUmZu1b" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "ablagef" has value "ja"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu1"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu1b"
Then field "nachfolger" is not empty
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id | beworig^id | tbewpr | addkosten |
    | 20   | (0,0,0) | (0,0,0)    | 6.0000 | 1.0000    |
And I close the current editor

And I open an editor "BewertungUmAb2b" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmAb2b"
Then field "ablagef" has value "ja"
Then field "nachfolger" is not empty
And I close the current editor

And I open an editor "BewertungUmZu2b" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungUmZu2b"
Then field "ablagef" has value "ja"
Then field "nachfolger" is not empty
And I close the current editor

Given I open an editor "BewertungUmAb2c" via ID from editor "BewertungUmAb2b" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "ablagef" has value "nein"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb2"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmAb2b"
Then field "nachfolger" is empty
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu2^id | !JournalZu2^id | 6.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmZu2c" via ID from editor "BewertungUmZu2b" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "ablagef" has value "nein"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu2"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu2b"
Then field "nachfolger" is empty
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id        | beworig^id     | tbewpr | addkosten |
    | 20   | !JournalZu2^id | !JournalZu2^id | 7.5000 | 1.5000    |
    | 20   | (0,0,0)        | (0,0,0)        | 7.5000 | 1.5000    |
And I close the current editor
