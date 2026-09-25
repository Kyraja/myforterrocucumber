# *****************************************************************************
#  Name           : sequence_description_crud.feature
#  Autor          : fwester
#  Verantwortlich : as
#  Funktion       : Testet CRUD-Funktionalitaet fuer 133:1
# *****************************************************************************
@persistent
@FP_TEST
Feature: CRUD 133:1
Background:
Given I set the fake date to "02.01.1995"

Scenario: Create 1st new sequence description
Given I open an editor "sequence_desc_new_10" from table "(SequenceDescription):(SequenceDescription)" with command "NEW" for record ""
And I set field "nummer" to "10"
And I set field "such" to "DESC1"
And I set field "namebspr" to "Ich weiss noch nicht!"
And I save the current editor
Then field "name1" has value "Ich weiss noch nicht!"

Scenario: Create 2nd new sequence description
Given I open an editor "sequence_desc_new_20" from table "(SequenceDescription):(SequenceDescription)" with command "NEW" for record ""
And I set field "nummer" to "20"
And I set field "such" to "DESC2"
And I set field "namebspr" to "Second description"
And I save the current editor
Then field "name1" has value "Second description"

Scenario: Edit 1st sequence desription
Given I open an editor "sequence_desc_edit_10" from table "(SequenceDescription):(SequenceDescription)" with command "UPDATE" for record "10"
And I set field "namebspr" to "First description"
And I save the current editor
Then field "name1" has value "First description"

Scenario: Edit table 1st sequence desription
Given I open an editor "sequence_desc_edit_table_10" from table "(SequenceDescription):(SequenceDescription)" with command "UPDATE" for record "10"
Then I create a new row at the end of the table
And I set field "ablaufzust" to "1" in row 1
Then I create a new row at the end of the table
And I set field "ablaufzust" to "2" in row 2
And I save the current editor
Then field "ablaufzustbez" has value "First step" in row 1
Then field "ablaufzustbez" has value "Second step" in row 2

Scenario: Create 3rd new sequence description while copying record 10
Given I open an editor "sequence_desc_copy_10" from table "(SequenceDescription):(SequenceDescription)" with command "COPY" for record "10"
And I set field "nummer" to "30"
And I set field "such" to "DESC3"
And I set field "namebspr" to "Third description"
And I save the current editor
Then field "name1" has value "Third description"

Scenario: Edit number of 3rd sequence description
Given I open an editor "sequence_desc_edit_30" from table "(SequenceDescription):(SequenceDescription)" with command "UPDATE" for record "30"
Then setting field "nummer" to "666" throws the exception "551"
And I save the current editor
Then field "nummer" has value "30"
Then field "name1" has value "Third description"

Scenario: View 3rd sequence description
Given I open an editor "sequence_desc_view_30" from table "(SequenceDescription):(SequenceDescription)" with command "VIEW" for record "30"
And I save the current editor
Then field "name1" has value "Third description"

Scenario: Delete 3rd sequence description
Given I open an editor "sequence_desc_del_30" from table "(SequenceDescription):(SequenceDescription)" with command "DELETE" for record "30"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Scenario: Edit filed 3rd sequence description
And opening an editor from table "(SequenceDescription):(SequenceDescription)" with command "UPDATE" for record from editor "sequence_desc_del_30" throws the exception "9272"
