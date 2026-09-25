# *****************************************************************************
#  Name             : behaelter_ekre_mitmz_scenario04.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Ruecklieferungen ueber Rechnung mit Lagerbewegung und Behaelter
#
# *****************************************************************************
@persistent
Feature: behaelter_ekre_mitmz_scenario04.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelter anlegen
And I create a Container "behaelter04A" for packaging material "KLT"
And I create a Container "behaelter04B" for packaging material "KLT"
And I create a Container "behaelter04C" for packaging material "KLT"
And I create a Container "behaelter04D" for packaging material "KLT"
And I create a Container "behaelter04E" for packaging material "KLT"
And I create a Container "behaelter04F" for packaging material "KLT"


Scenario: 02 Rechnung mit Lagerbewegung anlegen und verbuchen
Given I open an editor "Rechnung04" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | RE_04   |
And I append rows
    | artikel | mge |
    | SATTEL  | 4   |
    | KLINGEL | 4   |
    | RAD     | 5   |
    | RAHMEN  | 5   |
    | PEDALE  | 5   |
# gleicher Artikel liegt in unterschiedlichen Behaeltern
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | 2      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter04A^nummer |
    | 2      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter04B^nummer |
And I save the current subeditor to switch back to the parent editor
# gleicher Artikel liegt in unterschiedlichen Behaelter, Angaben in MZ und in Artikelposition
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | 2      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter04C^nummer |
And I save the current subeditor to switch back to the parent editor
# Artikel in einem Behaelter ueber MZ und Artikelposition angeben
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | 2      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter04E^nummer |
And I save the current subeditor to switch back to the parent editor
# zwei versch. Artikel in einem Behaelter
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 4
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | 5      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter04F^nummer |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 5
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | 5      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter04F^nummer |
And I save the current subeditor to switch back to the parent editor
And I modify table
    | !row | mge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | 2    | 4   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter04D^nummer |
    | 3    | 5   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter04E^nummer |
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


Scenario: 03 Ruecklieferung auf Rechnung mit Lagerbewegung
Given I open an editor "Retoure04" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "Rechnung04"
And I set fields
    | vom    | .          |
    | ebeleg | RETOURE_04 |
And I modify table
    | !row | mge |
    | 1    | -4  |
    | 2    | -4  |
    | 3    | -5  |
    | 4    | -5  |
    | 5    | -5  |
# gleicher Artikel liegt in unterschiedlichen Behaeltern
And I set field "mge" to "-4" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | behaelter        |
    | -2     | !behaelter04A^id |
    | -2     | !behaelter04B^id |
And I save the current subeditor to switch back to the parent editor
# gleicher Artikel liegt in unterschiedlichen Behaelter, Angaben in MZ und in Artikelposition
And I set field "mge" to "-4" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I delete all rows
And I append rows
    | zuomge | behaelter        |
    | -2     | !behaelter04C^id |
And I save the current subeditor to switch back to the parent editor
# Artikel in einem Behaelter ueber MZ und Artikelposition angeben
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I delete all rows
And I append rows
    | zuomge | behaelter        |
    | -2     | !behaelter04E^id |
And I save the current subeditor to switch back to the parent editor
# zwei versch. Artikel in einem Behaelter
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 4
And I delete all rows
And I append rows
    | zuomge | behaelter        |
    | -5     | !behaelter04F^id |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 5
And I delete all rows
And I append rows
    | zuomge | behaelter        |
    | -5     | !behaelter04F^id |
And I save the current subeditor to switch back to the parent editor
And I modify table
    | !row | mge | behaelter        |
    | 2    | -4  | !behaelter04D^id |
    | 3    | -5  | !behaelter04E^id |
And I set field "ueb" to "ja"
And I save the current editor


Scenario Outline: 04 Behaelter pruefen
And I switch the current editor to editor "<behaelter>" with command "VIEW"
Then the table has 0 rows
Then field "behstatusaz" has value "Rücklieferung"
Then field "behleer" has value "nein"
And I close the current editor

Examples: 04 Behaelter

| behaelter    |
| behaelter04A |
| behaelter04B |
| behaelter04C |
| behaelter04D |
| behaelter04E |
| behaelter04F |
