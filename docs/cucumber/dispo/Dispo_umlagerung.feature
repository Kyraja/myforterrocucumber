@persistent
Feature: Dispo_umlagerung.feature

Background:
And I set the fake date to "02.01.95"
Given I enable the flag 39

# **********************************************************************************
#  Name             : Dispo_umlagerung.feature
#  Autor            : bheim
#  Verantwortlich   : bheim
#  Kontrolle        : drpf
#  Funktion         : Testet Umlagerungen in der Dispo
#  ref              : ref_umlagern_cu
#
# **********************************************************************************
# verwendete Stammdaten: basis_stammdaten.feature


Scenario: 00  Stammdaten

# Projektkostenrechnung einschalten
Given I open an editor "config" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "projekt" to "ja"
And I save the current editor

# Zulaessiger Rueckstand in Betriebsdaten auf 0 setzen
Given I open an editor "KonfigurationDisposition" from table "(SchedulingConfiguration):(CompanySchedConfig)" with command "STORE" for record "1"
And I set field "rueckstand" to "0"
And I save the current editor


Scenario: 01  Auftrag mit einem Bedarf der 2 mal umgelagert wird

# Lagergruppeneigenschaften im Artikel anpassen und Lieferant eintragen
Given I open an editor "TE_EFA_UML" from table "(Part):(Product)" with command "STORE" for record "TE_EFA_UML"
And I set fields
    | such      | TE_EFA_UML        |
    | bsart     | Eigenfertigung    |
    | dispo     | Auftragsbezogen   |
    | lief      | TEST              |
    | efrist    | 0                 |
    | mindest   | 50                |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
  | lgruppe     | dispoa            | bsart     | umllg     | lief  | mindest   | vorlauf   |
  | HONGKONG    | Auftragsbezogen   | Umlagern  | KARLSRUHE | 002   | 10        | 10        |
  | BERLIN      | Auftragsbezogen   | Umlagern  | HONGKONG  | 001   | 5         | 10        |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lagergruppeneigenschaften im Artikel anpassen und Lieferant eintragen
Given I open an editor "TE_EFB_UML" from table "(Part):(Product)" with command "STORE" for record "TE_EFB_UML"
And I set fields
    | such      | TE_EFB_UML        |
    | bsart     | Eigenfertigung    |
    | dispo     | Bedarfsbezogen    |
    | lief      | TEST              |
    | efrist    | 0                 |
    | mindest   | 50                |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
  | lgruppe     | dispoa            | bsart     | umllg     | lief  | mindest   | vorlauf   |
  | HONGKONG    | Bedarfsbezogen    | Umlagern  | KARLSRUHE | 002   | 10        | 5         |
  | BERLIN      | Bedarfsbezogen    | Umlagern  | HONGKONG  | 001   | 5         | 5         |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Bestand zubuchen
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE_TE_EFE     |
    | budat    | .             |
And I append rows
    | artikel     | mge   |  preis | lgruppe   |
    | TE_EFB_UML  | 75    |  15,00 | KARLSRUHE |
    | TE_EFB_UML  | 50    |  15,00 | BERLIN    |
    | TE_EFB_UML  | 25    |  15,00 | HONGKONG  |
    | TE_EFA_UML  | 75    |  15,00 | KARLSRUHE |
    | TE_EFA_UML  | 50    |  15,00 | BERLIN    |
    | TE_EFA_UML  | 25    |  15,00 | HONGKONG  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Auftrag fuer EK-TE_EFB_UML anlegen
Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I append rows
    | artikel        | mge   | term | lgruppe   |
    | TE_EFB_UML     | 100   | +30  | BERLIN    |
    | TE_EFB_UML     | 200   | +45  | BERLIN    |
    | TE_EFB_UML     | 300   | +60  | BERLIN    |
And I save the current editor

