# *****************************************************************************
#  Name             : anl_indexreihe_wechseln.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Hier werden kalk. Anlagen mit Indexreihen abgeschrieben
#                     bzw. die Abschreibungsberechnung bei Anlagen festgehalten.
#                     Besonderheit:
#                     hier werden die Daten bei Indexreihen monatlich fuer das aktuellen
#                     GJ ergaenzt. Die JahresAfA wird erst Dezember angepasst - unterjaehring werden
#                     Werte aus Indexreihen nicht berücksichtigt.
#
# *****************************************************************************
@persistent
Feature: ANBU Indexreihen
Background: Wechsel von Indexreihen fuer eine Anlage




Scenario: eine Anlage mit Tabelle editieren
# ------------------------------------------------------------
# bis November 2000
# ------------------------------------------------------------
Given I set the fake date to "1.12.00"


Given I open an editor "anlage-10a" from table "(FixedAsset):(IndexSeries)" with command "UPDATE" for record "10monatl"
And I append rows
	| startdat |   enddat | infla |
	| 20001101 | 20001130 |   1.0 |
And I save the current editor


Given I open an editor "anlage-11a" from table "(FixedAsset):(IndexSeries)" with command "UPDATE" for record "11monatl"
And I append rows
	| startdat |   enddat | infla |
	| 20001101 | 20001130 |  0.05 |
And I save the current editor


# AfA-Vorschlag fuer Anlagen "10monat!11monat"
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "00"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "11"
And I set field "vanl" to "10monat"
And I set field "banl" to "11monat"
And I press button "afaerm"
Then the table has 2 rows
Then field "buanlage" has value "10monat" in row 1
Then field "betrag" has value "416.67" in row 1
Then field "buanlage" has value "11monat" in row 2
Then field "betrag" has value "416.67" in row 2
And I respond with answer "Ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# Kontrolle: Ist-VKZ (Zeigen)

# eine Anlage bzw. VKZ laden
Given I open an editor "anlage10-vkz-november" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "10monat"
And I set field "modart" to "kalk"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "modart" has value "kalkulatorisch"
# Reiter 'Abschreibungsberechnung'
Then field "bemgr1" has value "50000.00"
Then field "bemgr12" has value "50000.00"
Then field "afabtr1" has value "416.67"
Then field "afabtr9" has value "416.67"
Then field "afabtr10" has value "416.67"
Then field "afabtr11" has value "416.67"
Then field "afabtr12" has value "416.67"
Then field "mind" has value "0.00"
Then field "kafabtr" has value "5000.04"
# Reiter 'Anfangs- und Endwerte'
Then field "afafehl" has value "0"
Then field "afaftxt" is empty
And I close the current editor
And I switch the current editor to editor "anlage10-vkz-november"
# Test abschliessen
And I close the current editor


# eine Anlage bzw. VKZ laden
Given I open an editor "anlage11-vkz-november" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "11monat"
And I set field "modart" to "kalk"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "modart" has value "kalkulatorisch"
# Reiter 'Abschreibungsberechnung'
Then field "bemgr1" has value "50000.00"
Then field "bemgr12" has value "50000.00"
Then field "afabtr1" has value "416.67"
Then field "afabtr9" has value "416.67"
Then field "afabtr10" has value "416.67"
Then field "afabtr11" has value "416.67"
Then field "afabtr12" has value "416.67"
Then field "mind" has value "0.00"
Then field "kafabtr" has value "5000.04"
# Reiter 'Anfangs- und Endwerte'
Then field "afafehl" has value "0"
Then field "afaftxt" is empty
And I close the current editor
And I switch the current editor to editor "anlage11-vkz-november"
# Test abschliessen
And I close the current editor


# ------------------------------------------------------------
# bis Dezember 2000
# ------------------------------------------------------------
Given I set the fake date to "1.01.01"


Given I open an editor "anlage-10b" from table "(FixedAsset):(IndexSeries)" with command "UPDATE" for record "10monatl"
And I append rows
	| startdat |   enddat | infla |
	| 20001201 | 20001231 |   1.0 |
And I save the current editor

Given I open an editor "anlage-11b" from table "(FixedAsset):(IndexSeries)" with command "UPDATE" for record "11monatl"
And I append rows
	| startdat |   enddat | infla |
	| 20001201 | 20001231 |  0.05 |
And I save the current editor


