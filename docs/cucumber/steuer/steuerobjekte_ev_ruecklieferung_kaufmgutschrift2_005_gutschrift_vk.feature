# *****************************************************************************
#  Name             : steuerobjekte_ev_ruecklieferung_kaufmgutschrift2_005_gutschrift_vk.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Ueberwachung von steuerlichen Objekten bei
#                     Storno und Ruecklieferungen in Verkauf
#
#        Scenario: 1. AU-RE-LS-RLS-GS  -> STRGL in der Zeile der KGS geaendert
#
# *****************************************************************************

@persistent
Feature: steuerobjekte_ev_ruecklieferung_kaufmgutschrift2_005_gutschrift_vk.feature
Background: steuerliche Objekten in VK

Scenario: 1. Vorher: AU-RE-LS-RLS  -> STRGL in der Zeile geaendert    Nachher: KGS

# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "kgs1" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1rls"
And I set field "nummer" to "1gs"
And I set field "vom" to "."
# Felder abfragen
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
#
And I set field "strgl" to "5006" in row 1
# Felder erneut abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47300" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Felder in Rechnung/KGS nochmal kontrollieren
Given I open an editor "kontrolle" from table "(Sales):(Invoice)" with command "VIEW" for record "+1gs"
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47300" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I close the current editor
#####################################################################################################################################

