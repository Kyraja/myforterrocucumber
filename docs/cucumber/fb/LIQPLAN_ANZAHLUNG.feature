@persistent
Feature: Liquiditaetsplanung für Anzahlungen

Background:
Given I set the fake date to "31.12.2004"

Scenario: Neuer Auftrag 99001, Kunde 310000, Artikel V1: Menge positiv, Preis negativ
Given I open an editor "auftrag1" from table "(Sales):(SalesOrder)" with command "STORE" for record "BKD310000"
And I set field "nummer" to "99001"
And I set field "kunde" to "310000"
And I set field "vom" to "."
And I set field "oterm" to "+30"
And I set field "brutto" to "ja"
And I set field "budat" to "."
And I append rows
    | artex | mge         | preis       | tterm       | konto      | oterm       |
    | V1    | 10          | -100        | +30         | !dontChange| !dontChange |
    | ANZ   | !dontChange | !dontChange | !dontChange | 32720      | +30         |
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"
And I save the current editor

Scenario: Anzahlungsrechnung 1 aus Auftrag 99001
Given I open an editor "anzrechnung1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag1"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "pwert" to "10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"
And I save the current editor

# Liquititaetsplanung -> beleg: Anzahlungsposition aus Auftrag 99001
Scenario: Infosystem LIQPLANDETAILS - 1. Mal
Given I open the infosystem "LIQPLANDETAILS"
And I set field "planszenario" to "PLAN1"
And I set field "stichtag" to "."
And I set field "periodevon" to "0"
And I set field "periodebis" to "13"
And I set field "zeiteinheit" to "Monat"
And I set field "beleg" to "$,artex==ANZAHLUNG;kopf==99001;@gruppe=3:2;@ablageart=(Active)"
And I press start
Then the table has 2 rows
And field "summe" has value "-8.62"
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"
And I export fields "tposition,tekvk,tperiode,tkonto,tbelegtyp,tbelegkopf,tzabetr,tskonto,tskontosatz,tzbed,tfaelltage" from table content to output file "LIQPLAN_ANZ.REF"
And I close the current editor

Scenario: Infosystem LIQPLAN - 1. Mal
Given I open the infosystem "LIQPLAN"
And I set field "planszenario" to "Plan1"
And I set field "stichtag" to "."
And I press start
Then the table has 30 rows
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"
And I export fields "tposition,tekvk,twert0,twert1,twert2,twert3,twert4,twert5,twert6,twert7,twert8,twert9,twert10,twert11,twert12,twert13,tzeilensum" from table content to output file "LIQPLAN_ANZ.REF"
And I close the current editor

Scenario: Neuer Auftrag 99002, Kunde 310000, Artikel V1: Menge positiv, Preis positiv
Given I open an editor "auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "99002"
And I set field "kunde" to "310000"
And I set field "vom" to "."
And I set field "oterm" to "+30"
And I set field "brutto" to "ja"
And I set field "budat" to "."
And I append rows
    | artex | mge         | preis       | tterm       | konto       | oterm       |
    | V1    | 10          | 100         | +30         | !dontChange | !dontChange |
    | ANZ   | !dontChange | !dontChange | !dontChange | 32720       | +30         |
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"  
And I save the current editor

Scenario: Anzahlungsrechnung 2 aus Auftrag 99002
Given I open an editor "anzrechnung2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag2"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "pwert" to "10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"
And I save the current editor

# Liquititaetsplanung -> beleg: Anzahlungsposition aus Auftrag 99002
Scenario: Infosystem LIQPLANDETAILS - 2. Mal
Given I open the infosystem "LIQPLANDETAILS"
And I set field "planszenario" to "PLAN1"
And I set field "stichtag" to "."
And I set field "periodevon" to "0"
And I set field "periodebis" to "13"
And I set field "zeiteinheit" to "Monat"
And I set field "beleg" to "$,artex==ANZAHLUNG;kopf==99002;@gruppe=3:2;@ablageart=(Active)"
And I press start
Then the table has 2 rows
And field "summe" has value "-8.62"
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"
And I export fields "tposition,tekvk,tperiode,tkonto,tbelegtyp,tbelegkopf,tzabetr,tskonto,tskontosatz,tzbed,tfaelltage" from table content to output file "LIQPLAN_ANZ.REF"
And I close the current editor

