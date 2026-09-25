@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "08.01.2002"

# ----------------------
@Lieferschein
Scenario: Kommando <(Purchasing)> LIEFERSCHEIN <(new)>
# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
# Lieferscheinart kann nicht geandert werden.

Given I open an editor "LS1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""

Then field "typa" has value "Lieferschein"
Then field "lief" is modifiable

And I set field "lief" to "TEST"
And I set field "vom" to "." 
And I set field "num4" to "37476ls" 
And I set field "ueb" to "ja" 
And I set field "erfwaehr" to "EUR"

And I create a new row at the end of the table
And I set field "artikel" to "13vo" in row 1
And I set field "mge" to "2" in row 1
And I set field "preis" to "20" in row 1

And I save the current editor
And I close the current editor

# ---------------------
@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) A >
# Given I set the fake date to "09.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.01.2002" 
And I set field "edat" to "." 
And I press button "kosvor"

And I respond with answer "yes" to the dialog with id "2324"
# 5567 ist nur das Fragewort Weiter?, JEDOCH SIND EIGENTLICH FOLGENDE FRAGEN INHALTLICH ENTSCHEIDEND, DIE HIER ANGEZEIGT WERDEN MUESSEN!
# Kostenbuchungen ab Startdatum %s erzeugen. oder...
# Kostenbuchungsvorschlag speichern und Startdatum auf den %s setzen.
And I respond with answer "yes" to the dialog with id "5567"
And I save the current editor

And I close the current editor

@EK-Rechnung
Scenario: Kommando <(Purchasing)> RE <(new)>
Given I set the fake date to "09.01.2002"

Given I open an editor "RE_zu_LS1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "37476ls"
And I set field "num4" to "37476re" 
And I set field "vom" to "." 
And I set field "ueb" to "ja" 

And I respond with answer "yes" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# ---------------------
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "09.01.2002"

Given I open an editor "MN1" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN1SUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art=13vo;buart=1;platz=F2;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "55" in row 1

And I save the current editor
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# ---------------------

@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) B >
Given I set the fake date to "10.01.2002"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"

# SPEZIALFALL NICHT LOESCHEN!
# moechte man den standardfall, haengt man "einfach" direkt noch einen kbv an.
And I set field "buchen" to "nein" in row 2 

And I respond with answer "yes" to the dialog with id "2324"

And I save the current editor
And I close the current editor

