# *****************************************************************************
#  Name             : anbu_tagesgenau_abschreibungsberechnung_001_afaplannung.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : 
#
# *****************************************************************************
@persistent
Feature: anbu_tagesgenau_abschreibungsberechnung_001_afaplannung.feature
Background: Tagesgenaue AFA in der Anbu-Konfig

Given I set the fake date to "7.1.01"


@FALL-AHK/ND
Scenario: Abschreibungsart = Anschaffungskosten/Nutzungsdauer

# eine neuangelegte steuerl. Anlage ueberwachen
Given I open an editor "anlage-view10" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "700st"
# Abschreibungsart = Anschaffungskosten/Nutzungsdauer
Then field "wg" has value "10150"
#
Then field "andat" has value "23.11.2000"
Then field "uebahk" has value "10000.00"
Then field "nmon" has value "24"
Then field "restnutzdau" has value "24"
Then field "hiafa" has value "0.00"
Then field "erinnerwert" has value "1.00"
#
#
And I set field "berplafa" to "ja"
Then field "gjafapl1" has value "01"
Then field "gjafapl2" has value "02"
Then field "gjafapl3" has value "03"
Then field "gjafapl4" has value "04"
Then field "gjafapl5" has value "05"
Then field "gjafapl6" has value "06"
Then field "gjafapl7" has value ""
#
Then field "afaplan1" has value "5000.00"
Then field "afaplan2" has value "4471.00"
Then field "afaplan3" has value "0.00"
Then field "afaplan4" has value "0.00"
Then field "afaplan5" has value "0.00"
Then field "afaplan6" has value "0.00"
Then field "afaplan7" has value "0.00"

#
Then field "rbwplan1" has value "4472.00"
Then field "rbwplan2" has value "1.00"
Then field "rbwplan3" has value "1.00"
Then field "rbwplan4" has value "1.00"
Then field "rbwplan5" has value "1.00"
Then field "rbwplan6" has value "1.00"
Then field "rbwplan7" has value "0.00"
#
And I close the current editor


# Abschreibung der Anlage fuer 2000
# AFA in 2001= 528, 00 EUR
#
# AfA-Vorschlag fuer 1-14 2000
Given I open an editor "vorschlag-10" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "100a1"
And I set field "gjahr" to "00"
And I set field "vmon" to "1"
And I set field "bmon" to "14"
And I set field "vanl" to "700st"
And I set field "banl" to "700st"
And I press button "afaerm"
Then the table has 1 rows
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

Given I open an editor "vorschlag-11" from table "(FixedAsset):(DepreciationSuggestion)" with command "VIEW" for record "+100a1"
Then field "buanlage" has value "700st" in row 1
Then field "buanlage" has value "700st" in row 1
Then the table has 1 rows
And I close the current editor


# Anlage laden und Planabschreibung pruefen
# Restbuchwert zu Beginn von 2001: 9472
Given I open an editor "anlage-view11" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "700st"
# Abschreibungsart = Anschaffungskosten/Nutzungsdauer
Then field "wg" has value "10150"
Then field "andat" has value "23.11.2000"
Then field "uebahk" has value "10000.00"
Then field "nmon" has value "24"
#
Then field "hirbw" has value "9472.00"
Then field "restnutzdau" has value "22"
Then field "hiafa" has value "528.00"
Then field "erinnerwert" has value "1.00"
#
#
And I set field "berplafa" to "ja"
Then field "gjafapl1" has value "01"
Then field "gjafapl2" has value "02"
Then field "gjafapl3" has value "03"
Then field "gjafapl4" has value "04"
Then field "gjafapl5" has value "05"
Then field "gjafapl6" has value "06"
Then field "gjafapl7" has value ""
#
Then field "afaplan1" has value "5000.00"
Then field "afaplan2" has value "4471.00"
Then field "afaplan3" has value "0.00"
Then field "afaplan4" has value "0.00"
Then field "afaplan5" has value "0.00"
Then field "afaplan6" has value "0.00"
Then field "afaplan7" has value "0.00"

#
Then field "rbwplan1" has value "4472.00"
Then field "rbwplan2" has value "1.00"
Then field "rbwplan3" has value "1.00"
Then field "rbwplan4" has value "1.00"
Then field "rbwplan5" has value "1.00"
Then field "rbwplan6" has value "1.00"
Then field "rbwplan7" has value "0.00"
#
And I close the current editor
# =========================================================================================





