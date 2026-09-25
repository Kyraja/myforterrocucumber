# *****************************************************************************
#  Name           : sequence_status_crud.feature
#  Autor          : fwester
#  Verantwortlich : as
#  Funktion       : Testet CRUD-Funktionalitaet fuer 133:2
# *****************************************************************************
@persistent
@FP_TEST
Feature: CRUD 133:2
Background:
Given I set the fake date to "02.01.1995"

Scenario: Create 1st new sequence status
Given I open an editor "sequence_status_new_1" from table "(SequenceDescription):(SequenceStatus)" with command "NEW" for record ""
And I set field "nummer" to "1"
And I set field "such" to "FIRST"
And I set field "namebspr" to "Ich weiss noch nicht!"
And I save the current editor
Then field "name1" has value "Ich weiss noch nicht!"

Scenario: Create 2nd new sequence status
Given I open an editor "sequence_status_new_2" from table "(SequenceDescription):(SequenceStatus)" with command "NEW" for record ""
And I set field "nummer" to "2"
And I set field "such" to "SECOND"
And I set field "namebspr" to "Second step"
And I save the current editor
Then field "name1" has value "Second step"

Scenario: Create 3rd new sequence status while copying record 2
Given I open an editor "sequence_status_copy_1" from table "(SequenceDescription):(SequenceStatus)" with command "COPY" for record "2"
And I set field "nummer" to "3"
And I set field "such" to "THIRD"
And I set field "namebspr" to "Third step"
And I save the current editor
Then field "name1" has value "Third step"

Scenario: Edit number of 3rd sequence status
Given I open an editor "sequence_status_edit_3" from table "(SequenceDescription):(SequenceStatus)" with command "UPDATE" for record "3"
Then setting field "nummer" to "666" throws the exception "551"
And I save the current editor
Then field "nummer" has value "3"
Then field "name1" has value "Third step"

Scenario: View 3rd sequence status
Given I open an editor "sequence_status_view_3" from table "(SequenceDescription):(SequenceStatus)" with command "VIEW" for record "3"
And I save the current editor
Then field "name1" has value "Third step"

Scenario: Edit 1st sequence status
Given I open an editor "sequence_status_edit_1" from table "(SequenceDescription):(SequenceStatus)" with command "UPDATE" for record "1"
And I set field "namebspr" to "First step"
And I save the current editor
Then field "name1" has value "First step"

Scenario: Delete 3rd sequence status
Given I open an editor "sequence_status_del_3" from table "(SequenceDescription):(SequenceStatus)" with command "DELETE" for record "3"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Scenario: Edit filed 3rd sequence status
And opening an editor from table "(SequenceDescription):(SequenceStatus)" with command "UPDATE" for record from editor "sequence_status_del_3" throws the exception "9272"
