# *****************************************************************************
#  Name             : behaelter_ek_packm_berechnen_mz_scenario01.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Packmittel berechnen, ein Artikel, mehrere Behaelter
#
# *****************************************************************************
@persistent
Feature: behaelter_ek_packm_berechnen_mz_scenario01.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelter anlegen
And I create a Container "KLT1" for packaging material "KLT"
And I create a Container "KLT2" for packaging material "KLT"


Scenario: 02 Lieferschein anlegen und verbuchen
Given I open an editor "EKLS02" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | ebeleg | EKLS_M02 |
    | vom    | .        |
And I append rows
    | artikel | mge | fmenge |
    | RAD     | 12  | 6      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum     |
    | 6      | Externe Behälternummer ist bereits vergeben. | nein          | !KLT1^nummer |
    | 6      | Externe Behälternummer ist bereits vergeben. | nein          | !KLT2^nummer |
And I save the current subeditor to switch back to the parent editor
And I press button "packvor"
Then table has values
    | artikel  | mge |
    | RAD      | 12  |
    | KLT      | 2   |
    | KLT      | 2   |
    | SPALETTE | 1   |
And I set field "ueb" to "ja"
And I save the current editor

# Then field "bhbuchung" has value "" in row 1
# Then field "bhbuchung^mge" has value "2" in row 2
# Then field "bhbuchung^buart" has value "Zugang" in row 2
# Then field "bhbuchung^mge" has value "2" in row 3
# Then field "bhbuchung^buart" has value "Zugang" in row 3


Scenario: 03 Behaelter pruefen
And I switch the current editor to editor "KLT1"
Then table has values
    | artikel | mge |
    | RAD     | 12  |
And I close the current editor

And I switch the current editor to editor "KLT2"
Then table has values
    | artikel | mge |
    | RAD     | 12  |
And I close the current editor
