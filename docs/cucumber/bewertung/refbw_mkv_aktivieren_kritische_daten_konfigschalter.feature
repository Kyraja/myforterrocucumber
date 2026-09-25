# *****************************************************************************
#  Autor            : uo
#  Verantwortlich   : uo
#  Kontrolle        : sih
#  Funktion         : 
# *****************************************************************************
@persistent
Feature: Laufzeitmessung für Aktivierung der MKV: Bewertungen im Bestand kontieren
Background:
Given I set the fake date to "31.01.2002"
Given I enable the flag 39 

# ---------------------------------------------------------------------------------------------------
Scenario: Konfigschalter aktivieren
# ---------------------------------------------------------------------------------------------------
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "bew" to "ja"
And I respond with answer "ja" to the dialog with id "2539"
And I respond with answer "ja" to the dialog with id "2540"
# And I wait for file cucudbg for debugging
And I save the current editor
