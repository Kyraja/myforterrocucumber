# *****************************************************************************
#  Name             : behaelter_ekls_mit_mz_scenario07.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : EK-Prozess - Bestellung, Lieferschein, Ruecklieferschein
#
# *****************************************************************************
@persistent
Feature: behaelter_ekls_mit_mz_scenario07.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Bestellung anlegen
Given I open an editor "Bestellung07" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | nummer | 7ekbe   |
    | lief   | KETTLER |
And I append rows
    | artikel | mge |
    | RAD     | 5   |
And I save the current editor


Scenario: 02 Lieferschein anlegen und verbuchen
Given I open an editor "EKLS07" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung07"
And I set fields
    | ebeleg | EKLS_07 |
    | vom    | .       |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | exbehnum   | packm |
    | 2      | 7089_07_P1 | KLT   |
    | 3      | 7089_07_P2 | KLT   |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 03 Behaelter pruefen
And I open an editor "7089_07_P1" from table "(Container):(ContainerShell)" with command "VIEW" for record "7089_07_P1"
Then table has values
    | mge | gebeinh |
    | 4   | Stück  |
And I close the current editor

And I open an editor "7089_07_P2" from table "(Container):(ContainerShell)" with command "VIEW" for record "7089_07_P2"
Then table has values
    | mge | gebeinh |
    | 6   | Stück  |
And I close the current editor


Scenario: 04 Vollstaendige Ruecklieferung des Lieferscheins
Given I open an editor "EKRLS_07" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EKLS07"
And I set fields
    | ebeleg | EKRLS_07 |
    | vom    | .        |
And I set field "mge" to "-5" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I append rows
    | zuomge | behaelter      |
    | -2     | !7089_07_P1^id |
    | -3     | !7089_07_P2^id |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 05 Behaelter pruefen
And I open an editor "7089_07_P1" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "7089_07_P1"
Then field "behstatusaz" has value "Rücklieferung"
Then the table has 0 rows
And I close the current editor

And I open an editor "7089_07_P2" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "7089_07_P2"
Then field "behstatusaz" has value "Rücklieferung"
Then the table has 0 rows
And I close the current editor

