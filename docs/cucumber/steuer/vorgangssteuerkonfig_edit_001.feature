# *****************************************************************************
#  Name             : vorgangssteuerkonfig_edit_001.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Editierbarkeit von Vorgangssteuerkonfiguration mit
#                     den neuen Feldern:
#                     * vsrechnland
#                     * vsbestland
#                     * vsrechnustidland
#                     * vsbestustidland
#
#
#
#
# *****************************************************************************
@persistent
Feature: vorgangssteuerkonfig_edit_001.feature
Background: Editierbarkeit von Vorgangssteuerkonfiguration


Scenario: rechnland und rechnlaart

Given I open an editor "konfig1" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"

And I create a new row at the end of the table
And I set field "ev" to "verkauf" in row !lastRow
And I set field "rechnlaart" to "Inland" in row !lastRow
Then field "rechnland" is modifiable in row !lastRow
# eine Region aus Deutschland
And I set field "rechnland" to "SAARLAND" in row !lastRow

# eine Region aus MEXIKO -> Fehler
# hier muss eigentlich exception "2708" sein
Then setting field "rechnland" to "CHH" in row !lastRow throws the exception "1361"

# wieder eine Region aus Deutschland -> moeglich
And I set field "rechnland" to "BAYERN" in row !lastRow

Then field "rechnlaart" is modifiable in row !lastRow
# rechnland = BAYERN -> Fehler
Then setting field "rechnlaart" to "Ausland" in row !lastRow throws the exception "2708"
And I set field "rechnland" to "" in row !lastRow
And I set field "rechnlaart" to "Ausland" in row !lastRow
# eine Region aus MEXIKO -> moeglich
And I set field "rechnland" to "CHH" in row !lastRow
# MEXIKO selbst -> moeglich
And I set field "rechnland" to "MEXIKO" in row !lastRow
# ein Wirtschaftsraum -> Fehler
# hier muss eigentlich exception "2179" sein
Then setting field "rechnland" to "EUZV" in row !lastRow throws the exception "1361"

And I close the current editor
# =========================================================================================

Scenario: bestland und bestlaart

Given I open an editor "konfig2" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"

And I create a new row at the end of the table
And I set field "ev" to "verkauf" in row !lastRow
And I set field "rechnlaart" to "Inland" in row !lastRow
Then field "rechnland" is modifiable in row !lastRow
# eine Region aus Deutschland
And I set field "rechnland" to "SAARLAND" in row !lastRow

# ---- Ab hier Test ----
#

Then field "bestlaart" is empty in row !lastRow
# eine Region aus MEXIKO -> moeglich
And I set field "bestland" to "CHH" in row !lastRow
Then field "bestlaart" has value "Ausland" in row !lastRow

# eine Region aus Deutschland -> Fehler
# hier muss eigentlich exception "2708" sein
Then setting field "bestland" to "SAARLAND" in row !lastRow throws the exception "1361"

# ein Wirtschaftsraum -> Fehler
# hier muss eigentlich exception "2179" sein
Then setting field "bestland" to "EUZV" in row !lastRow throws the exception "1361"

And I set field "bestland" to "" in row !lastRow
And I set field "bestlaart" to "EU-Staat" in row !lastRow
# eine Region aus EU -> moeglich
And I set field "bestland" to "LOM" in row !lastRow
# ein Land aus EU -> moeglich
And I set field "bestland" to "BELGIEN" in row !lastRow

# ein Wirtschaftsraum -> Fehler
# hier muss eigentlich exception "2179" sein
Then setting field "bestland" to "EUZV" in row !lastRow throws the exception "1361"

And I close the current editor
# =========================================================================================


Scenario: rechnustidland und rechnustid

Given I open an editor "konfig3" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"

And I create a new row at the end of the table
And I set field "ev" to "verkauf" in row !lastRow
And I set field "rechnlaart" to "Inland" in row !lastRow
Then field "rechnland" is modifiable in row !lastRow
# eine Region aus Deutschland
And I set field "rechnland" to "SAARLAND" in row !lastRow
And I set field "bestlaart" to "EU-Staat" in row !lastRow
Then field "bestland" is empty in row !lastRow

