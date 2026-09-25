# *****************************************************************************
#  Name             : steuer_sammelposition_edit_002_aendern.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Plausis in Sammelposition ueberwachen
#
#
# *****************************************************************************
@persistent
Feature: steuer_sammelposition_edit_002_aendern.feature
Background: CRUD 54:5; Plausis in Sammelposition ueberwachen



Scenario: Aendern; Leerzeile

# 
Given I open an editor "sammelpos_update" from table "(Evaluation):(CollectiveItem)" with command "UPDATE" for record "1SAM-CZ"
#  4157 TX=de   |andere Waehrung in der Tabelle verwendet
#  And setting field "w2ist" to "USD" in row 0 throws the exception "4157"
And I set field "w2ist" to "USD" in row 0
#
# eine weitere leere Zeile
And I create a new row at the end of the table
#  10179 TX=de   |bitte eintragen
And saving the current editor throws the exception "10179"
# Ohne Speichern rausgehen
And I close the current editor
# =========================================================================================


Scenario: Aendern; Zeilen verschieben

# 
Given I open an editor "sammelpos_update1" from table "(Evaluation):(CollectiveItem)" with command "UPDATE" for record "150SA"
Then the table has 2 rows
Then field "ustpos" has value "81" in row 1
Then field "tustland" has value "DEUTSCHLAND" in row 1
Then field "tw2ist" has value "" in row 1
Then field "ustpos" has value "81CZ" in row 2
Then field "tustland" has value "TSCHECHIEN" in row 2
Then field "tw2ist" has value "CZK" in row 2
And I move rows "1" to position "2"
And I move rows "2" to position "1"
#
# Ueberpuefung
Then the table has 2 rows
Then field "ustpos" has value "81CZ" in row 1
Then field "tustland" has value "TSCHECHIEN" in row 1
Then field "tw2ist" has value "CZK" in row 1
Then field "ustpos" has value "81" in row 2
Then field "tustland" has value "DEUTSCHLAND" in row 2
Then field "tw2ist" has value "" in row 2
#
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: Aendern; Zeilen loeschen

# Alle Zeilen
Given I open an editor "sammelpos_zeilen1" from table "(Evaluation):(CollectiveItem)" with command "UPDATE" for record "1SAM-CZ"
And I delete all rows
#
#  3001 TX=de   |Fuer Funktion mindestens eine Zeile in Tabelle notwendig!
And saving the current editor throws the exception "3001"
And I close the current editor

# eine Zeile
Given I open an editor "sammelpos_zeilen2" from table "(Evaluation):(CollectiveItem)" with command "UPDATE" for record "6VK-Alle"
Then the table has 3 rows
And I delete row at position 1
Then the table has 2 rows
#
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: Aendern; Fremdwaehrung eintragen

# USt-Formular auf "CZK" umstellen und versuchen eine Sammelposition ohne "CZK"
# in den Formular einzutragen
Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2022-CZK"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
# auf die Fremdwaehrung umstellen
And I set field "waehr" to "CZK"
And I press button "berech"
#
Then the table has 3 rows
And I create a new row at the end of the table
# Eintragen muss fuktionieren -> Speichern aber nicht!!!
And I set field "bempos" to "150SA" in row !lastRow
# 1052 TX=de |Waehrung der UStVA-Position muss mit Waehrung des USt-Formulars uebereinstimmen.
And saving the current editor throws the exception "1052"
#
# fehlerhafte Zeile entfernen
And I delete row at position !lastRow
Then the table has 3 rows
#
And I save the current editor
And I close the current editor


# eine Sammelposition auf "CZK" umstellen
Given I open an editor "sammelpos_fremdwaehr" from table "(Evaluation):(CollectiveItem)" with command "UPDATE" for record "150SA"
Then field "ustpos" has value "81CZ" in row 1
Then field "tustland" has value "TSCHECHIEN" in row 1
Then field "tw2ist" has value "CZK" in row 1
Then field "ustpos" has value "81" in row 2
Then field "tustland" has value "DEUTSCHLAND" in row 2
Then field "tw2ist" has value "" in row 2
#
And I set field "w2ist" to "CZK" in row 0
#
# 4157 TX=de |Andere Waehrung in der Tabelle verwendet.
And saving the current editor throws the exception "4157"
#
# USt-Position ohne Fremdwaehrung durch eine andere mit "CZK" ersetzen
And I set field "ustpos" to "43CZ" in row 2
#
And I save the current editor
And I close the current editor


# angepasste Sammelposition 150SA noch Mal versuchen in den Formular einzutragen
Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2022-CZK"
Then field "waehr" has value "CZK" in row 0
Then the table has 3 rows
#
And I create a new row at the end of the table
# Jetzt muss das Eintragen und das Speichern fuktionieren!!!
And I set field "bempos" to "150SA" in row !lastRow
And I press button "berech"
Then the table has 4 rows
#
And I save the current editor
And I close the current editor
# =========================================================================================


