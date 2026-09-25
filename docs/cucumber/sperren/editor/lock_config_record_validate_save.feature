# *****************************************************************************
#  Name: lock_config_record_validate_save.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet den Editor der Sperrkonfiguration beim Speichern
#            Genauer das Ereignis record_validate_save
# *****************************************************************************
@persistent
@LOCK_CONFIGURATION_RECORD_VALIDATE_TEST
Feature: CRUD 192:1

Given I'm logged in with password "sy"

Scenario: Testdaten_anlegen_Verweissperrstellen

Given I open an editor "LR_DOUBLE" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "LR_DOUBLE"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
   | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname |
   | V-03-24             | ja                   | artikel         |
And I save the current editor
And I close the current editor

Scenario: Testdaten_anlegen_Prozesssperrstelle

Given I enable the flag 298

Given I open an editor "LPS_DOUBLE" from table "(LockConfiguration):(LockableProcessStep)" with command "NEW" for record ""
And I set field "such" to "LPS_DOUBLE"
And I set field "gesperrtegruppe" to "V-02-04"
And I set field "prozessstelle" to "Auftragsposition einplanen"
And I save the current editor
And I close the current editor

Scenario: Keine_doppelten_Verweissperrstellen in der Tabelle

Given I disable the flag 298

Given I open an editor "LC_DOUBLE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LC_DOUBLE"
And I set field "classname" to "LcDouble"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
   | verweissperrstellen | sperrwirkung |
   | LR_DOUBLE           | gesperrt     |
   | LR_DOUBLE           | hinweis     |
And saving the current editor throws the exception "5114"
And I close the current editor

Scenario: Keine_doppelten_Prozesssperrstellen_in_der_Tabelle

Given I open an editor "LC_DOUBLE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LC_DOUBLE"
And I set field "classname" to "LpsDouble"
And I set field "gesperrtegruppe" to "V-02-04"
And I append rows
   | prozesssperrstelle | sperrwirkung |
   | LPS_DOUBLE         | gesperrt     |
   | LPS_DOUBLE         | hinweis      |
And saving the current editor throws the exception "5114"
And I close the current editor

Scenario: Doppelte_Prozesssperrstelle_falls_nur_eine_aktiv

Given I open an editor "LC_DOUBLE_ACTIVE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LC_DOUBLE_ACTIVE"
And I set field "classname" to "LpsDouble"
And I set field "gesperrtegruppe" to "V-02-04"
And I append rows
   | aktiv | prozesssperrstelle | sperrwirkung |
   |  ja     | LPS_DOUBLE       | gesperrt         |
   | nein    | LPS_DOUBLE       | gesperrt         |
And I save the current editor
And I close the current editor

Scenario: Leere_Zeilen_ignorieren

Given I open an editor "LC_LEER" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LC_LEER"
And I set field "classname" to "LpsLeer"
And I set field "gesperrtegruppe" to "V-02-04"
And I append rows
|   aktiv   | prozesssperrstelle | sperrwirkung |
|   nein    |                    |              |
|   ja      | LPS_DOUBLE         | gesperrt     |
|   nein    |                    |              |
And I save the current editor
And I close the current editor
