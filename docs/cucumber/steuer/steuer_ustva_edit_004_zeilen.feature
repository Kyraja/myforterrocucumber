# *****************************************************************************
#  Name             : steuer_ustva_edit_004_zeilen.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : "Zeilen"-Plausis bei USTVA-Positionen
#
#
# *****************************************************************************
@persistent
Feature: steuer_ustva_edit_004_zeilen.feature
Background: "Zeilen"-Plausis bei USTVA-Positionen



Scenario: mehrzeilige Positionen

#   Modus NEU
#
Given I open an editor "postion81_copy" from table "(Evaluation):(ItemNumber)" with command "COPY" for record "81"
And I set field "nummer" to "81copy"
Then field "meldungsnr" has value "81" in row 0
Then field "postyp" has value "Mwst-Bemessung" in row 0
Then field "ivkz" is not modifiable
Then field "pvkz" is not modifiable
Then field "bgjahr" is modifiable
Then field "bwaehr" is modifiable
#
And I create a new row at the end of the table
And I set field "sts" to "0" in row !lastRow
Then field "tstsname" has value "Null-Steuerschlüssel" in row !lastRow
Then field "sts" has value "0" in row !lastRow
#
And I create a new row at the end of the table
And I set field "sts" to "2" in row !lastRow
#
# STS 1 nochmal eintragen -> wird nicht verhindert
And I create a new row at the end of the table
And I set field "sts" to "1" in row !lastRow
#
Then the table has 4 rows
And I save the current editor
And I close the current editor


Given I open an editor "postion550_copy" from table "(Evaluation):(ItemNumber)" with command "COPY" for record "550"
And I set field "nummer" to "550copy"
Then field "meldungsnr" is empty in row 0
Then field "postyp" has value "Kontrolle" in row 0
#
And I create a new row at the end of the table
And I set field "sts" to "0" in row !lastRow
#
And I create a new row at the end of the table
And I set field "sts" to "2" in row !lastRow
#
# STS 1 nochmal eintragen -> wird nicht verhindert
And I create a new row at the end of the table
And I set field "sts" to "1" in row !lastRow
#
#
And I delete row at position 2
#
Then the table has 3 rows
And I save the current editor
And I close the current editor


#   Modus AENDERN
#
Given I open an editor "postion1_update" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "81copy"
And I set field "nummer" to "888"
And I set field "anteil" to "1.00"
Then field "meldungsnr" has value "81" in row 0
Then field "postyp" has value "Mwst-Bemessung" in row 0
Then field "ivkz" is modifiable
Then field "pvkz" is modifiable
Then field "bgjahr" is modifiable
Then field "bwaehr" is modifiable
#
And I delete row at position !lastRow
#
Then the table has 3 rows
And I save the current editor
And I close the current editor


Given I open an editor "postion2_update" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "550copy"
And I set field "nummer" to "550copy2"
Then field "meldungsnr" is empty in row 0
Then field "postyp" has value "Kontrolle" in row 0
#
And I delete all rows
#
Then the table has 0 rows
# 2850 TX=de   |Tabelle unvollstaendig ausgefuellt!
Then saving the current editor throws the exception "2850"
#
And I create a new row at the end of the table
And I set field "sts" to "1" in row !lastRow
And I create a new row at the end of the table
And I set field "sts" to "2" in row !lastRow
Then the table has 2 rows
And I save the current editor
And I close the current editor

# P81 ist bei einem UStVA-Formular eingetragen
Given I open an editor "postion3_update" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "81"
Then field "meldungsnr" has value "81" in row 0
Then field "postyp" has value "Mwst-Bemessung" in row 0
#
And I create a new row at the end of the table
And I set field "sts" to "2" in row !lastRow
And I create a new row at the end of the table
And I set field "sts" to "0" in row !lastRow
Then the table has 3 rows
And I save the current editor

#   Modus LOESCHEN
#
Given I open an editor "postion1_delete" from table "(Evaluation):(ItemNumber)" with command "DELETE" for record "550copy2"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor


# 113 TX=de   |Darf wegen Fibu bzw. Zahlungserinnerungen nicht geloescht werden
#Given opening an editor from table "(Evaluation):(ItemNumber)" with command "DELETE" for record "81" throws the exception "113"
#And I save the current editor
#And I close the current editor
#############################################################################################################################

Scenario: bebuchten Zeilen


# P43 wurde mit STS 0 bebucht
Given I open an editor "postion4_update" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "43"
Then field "meldungsnr" has value "43" in row 0
Then field "postyp" has value "Mwst-Bemessung" in row 0
#
And I create a new row at the end of the table
And I set field "sts" to "2" in row !lastRow
And I create a new row at the end of the table
And I set field "sts" to "1" in row !lastRow
Then the table has 3 rows
And I save the current editor
And I close the current editor


Given I open an editor "postion5_update" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "43"
Then field "meldungsnr" has value "43" in row 0
Then field "postyp" has value "Mwst-Bemessung" in row 0
#
Then field "tstsname" has value "Null-Steuerschlüssel" in row 1
Then field "sts" has value "0" in row 1
# 784 TX=de   |Zeilen einfuegen oder loeschen bei diesem Ereignis verboten
And deleting the row at position 1 throws the exception "784"
Then the table has 3 rows
And I close the current editor
#############################################################################################################################


