# *****************************************************************************
#  Name             : anbu_freie_perioden_001_vorbereitung.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : 
#
#                     Am Ende Termine:
# --------------------------------------------------------------------------------------
# 94    01.01.94    31.12.94    12          vergangen               nein    nein    nein
# 95    01.01.95    31.12.95    12          vergangen               nein    nein    nein
# 96    01.01.96    31.12.96    12          vergangen               nein    nein    nein
# 97    01.01.97    31.12.97    12          vergangen               nein    nein    nein
# 98    01.01.98    31.12.98    12          vergangen               nein    nein    nein
# 99    01.01.99    28.02.99    2           vergangen               nein    nein    nein
# 00-1  01.03.99    29.02.00    12          vergangen               ja      nein    nein
# 00-2  01.03.00    30.10.00    9   13-15   vorl�ufig abgeschlossen ja      nein    nein
# 01    31.10.00    29.10.01    12  1-12    aktuell                 ja      nein    nein
# 02    30.10.01    27.10.02    12  1-12    neu                     ja      nein    nein
# 03    28.10.02    25.10.03    12          zuk�nftig               ja      nein    nein
# --------------------------------------------------------------------------------------

# 
#
# *****************************************************************************
@persistent
Feature: anbu_freie_perioden_001_vorbereitung.feature
Background: Vorbereitungen



@FALL-Termine
Scenario: Termine -> GJ anpassen

Given I'm logged in with password "annette"

Given I open an editor "termine" from table "(Company):(FinancialDates)" with command "UPDATE" for record "2"
And I press button "bsperremand"
#
And I set field "gjenddat" to "ja"
And I set field "nzmon" to "12"
#
And I set field "gjend" to "28.02.99" in row 6
#
And I set field "gjanf" to "01.03.99" in row 7
And I set field "gjend" to "29.02.00" in row 7
And I set field "frdefgm" to "ja" in row 7
#
And I set field "gjanf" to "01.03.00" in row 8
And I set field "gjend" to "30.10.00" in row 8
And I set field "frdefgm" to "ja" in row 8
#
And I set field "gjanf" to "31.10.00" in row 9
And I set field "gjend" to "29.10.01" in row 9
And I set field "frdefgm" to "ja" in row 9
#
And I set field "gjanf" to "30.10.01" in row 10
And I set field "gjend" to "27.10.02" in row 10
And I set field "frdefgm" to "ja" in row 10
#
And I set field "gjanf" to "28.10.02" in row 11
And I set field "gjend" to "25.10.03" in row 11
And I set field "frdefgm" to "ja" in row 11
#
And I delete row at position 13
And I delete row at position 12
#And I delete row at position 11
#
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
# =========================================================================================


Scenario Outline: Abschluesse wiederherstellen

Given I open an editor "abschl<num>" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set field "nummer" to "200zz<num>"
And I set field "such" to "ABSCHL<num>"
And I set field "jastart" to "ja"
And I respond with answer "ja" to the dialog with id "10747"
And I respond with answer "ja" to the dialog with id "7626"
And I save the current editor

Examples: EK/VK
| num|
| 0  |
| 1  |
| 2  |
| 3  |
# =========================================================================================


Scenario: Buchungssynchronisation

Given I'm logged in with password "annette"

Given I open an editor "REWEStammBuchungssynchronisation" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "NEW" for record ""
And I set fields
    | such    | BS345           |
    | bsart   | Alle Verkehrszahlen und Umsatzzähler |
    | bspgj   | 94              |
    | bspbukr | Alle Buchungskreise |
And I save the current editor


Given I open an editor "REWEStammBuchungssynchronisation" from table "(AcctngMasterFiles):(EntrySynchronisation)" with command "UPDATE" for record "BS345"
And I respond with answer "ja" to the dialog with id "7440"
And I press button "bstart"
And I save the current editor

Given I'm logged in with password "sy"
# =========================================================================================


@FALL-Vorbereitung-ANBU

Scenario: Vorbereitung ANBU


# ANBU-Konfiguration anpassen
Given I open an editor "konfig" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"
And I set field "abgbuart" to "Anschaffungskosten"
And I set field "tgafa" to "ja"
And I set field "abve" to "halbjährig"
And I set field "anlvlad" to "ja"
And I set field "negafaabg" to "ja"
#
Then field "nachzug" has value "nein"
Then field "stafakost" has value "ja"
Then field "afabuform" has value "direkt"
Then field "tgafabtr" has value "nein"
Then field "bertagasatz" has value "monatsgenau"
Then field "apedit" has value "nein"
Then field "inbetdatumaktiv" has value "nein"
Then field "anve" has value "halbjährig"
#
And I save the current editor
And I close the current editor

# fehlende Abschreibungsart anlegen
Given I open an editor "afa-art" from table "(FixedAsset):(DepreciationMethod)" with command "NEW" for record ""
And I set field "nummer" to "10010"
And I set field "such" to "AWND"
And I set field "namebspr" to "AW/ND (lineare Afa für abnutzbares AV)"
And I set field "rarta" to "Anschaffungswert/Nutzungsdauer"
And I set field "afako" to "62200"
And I save the current editor
And I close the current editor
# =========================================================================================
