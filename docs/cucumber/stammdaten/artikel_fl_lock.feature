@persistent
Feature: artikel_fl_lock.feature

  Background:
    And I set the fake date to "02.01.95"

	
# *****************************************************************************
#  Name             : artikel_fl_lock.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : 
#  Funktion         : Sperrsituation bei Artikeln mit Fertigungsliste
#  ref              : ref_artikel_fl_lock_cu
#  Stammdaten       : basis_stammdaten.feature
#
# *****************************************************************************

Scenario:
Given I open an editor "Baugruppe" from table "(Part):(Product)" with command "UPDATE" for record "BG1"

Given I'm logged in with password "me"
Given I open an editor "FE1-AUFTRAG" from table "(Part):(Product)" with command "COPY" for record "FE1-AUFTRAG"
And I set field "such" to "FE2-AUFTRAG"
And I set field "INDEX" to "10"
And I save the current editor

Given I'm logged in with password "sy"
And I close the current editor
