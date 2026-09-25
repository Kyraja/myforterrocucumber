@persistent
Feature: fertigungslisten3.feature

# **********************************************************************************
#  Name             : fertigungsliste3.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : bheim
#  Funktion         : Std.-Fertigungslisten im artikel aendern
#  ref              : ref_fertigungslisten_cu
#  Stammdaten       : basis_stammdaten.feature
#
# **********************************************************************************

Scenario: 01 Artikel mit Eigenfertigungsstückliste

    Given I open an editor "BAUGRUPPEX4" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such     | BAUGRUPPEx4    |
      | namebspr | BAUGRUPPEX4    |
      | bsart    | Eigenfertigung |
      | lief     | K-LIEF         |
      | efrist   | 3              |
      | epr      | 100            |
    And I delete all rows
	And I append rows
      | elex       | lge         | breite      | elanzahl |
      | E2         | !dontChange | !dontChange | 1        |
      | E3         | !dontChange | !dontChange | 1        |
      | A AG1      | 20          | 10          | 1        |
    And I save the current editor

Scenario: 02 Artikel mit Fremdbeschaffungsfertigungsstückliste
    Given I open an editor "BGX4-FREMD" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
    And I set fields
      | such      | BGX4-FREMD        |
      | artikel   | BAUGRUPPEX4       |
      | bsart     | FREMDBESCHAFFUNG  |
      | flistestd | ja                |
      | lgruppe   | KARLSRUHE         |
    And I append rows
      | elex       | elanzahl    | bua                    |
      | BG-BEDARF  | 1           | Lieferantenbeistellung |
    And I save the current editor

Scenario: 03 Im Artikel Stueckliste pruefen
    Given I open an editor "BGX4" from table "(Part):(Product)" with command "VIEW" for record "BAUGRUPPEX4"
	Then field "flistestd" has value "STANDARD"
    Then the table has 3 rows
    Then table has values
      | elex      |
      | E2        |
      | E3        |
      | A AG1     |
	And I close the current editor


