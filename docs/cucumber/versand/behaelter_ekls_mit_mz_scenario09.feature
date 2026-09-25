# *****************************************************************************
#  Name             : behaelter_ekls_mit_mz_scenario09.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Buchung von Teilmengen einer Bestellung
#                     MZ wird beibehalten und um gebuchte Mengen reduziert
#
# *****************************************************************************
@persistent
Feature: behaelter_ekls_mit_mz_scenario09.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelter anlegen
And I create a Container "TEILMENGE_BEH1" for packaging material "KLT"
And I create a Container "TEILMENGE_BEH2" for packaging material "KLT"
And I create a Container "NEUE_TEILMENGE1" for packaging material "KLT"
And I create a Container "NEUE_TEILMENGE2" for packaging material "SKARTON"
And I create a Container "NEUE_TEILMENGE3" for packaging material "SKARTON"


Scenario: 02 Bestellung anlegen
Given I open an editor "Bestellung09" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | nummer | 9ekbe   |
    | lief   | KETTLER |
And I append rows
    | artikel | mge |
    | RAD     | 100 |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum               |
    | 50     | Externe Behälternummer ist bereits vergeben. | nein          | !TEILMENGE_BEH1^nummer |
    | 50     | Externe Behälternummer ist bereits vergeben. | nein          | !TEILMENGE_BEH2^nummer |
And I save the current subeditor to switch back to the parent editor
And I save the current editor


Scenario: 03 Ersten Teil-Lieferschein anlegen und verbuchen
Given I open an editor "EKLS09_1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung09"
And I set fields
    | ebeleg | EKLS09_1 |
    | vom    | .        |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete row at position !lastRow
And I modify table
    | !row | zuomge | exbehnum                |
    | 1    | 10     | !NEUE_TEILMENGE1^nummer |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 04 Bestellung pruefen nach 1. Teillieferung
And I switch the current editor to editor "Bestellung09" with command "VIEW"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | zuomge | behaelter^id        |
    | 40     | !NEUE_TEILMENGE1^id |
    | 50     | !TEILMENGE_BEH2^id  |
And I close the current editor
And I switch the current editor to editor "Bestellung09"
And I close the current editor


Scenario: 05 Zweiten Teil-Lieferschein anlegen und verbuchen
Given I open an editor "EKLS09_2" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung09"
And I set fields
    | ebeleg | EKLS09_2 |
    | vom    | .        |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete row at position 1
And I modify table
    | !row | zuomge | exbehnum                |
    | 1    | 10     | !NEUE_TEILMENGE2^nummer |
And I respond with answer "yes" to the dialog with id "150"
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 06 Bestellung pruefen nach 2. Teillieferung
And I switch the current editor to editor "Bestellung09" with command "VIEW"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | zuomge | behaelter^id        |
    | 40     | !NEUE_TEILMENGE2^id |
    | 40     | !NEUE_TEILMENGE1^id |
And I close the current editor
And I switch the current editor to editor "Bestellung09"
And I close the current editor


Scenario: 07 Dritten Teil-Lieferschein anlegen und verbuchen
Given I open an editor "EKLS09_3" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung09"
And I set fields
    | ebeleg | EKLS09_3 |
    | vom    | .        |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete row at position !lastRow
And I modify table
    | !row | zuomge | exbehnum                |
    | 1    | 10     | !NEUE_TEILMENGE3^nummer |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 08 Bestellung pruefen nach 3. Teillieferung
And I switch the current editor to editor "Bestellung09" with command "VIEW"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | zuomge | behaelter^id        |
    | 30     | !NEUE_TEILMENGE3^id |
    | 40     | !NEUE_TEILMENGE1^id |
And I close the current editor
And I switch the current editor to editor "Bestellung09"
And I close the current editor


Scenario: 09 Behaelter pruefen
Then Container from editor "TEILMENGE_BEH1" is empty
Then Container from editor "TEILMENGE_BEH2" is empty

And I open an editor "NEUE_TEILMENGE1" from table "(Container):(ContainerShell)" with command "VIEW" for record "NEUE_TEILMENGE1"
Then table has values
    | artikel | mge | gebeinh |
    | RAD     | 20  | Stück  |
And I close the current editor

And I open an editor "NEUE_TEILMENGE2" from table "(Container):(ContainerShell)" with command "VIEW" for record "NEUE_TEILMENGE2"
Then table has values
    | artikel | mge | gebeinh |
    | RAD     | 20  | Stück  |
And I close the current editor

And I open an editor "NEUE_TEILMENGE3" from table "(Container):(ContainerShell)" with command "VIEW" for record "NEUE_TEILMENGE3"
Then table has values
    | artikel | mge | gebeinh |
    | RAD     | 20  | Stück  |
And I close the current editor

