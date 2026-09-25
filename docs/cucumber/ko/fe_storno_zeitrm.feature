# *****************************************************************************
#  Name           : fe_storno_zeitrm.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : wane
#  Funktion       : Test des Buchens, Stornierens und wieder Buchens von Arbeits- und Maschinenzeit mit Sonderkosten.
#                   
#
# *****************************************************************************
@persistent
Feature: BW2-955 (Test Bewertungsketten zu R�ckmeldetypen der Art Storno und Zeit)
Background:
Given I set the fake date to "03.02.1995"


Scenario: P1212 Storno einer Zeitbuchung auf einen Arbeitsschein
# Fertigungsvorschlag anlegen, freigeben und Arbeitsschein öffnen
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
	| artikel	| mge	| mfreig	| bisuch	|
	| BAUGRUPPE	| 99	| ja		| JODEL_	|
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor
Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "JODEL_001"
And I close the current editor


# Zeitbuchung und Zeitbuchung öffnen
Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "nummer" from editor "Arbeitsschein1"
And I set field "bem" to "Zeitbuchung JODEL_001 1"
And I set fields
	| bzeit	| 0.5	|
	| mzeit	| 0.5	|
And I save the current editor

# Fertigungskostenverbuchung
Given I create a CostEntriesSuggestion "fkv-111" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitkorrektur stornieren
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=JODEL_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
And I set field "bem" to "Storno JODEL_001 1"
And I save the current editor



# Dann nochmal Zeitbuchung - Sonderkosten müssen in Bewertung sein
Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "nummer" from editor "Arbeitsschein1"
And I set field "bem" to "Zeitbuchung JODEL_001 2"
And I set fields
	| bzeit	| 1.5	|
	| mzeit	| 1.5	|
And I save the current editor
#
Given I open an editor "Zeitkorrektur" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=JODEL_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
And I close the current editor

# Fertigungskostenverbuchung
Given I create a CostEntriesSuggestion "fkv-111" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Und dann noch ein zweites mal eine  Zeitbuchung - diesmal, da das zweite mal, ohne Sonderkosten
Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "nummer" from editor "Arbeitsschein1"
And I set field "bem" to "Zeitbuchung JODEL_001 3"
And I set fields
	| bzeit	| 1.5	|
	| mzeit	| 1.5	|
And I save the current editor
#
Given I open an editor "Zeitkorrektur" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=JODEL_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
And I close the current editor

# Fertigungskostenverbuchung
Given I create a CostEntriesSuggestion "fkv-111" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Und dann noch ein drittes mal eine  Zeitbuchung - diesmal, da das dritte mal, ohne Sonderkosten
Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "nummer" from editor "Arbeitsschein1"
And I set field "bem" to "Zeitbuchung JODEL_001 4"
And I set fields
	| bzeit	| 2.5	|
	| mzeit	| 2.5	|
And I save the current editor
#
Given I open an editor "Zeitkorrektur" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=JODEL_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
And I close the current editor

# Fertigungskostenverbuchung
Given I create a CostEntriesSuggestion "fkv-111" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."