Scenario: Neuer Auftrag 99003, Kunde 310000, Artikel V1: Menge positiv, Preis positiv
Given I open an editor "auftrag3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "99003"
And I set field "kunde" to "310000"
And I set field "vom" to "."
And I set field "oterm" to "+30"
And I set field "brutto" to "ja"
And I set field "budat" to "."
And I append rows
    | artex | mge         | preis       | tterm       | konto       | oterm       |
    | V1    | 10          | 100         | +30         | !dontChange | !dontChange |
    | ANZ   | !dontChange | !dontChange | !dontChange | 32720       | +30         |
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"
And I save the current editor

Scenario: Anzahlungsrechnung 3 aus Auftrag 99003
Given I open an editor "anzrechnung3" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag3"
And I set field "ueb" to "nein"
And I set field "tterm" to "."
And I set field "pwert" to "10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"
And I save the current editor

# Liquititaetsplanung
Scenario: Infosystem LIQPLANDETAILS - 3. Mal -> beleg: Anzahlungsposition aus Auftrag 99003
Given I open the infosystem "LIQPLANDETAILS"
And I set field "planszenario" to "PLAN1"
And I set field "stichtag" to "."
And I set field "periodevon" to "0"
And I set field "periodebis" to "13"
And I set field "zeiteinheit" to "Monat"
And I set field "beleg" to "$,artex==ANZAHLUNG;kopf==99003;@gruppe=3:2;@ablageart=(Active)"
And I press start
Then the table has 2 rows
And field "summe" has value "-8.62"
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"
And I export fields "tposition,tekvk,tperiode,tkonto,tbelegtyp,tbelegkopf,tzabetr,tskonto,tskontosatz,tzbed,tfaelltage" from table content to output file "LIQPLAN_ANZ.REF"
And I close the current editor

Scenario: Neuer Konzern anlegen
Given I open an editor "konzern" from table "(Consolidation):(AffiliatedCompany)" with command "NEW" for record ""
And I set field "kukonz" to "310000"
And I set field "name" to "310000^namebspr"
And I set field "zugseit" to "1.1."
And I set field "zugbis" to "31.12."
And I set field "waehr" to "EUR"
And I set field "betgrad" to "beteiligt"
And I set field "faart" to "Konzerntochter"
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"
And I save the current editor

Scenario: Neuer Konsolidierungskreis anlegen
Given I open an editor "kkreis" from table "(Consolidation):(ConsolidationGroup)" with command "NEW" for record ""
And I set field "such" to "SWD"
And I set field "zugseit" to "1.1."
And I set field "zugbis" to "31.12."
And I set field "waehr" to "EUR"
And I create a new row at the end of the table
And I set field "tadatum" to "1.1." in row 1
And I set field "tedatum" to "31.12." in row 1
And I set field "tkonzobj" to "1" in row 1
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"
And I save the current editor

Scenario: Neue Brutto-Rechnung 99004, Kunde 310000, Artikel V1: Menge positiv, Preis positiv
Given I open an editor "rechnung1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "99004"
And I set field "kunde" to "310000"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "brutto" to "ja"
And I set field "budat" to "."
And I set field "mterm" to "ja"
Then field "inkkreis" has value "ja"
And I append rows
    | artex | mge | preis |
    | V1    | 10  | 100   |
And I respond with answer "Ja" to the dialog with id "4841"
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"
And I save the current editor

Scenario: Neue Brutto-Rechnung 99005, Kunde 310001, Artikel V1: Menge positiv, Preis positiv
Given I open an editor "rechnung2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "99005"
And I set field "kunde" to "310001"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "brutto" to "ja"
And I set field "budat" to "."
And I set field "mterm" to "ja"
Then field "inkkreis" has value "nein"
And I append rows
    | artex | mge | preis |
    | V1    | 10  | 100   |
And I respond with answer "Ja" to the dialog with id "4841"
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"
And I save the current editor

Scenario: Infosystem LIQPLAN - 2. Mal
Given I open the infosystem "LIQPLAN"
And I set field "planszenario" to "Plan1"
And I set field "icgetrennt" to "ja"
And I press start
Then the table has 34 rows
And I append ScenarioHeadline to output file "LIQPLAN_ANZ.REF"
And I export fields "tposition,tekvk,twert0,twert1,twert2,twert3,twert4,twert5,twert6,twert7,twert8,twert9,twert10,twert11,twert12,twert13,tzeilensum" from table content to output file "LIQPLAN_ANZ.REF"
And I close the current editor