# Auftrag fuer TE_EFA_UML anlegen
Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I append rows
    | artikel        | mge   | term | lgruppe |
    | TE_EFA_UML     | 100   | +30  | BERLIN  |
    | TE_EFA_UML     | 200   | +45  | BERLIN  |
    | TE_EFA_UML     | 300   | +60  | BERLIN  |
And I save the current editor

And I run Scheduling


# Termine und Lieferant im Umlagerungsvorschlag pruefen
Given I open an editor "umlvor" from table "(Purchasing):(RelocationSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFB_UML"
And I press button "ladetab"
Then table has values
    | lief  | mge  | ablgruppe | lgruppe   |  wtsterm   |  wtterm    | wtrterm    | wtfterm  |
    | 002   | 25   | KARLSRUHE | HONGKONG  | 25.01.95   | 25.01.95   | 25.01.95   |          |
    | 002   | 5    | KARLSRUHE | HONGKONG  | 25.01.95   | 25.01.95   | 25.01.95   |          |
    | 002   | 10   | KARLSRUHE | HONGKONG  | 25.01.95   | 25.01.95   | 25.01.95   |          |
    | 001   | 50   | HONGKONG  | BERLIN    | 01.02.95   | 01.02.95   | 01.02.95   |          |
    | 001   | 5    | HONGKONG  | BERLIN    | 01.02.95   | 01.02.95   | 01.02.95   |          |
    | 002   | 200  | KARLSRUHE | HONGKONG  | 09.02.95   | 09.02.95   | 09.02.95   |          |
    | 001   | 200  | HONGKONG  | BERLIN    | 16.02.95   | 16.02.95   | 16.02.95   |          |
    | 002   | 300  | KARLSRUHE | HONGKONG  | 24.02.95   | 24.02.95   | 24.02.95   |          |
    | 001   | 300  | HONGKONG  | BERLIN    | 03.03.95   | 03.03.95   | 03.03.95   |          |
And I close the current editor

# Termine und Lieferant im Umlagerungsvorschlag pruefen
Given I open an editor "umlvor" from table "(Purchasing):(RelocationSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFA_UML"
And I press button "ladetab"
Then table has values
    | lief  | mge  | ablgruppe | lgruppe   |  wtsterm   |  wtterm    | wtrterm    | wtfterm | verw     |
    | 002   | 25   | KARLSRUHE | HONGKONG  | 18.01.95   | 18.01.95   | 18.01.95   |         | 200002_1 |
    | 002   | 5    | KARLSRUHE | HONGKONG  | 18.01.95   | 18.01.95   | 18.01.95   |         |          |
    | 002   | 10   | KARLSRUHE | HONGKONG  | 18.01.95   | 18.01.95   | 18.01.95   |         |          |
    | 001   | 50   | HONGKONG  | BERLIN    | 01.02.95   | 01.02.95   | 01.02.95   |         | 200002_1 |
    | 001   | 5    | HONGKONG  | BERLIN    | 01.02.95   | 01.02.95   | 01.02.95   |         |          |
    | 002   | 200  | KARLSRUHE | HONGKONG  | 02.02.95   | 02.02.95   | 02.02.95   |         | 200002_2 |
    | 001   | 200  | HONGKONG  | BERLIN    | 16.02.95   | 16.02.95   | 16.02.95   |         | 200002_2 |
    | 002   | 300  | KARLSRUHE | HONGKONG  | 17.02.95   | 17.02.95   | 17.02.95   |         | 200002_3 |
    | 001   | 300  | HONGKONG  | BERLIN    | 03.03.95   | 03.03.95   | 03.03.95   |         | 200002_3 |
And I close the current editor


