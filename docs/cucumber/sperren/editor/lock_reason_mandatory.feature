# *****************************************************************************
#  Name: lock_reason_mandatory.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Wirkung der Sperrgrundpflicht in Zusatzpositionen.
# *****************************************************************************
@persistent
Feature: Pflichtgrund_in_Zusatzpositionen

Scenario: Neue_Sperrkonfigurationen

Given I'm logged in with password "sy"

Given I open an editor "Lock_no_reason" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "KEIN_GRUND"
And I set field "classname" to "SperreOhnePflichtgrund"
And I set field "gesperrtegruppe" to "V-02-04"
And I save the current editor
And I close the current editor

Given I open an editor "Lock_forced_reason" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "HINW_MIT_GRUND"
And I set field "classname" to "HinweisSperreMitPflichtgrund"
And I set field "gesperrtegruppe" to "V-02-04"
And I set field "istsperrgrundpflicht" to "Ja"
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "VOLL_MIT_GRUND"
And I set field "classname" to "VollsperreMitPflichtgrund"
And I set field "gesperrtegruppe" to "V-02-04"
And I set field "istsperrgrundpflicht" to "Ja"
And I save the current editor
And I close the current editor

Scenario: Aufzaehlung_22002_erweitern

Given I open an editor "Enumeration" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "22002"
And I append rows
   | vaufzelem                         | aebez           | aekbez | aebezeichner   |
   | Sperrkonfiguration KEIN_GRUND     | Kein Grund      | -      | KG             |
   | Sperrkonfiguration HINW_MIT_GRUND | Hinweis & Grund | +      | HG             |
   | Sperrkonfiguration VOLL_MIT_GRUND | Voll & Grund    | ++     | VG             |
And I respond with answer "Ja" to the dialog with id "10951"
And I save the current editor

Scenario: Erfolgreiches_Speichern_mit_neuer_Sperre_ohne_Pflicht

Given I open an editor "Platzhalter" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
And I set field "sperrkonfigurationneu" to "Kein Grund"
And I set field "sperrgrundneu" to ""
And I save the current editor
And I close the current editor

Scenario: Erfolgreiches_Speichern_mit_ersetzender_Sperre_mit_Pflicht

Given I open an editor "Platzhalter" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
Then field "sperrkonfigurationneu" has value "Kein Grund"
Then field "sperrgrundneu" has value ""
And I set field "sperrkonfigurationneu" to "Hinweis & Grund"
And I set field "sperrgrundneu" to "Hinweis & Grund"
And I save the current editor
And I close the current editor

Scenario: Scheiterndes_Speichern_gleicher_Sperre_mit_Pflicht_aber_ohne_Grund

Given I open an editor "Platzhalter" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
Then field "sperrkonfigurationneu" has value "Hinweis & Grund"
Then field "sperrgrundneu" has value "Hinweis & Grund"
And I set field "sperrgrundneu" to ""
Then saving the current editor throws the exception "3567"
And I close the current editor

Scenario: Scheiterndes_Speichern_mit_ersetzender_Sperre_mit_Pflicht

Given I open an editor "Platzhalter" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
Then field "sperrkonfigurationneu" has value "Hinweis & Grund"
Then field "sperrgrundneu" has value "Hinweis & Grund"
And I set field "sperrkonfigurationneu" to "Voll & Grund"
And I set field "sperrgrundneu" to ""
Then saving the current editor throws the exception "3567"
And I close the current editor

Scenario: Erfolgreiches_Speichern_mit_ersetzender_Sperre_mit_Pflicht

Given I open an editor "Platzhalter" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
Then field "sperrkonfigurationneu" has value "Hinweis & Grund"
Then field "sperrgrundneu" has value "Hinweis & Grund"
And I set field "sperrkonfigurationneu" to "Voll & Grund"
And I set field "sperrgrundneu" to "Voll & Grund"
And I save the current editor
And I close the current editor

Scenario: Erfolgreiches_Speichern_mit_Aufheben_der_Sperre

Given I open an editor "Platzhalter" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
Then field "sperrkonfigurationneu" has value "Voll & Grund"
Then field "sperrgrundneu" has value "Voll & Grund"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor

Given I open an editor "Platzhalter" from table "(Part):(SupplementaryItem)" with command "VIEW" for record "A."
Then field "sperrkonfigurationneu" has value ""
Then field "sperrgrundneu" has value ""
And I close the current editor
