#***************************************************************************
#
#  Name      : ehemals BWKOSBU.LT.TABELLENZEILEN1.LAD  *2.LAD  *3.LAD
#  Datum     : 03.11.15
#  Autor     : judi
#  Verantwortlich : uo
#
#  Funktion  : Laderscript zum Erzeugen von Kostenbuchungsvorschlägen
#              zum Testen der abweichenden Datenweitergabe von KBV an Buchung
#              wenn die Option "Kostenbuchung pro Zeile" gesetzt ist.
#***************************************************************************

@persistent
Feature: Kopier-AP im Kostenbuchungsvorschlag

Background:
Given I set the fake date to "15.03.02"


Scenario: KBV OHNE Kostenbuchung pro Zeile

Given I open an editor "kosbuvor1" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set fields
	| nummer        | 1B                       |
	| such          | OHNE                     |
	| kosart        | Verbuchung Lagerbestand  |
	| kosbuprozeile | nein                     |
And I press button "kosvor"
# schreibgeschützt
And setting field "tbukenn" to "DI" in row 1 throws the exception "203"
# schreibgeschützt
And setting field "tbubeleg" to "test" in row 1 throws the exception "203"
# schreibgeschützt
And setting field "tbutext" to "test" in row 1 throws the exception "203"
And I close the current editor


Scenario: KBV MIT Kostenbuchung pro Zeile

Given I open an editor "kosbuvor2" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set fields
    | nummer        | 1B                       |
    | such          | MIT                      |
    | kosart        | Verbuchung Lagerbestand  |
    | kosbuprozeile | ja                       |
And I press button "kosvor"
# 1336 de      |Das Journalkennzeichen ist in der Standardkontierung nicht definiert
And setting field "tbukenn" to "TEST" in row 1 throws the exception "1336"
And I close the current editor


Scenario: KBV-Buchung Lager

Given I open an editor "kosbuvor3" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set fields
        | nummer        | 2A                       |
        | such          | MIT                      |
        | kosart        | Verbuchung Lagerbestand  |
        | kosbuprozeile | ja                       |
And I press button "kosvor"
And I set field "tbukenn" to "AB" in row 1
And I set field "tbubeleg" to "test" in row 1
And I set field "tbutext" to "test" in row 1
And I set field "tbukenn" to "ST" in row 2
And I set field "tbubeleg" to "test" in row 3
And I set field "tbutext" to "test" in row 4
And I set field "tbukenn" to "LANG" in row 5
And I set field "tbubeleg" to "ganzlang" in row 5
And I set field "tbutext" to "ganzganzganzganzganzganzganzlang" in row 5
And I set field "tbukenn" to "LANG" in row 6
And I set field "tbubeleg" to "ganzlang" in row 7
And I set field "tbutext" to "ganzganzganzganzganzganzganzlang" in row 8
#And I press button "kosbu"
# 5567 ist nur das Fragewort Weiter?, JEDOCH SIND EIGENTLICH FOLGENDE FRAGEN INHALTLICH ENTSCHEIDEND, DIE HIER ANGEZEIGT WERDEN MUESSEN!
# Kostenbuchungen ab Startdatum %s erzeugen. oder...
# Kostenbuchungsvorschlag speichern und Startdatum auf den %s setzen.
And I respond with answer "JA" to the dialog with id "5567"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor



Scenario: KBV-Buchung Lager uE

Given I open an editor "kosbuvor4" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set fields
        | nummer        | 2B                                        |
        | such          | MIT                                       |
        | kosart        | Verbuchung Bestand unfertige Erzeugnisse  |
        | kosbuprozeile | ja                                        |
        | bukenn        | ST                                        |
And I press button "kosvor"
And I set field "tbukenn" to "AB" in row 1
And I set field "tbubeleg" to "test" in row 1
And I set field "tbutext" to "test" in row 1
And I set field "tbukenn" to "ST" in row 2
And I set field "tbubeleg" to "test" in row 3
And I set field "tbutext" to "test" in row 4
And I set field "tbukenn" to "LANG" in row 5
And I set field "tbubeleg" to "ganzlang" in row 5
And I set field "tbutext" to "ganzganzganzganzganzganzganzlang" in row 5
And I set field "tbukenn" to "LANG" in row 6
And I set field "tbubeleg" to "ganzlang" in row 7
And I set field "tbutext" to "ganzganzganzganzganzganzganzlang" in row 8
#And I press button "kosbu"
# 5567 ist nur das Fragewort Weiter?, JEDOCH SIND EIGENTLICH FOLGENDE FRAGEN INHALTLICH ENTSCHEIDEND, DIE HIER ANGEZEIGT WERDEN MUESSEN!
# Kostenbuchungen ab Startdatum %s erzeugen. oder...
# Kostenbuchungsvorschlag speichern und Startdatum auf den %s setzen.
And I respond with answer "JA" to the dialog with id "5567"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor




# 
# 
# # TO DO: <Kostenbuchungsvorschlag>
# # TO DO: <neu>
# And I set fields
#         | nummer        | 2B                                        |
#         | such          | MIT                                       |
#         | kosart        | Verbuchung Bestand unfertige Erzeugnisse  |
#         | kosbuprozeile | ja                                        |
#         | bukenn        | ST                                        |
# # TO DO: And I press button "NOT CODED" to open a subeditor for "Buchungsvorschlag erstellen"
# # And I set field "tbukenn" to "AB" in row 1
# And I set field "tbubeleg" to "test" in row 1
# And I set field "tbutext" to "test" in row 1
# # And I set field "tbukenn" to "ST" in row 2
# # And I set field "tbubeleg" to "test" in row 4
# # And I set field "tbutext" to "test" in row 7
# # And I set field "tbukenn" to "LANG" in row 11
# And I set field "tbubeleg" to "ganzlang" in row 11
# And I set field "tbutext" to "ganzganzganzganzganzganzganzlang" in row 11
# # And I set field "tbukenn" to "LANG" in row 16
# # And I set field "tbubeleg" to "ganzlang" in row 22
# # And I set field "tbutext" to "ganzganzganzganzganzganzganzlang" in row 29
# # # TO DO: <home>
# # TO DO: And I press button "NOT CODED" to open a subeditor for "Buchungsvorschlag buchen"
# # Kostenbuchungen ab Startdatum 01.01.02 erzeugen? ?
# # TO DO: <?> ja
# # TO DO: <
# # Weiter? ?
# 
# # TO DO: Dialog Abbruch> <?> nein
# And I close the current editor
# # TO DO: <
# # Weiter? ?
# 
# # TO DO: Dialog Abbruch> <?> nein
# And I close the current editor
# 
# 
# 







# Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
# And I set field "such" to "FALL-BW21b"
# And I set field "kosart" to "Verbuchung Lagerbestand"
# And I set field "adat" to "."
# And I set field "edat" to "."
# And I set field "vart" to "0efall2"
# And I press button "kosvor"
# And I respond with answer "JA" to the dialog with id "2324"
# # 5567 ist nur das Fragewort Weiter?, JEDOCH SIND EIGENTLICH FOLGENDE FRAGEN INHALTLICH ENTSCHEIDEND, DIE HIER ANGEZEIGT WERDEN MUESSEN!
# # Kostenbuchungen ab Startdatum %s erzeugen. oder...
# # Kostenbuchungsvorschlag speichern und Startdatum auf den %s setzen.
# And I respond with answer "yes" to the dialog with id "5567"
# And I save the current editor

