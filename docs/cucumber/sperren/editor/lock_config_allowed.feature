# *****************************************************************************
#  Name: lock_config_allowed.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Zulässigkeit des Datensatzes
# *****************************************************************************
@persistent
@LOCK_CONFIGURATION_ALLOWED_TEST
Feature: CRUD 192:1

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

Scenario: ErzeugePrivilegiertTestdaten

Given I enable the flag 298

Given I open an editor "STANDARD" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "nummer" to "1"
And I set field "such" to "STANDARD"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "classname" to "Standard"
And I save the current editor
And I close the current editor

Given I open an editor "INDIVIDUELL" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "INDIVIDUELL"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "classname" to "Individuell"
And I save the current editor
And I close the current editor

Given I open an editor "DUBLETTESTD" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "nummer" to "2"
And I set field "such" to "DUBLETTESTD"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "classname" to "DublStd"
And I save the current editor
And I close the current editor

Given I open an editor "DUBLETTEIND" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "DUBLETTEIND"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "classname" to "DublIndiv"
And I save the current editor
And I close the current editor

Given I open an editor "Aufz�hlung" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "22001"
And I append rows
   | vaufzelem                      | aebez          | aekbez          | aebezeichner   |
   | Sperrkonfiguration STANDARD    | Artikelsperre  | Artikelsperre   | Artikelsperre  |
   | Sperrkonfiguration INDIVIDUELL | Artikelhinweis | Arrtikelhinweis | Artikelhinweis |
And I respond with answer "Ja" to the dialog with id "10951"
And I save the current editor

################################################################################
Scenario: AusnahmeBeimEditierenImLieferumfang
Given I disable the flag 298

Given opening an editor from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "STANDARD" throws the exception "3560"

################################################################################
Scenario: AusnahmeBeimEntfernenImLieferumfang
Given I disable the flag 298

Given opening an editor from table "(LockConfiguration):(LockConfiguration)" with command "DELETE" for record "STANDARD" throws the exception "3560"

################################################################################
Scenario: AusnahmenBeimEntfernenVonAktivenInAZ
Given I disable the flag 298

Given opening an editor from table "(LockConfiguration):(LockConfiguration)" with command "DELETE" for record "INDIVIDUELL" throws the exception "4795"

################################################################################
Scenario: AusnahmeBeimEntfernenVonAktivenInAZImLieferumfang
Given I enable the flag 298

Given opening an editor from table "(LockConfiguration):(LockConfiguration)" with command "DELETE" for record "STANDARD" throws the exception "4795"

################################################################################
Scenario: ErfolgBeimEditierenImLieferumfang
Given I enable the flag 298

Given I open an editor "EDIT_DUBL_STD" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "DUBLETTESTD"
And I set field "sucherw" to "Ich bin doppelt geliefert"
And I save the current editor
And I close the current editor

################################################################################
Scenario: ErfolgBeimEditieren
Given I disable the flag 298

Given I open an editor "EDIT_DUBL_IND" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "DUBLETTEIND"
And I set field "sucherw" to "Ich bin doppelt"
And I save the current editor
And I close the current editor

################################################################################
Scenario: ErfolgBeimEntfernenImLieferumfang
Given I enable the flag 298

Given I open an editor "DELETE_DUBL_STD" from table "(LockConfiguration):(LockConfiguration)" with command "DELETE" for record "DUBLETTESTD"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

################################################################################
Scenario: ErfolgBeimEntfernen
Given I disable the flag 298

Given I open an editor "DELETE_DUBL_IND" from table "(LockConfiguration):(LockConfiguration)" with command "DELETE" for record "DUBLETTEIND"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

################################################################################
