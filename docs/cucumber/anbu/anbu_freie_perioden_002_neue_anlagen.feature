# *****************************************************************************
#  Name             : anbu_freie_perioden_002_neue_anlagen.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : neue Anlagen werden im GJ mit freien Geschaeftsperioden (GP) angelegt
#
#            Hinweis: 7. GeschaeftsPeriode (28.04.2001-27.05.01)
#
# *****************************************************************************
@persistent
Feature: anbu_freie_perioden_002_neue_anlagen.feature
Background: Neuanlage von Anlagen

Given I set the fake date to "01.01.02"


@FALL-Anlage1
Scenario: eine Anlage mit AfA-Beginn am 28.04.2001 (Anfang der GP)

# eine neue Anlage anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "100Anschaffung"
And I set field "modart" to "steuer"
And I set field "such" to "KREISEL"
And I set field "namebspr" to "ANF.644890; REWE-3606;\nAfA-Beginn: Anschaffungsdatum"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "bilkto" to "04400"
And I set field "afaart" to "10010"
And I set field "veregel" to "ja"
And I set field "nmon" to "60"
And I set field "andat" to "04.05.01"
# wegen VE-Regel wird 1. im GP genommen
Then field "afadat" has value "28.04.2001"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor


Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "04.05.01"
And I set field "kenn" to "ZU"
And I set field "inbukreis1" to "ja"
#
And I create a new row at the end of the table
And I set field "konto" to "L 004" in row 1
And I set field "ewhbetr" to "2338.20" in row 1
#
And I create a new row at the end of the table
And I set field "anlage" to "100Anschaffung" in row 2
And I set field "konto" to "04400" in row 2
#
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor


# AfA-Vorschlag fuer die ANlage 100Anschaffung
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "vanl" to "100Anschaffung"
And I set field "banl" to "100Anschaffung"
And I set field "gjahr" to "01"
And I set field "vmon" to "7"
And I set field "bmon" to "7"
And I press button "afaerm"
Then the table has 1 rows
Then field "betrag" has value "38.97" in row 1
And I set field "bmon" to "8"
And I press button "afaerm"
Then the table has 1 rows
Then field "betrag" has value "77.94" in row 1
# das Objekt wird nicht gespeichert
And I close the current editor
# =========================================================================================

@FALL-Anlage2
Scenario: eine Anlage mit AfA-Beginn am 04.05.01


# eine neue Anlage anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "100beliebig"
And I set field "modart" to "steuer"
And I set field "such" to "KREISEL"
And I set field "namebspr" to "ANF.644890; REWE-3606;\nAfA-Beginn: Beginn beliebig"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "bilkto" to "04400"
And I set field "afaart" to "10010"
And I set field "veregel" to "ja"
And I set field "nmon" to "60"
And I set field "andat" to "04.05.01"
# AfA-Beginn beliebig
And I set field "afadat" to "04.05.01"
#And I respond with answer "Ja" to the dialog with id "4475"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor


Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "04.05.01"
And I set field "kenn" to "ZU"
And I set field "inbukreis1" to "ja"
#
And I create a new row at the end of the table
And I set field "konto" to "L 004" in row 1
And I set field "ewhbetr" to "2338.20" in row 1
#
And I create a new row at the end of the table
And I set field "anlage" to "100beliebig" in row 2
And I set field "konto" to "04400" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor


# AfA-Vorschlag fuer die ANlage 100beliebig
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "vanl" to "100beliebig"
And I set field "banl" to "100beliebig"
And I set field "gjahr" to "01"
And I set field "vmon" to "7"
And I set field "bmon" to "7"
And I press button "afaerm"
Then the table has 1 rows
Then field "betrag" has value "38.97" in row 1
And I set field "bmon" to "8"
And I press button "afaerm"
Then the table has 1 rows
Then field "betrag" has value "77.94" in row 1
# das Objekt wird nicht gespeichert
And I close the current editor
# =========================================================================================

@FALL-Anlage3
Scenario: eine Anlage mit AfA-Beginn am 27.05.01 (Ende der GP)


# eine neue Anlage anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "200beliebig"
And I set field "modart" to "steuer"
And I set field "such" to "KREISEL"
And I set field "namebspr" to "ANF.644890; REWE-3606;\nAfA-Beginn: Beginn beliebig"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "bilkto" to "04400"
And I set field "afaart" to "10010"
And I set field "veregel" to "ja"
And I set field "nmon" to "60"
And I set field "andat" to "04.05.01"
# AfA-Beginn beliebig -> letzter Tag im Geschaeftsperiode 7
And I set field "afadat" to "27.05.01"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor


Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "04.05.01"
And I set field "kenn" to "ZU"
And I set field "inbukreis1" to "ja"
#
And I create a new row at the end of the table
And I set field "konto" to "L 004" in row 1
And I set field "ewhbetr" to "2338.20" in row 1
#
And I create a new row at the end of the table
And I set field "anlage" to "200beliebig" in row 2
And I set field "konto" to "04400" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor


# AfA-Vorschlag fuer die ANlage 200beliebig
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "vanl" to "200beliebig"
And I set field "banl" to "200beliebig"
And I set field "gjahr" to "01"
And I set field "vmon" to "7"
And I set field "bmon" to "7"
And I press button "afaerm"
Then the table has 1 rows
Then field "betrag" has value "38.97" in row 1
And I set field "bmon" to "8"
And I press button "afaerm"
Then the table has 1 rows
Then field "betrag" has value "77.94" in row 1
# das Objekt wird nicht gespeichert
And I close the current editor
# =========================================================================================

