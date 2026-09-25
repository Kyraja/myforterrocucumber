# *****************************************************************************
#  Name             : steuer_sammelposition_verwendung_001_eintragen.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Plausis in UStVA-Formular beim Eintragen von Sammelpositionen
#                     ueberwachen
#
#
# *****************************************************************************
@persistent
Feature: steuer_sammelposition_verwendung_001_eintragen.feature
Background: Plausis in UStVA-Formular


Scenario: eine abgelegte/geloeschte Sammelposition eintragen

Given I open an editor "sa_kopieren" from table "(Evaluation):(CollectiveItem)" with command "COPY" for record "8-VK-EU"
And I set field "nummer" to "8KOPIE" in row 0
And I save the current editor
And I close the current editor


# Versuch eine in einem Formular verwendete Sammelposition zu loeschen
Given I open an editor "loeschen1" from table "(Evaluation):(CollectiveItem)" with command "DELETE" for record "8KOPIE"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor


# Kontrolle, dass es wirklich geloescht wurde -> in der Ablage
Given I open an editor "sammelpos_update4" from table "(Evaluation):(CollectiveItem)" with command "VIEW" for record from editor "loeschen1"
Then field "ablagef" has value "ja" in row 0
Then field "ablagen" is not empty in row 0
And I close the current editor


Given I open an editor "formular_edit1" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
And I create a new row at the end of the table
And I set field "bempos" to id from editor "loeschen1" in row !lastRow
# Versuch mit abgelegter Position in der Tabelle abzuspeichern
And saving the current editor throws the exception "4959"
# abgelegte Position aus der Tabelle loeschen 
And I set field "bempos" to "" in row !lastRow
Then field "bempos" is empty in row !lastRow
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: Plausis

Given I open an editor "formular_edit1" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
And I create a new row at the end of the table
# eine "Konrollposition" bei "Bemessung" verwenden
Then setting field "bempos" to "555" in row !lastRow throws the exception "1361"
# eine "Bemessungsposition" bei "Konrolle" verwenden
Then setting field "kpos" to "8-VK-EU" in row !lastRow throws the exception "2985"
#
And I save the current editor
And I close the current editor


# mehrfach eine Sammelposition eintragen
Given I open an editor "formular_edit1" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "1UK"
And I create a new row at the end of the table
Then setting field "bempos" to "8-VK-EU" in row !lastRow throws the exception "2981"
And I press button "berech"
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: Fremdwaehrung

# Given I open an editor "formular_edit1" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
# And I create a new row at the end of the table
# # eine Sammelposition mit der 2. Waehrung
# And I set field "bempos" to "1SAM-CZ" in row !lastRow
# #
# And I save the current editor
# And I close the current editor


Given I open an editor "formular_edit1" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2022-CZK"
# auf die Fremdwaehrung umstellen
And I set field "waehr" to "CZK"
And I press button "berech"
#
And I create a new row at the end of the table
# eine Sammelposition mit der 2. Waehrung
And I set field "bempos" to "8-VK-EU" in row !lastRow
# 1052 TX=de |Waehrung der UStVA-Position muss mit Waehrung des USt-Formulars uebereinstimmen.
And saving the current editor throws the exception "1052"
# fehlerhafte Zeile entfernen
And I delete row at position !lastRow
#
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: USt-Land

Given I open an editor "formular_edit1" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
And I create a new row at the end of the table
# eine Sammelposition mit dem abweichenden Land eintragen
And I set field "bempos" to "1SAM-CZ" in row !lastRow
# 1058 TX=de |Das Land der Umsatzsteuerberechnung muss in Umsatzsteuerformular und Umsatzsteuerposition uebereinstimmen.
And saving the current editor throws the exception "1058"
# fehlerhafte Zeile entfernen
And I delete row at position !lastRow
#
And I save the current editor
And I close the current editor

