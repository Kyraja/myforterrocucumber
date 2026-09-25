@persistent
Feature: rechenregeln
Background:
Given I set the fake date to "04.01.2002"


Scenario: 01
Given I set the fake date to "04.01.2002"

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "50000"
And I set field "nummer" to "50010"
Then field "zkoart" has value "50000" in row 1
And I save the current editor

# -------------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------------
Given I open an editor "buchung_1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bu1"
And I create a new row at the end of the table
And I set field "konto" to "10000" in row !lastRow
And I create a new row at the end of the table
And I set field "konto" to "50000" in row !lastRow
And I set field "ewsbetr" to "10" in row !lastRow
And I set field "kstelle" to "101" in row !lastRow
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor

Given I open an editor "buchung_2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bu2"
And I create a new row at the end of the table
And I set field "konto" to "10000" in row !lastRow
And I create a new row at the end of the table
And I set field "konto" to "50010" in row !lastRow
And I set field "ewsbetr" to "4" in row !lastRow
And I set field "kstelle" to "101" in row !lastRow
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor

Given I open an editor "buchung_3" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bu3"
And I create a new row at the end of the table
And I set field "konto" to "13010" in row !lastRow
And I create a new row at the end of the table
And I set field "konto" to "44000" in row !lastRow
And I set field "ewsbetr" to "3" in row !lastRow
And I set field "kstelle" to "101" in row !lastRow
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor

Given I open an editor "rere1" from table "(CostType):(ComputationRule)" with command "NEW" for record ""
And I set field "such" to "rere1"
And I set field "optyp" to "summierung"
And I create a new row at the end of the table
And I set field "koart" to "50000" in row !lastRow
And I save the current editor

Given I open an editor "rere1" from table "(CostType):(ComputationRule)" with command "UPDATE" for record from editor "rere1"
And I create a new row at the end of the table
And I set field "koart" to "rere1" in row !lastRow
And I save the current editor


Given I open an editor "rere2" from table "(CostType):(ComputationRule)" with command "NEW" for record ""
And I set field "such" to "rere2"
And I set field "optyp" to "summierung"
And I create a new row at the end of the table
And I set field "koart" to "rere1" in row !lastRow
And I save the current editor

Given I open an editor "rere1" from table "(CostType):(ComputationRule)" with command "UPDATE" for record from editor "rere1"
And I create a new row at the end of the table
And I set field "koart" to "rere2" in row !lastRow
And I save the current editor

Given I open an editor "rere3" from table "(CostType):(ComputationRule)" with command "NEW" for record ""
And I set field "such" to "rere3"
And I set field "optyp" to "summierung"
And I create a new row at the end of the table
And I set field "koart" to "rere1" in row !lastRow
And I save the current editor

Given I open an editor "rere4" from table "(CostType):(ComputationRule)" with command "NEW" for record ""
And I set field "such" to "rere4"
And I set field "optyp" to "summierung"
And I create a new row at the end of the table
And I set field "koart" to "rere2" in row !lastRow
And I create a new row at the end of the table
And I set field "koart" to "44000" in row !lastRow
And I save the current editor

Given I open an editor "rere3upd" from table "(CostType):(ComputationRule)" with command "UPDATE" for record from editor "rere3"
And I set field "koart" to "rere4" in row 1
And I save the current editor

Given I open an editor "rere2upd" from table "(CostType):(ComputationRule)" with command "UPDATE" for record from editor "rere2"
And I create a new row at the end of the table
And I set field "koart" to "rere3" in row !lastRow
And I save the current editor


Given I open an editor "rere1werte" from table "(CostType):(ComputationRule)" with command "VIEW" for record "RERE1"
And I set field "koobj" to "101"
Then I fill template "ko_rechenregel1.ftl" and append it to output file "rere_template_out.ref"
And I close the current editor

Given I open an editor "rere2werte" from table "(CostType):(ComputationRule)" with command "VIEW" for record "RERE2"
And I set field "koobj" to "101"
Then I fill template "ko_rechenregel1.ftl" and append it to output file "rere_template_out.ref"
And I close the current editor

Given I open an editor "rere3werte" from table "(CostType):(ComputationRule)" with command "VIEW" for record "RERE3"
And I set field "koobj" to "101"
Then I fill template "ko_rechenregel1.ftl" and append it to output file "rere_template_out.ref"
And I close the current editor

Given I open an editor "rere4werte" from table "(CostType):(ComputationRule)" with command "VIEW" for record "RERE4"
And I set field "koobj" to "101"
Then I fill template "ko_rechenregel1.ftl" and append it to output file "rere_template_out.ref"
And I close the current editor


Given I open an editor "bab1" from table "(EDS):(EDS)" with command "NEW" for record ""
And I set field "such" to "bab1"
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I set field "koobj" to "101"
And I create a new row at the end of the table
And I set field "koart" to "rere1" in row !lastRow
And I create a new row at the end of the table
And I set field "koart" to "rere2" in row !lastRow
And I create a new row at the end of the table
And I set field "koart" to "rere3" in row !lastRow
And I create a new row at the end of the table
And I set field "koart" to "rere4" in row !lastRow
# 2614 de      |Zyklus in Rechenregel. Trotzdem speichern?
And I respond with answer "Ja" to the dialog with id "2614"
And I save the current editor
