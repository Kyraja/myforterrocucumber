# *****************************************************************************
#  Name             : anbu_abschreibungsberechnung_001_errinerungswert.feature
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


Scenario Outline: alt-Anlagen

# alt-Anlagen mit 24,36 Monaten ND anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "modart" to "steuer"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set fields
    | afaart      | 10001         |
    | kstelle     | 100           |
    | andat       | <andat>       |
    | nmon        | <nmon>        |
    | erinnerwert | <erinnerwert> |
    | bilkto      | 05200         |
    | abwuebdat   | 01.01.        |
    | erafa       | <erafa>       |
And I respond with answer "Ja" to the dialog with id "4476"
And I set field "uebahk" to "<uebahk>"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor
Examples:
    | nummer | such      | namebspr               | andat    | nmon | erinnerwert | uebahk  | erafa   |
    | 1anl   | PKW2JAHRE | 2 Jahre                | 01.01.00 | 24   | 1.00        | 2400.00 | 1200.00 |
    | 2anl   | PKW3JAHRE | Erinnerwert > mtl AfA  | 01.01.99 | 36   | 250.00      | 3600.00 | 2400.00 |
    | 3anl   | PKW1CENT  | Erinnerwert sehr klein | 01.01.99 | 36   | 0.01        | 3600.00 | 2400.00 |
    | 4anl   | PKW0CENT  | Erinnerwert 0.00       | 01.01.00 | 24   | 0.00        |  698.00 |  349.00 |
    | 5anl   | PKW0CENT  | Erinnerwert 0.05       | 01.01.00 | 24   | 0.05        |  698.00 |  349.00 |
# =========================================================================================


Scenario Outline: GWG mit einem Zugang im letzten Nutzungsmonat

# neue Anlagen mit 6 und 12 Monaten ND anlegen - GWG;
Given I open an editor "anlage-2" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "modart" to "steuer"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set fields
    | afaart      | 10007         |
    | kstelle     | 100           |
    | andat       | <andat>       |
    | nmon        | <nmon>        |
    | erinnerwert | <erinnerwert> |
    | bilkto      | 05200         |
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-2"
And I save the current editor
And I close the current editor
Examples:
    | nummer | such | andat  | nmon | erinnerwert | namebspr                                          |
    | 1gwg   | GWG1 | 01.01. | 12   |   1.00      | AfA ab Januar, letzte ZU Dezember                 |
    | 2gwg   | GWG2 | 09.04. | 12   |   1.00      | AfA ab April, 1. ZU Dezember                      |
    | 3gwg   | GWG3 | 01.01. | 12   | 250.00      | Erinnerwert > mtl AfA                             |
    | 4gwg   | GWG4 | 01.01. | 12   | 250.00      | Erinnerwert > mtl AfA                             |
    | 5gwg   | GWG5 | 01.07. |  6   |   1.00      | 6 Monate                                          |
    | 6gwg   | GWG6 | 10.04. | 12   |   0.00      | AfA ab April, 1. ZU Dezember (krummer AfA-Betrag) |
    | 7gwg   | GWG7 | 11.04. | 12   |   0.00      | AfA ab April, 1. ZU Dezember (krummer AfA-Betrag) |
    | 8gwg   | GWG8 | 01.10. |  1   |   1.11      | AfA nur Oktober                                   |
# =========================================================================================


Scenario Outline: Zugangsbuchungen

Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "kenn" to "ZU"
And I set field "budat" to "<budat>"
And I set field "beleg" to "<anlage>"
And I create a new row at the end of the table
And I set field "anlage" to "<anlage>" in row 1
And I set field "ewsbetr" to "<betrag>" in row 1
And I create a new row at the end of the table
And I set field "konto" to "18100" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
Examples:
    | anlage | betrag  | budat  |
    | 1anl   |  600.00 | 01.12. |
    | 2anl   |  600.00 | 01.12. |
    | 3anl   |  600.00 | 01.12. |
    | 1gwg   | 1200.00 | 01.01. |
    | 1gwg   |  600.00 | 05.12. |
    | 2gwg   | 1200.00 | 05.12. |
    | 3gwg   | 1200.00 | 01.01. |
    | 3gwg   |  120.00 | 01.11. |
    | 3gwg   |   12.00 | 01.12. |
    | 4gwg   | 1200.00 | 01.01. |
    | 5gwg   |  600.00 | 01.12. |
    | 6gwg   |  349.00 | 05.12. |
    | 7gwg   | 1500.00 | 05.12. |
    | 8gwg   |   50.00 | 05.10. |
# =========================================================================================


Scenario Outline: Kontrolle: Ist-VKZ (Zeigen)

# eine Anlage bzw. VKZ laden
Given I open an editor "anlage-vkz" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "<anlage>"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
# Reiter 'Abschreibungsberechnung'
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
    | anlage | afabtr1 | afabtr9 | afabtr10 | afabtr11 | afabtr12 | mind   | kafabtr  | gldiff |
    | 1anl   | 150.00  | 150.00  | 150.00   | 150.00   |  149.00  |   1.00 | 1799.00  |   0.00 |
    | 2anl   | 150.00  | 150.00  | 150.00   |  50.00   |    0.00  | 250.00 | 1550.00  |   0.00 |
    | 3anl   | 150.00  | 150.00  | 150.00   | 150.00   |  149.99  |   0.01 | 1799.99  |   0.00 |
    | 4anl   |  29.08  |  29.08  |  29.08   |  29.08   |   29.08  |   0.00 |  348.96  |  -0.04 |
    | 5anl   |  29.08  |  29.08  |  29.08   |  29.08   |   29.07  |   0.05 |  348.95  |   0.00 |
    | 1gwg   | 150.00  | 150.00  | 150.00   | 150.00   |  149.00  |   1.00 | 1799.00  |   0.00 |
    | 2gwg   |   0.00  |   0.00  |   0.00   |   0.00   | 1199.00  |   1.00 | 1199.00  |   0.00 |
    | 3gwg   | 111.00  | 111.00  |  83.00   |   0.00   |    0.00  | 250.00 | 1082.00  |   0.00 |
    | 4gwg   | 100.00  | 100.00  |  50.00   |   0.00   |    0.00  | 250.00 |  950.00  |   0.00 |
    | 5gwg   |   0.00  |   0.00  |   0.00   |   0.00   |  599.00  |   1.00 |  599.00  |   0.00 |
    | 6gwg   |   0.00  |   0.00  |   0.00   |   0.00   |  349.00  |   0.00 |  349.00  |   0.00 |
    | 7gwg   |   0.00  |   0.00  |   0.00   |   0.00   | 1500.00  |   0.00 | 1500.00  |   0.00 |
    | 8gwg   |   0.00  |   0.00  |  16.67   |  16.67   |   15.55  |   1.11 |   48.89  |   0.00 |
# =========================================================================================

