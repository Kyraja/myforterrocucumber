#  Verantwortlich   : uo
#  Kontrolle        : sih

@persistent
Feature: kostenbuchungsvorschlaege mit budat in der naechsten periode

Background: 
# Buchungsdatum einen Monat später das das Systemdatum.
# dazu das Systemdatum ggü. vorgängertest in den vorgängermonat setzen!
Given I set the fake date to "28.02.2002"

#--------------------------------------------------------------
Scenario: Stammdaten und Konfig.voraussetzungen schaffen
#--------------------------------------------------------------
Given I set the fake date to "28.02.2002"

Given I open an editor "korekonfig_max_zeilen" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "mzeile" to "10"
And I save the current editor

# ==== startdatum setzen
Given I open an editor "lb-startdat" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "vart" to "BEHAELTER"
And I set field "adat" to "1.2.2"
And I set field "edat" to "28.2.2"
And I set field "such" to "startdat"
And I press button "kosvor"
And I respond with answer "JA" to the dialog with id "5567"
And I save the current editor

#--------------------------------------------------------------
Scenario: mkv-versuch-in-naechste-gperiode
#--------------------------------------------------------------
Given I set the fake date to "28.02.2002"

#  !!!!! eigentliche testselektion !!!!!
# ========== VERBUCHBARE (grüne) BEWERTUNGEN suchen die dann aber bei der prüfung im kostenbuchungsvorschlag rot werden 
#            erwartung: ALLE MIT DATUM AUSSERHALB VERBUCHB ZEITRAUM =====

Given I open an editor "mkv-datum-in-zukunft" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

# bedingungen wie in gegenprobe unten
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "ursache" to "Lieferschein"
And I set field "buart" to "Abgang"
And I set field "adat" to "4.3."
And I set field "edat" to "4.3."
# DAZU MUSS MINDESTENS GRÜN + ROT AUSGEWÄHLT WERDEN!  DAS VERHÄLT SICH WIE BEI KONFLIKTEN, DIE WERDEN AUCH ERST IM KOSBUVOR ROT
And I set field "niverbausw" to "ja"
And I set field "verbhbedarfausw" to "ja"
And I set field "verbausw" to "ja"

And I set field "such" to "BUDATPER-GT-SYSDATPER"
And I press button "kosvor"
Then field "such" has value "BUDATPER-GT-SYSDATPER"

And I respond with answer "JA" to the dialog with id "9402"
And I save the current editor


#  ----- noch nebenselektionen AM 28.2 -----

# ========== nur grüne suchen / erwartung: keine da =====
Given I open an editor "mkv-versuch" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "4.3."
And I set field "edat" to "4.3."

And I set field "niverbausw" to "nein"
And I set field "verbhbedarfausw" to "nein"
And I set field "verbausw" to "ja"

And I press button "kosvor"

# 3641 tabelle leer
And saving the current editor throws the exception "3641"
And I close the current editor


# ========== nur gelbe suchen / erwartung: keine da =====
Given I open an editor "mkv-versuch" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "4.3."
And I set field "edat" to "4.3."

And I set field "niverbausw" to "nein"
And I set field "verbhbedarfausw" to "ja"
And I set field "verbausw" to "nein"

And I press button "kosvor"

# 3641 tabelle leer
And saving the current editor throws the exception "3641"
And I close the current editor


# ===== nur rote = nicht verbuchbare bewertungen suchen  

Given I open an editor "mkv-datum-in-zukunft" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "4.3."
And I set field "edat" to "4.3."

And I set field "niverbausw" to "ja"
And I set field "verbhbedarfausw" to "nein"
And I set field "verbausw" to "nein"

And I set field "such" to "NIVERBAUSW"
And I press button "kosvor"
Then field "such" has value "NIVERBAUSW"

And I respond with answer "JA" to the dialog with id "9402"
And I save the current editor



#--------------------------------------------------------------
Scenario: mkv-buchungen nach sysdat im maerz angekommen ist
#--------------------------------------------------------------

# !!! Gegenprobe, können die oben noch nicht verbuchbaren 
#     kostenbuchungszeilen mit erhöhtem Systemdatum gebucht werden ???

Given I set the fake date to "01.03.2002"

Given I open an editor "mkv-in-der-zukunft-angekommen" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

# bedingungen wie in eigentliche testselektion oben
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "ursache" to "Lieferschein"
And I set field "buart" to "Abgang"
And I set field "adat" to "4.3."
And I set field "edat" to "4.3."
And I set field "niverbausw" to "ja"
And I set field "verbhbedarfausw" to "ja"
And I set field "verbausw" to "ja"

And I set field "such" to "BUDATPER-EQ-SYSDATPER"
And I press button "kosvor"
Then field "such" has value "BUDATPER-EQ-SYSDATPER"

And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor

