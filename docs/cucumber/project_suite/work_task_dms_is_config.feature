# *****************************************************************************
#  Name           : work_task_dms_is_config.feature
#  Autor          : fwester
#  Verantwortlich : fwester
#  Funktion       : Testet Schreibschutze DMS-Felder
# *****************************************************************************
@persistent
@FP_TEST
Feature: CRUD Write protections 149:3
Background:
Given I set the fake date to "02.01.1995"

Scenario: NEW: Check write protections of dms fields while abas dms is configured
Given I open an editor "work_task_10" from table "(ProjectSuitePlanning):(WorkTask)" with command "NEW" for record ""
# Always not editable
And setting field "doku" to "1" throws the exception "203"
# Always editable
And I press button "dokuz"
# Always not editable
And setting field "rueckdoku" to "1" throws the exception "203"
# Always editable
And I press button "rueckdokuz"
# Editable but illegal input
And setting field "barcode" to "1" throws the exception "1361"
# Not editable if NEW
And pressing button "barcodezu" throws the exception "9804"
And I set field "dndbetreff" to "1"
# Not editable if NEW
And pressing button "dragdropzu" throws the exception "10840"
# Always not editable
And setting field "rueckbarcode" to "1" throws the exception "203"
# Always editable
And I set field "dokumentbaurl" to "1"
# Always editable
And I press button "dokumentbaneulad"
# Editable but input not found
And setting field "dndbelegart" to "1" throws the exception "149"
And I close the current editor

Scenario: CREATE: Create a work task
Given I open an editor "work_task_1" from table "(ProjectSuitePlanning):(WorkTask)" with command "NEW" for record ""
And I set field "nummer" to "1"
And I set field "such" to "TEST"
And I save the current editor

Scenario: VIEW: Check write protections of dms fields while abas dms is configured
Given I open an editor "work_task_20" from table "(ProjectSuitePlanning):(WorkTask)" with command "VIEW" for record "1"
# Always not editable
And setting field "doku" to "1" throws the exception "551"
# Always editable
And I press button "dokuz"
# Always not editable
And setting field "rueckdoku" to "1" throws the exception "551"
# Always editable
And I press button "rueckdokuz"
# Editable but illegal input
And setting field "barcode" to "1" throws the exception "1361"
# Editable in VIEW mode, if field barcode is not empty
Then pressing button "barcodezu" in row 0 throws the exception "551"
And I set field "barcode" to "1111114x"
And I press button "barcodezu"
And I set field "dndbetreff" to "1"
# Editable in VIEW mode, if field dateiarchivieren is not empty
Then pressing button "dragdropzu" in row 0 throws the exception "551"
And I set field "dateiarchivieren" to "DND"
And I press button "dragdropzu"
# Always not editable
And setting field "rueckbarcode" to "1" throws the exception "551"
# Always editable
And I set field "dokumentbaurl" to "1"
# Always editable
And I press button "dokumentbaneulad"
# Editable but input not found
And setting field "dndbelegart" to "1" throws the exception "149"
And I close the current editor

Scenario: EDIT: Check write protections of dms fields while abas dms is configured
Given I open an editor "work_task_30" from table "(ProjectSuitePlanning):(WorkTask)" with command "UPDATE" for record "1"
# Always not editable
And setting field "doku" to "1" throws the exception "551"
# Always editable
And I press button "dokuz"
# Always not editable
And setting field "rueckdoku" to "1" throws the exception "551"
# Always editable
And I press button "rueckdokuz"
# Editable but illegal input
And setting field "barcode" to "1" throws the exception "1361"
# Editable in VIEW mode, if field barcode is not empty
Then pressing button "barcodezu" in row 0 throws the exception "551"
And I set field "barcode" to "1111115x"
And I press button "barcodezu"
And I set field "dndbetreff" to "1"
# Editable in VIEW mode, if field dateiarchivieren is not empty
Then pressing button "dragdropzu" in row 0 throws the exception "551"
And I set field "dateiarchivieren" to "DND"
And I press button "dragdropzu"
# Always not editable
And setting field "rueckbarcode" to "1" throws the exception "551"
# Always editable
And I set field "dokumentbaurl" to "1"
# Always editable
And I press button "dokumentbaneulad"
# Editable but input not found
And setting field "dndbelegart" to "1" throws the exception "149"
And I close the current editor

