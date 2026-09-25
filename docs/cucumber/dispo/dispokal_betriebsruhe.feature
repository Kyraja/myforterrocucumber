@persistent
Feature: 	

Background:
And I set the fake date to "08.01.1995"

Scenario Outline: Stamm- und Betriebsdaten für Test einstellen
# Lieferant mit Konsilager und Kunde
  Given I open an editor "<such>" from table "<table>" with command "STORE" for record "<such>"
  And I set fields
    | such     | <such>      |
    | namebspr | <namebspr>  |
    | ans      | <ans>       |
    | str      | <str>       |
    | plz      | 45678       |
    | nort     | Kleinstadt  |
    | konsi    | <konsi>     |
    | zbed     | 201         |
  And I save the current editor
  
  Examples:
    | table                | such     | namebspr            | ans     | str              | konsi       |
    | (Vendor):(Vendor)    | K-LIEF   | Lief mit Konsilager | K-LIEF  | Kleine Straße 3  | L3F1        |
    | (Vendor):(Vendor)    | LIEF1    | Lieferant 1 Inland  | LIEF1   | Neue Straße 1    | !dontChange |
    | (Customer):(Customer)| KUNDE1   | Kunde 1 Inland      | KUNDE1  | Hohe Straße 1    | !dontChange |

Scenario: Stamm- und Betriebsdaten für Test einstellen
# EK-Teil für Beistellung
  Given I open an editor "EK1-BEDARF" from table "(Part):(Product)" with command "STORE" for record "EK1-BEDARF"
  And I set fields
    | such     | EK1-BEDARF              |
    | namebspr | bedarfsbezogenes Teil 1 |
    | lief     | LIEF1                   |
    | efrist   | 2                       |
    | epr      | 10                      |
    | wgruppe  | 55                      |
    | erlgrp   | 66                      |
    And I save the current editor

# Struktur EK-Teil mit Beistellung
  Given I open an editor "EK-BEISTELL" from table "(Part):(Product)" with command "STORE" for record "EK-BEISTELL"
  And I set fields
    | such     | EK-BEISTELL              |
    | namebspr | EK-Teil mit Beistellung  |
    | lief     | K-LIEF                   |
    | efrist   | 5                        |
    | epr      | 10                       |
    | wgruppe  | 55                       |
    | erlgrp   | 66                       |
  And I delete all rows
  And I modify table
    | !row    | elex       | elanzahl  | bua                     |
    | +1      | EK1-BEDARF | 1         | !dontChange  |
  And I save the current editor

# Dispokalender mit Bezugsobjekt Betriebsdaten, Betriebsferien über Weihnachten eintragen
  Given I open an editor "BETRIEBSKAL" from table "(Calendar):(SchedulingCalendar)" with command "STORE" for record "BETRIEBSKAL"
  And I set fields
    | such        | BETRIEBSKAL       |
    | namebspr    | Betriebskalender  |
    | dispobezobj | Firma 1           |
  And I delete all rows
  And I modify table
    | !row  | anf       | end       | ftag  |
    | +1    | 23.12.20  | 06.01.21  | ja    |
  And I save the current editor

Scenario: Dispokalender mit Bezugsobjekt Betriebsdaten wird bei Terminierung berücksichtigt
# Auftrag für EK-BEISTELL mit Termin 07.01.
  Given I open an editor "Auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
  And I set fields
    | kl        | KUNDE1      |
    | vom       | .           |
  And I modify table
    | !row    | artikel        | mge   | tterm       |
    | +1      | EK-BEISTELL    | 1     | 07.01.2021  |
  And I save the current editor
  And I run Scheduling

# Beschaffungsstatus öffnen und Termine prüfen
  Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "Auftrag1"
  Then the table has 1 rows
  Then table has values
    | elem          | term        | aterm       | eterm       | vart                 |
    | EK-BEISTELL   | 07.01.2021  | 22.12.2020  | 07.01.2021  | Fremdbeschaffung     |
  And I close the current editor
