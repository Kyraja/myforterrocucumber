# *****************************************************************************
#  Name             : steuerobjekte_ev_ruecklieferung_kaufmgutschrift2_002_vorbereitung_vk.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Ueberwachung von steuerlichen Objekten bei
#                     Storno und Ruecklieferungen in Verkauf
#
#        Scenario: 1. AU(0001au)-RE(1revor)-LS(1ls)-RLS(1rls)
#
# *****************************************************************************

@persistent
Feature: steuerobjekte_ev_ruecklieferung_kaufmgutschrift2_002_vorbereitung_vk.feature
Background: steuerliche Objekten in VK

Scenario: 1. AU-RE-LS-RLS

Given I open an editor "auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "0001au"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "3.15" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "81" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47365" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "sktoustpos" has value "81" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "581" in row 1
#
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I set field "proz" to "5" in row 1
Then field "proz" has value "5" in row 1
And I save the current editor


# Auftrag in Rechnung ueberfuehren -> Vorkasse
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag1"
And I set field "nummer" to "1revor"
And I set field "tterm" to "."
And I set field "fakt" to "nein"
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "81" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47365" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "sktoustpos" has value "81" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "581" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Auftrag beliefern
Given I open an editor "ls-1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag1"
And I set field "nummer" to "1ls"
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "81" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47365" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "sktoustpos" has value "81" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "581" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor

# Ruecklieferung von 25 Stk
Given I open an editor "rls-1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "ls-1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "1rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "203" in row 1
And I set field "mge" to "-25" in row 1
And I save the current editor
And I close the current editor
#####################################################################################################################################


