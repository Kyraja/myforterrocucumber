# *****************************************************************************
#  Name           : kore_skip_01_kst_gm_gj.feature
#  Autor          : Michael Rothmann
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test von Plausipruefungen GM bei KST,Kostenträger,Kostenart,Rechenregel,Projekt
#
#
# *****************************************************************************
@persistent
Feature: Plausitest Umlageobjekte der Kore
Background:
Given I set the fake date to "1.02.02"
Scenario: 01 Kostenrechnungskonfiguration ändern "ILV umfasst auch Monet 14 = nein"
Given I'm logged in with password "annette"
Given I open an editor "config" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "1"
And I set field "ilvnach14" to "nein"
And I save the current editor
And I close the current editor
Scenario: 02 In einer Kostenstelle getestet
Given I'm logged in with password "sy"
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
Then field "anmon" has value "1"
Then field "endmon" has value "12"
Then field "agjahr" has value "02"
Then field "egjahr" has value "02"
#
#
And I set field "anmon" to "13"
Then field "anmon" has value "13"
And I set field "endmon" to "13"
Then field "endmon" has value "13"
#
# 131: unzulässige Angabe
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
Then setting field "anmon" to "-1" in row 0 throws the exception "131"
Then setting field "endmon" to "-1" in row 0 throws the exception "131"
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
#
# 8125 - Nur die für die ILV gültigen Nachbuchungsmonate sind erlaubt.
Then setting field "anmon" to "14" in row 0 throws the exception "8125"
Then setting field "endmon" to "14" in row 0 throws the exception "8125"
Then setting field "anmon" to "15" in row 0 throws the exception "8125"
Then setting field "endmon" to "15" in row 0 throws the exception "8125"
#
# 641 - Anfangs-/Endmonat darf nicht größer als Anzahl der bebuchb. Monate sein!
Then setting field "anmon" to "16" in row 0 throws the exception "641"
Then setting field "endmon" to "16" in row 0 throws the exception "641"
#
And I close the current editor
# =========================================================================================
Scenario: 03 In einem Kostenträger getestet
Given I open an editor "kt" from table "(Account):(CostObject)" with command "NEW" for record ""
Then field "anmon" has value "1"
Then field "endmon" has value "12"
Then field "agjahr" has value "02"
Then field "egjahr" has value "02"
#
#
And I set field "anmon" to "13"
Then field "anmon" has value "13"
And I set field "endmon" to "13"
Then field "endmon" has value "13"
#
# 131: unzulässige Angabe
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
Then setting field "anmon" to "-1" in row 0 throws the exception "131"
Then setting field "endmon" to "-1" in row 0 throws the exception "131"
#
# 8125 - Nur die für die ILV gültigen Nachbuchungsmonate sind erlaubt.
Then setting field "anmon" to "14" in row 0 throws the exception "8125"
Then setting field "endmon" to "14" in row 0 throws the exception "8125"
Then setting field "anmon" to "15" in row 0 throws the exception "8125"
Then setting field "endmon" to "15" in row 0 throws the exception "8125"
#
# 641 - Anfangs-/Endmonat darf nicht größer als Anzahl der bebuchb. Monate sein!
Then setting field "anmon" to "16" in row 0 throws the exception "641"
Then setting field "endmon" to "16" in row 0 throws the exception "641"
#
And I close the current editor
#
Scenario: 04 In einem Kostenart getestet
Given I open an editor "ka" from table "(CostType):(CostType)" with command "NEW" for record ""
Then field "anmon" has value "1"
Then field "endmon" has value "12"
Then field "agjahr" has value "02"
Then field "egjahr" has value "02"
#
#
And I set field "anmon" to "13"
Then field "anmon" has value "13"
And I set field "endmon" to "13"
Then field "endmon" has value "13"
#
# 131: unzulässige Angabe
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
Then setting field "anmon" to "-1" in row 0 throws the exception "131"
Then setting field "endmon" to "-1" in row 0 throws the exception "131"
#
# 8125 - Nur die für die ILV gültigen Nachbuchungsmonate sind erlaubt.
Then setting field "anmon" to "14" in row 0 throws the exception "8125"
Then setting field "endmon" to "14" in row 0 throws the exception "8125"
Then setting field "anmon" to "15" in row 0 throws the exception "8125"
Then setting field "endmon" to "15" in row 0 throws the exception "8125"
#
# 641 - Anfangs-/Endmonat darf nicht größer als Anzahl der bebuchb. Monate sein!
Then setting field "anmon" to "16" in row 0 throws the exception "641"
Then setting field "endmon" to "16" in row 0 throws the exception "641"
#
And I close the current editor
#
Scenario: 05 In einem Rechenregel getestet
Given I open an editor "rr" from table "(CostType):(ComputationRule)" with command "NEW" for record ""
Then field "anmon" has value "1"
Then field "endmon" has value "12"
Then field "agjahr" has value "02"
Then field "egjahr" has value "02"
#
#
And I set field "anmon" to "13"
Then field "anmon" has value "13"
And I set field "endmon" to "13"
Then field "endmon" has value "13"
#
# 131: unzulässige Angabe
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
Then setting field "anmon" to "-1" in row 0 throws the exception "131"
Then setting field "endmon" to "-1" in row 0 throws the exception "131"
#
# 8125 - Nur die für die ILV gültigen Nachbuchungsmonate sind erlaubt.
Then setting field "anmon" to "14" in row 0 throws the exception "8125"
Then setting field "endmon" to "14" in row 0 throws the exception "8125"
Then setting field "anmon" to "15" in row 0 throws the exception "8125"
Then setting field "endmon" to "15" in row 0 throws the exception "8125"
#
# 641 - Anfangs-/Endmonat darf nicht größer als Anzahl der bebuchb. Monate sein!
Then setting field "anmon" to "16" in row 0 throws the exception "641"
Then setting field "endmon" to "16" in row 0 throws the exception "641"
#
And I close the current editor
#
Scenario: 06 In einem Projekt getestet
Given I open an editor "pr" from table "(Transaction):(Project)" with command "NEW" for record ""
Then field "anmon" has value "1"
Then field "endmon" has value "12"
Then field "agjahr" has value "02"
Then field "egjahr" has value "02"
#
#
And I set field "anmon" to "13"
Then field "anmon" has value "13"
And I set field "endmon" to "13"
Then field "endmon" has value "13"
#
# 131: unzulässige Angabe
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
Then setting field "anmon" to "-1" in row 0 throws the exception "131"
Then setting field "endmon" to "-1" in row 0 throws the exception "131"
#
# 8125 - Nur die für die ILV gültigen Nachbuchungsmonate sind erlaubt.
Then setting field "anmon" to "14" in row 0 throws the exception "8125"
Then setting field "endmon" to "14" in row 0 throws the exception "8125"
Then setting field "anmon" to "15" in row 0 throws the exception "8125"
Then setting field "endmon" to "15" in row 0 throws the exception "8125"
#
# 641 - Anfangs-/Endmonat darf nicht größer als Anzahl der bebuchb. Monate sein!
Then setting field "anmon" to "16" in row 0 throws the exception "641"
Then setting field "endmon" to "16" in row 0 throws the exception "641"
And I close the current editor
# =========================================================================================
# =========================================================================================
Scenario: 07 Kostenrechnungskonfiguration ändern "ILV umfasst auch Monet 14 = ja"
Given I'm logged in with password "annette"
Given I open an editor "config" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "1"
And I set field "ilvnach14" to "ja"
And I save the current editor
And I close the current editor
#
Scenario: 08 In einer Kostenstelle getestet
Given I'm logged in with password "sy"
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
Then field "anmon" has value "1"
Then field "endmon" has value "12"
Then field "agjahr" has value "02"
Then field "egjahr" has value "02"
#
And I set field "anmon" to "13"
Then field "anmon" has value "13"
And I set field "endmon" to "13"
Then field "endmon" has value "13"
#
#
And I set field "anmon" to "14"
Then field "anmon" has value "14"
And I set field "endmon" to "14"
Then field "endmon" has value "14"
#
# 131: unzulässige Angabe
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
Then setting field "anmon" to "-1" in row 0 throws the exception "131"
Then setting field "endmon" to "-1" in row 0 throws the exception "131"
#
# 8125 - Nur die für die ILV gültigen Nachbuchungsmonate sind erlaubt.
Then setting field "anmon" to "15" in row 0 throws the exception "8125"
Then setting field "endmon" to "15" in row 0 throws the exception "8125"
#
# 641 - Anfangs-/Endmonat darf nicht größer als Anzahl der bebuchb. Monate sein!
Then setting field "anmon" to "16" in row 0 throws the exception "641"
Then setting field "endmon" to "16" in row 0 throws the exception "641"
#
And I close the current editor
# =========================================================================================
#
Scenario: 09 In einem Kostenträger getestet
Given I open an editor "kt" from table "(Account):(CostObject)" with command "NEW" for record ""
Then field "anmon" has value "1"
Then field "endmon" has value "12"
Then field "agjahr" has value "02"
Then field "egjahr" has value "02"
#
#
And I set field "anmon" to "13"
Then field "anmon" has value "13"
And I set field "endmon" to "13"
Then field "endmon" has value "13"
#
And I set field "anmon" to "14"
Then field "anmon" has value "14"
And I set field "endmon" to "14"
Then field "endmon" has value "14"
#
# 131: unzulässige Angabe
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
Then setting field "anmon" to "-1" in row 0 throws the exception "131"
Then setting field "endmon" to "-1" in row 0 throws the exception "131"
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
#
# 8125 - Nur die für die ILV gültigen Nachbuchungsmonate sind erlaubt.
Then setting field "anmon" to "15" in row 0 throws the exception "8125"
Then setting field "endmon" to "15" in row 0 throws the exception "8125"
#
# 641 - Anfangs-/Endmonat darf nicht größer als Anzahl der bebuchb. Monate sein!
Then setting field "anmon" to "16" in row 0 throws the exception "641"
Then setting field "endmon" to "16" in row 0 throws the exception "641"
#
And I close the current editor
#
Scenario: 10 In einem Kostenart getestet
Given I open an editor "ka" from table "(CostType):(CostType)" with command "NEW" for record ""
Then field "anmon" has value "1"
Then field "endmon" has value "12"
Then field "agjahr" has value "02"
Then field "egjahr" has value "02"
#
#
And I set field "anmon" to "13"
Then field "anmon" has value "13"
And I set field "endmon" to "13"
Then field "endmon" has value "13"
#
And I set field "anmon" to "14"
Then field "anmon" has value "14"
And I set field "endmon" to "14"
Then field "endmon" has value "14"
#
# 131: unzulässige Angabe
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
Then setting field "anmon" to "-1" in row 0 throws the exception "131"
Then setting field "endmon" to "-1" in row 0 throws the exception "131"
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
#
# 8125 - Nur die für die ILV gültigen Nachbuchungsmonate sind erlaubt.
Then setting field "anmon" to "15" in row 0 throws the exception "8125"
Then setting field "endmon" to "15" in row 0 throws the exception "8125"
#
# 641 - Anfangs-/Endmonat darf nicht größer als Anzahl der bebuchb. Monate sein!
Then setting field "anmon" to "16" in row 0 throws the exception "641"
Then setting field "endmon" to "16" in row 0 throws the exception "641"
#
And I close the current editor
#
Scenario: 11 In einem Rechenregel getestet
Given I open an editor "rr" from table "(CostType):(ComputationRule)" with command "NEW" for record ""
Then field "anmon" has value "1"
Then field "endmon" has value "12"
Then field "agjahr" has value "02"
Then field "egjahr" has value "02"
#
#
And I set field "anmon" to "13"
Then field "anmon" has value "13"
And I set field "endmon" to "13"
Then field "endmon" has value "13"
#
And I set field "anmon" to "14"
Then field "anmon" has value "14"
And I set field "endmon" to "14"
Then field "endmon" has value "14"
#
# 131: unzulässige Angabe
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
Then setting field "anmon" to "-1" in row 0 throws the exception "131"
Then setting field "endmon" to "-1" in row 0 throws the exception "131"
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
#
# 8125 - Nur die für die ILV gültigen Nachbuchungsmonate sind erlaubt.
Then setting field "anmon" to "15" in row 0 throws the exception "8125"
Then setting field "endmon" to "15" in row 0 throws the exception "8125"
#
# 641 - Anfangs-/Endmonat darf nicht größer als Anzahl der bebuchb. Monate sein!
Then setting field "anmon" to "16" in row 0 throws the exception "641"
Then setting field "endmon" to "16" in row 0 throws the exception "641"
#
And I close the current editor
#
Scenario: 12 In einem Projekt getestet
Given I open an editor "pr" from table "(Transaction):(Project)" with command "NEW" for record ""
Then field "anmon" has value "1"
Then field "endmon" has value "12"
Then field "agjahr" has value "02"
Then field "egjahr" has value "02"
#
#
And I set field "anmon" to "13"
Then field "anmon" has value "13"
And I set field "endmon" to "13"
Then field "endmon" has value "13"
#
And I set field "anmon" to "14"
Then field "anmon" has value "14"
And I set field "endmon" to "14"
Then field "endmon" has value "14"
#
# 131: unzulässige Angabe
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
Then setting field "anmon" to "-1" in row 0 throws the exception "131"
Then setting field "endmon" to "-1" in row 0 throws the exception "131"
Then setting field "anmon" to "aa" in row 0 throws the exception "131"
Then setting field "endmon" to "aa" in row 0 throws the exception "131"
#
# 8125 - Nur die für die ILV gültigen Nachbuchungsmonate sind erlaubt.
Then setting field "anmon" to "15" in row 0 throws the exception "8125"
Then setting field "endmon" to "15" in row 0 throws the exception "8125"
#
# 641 - Anfangs-/Endmonat darf nicht größer als Anzahl der bebuchb. Monate sein!
Then setting field "anmon" to "16" in row 0 throws the exception "641"
Then setting field "endmon" to "16" in row 0 throws the exception "641"
#
And I close the current editor

