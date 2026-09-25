# *****************************************************************************
#  Name: obj_lock_items_validate.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet Wertpruefungen der Objektsperre-Felder in Editoren
# *****************************************************************************
@persistent
Feature: Feldpruefungen

Scenario: EtabliereZusatzpositionssperre

Given I'm logged in with password "NixAendern"

Given I open an editor "EtabliereSperre" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
And I set field "sperrkonfigurationneu" to "Zusatzpositionshinweis"
And I save the current editor
And I close the current editor

Scenario: NixNeuEtabliereAndereZusatzpositionssperre

Given I'm logged in with password "NixNeu"

Given I open an editor "NixNeu" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
And setting field "sperrkonfigurationneu" to "Zusatzpositionssperre" throws the exception "131"
And I close the current editor

Scenario: EtabliereZusatzpositionssperreInDienstleistung

Given I'm logged in with password "sy"

Given I open an editor "FalscheGruppe" from table "(Part):(Service)" with command "NEW" for record ""
And setting field "sperrkonfigurationneu" to "Falsche Gruppe" throws the exception "1361"
And I close the current editor
