# *****************************************************************************
#  Name             : steuer_sammelposition_edit_003_loeschen.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Plausis in Sammelposition ueberwachen
#
#
# *****************************************************************************
@persistent
Feature: steuer_sammelposition_edit_003_loeschen.feature
Background: CRUD 54:5; Plausis in Sammelposition ueberwachen


Scenario: Loeschen1; eine verwendete Sammelposition

# Versuch eine in einem Formular verwendete Sammelposition zu loeschen
Given I open an editor "LOESCH-001" from table "(Evaluation):(CollectiveItem)" with command "DELETE" for record "1SAM-CZ"
# 8850 TX=de   |Datensatz darf nicht gelöscht werden, da er bereits verwendet wird.
Then saving the current editor throws the exception "8850"
And I close the current editor

# Kontrolle, dass wirklich nicht geloescht wurde
Given I open an editor "sammelpos_update3" from table "(Evaluation):(CollectiveItem)" with command "VIEW" for record "1SAM-CZ"
Then field "ablagef" has value "nein" in row 0
Then field "ablagen" is empty in row 0
And I close the current editor
# =========================================================================================


Scenario: Loeschen2; eine nicht verwendete Sammelposition

# Versuch eine in einem Formular verwendete Sammelposition zu loeschen
Given I open an editor "LOESCH-002" from table "(Evaluation):(CollectiveItem)" with command "DELETE" for record "85SA"
# 826 de      |Wirklich löschen?
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

# Kontrolle, dass es wirklich geloescht wurde -> in der Ablage
Given I open an editor "sammelpos_update4" from table "(Evaluation):(CollectiveItem)" with command "VIEW" for record from editor "LOESCH-002"
Then field "ablagef" has value "ja" in row 0
Then field "ablagen" is not empty in row 0
And I close the current editor
# =========================================================================================




Scenario: Loeschen3; eine USt-Position, die in einer Sammelposition verwendet wird

Given I open an editor "LOESCH-003" from table "(Evaluation):(ItemNumber)" with command "DELETE" for record "21"
# 826 de      |Wirklich löschen?
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

# Kontrolle, dass es wirklich geloescht wurde -> in der Ablage
Given I open an editor "sammelpos_update4" from table "(Evaluation):(ItemNumber)" with command "VIEW" for record from editor "LOESCH-003"
Then field "ablagef" has value "ja" in row 0
Then field "ablagen" is not empty in row 0
And I close the current editor


Given I open an editor "sammelpos_kontrolle" from table "(Evaluation):(CollectiveItem)" with command "UPDATE" for record "8-VK-EU"
Then the table has 2 rows
Then field "ustpos" has value "41" in row 1
# eine abgelegte USt-Position
Then field "ustpos" has value "+21" in row 2
#
# 4959 TX=de |abgelegter Datensatz
And saving the current editor throws the exception "4959"
#
# Zeile mit der abgelegten USt-Position
And I delete row at position 2
Then the table has 1 rows
#
And I save the current editor
And I close the current editor
# =========================================================================================



