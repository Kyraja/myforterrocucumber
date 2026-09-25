# *****************************************************************************
#  Name             : behaelter_ekls_mit_mz_scenario11.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Artikel im Behaelter umlagern ueber Einkaufslieferschein bsart = Umlagerung
#
# *****************************************************************************
@persistent
Feature: behaelter_ekls_mit_mz_scenario11.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelter und Auftrag anlegen
Given I create a SalesOrder "auftrag11" for Customer "RADSHOP" with Product "KLINGEL" and quantity "10"
Given I create a Container "LS_BSART" for packaging material "KLT"


Scenario: 02 Behaelter fuellen
Given I open an editor "Lagerbuchung11" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | KLINGEL |
    | buart   | Zugang  |
    | beleg   | LM11    |
    | beldat  | .       |
And I modify table
    | !row | mge | platz2 | behaelter    |
    | 1    | 10  | L2F1   | !LS_BSART^id |
And I set field "verw" in row 1 to "verw" from editor "auftrag11" in row 1
And I save the current editor

# Dispo starten
And I run Scheduling


Scenario: 03 Umlagerungsvorschlag zu Bestellung freigeben
Given I open an editor "Umlagerungsvorschlag" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "KLINGEL"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row !lastRow
And I press button "freig" to open a subeditor for "Bestellung11"
And I set field "lief" to "KETTLER"
And I save the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: 04 Lieferschein bsart=Umlagern
Given I open an editor "EKLS11" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung11"
And I set fields
    | vom    | .      |
    | ebeleg | EKLS11 |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | zuomge | lpsuch | behaelterzu  | behaelter   | !row |
    | 10     | F1     | !LS_BSART^id |!LS_BSART^id | 1    |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 05 Behaelter pruefen
And I switch the current editor to editor "LS_BSART"
Then field "platz" has value "F1"
Then the table has 1 rows
And I close the current editor

