# *****************************************************************************
#  Name           : work_task_dms_not_config.feature
#  Autor          : fwester
#  Verantwortlich : fwester
#  Funktion       : Testet Schreibschutze DMS-Felder
# *****************************************************************************
@persistent
@FP_TEST
Feature: CRUD Write protections 149:3
Background:
Given I set the fake date to "02.01.1995"

Scenario: In der Konfiguration dms deaktivieren
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I press button "bsperremand"
And I set field "dms" to "nein"
And I save the current editor
And I close the current editor

Scenario: NEW: Check write protections of dms fields while abas dms is not configured
Given I open an editor "work_task_10" from table "(ProjectSuitePlanning):(WorkTask)" with command "NEW" for record ""
And setting field "doku" to "1" throws the exception "203"
# Always editable
And I press button "dokuz"
And setting field "rueckdoku" to "1" throws the exception "203"
# Always editable
And I press button "rueckdokuz"
And setting field "barcode" to "1" throws the exception "203"
And pressing button "barcodezu" throws the exception "203"
And setting field "dndbetreff" to "1" throws the exception "203"
And pressing button "dragdropzu" throws the exception "203"
And setting field "rueckbarcode" to "1" throws the exception "203"
# Always editable
And I set field "dokumentbaurl" to "1"
# Always editable
And I press button "dokumentbaneulad"
And setting field "dndbelegart" to "1" throws the exception "203"
And I close the current editor

Scenario: CREATE: Create a work task
Given I open an editor "work_task_1" from table "(ProjectSuitePlanning):(WorkTask)" with command "NEW" for record ""
And I set field "nummer" to "1"
And I set field "such" to "TEST"
And I save the current editor

Scenario: VIEW: Check write protections of dms fields while abas dms is not configured
Given I open an editor "work_task_20" from table "(ProjectSuitePlanning):(WorkTask)" with command "VIEW" for record "1"
And setting field "doku" to "1" throws the exception "551"
# Always editable
And I press button "dokuz"
And setting field "rueckdoku" to "1" throws the exception "551"
# Always editable
And I press button "rueckdokuz"
And setting field "barcode" to "1" throws the exception "203"
And pressing button "barcodezu" throws the exception "203"
And setting field "dndbetreff" to "1" throws the exception "203"
And pressing button "dragdropzu" throws the exception "203"
And setting field "rueckbarcode" to "1" throws the exception "551"
# Always editable
And I set field "dokumentbaurl" to "1"
# Always editable
And I press button "dokumentbaneulad"
And setting field "dndbelegart" to "1" throws the exception "203"
And I close the current editor

Scenario: EDIT: Check write protections of dms fields while abas dms is not configured
Given I open an editor "work_task_30" from table "(ProjectSuitePlanning):(WorkTask)" with command "UPDATE" for record "1"
And setting field "doku" to "1" throws the exception "203"
# Always editable
And I press button "dokuz"
And setting field "rueckdoku" to "1" throws the exception "203"
# Always editable
And I press button "rueckdokuz"
And setting field "barcode" to "1" throws the exception "203"
And pressing button "barcodezu" throws the exception "203"
And setting field "dndbetreff" to "1" throws the exception "203"
And pressing button "dragdropzu" throws the exception "203"
And setting field "rueckbarcode" to "1" throws the exception "203"
# Always editable
And I set field "dokumentbaurl" to "1"
# Always editable
And I press button "dokumentbaneulad"
And setting field "dndbelegart" to "1" throws the exception "203"
And I close the current editor

Scenario: Delete Work task
Given I open an editor "work_task_1" from table "(ProjectSuitePlanning):(WorkTask)" with command "DELETE" for record "1"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
