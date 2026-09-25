#  Autor            : uo
#  Verantwortlich   : uo
#  Kontrolle        : wane sih
#  Funktion         : 

@persistent
Feature: Kopieren von kostenbuchungsvorschlägen
Background: 

# @FALL-..........
Scenario: kopieren mit parametern vorbereiten

# systemdatum INNERHALB der bebuchbaren zeiträume, adat und edat auch
Given I set the fake date to "31.12.2002"

Given I open an editor "kosbu1" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "COPY" for record "B01"

Then the table has 0 rows

Then I set field "kosart" to "Verbuchung Bestand unfertige Erzeugnisse"
Then I set field "such" to "SELPARAM1"

Then I set field "vkoo" to "112"
Then I set field "bkoo" to "114"
Then I set field "vart" to "E1A-VF"

# einige ungewöhnliche werte setzen, die dann beim kopieren dieses satzes erhalten bleiben müssen (werteprüfung)
# u.a. nur rote 
Then I set field "verbhbedarfausw" to "nein"
Then I set field "verbausw" to "nein"
Then I set field "absmindwert" to "2.00"
Then I set field "kosbuprozeile" to "ja"
Then I set field "direktausw" to "nein"

Then the table has 0 rows

# erstellen
And I press button "kosvor"

#  9402 de   |Es sind keine verbuchbaren Zeilen vorhanden. Trotzdem fortfahren?
And I respond with answer "ja" to the dialog with id "9402"
And I save the current editor


Scenario: Fehler/Plausi leere tabelle muß nach dem kopieren wirken!

# systemdatum außerhalb der bebuchbaren zeiträume, adat und edat aber im
# bebuchbaren zeitraum. das funktioniert, zumindest ohne erzeugen von buchungen 
Given I set the fake date to "31.12.2002"

Given I open an editor "kosbu2" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "COPY" for record "SELPARAM1"
Then the table has 0 rows
Then I set field "such" to "SPEICHERNFEHLER1"
# tabelle ist leer
And saving the current editor throws the exception "3641"
And I close the current editor


Scenario: OK-fall, kopieren mit parametern und werteprüfung

# systemdatum außerhalb der bebuchbaren zeiträume, adat und edat aber im
# bebuchbaren zeitraum. das funktioniert, zumindest ohne erzeugen von buchungen 
Given I set the fake date to "31.12.2006"

Given I open an editor "kosbu2" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "COPY" for record "SELPARAM1"

Then the table has 0 rows

Then field "kosart" has value "Verbuchung Bestand unfertige Erzeugnisse"
# das suchwort wird generell nicht kopiert sondern auch beim kopieren mit der kostenart und dem monat vorbelegt
Then field "such" has value "B12"

Then I set field "such" to "PARAMKOPIERT"

# werteprüfungen
Then field "vkoo" has value "112"
Then field "bkoo" has value "114"
Then field "vart" has value "E1A-VF"

Then field "verbhbedarfausw" has value "nein"
Then field "verbausw" has value "nein"
Then field "absmindwert" has value "2.00"
Then field "kosbuprozeile" has value "ja"
Then field "direktausw" has value "nein"

Then the table has 0 rows

# erstellen
And I press button "kosvor"

#  9402 de   |Es sind keine verbuchbaren Zeilen vorhanden. Trotzdem fortfahren?
And I respond with answer "ja" to the dialog with id "9402"
And I save the current editor


Scenario: Datumsfehler adat. (nicht kopieren spezifisch)

# systemdatum außerhalb der bebuchbaren zeiträume, adat und edat aber im
# bebuchbaren zeitraum. das funktioniert, zumindest ohne erzeugen von buchungen 
Given I set the fake date to "31.12.2006"

Given I open an editor "kosbu2" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "COPY" for record "SELPARAM1"
And setting field "adat" to "01.12.2006" throws the exception "2201"
#  Tagesdatum gr.*er als max. Buchungsdatum, bitte Jahresabschl
And I close the current editor
