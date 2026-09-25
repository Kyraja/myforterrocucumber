# *****************************************************************************
#  Name           : ks_kt_edit_sperrkonfig_plausis_wegen_verdichtung.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test der Plausibilisierung der Verdichtungsobjekte in Bezug auf Editierbarkeit der Felder
#                   der Sperrkonfiguration.
#
# *****************************************************************************
@persistent
Feature: BW2-2000 (Kostenobjekte, die nicht gesperrt werden drfen - Kostenobjekteigenschaft)
Background:
Given I set the fake date to "20.01.1995"

Scenario: 01 Kst und Ktr anlegen
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "201"
And I set field "such" to "ks201"
And I save the current editor
And I close the current editor

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "222"
And I set field "such" to "ks222"
And I set field "bebuchbar" to "nein"
And I save the current editor
And I close the current editor

Given I open an editor "kt" from table "(Account):(CostObject)" with command "COPY" for record "100000"
And I set field "nummer" to "200001"
And I set field "such" to "kt200001"
And I save the current editor
And I close the current editor

Given I open an editor "kt" from table "(Account):(CostObject)" with command "COPY" for record "100000"
And I set field "nummer" to "202222"
And I set field "such" to "kt202222"
And I set field "bebuchbar" to "nein"
And I save the current editor
And I close the current editor

Scenario: 02 Sperrkonfiguration in Kst und Ktr eintragen
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "201"
And I set field "sperrkonfigurationneu" to "Standard-Kostens"
And I set field "sperrgrundneu" to "gesperrt"
And I save the current editor
And I close the current editor
 
Given I open an editor "kt" from table "(Account):(CostObject)" with command "UPDATE" for record "200001"
And I set field "sperrkonfigurationneu" to "Standard-Kostentraegersperre"
And I set field "sperrgrundneu" to "gesperrt"
And I save the current editor
And I close the current editor

Scenario: 03 bebuchbare Kostenobjekte mit Sperrkonfiguration auf "nicht bebuchbar" umstellen -> Plausi!
# Plausi 2068: Beim Verdichtungsobjekt nicht „nderbar.
Given I'm logged in with password "annette"

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "201"
And I set field "bebuchbar" to "nein"
Then saving the current editor throws the exception "2068"
And I close the current editor
# 
Given I open an editor "kt" from table "(Account):(CostObject)" with command "UPDATE" for record "200001"
And I set field "bebuchbar" to "nein"
Then saving the current editor throws the exception "2068"
And I close the current editor
# 
Given I'm logged in with password "sy"

Scenario: 04 Verdichtungskostenstelle und -traeger sperren -> Plausi
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "222"
And I set field "sperrkonfigurationneu" to "Standard-Kostens"
And I set field "sperrgrundneu" to "gesperrt"
Then saving the current editor throws the exception "2068"
And I close the current editor
#
Given I open an editor "ks2" from table "(Account):(CostCenter)" with command "VIEW" for record "222" 	
Then field "sperrkonfigurationneu" has value ""
Then field "sperrgrundneu" has value ""
And I close the current editor
# 
Given I open an editor "kt" from table "(Account):(CostObject)" with command "UPDATE" for record "202222"
And I set field "sperrkonfigurationneu" to "Standard-Kostent"
And I set field "sperrgrundneu" to "gesperrt"
Then saving the current editor throws the exception "2068"
And I close the current editor
#
Given I open an editor "kt2" from table "(Account):(CostObject)" with command "VIEW" for record "202222" 	
Then field "sperrkonfigurationneu" has value ""
Then field "sperrgrundneu" has value ""
And I close the current editor



