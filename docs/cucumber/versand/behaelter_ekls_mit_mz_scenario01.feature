# *****************************************************************************
#  Name             : behaelter_ekls_mit_mz_scenario01.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Artikel in Behaelter buchen ueber Einkaufslieferschein
#
# *****************************************************************************
@persistent
Feature: behaelter_ekls_mit_mz_scenario01.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelter erstellen
And I create a Container "BUCHUNG_1" for packaging material "KLT"
And I create a Container "BUCHUNG_2" for packaging material "KLT"
And I create a Container "BUCHUNG_3" for packaging material "KLT"


Scenario: 02 LS Einkauf Artikel in Behaelter buchen
Given I open an editor "EKLS01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | ebeleg | EKLS01  |
    | vom    | .       |
And I append rows
    | artikel | mge |
    | PEDALE  | 5   |

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | verw  | !dialogId                                     | !dialogAnswer | exbehnum          |
    | F1     | 2      | Verw1 | Externe Behälternummer ist bereits vergeben. | nein          | !BUCHUNG_1^nummer |
    | F2     | 2      | Verw2 | Externe Behälternummer ist bereits vergeben. | nein          | !BUCHUNG_2^nummer |
    | F3     | 1      | Verw3 | Externe Behälternummer ist bereits vergeben. | nein          | !BUCHUNG_3^nummer |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor

# VERSAND-836:  Behaelterkonto wird nicht bebucht
#Then field "bhbuchung^mge" has value "3" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#And I close the current editor


Scenario: 03 Lagerjournal pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "EKLS01"
And I press start
Then table has values
    | mei  | art    | mge | nplatz |
    | Paar | PEDALE | 4   | F1     |
    | Paar | PEDALE | 4   | F2     |
    | Paar | PEDALE | 2   | F3     |
And I close the current editor


Scenario Outline: 04 Behaelter pruefen
And I switch the current editor to editor "<behaelter>"
Then field "platz" has value "<platz>"
Then field "artikel" has value "<artikel>" in row 1
Then field "mge" has value "<mge>" in row 1
Then field "verw" has value "<verw>" in row 1
And I close the current editor

Examples:
| behaelter | platz | artikel | mge | verw  |
| BUCHUNG_1 | F1    | PEDALE  | 4   | Verw1 |
| BUCHUNG_2 | F2    | PEDALE  | 4   | Verw2 |
| BUCHUNG_3 | F3    | PEDALE  | 2   | Verw3 |

