@persistent
Feature: ue_verwerfen 

# BW2-2128, BW2-2342
# bis auf die Reihenfolge identisch wie refbw_fe_rueckbau_gesamt_nm_sto_rb_ue_verwerfen_cu.feature
# zusätzlich noch Mengeneubewerten am Ende

Background:
Given I set the fake date to "22.01.2002"


Scenario: 02-sto-nm Rückbau aus vorgänger hier stornieren dann noch nachmeldung  
#------------------------------------------------------------------------------
Given I set the fake date to "22.01.2002"

	Given I open an editor "RM1_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record "$,,such==RUECKB_GESAMT_002;bem==gesamt_rb;typ=Rückbau auf abgelegten Fertigungsvorschlag;@ablageart=abgelegt;@maxtreffer=1"
	And I save the current editor

Given I set the fake date to "23.01.2002"

# dispo
And I run Scheduling
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

Given I set the fake date to "24.01.2002"

# Nachmeldung Entnahmemenge und Zeiten nach BA-Abschluss UND Gesamtrückbau:
	Given I open an editor "nach-rmeldung-fuer-gesamt" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for record "$,,such==RUECKB_GESAMT_002;bem==gesamt_rm_2;typ=Rückmeldung;@ablageart=abgelegt;@maxtreffer=1"
	And I set field "mzeit" to "4"
	And I set field "mzeit2" to "3"
	And I set field "mge" to "2" in row 2
	And I set field "bem" to "rb_gesamt_nm_na_sto"
	And I save the current editor

Given I set the fake date to "25.01.2002"

# dispo
And I run Scheduling
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

Given I set the fake date to "26.01.2002"

# Mengenneubewertung
Given I open an editor "mnb" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB" 
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such==LZUG2E1FR-VF;art=E1FR-VF;buart=1;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "24" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

Given I set the fake date to "27.01.2002"

# dispo
And I run Scheduling
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