# Dispomz's pruefen
# Karlsruhe
Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFB_UML"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   |
    |        |   ja  | 75       | 10       | 10     | 18.01.95|          |
    |        |   ja  | 75       | 5        | 5      | 18.01.95|          |
    |        |   ja  | 75       | 25       | 25     | 18.01.95| 18.01.95 |
    |        |   ja  | 75       | 35       | 200    | 02.02.95| 02.02.95 |
    |        | nein  |          |          |        |         |          |
    |18.01.95| nein  | 15       | 15       |        |         |          |
    |        | nein  |          |          |        |         |          |
    |02.02.95| nein  | 200      | 165      | 200    | 02.02.95| 02.02.95 |
    |02.02.95| nein  | 200      | 35       | 300    | 17.02.95| 17.02.95 |
    |        | nein  |          |          |        |         |          |
    |17.02.95| nein  |300       | 35       |        |         |          |
    |17.02.95| nein  |300       | 265      | 300    | 17.02.95| 17.02.95 |
And I close the current editor

Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFA_UML"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   | rverw       | bsverw   |
    |        |   ja  | 75       | 10       | 10     | 03.01.95|          |             |          |
    |        |   ja  | 75       | 5        | 5      | 03.01.95|          |             |          |
    |        |   ja  | 75       | 25       | 25     | 03.01.95| 03.01.95 | 200002_1    |          |
    |        |   ja  | 75       | 35       | 200    | 19.01.95| 19.01.95 | 200002_2    |          |
    |        | nein  |          |          |        |         |          |             |          |
    |03.01.95| nein  | 15       | 15       |        |         |          |             |          |
    |        | nein  |          |          |        |         |          |             |          |
    |19.01.95| nein  | 35       | 35       |        |         |          |             |          |
    |        | nein  |          |          |        |         |          |             |          |
    |19.01.95| nein  | 165      | 165      | 200    | 19.01.95| 19.01.95 | 200002_2    | 200002_2 |
    |        | nein  |          |          |        |         |          |             |          |
    |03.02.95| nein  | 300      | 300      | 300    | 03.02.95| 03.02.95 | 200002_3    | 200002_3 |
And I close the current editor

# BERLIN
Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFB_UML"
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   |
    |        |   ja  | 50       | 50       | 100    | 01.02.95| 01.02.95 |
    |        | nein  |          |          |        |         |          |
    |01.02.95| nein  | 5        | 5        |        |         |          |
    |        | nein  |          |          |        |         |          |
    |01.02.95| nein  | 50       | 50       | 100    | 01.02.95| 01.02.95 |
    |        | nein  |          |          |        |         |          |
    |16.02.95| nein  |200       | 200      | 200    | 16.02.95| 16.02.95 |
    |        | nein  |          |          |        |         |          |
    |03.03.95| nein  |300       | 300      | 300    | 03.03.95| 03.03.95 |
And I close the current editor

Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFA_UML"
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   | rverw       | bsverw   |
    |        |   ja  | 50       | 50       | 100    | 01.02.95| 01.02.95 | 200002_1    |          |
    |        | nein  |          |          |        |         |          |             |          |
    |01.02.95| nein  | 5        | 5        |        |         |          |             |          |
    |        | nein  |          |          |        |         |          |             |          |
    |01.02.95| nein  | 50       | 50       | 100    | 01.02.95| 01.02.95 | 200002_1    | 200002_1 |
    |        | nein  |          |          |        |         |          |             |          |
    |16.02.95| nein  | 200      | 200      | 200    | 16.02.95| 16.02.95 | 200002_2    | 200002_2 |
    |        | nein  |          |          |        |         |          |             |          |
    |03.03.95| nein  | 300      | 300      | 300    | 03.03.95| 03.03.95 | 200002_3    | 200002_3 |
And I close the current editor

# HONGKONG
Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFB_UML"
And I set field "lgruppe" to "HONGKONG"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   |
    |        |   ja  | 25       | 25       | 50     | 25.01.95| 25.01.95 |
    |        | nein  |          |          |        |         |          |
    |25.01.95| nein  | 10       | 10       |        |         |          |
    |        | nein  |          |          |        |         |          |
    |25.01.95| nein  | 25       | 25       | 50     | 25.01.95| 25.01.95 |
    |        | nein  |          |          |        |         |          |
    |25.01.95| nein  | 5        | 5        | 5      | 25.01.95|          |
    |        | nein  |          |          |        |         |          |
    |09.02.95| nein  | 200      | 200      | 200    | 09.02.95| 09.02.95 |
    |        | nein  |          |          |        |         |          |
    |24.02.95| nein  | 300      | 300      | 300    | 24.02.95| 24.02.95 |
