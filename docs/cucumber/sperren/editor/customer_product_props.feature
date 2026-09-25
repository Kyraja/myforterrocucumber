# *****************************************************************************
#  Name: customer_product_props.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet Artikelsperre im Kopffeld artikel der Kunden-Artikel-
#  Eigenschaften. Das ist kein Plattenfeld.
# *****************************************************************************
@persistent
Feature: Verweissperrstelle_in_Kunden_Artikel_Eigenschaften

Scenario: Verweissperrstellen_erstellen

Given I'm logged in with password "sy"

Given I open an editor "LR_CREATE" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "KU_ART_PROPS"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
   | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname |
   | V-02-07             | nein                 |                 |
And I respond with answer "1" to the dialog with id "Variablenauswahl"
And I press button "verweisfeldauswahl" in row 1
Then field "verweisfeldname" has value "artikel" in row 1
And I save the current editor
And I close the current editor


Scenario: Verweissperrstellen_konfigurieren

Given I'm logged in with password "sy"

# Datensatz ART_LOCK aus lock_config_base.feature erweitern
Given I open an editor "LC_UPDATE" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "ART_LOCK"
And I delete all rows
And I append rows
   | verweissperrstellen | sperrwirkung |
   | KU_ART_PROPS        | gesperrt     |
And I save the current editor
And I close the current editor


Scenario: Artikel_sperren

Given I'm logged in with password "sy"

Given I open an editor "PROD_UPDATE" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "sperrkonfigurationneu" to "Artikelvollsperre"
And I set field "sperrgrundneu" to "Nicht möglich - Artikel futsch"
And I save the current editor
And I close the current editor


Scenario: Verweissperrstelle_testen

Given I'm logged in with password "adm"

Given I open an editor "KUART_CREATE" from table "(Part):(CustomerProductProperties)" with command "NEW" for record ""
Then setting field "artikel" to "V1" in row 0 throws the exception "4806"
And I close the current editor
