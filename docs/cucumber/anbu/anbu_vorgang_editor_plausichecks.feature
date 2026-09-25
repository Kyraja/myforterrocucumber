# *****************************************************************************
#  Name             : anbu_vorgang_editor_plausichecks.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Hier werden die Plausis bzw. die Aenderbarkeit
#                     im Editor fuer Anlagenvorgang geprueft.
#
#
#   ACHTUNG: Hier wird im Scenario: "Bilanzkonten; Teil 2b, Abschreibungsverbuchung: indirekt -> Wertberichtigungskonto"
#            die AfA-Verbuchung auf 'indirekt' gesetzt!!! -> kann nicht rueckgaengig gemacht werden
#
# *****************************************************************************
@persistent
Feature: ANBU Fehler
Background: Test des Editors fuer Anlage

Given I set the fake date to "01.01.01"


Scenario: fehlende Vorgangsart, fehlende Anlage

# einen neuen Anlagenvorgang anlegen -> Meldung zur fehlenden Vorgangsart
Given I open an editor "anlagenvorg1" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "100VA"
And I set field "vorgart" to ""
And I set field "such" to "LEERVART"
Then saving the current editor throws the exception "Vorgangsart bitte eintragen"
And I set field "vorgart" to "Vollabgang"
Then saving the current editor throws the exception "Bitte erst Anlage eintragen!"
And I set field "anlage" to "440001"
And I respond with answer "Ja" to the dialog with id "4479"
And I save the current editor
# Test abschliessen
And I close the current editor
# =========================================================================================


Scenario: abgegangene Anlage
# einen neuen Anlagenvorgang anlegen -> Meldung zur abgegangenen Anlage
Given I open an editor "anlagenvorg2" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "200VA"
And I set field "vorgart" to "Vollabgang"
And I set field "such" to "VOLLABG"
Then saving the current editor throws the exception "Bitte erst Anlage eintragen!"
And setting field "anlage" to "440001" throws the exception "Anlage nicht bebuchbar: in diesem Buchungskreis bereits abgegangen!"
And I set field "vorgart" to "Teilabgang"
And I set field "anlage" to "520001"
And I set field "auahk" to "500.11"
And I respond with answer "Ja" to the dialog with id "4479"
And I save the current editor

# Test abschliessen
And I close the current editor
# =========================================================================================

Scenario Outline: Bilanzkonten; Teil 1a, neue Konten anlegen

Given I open an editor "bilkonto" from table "(Account):(Account)" with command "COPY" for record "<konto>"
And I set field "nummer" to "<kopienr>"
And I set field "namebspr" to "<namebspr>"
And I set field "gv" to "<gv>"
And I save the current editor
Examples:
| konto | kopienr | gv          | namebspr    |
| 01350 | 01350a  | ja          | Kopie       |
| 02350 | 02350a  | ja          | Kopie       |
| 04400 | 04400a  | ja          | Kopie       |
| 05200 | 05200a  | ja          | Kopie       |
| 05200 | 05200b  | !dontChange | Kopie 05200 |
| 05200 | 05200c  | !dontChange | Kopie 05200 |
# =========================================================================================


Scenario: Bilanzkonten; Teil 1b, Konten eintragen

Given I open an editor "anlage-520002" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "520002"
And I set field "ktozug1" to "01350a"
And I set field "ktozug2" to "02350a"
And I set field "ktozug3" to "04400a"
And I set field "ktoabg1" to "05200c"
And I set field "ktoabg2" to "05200a"
And I set field "ktoabg3" to "99800a"

And I save the current editor
And I close the current editor
# =========================================================================================

Scenario: Bilanzkonten; Teil 2a, Abschreibungsverbuchung: direkt

# einen neuen Anlagenvorgang anlegen -> Meldung bei falschen Konten
# vkoahk1 und vkoafa1
Given I open an editor "anlagenvorg3" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "300VA"
And I set field "vorgart" to "Vollabgang"
And I set field "such" to "VOLLABG"
And I set field "anlage" to "520002"
# ab hier wird getestet
#
# zwar ein alternatives Zugangskonto, aber
And setting field "vkoahk1" to "01350a" throws the exception "Hier nur Bilanzkonten"
And setting field "vkoafa1" to "01350a" throws the exception "Hier nur Bilanzkonten"

# ein alternatives Abgangskonto
And I set field "vkoahk1" to "05200c"
And I set field "vkoafa1" to "05200c"
# ein x-beliebeiges Konto
And setting field "vkoahk1" to "01200" throws the exception "Buchungskonto kein gültiges Konto für verwendete Anlage!"
And setting field "vkoafa1" to "01200" throws the exception "Buchungskonto kein gültiges Konto für verwendete Anlage!"
# Test abschliessen
And I close the current editor


