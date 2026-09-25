# *****************************************************************************
#  Name             : behaelter_ekls_mit_mz_scenario12.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : EK-Prozess - Bestellung mit MZ, Lieferschein
#
# *****************************************************************************
@persistent
Feature: behaelter_ekls_mit_mz_scenario12.feature
Background:
Given I set the fake date to "02.01.1995"

Scenario: 01 Bestellung anlegen
Given I open an editor "Bestellung12" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | nummer | 12ekbe  |
    | lief   | KETTLER |
And I append rows
    | artikel | mge |
    | RAD     | 10  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | exbehnum   | packm |
    | 4      | 1289_12_P1 | KLT   |
    | 6      | 1289_12_P2 | KLT   |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Scenario: 02 Lieferschein anlegen und verbuchen
Given I open an editor "EKLS12" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung12"
And I set fields
    | ebeleg | EKLS_12 |
    | vom    | .       |
    | ueb    | ja      |
And I set field "mge" to "10" in row 1
And I save the current editor

Scenario: 03 Behaelter pruefen
# Behaeltermenge in LE, oben wird in HE 1 Paar = 2 Stueck gebucht
And I open an editor "1289_12_P1" from table "(Container):(ContainerShell)" with command "VIEW" for record "1289_12_P1"
Then table has values
    | artikel | mge | gebeinh |
    | RAD     | 8   | Stück  |
And I close the current editor

And I open an editor "1289_12_P2" from table "(Container):(ContainerShell)" with command "VIEW" for record "1289_12_P2"
Then table has values
    | artikel | mge | gebeinh |
    | RAD     | 12   | Stück  |
And I close the current editor
