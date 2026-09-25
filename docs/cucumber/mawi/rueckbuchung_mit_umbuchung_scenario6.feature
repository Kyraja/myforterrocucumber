# *****************************************************************************
#  Name             : rueckbuchung_mit_umbuchung_scenario6.feature
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
#  - Storno der Ruecklieferung
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_mit_umbuchung_scenario6.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: 01 Artikel kopieren
Given I open an editor "RAD-06" from table "(Part):(Product)" with command "COPY" for record "RAD"
And I set field "such" to "RAD-06"
And I set field "chverfolgung" to ""
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "alles" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 02 Rad einkaufen
Given I open an editor "RechnungmLZu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 6zu      |
    | lief     | PUKY     |
    | vom      | .        |
    | ebeleg   | Zugang06 |
    | ueb      | ja       |
    | fakt     | ja       |
    | erfwaehr | DEM      |
And I append rows
    | artikel | mge | he   | preis |
    | RAD-06  | 10  | Paar | 10.00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-06;buarta==Zugang;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "MLF01"
Then field "gmge" has value "10"
Then field "mge" has value "20"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-06" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 20     | Stück  | !JournalZu^id | !JournalZu^id | 20     | !JournalZu^id | !JournalZu^id |
And I close the current editor

# Bewertungen pruefen
Given I open an editor "BewertungZu" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-06;buart==Zugang;"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 20   | !JournalZu^id | !JournalZu^id | 5.0000 | 0.0000    |
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "RAD-06" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 03 Rad umlagern in externe Lagergruppe mit Transportkosten
Given I open an editor "RechnungmLUm" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 6um        |
    | bsart    | Umlagern   |
    | lief     | PUKY       |
    | vom      | .          |
    | ebeleg   | Umlagern06 |
    | ueb      | ja         |
    | fakt     | ja         |
    | erfwaehr | DEM        |
And I append rows
    | artikel | mge | he   | preis | abplatz | platz |
    | RAD-06  | 10  | Paar |  2.00 | MLF01   | L3F1  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-06;buarta==Abgang;detursache==Umlagerungsrechnung Einkauf;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "MLF01"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 20  | !JournalZu^id | !JournalZu^id | 20     | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-06;buarta==Zugang;detursache==Umlagerungsrechnung Einkauf"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "platz" has value "L3F1"
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "RAD-06" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "RAD-06" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id       | bewmge | bewlj^id        | beworig^id    |
    | 20     | Stück  | !JournalUmZu^id | !JournalZu^id | 20     | !JournalUmZu^id | !JournalZu^id |
And I close the current editor

# Umlagerungsbewertungen pruefen - wichtig sind die additiven Kosten
Given I open an editor "BewertungUmAb1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-06;buart==Abgang;detursache==Umlagerungsrechnung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 20   | !JournalZu^id | !JournalZu^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmZu1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-06;buart==Zugang;detursache==Umlagerungsrechnung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 20   | !JournalZu^id | !JournalZu^id | 6.0000 | 1.0000    |
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "RAD-06" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 04 Ruecklieferung auf Zugang
Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set field "nummer" to "6rueck"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-10" in row 1
And I save the current editor

# Journaleintraege pruefen
Given I open an editor "JournalRueck" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-06;buarta==Zugang;detursache==Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "-10"
Then field "rueckorig^id" has value equal to field "id" from editor "JournalZu"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-06" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id | bewmge | bewlj^id        | beworig^id |
    | -20    | Stück  | !JournalUmAb^id | (0,0,0) | -20    | !JournalUmAb^id | (0,0,0)    |
And I close the current editor

Given I query StorageQuantity for Product "RAD-06" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id | bewmge | bewlj^id        | beworig^id |
    | 20     | Stück  | !JournalUmZu^id | (0,0,0) | 20     | !JournalUmZu^id | (0,0,0)    |
And I close the current editor

# Bewertungen pruefen
Given I open an editor "BewertungRueck" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-06;buart==Zugang;detursache==Rücklieferung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 0    | !JournalZu^id | !JournalZu^id | 5.0000 | 0.0000    |
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
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck"
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id | beworig^id | tbewpr | addkosten |
    | 20   | (0,0,0) | (0,0,0)    | 6.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmZu2" via ID from editor "BewertungUmZu1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu1"
Then field "rueckverur^id" has value equal to field "id" from editor "JournalRueck"
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id 		| beworig^id 	| tbewpr | addkosten |
    | 20   | (0,0,0)		| (0,0,0)   	| 7.0000 | 1.0000    |
    | 20   | !JournalZu^id 	| !JournalZu^id | 6.0000 | 1.0000    |

And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "RAD-06" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

Given I open an editor "BewertungUmZu3" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-06;buart==Zugang;detursache==Umlagerungsrechnung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu2"
Then field "nachfolger" is empty
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id 		| beworig^id 	| tbewpr | addkosten |
    | 20   | (0,0,0)		| (0,0,0)   	| 6.0000 | 1.0000    |
    | 20   | !JournalZu^id 	| !JournalZu^id | 6.0000 | 1.0000    |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 05 Ruecklieferung stornieren
Given I open an editor "RueckStorno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung"
And I set field "nummer" to "6storno"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "RAD-06" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Journaleintraege pruefen
Given I open an editor "JournalStorno" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==RAD-06;buarta==Zugang;detursache==Storno-Rücklieferung Einkauf;"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "10"
Then field "mge" has value "20"
Then field "stornolj^id" has value equal to field "id" from editor "JournalRueck"
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RAD-06" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "RAD-06" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id       | bewmge | bewlj^id        | beworig^id    |
    | 20     | Stück  | !JournalUmZu^id | !JournalZu^id | 20     | !JournalUmZu^id | !JournalZu^id |
And I close the current editor

# Bewertungen pruefen
Given I open an editor "BewertungStorno" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-06;buart==Zugang;detursache==Storno-Rücklieferung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu"
Then field "stornoverur^id" has value equal to field "id" from editor "JournalStorno"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungRueck"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 20   | !JournalZu^id | !JournalZu^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmAb3" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-06;buart==Abgang;detursache==Umlagerungsrechnung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 20   | !JournalZu^id | !JournalZu^id | 5.0000 | 0.0000    |
And I close the current editor

Given I open an editor "BewertungUmZu4" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=RAD-06;buart==Zugang;detursache==Umlagerungsrechnung Einkauf;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "vorgaenger" is not empty
Then field "nachfolger" is empty
Then field "umlkostenvorh" has value "ja"
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr | addkosten |
    | 20   | !JournalZu^id | !JournalZu^id | 6.0000 | 1.0000    |
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "RAD-06" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