And I close the current editor

Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFA_UML"
And I set field "lgruppe" to "HONGKONG"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   | rverw       | bsverw   |
    |        |   ja  | 25       | 25       | 50     | 18.01.95| 18.01.95 | 200002_1    |          |
    |        | nein  |          |          |        |         |          |             |          |
    |18.01.95| nein  | 10       | 10       |        |         |          |             |          |
    |        | nein  |          |          |        |         |          |             |          |
    |18.01.95| nein  | 25       | 25       | 50     | 18.01.95| 18.01.95 | 200002_1    | 200002_1 |
    |        | nein  |          |          |        |         |          |             |          |
    |18.01.95| nein  | 5        | 5        | 5      | 18.01.95|          |             |          |
    |        | nein  |          |          |        |         |          |             |          |
    |02.02.95| nein  | 200      | 200      | 200    | 02.02.95| 02.02.95 | 200002_2    | 200002_2 |
    |        | nein  |          |          |        |         |          |             |          |
    |17.02.95| nein  | 300      | 300      | 300    | 17.02.95| 17.02.95 | 200002_3    | 200002_3 |
And I close the current editor




Scenario: 02  Auftrag mit mehreren Positionen gleicher Artikel und gleiche Verwendung, mit verschiedenen Terminen

# Lagergruppeneigenschaften im Artikel anpassen und Lieferant eintragen
Given I open an editor "TE_EFA_2_UML" from table "(Part):(Product)" with command "STORE" for record "TE_EFA_2_UML"
And I set fields
    | such      | TE_EFA_2_UML      |
    | bsart     | Eigenfertigung    |
    | dispo     | Auftragsbezogen   |
    | lief      | TEST              |
    | efrist    | 0                 |
    | mindest   | 0                 |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
  | lgruppe     | dispoa            | bsart     | umllg     | lief  | vorlauf   |
  | HONGKONG    | Auftragsbezogen   | Umlagern  | KARLSRUHE | 002   | 10        |
  | BERLIN      | Auftragsbezogen   | Umlagern  | HONGKONG  | 001   | 10        |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Auftrag fuer EK-TE_EFA_2_UML anlegen
Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I append rows
    | artikel        | mge   | term | lgruppe   | verw     |
    | TE_EFA_2_UML   | 100   | +30  | BERLIN    | 200003_A |
    | TE_EFA_2_UML   | 100   | +31  | BERLIN    | 200003_A |
    | TE_EFA_2_UML   | 100   | +32  | BERLIN    | 200003_A |
And I save the current editor

# Bestand zubuchen
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE_TE_EFA_2   |
    | budat    | .             |
And I append rows
    | artikel      | mge   |  preis | lgruppe   |
    | TE_EFA_2_UML | 75    |  15,00 | KARLSRUHE |
    | TE_EFA_2_UML | 50    |  15,00 | BERLIN    |
    | TE_EFA_2_UML | 25    |  15,00 | HONGKONG  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I run Scheduling