# ---- Ab hier Test ----
#

And I set field "rechnustid" to "irrelevant" in row !lastRow
Then field "rechnustidland" is not modifiable in row !lastRow

And I set field "rechnustid" to "leer oder aus Inland" in row !lastRow
Then field "rechnustidland" is not modifiable in row !lastRow

And I set field "rechnustid" to "vorhanden und aus EU-Staat" in row !lastRow
Then field "rechnustidland" is modifiable in row !lastRow

# eine Region aus Deutschland -> Fehler
# hier muss eigentlich exception "2204" sein
Then setting field "rechnustidland" to "SAARLAND" in row !lastRow throws the exception "1361"

# eine Region aus MEXIKO -> Fehler
# hier muss eigentlich exception "2204" sein
Then setting field "rechnustidland" to "CHH" in row !lastRow throws the exception "1361"

# ein Wirtschaftsraum -> Fehler
# hier muss eigentlich exception "2204" sein
Then setting field "rechnustidland" to "EUZV" in row !lastRow throws the exception "1361"

# ein Land nicht aus EU -> Fehler
# hier muss eigentlich exception "2729" sein
Then setting field "rechnustidland" to "USA" in row !lastRow throws the exception "1361"

# ein Land aus EU -> moeglich
And I set field "rechnustidland" to "BELGIEN" in row !lastRow

# eine Region aus EU -> Fehler
# hier muss eigentlich exception "2204" sein
Then setting field "rechnustidland" to "TOS" in row !lastRow throws the exception "1361"

And I close the current editor
# =========================================================================================


Scenario: bestustidland und bestustid

Given I open an editor "konfig4" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"

And I create a new row at the end of the table
And I set field "ev" to "verkauf" in row !lastRow
And I set field "rechnlaart" to "Inland" in row !lastRow
Then field "rechnland" is modifiable in row !lastRow
# eine Region aus Deutschland
And I set field "rechnland" to "SAARLAND" in row !lastRow
And I set field "bestlaart" to "EU-Staat" in row !lastRow
Then field "bestland" is empty in row !lastRow
And I set field "rechnustid" to "irrelevant" in row !lastRow
Then field "rechnustidland" is not modifiable in row !lastRow

# ---- Ab hier Test ----
#

And I set field "bestustid" to "irrelevant" in row !lastRow
Then field "bestustidland" is not modifiable in row !lastRow

And I set field "bestustid" to "leer oder aus Inland" in row !lastRow
Then field "bestustidland" is not modifiable in row !lastRow

And I set field "bestustid" to "vorhanden und aus EU-Staat" in row !lastRow
Then field "bestustidland" is modifiable in row !lastRow

# eine Region aus Deutschland -> Fehler
# hier muss eigentlich exception "2204" sein
Then setting field "bestustidland" to "SAARLAND" in row !lastRow throws the exception "1361"

# eine Region aus MEXIKO -> Fehler
# hier muss eigentlich exception "2204" sein
Then setting field "bestustidland" to "CHH" in row !lastRow throws the exception "1361"

# ein Wirtschaftsraum -> Fehler
# hier muss eigentlich exception "2204" sein
Then setting field "bestustidland" to "EUZV" in row !lastRow throws the exception "1361"

# ein Land nicht aus EU -> Fehler
# hier muss eigentlich exception "2729" sein
Then setting field "bestustidland" to "USA" in row !lastRow throws the exception "1361"

# ein Land aus EU -> moeglich
And I set field "bestustidland" to "BELGIEN" in row !lastRow

# eine Region aus EU -> Fehler
# hier muss eigentlich exception "2204" sein
Then setting field "bestustidland" to "TOS" in row !lastRow throws the exception "1361"


And I set field "vrgstrgl" to "VKINLRC" in row !lastRow
And I save the current editor
And I close the current editor
# =========================================================================================


