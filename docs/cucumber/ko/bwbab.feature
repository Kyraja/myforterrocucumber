@persistent
Feature: BAB mit Buchungen der Kostenumlage
Background:
Given I set the fake date to "20.12.1995"

# *****************************************************************************
#  Name             : BAB mit Buchungen der Kostenumlage
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Test 
#              * der Buchungen der Kostenumlage im Buchungsnachweis des
#                BAB-Formular
#              * Kontennachweis, Buchungsnachweis: Belegnachweis zu diesem
#                Konto: ja
#
# *****************************************************************************

#***************************************************************************
# Buchungsnachweis bez. Kostenumlagebuchung
#***************************************************************************
Scenario: 

Given I'm logged in with password "annette"
Given I open an editor "termine" from table "(Company):(FinancialDates)" with command "UPDATE" for record "term" 
And I set fields
	| babkoartgj | 1995  |
	| babkoartgm | 1     |
And I save the current editor
Given I'm logged in with password "sy"

#
Given I open an editor "KOArtKostenart-1" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set fields
	| nummer | 99999                    |
	| such   | koart                    |
	| name   | statistische Lohnkosten  |
	| stat   | ja                       |
And I save the current editor
#
Given I open an editor "ko1" from table "(Account):(Account)" with command "UPDATE" for record "50000" 
And I set field "zkoart" to "50000" in row 1
And I set field "koartvon" to "1.01.95" in row 1
And I save the current editor
# Finanzbuchungen korrigieren ?
# TO DO: <?> ja
#
Given I open an editor "ko2" from table "(Account):(Account)" with command "UPDATE" for record "99800" 
And I set field "zkoart" to "99999" in row 1
And I set field "koartvon" to "1.01.95" in row 1
And I save the current editor
# Finanzbuchungen korrigieren ?
# TO DO: <?> ja
#
Given I open an editor "bab" from table "(EDS):(EDS)" with command "NEW" for record "" 
And I set fields
	| nummer   | 100  |
	| such     | bab  |
	| sganmon  | 1    |
	| sgendmon | 12   |
	| skoobj   | 101  |
And I create a new row at the end of the table
And I set field "koart" to "50000" in row 1
And I create a new row at the end of the table
And I set field "koart" to "99999" in row 2
And I save the current editor
#
Given I open an editor "REWEStammBuchungssynchronisation-2" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "NEW" for record ""
And I set fields
	| such  | bs1             |
	| bsart | Kostenrechnung  |
	| bspgj | 95              |
And I save the current editor
#
Given I open an editor "REWEStammBuchungssynchronisation-2" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "UPDATE" for record "BS1"
And I press button "bstart"
And I save the current editor
#***************************************************************************
# Lagerbestand
#***************************************************************************
Given I open an editor "LBuchung" for tip command "Lbuchung" and arguments ""
And I set fields
	| artikel | 1000  |
	| beleg   | 1     |
	| beldat  | .     |
	| buart   | z     |
	| wert    | 50    |
And I append rows
	| mge |
	| 100 |
And I save the current editor

Given I create a CostEntriesSuggestion "mkv-lager" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.12." until enddate "."

#
#***************************************************************************
# Fertigungskosten
#***************************************************************************
#
# Disposition starten
And I run Scheduling
#
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor
And I close the current editor
#
Given I open an editor "Arbeitsschein1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "1001"
And I set field "gut" to "1"
And I set field "sofort" to "1"
And I set field "ma" to "1"
And I set field "lgr" to "1"
And I set field "lart" to "1"
And I set field "bzeit" to "1"
And I set field "mzeit" to "1"
And I set field "ma2" to "1"
And I set field "lgr2" to "1"
And I save the current editor
#
Given I create a CostEntriesSuggestion "mkv-fertigung" with type of cost entry "Verbuchung Fertigungskosten" for startdate "1.12." until enddate "."
#