# Termine und Lieferant im Umlagerungsvorschlag pruefen
Given I open an editor "umlvor" from table "(Purchasing):(RelocationSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFA_2_UML"
And I press button "ladetab"
Then table has values
    | lief  | mge  | ablgruppe | lgruppe   |  wtsterm   |  wtterm    | wtrterm    | wtfterm | verw     |
    | 002   | 25   | KARLSRUHE | HONGKONG  | 18.01.95   | 18.01.95   | 18.01.95   |         | 200003_A |
    | 002   | 100  | KARLSRUHE | HONGKONG  | 19.01.95   | 19.01.95   | 19.01.95   |         | 200003_A |
    | 002   | 100  | KARLSRUHE | HONGKONG  | 20.01.95   | 20.01.95   | 20.01.95   |         | 200003_A |
    | 001   | 50   | HONGKONG  | BERLIN    | 01.02.95   | 01.02.95   | 01.02.95   |         | 200003_A |
    | 001   | 100  | HONGKONG  | BERLIN    | 02.02.95   | 02.02.95   | 02.02.95   |         | 200003_A |
    | 001   | 100  | HONGKONG  | BERLIN    | 03.02.95   | 03.02.95   | 03.02.95   |         | 200003_A |
And I close the current editor

# Dispomz's pruefen
# Karlsruhe
Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFA_2_UML"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   | rverw       | bsverw   |
    |        |   ja  | 75       | 25       | 25     | 03.01.95| 03.01.95 | 200003_A    |          |
    |        |   ja  | 75       | 50       | 100    | 04.01.95| 04.01.95 | 200003_A    |          |
    |        | nein  |          |          |        |         |          |             |          |
    |04.01.95| nein  | 50       | 50       | 100    | 04.01.95| 04.01.95 | 200003_A    | 200003_A |
    |        | nein  |          |          |        |         |          |             |          |
    |05.01.95| nein  | 100      | 100      | 100    | 05.01.95| 05.01.95 | 200003_A    | 200003_A |
And I close the current editor

# BERLIN
Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFA_2_UML"
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   | rverw       | bsverw   |
    |        |   ja  | 50       | 50       | 100    | 01.02.95| 01.02.95 | 200003_A    |          |
    |        | nein  |          |          |        |         |          |             |          |
    |01.02.95| nein  | 50       | 50       | 100    | 01.02.95| 01.02.95 | 200003_A    | 200003_A |
    |        | nein  |          |          |        |         |          |             |          |
    |02.02.95| nein  | 100      | 100      | 100    | 02.02.95| 02.02.95 | 200003_A    | 200003_A |
    |        | nein  |          |          |        |         |          |             |          |
    |03.02.95| nein  | 100      | 100      | 100    | 03.02.95| 03.02.95 | 200003_A    | 200003_A |
And I close the current editor

# HONGKONG
Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFA_2_UML"
And I set field "lgruppe" to "HONGKONG"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   | rverw       | bsverw   |
    |        |   ja  | 25       | 25       | 50     | 18.01.95| 18.01.95 | 200003_A    |          |
    |        | nein  |          |          |        |         |          |             |          |
    |18.01.95| nein  | 25       | 25       | 50     | 18.01.95| 18.01.95 | 200003_A    | 200003_A |
    |        | nein  |          |          |        |         |          |             |          |
    |19.01.95| nein  | 100      | 100      | 100    | 19.01.95| 19.01.95 | 200003_A    | 200003_A |
    |        | nein  |          |          |        |         |          |             |          |
    |20.01.95| nein  | 100      | 100      | 100    | 20.01.95| 20.01.95 | 200003_A    | 200003_A |
And I close the current editor



Scenario: 03  Auftrag mit einem Bedarf der 2 mal umgelagert wird und Projekt später eintragen

# Lagergruppeneigenschaften im Artikel anpassen und Lieferant eintragen
Given I open an editor "TE_EFP_UML" from table "(Part):(Product)" with command "STORE" for record "TE_EFP_UML"
And I set fields
    | such      | TE_EFP_UML        |
    | bsart     | Eigenfertigung    |
    | dispo     | Projektbezogen    |
    | lief      | TEST              |
    | efrist    | 0                 |
    | mindest   | 50                |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
  | lgruppe     | dispoa            | bsart     | umllg     | lief  | mindest   | vorlauf   |
  | HONGKONG    | Projektbezogen    | Umlagern  | KARLSRUHE | 002   | 10        | 10        |
  | BERLIN      | Projektbezogen    | Umlagern  | HONGKONG  | 001   | 5         | 10        |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Projekte
