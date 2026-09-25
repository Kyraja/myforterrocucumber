@persistent
Feature: REWE-2354                      
Background:
Given I set the fake date to "31.01.2002"

# *****************************************************************************
#  Name             : ILV: Test mit sehr vielen Kostenstellen, die nur als Lueckenfueller dienen
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : wane
#  Funktion         : Test der Aufnahme (ausschliesslich) der relevanten Kst in die Matrix zur ILV-Berechnung
#
# *****************************************************************************

Scenario: Stammdaten in der Kore-Konfig und in Fa. TERM erfassen
Given I open an editor "korekonf" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "ilvko" to "99800"
And I set field "ilvks" to "100"
And I set field "ilvauto" to "ja"
And I set field "gekobuch" to "ja"
And I set field "gekoindi" to "ja"
And I save the current editor

Given I open an editor "korekonf" from table "(Company):(FinancialDates)" with command "UPDATE" for record "term"
And I set field "ilviststartgj" to "02"
And I set field "ilviststartgm" to "1"
And I set field "ilvplanstartgj" to "02"
And I set field "ilvplanstartgm" to "1"
And I save the current editor

Scenario: Kostenarten, Bezugsgroessen
Given I open an editor "koart1" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set field "num60" to "99100"
And I set field "such60" to "kbel"
And I set field "prim" to "nein"
And I set field "sekgut" to "nein"
And I save the current editor

Given I open an editor "koart2" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set field "num60" to "99200"
And I set field "such60" to "kent"
And I set field "prim" to "nein"
And I set field "sekgut" to "ja"
And I save the current editor

Given I open an editor "konto1" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "num5" to "99100"
And I set field "such5" to "kbel"
And I set field "name" to "Belastung ILV"
And I set field "gv" to "ja"
And I set field "kost" to "ja"
And I set field "stata" to "Belastung"
And I create a new row at the end of the table
And I set field "zkoart" to "99100" in row 1
And I save the current editor

Given I open an editor "konto2" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "num5" to "99200"
And I set field "such5" to "kent"
And I set field "name" to "Entlastung ILV"
And I set field "gv" to "ja"
And I set field "kost" to "ja"
And I set field "stata" to "Entlastung"
And I create a new row at the end of the table
And I set field "zkoart" to "99200" in row 1
And I save the current editor

Given I open an editor "bg1" from table "(ActivityBase):(ActivityBase)" with command "NEW" for record ""
And I set field "num61" to "100"
And I set field "such61" to "bg1"
And I set field "einheitbz" to "STUECK"
And I save the current editor

Given I open an editor "bg1" from table "(ActivityBase):(ActivityBase)" with command "UPDATE" for record "bg1"
And I set field "gjahr" to "02"
And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "100"
And I set field "s2" to "100"
And I set field "s3" to "100"
And I set field "s4" to "100"
And I set field "s5" to "100"
And I set field "s6" to "100"
And I set field "s7" to "100"
And I set field "s8" to "100"
And I set field "s9" to "100"
And I set field "s10" to "100"
And I set field "s11" to "100"
And I set field "s12" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "bg1"
And I close the current editor
 

Given I open an editor "bg2" from table "(ActivityBase):(ActivityBase)" with command "NEW" for record ""
And I set field "num61" to "200"
And I set field "such61" to "bg2"
And I set field "einheitbz" to "STUECK"
And I save the current editor






