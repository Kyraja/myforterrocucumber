# *****************************************************************************
#  Name             : FERTIGUNG_Zeitbuchung
#  Autor            : uo
#  Verantwortlich   : uo
#  Kontrolle        : 
#  Funktion         : abteilungskostensatz erfassen, muss nachbewertung auslösen 
#
# *****************************************************************************

@persistent
Feature: abteilungskostensatz
Background:
And I set the fake date to "25.02.1995"

Scenario: abteilungskostensatz
Given I open an editor "abt" from table "(Capacity):(Department)" with command "UPDATE" for record "BETR"
And I set field "fixkost" to "11"
And I save the current editor