Given I open an editor "projekt901" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set field "nummer" to "901"
And I set field "such" to "P901"
And I save the current editor
Given I open an editor "projekt902" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set field "nummer" to "902"
And I set field "such" to "P902"
And I save the current editor

# Bestand zubuchen
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE_TE_EFP     |
    | budat    | .             |
And I append rows
    | artikel     | mge   |  preis | lgruppe   | projekt |
    | TE_EFP_UML  | 75    |  15,00 | KARLSRUHE | P902    |
    | TE_EFP_UML  | 50    |  15,00 | BERLIN    | P902    |
    | TE_EFP_UML  | 25    |  15,00 | HONGKONG  | P902    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Auftrag fuer EK-TE_EFB_UML anlegen
Given I open an editor "AuftragEFP" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set fields
   | kunde   | 1      |
   | such    | AU_EFP |
And I append rows
    | artikel        | mge   | term | lgruppe   |
    | TE_EFP_UML     | 100   | +30  | BERLIN    |
    | TE_EFP_UML     | 200   | +45  | BERLIN    |
    | TE_EFP_UML     | 300   | +60  | BERLIN    |
And I save the current editor

And I run Scheduling

# Termine und Lieferant im Umlagerungsvorschlag pruefen
Given I open an editor "umlvor" from table "(Purchasing):(RelocationSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFP_UML"
And I press button "ladetab"
Then table has values
    | lief  | mge  | ablgruppe | lgruppe   |  wtsterm   |  wtterm    | wtrterm    | wtfterm  | projekt |
    | 002   | 10   | KARLSRUHE | HONGKONG  | 17.01.95   | 17.01.95   | 02.01.95   | 17.01.95 |         |
    | 002   | 5    | KARLSRUHE | HONGKONG  | 17.01.95   | 17.01.95   | 02.01.95   | 17.01.95 |         |
    | 002   | 100  | KARLSRUHE | HONGKONG  | 18.01.95   | 18.01.95   | 18.01.95   |          |         |
    | 001   | 5    | HONGKONG  | BERLIN    | 31.01.95   | 31.01.95   | 02.01.95   | 31.01.95 |         |
    | 001   | 100  | HONGKONG  | BERLIN    | 01.02.95   | 01.02.95   | 01.02.95   |          |         |
    | 002   | 200  | KARLSRUHE | HONGKONG  | 02.02.95   | 02.02.95   | 02.02.95   |          |         |
    | 001   | 200  | HONGKONG  | BERLIN    | 16.02.95   | 16.02.95   | 16.02.95   |          |         |
    | 002   | 300  | KARLSRUHE | HONGKONG  | 17.02.95   | 17.02.95   | 17.02.95   |          |         |
    | 001   | 300  | HONGKONG  | BERLIN    | 03.03.95   | 03.03.95   | 03.03.95   |          |         |
And I close the current editor

# Dispomz's pruefen
# Karlsruhe
Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFP_UML"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   | rprojekt | bprojekt |
    |        |   ja  | 75       | 75       |        |         |          |          | P902     |
    |        | nein  |          |          |        |         |          |          |          |
    |02.01.95| nein  | 55       | 50       |        |         |          |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |02.01.95| nein  | 10       | 10       | 10     | 02.01.95|          |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |02.01.95| nein  | 55       | 5        | 5      | 02.01.95|          |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |03.01.95| nein  | 100      | 100      | 100    | 03.01.95| 03.01.95 |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |19.01.95| nein  | 200      | 200      | 200    | 19.01.95| 19.01.95 |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |03.02.95| nein  | 300      | 300      | 300    | 03.02.95| 03.02.95 |          |          |
And I close the current editor

