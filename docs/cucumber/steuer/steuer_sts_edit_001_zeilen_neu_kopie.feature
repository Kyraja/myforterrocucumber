# *****************************************************************************
#  Name             : steuer_sts_edit_001_zeilen_neu_kopie.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Zeilen bei Steuerschluessel (StS):
#                     * Einfuegen
#                     * Verschieben
#                     * Loeschen
#                     in NEU und KOPIE
#
#
# *****************************************************************************
@persistent

Feature: steuer_sts_edit_001_zeilen_neu_kopie.feature
Background: Behandlung von Zeilen bei StS



Scenario: NEU

# ohne Zeilen
Given I open an editor "sts_new1" from table "(TaxCode):(TaxCode)" with command "NEW" for record ""
And I set field "namebspr" to "STS 100"
And I set field "such" to "STS100"
And I set field "nummer" to "100"
Then the table has 0 rows
And I save the current editor
And I close the current editor


# leere Zeile
Given I open an editor "sts_new2" from table "(TaxCode):(TaxCode)" with command "NEW" for record ""
And I set field "namebspr" to "STS 200"
And I set field "such" to "STS200"
And I set field "nummer" to "200"
And I create a new row at the end of the table
Then the table has 1 rows
#
# 279 TX=de   |Bitte eintragen
Then saving the current editor throws the exception "279"
And I set field "gperr" to "PER1" in row 1
#
# kein Steuersatz angegeben, kein Nullsteuerschluessel
Then field "psatz" has value "0.00" in row 1
Then field "nullsts" has value "nein" in row 0
And I save the current editor
And I close the current editor


# mehrere Zeilen
Given I open an editor "sts_new3" from table "(TaxCode):(TaxCode)" with command "NEW" for record ""
And I set field "namebspr" to "STS 300"
And I set field "such" to "STS300"
And I set field "nummer" to "300"
# 1. Zeile
And I create a new row at the end of the table
And I set field "gperr" to "PER1" in row 1
And I set field "psatz" to "15" in row 1
Then field "gvon" has value "01.01.1981" in row 1
Then field "gbis" has value "31.12.2080" in row 1
And I set field "gbis" to "31.12.1985" in row 1
# 2. Zeile
And I create a new row at the end of the table
And I set field "gperr" to "PER2" in row 2
And I set field "psatz" to "20" in row 2
Then field "gvon" has value "01.01.1986" in row 2
Then field "gbis" has value "31.12.2080" in row 2
And I set field "gbis" to "31.12.1990" in row 2
# 3. Zeile
And I create a new row at the end of the table
And I set field "gperr" to "PER3" in row 3
And I set field "psatz" to "30" in row 3
Then field "gvon" has value "01.01.1991" in row 3
Then field "gbis" has value "31.12.2080" in row 3
And I set field "gbis" to "31.12.1998" in row 3
#
# 4. Zeile - sie wird geloescht
And I create a new row at the end of the table
And I set field "gperr" to "PER3A" in row 4
And I set field "psatz" to "33" in row 4
Then field "gvon" has value "01.01.1999" in row 4
Then field "gbis" has value "31.12.2080" in row 4
And I set field "gbis" to "31.12.2005" in row 4
# 5. Zeile
And I create a new row at the end of the table
And I set field "gperr" to "PER4" in row 5
And I set field "psatz" to "10" in row 5
Then field "gvon" has value "01.01.2006" in row 5
Then field "gbis" has value "31.12.2080" in row 5
And I set field "gbis" to "31.12.2020" in row 5
#
Then the table has 5 rows
# 
And I delete row at position 4
# 10042 TX=de   |Zeitbereich muss fortlaufend und lückenlos sein.
Then saving the current editor throws the exception "10042"
Then field "gbis" has value "31.12.1998" in row 3
Then field "gvon" has value "01.01.2006" in row 4
And I set field "gvon" to "01.01.1999" in row 4
Then the table has 4 rows
And I save the current editor
And I close the current editor
#############################################################################################################################


Scenario: KOPIE

# Kopie mit mehreren Zeilen
Given I open an editor "sts_copy1" from table "(TaxCode):(TaxCode)" with command "COPY" for record "300"
And I set field "namebspr" to "STS 400"
And I set field "such" to "STS400"
And I set field "nummer" to "400"
Then field "gbis" has value "31.12.1998" in row 3
Then field "gvon" has value "01.01.1999" in row 4
Then field "gbis" has value "31.12.2020" in row 4
Then the table has 4 rows
And I create a new row at position 4
And I set field "gperr" to "PER3A" in row 4
And I set field "psatz" to "33" in row 4
Then field "gvon" has value "01.01.1999" in row 4
Then field "gbis" has value "31.12.2080" in row 4
And I set field "gbis" to "31.12.2005" in row 4
Then the table has 5 rows
# 10042 TX=de   |Zeitbereich muss fortlaufend und l�ckenlos sein.
Then saving the current editor throws the exception "10042"
#
Then field "gbis" has value "31.12.2005" in row 4
Then field "gvon" has value "01.01.1999" in row 5
Then field "gbis" has value "31.12.2020" in row 5
# 'gvon' muss angepasst werden
And I set field "gvon" to "01.01.2006" in row 5
#
# 6. Zeile
And I create a new row at the end of the table
And I set field "gperr" to "PER5" in row 6
And I set field "psatz" to "17,5" in row 6
Then field "gvon" has value "01.01.2021" in row 6
Then field "gbis" has value "31.12.2080" in row 6
And I set field "gbis" to "31.12.2025" in row 6
Then the table has 6 rows
#
# 7. Zeile
And I create a new row at the end of the table
And I set field "gperr" to "PER6" in row 7
And I set field "psatz" to "17,5" in row 7
Then field "gvon" has value "01.01.2026" in row 7
Then field "gbis" has value "31.12.2080" in row 7
And I set field "gbis" to "31.12.2025" in row 7
Then the table has 7 rows
#
# 812 TX=de   |Datumsuntergrenze gr��er als Datumsobergrenze
Then saving the current editor throws the exception "812"
And I set field "gbis" to "31.12.2035" in row 7
#
# Zeilen verschieben
And I move rows "7" to position "1"
Then the table has 7 rows
Then field "gvon" has value "01.01.2026" in row 1
Then field "gbis" has value "31.12.2035" in row 1
Then field "gvon" has value "01.01.1981" in row 2
Then field "gbis" has value "31.12.1985" in row 2
Then field "gvon" has value "01.01.2021" in row 7
Then field "gbis" has value "31.12.2025" in row 7
#
# 10042 TX=de   |Zeitbereich muss fortlaufend und l�ckenlos sein.
Then saving the current editor throws the exception "10042"
#
# Zeilen zur�ckverschieben
# gut zu wissen: es gibt 7 Zeilen. Um ans Ende zu verschieben muss man die Position 8 angeben!!!
And I move rows "1" to position "8"
Then the table has 7 rows
Then field "gvon" has value "01.01.1981" in row 1
Then field "gbis" has value "31.12.1985" in row 1
Then field "gvon" has value "01.01.2021" in row 6
Then field "gbis" has value "31.12.2025" in row 6
Then field "gvon" has value "01.01.2026" in row 7
Then field "gbis" has value "31.12.2035" in row 7
#
And I save the current editor
And I close the current editor
#############################################################################################################################

