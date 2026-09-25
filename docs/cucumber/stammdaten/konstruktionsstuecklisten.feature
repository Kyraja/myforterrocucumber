@persistent
Feature: konstruktionsstuecklisten.feature

  Background:
    And I set the fake date to "01.01.2000"

    Given I'm logged in with password "sy"

# *****************************************************************************
#  Name             : konstruktionsstuecklisten.feature
#  Autor            : bschiga
#  Verantwortlich   : amk
#  Kontrolle        : lbettendorf
#  Funktion         : Testet Erstellen und Verwenden Konstruktionsstuecklisten
#
# *****************************************************************************

## basisartikel.feature als Vorgänger

  Scenario: Konstruktionsstückliste neu anlegen und Plausis testen

# Konstruktionsstückliste neu anlegen, Standard kann nicht gesetzt werden
    Given I open an editor "KONSTR01" from table "(ProductionList):(ProductionList)" with command "STORE" for record "KONSTR01"
    And I set fields
      | such      | KONSTR01                |
      | artikel   | BG1                     |
      | flistetyp | Konstruktionsstückliste |
# 2996 |Eine Konstruktionsstücklisteliste darf nicht als Standard markiert werden.
    Then setting field "flistestd" to "ja" throws the exception "2996"
    And I delete all rows
    And I append rows
      | elex  | elanzahl |
      | EINK  | 1        |
      | E3    | 1        |
      | A AG1 | 1        |
    And I save the current editor

# beim Neu anlegen ist Typ Fertigungsliste vorbelegt, flistetyp darf nicht leer sein
    Given I open an editor "KONSTR02" from table "(ProductionList):(ProductionList)" with command "STORE" for record "KONSTR02"
    And I set fields
      | such    | KONSTR02 |
      | artikel | BAUT     |
    Then field "flistetyp" has value "Fertigungsliste"
    And I set field "flistetyp" to ""
# 10179 |bitte eintragen
    Then saving the current editor throws the exception "10179"
    And I set field "flistetyp" to "Konstruktionsstückliste"
    And I delete all rows
    And I append rows
      | tbasisartikel | elex  | elanzahl |
      | BAS_BED       |       | 1        |
      |               | E3    | 1        |
      |               | A AG1 | 1        |
    And I save the current editor

# Konstruktionsstückliste darf nicht im Artikel verwendet werden
    Given I open an editor "BG1" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
# 3101 |Eine Konstruktionsstückliste darf nicht verwendet werden.
    Then setting field "flistestd" to "KONSTR01" throws the exception "3101"
    And I close the current editor

# Umstellen von Fertigungsliste auf Konstruktionsstückliste geht nicht, wenn irgendwo als Standard markiert
    Given I open an editor "FL" via ID from editor "BG1" from field "flistestd" in row 0 for table "(ProductionList):(ProductionList)" with command "UPDATE"
    Then field "flistetyp" has value "Fertigungsliste"
# 2996 |Eine Konstruktionsstücklisteliste darf nicht als Standard markiert werden.
    Then setting field "flistetyp" to "Konstruktionsstückliste" throws the exception "2996"
    And I close the current editor


# FV Neu anlegen, versuchen Konstruktionsstückliste einzutragen
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "artikel" to "BAUT" in row 1
    And I set field "netmge" to "5" in row 1
    And I press button "absteig" to open a subeditor for "AFL" in row 1
# 7708 |%s: ist keine Fertigungsliste dieses Artikels in der Lagergruppe.
    Then setting field "flistestd" to "KONSTR01" throws the exception "0"
# 3101 |Eine Konstruktionsstückliste darf nicht verwendet werden.
    Then setting field "flistestd" to "KONSTR02" throws the exception "3101"
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

# FV Ändern, Absteigen in AFL des FV, Konstruktionsstückliste kann nicht verwendet werden
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BAUT"
    And I press button "ladetab"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
# 3101 |Eine Konstruktionsstückliste darf nicht verwendet werden.
    Then setting field "flistestd" to "KONSTR02" throws the exception "3101"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor


# Konstruktionsstückliste kann auch nicht verwendet werden in Auftragsposition
    Given I open an editor "AUF_BG1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | KUNDE1  |
      | such  | AUF_BG1 |
      | vom   | .       |
    And I append rows
      | artikel | mge | einplan |
      | BG1     | 10  | ja      |
	# 3101 |Eine Konstruktionsstückliste darf nicht verwendet werden.
    Then setting field "flistestd" to "KONSTR01" in row 1 throws the exception "3101"
    And I close the current editor

