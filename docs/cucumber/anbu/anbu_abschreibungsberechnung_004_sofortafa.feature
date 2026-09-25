# *****************************************************************************
#  Name             : anbu_abschreibungsberechnung_004_sofortafa.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Hier wird die Beruecksichtigung von dem Errinerungswert bei
#                     steuerlichen Anlagen geprueft
#
# *****************************************************************************
@persistent
Feature: anbu_abschreibungsberechnung_001_errinerungswert.feature
Background:

Given I set the fake date to "7.1.01"


Scenario: ANBU-Konfiguration anpassen: Nachtraegliche Zugaenge monatsgenau + "Errinerungswert = 0.00" + SofortAfA


# Vorbereitung ANBU

# Feld "Nachtraegliche Zugaenge monatsgenau" ist nur in "Wartung" aenderbar
Given I'm logged in with password "annette"

# ANBU-Konfiguration anpassen
Given I open an editor "konfig" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"
Then field "nachzug" has value "nein"
Then field "anve" has value "halbjährig"
And I set field "nachzug" to "ja"
And I set field "anve" to ""
#
Then field "anve" has value ""
Then field "nachzug" has value "ja"
Then field "stafakost" has value "ja"
Then field "afabuform" has value "direkt"
Then field "tgafabtr" has value "nein"
Then field "bertagasatz" has value "monatsgenau"
Then field "apedit" has value "nein"
Then field "inbetdatumaktiv" has value "nein"
#
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
# =========================================================================================

Scenario Outline: Nachtraegliche Zugaenge monatsgenau + "Errinerungswert" + SofortAfA

# eine Anlage bzw. VKZ laden
Given I open an editor "anlage-vkz" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "<anlage>"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
# Reiter 'Abschreibungsberechnung'
Then field "bemgr1" has value "<bemgr1>"
Then field "bemgr12" has value "<bemgr12>"
Then field "afabtr1" has value "<afabtr1>"
Then field "afabtr9" has value "<afabtr9>"
Then field "afabtr10" has value "<afabtr10>"
Then field "afabtr11" has value "<afabtr11>"
Then field "afabtr12" has value "<afabtr12>"
Then field "mind" has value "<mind>"
Then field "kafabtr" has value "<kafabtr>"
# Reiter 'Anfangs- und Endwerte'
Then field "afafehl" has value "0"
Then field "afaftxt" is empty
And I close the current editor
And I switch the current editor to editor "anlage-vkz"
# Test abschliessen
And I save the current editor

Examples:
    | anlage | bemgr1  | bemgr12 | afabtr1 | afabtr9 | afabtr10 | afabtr11 | afabtr12 | mind   | kafabtr  | gldiff |
    | 1gwg   | 1200.00 | 1800.00 | 100.00  | 100.00  | 100.00   | 100.00   |  699.00  |   1.00 | 1799.00  |   0.00 |
    | 2gwg   |    0.00 | 1200.00 |   0.00  |   0.00  |   0.00   |   0.00   | 1199.00  |   1.00 | 1199.00  |   0.00 |
    | 3gwg   | 1200.00 | 1332.00 | 100.00  | 100.00  |  50.00   | 110.00   |   22.00  | 250.00 | 1082.00  |   0.00 |
    | 4gwg   | 1200.00 | 1200.00 | 100.00  | 100.00  |  50.00   |   0.00   |    0.00  | 250.00 |  950.00  |   0.00 |
# =========================================================================================

Scenario: ANBU-Konfiguration zuruecksetzen

Given I'm logged in with password "annette"


Given I open an editor "konfig-zurueck" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"
Then field "nachzug" has value "ja"
Then field "anve" has value ""
And I set field "nachzug" to "nein"
And I set field "anve" to "halbjährig"
#
Then field "anve" has value "halbjährig"
Then field "nachzug" has value "nein"
Then field "stafakost" has value "ja"
Then field "afabuform" has value "direkt"
Then field "tgafabtr" has value "nein"
Then field "bertagasatz" has value "monatsgenau"
Then field "apedit" has value "nein"
Then field "inbetdatumaktiv" has value "nein"
#
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
# =========================================================================================
