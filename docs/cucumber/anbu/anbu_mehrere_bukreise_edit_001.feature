# *****************************************************************************
#  Name             : anbu_mehrere_bukreise_cu.feature
#  Autor            :
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : 
#
# *****************************************************************************
@persistent
Feature: anbu_mehrere_bukreise
Background: ref_anbu_mehrere_bukreise

# Abschreibungsvorschlaege generieren

# ################################################################################################################################

Scenario: AfA-Vorschlag scheitert

# Scheitert da beganbugj2 = gj + 1

Given I open an editor "afavorschl" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "."
# erwarteter Fehler: 4186 : Geschaeftsjahr liegt vor Beginn der Anlagenbuchhaltung!
# tatsaechlicher Fehler: 1361 : Ungueltiger Feldwert
Then setting field "selbukreis" to "2" throws the exception "1361"
# Wird nicht gebucht oder gespeichert, da gewÅnschte Eingabe aufgrund von Fehlern nicht Åbernommen werden kînnen
# And I save the current editor
And I close the current editor
# ################################################################################################################################

# XXX1 komplett im aktuellen GJ auf XXX3 umbuchen

Scenario Outline: Anlagenvorgaenge

Given I open an editor "umbuchung" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "vorgart" to "vollumbuchung"
And I set field "selbukreis" to "<buchungskreis>"
And I set field "apart" to "<apart>"

# 106 : unzulÑssiges Datum, wird hier in jedem Fall geworfen, bei Bearbeitung "von Hand" im Mandanten nur bei Buchungskreis 2
Then setting field "vdatum" to "." throws the exception "106"

And I set field "anlage" to "XXX1"

# Fehler wird fÅr Buchungskreise 1 und 3 erwartet, tritt aber hier nicht auf (da bereits zuvor das Datum nicht auf den entsprechenden Wert gesetzt werden konnte)
# 8118 : Anschaffungsdatum muss vor dem ersten Buchungsdatum liegen.
# Then setting field "uanlage" to "XXX3" throws the exception "8118"

And I set field "uanlage" to "XXX3"


# 4479 : Verbuchen von Anlagenvorgang?
And I respond with answer "ja" to the dialog with id "4479"
# 2743 : Vorgang abgebrochen
# 106  : unzulÑssiges Datum
Then saving the current editor throws the exception "106"
And I close the current editor

Examples:

|buchungskreis|         apart|
|            1|    steuerlich|
|            2|    steuerlich|
|            3|    steuerlich|
|            1|kalkulatorisch|
|            2|kalkulatorisch|
|            3|kalkulatorisch|
# ################################################################################################################################


# # alle anderen AfA-Vorschlaege werden ohne Fehler angelegt
# 
# Scenario Outline: erfolgreiche Abschreibungsvorschlaege
# 
# Given I open an editor "afavorschl" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
# And I set field "gjahr" to "<gj>"
# And I set field "selbukreis" to "<buchungskreis>"
# # !!! Verursacht Fehleranzeige in Terminal, aber keinen ordentlichen Output (vlt. ADM.FEHL?)
# And I press button "afaerm"
# And I press button "buchap"
# And I save the current editor
# And I close the current editor
# 
# Examples:
# 
# |gj|buchungskreis|
# | .|            1|
# | .|            3|
# |+1|            1|
# |+1|            2|
# |+1|            3|
# 
# # ################################################################################################################################


