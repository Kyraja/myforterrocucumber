# *****************************************************************************
#  Name             : anbu_indexreihe_datum.feature
#  Autor            : jeffler
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Hier werden die Plausis bezueglich der Datumsfelder
#                     von Indexreihen geprueft.
#
# *****************************************************************************

@persistent

Feature: ref_anl_indexreihe_edit_cu
Background: Indexreihen

Scenario: GJ-Tabelle pruefen

Given I open an editor "gj" from table "(Company):(FinancialDates)" with command "VIEW" for record "2"
Then the table has 6 rows
Then field "gjahr" has value "98" in row 1
Then field "gjahr" has value "03" in row 6
And I close the current editor

Scenario: Indexreihe anlegen

Given I open an editor "idx-neu" from table "(FixedAsset):(IndexSeries)" with command "NEW" for record ""
And I set field "nummer" to "1idxdat"
And I set field "such" to "datidx1"
And I set field "basisgj" to "2000"
And I create a new row at the end of the table
Then setting field "startdat" to "12.05.2000" in row 1 throws the exception "4485"
Then setting field "startdat" to "31.05.2000" in row 1 throws the exception "4485"
Then setting field "startdat" to "31.02.2000" in row 1 throws the exception "106"
And I set field "startdat" to "01.05.2000" in row 1
Then setting field "startdat" to "20.09.2000" in row 1 throws the exception "4485"
Then setting field "enddat" to "01.11.2000" in row 1 throws the exception "4486"
Then setting field "enddat" to "12.11.2000" in row 1 throws the exception "4486"
And I set field "enddat" to "31.12.2000" in row 1
And I set field "enddat" to "30.09.2000" in row 1
Then setting field "enddat" to "20.09.2000" in row 1 throws the exception "4486"
Then setting field "startdat" to "12.05.2000" in row 1 throws the exception "4485"
Then setting field "startdat" to "31.05.2000" in row 1 throws the exception "4485"
Then setting field "startdat" to "31.02.2000" in row 1 throws the exception "106"
And I set field "enddat" to "" in row 1
And I set field "startdat" to "01.05.2000" in row 1
Then setting field "startdat" to "20.09.2000" in row 1 throws the exception "4485"
Then setting field "enddat" to "20.09.2000" in row 1 throws the exception "4486"
Then setting field "enddat" to "01.12.2000" in row 1 throws the exception "4486"
Then setting field "enddat" to "12.12.2000" in row 1 throws the exception "4486"
And I set field "enddat" to "31.12.2000" in row 1
And I set field "enddat" to "30.11.2000" in row 1
And I save the current editor
And I close the current editor

# basisgj ausserhalb der GJ-Tabelle

Given I open an editor "idx-neu2" from table "(FixedAsset):(IndexSeries)" with command "NEW" for record ""
And I set field "nummer" to "2idxdat"
And I set field "such" to "datidx2"
# GJ vor Tabelle
And I set field "basisgj" to "1981"
And I create a new row at the end of the table
Then setting field "startdat" to "12.05.81" in row 1 throws the exception "4485"
Then setting field "enddat" to "12.05.81" in row 1 throws the exception "4486"
#
And I set field "startdat" to "01.01.83" in row 1
And I set field "enddat" to "31.12.83" in row 1
Then saving the current editor throws the exception "4487"
#
And I set field "startdat" to "01.01.81" in row 1
And I set field "enddat" to "31.12.81" in row 1
And I save the current editor
And I close the current editor

# GJ nach Tabelle
Given I open an editor "idx-neu3" from table "(FixedAsset):(IndexSeries)" with command "NEW" for record ""
And I set field "nummer" to "3idxdat"
And I set field "such" to "datidx3"
And I set field "basisgj" to "2050"
And I create a new row at the end of the table
Then setting field "startdat" to "12.05.2050" in row 1 throws the exception "4485"
Then setting field "enddat" to "12.05.2050" in row 1 throws the exception "4486"
#
And I set field "startdat" to "01.01.2048" in row 1
And I set field "enddat" to "31.12.2048" in row 1
Then saving the current editor throws the exception "4487"
#
And I set field "enddat" to "31.12.2050" in row 1
And I set field "startdat" to "01.01.2050" in row 1
And I save the current editor
And I close the current editor

Scenario: Indexreihe aendern

Given I open an editor "idx-edit" from table "(FixedAsset):(IndexSeries)" with command "UPDATE" for record "1idxdat"
Then setting field "enddat" to "01.10.2000" in row 1 throws the exception "4486"
Then setting field "enddat" to "12.10.2000" in row 1 throws the exception "4486"
Then setting field "enddat" to "31.09.2000" in row 1 throws the exception "106"
And I set field "enddat" to "31.10.2000" in row 1
Then setting field "enddat" to "20.10.2000" in row 1 throws the exception "4486"
Then setting field "startdat" to "12.05.2000" in row 1 throws the exception "4485"
Then setting field "startdat" to "31.05.2000" in row 1 throws the exception "4485"
Then setting field "startdat" to "31.02.2000" in row 1 throws the exception "106"
And I set field "startdat" to "01.05.2000" in row 1
And I set field "enddat" to "" in row 1
Then setting field "startdat" to "20.05.2000" in row 1 throws the exception "4485"
Then setting field "enddat" to "20.09.2000" in row 1 throws the exception "4486"
Then setting field "enddat" to "01.11.2000" in row 1 throws the exception "4486"
Then setting field "enddat" to "12.11.2000" in row 1 throws the exception "4486"
Then setting field "enddat" to "31.02.2000" in row 1 throws the exception "106"
And I set field "enddat" to "31.05.2000" in row 1
And I save the current editor
And I close the current editor

# basisgj ausserhalb der GJ-Tabelle

Given I open an editor "idx-edit2" from table "(FixedAsset):(IndexSeries)" with command "UPDATE" for record "2idxdat"
# GJ vor Tabelle
Then field "basisgj" has value "1981"
Then setting field "startdat" to "12.05.81" in row 1 throws the exception "4485"
Then setting field "enddat" to "12.05.81" in row 1 throws the exception "4486"
#
And I set field "enddat" to "31.12.83" in row 1
And I set field "startdat" to "01.01.83" in row 1
Then saving the current editor throws the exception "4487"
#
And I set field "startdat" to "01.01.81" in row 1
And I set field "enddat" to "31.12.81" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "idx-edit3" from table "(FixedAsset):(IndexSeries)" with command "UPDATE" for record "3idxdat"
# GJ nach Tabelle
Then field "basisgj" has value "2050"
Then setting field "startdat" to "12.05.2050" in row 1 throws the exception "4485"
Then setting field "enddat" to "12.05.2050" in row 1 throws the exception "4486"
#
And I set field "startdat" to "01.01.2048" in row 1
And I set field "enddat" to "31.12.2048" in row 1
Then saving the current editor throws the exception "4487"
#
And I set field "enddat" to "31.12.50" in row 1
And I set field "startdat" to "01.01.50" in row 1
#
And I save the current editor
And I close the current editor
