# *****************************************************************************
#  Name             : steuer_ist_versteuerung_allg_004_storno.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbelegung/Plausis/Nachbehandlung von (ev)istversteuerer
#                     in EV-Vorgaengen
#
#
# *****************************************************************************
@persistent
Feature: steuer_ist_versteuerung_allg_004_storno.feature
Background: Vorbelegung/Plausis/Nachbehandlung von (ev)istversteuerer

Given I set the fake date to "31.12.1999"


Scenario: Storno in Verkauf

# Original-VK-Rechnung anlegen
Given I open an editor "vkre-original" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "num3" to "01orig"
Then field "istversteuerer" has value "nein"
And I set field "istversteuerer" to "ja"
And I set field "ueb" to "ja"
#
Then field "vrgstrgl" has value "VKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "ja"
Then field "istversteuerer" is modifiable
#
And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "020" in row 1
And I set field "preis" to "020" in row 1
#
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


Given I open an editor "vkre-storno" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+01orig"
# Given I open an editor "re-storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+40RE001"
Then field "vrgstrgl" has value "VKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "ja"
Then field "op" has value ""
Then field "opz" has value ""
#
# And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
###################################################################################################


Scenario: Storno in Einkauf

# Original-VK-Rechnung anlegen
Given I open an editor "ekre-original" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "num4" to "01orig"
And I set field "vom" to "."
Then field "istversteuerer" has value "nein"
And I set field "istversteuerer" to "ja"
And I set field "ueb" to "ja"
#
Then field "vrgstrgl" has value "EKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "ja"
Then field "istversteuerer" is modifiable
#
And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "150" in row 1
And I set field "preis" to "10" in row 1
#
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


Given I open an editor "ekre-storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+01orig"
Then field "vrgstrgl" has value "EKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "ja"
Then field "op" has value ""
Then field "opz" has value ""
#
# And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
###################################################################################################


