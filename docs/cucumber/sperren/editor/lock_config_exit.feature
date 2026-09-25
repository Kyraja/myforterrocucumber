# *****************************************************************************
#  Name: lock_config_exit.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Feldaustritte Sperrkonfiguration
# *****************************************************************************
@persistent
@LOCK_CONFIG_EXIT
Feature: Feldaustritte_Sperrkonfig

background
Given I'm logged in with password "sy"

Scenario: verweissperrstellenEintragen

Given I open an editor "LockConfig" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "hinweisbspr" to "Hinweis"
Then field "hinweis" has value "Hinweis"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "classname" to "Shrotty"
And I create a new row at the end of the table
And I set field "verweissperrstellen" to "MYLOCKREFLIST" in row 1
And I set field "maskenpruefung" to "ja" in row 1
And I set field "verweissperrstellen" to "" in row 1
Then field "maskenpruefung" has value "nein" in row 1
And I close the current editor

Scenario: tabellenvorlageErstellen

Given I enable the flag 46

Given I open an editor "Tabellenvorlage" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "TABLETEMPLATE"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "classname" to "TableTemplate"
And I create a new row at the end of the table
And I set field "verweissperrstellen" to "MYLOCKREFLIST" in row 1
And I set field "maskenpruefung" to "ja" in row 1
And I set field "sperrwirkung" to "Hinweis" in row 1
And I set field "sperrhinweis" to "Kunde" in row 1
And I press button "sperrhinweisueb" in row 1
And I create a new row at the end of the table
And I set field "prozesssperrstelle" to "SBLANKET-SCHEDULE" in row 2
And I set field "sperrwirkung" to "Gesperrt" in row 2
And I set field "sperrhinweis" to "Lieferant" in row 2
And I press button "sperrhinweisueb" in row 2
And I save the current editor
And I close the current editor

Scenario: tabellenvorlageUebernehmenBejahen

Given I enable the flag 46

Given I open an editor "TabellenvorlageUebernehmen" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "TAKEOVER"
And I set field "gesperrtegruppe" to "V-02-01"
# Tabelle/Zeile darf für Rückfrage nicht leer sein
And I create a new row at the end of the table
And I set field "sperrwirkung" to "Gesperrt" in row 1
And I respond with answer "ja" to the dialog with id "10310"
And I set field "tabellenvorlage" to "TABLETEMPLATE"
Then the table has 2 rows
Then field "tabellenvorlage" is empty
Then field "verweissperrstellen" has value "MYLOCKREFLIST" in row 1
Then field "maskenpruefung" has value "ja" in row 1
Then field "sperrwirkung" has value "Hinweis" in row 1
Then field "sperrhinweis1" has value "Kunde" in row 1
Then field "sperrhinweis2" has value "Customer" in row 1
Then field "prozesssperrstelle" has value "SBLANKET-SCHEDULE" in row 2
Then field "maskenpruefung" has value "nein" in row 2
Then field "sperrwirkung" has value "Gesperrt" in row 2
Then field "sperrhinweis1" has value "Lieferant" in row 2
Then field "sperrhinweis2" has value "Supplier" in row 2
And I close the current editor

Scenario: tabellenvorlageTrotzLeerzeileOhneBejahenUebernehmen

Given I open an editor "TabellenvorlageUebernehmen" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "TAKEOVER2"
And I set field "gesperrtegruppe" to "V-02-01"
# Eine Leerzeile wird ignoriert
And I create a new row at the end of the table
And I set field "aktiv" to "nein" in row 1
And I set field "tabellenvorlage" to "TABLETEMPLATE"
Then the table has 2 rows
Then field "tabellenvorlage" is empty
And I close the current editor

Scenario: tabellenvorlageUebernehmenVerneinen

Given I open an editor "TabellenvorlageUebernehmen" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "TAKEOVER3"
And I set field "gesperrtegruppe" to "V-02-01"
# Tabelle/Zeile darf für Rückfrage nicht leer sein
And I create a new row at the end of the table
And I set field "sperrwirkung" to "Gesperrt" in row 1
And I respond with answer "nein" to the dialog with id "10310"
And I set field "tabellenvorlage" to "TABLETEMPLATE"
# Die Leerzeile von oben bleibt stehen.
Then the table has 1 rows
Then field "sperrwirkung" has value "Gesperrt" in row 1
Then field "tabellenvorlage" is empty
And I close the current editor
