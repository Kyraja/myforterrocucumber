@persistent
Feature: Artikelbereich Diverses

# *****************************************************************************************
#  Name           : artberdiv.feature
#  Autor          : as/foe
#  Verantwortlich : as
#  Kontrolle      : foe
#  Funktion       : Script zum Testen diverser Funktionalitaeten in Artikelbereichen
#  Beschreibung   :
# *****************************************************************************************
#
#--------------------------------------------------------------------------------------------
Scenario: Selektionsleisten anlegen
#--------------------------------------------------------------------------------------------
Given I open an editor "Selektionsleiste-1" from table "(Company):(SelectionBar)" with command "NEW" for record ""
And I set fields
	| such     | T_TE          |
	| namebspr | Test Artikel  |
And I append rows
   | merkmalname |
   | name        |
And I save the current editor

Given I open an editor "Selektionsleiste-2" from table "(Company):(SelectionBar)" with command "NEW" for record ""
And I set fields
	| such     | T_ZP                 |
	| namebspr | Test Zusatzposition  |
# Gruppe Artikel und Zusatzposition auswählen
And I set field "grliste" to "2:4"
And I append rows
   | merkmalname |
   | name        |
And I save the current editor

Given I open an editor "Selektionsleiste-3" from table "(Company):(SelectionBar)" with command "NEW" for record ""
And I set fields
	| such     | T_TEZP                           |
	| namebspr | Test Artikel und Zusatzposition  |
And I set field "grliste" to "2:1.4"
And I append rows
   | merkmalname |
   | name        |
And I save the current editor

Given I open an editor "Selektionsleiste-4" from table "(Company):(SelectionBar)" with command "NEW" for record ""
And I set fields
	| such     | T_DL                 |
	| namebspr | Test Dienstleistung  |
And I set field "grliste" to "2:5"
And I append rows
   | merkmalname |
   | name        |
And I save the current editor

Given I open an editor "Selektionsleiste-5" from table "(Company):(SelectionBar)" with command "NEW" for record ""
And I set fields
	| such     | T_TEZPDL                                      |
	| namebspr | Test Artikel, Dienstleistung, Zusatzposition  |
And I set field "grliste" to "2:1.4.5"
And I append rows
   | merkmalname |
   | name        |
And I save the current editor

Given I open an editor "Selektionsleiste-6" from table "(Company):(SelectionBar)" with command "NEW" for record ""
And I set fields
	| such     | T_TEZPDLFM                                                      |
	| namebspr | Test Artikel, Dienstleistung, Zusatzposition, Fertigungsmittel  |
And I set field "grliste" to "2:1.2.4.5"
And I append rows
   | merkmalname |
   | name        |
And I save the current editor

#--------------------------------------------------------------------------------------------
Scenario: Fertigungsmittel, Dienstleistung anlegen
#--------------------------------------------------------------------------------------------
Given I open an editor "TeilFertigungsmittel-2" from table "(Part):(MeansOfProduction)" with command "NEW" for record ""
And I set fields
	| such     | TEST_FM                |
	| namebspr | Test Fertigungsmittel  |
And I save the current editor

Given I open an editor "TeilDienstleistung-3" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| such     | TEST_DL              |
	| namebspr | Test Dienstleistung  |
Then I append text " " to output file "artberdiv.out"
And I save the current editor

#--------------------------------------------------------------------------------------------
Scenario: Artikelbereich anlegen
#--------------------------------------------------------------------------------------------
Given I open an editor "Artikelbereich-1" from table "(ProductRange):(ProductRange)" with command "NEW" for record ""
And I set fields
	| such | ARTBERDIV1                |
	| name | Artikelbereich diverse 1  |
And I append rows
	| abereich |
	| EINKAUF  |
# Artikelbereich und Zusatzartikelbereich sind identisch.
Then setting field "zabereich" to "EINKAUF" in row 1 throws the exception "9167"
And I close the current editor

Given I open an editor "Artikelbereich-2" from table "(ProductRange):(ProductRange)" with command "NEW" for record ""
And I set fields
	| such | ARTBERDIV1                |
	| name | Artikelbereich diverse 1  |
And I append rows
	| abereich    | artikel     | selekt      | plaktiv     | catactiv    | kategorie       | zabereich   |
	| EINKAUF     | !dontChange | !dontChange | j           | j           | Zubehoer        | VERKAUF     |
	| !dontChange | BG1         | !dontChange | j           | j           | Katalogposition | !dontChange |
	| !dontChange | E2          | !dontChange | !dontChange | !dontChange | Katalogposition | !dontChange |
	| !dontChange | !dontChange | T_TE        | !dontChange | j           | Upseller        | !dontChange |
	| !dontChange | e1          | !dontChange | !dontChange | !dontChange | Katalogposition | !dontChange |
	| !dontChange | !dontChange | T_ZP        | !dontChange | j           | Restposten      | !dontChange |
	| !dontChange | e3          | !dontChange | j           | j           | Ersatzteil      | !dontChange |
	| !dontChange | !dontChange | T_TEZP      | !dontChange | j           | Topseller       | !dontChange |
	| !dontChange | V1          | !dontChange | j           | j           | Katalogposition | !dontChange |
	| !dontChange | TEST_DL     | !dontChange | !dontChange | j           | !dontChange     | !dontChange |
	| !dontChange | TEST_FM     | !dontChange | !dontChange | !dontChange | !dontChange     | !dontChange |
	| !dontChange | !dontChange | T_DL        | !dontChange | j           | !dontChange     | !dontChange |
	| !dontChange | !dontChange | T_TEZPDL    | !dontChange | j           | !dontChange     | !dontChange |