Scenario: Delete Work task
Given I open an editor "work_task_1" from table "(ProjectSuitePlanning):(WorkTask)" with command "DELETE" for record "1"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
###############################################################################
Scenario: Create a work task and archiv while saving
Given I open an editor "create_and_archiv_while_saving" from table "(ProjectSuitePlanning):(WorkTask)" with command "NEW" for record ""
And I set field "such" to "ZWEI"
And I set field "barcode" to "1111111x"
And I set field "dndbelegart" to "Arbeitsaufgabe"
And I save the current editor
Then field "doku^bezobj^such" has value "ZWEI"

Scenario: Edit a work task and archiv while assigning
Given I open an editor "edit_and_archiv_while_assigning" from table "(ProjectSuitePlanning):(WorkTask)" with command "UPDATE" for record "ZWEI"
And I set field "barcode" to "1111112x"
And I press button "barcodezu"
And I save the current editor
Then field "doku^bezobj^such" has value "ZWEI"

Scenario: View a work task and archiv while assigning
Given I open an editor "view_and_archiv_while_assigning" from table "(ProjectSuitePlanning):(WorkTask)" with command "VIEW" for record "ZWEI"
And I set field "barcode" to "1111113x"
And I press button "barcodezu"
And I save the current editor
Then field "doku^bezobj^such" has value "ZWEI"

Scenario: View a work task and archiv dnd file while assigning
Given I open an editor "view_and_archiv_dnd_while_assigning" from table "(ProjectSuitePlanning):(WorkTask)" with command "VIEW" for record "ZWEI"
And I set field "barcode" to "2222221x"
And I set field "dndbetreff" to "DnD-Betreff View"
And I set field "dateiarchivieren" to "DND"
And I press button "dragdropzu"
And I save the current editor
Then field "doku^bezobj^such" has value "ZWEI"

Scenario: Edit a work task and archiv dnd file while assigning
Given I open an editor "edit_and_archiv_dnd_while_assigning" from table "(ProjectSuitePlanning):(WorkTask)" with command "UPDATE" for record "ZWEI"
And I set field "barcode" to "2222222x"
And I set field "dndbetreff" to "DnD-Betreff Edit"
And I set field "dateiarchivieren" to "DND"
And I press button "dragdropzu"
And I save the current editor
Then field "doku^bezobj^such" has value "ZWEI"

Scenario: Create new work task while copying record 2
Given I open an editor "copying_work_task_and_archiv_while_saving" from table "(ProjectSuitePlanning):(WorkTask)" with command "COPY" for record "ZWEI"
And I set field "nummer" to "3"
And I set field "such" to "DREI"
And I set field "barcode" to "3333333x"
And I save the current editor
Then field "doku^bezobj^such" has value "DREI"
###############################################################################
Scenario: Edit a work task and archiv while reassigning answered No
Given I open an editor "edit_and_archiv_while_assigning" from table "(ProjectSuitePlanning):(WorkTask)" with command "UPDATE" for record "ZWEI"
And I set field "barcode" to "1111112x"
And I respond with answer "Nein" to the dialog with id "10235"
And I press button "barcodezu"
And I save the current editor
Then field "doku^bezobj^such" has value "ZWEI"

Scenario: Edit a work task and archiv while reassigning answered Yes
Given I open an editor "edit_and_archiv_while_assigning" from table "(ProjectSuitePlanning):(WorkTask)" with command "UPDATE" for record "ZWEI"
And I set field "barcode" to "1111112x"
And I respond with answer "Ja" to the dialog with id "10235"
And I press button "barcodezu"
And I save the current editor
Then field "doku^bezobj^such" has value "ZWEI"