# einen neuen Anlagenvorgang anlegen -> Meldung bei falschen Konten
# vkoahk1 und vkoafa1
Given I open an editor "anlagenvorg3" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "301TA"
And I set field "vorgart" to "Teilabgang"
And I set field "such" to "TEILABG"
And I set field "anlage" to "520002"
# ab hier wird getestet
#
# zwar ein alternatives Zugangskonto, aber
And setting field "vkoahk1" to "01350a" throws the exception "Hier nur Bilanzkonten"
And setting field "vkoafa1" to "01350a" throws the exception "Hier nur Bilanzkonten"
# ein alternatives Abgangskonto
And I set field "vkoahk1" to "05200c"
And I set field "vkoafa1" to "05200c"
# ein stat. Konto
And setting field "vkoahk1" to "99800a" throws the exception "Konto darf kein statistisches Konto sein!"
And setting field "vkoafa1" to "99800a" throws the exception "Konto darf kein statistisches Konto sein!"
# ein x-beliebeiges Konto
And setting field "vkoahk1" to "01200" throws the exception "Buchungskonto kein gültiges Konto für verwendete Anlage!"
And setting field "vkoafa1" to "01200" throws the exception "Buchungskonto kein gültiges Konto für verwendete Anlage!"
# Test abschliessen
And I close the current editor
# =========================================================================================


Scenario: Bilanzkonten; Teil 2b, Abschreibungsverbuchung: indirekt -> Wertberichtigungskonto

Given I open an editor "anu-konfig" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"
And I set field "afabuform" to "indirekt"
And I save the current editor
And I close the current editor


Given I open an editor "anlage-copy" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "520002"
And I set field "nummer" to "20wert"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "wertbko" to "05200b"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-copy"
And I save the current editor
And I close the current editor

# einen neuen Anlagenvorgang anlegen -> Meldung bei falschen Konten
# vkoahk1 und vkoafa1
Given I open an editor "anlagenvorg4" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "400VA"
And I set field "vorgart" to "Vollabgang"
And I set field "such" to "VOLLABG"
And I set field "anlage" to "20wert"
# ab hier wird getestet
#
# Versuch das Berichtigungskonto zu verwenden
And setting field "vkoahk1" to "05200b" throws the exception "Buchungskonto kein gültiges Konto für verwendete Anlage!"
# hier muss es funktionieren
And I set field "vkoafa1" to "05200b"
# ein alternatives Abgangskonto
And I set field "vkoahk1" to "05200c"
And I set field "vkoafa1" to "05200c"
# ein x-beliebeiges Konto
And setting field "vkoahk1" to "01200" throws the exception "Buchungskonto kein gültiges Konto für verwendete Anlage!"
And setting field "vkoafa1" to "01200" throws the exception "Buchungskonto kein gültiges Konto für verwendete Anlage!"
#
# Test abschliessen -> nicht speichern
And I close the current editor
# =========================================================================================


Scenario: STORNO, Button "buchen"

# einen Anlagenvorgang stornieren -> Verbuchung ueber Button 'buchen'
Given I open an editor "stornovorg1" from table "(FixedAsset):(FixedAssetTransaction)" with command "REVERSAL" for record "+100VA"
And I set field "nummer" to "100VA-ST"
And I set field "such" to "STORNO"
# pruefen, ob Button klickbar ist
Then pressing button "buch" throws the exception ""
# In GUI funktionier der Button
# And I press button "buch"
# beim Druecken des Buttons kommt die Meldung "Ungueltige Buttonart buch(0) = []"
# deswegen ueber Speichern
And I save the current editor
And I close the current editor

# Ueberpruefung, ob wirklich storniert wurde
Given I open an editor "anlagenvorg1" from table "(FixedAsset):(FixedAssetTransaction)" with command "VIEW" for record "+100VA"
Then field "storniert" is not empty in row 0
Then field "partnervorgang" is not empty in row 0
Then field "partnervorgang" has value "+100VA-ST"
# Test abschliessen
And I close the current editor
# =========================================================================================

Scenario: Storno stornieren

Given I open an editor "av" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "500VA"
And I set field "vorgart" to "Vollabgang"
And I set field "such" to "VOLLABG"
And I set field "anlage" to "520002"
And I set field "vkoafa1" to "05200"
And I respond with answer "ja" to the dialog with id "4479"
And I save the current editor
And I close the current editor

Given I open an editor "avstorno" from table "(FixedAsset):(FixedAssetTransaction)" with command "REVERSAL" for record "+500VA"
And I set field "nummer" to "500VA-ST"
And I save the current editor
And I close the current editor

Given I open an editor "avstorno" from table "(FixedAsset):(FixedAssetTransaction)" with command "VIEW" for record "+500VA-ST"
Then field "partnervorgang" is not empty in row 0
Then field "partnervorgang" has value "+500VA"
Then field "storniert" has value "nein"
And I close the current editor

Given I open an editor "avstorno" from table "(FixedAsset):(FixedAssetTransaction)" with command "VIEW" for record "+500VA"
Then field "partnervorgang" is not empty in row 0
Then field "partnervorgang" has value "+500VA-ST"
Then field "storniert" has value "ja"
And I close the current editor


Then opening an editor from table "(FixedAsset):(FixedAssetTransaction)" with command "REVERSAL" for record "+500VA" throws the exception "9311"

Then opening an editor from table "(FixedAsset):(FixedAssetTransaction)" with command "REVERSAL" for record "+500VA-ST" throws the exception "9311"