# AfA-Vorschlag fuer Anlagen "10monat!11monat"
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "00"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "10monat"
And I set field "banl" to "11monat"
And I press button "afaerm"
Then the table has 2 rows
Then field "buanlage" has value "10monat" in row 1
Then field "betrag" has value "466.63" in row 1
Then field "buanlage" has value "11monat" in row 2
Then field "betrag" has value "419.63" in row 2
And I respond with answer "Ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# Kontrolle: Ist-VKZ (Zeigen)

# eine Anlage bzw. VKZ laden
Given I open an editor "anlage10-vkz-dezember" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "10monat"
And I set field "modart" to "kalk"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "modart" has value "kalkulatorisch"
# Reiter 'Abschreibungsberechnung'
Then field "bemgr1" has value "50500.00"
Then field "bemgr12" has value "50500.00"
Then field "afabtr1" has value "420.83"
Then field "afabtr9" has value "420.83"
Then field "afabtr10" has value "420.83"
Then field "afabtr11" has value "420.83"
Then field "afabtr12" has value "420.83"
Then field "mind" has value "0.00"
Then field "kafabtr" has value "5049.96"
# Reiter 'Anfangs- und Endwerte'
Then field "afafehl" has value "0"
Then field "afaftxt" is empty
And I close the current editor
And I switch the current editor to editor "anlage10-vkz-dezember"
# Test abschliessen
And I close the current editor


# eine Anlage bzw. VKZ laden
Given I open an editor "anlage11-vkz-dezember" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "11monat"
And I set field "modart" to "kalk"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "modart" has value "kalkulatorisch"
# Reiter 'Abschreibungsberechnung'
Then field "bemgr1" has value "50025.00"
Then field "bemgr12" has value "50025.00"
Then field "afabtr1" has value "416.88"
Then field "afabtr9" has value "416.88"
Then field "afabtr10" has value "416.88"
Then field "afabtr11" has value "416.88"
Then field "afabtr12" has value "416.88"
Then field "mind" has value "0.00"
Then field "kafabtr" has value "5002.56"
# Reiter 'Anfangs- und Endwerte'
Then field "afafehl" has value "0"
Then field "afaftxt" is empty
And I close the current editor
And I switch the current editor to editor "anlage11-vkz-dezember"
# Test abschliessen
And I close the current editor



# ------------------------------------------------------------
# bis Januar 2001
# ------------------------------------------------------------
Given I set the fake date to "1.02.01"


Given I open an editor "anlage-10c" from table "(FixedAsset):(IndexSeries)" with command "UPDATE" for record "10monatl"
And I append rows
	| startdat |   enddat | infla |
	| 20010101 | 20010131 |   2.0 |
And I save the current editor

Given I open an editor "anlage-11c" from table "(FixedAsset):(IndexSeries)" with command "UPDATE" for record "11monatl"
And I append rows
	| startdat |   enddat | infla |
	| 20010101 | 20010131 |   1.0 |
And I save the current editor

# AfA-Vorschlag fuer Anlagen "10monat!11monat"
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "01"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "1"
And I set field "vanl" to "10monat"
And I set field "banl" to "11monat"
And I press button "afaerm"
Then the table has 2 rows
Then field "buanlage" has value "10monat" in row 1
Then field "betrag" has value "215.17" in row 1
Then field "buanlage" has value "11monat" in row 2
Then field "betrag" has value "213.14" in row 2
And I respond with answer "Ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# Kontrolle: Ist-VKZ (Zeigen) im Aendern-Modus wegen GJ und Waehrung

# eine Anlage bzw. VKZ laden
Given I open an editor "anlage10-vkz-januar" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "10monat"
And I set field "modart" to "kalk"
And I set field "gjahr" to "01"
And I set field "mwaehr" to "EUR"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "modart" has value "kalkulatorisch"
# Reiter 'Abschreibungsberechnung'
Then field "bemgr1" has value "23238.22"
Then field "bemgr12" has value "23238.22"
Then field "afabtr1" has value "215.17"
Then field "afabtr9" has value "215.17"
Then field "afabtr10" has value "215.17"
Then field "afabtr11" has value "215.17"
Then field "afabtr12" has value "215.17"
Then field "mind" has value "0.00"
Then field "kafabtr" has value "2582.04"
# Reiter 'Anfangs- und Endwerte'
Then field "afafehl" has value "0"
Then field "afaftxt" is empty
And I close the current editor
And I switch the current editor to editor "anlage10-vkz-januar"
# Test abschliessen
And I close the current editor


