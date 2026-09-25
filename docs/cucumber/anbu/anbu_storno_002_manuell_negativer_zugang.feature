# *****************************************************************************
#  Name             : anbu_storno_002_manuell_negativer_zugang.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : XXXXXXXXX
#
# *****************************************************************************
@persistent
Feature: anbu_storno_002_manuell_negativer_zugang.feature
Background: Test des Editors fuer AfA-Vorschlag

Given I set the fake date to "01.01.01"


Scenario: 1: man. Storno drei Monat spaeter

# das Szenario ist etwas seltsam, abermoeglich!
# Hier wird:
# 1. eine Anlage angelegt               - Januar
# 2. man. Zugang auf die Anlage         - Januar
# 3. ANlage fÅr 3 Monate abgeschrieben  - Maerz
# 4. Zugangsbuchung manuell storniert   - April
# 5. manuell stornierter Zugang wieder storniert - Juni


Given I open an editor "anlage-1001" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "100mzug"
And I set field "such" to "MAN1"
And I set field "modart" to "steuer"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "wg" to "1008"
And I set field "kstelle" to "101"
And I set field "andat" to "01.01."
And I set field "erinnerwert" to "1.00"
#
Then field "nmon" has value "120"
Then field "restnutzdau" has value "120"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1001"
And I save the current editor


# Manuelle Buchung: Zugang
Given I open an editor "buchung-zugang1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "BZU1" in row 0
And I set field "kenn" to "ZU" in row 0
And I set field "beleg" to "ZU1" in row 0
And I set field "beldat" to "07.01.01" in row 0
And I set field "budat" to "07.01.01" in row 0
And I create a new row at the end of the table
And I set field "anlage" to "100mzug" in row 1
And I set field "sbetrag" to "20000" in row 1
And I create a new row at the end of the table
And I set field "konto" to "35010" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
Then message "Zugang auf Anlage verbucht" was displayed
And I close the current editor


# AfA-Vorschlag fuer 1-3 2002
Given I open an editor "vorschlag-1001" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "01a100mzug"
And I set field "gjahr" to "01"
And I set field "vmon" to "1"
And I set field "bmon" to "3"
And I set field "vanl" to "100mzug"
And I set field "banl" to "100mzug"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "100mzug" in row 1
Then field "betrag" has value "500.01" in row 1
Then field "tkstelle" has value "101" in row 1
Then field "tafaftxt" is empty in row 1
#And I press button "buch"
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor


# Zugang AHK manuell stornieren
Given I open an editor "ahk-storno-manuell" via ID from editor "buchung-zugang1" from field "num6" in row 0 for table "(Entry):(Entry)" with command "COPY"
And I press button "storno"
And I set field "budat" to "30.04."
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor


# STORNO-Zugang AHK manuell stornieren - 3 Monate spaeter
Given I open an editor "ahk-buchung" via ID from editor "ahk-storno-manuell" from field "num6" in row 0 for table "(Entry):(Entry)" with command "COPY"
And I press button "storno"
And I set field "budat" to "30.07."
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor


# die Anlage laden
Given I open an editor "anlage-1001-view" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "100mzug"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "annum" is not modifiable
Then field "annum" has value "100mzug"
###################
# Reiter 'Abschreibungsberechnung'
###################
Then field "afabtr1" has value "166.67"
Then field "afabtr2" has value "166.67"
Then field "afabtr3" has value "166.67"
Then field "afabtr4" has value "166.67"
Then field "afabtr5" has value "166.67"
Then field "afabtr6" has value "166.67"
Then field "afabtr7" has value "166.67"
Then field "afabtr8" has value "166.67"
Then field "afabtr9" has value "166.67"
Then field "afabtr10" has value "166.67"
Then field "afabtr11" has value "166.67"
Then field "afabtr12" has value "166.67"
#
Then field "bemgr1" has value "20000.00"
Then field "bemgr2" has value "20000.00"
Then field "bemgr3" has value "20000.00"
Then field "bemgr4" has value "20000.00"
Then field "bemgr5" has value "20000.00"
Then field "bemgr6" has value "20000.00"
Then field "bemgr7" has value "20000.00"
Then field "bemgr8" has value "20000.00"
Then field "bemgr9" has value "20000.00"
Then field "bemgr10" has value "20000.00"
Then field "bemgr11" has value "20000.00"
Then field "bemgr12" has value "20000.00"
#
Then field "rnad1" has value "120"
Then field "rnad2" has value "120"
Then field "rnad3" has value "120"
Then field "rnad4" has value "120"
Then field "rnad5" has value "120"
Then field "rnad6" has value "120"
Then field "rnad7" has value "120"
Then field "rnad8" has value "120"
Then field "rnad9" has value "120"
Then field "rnad10" has value "120"
Then field "rnad11" has value "120"
Then field "rnad12" has value "120"
#
Then field "kafabtr" has value "2000.04"
Then field "gldiff" has value "0.04"
#
And I close the current editor
And I switch the current editor to editor "anlage-1001-view"

# Test abschliessen
And I save the current editor
# =========================================================================================
