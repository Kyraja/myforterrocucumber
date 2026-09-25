@persistent
Feature: Buchungen bezüglich Kostenrechnung reparieren/synchronisieren
Background:
Given I set the fake date to "31.12.2003"

# *****************************************************************************
#  Autor            : uo
#  Verantwortlich   : uo
#  Kontrolle        : sih
#  Funktion         : bedarfsweises ausführen der kostenrechnungskorrekturen in buchungen 
#                     kann in einem test mehrfach benutzt werden, weil datensätze in die
#                     ablage gehen. update-suche nach such==BS funktioniert deshalb immer wieder
#                     eindeutig.
# *****************************************************************************

Scenario: 

Given I open an editor "REWEStammBuchungssynchronisation" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "NEW" for record ""
And I set fields
	| such  | BS              |
	| bsart | Kostenrechnung  |
	| bspgj | 01              |
And I save the current editor
#
Given I open an editor "REWEStammBuchungssynchronisation" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "UPDATE" for record "BS"
And I press button "bstart"
And I save the current editor