# Schreibschutz pruefen
Then field "artikel" is not modifiable in row 1
Then field "selekt" is not modifiable in row 1
Then field "abereich" is not modifiable in row 2
Then field "selekt" is not modifiable in row 2
Then field "selekt" is not modifiable in row 3
Then field "abereich" is not modifiable in row 3
Then field "abereich" is not modifiable in row 4
Then field "artikel" is not modifiable in row 4
Then field "abereich" is not modifiable in row 5
Then field "selekt" is not modifiable in row 5
Then field "artikel" is not modifiable in row 6
Then field "abereich" is not modifiable in row 6
Then field "plaktiv" is not modifiable in row 6
Then field "selekt" is not modifiable in row 7
Then field "abereich" is not modifiable in row 7
Then field "plaktiv" is not modifiable in row 8
Then field "abereich" is not modifiable in row 8
Then field "artikel" is not modifiable in row 8
Then field "abereich" is not modifiable in row 10
Then field "selekt" is not modifiable in row 10
Then field "plaktiv" is not modifiable in row 10
Then field "selekt" is not modifiable in row 11
Then field "plaktiv" is not modifiable in row 11
Then field "abereich" is not modifiable in row 11
Then field "catactiv" is not modifiable in row 11
Then field "abereich" is not modifiable in row 12
Then field "artikel" is not modifiable in row 12
Then field "plaktiv" is not modifiable in row 12
Then field "artikel" is not modifiable in row 13
Then field "plaktiv" is not modifiable in row 13
Then field "abereich" is not modifiable in row 13
Then setting field "abereich" to "EINKAUF" in row 13 throws the exception "203"

# TODO mibr: append text funktioniert erst, nachdem append to outputfile einmal gelaufen ist.
Then I append text "ARTIKELBEREICH - NEU" to output file "artberdiv.out"
Then I append text "" to output file "artberdiv.out"
Then I fill template "artikelbereiche.ftl" and append it to output file "../../artberdiv.out"
And I save the current editor

Given I open an editor "Artikelbereich-3" from table "(ProductRange):(ProductRange)" with command "NEW" for record ""
And I create a new row at the end of the table
And setting field "selekt" to "HALLO123" in row 1 throws the exception "149"
And I close the current editor

Given I open an editor "Artikelbereich-4" from table "(ProductRange):(ProductRange)" with command "NEW" for record ""
And I create a new row at the end of the table
And setting field "selekt" to "SEL-KALK" in row 1 throws the exception "9126"
And I close the current editor

Given I open an editor "Artikelbereich-5" from table "(ProductRange):(ProductRange)" with command "NEW" for record ""
And I create a new row at the end of the table
And setting field "selekt" to "T_TEZPDLFM" in row 1 throws the exception "9126"
And I close the current editor

#--------------------------------------------------------------------------------------------
Scenario: Artikelbereich aendern
#--------------------------------------------------------------------------------------------
Given I open an editor "Artikelbereich-1" from table "(ProductRange):(ProductRange)" with command "UPDATE" for record "ARTBERDIV1"
And I press button "catall"
And I press button "planall"
Then I append text "ARTIKELBEREICH - ALLE AKTIVIEREN/DEAKTIVIEREN 1" to output file "artberdiv.out"
Then I fill template "artikelbereiche.ftl" and append it to output file "../../artberdiv.out"

And I press button "catall"
And I press button "planall"
Then I append text "ARTIKELBEREICH - ALLE AKTIVIEREN/DEAKTIVIEREN 2" to output file "artberdiv.out"
Then I fill template "artikelbereiche.ftl" and append it to output file "../../artberdiv.out"

And I press button "catall"
And I press button "planall"
Then I append text "ARTIKELBEREICH - ALLE AKTIVIEREN/DEAKTIVIEREN 3" to output file "artberdiv.out"
Then I fill template "artikelbereiche.ftl" and append it to output file "../../artberdiv.out"
And I save the current editor

#--------------------------------------------------------------------------------------------
Scenario: Selektionsleiste aendern
#--------------------------------------------------------------------------------------------
Given I open an editor "Selektionsleiste-1U" from table "(Company):(SelectionBar)" with command "UPDATE" for record "T_TE"
# + Fertigungsmittel
And I set field "grliste" to "2:1.2"
Then saving the current editor throws the exception "9166"
# - Fertigungsmittel
And I set field "grliste" to "2:1"
And I save the current editor
