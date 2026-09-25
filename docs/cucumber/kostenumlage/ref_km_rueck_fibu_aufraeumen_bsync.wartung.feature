# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : 
# *****************************************************************************
@persistent
Feature: Test Kostenumlagerückführungen aufräumen und Buchungen bereinigen (Basis KM aus FIBU) 

# ------------------------------------------------------------------------------------------------
Background:
# ------------------------------------------------------------------------------------------------
# Buchungssynchronsiation (Buchungen löschen) kann man nur in Wartung starten, deshalb hier
# separat Wartung das geht im Aufräumen auch nur im allein-modus und der wiederum geht nur 
# mit login im background :(

Given I'm logged in with password "annette"
Given I set the fake date to "31.01.2004"

# ------------------------------------------------------------------------------------------------
Scenario: 2 Jahre abschliessen, damit Buchungen in 02 gelöscht werden können
# ------------------------------------------------------------------------------------------------

Given I set the fake date to "31.01.2004"

Given I open an editor "Jahresabschl-01" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set field "such" to "jab01"
And I set field "jastart" to "ja"
And I respond with answer "ja" to the dialog with id "10747"
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor

Given I open an editor "Jahresabschl-02" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set field "such" to "jab02"
And I set field "jastart" to "ja"
And I respond with answer "ja" to the dialog with id "10747"
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor


# ------------------------------------------------------------------------------------------------
Scenario:  aufraeumen / über buchungssync
# ------------------------------------------------------------------------------------------------
Given I set the fake date to "31.01.2004"


Given I open an editor "REWEStammBuchungssynchronisation-2" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "NEW" for record ""
And I set fields
	| such  | LOESCH02        |
	| bsart | Buchungen und Verkehrszahlen löschen  |
	| bsegj | 02              |
And I save the current editor

Given I open an editor "REWEStammBuchungssynchronisation-2" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "UPDATE" for record "LOESCH02"
And I press button "bstart"
And I save the current editor
