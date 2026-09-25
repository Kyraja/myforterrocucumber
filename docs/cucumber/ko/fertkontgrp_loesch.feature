# *****************************************************************************
#  Name           : fertkontgrp_loesch.feature            
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test des Löschens von Fertigungskontengruppen.                         
#                   Fertigungskontengruppen kommen vor in Kostenstellen, Kostenträgern, Stammkostenverteilern und der 
#                   Kostenrechnungskonfiguration
#
# FertkontGrp: 66, 100, 500, 77
# Kst/Ktr/KV       FertkontGrp
#     101              100
#     102              100
#     600               66
#
#  200000               77
#  300000               77
# 
#      20               77
#
#        1             500
# *****************************************************************************
@persistent
Feature: BW2-1404  
Background:
Given I set the fake date to "02.01.1995"

Scenario: 01 Stammdaten
Given I open an editor "fk" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "COPY" for record "66"
And I set field "nummer" to "77"
And I set field "such" to "FK77"
And I save the current editor

Given I open an editor "ktr" from table "(Account):(CostObject)" with command "UPDATE" for record "200000"
And I set field "fertkont" to "77"
And I save the current editor

Given I open an editor "ktr" from table "(Account):(CostObject)" with command "UPDATE" for record "300000"
And I set field "fertkont" to "77"
And I save the current editor

Given I open an editor "kv" from table "(Account):(CostDistribution)" with command "COPY" for record "10"
And I set field "nummer" to "20"
And I set field "such" to "KV20"
And I set field "fertkont" to "77"
And I save the current editor

Scenario: 02 Loeschversuche aller Fertigungskontengruppen
Given I open an editor "FkoGrp" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "DELETE" for record "66"
Then saving the current editor throws the exception "4119"
And I close the current editor
#
Given I open an editor "FkoGrp" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "DELETE" for record "77"
Then saving the current editor throws the exception "4120"
And I close the current editor
#
Given I open an editor "FkoGrp" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "DELETE" for record "500"
Then saving the current editor throws the exception "4127"
And I close the current editor

Scenario: 03 Fertigungskontengruppenverwendung aufheben und dann loeschen
Given I open an editor "kst" from table "(Account):(CostCenter)" with command "UPDATE" for record "600"
And I set field "fertkont" to ""
And I save the current editor

Given I open an editor "FkoGrp" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "DELETE" for record "66"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Given I open an editor "ktr" from table "(Account):(CostObject)" with command "UPDATE" for record "200000"
And I set field "fertkont" to ""
And I save the current editor

Given I open an editor "ktr" from table "(Account):(CostObject)" with command "UPDATE" for record "300000"
And I set field "fertkont" to ""
And I save the current editor

Given I open an editor "FkoGrp" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "DELETE" for record "77"
Then saving the current editor throws the exception "4122"
And I close the current editor

Given I open an editor "kv" from table "(Account):(CostDistribution)" with command "UPDATE" for record "20"
And I set field "fertkont" to ""
And I save the current editor

Given I open an editor "FkoGrp" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "DELETE" for record "77"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Given I open an editor "korekonf" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "fertkont" to ""
Then saving the current editor throws the exception "2842"
And I close the current editor

