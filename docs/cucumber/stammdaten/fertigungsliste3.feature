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


  Scenario: 01 Artikel mit Fremdbeschaffung
    Given I open an editor "STDFLTEST" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such     | STDFLTEST        |
      | namebspr | STDFLTEST        |
      | bsart    | Fremdbeschaffung |
      | lief     | K-LIEF           |
      | efrist   | 3                |
      | epr      | 100              |
    And I delete all rows
    And I append rows
      | elex       | lge         | breite      | elanzahl |
      | E2         | !dontChange | !dontChange | 1        |
      | E3         | !dontChange | !dontChange | 1        |
      | A AG1      | 20          | 10          | 1        |
    And I save the current editor

  Scenario: 02 Artikel mit Fremdfertigungsstückliste
    Given I open an editor "FREMDFLTEST" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
    And I set fields
      | such      | FREMDFLTEST      |
      | namebspr  | FREMDFLTEST      |
	    | artikel   | STDFLTEST        |
	    | lgruppe   | Karlsruhe        |
      | bsart     | Fremdbeschaffung |
	    | flistestd | ja               |
    And I delete all rows
	  And I append rows
      | elex      | elanzahl | bua                    |
      | BG-BEDARF | 1        | Lieferantenbeistellung |
    And I save the current editor


  Scenario: 03 Artikel mit Eigenfertigungsstückliste
    Given I open an editor "EIGENFLTEST" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
    And I set fields
      | such      | EIGENFLTEST    |
      | namebspr  | EIGENFLTEST    |
	    | artikel   | STDFLTEST      |
	    | lgruppe   | Karlsruhe      |
      | bsart     | Eigenfertigung |
	    | flistestd | ja             |
    And I delete all rows
	  And I append rows
      | elex       | lge         | breite      | elanzahl |
      | E2         | !dontChange | !dontChange | 1        |
      | E3         | !dontChange | !dontChange | 1        |
      | A AG1      | 20          | 10          | 1        |
    And I save the current editor

  Scenario: 04 Artikel auf umlagern umstellen
    Given I open an editor "STDFLTEST" from table "(Part):(Product)" with command "UPDATE" for record "STDFLTEST"
	  And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
	  And I delete all rows
    And I append rows
	    | lgruppe | bsart          |
	    | Berlin  | Eigenfertigung |
	  And I save the current subeditor to switch back to the parent editor
	  And I set fields
	    | umllg | Berlin   |
	    | bsart | Umlagern |
	  And I save the current editor

  Scenario: 05 Standardkenner testen in FL
    Given I open an editor "EIGENFLTEST" from table "(ProductionList):(ProductionList)" with command "VIEW" for record "EIGENFLTEST"
	  Then field "flistestd" has value "ja"
	  And I close the current editor
	
	  Given I open an editor "FREMDFLTEST" from table "(ProductionList):(ProductionList)" with command "VIEW" for record "FREMDFLTEST"
	  Then field "flistestd" has value "ja"
	  And I close the current editor

  Scenario: 06 Im Artikel neue Fertigungsliste erstellen
    Given I open an editor "STDFLTEST" from table "(Part):(Product)" with command "UPDATE" for record "STDFLTEST"
	  And I set field "flistestd" to " "
	  Then the table has 0 rows
	  And I append rows
      | elex       | lge         | breite      | elanzahl |
      | E3         | !dontChange | !dontChange | 1        |
      | E2         | !dontChange | !dontChange | 1        |
      | A AG1      | 30          | 20          | 1        |
	  And I save the current editor

  Scenario: 07 Standardkenner testen in FL
    Given I open an editor "EIGENFLTEST" from table "(ProductionList):(ProductionList)" with command "VIEW" for record "EIGENFLTEST"
	  Then field "flistestd" has value "nein"
    Then field "bsart" has value "Eigenfertigung"
	  And I close the current editor
	
	  Given I open an editor "FREMDFLTEST" from table "(ProductionList):(ProductionList)" with command "VIEW" for record "FREMDFLTEST"
	  Then field "flistestd" has value "ja"
    Then field "bsart" has value "Fremdbeschaffung"
	  And I close the current editor

  Scenario: 08 Im Artikel alte Fertigungsliste wieder einsetzen
    Given I open an editor "STDFLTEST" from table "(Part):(Product)" with command "UPDATE" for record "STDFLTEST"
	  And I set field "flistestd" to "EIGENFLTEST"
	  And I save the current editor

  Scenario: 09 Eigenfertigungsstückliste aendern
    Given I open an editor "EIGENFLTEST" from table "(ProductionList):(ProductionList)" with command "UPDATE" for record "EIGENFLTEST"
    Then field "flistestd" has value "ja"
	  And I append rows
      | elex       | lge         | breite      | elanzahl |
      | BG1        | !dontChange | !dontChange | 1        |
      | A AG2      | 20          | 10          | 1        |
    And I save the current editor

  Scenario: 10 Im Artikel Stueckliste pruefen
    Given I open an editor "STDFLTEST" from table "(Part):(Product)" with command "UPDATE" for record "STDFLTEST"
	  Then field "flistestd" has value "EIGENFLTEST"
    Then the table has 5 rows
        Then table has values
      | elex      |
      | E2        |
      | E3        |
      | A AG1     |
      | BG1       |
      | A AG2     |
	  And I close the current editor
