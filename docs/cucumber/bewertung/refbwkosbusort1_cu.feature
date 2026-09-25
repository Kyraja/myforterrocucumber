#  Autor            : uo
#  Verantwortlich   : uo

@persistent
Feature: Sortierung in der Tabelle eines KVB plausibilisieren

Background:
Given I set the fake date to "07.03.2002"


Scenario: Sortierung durch Verschieben simulieren - Absicherung gegen Doppelbuchungen

# Materialkostenverbuchung
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-BW21b"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "1.1."
And I set field "edat" to "."
And I press button "kosvor"

# ZUR FEHLERPROVOKATION MUSS EINE VERSCHIEBUNG MIT DER LETZTEN ZEILEN ERFOLGEN!!! 
Then the table has 8 rows
Then table has values
 | artikel | 
 | E1A-VLI | 
 | E1A-VLI |
 | E1A-VF  |
 | E1A-VF  |
 | E1A-VO  |
 | E1A-VO  |
 | E1A-VM  |
 | E1A-VM  |

And I move rows "8" to position "3"
Then the table has 8 rows
Then table has values
 | artikel |
 | E1A-VLI |
 | E1A-VLI |
 | E1A-VM  |
 | E1A-VF  |
 | E1A-VF  |
 | E1A-VO  |
 | E1A-VO  |
 | E1A-VM  |

And I respond with answer "JA" to the dialog with id "2324"
#
# der fehler wirkt sich nur aus, wenn die sortierung die letzte zeile ändert.
# es ist dann so, dass die ursprüngliche orginalzeile der zum zeitpunkt vor dem speichern in der letzten zeile
# befindlichen zeile nicht mehr rückkorrigiert wird. d.h. die dortige bewertung + bewertungspostion wird
# zum duplikat. das kann je nach sortierung ganz unterschiedlich sein
# 
#                                            in Zeile 7
#                                                  V
# Bewertungsposition kommt doppelt vor.|ERROR|3524|7|bewssref||-6|
And I respond with answer "ja" to the dialog with id "5567"
And I save the current editor

# Ursprungsreihenfolge muss sich hier bestätigen
# auf Duplikate in den Bewertungspostionen wird im testbett geprüft
Given I open an editor "mkv-check" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "VIEW" for record "1"
Then table has values
 | artikel | 
 | E1A-VLI | 
 | E1A-VLI |
 | E1A-VF  |
 | E1A-VF  |
 | E1A-VO  |
 | E1A-VO  |
 | E1A-VM  |
 | E1A-VM  |
And I save the current editor
