@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf

# ---------------------
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "10.01.2002"

Given I open an editor "MN2" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN2SUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art=13vo;buart=1;platz=F2;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1

And I set field "ntbewpr" to "42" in row 1
# nbewertet

And I save the current editor
And I close the current editor

# ---------------------
@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) C1 >
Given I set the fake date to "10.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"

# SPEZIALFALL NICHT LOESCHEN!
And I set field "buchen" to "nein" in row 2 

And I respond with answer "yes" to the dialog with id "2324"

And I save the current editor
And I close the current editor

# ---------------------
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "11.01.2002"

Given I open an editor "SMN1" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MN1SUCH"
And I set field "such" to "SMN1SUCH" 

And I save the current editor
And I close the current editor

# ---------------------
@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) C2 >
Given I set the fake date to "11.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"

And I respond with answer "yes" to the dialog with id "2324"
And I save the current editor
And I close the current editor


# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# ---------------------

# ========================================
# @EK-Rechnung
# Scenario: Kommando <(Purchasing)> RE <(new)>
# Given I set the fake date to "11.01.2002"
# 
# Given I open an editor "RE_storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+37476re"
# And I set field "num4" to "37476re" 
# 
# And I save the current editor
# And I close the current editor

# ========================================

# ----------------------
@Lieferschein
Scenario: Kommando <(Purchasing)> LIEFERSCHEIN <(new)>
# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
# Lieferscheinart kann nicht geandert werden.
Given I set the fake date to "08.01.2002"

Given I open an editor "LS1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""

Then field "typa" has value "Lieferschein"
Then field "lief" is modifiable

And I set field "lief" to "TEST"
And I set field "vom" to "." 
And I set field "num4" to "37444s" 
And I set field "ueb" to "ja" 
And I set field "erfwaehr" to "EUR"

And I create a new row at the end of the table
And I set field "artikel" to "13vo" in row 1
And I set field "mge" to "2" in row 1
And I set field "preis" to "20" in row 1

And I save the current editor
And I close the current editor
 
# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# ---------------------

@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) A >
Given I set the fake date to "12.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.01.2002" 
And I set field "edat" to "." 
And I press button "kosvor"

And I respond with answer "yes" to the dialog with id "2324"
# 5567=WEITER?, JEDOCH SIND EIGENTLICH FOLGENDE FRAGEN INHALTLICH ENTSCHEIDEND!
# Kostenbuchungen ab Startdatum %s erzeugen. oder...
# Kostenbuchungsvorschlag speichern und Startdatum auf den %s setzen.
# And I respond with answer "yes" to the dialog with id "5667"
And I save the current editor

And I close the current editor

# @Saldenkontrolle
# Scenario: Kommando <(Account) A >
# Given I set the fake date to "12.01.2002"
# 
# Given I open an editor "Konto" from table "(Account):(Account)" with command "VIEW" for record "10020"
# Then field "esakt" has value "84.00"


#                          VERMUTLICH IST FOLGENDER WEG SINNVOLL:
#               VIELE KLEINE PARALLELTESTS - BASIEREND AUF EINIGEN CUCU FEATUREDATEIEN
#               WEGEN : LAGERBESTAND UND KONTENSALDEN MISCHEN SICH ZU SEHR
#     MAN KOENNTE DEN BESTAND NACH JEDEN TEILSTUECK AUF 0 BRINGEN, MACHT ABER 
#     WOHL SEHR WENIG SPASS....
#                * SALDENABFRAGE UEBER DEN EDITOR MACHEN, MUSS UEBERALL GLEICH SEIN
#                * DIE KONTEXTDATEN ABER IMMER MIT ERZEUGEN WIE EINE REFERENZ
#               * TESTS KOENNEN HEISSEN WIE IHR GESCHAEFTSPROZESS

# # ---------------------
# @Mengenneubewertung
# Scenario: Kommando <(QuantityRevaluation)>
# Given I set the fake date to "10.01.2002"
# 
# Given I open an editor "MN2b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
# And I set field "such" to "MN2SUCHB" 
# 
# Then field "vorgang" is modifiable in row 1
# And I set field "vorgang" to "$,,art=13vo;buart=1;platz=F2;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
# 
# And I set field "ntbewpr" to "42" in row 1
# And I set field "nbewertet" to "direkt" in row 1
# 
# And I save the current editor
# And I close the current editor
# 
# # ---------------------
# @Kostenbuchung
# Scenario: Kommando <(CostEntriesSuggestion) C1 >
# Given I set the fake date to "10.01.2002"
# 
# Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
# 
# And I set field "adat" to "01.01.2002"
# And I set field "edat" to "." 
# And I press button "kosvor"
# 
# # And I set field "buchen" to "nein" in row 2 
# 
# And I respond with answer "yes" to the dialog with id "2324"
# 
# And I save the current editor
# And I close the current editor
# 
