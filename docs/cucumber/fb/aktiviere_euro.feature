@persistent
Feature: REWE-3445
Background:
Given I set the fake date to "30.06.1995"
Given I enable the flag 39

# *****************************************************************************
#  Name             : aktiviere_euro.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Test des Aktivierens von "Umstellung auf Euro" in Firma KONF
#                     an: nur mit Flagge unabhängig von Wartung
#                     aus: unverändert nur in Wartung
#
# *****************************************************************************

Scenario: 01 Anschalten ohne Flagge ohne Wartung - scheitert
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# 3223: Für eine Währungsumstellung wenden Sie sich bitte an den betreuenden Partner.
Then setting field "euro" to "ja" throws the exception "3223"
And I close the current editor
#
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "VIEW" for record "0k"
Then field "euro" has value "nein" 
And I close the current editor


Scenario: 02 Anschalten mit Flagge ohne Wartung - tut
Given I enable the flag 113
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "euro" to "ja" 
And I save the current editor
And I close the current editor
Given I disable the flag 113
#
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "VIEW" for record "0k"
Then field "euro" has value "ja" 
And I close the current editor

Scenario: 03 Ausschalten ohne Flagge ohne Wartung - scheitert
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# 861: darf nicht ausgeschaltet werden
Then setting field "euro" to "nein" throws the exception "861"
And I close the current editor
#
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "VIEW" for record "0k"
Then field "euro" has value "ja" 
And I close the current editor

# folgendes geht nicht: Dazu müssen Sie allein in diesem Mandanten sein.
# Given I'm logged in with password "annette"
# Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# Then setting field "euro" to "ja" throws the exception "3223"
# And I close the current editor