@FALL-RBW/RND
Scenario: Abschreibungsart = Restbuchwert/Restnutzungsdauer

# eine neuangelegte steuerl. Anlage ueberwachen
Given I open an editor "anlage-view20" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "800st"
# Abschreibungsart = Anschaffungskosten/Nutzungsdauer
Then field "wg" has value "10160"
#
Then field "andat" has value "23.11.2000"
Then field "uebahk" has value "10000.00"
Then field "nmon" has value "24"
Then field "restnutzdau" has value "24"
Then field "hiafa" has value "0.00"
Then field "erinnerwert" has value "1.00"
#
#
And I set field "berplafa" to "ja"
Then field "gjafapl1" has value "01"
Then field "gjafapl2" has value "02"
Then field "gjafapl3" has value "03"
Then field "gjafapl4" has value "04"
Then field "gjafapl5" has value "05"
Then field "gjafapl6" has value "06"
Then field "gjafapl7" has value ""
#
Then field "afaplan1" has value "5167.00"
Then field "afaplan2" has value "4304.00"
Then field "afaplan3" has value "0.00"
Then field "afaplan4" has value "0.00"
Then field "afaplan5" has value "0.00"
Then field "afaplan6" has value "0.00"
Then field "afaplan7" has value "0.00"

#
Then field "rbwplan1" has value "4305.00"
Then field "rbwplan2" has value "1.00"
Then field "rbwplan3" has value "1.00"
Then field "rbwplan4" has value "1.00"
Then field "rbwplan5" has value "1.00"
Then field "rbwplan6" has value "1.00"
Then field "rbwplan7" has value "0.00"
#
And I close the current editor


# Abschreibung der Anlage fuer 2000
# AFA in 2001= 528, 00 EUR
#
# AfA-Vorschlag fuer 1-14 2000
Given I open an editor "vorschlag-20" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "100a2"
And I set field "gjahr" to "00"
And I set field "vmon" to "1"
And I set field "bmon" to "14"
And I set field "vanl" to "800st"
And I set field "banl" to "800st"
And I press button "afaerm"
Then the table has 1 rows
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

Given I open an editor "vorschlag-21" from table "(FixedAsset):(DepreciationSuggestion)" with command "VIEW" for record "+100a2"
Then field "buanlage" has value "800st" in row 1
Then field "buanlage" has value "800st" in row 1
Then the table has 1 rows
And I close the current editor


# Anlage laden und Planabschreibung pruefen
# Restbuchwert zu Beginn von 2001: 9472
Given I open an editor "anlage-view21" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "800st"
# Abschreibungsart = Anschaffungskosten/Nutzungsdauer
Then field "wg" has value "10160"
Then field "andat" has value "23.11.2000"
Then field "uebahk" has value "10000.00"
Then field "nmon" has value "24"
#
Then field "hirbw" has value "9472.00"
Then field "restnutzdau" has value "22"
Then field "hiafa" has value "528.00"
Then field "erinnerwert" has value "1.00"
#
#
And I set field "berplafa" to "ja"
Then field "gjafapl1" has value "01"
Then field "gjafapl2" has value "02"
Then field "gjafapl3" has value "03"
Then field "gjafapl4" has value "04"
Then field "gjafapl5" has value "05"
Then field "gjafapl6" has value "06"
Then field "gjafapl7" has value ""
#
Then field "afaplan1" has value "5167.00"
Then field "afaplan2" has value "4304.00"
Then field "afaplan3" has value "0.00"
Then field "afaplan4" has value "0.00"
Then field "afaplan5" has value "0.00"
Then field "afaplan6" has value "0.00"
Then field "afaplan7" has value "0.00"

#
Then field "rbwplan1" has value "4305.00"
Then field "rbwplan2" has value "1.00"
Then field "rbwplan3" has value "1.00"
Then field "rbwplan4" has value "1.00"
Then field "rbwplan5" has value "1.00"
Then field "rbwplan6" has value "1.00"
Then field "rbwplan7" has value "0.00"
#
And I close the current editor
# =========================================================================================



