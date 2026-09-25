# *****************************************************************************
#  Name: obj_lock_items_editable.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet Feldaenderbarkeiten der Objektsperre-Felder in Editoren
# *****************************************************************************
@persistent
Feature: Feldaenderbarkeiten

Scenario: NixNeu

Given I'm logged in with password "NixNeu"

Given I open an editor "NixNeu" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
Then field "sperrgrundneu" is not modifiable
Then field "sperrkonfigurationneu" is not modifiable
And I close the current editor

Scenario: NixLoesch

Given I'm logged in with password "NixLoesch"

Given I open an editor "NixLoesch" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
Then field "sperrgrundneu" is not modifiable
Then field "sperrkonfigurationneu" is modifiable
And I close the current editor

Scenario: NixAendern

Given I'm logged in with password "NixAendern"

Given I open an editor "NixAendern" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
Then field "sperrgrundneu" is not modifiable
Then field "sperrkonfigurationneu" is modifiable
And I close the current editor

Scenario: EtabliereSperre

Given I'm logged in with password "sy"

Given I open an editor "EtabliereSperre" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
Then field "sperrgrundneu" is not modifiable
Then field "sperrkonfigurationneu" is modifiable
And I set field "sperrkonfigurationneu" to "Zusatzpositionshinweis"
Then field "sperrgrundneu" is modifiable
And I save the current editor
And I close the current editor

Scenario: NixNeu_locked

Given I'm logged in with password "NixNeu"

Given I open an editor "NixNeu_locked" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
Then field "sperrgrundneu" is modifiable
Then field "sperrkonfigurationneu" is modifiable
And I set field "sperrkonfigurationneu" to ""
And I close the current editor

Scenario: NixLoesch_locked

Given I'm logged in with password "NixLoesch"

Given I open an editor "NixLoesch_locked" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
Then field "sperrgrundneu" is modifiable
Then field "sperrkonfigurationneu" is not modifiable
And I close the current editor

Scenario: NixAendern_locked

Given I'm logged in with password "NixAendern"

Given I open an editor "NixAendern_locked" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
Then field "sperrgrundneu" is modifiable
Then field "sperrkonfigurationneu" is modifiable
And I set field "sperrkonfigurationneu" to "Zusatzpositionssperre"
And I close the current editor
