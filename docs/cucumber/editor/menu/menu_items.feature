# *****************************************************************************
#  Name           : menu_items.feature
#  Verantwortlich : @forterro-prd/t024-abas-core
#  Funktion       : Testet die Kernbehandlung von Menüfeldern
# *****************************************************************************
@persistent
@INSERT_MENU_ITEMS_TEST
Feature: MENU_ITEMS_65:1

Scenario: CreateNewInfosystem

Given I'm logged in with password "sy"
Given I open an editor "Infosystem neu" from table "(Infosystem):(Infosystem)" with command "NEW" for record ""
And I set field "such" to "MENU"
And I set field "arb" to "ow1"
And I set field "maskorigin" to "Automatisch erzeugen"
And I set field "layoutorigin" to "Keine Ausgabe"
And I set field "zeilereinerlaubt" to "ja"
And I set field "zeilerauserlaubt" to "nein"
And I set field "zeilebewerlaubt" to "nein"
And I modify table
    | !row                        | inmask | param       | vms             |
    | vname=='ismenueauswahl'     | 1      | !dontChange | !dontChange     |
    | vname=='itzn'               | 1      | !dontChange | !dontChange     |
    | vname=='istmenueausgewaehlt'| 1      | Eingabe     | änderbar        |
    | vname=='istbaumtext'        | 1      | Eingabe     | änderbar        |
And I save the current editor
And I close the current editor

Scenario: SelectMenuOptions

Given I'm logged in with password "sy"
Given I open the infosystem "MENU"
Then editor status "INSERTROWS" has value "1"
Then editor status "DELETEROWS" has value "0"
Then editor status "MOVEROWS" has value "0"
And I append rows
    | tbaumtext |
    | Eins      |
    | Zwei      |
    | Drei      |
    | Vier      |
    | Fünf      |
Then field "menueauswahl" has value "0"
# Auswahl treffen und wieder wegnehmen
And I set field "tmenueausgewaehlt" to "ja" in row 3
Then field "menueauswahl" has value "3"
And I set field "tmenueausgewaehlt" to "nein" in row 3
Then field "menueauswahl" has value "0"
# Auswahl treffen und ändern
And I set field "tmenueausgewaehlt" to "ja" in row 1
Then field "menueauswahl" has value "1"
And I set field "tmenueausgewaehlt" to "ja" in row 5
Then field "menueauswahl" has value "5"
Then field "tmenueausgewaehlt" has value "nein" in row 1
# Menüauswahl im Druckdialog des Infosystems
And I press button "budruck" to open a subeditor for "Druckdialog"
# ?!
Then editor status "INSERTROWS" has value "1"
# ?!
Then editor status "DELETEROWS" has value "1"
# ?!
Then editor status "MOVEROWS" has value "0"
And I set field "tmenueausgewaehlt" to "ja" in row 3
Then field "menueauswahl" has value "3"
And I set field "tmenueausgewaehlt" to "nein" in row 3
Then field "menueauswahl" has value "0"
# Auswahl treffen und ändern
And I set field "tmenueausgewaehlt" to "ja" in row 1
Then field "menueauswahl" has value "1"
And I set field "tmenueausgewaehlt" to "ja" in row 2
Then field "menueauswahl" has value "2"
Then field "tmenueausgewaehlt" has value "nein" in row 1
# Bei getroffner Menüauswahl kein Einfügen/Löschen von Zeilen
Then creating a new row at position !lastRow throws the exception "294"
Then deleting the row at position 1 throws the exception "295"
And I set field "tmenueausgewaehlt" to "nein" in row 2
Then field "menueauswahl" has value "0"
And I create a new row at the end of the table
And I delete row at position !lastRow
And I close the current subeditor to switch back to the parent editor
And I close the current editor
