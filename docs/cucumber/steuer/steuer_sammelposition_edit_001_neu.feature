# *****************************************************************************
#  Name             : steuer_sammelposition_edit_001_neu.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Plausis in Sammelposition ueberwachen
#
#
# *****************************************************************************
@persistent
Feature: steuer_sammelposition_edit_001_neu.feature
Background: CRUD 54:5; Plausis in Sammelposition ueberwachen


Scenario: Neu anlegen 1
# Vorbelegung
Given I open an editor "sammelpos1" from table "(Evaluation):(CollectiveItem)" with command "NEW" for record ""
Then field "anteil" has value "1.00" in row 0

Then field "ustland" has value "DEUTSCHLAND" in row 0
Then field "iwbu" has value "EUR" in row 0
Then field "w2ist" is empty in row 0

Then field "postyp" is not empty in row 0
Then field "eva" is not empty in row 0
Then field "meldungsnr" is empty in row 0
Then field "nummer" is empty in row 0

Then the table has 0 rows
And I create a new row at the end of the table
Then field "ustposanteil" has value "1.00" in row 1
Then field "ustpos" is empty in row 1
#
# eine Position in der Tabelle eingetragen
And I set field "ustpos" to "81" in row 1
# -> Vorbelegung aus der Tabelle
Then field "postyp" has value "Mwst-Bemessung" in row 0
Then field "eva" has value "Verkauf" in row 0
Then field "ustposanteil" has value "1.00" in row 1
Then field "teva" has value "Verkauf" in row 1
Then field "tpostyp" has value "Mwst-Bemessung" in row 1
Then field "tw2ist" has value "" in row 1
Then field "tustland" has value "DEUTSCHLAND" in row 1
#
# eine weitere Zeile
And I create a new row at the end of the table
Then field "ustposanteil" has value "1.00" in row 2
Then field "ustpos" is empty in row 2
#
#  2981 TX=de   |UStVA-Position wird unzulaessigerweise mehrfach verwendet!
And setting field "ustpos" to "81" in row 2 throws the exception "2981"
And I set field "ustpos" to "50" in row 2
And I set field "ustposanteil" to "-1" in row 2
#
# Pflichfelder
And I set field "nummer" to "81SA" in row 0
And I set field "such" to "SA81" in row 0
#
#  279 TX=de   |Bitte eintragen
And saving the current editor throws the exception "279"
#
And I set field "meldungsnr" to "81" in row 0

And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: Neu anlegen 2
# Vorbelegung
Given I open an editor "sammelpos2" from table "(Evaluation):(CollectiveItem)" with command "NEW" for record ""
Then field "anteil" has value "1.00" in row 0

Then field "postyp" is not empty in row 0
Then field "eva" is not empty in row 0
Then field "meldungsnr" is empty in row 0
Then field "nummer" is empty in row 0

Then the table has 0 rows
And I create a new row at the end of the table
Then field "ustposanteil" has value "1.00" in row 1
Then field "ustpos" is empty in row 1
And I set field "ustpos" to "81" in row 1
And I set field "meldungsnr" to "81" in row 0
#
# Pflichfelder
And I set field "nummer" to "85SA" in row 0
#
# Pflichfeld "such" ist leer -> Fehlermeldung
#  10179 TX=de   |bitte eintragen
And saving the current editor throws the exception "10179"
#
And I set field "such" to "SA85" in row 0
#
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: Neu anlegen 3, Kontrollposition 1
# Vorbelegung
Given I open an editor "sammelpos3" from table "(Evaluation):(CollectiveItem)" with command "NEW" for record ""
Then field "anteil" has value "1.00" in row 0
#
Then field "postyp" is not empty in row 0
Then field "eva" is not empty in row 0
Then field "meldungsnr" is modifiable
Then field "meldungsnr" is empty in row 0
Then field "nummer" is empty in row 0
#
And I set field "postyp" to "Kontrolle" in row 0
Then field "meldungsnr" is not modifiable
Then setting field "meldungsnr" to "100" in row 0 throws the exception "203"
#
Then the table has 0 rows
And I create a new row at the end of the table
Then field "ustposanteil" has value "1.00" in row 1
Then field "ustpos" is empty in row 1
#
# eine "Bemessungsposition" bei "Konrolle" verwenden
Then setting field "ustpos" to "81" in row 1 throws the exception "1361"
And I set field "ustpos" to "581" in row 1
#
# Pflichfelder
And I set field "such" to "SA581" in row 0

# Pflichfeld "nummer" ist leer -> Fehlermeldung
# 10179 TX=de   |bitte eintragen
And saving the current editor throws the exception "10179"
#
And I set field "nummer" to "581SA" in row 0
#
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: Neu anlegen 4, ohne USt-Land
# Vorbelegung
Given I open an editor "sammelpos4" from table "(Evaluation):(CollectiveItem)" with command "NEW" for record ""
Then field "anteil" has value "1.00" in row 0

Then field "postyp" is not empty in row 0
Then field "eva" is not empty in row 0
Then field "meldungsnr" is empty in row 0
Then field "nummer" is empty in row 0
#
And I set field "meldungsnr" to "81" in row 0
# USt-Land leeren
And I set field "ustland" to "" in row 0
#
Then the table has 0 rows
And I create a new row at the end of the table
Then field "ustposanteil" has value "1.00" in row 1
Then field "ustpos" is empty in row 1
And I set field "ustpos" to "81" in row 1
#
And I create a new row at the end of the table
And I set field "ustpos" to "81CZ" in row 2
#
# Pflichfelder
And I set field "nummer" to "150SA" in row 0
And I set field "such" to "SA150" in row 0
#
And I save the current editor
And I close the current editor
# =========================================================================================