# BERLIN
Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFP_UML"
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   | rprojekt | bprojekt |
    |        |   ja  | 50       | 50       |        |         |          |          | P902     |
    |        | nein  |          |          |        |         |          |          |          |
    |31.01.95| nein  | 5        | 5        |        |         |          |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |01.02.95| nein  | 100      | 100      | 100    | 01.02.95| 01.02.95 |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |16.02.95| nein  | 200      | 200      | 200    | 16.02.95| 16.02.95 |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |03.03.95| nein  | 300      | 300      | 300    | 03.03.95| 03.03.95 |          |          |
And I close the current editor

# HONGKONG
Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFP_UML"
And I set field "lgruppe" to "HONGKONG"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   | rprojekt | bprojekt |
    |        |   ja  | 25       | 25       |        |         |          |          | P902     |
    |        | nein  |          |          |        |         |          |          |          |
    |17.01.95| nein  | 10       | 10       |        |         |          |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |17.01.95| nein  | 5        | 5        | 5      | 17.01.95|          |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |18.01.95| nein  | 100      | 100      | 100    | 18.01.95| 18.01.95 |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |02.02.95| nein  | 200      | 200      | 200    | 02.02.95| 02.02.95 |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |17.02.95| nein  | 300      | 300      | 300    | 17.02.95| 17.02.95 |          |          |
And I close the current editor

# Auftrag aendern: Offene Menge fuer Rahmenauftrag 24B2 zu gering
Given I open an editor "AU_EFP" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU_EFP"
And I set field "projekt" to "P901" in row 1
And I set field "projekt" to "P901" in row 2
And I set field "projekt" to "P901" in row 3
And I save the current editor

And I run Scheduling

# Termine und Lieferant im Umlagerungsvorschlag pruefen
Given I open an editor "umlvor" from table "(Purchasing):(RelocationSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFP_UML"
And I press button "ladetab"
Then table has values
    | lief  | mge  | ablgruppe | lgruppe   |  wtsterm   |  wtterm    | wtrterm    | wtfterm  | projekt |
    | 002   | 10   | KARLSRUHE | HONGKONG  | 17.01.95   | 17.01.95   | 02.01.95   | 17.01.95 |         |
    | 002   | 5    | KARLSRUHE | HONGKONG  | 17.01.95   | 17.01.95   | 02.01.95   | 17.01.95 |         |
    | 002   | 100  | KARLSRUHE | HONGKONG  | 18.01.95   | 18.01.95   | 18.01.95   |          | P901    |
    | 001   | 5    | HONGKONG  | BERLIN    | 31.01.95   | 31.01.95   | 02.01.95   | 31.01.95 |         |
    | 001   | 100  | HONGKONG  | BERLIN    | 01.02.95   | 01.02.95   | 01.02.95   |          | P901    |
    | 002   | 200  | KARLSRUHE | HONGKONG  | 02.02.95   | 02.02.95   | 02.02.95   |          | P901    |
    | 001   | 200  | HONGKONG  | BERLIN    | 16.02.95   | 16.02.95   | 16.02.95   |          | P901    |
    | 002   | 300  | KARLSRUHE | HONGKONG  | 17.02.95   | 17.02.95   | 17.02.95   |          | P901    |
    | 001   | 300  | HONGKONG  | BERLIN    | 03.03.95   | 03.03.95   | 03.03.95   |          | P901    |
And I close the current editor

# Dispomz's pruefen
# Karlsruhe
Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFP_UML"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   | rprojekt | bprojekt |
    |        |   ja  | 75       | 75       |        |         |          |          | P902     |
    |        | nein  |          |          |        |         |          |          |          |
    |02.01.95| nein  | 60       | 50       |        |         |          |          |          |
    |02.01.95| nein  | 60       | 10       | 10     | 02.01.95|          |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |02.01.95| nein  | 5        | 5        | 5      | 02.01.95|          |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |03.01.95| nein  | 100      | 100      | 100    | 03.01.95| 03.01.95 |  P901    | P901     |
    |        | nein  |          |          |        |         |          |          |          |
    |19.01.95| nein  | 200      | 200      | 200    | 19.01.95| 19.01.95 |  P901    | P901     |
    |        | nein  |          |          |        |         |          |          |          |
    |03.02.95| nein  | 300      | 300      | 300    | 03.02.95| 03.02.95 |  P901    | P901     |
