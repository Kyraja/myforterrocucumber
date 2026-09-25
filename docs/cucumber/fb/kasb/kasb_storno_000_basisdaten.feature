# *****************************************************************************
#  Name             : kasb_storno_000_basisdaten.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Basisdaten
#
#
# *****************************************************************************

@persistent
Feature: STORNO und Kassenbuch
Background: Daten
Given I set the fake date to "03.02.2002"

Scenario: Kassenbuch anlegen
Given I open an editor "Kassenbuch" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "nummer" to "1"
And I set field "kasskto" to "16000"
#And I set field "waehr" to "DEM"
And I create a new row at the end of the table
And I set field "beldat" to "1.02.02" in row 1
And I set field "beinn" to "15" in row 1
And I set field "gkonto" to "44000" in row 1
And I set field "kstelle" to "100" in row 1
And I save the current editor
And I close the current editor
#####################################################################################################################################
