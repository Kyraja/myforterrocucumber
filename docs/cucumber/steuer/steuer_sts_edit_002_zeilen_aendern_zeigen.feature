# *****************************************************************************
#  Name             : steuer_sts_edit_002_zeilen_aendern_zeigen.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Zeilen bei Steuerschluessel (StS):
#                     * Einfuegen
#                     * Verschieben
#                     * Loeschen
#                     in AENDERN und ZEIGEN
#
#
# *****************************************************************************
@persistent

Feature: steuer_sts_edit_002_zeilen_aendern_zeigen.feature
Background: Behandlung von Zeilen bei StS


Scenario: AENDERN

# Verschieben
Given I open an editor "sts_update1" from table "(TaxCode):(TaxCode)" with command "UPDATE" for record "400"
Then the table has 7 rows
Then field "gvon" has value "01.01.1981" in row 1
Then field "gbis" has value "31.12.1985" in row 1
Then field "gvon" has value "01.01.2026" in row 7
Then field "gbis" has value "31.12.2035" in row 7
#
# 3834 TX=de |Verschieben von Zeilen nicht erlaubt
Then moving rows "7" to position "1" throws the exception "3834"
#
# Beweis, dass nichts verschoben wurde
Then the table has 7 rows
Then field "gvon" has value "01.01.1981" in row 1
Then field "gbis" has value "31.12.1985" in row 1
Then field "gvon" has value "01.01.2026" in row 7
Then field "gbis" has value "31.12.2035" in row 7
#
#
# 3834 TX=de |Verschieben von Zeilen nicht erlaubt
Then moving rows "2" to position "3" throws the exception "3834"
And I save the current editor
And I close the current editor


# Loeschen 1
Given I open an editor "sts_update2" from table "(TaxCode):(TaxCode)" with command "UPDATE" for record "400"
Then the table has 7 rows
Then field "gvon" has value "01.01.1981" in row 1
Then field "gbis" has value "31.12.1985" in row 1
Then field "gvon" has value "01.01.2026" in row 7
Then field "gbis" has value "31.12.2035" in row 7
#
# 784 TX=de |Zeilen einfügen oder löschen bei diesem Ereignis verboten
And deleting the row at position 4 throws the exception "784"
#
Then the table has 7 rows
#
# letzte Zeile loeschen
#
# 784 TX=de |Zeilen einfügen oder löschen bei diesem Ereignis verboten
And deleting the row at position 7 throws the exception "784"
Then the table has 7 rows
#
And I save the current editor
And I close the current editor


# Loeschen 2
Given I open an editor "sts_update3" from table "(TaxCode):(TaxCode)" with command "UPDATE" for record "1"
Then the table has 1 rows
#
# 10149 TX=de |Steuerperiode wird benutzt und kann nicht gelöscht werden.
And deleting the row at position 1 throws the exception "10149"
#
Then the table has 1 rows
And I save the current editor
And I close the current editor
#############################################################################################################################


Scenario: ZEIGEN

# Verschieben
Given I open an editor "sts_view1" from table "(TaxCode):(TaxCode)" with command "VIEW" for record "400"
Then the table has 7 rows
Then field "gvon" has value "01.01.1981" in row 1
Then field "gbis" has value "31.12.1985" in row 1
Then field "gvon" has value "01.01.2026" in row 7
Then field "gbis" has value "31.12.2035" in row 7
#
# 291 TX=de |Kommando erlaubt keine Änderungen
Then moving rows "7" to position "1" throws the exception "291"
#
# Beweis, dass nichts verschoben wurde
Then the table has 7 rows
Then field "gvon" has value "01.01.1981" in row 1
Then field "gbis" has value "31.12.1985" in row 1
Then field "gvon" has value "01.01.2026" in row 7
Then field "gbis" has value "31.12.2035" in row 7
#
#
# 291 TX=de |Kommando erlaubt keine Änderungen
Then moving rows "2" to position "3" throws the exception "291"
And I save the current editor
And I close the current editor


# Loeschen 1
Given I open an editor "sts_view2" from table "(TaxCode):(TaxCode)" with command "VIEW" for record "400"
Then the table has 7 rows
Then field "gvon" has value "01.01.1981" in row 1
Then field "gbis" has value "31.12.1985" in row 1
Then field "gvon" has value "01.01.2026" in row 7
Then field "gbis" has value "31.12.2035" in row 7
#
# 291 TX=de |Kommando erlaubt keine Änderungen
And deleting the row at position 4 throws the exception "291"
#
Then the table has 7 rows
#
# letzte Zeile loeschen
#
# 291 TX=de |Kommando erlaubt keine Änderungen
And deleting the row at position 7 throws the exception "291"
Then the table has 7 rows
#
And I save the current editor
And I close the current editor
#############################################################################################################################

