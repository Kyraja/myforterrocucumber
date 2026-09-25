# *****************************************************************************
#  Name             : steuer_steuerregel_edit_001_zeilen.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Zeilen bei Steuerregel (STRGL):
#                     * Einfuegen
#                     * Loeschen
#                     in NEU und KOPIE
#
#
# *****************************************************************************
@persistent

Feature: steuer_steuerregel_edit_001_zeilen.feature
Background: Behandlung von Zeilen bei STRGL



Scenario: NEU

# ohne Zeilen -> macht kein Sinn, ist aber moeglich
Given I open an editor "steuerregel-ohne" from table "(TaxCode):(TaxRule)" with command "NEW" for record ""
And I set field "namebspr" to "STRGL ohne Tabelle"
And I set field "such" to "EKAUSFREI-100"
And I set field "ev" to "Einkauf"
And I set field "stlaart" to "Ausland"
And I set field "ustart" to "steuerfrei"
And I set field "sts" to "0"
And I set field "nummer" to "5000a"
Then the table has 0 rows
And I save the current editor
And I close the current editor


# leere Zeile
Given I open an editor "steuerregel" from table "(TaxCode):(TaxRule)" with command "NEW" for record ""
And I set field "namebspr" to "STRGL ohne Tabelle"
And I set field "such" to "EKAUSFREI-100"
And I set field "ev" to "Einkauf"
And I set field "stlaart" to "Ausland"
And I set field "ustart" to "steuerfrei"
And I set field "sts" to "0"
And I set field "nummer" to "5000b"
And I create a new row at the end of the table
Then the table has 1 rows
# 10179 TX=de   |bitte eintragen
Then saving the current editor throws the exception "10179"
And I press button "ladestpertab"
Then the table has 2 rows
# die leere Zeile wird in der Maske beim Speichern eigentlich geloescht!
Then saving the current editor throws the exception "10179"
#
# eigentliche Meldung in der Maske:
#================================
#        CAUSE: Vorgang abgebrochen
#        Folgende Pflichtfelder sind nicht ausgefÅllt:
#        Steuerperiode des Buchungsdatums in Zeile 1
#        Steuerperiode des Steuerberechnungsdatums in Zeile 1
#        Steuerperiode des Buchungsdatums in Zeile 1 bitte eintragen
#
And I delete row at position 1
And I save the current editor
And I close the current editor
############################################################################################################


Scenario: Kopie


# ohne Zeilen
Given I open an editor "steuerregel" from table "(TaxCode):(TaxRule)" with command "COPY" for record "5010"
And I set field "namebspr" to "STRGL ohne Tabelle 2"
And I set field "such" to "OHNE2"
And I set field "nummer" to "5010ohne"
Then the table has 1 rows
And I delete row at position 1
And I save the current editor
And I close the current editor
############################################################################################################