# eine Anlage bzw. VKZ laden
Given I open an editor "anlage11-vkz-januar" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "11monat"
And I set field "modart" to "kalk"
And I set field "gjahr" to "01"
And I set field "mwaehr" to "EUR"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "modart" has value "kalkulatorisch"
# Reiter 'Abschreibungsberechnung'
Then field "bemgr1" has value "23019.38"
Then field "bemgr12" has value "23019.38"
Then field "afabtr1" has value "213.14"
Then field "afabtr9" has value "213.14"
Then field "afabtr10" has value "213.14"
Then field "afabtr11" has value "213.14"
Then field "afabtr12" has value "213.14"
Then field "mind" has value "0.00"
Then field "kafabtr" has value "2557.68"
# Reiter 'Anfangs- und Endwerte'
Then field "afafehl" has value "0"
Then field "afaftxt" is empty
And I close the current editor
And I switch the current editor to editor "anlage11-vkz-januar"
# Test abschliessen
And I close the current editor


# ------------------------------------------------------------
# bis Februar 2001
# ------------------------------------------------------------
Given I set the fake date to "1.03.01"


Given I open an editor "anlage-10d" from table "(FixedAsset):(IndexSeries)" with command "UPDATE" for record "10monatl"
And I append rows
	| startdat |   enddat | infla |
	| 20010201 | 20010228 |   2.0 |
And I save the current editor

Given I open an editor "anlage-11d" from table "(FixedAsset):(IndexSeries)" with command "UPDATE" for record "11monatl"
And I append rows
	| startdat |   enddat | infla |
	| 20010201 | 20010228 |   1.0 |
And I save the current editor

# AfA-Vorschlag fuer Anlagen "10monat!11monat"
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "01"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "2"
And I set field "vanl" to "10monat"
And I set field "banl" to "11monat"
And I press button "afaerm"
Then the table has 2 rows
Then field "buanlage" has value "10monat" in row 1
Then field "betrag" has value "215.17" in row 1
Then field "buanlage" has value "11monat" in row 2
Then field "betrag" has value "213.14" in row 2
And I respond with answer "Ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# Kontrolle: Ist-VKZ (Zeigen) im Aendern-Modus wegen GJ und Waehrung

# eine Anlage bzw. VKZ laden
Given I open an editor "anlage10-vkz-januar" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "10monat"
And I set field "modart" to "kalk"
And I set field "gjahr" to "01"
And I set field "mwaehr" to "EUR"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "modart" has value "kalkulatorisch"
# Reiter 'Abschreibungsberechnung'
Then field "bemgr1" has value "23238.22"
Then field "bemgr12" has value "23238.22"
Then field "afabtr1" has value "215.17"
Then field "afabtr9" has value "215.17"
Then field "afabtr10" has value "215.17"
Then field "afabtr11" has value "215.17"
Then field "afabtr12" has value "215.17"
Then field "mind" has value "0.00"
Then field "kafabtr" has value "2582.04"
# Reiter 'Anfangs- und Endwerte'
Then field "afafehl" has value "0"
Then field "afaftxt" is empty
And I close the current editor
And I switch the current editor to editor "anlage10-vkz-januar"
# Test abschliessen
And I close the current editor


# eine Anlage bzw. VKZ laden
Given I open an editor "anlage11-vkz-januar" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "11monat"
And I set field "modart" to "kalk"
And I set field "gjahr" to "01"
And I set field "mwaehr" to "EUR"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "modart" has value "kalkulatorisch"
# Reiter 'Abschreibungsberechnung'
Then field "bemgr1" has value "23019.38"
Then field "bemgr12" has value "23019.38"
Then field "afabtr1" has value "213.14"
Then field "afabtr9" has value "213.14"
Then field "afabtr10" has value "213.14"
Then field "afabtr11" has value "213.14"
Then field "afabtr12" has value "213.14"
Then field "mind" has value "0.00"
Then field "kafabtr" has value "2557.68"
# Reiter 'Anfangs- und Endwerte'
Then field "afafehl" has value "0"
Then field "afaftxt" is empty
And I close the current editor
And I switch the current editor to editor "anlage11-vkz-januar"
# Test abschliessen
And I close the current editor



