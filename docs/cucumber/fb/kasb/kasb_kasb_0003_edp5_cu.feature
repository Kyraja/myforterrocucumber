# *****************************************************************************
#  Name             : kasb_kasb_0003_edp5_cu.feature
#  Autor            : Jan Effler
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : wird verwendet um kasb_edp5.txt zwischen ladbuch und kassbuch1 aufzurufen,
#                     da kasb_edp5.txt den vorherigen Aufruf von ladbuch voraussetzt
# *****************************************************************************

@persistent
Feature: kasb_kasb_0002_edp5
Background: ref_kasb
Scenario: edp5

Given I enable the flag 2
Given I enable the flag 261
Given I execute FOP "KASB.EDP5.FOP"
Given I disable the flag 261
Given I disable the flag 2