And I close the current editor

# BERLIN
Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFP_UML"
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   | rprojekt | bprojekt |
    |        |   ja  | 50       | 50       |        |         |          |          | P902     |
    |        | nein  |          |          |        |         |          |          |          |
    |31.01.95| nein  | 5        | 5        |        |         |          |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |01.02.95| nein  | 100      | 100      | 100    | 01.02.95| 01.02.95 | P901     | P901     |
    |        | nein  |          |          |        |         |          |          |          |
    |16.02.95| nein  | 200      | 200      | 200    | 16.02.95| 16.02.95 | P901     | P901     |
    |        | nein  |          |          |        |         |          |          |          |
    |03.03.95| nein  | 300      | 300      | 300    | 03.03.95| 03.03.95 | P901     | P901     |
And I close the current editor

# HONGKONG
Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EFP_UML"
And I set field "lgruppe" to "HONGKONG"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  | rlimge | rterm   | twterm   | rprojekt | bprojekt |
    |        |   ja  | 25       | 25       |        |         |          |          | P902     |
    |        | nein  |          |          |        |         |          |          |          |
    |17.01.95| nein  | 10       | 10       |        |         |          |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |17.01.95| nein  | 5        | 5        | 5      | 17.01.95|          |          |          |
    |        | nein  |          |          |        |         |          |          |          |
    |18.01.95| nein  | 100      | 100      | 100    | 18.01.95| 18.01.95 | P901     | P901     |
    |        | nein  |          |          |        |         |          |          |          |
    |02.02.95| nein  | 200      | 200      | 200    | 02.02.95| 02.02.95 | P901     | P901     |
    |        | nein  |          |          |        |         |          |          |          |
    |17.02.95| nein  | 300      | 300      | 300    | 17.02.95| 17.02.95 | P901     | P901     |
And I close the current editor




Scenario: 04  Lagergruppe einer Umlagerung aendern und fixieren, die muss danach trozdem noch zugeordnet werden

# Lagergruppeneigenschaften im Artikel anpassen und Lieferant eintragen
Given I open an editor "TE_EB_UMLAE" from table "(Part):(Product)" with command "STORE" for record "TE_EB_UMLAE"
And I set fields
    | such      | TE_EB_UMLAE       |
    | bsart     | Fremdbeschaffung  |
    | dispo     | Bedarfsbezogen    |
    | lief      | TEST              |
    | efrist    | 10                |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I append rows
  | lgruppe     | dispoa            | bsart     | umllg     | lief  | mindest   | vorlauf   |
  | BERLIN      | Bedarfsbezogen    | Umlagern  | KARLSRUHE | 001   | 10        | 10        |
And I save the current subeditor to switch back to the parent editor
And I press button "kalkul" to open a subeditor for "kalkulieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Bestand zubuchen
Given I open an editor "Rechnung_11" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE_TE_EB_UMLAE|
    | budat    | .             |
And I append rows
    | artikel      | mge   |  preis | lgruppe   |
    | TE_EB_UMLAE  | 20    |  15,00 | HONGKONG  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# In einen Umlagerungsvorschlag die lgruppe aendern und den Vorgang fixieren
Given I open an editor "UM01" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for search criteria "$,,artikel==TE_EB_UMLAE;mge==10;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "ablgruppe" to "HONGKONG" in row 1
And I set field "fix" to "ja" in row 1
And I save the current editor

And I run Scheduling

# Dispomz's pruefen
Given I open an editor "eplankarte" from table "(MaterialsAllocation)" with command "VIEW" for record ""
And I set field "artikel" to "TE_EB_UMLAE"
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then table has values
    |bstterm | bsfix | bsnlimge | lzuomge  |
    |31.01.95|   ja  | 10       | 10       |
