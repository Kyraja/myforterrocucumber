@persistent
@FP_TEST
Feature: Aufrufparameter testen

Scenario: Aufrufparameter - Editor Zeilen testen

Given I open an editor "Aufrufparameter" from table "(DataExport):(CallParameter)" with command "NEW" for record ""
And I set field "such" to "aptest1"
And I set field "name" to "Testaufrufparameter 1"
Then saving the current editor throws the exception "10179"
And pressing button "ladeparam" throws the exception "1864"
And I set field "zielobj" to "v-02-01"
And I set field "aufrktxt" to "v-02-01"
And pressing button "ladeparam" throws the exception "1864"
And I set field "zielobj" to "i test1"
And I press button "ladeparam"
And I set field "zielvar" to "select" in row 1
And setting field "zielaktion" to "(84)" in row 1 throws the exception "6275"
And I set field "aufrwtyp" to "kopffeld" in row 1
Then saving the current editor throws the exception "279"
And I set field "aufrwert" to "id" in row 1
And I create a new row at the end of the table
And I set field "zielvar" to "select" in row 2
And setting field "aufrbedtyp" to "tabellenfeld" throws the exception "6276"
And setting field "aufrwtyp" to "tabellenfeld" in row 2 throws the exception "6276"
And I set field "aufrtab" to "true"
And I set field "aufrwtyp" to "tabellenfeld" in row 2
And I set field "aufrwert" to "elem^id" in row 2
And I create a new row at the end of the table
And setting field "zielvar" to "tbaumtext" in row 3 throws the exception "1361"
And I set field "zieltab" to "true"
And I set field "zielaktion" to "tab" in row 3
And I set field "zielvar" to "budruck2" in row 3
And I set field "zielwerttyp" to "(CurrentLine)" in row 3
And I set field "aufrwtyp" to "konstante" in row 3
And I set field "aufrwert" to "1" in row 3
And I create a new row at the end of the table
And setting field "zielvar" to "bstart" in row 4 throws the exception "1361"
And I set field "zielvar" to "buinfosys" in row 4
And I set field "aufrwtyp" to "konstante" in row 4
And setting field "arb" to "gibtsnicht" throws the exception "1361"
And I set field "arb" to "is"
And I close the current editor

Given I open an editor "Aufrufparameter" from table "(DataExport):(CallParameter)" with command "NEW" for record ""
And I set field "name" to "Testaufrufparameter 2"
And I set field "zielobj" to "i test1"
And I set field "aufrktxt" to "i lku"
Then field "kontexttyp" has value "Einzelnes Infosystem"
And I set field "aufrktxt" to "v-00-01"
And I set field "kontexttyp" to "Alle Infosysteme"
Then field "aufrktxt" is empty
And I set field "aufrktxt" to "i lku"
And I set field "kontexttyp" to "Alle Variablentabellen"
Then field "aufrktxt" is empty
And I set field "aufrktxt" to "v-00-01"
Then field "kontexttyp" has value "Einzelne Variablentabelle"
And I create a new row at the end of the table
And I set field "zielvar" to "select" in row 1
And I set field "aufrwtyp" to "kopffeld" in row 1
And setting field "aufrwert" to "xxxx" in row 1 throws the exception "1361"
And setting field "aufrwert" to "techniker^xxxx" in row 1 throws the exception "1361"
And I set field "aufrwert" to "techniker^id" in row 1
And I set field "aufrwert" to "id" in row 1
And I create a new row at the end of the table
And I set field "zielvar" to "select" in row 2
And setting field "zielwerttyp" to "kopffeld" in row 2 throws the exception "551"
And I set field "aufrwert" to "yas" in row 2
And I delete row at position 2
And I press button "pruefezeilen"
And I save the current editor
And I close the current editor

Given I open an editor "Aufrufparameter" from table "(DataExport):(CallParameter)" with command "COPY" for record "test1"
And I set field "such" to "aptest3"
And I set field "name" to "Testaufrufparameter 3"
And I set field "zielobj" to ""
And I set field "zielobj" to "i test1"
And I set field "aufrktxt" to "v-00-02"
And I save the current editor

Scenario: Aufrufparameter - aufrbedtyp und aufrbed zusammen ausfuellen

Given I open an editor "Aufrufparameter" from table "(DataExport):(CallParameter)" with command "NEW" for record ""
And I set field "zielobj" to "i test1"
And I set field "aufrktxt" to "v-02-01"
And I set field "aufrbedtyp" to "formel"
Then saving the current editor throws the exception "6892"
And I set field "aufrbed" to "true"
And I save the current editor

Scenario: Aufrufparameter - gueltige Varnamen in aufrbed

Given I open an editor "Aufrufparameter" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "test1"
And I set field "aufrbedtyp" to "kopffeld"
And setting field "aufrbed" to "gibtsnicht" throws the exception "1361"
And I set field "aufrbed" to "lgruppe"
And setting field "aufrbed" to "gibtsnicht^auchnicht" throws the exception "1361"
And I set field "aufrbed" to "lgruppe^such"
And setting field "aufrbed" to "lgruppe^gibtsnicht" throws the exception "1361"
And I set field "aufrtab" to "1"
And setting field "aufrbed" to "gibtsnicht" throws the exception "1361"
And I set field "aufrbedtyp" to "tabellenfeld"
And I set field "aufrbed" to "elem"
And setting field "aufrbed" to "gibtsnicht^auchnicht" throws the exception "1361"
And I set field "aufrbed" to "elem^such"
And setting field "aufrbed" to "elem^gibtsnicht" throws the exception "1361"
And I set field "aufrbedtyp" to "druck"
And I set field "aufrbed" to "drucker"
And I set field "aufrbed" to "such"
And setting field "aufrbed" to "gibtsnicht" throws the exception "1361"
And I set field "aufrbedtyp" to "formel"
And I set field "aufrbed" to "blabla"
And I save the current editor

Scenario: Aufrufparameter - Feldsperren im Standard-Aufrufparameter

Given I open an editor "Aufrufparameter" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "59007"
Then field "aufrbed" is not modifiable
Then field "aufrktxt" is not modifiable
Then field "aufrbed" is not modifiable
Then field "aufrbedtyp" is not modifiable
Then field "zielobj" is not modifiable
And setting field "zielvar" to "xxxx" in row 1 throws the exception "551"
And setting field "zielaktion" to "xxxx" in row 1 throws the exception "551"
And setting field "zielwerttyp" to "xxxx" in row 1 throws the exception "551"
And setting field "aufrwert" to "xxxx" in row 1 throws the exception "551"
And setting field "aufrwtyp" to "xxxx" in row 1 throws the exception "551"
And creating a new row at position !lastRow throws the exception "294"
And deleting the row at position 2 throws the exception "295"
And I save the current editor

Scenario: Aufrufparameter - Exceptions check

Given I open an editor "Aufrufparameter" from table "(DataExport):(CallParameter)" with command "NEW" for record ""
And I set field "aufrktxt" to "V V-00-01"
And I set field "zielobj" to "V V-00-01"
And I create a new row at the end of the table
And setting field "zielvar" to "xxxx" in row 1 throws the exception "2821"
