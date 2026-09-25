@persistent
Feature: fertigungslisten2.feature

# **********************************************************************************
#  Name             : fertigungslisten.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : bheim
#  Funktion         : Testet die Kalkulation bei Artikeln mit Maximalstücklisten
#                     oder mehreren Fertigungslisten
#  ref              : ref_fertigungslisten_cu
#  Stammdaten       : basis_stammdaten.feature
#
# **********************************************************************************

  Scenario: 01 Artikel mit Eigenfertigungsstückliste

    Given I open an editor "BAUGRUPPEX1" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such     | BAUGRUPPEX1    |
      | namebspr | BAUGRUPPEX1    |
      | bsart    | Eigenfertigung |
      | lief     | K-LIEF         |
      | efrist   | 3              |
      | epr      | 100            |
    And I delete all rows
    And I save the current editor

    Given I open an editor "BGX1-INT-EIGEN" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
    And I set fields
      | such      | BGX1-INT-EIGEN |
      | artikel   | BAUGRUPPEX1    |
      | bsart     | Eigenfertigung |
      | flistestd | ja             |
      | lgruppe   | KARLSRUHE      |
    And I append rows
      | elex       | lge         | breite      | elanzahl |
      | E2         | !dontChange | !dontChange | 1        |
      | E3         | !dontChange | !dontChange | 1        |
      | A AG-LOHN1 | 20          | 10          | 1        |
    And I save the current editor

    Given I open an editor "BAUGRUPPEX1" from table "(Part):(Product)" with command "VIEW" for record "BAUGRUPPEX1"
    Then field "flistestd" has value "BGX1-INT-EIGEN"
    And I close the current editor

    Given I open an editor "BAUGRUPPEX1" from table "(Part):(Product)" with command "UPDATE" for record "BAUGRUPPEX1"
    And I set field "bsart" to "Fremdbeschaffung"
    Then field "flistestd" has value ""
    And I set field "bsart" to "Umlagern"
    Then field "flistestd" has value "BGX1-INT-EIGEN"
    And I close the current editor

  Scenario: 02 Artikel mit Fremdbeschaffungsstückliste

    Given I open an editor "EINKAUFX1" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such     | EINKAUFX1        |
      | namebspr | EINKAUFX1        |
      | bsart    | Fremdbeschaffung |
      | lief     | K-LIEF           |
      | efrist   | 3                |
      | epr      | 100              |
    And I delete all rows
    And I save the current editor

    Given I open an editor "EX1-INT-FREMD" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
    And I set fields
      | such      | EX1-INT-FREMD    |
      | artikel   | EINKAUFX1        |
      | bsart     | Fremdbeschaffung |
      | flistestd | ja               |
      | lgruppe   | KARLSRUHE        |
    And I append rows
      | elex      | elanzahl | bua                    |
      | BG-BEDARF | 1        | Lieferantenbeistellung |
    And I save the current editor

    Given I open an editor "EINKAUFX1" from table "(Part):(Product)" with command "VIEW" for record "EINKAUFX1"
    Then field "flistestd" has value "EX1-INT-FREMD"
    And I close the current editor

    Given I open an editor "EINKAUFX1" from table "(Part):(Product)" with command "UPDATE" for record "EINKAUFX1"
    And I set field "bsart" to "Eigenfertigung"
    Then field "flistestd" has value ""
    And I set field "bsart" to "Umlagern"
    Then field "flistestd" has value "EX1-INT-FREMD"
    And I close the current editor

  Scenario: 03 Artikel mit Fremdbeschaffungsstückliste

    Given I open an editor "MAXX1" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such     | MAXX1            |
      | namebspr | MAXX1            |
      | bsart    | Fremdbeschaffung |
      | lief     | K-LIEF           |
      | efrist   | 3                |
      | epr      | 100              |
    And I delete all rows
    And I save the current editor

    Given I open an editor "MAXX1-INT-FREMD" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
    And I set fields
      | such      | MAXX1-INT-FREMD  |
      | artikel   | MAXX1            |
      | bsart     | Fremdbeschaffung |
      | flistestd | ja               |
      | lgruppe   | KARLSRUHE        |
    And I append rows
      | elex      | elanzahl | bua                    |
      | BG-BEDARF | 1        | Lieferantenbeistellung |
    And I save the current editor

    Given I open an editor "MAXX1-INT-EIGEN" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
    And I set fields
      | such      | MAXX1-INT-EIGEN |
      | artikel   | MAXX1           |
      | bsart     | Eigenfertigung  |
      | flistestd | ja              |
      | lgruppe   | KARLSRUHE       |
    And I append rows
      | elex       | lge         | breite      | elanzahl |
      | E2         | !dontChange | !dontChange | 1        |
      | E3         | !dontChange | !dontChange | 1        |
      | A AG-LOHN1 | 20          | 10          | 1        |
    And I save the current editor

    Given I open an editor "MAXX1" from table "(Part):(Product)" with command "VIEW" for record "MAXX1"
    Then field "bsart" has value "Fremdbeschaffung"
    Then field "flistestd" has value "MAXX1-INT-FREMD"
    And I close the current editor

    Given I open an editor "MAXX1" from table "(Part):(Product)" with command "UPDATE" for record "MAXX1"
    And I set field "bsart" to "Eigenfertigung"
    Then field "flistestd" has value "MAXX1-INT-EIGEN"
    And I set field "bsart" to "Umlagern"
    Then field "flistestd" has value "MAXX1-INT-EIGEN"
    And I close the current editor

    Given I open an editor "MAXX1-BERLIN-EIGEN" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
    And I set fields
      | such      | MAXX1-BERLIN-EIGEN |
      | artikel   | MAXX1              |
      | bsart     | Eigenfertigung     |
      | flistestd | ja                 |
      | lgruppe   | Berlin             |
    And I append rows
      | elex       | lge         | breite      | elanzahl |
      | E2         | !dontChange | !dontChange | 1        |
      | E3         | !dontChange | !dontChange | 1        |
      | A AG-LOHN1 | 20          | 10          | 1        |
    And I save the current editor

    Given I open an editor "MAXX1-BERLIN-FREMD" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
    And I set fields
      | such      | MAXX1-BERLIN-FREMD |
      | artikel   | MAXX1              |
      | bsart     | Fremdbeschaffung   |
      | flistestd | ja                 |
      | lgruppe   | Berlin             |
    And I append rows
      | elex      | elanzahl | bua                    |
      | BG-BEDARF | 1        | Lieferantenbeistellung |
    And I save the current editor

    Given I open an editor "MAXX1-HK-EIGEN" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
    And I set fields
      | such      | MAXX1-HK-EIGEN |
      | artikel   | MAXX1          |
      | bsart     | Eigenfertigung |
      | flistestd | ja             |
      | lgruppe   | Hongkong       |
    And I append rows
      | elex       | lge         | breite      | elanzahl |
      | E2         | !dontChange | !dontChange | 1        |
      | E3         | !dontChange | !dontChange | 1        |
      | A AG-LOHN1 | 20          | 10          | 1        |
    And I save the current editor

    Given I open an editor "MAXX1-HK-FREMD" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
    And I set fields
      | such      | MAXX1-HK-FREMD   |
      | artikel   | MAXX1            |
      | bsart     | Fremdbeschaffung |
      | flistestd | ja               |
      | lgruppe   | Hongkong         |
    And I append rows
      | elex      | elanzahl | bua                    |
      | BG-BEDARF | 1        | Lieferantenbeistellung |
    And I save the current editor

    Given I open an editor "MAXX1" from table "(Part):(Product)" with command "UPDATE" for record "MAXX1"
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I append rows
      | lgruppe  | bsart            | umllg       |
      | BERLIN   | Fremdbeschaffung | !dontChange |
      | HONGKONG | Umlagern         | Karlsruhe   |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    Given I open an editor "MAXX1" from table "(Part):(Product)" with command "UPDATE" for record "MAXX1"
    And I set field "umllg" to "BERLIN"
    And I set field "bsart" to "Umlagern"
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    Then  field "flistestd" has value "MAXX1-BERLIN-FREMD" in row 1
    Then  field "flistestd" has value "MAXX1-BERLIN-FREMD" in row 2
