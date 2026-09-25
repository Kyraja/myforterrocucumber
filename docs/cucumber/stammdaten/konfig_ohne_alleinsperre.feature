# *****************************************************************************
#  Name           : konfig_ohne_alleinsperre.feature
#  Autor          : Silvia Warth
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test der Aktivierung der Module Kostenrechnung, Statistische Buchungen, Parallele Rechnungslegung, Konsolidierung
#                   und Konzernrechnungslegung ohne ohne Alleinsperre
#                   
# *****************************************************************************
@persistent
Feature: Aktivieren der Module ohne Alleinsperre
Background:
Given I set the fake date to "31.08.02"

Scenario: 01 erst einmal die o.e. Module deaktivieren
Given I'm logged in with password "annette"
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "pararele" to "nein"
And I set field "kost" to "nein"
And I set field "stbu" to "nein"
And I save the current editor
Given I'm logged in with password "sy"

Scenario: 02 Kostenrechnung aktivieren
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "kost" to "ja"
And I save the current editor

Scenario: 03 Statistische Buchungen aktivieren
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "stbu" to "ja"
And I respond with answer "ja" to the dialog with id "3215"
And I save the current editor

Scenario: 04 Parallele Rechnungslegung aktivieren
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "pararele" to "ja"
And I save the current editor

Scenario: 05 Konzernrechnungslegung aktivieren
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "konz" to "ja"
And I save the current editor

Scenario: 06 Konsolidierung aktivieren
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "konzmand" to "ja"
And I save the current editor





