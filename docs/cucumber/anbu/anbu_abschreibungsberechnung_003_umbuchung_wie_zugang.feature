# *****************************************************************************
#  Name             : anbu_abschreibungsberechnung_003_umbuchung_wie_zugang.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Hier wird die Beruecksichtigung von dem Errinerungswert bei
#                     steuerlichen Anlagen geprueft
#
#     Umbuchungen:
#        1q1umb -> 3zumbanl
#        2q1umb -> 4zumbanl
#        2q2umb -> 4zumbanl
#
#     Vergleiche:
#        1rumbanl <-> 3zumbanl <-> 6norm
#        5rumbanl <-> 4zumbanl <-> 7norm
#
#
# *****************************************************************************
@persistent
Feature: anbu_abschreibungsberechnung_003_umbuchung_wie_zugang.feature
Background:

Given I set the fake date to "7.1.01"


Scenario Outline: Anlagen anlegen

#
Given I open an editor "anlage-1umb" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "modart" to "steuer"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set fields
    | afaart      | 10001     |
    | kstelle     | 100       |
    | andat       | <andat>   |
    | nmon        | <nmon>    |
    | erinnerwert | <errwert> |
    | bilkto      | 05200     |
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1umb"
And I save the current editor
And I close the current editor
Examples:
    | nummer   | such     | andat    | nmon | errwert | namebspr                                        |
    | 1rumbanl | UMB1ANL  | 01.01.01 | 60   | 1.00    | Referenz-Anlage1                                |
    | 1q1umb   | UMBQ1ANL | 01.01.01 | 60   | 1.00    | Quelle1-Anlage; wird auf Ziel-Anlage1 umgebucht |
    | 2q1umb   | UMBQ2ANL | 01.01.01 | 60   | 1.00    | Quelle2-Anlage; wird auf Ziel-Anlage2 umgebucht |
    | 2q2umb   | UMBQ3ANL | 01.01.01 | 60   | 1.00    | Quelle3-Anlage; wird auf Ziel-Anlage2 umgebucht |
    | 3zumbanl | UMB3ANL  | 01.01.01 | 60   | 1.00    | Ziel-Anlage1                                    |
    | 4zumbanl | UMB4ANL  | 01.01.01 | 60   | 1.00    | Ziel-Anlage2                                    |
    | 5rumbanl | UMB5ANL  | 01.01.01 | 60   | 1.00    | Referenz-Anlage2                                |
    | 6norm    | NORM6ANL | 01.01.01 | 60   | 1.00    | Anlage 6; Zugang erst im Dezember               |
    | 7norm    | NORM7ANL | 01.01.01 | 60   | 1.00    | Anlage 7; Zugang erst im Dezember               |
# ======================================================================================================


Scenario Outline: Zugaenge buchen

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
    | anlage   | betrag  | budat  |
# Anlage1
    | 1rumbanl | 1000.00 | 01.02. |
    | 1rumbanl | 4000.00 | 01.10. |
    | 1q1umb   | 1000.00 | 01.02. |
    | 1q1umb   | 4000.00 | 01.10. |
# Anlage2
    | 5rumbanl |  600.00 | 05.07. |
    | 5rumbanl | 1750.00 | 05.01. |
    | 5rumbanl | 1750.00 | 01.11. |
    | 2q1umb   |  600.00 | 01.07. |
    | 2q1umb   | 1750.00 | 05.01. |
    | 2q2umb   | 1750.00 | 01.11. |
# Anlage6
    | 6norm    | 5000.00 | 01.12. |
# Anlage7
    | 7norm    | 2000.00 | 01.12. |
    | 7norm    | 2100.00 | 01.12. |
# ======================================================================================================


Scenario Outline: Anlagen umbuchen

# einen neuen Anlagenvorgang anlegen, aber nicht verbuchen
Given I open an editor "anlagenvorg" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "vorgart" to "Vollumbuchung"
And I set field "such" to "<such>"
And I set field "vdatum" to "15.12.2001"
And I set field "anlage" to "<anlage>"
And I set field "uanlage" to "<uanlage>"
#
# Kumulierte Anschaffungs- und Herstellungskosten
Then field "kumahk" has value "<kumahk>"
# Kumulierte Abschreibungen
Then field "kumafa" has value "<kumafa>"
# Restbuchwert
Then field "rbw" has value "<rbw>"
#
# _____START: ABGEHENDE WERTE
# Abgehende oder umzubuchende Anschaffungskosten
Then field "auahk" has value "<auahk>"
# Abgehende oder umzubuchende Abschreibungen
Then field "auafa" has value "<auafa>"
# Abgehender oder umzubuchender Restbuchwert
Then field "aurbw" has value "<aurbw>"
# _____ENDE: ABGEHENDE WERTE
#
# Noch zu verbuchende Abschreibungen
Then field "nochafa" has value "<nochafa>"
Then field "buahk" is empty in row 0
Then field "buafa" is empty in row 0
And I respond with answer "Ja" to the dialog with id "4479"
And I save the current editor
Examples:
  | nummer | such    | anlage | uanlage  | kumahk  | kumafa | rbw     | auahk   | auafa | aurbw   | nochafa |
  | 1umbA1 | U1UMBA1 | 1q1umb | 3zumbanl | 5000.00 | 0.00   | 5000.00 | 5000.00 | 0.00  | 5000.00 | 916.63  |
  | 2umbA2 | U1UMBA2 | 2q1umb | 4zumbanl | 2350.00 | 0.00   | 2350.00 | 2350.00 | 0.00  | 2350.00 | 430.87  |
  | 3umbA2 | U2UMBA2 | 2q2umb | 4zumbanl | 1750.00 | 0.00   | 1750.00 | 1750.00 | 0.00  | 1750.00 | 320.87  |
# ======================================================================================================


Scenario Outline: Kontrolle: Ist-VKZ (Zeigen)

# eine Anlage bzw. VKZ laden
Given I open an editor "anlage-vkz" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "<anlage>"
Then field "afaart" has value "10001"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
# Reiter 'Abschreibungsberechnung'
Then field "bemgr1" has value "<bemgr1>"
Then field "bemgr11" has value "<bemgr11>"
Then field "bemgr12" has value "<bemgr12>"
#
Then field "afabtr1" has value "<afabtr1>"
Then field "afabtr2" has value "<afabtr2>"
Then field "afabtr11" has value "<afabtr11>"
Then field "afabtr12" has value "<afabtr12>"
#
Then field "kmafa1" has value "<kmafa1>"
Then field "kmafa11" has value "<kmafa11>"
Then field "kmafa12" has value "<kmafa12>"
#
Then field "rnad1" has value "<rnad1>"
Then field "rnad11" has value "<rnad11>"
Then field "rnad12" has value "<rnad12>"
#
Then field "gldiff" has value "<gldiff>"

Then field "mind" has value "<mind>"
Then field "kafabtr" has value "<kafabtr>"
# Reiter 'Anfangs- und Endwerte'
Then field "afafehl" has value "<afafehl>"
# Then field "afaftxt" is empty
And I close the current editor
And I switch the current editor to editor "anlage-vkz"
# Test abschliessen
And I save the current editor

Examples:
    | anlage   | bemgr1  | bemgr11 | bemgr12 | afabtr1 | afabtr2 | afabtr11 | afabtr12 | kmafa1 | kmafa11 | kmafa12 | rnad1 | rnad11 | rnad12 | mind   | kafabtr | gldiff | afafehl |
# Anlage1
    | 3zumbanl |    0.00 |    0.00 | 5000.00 |   0.00  |   0.00  |   0.00   |  102.04  |   0.00 |   0.00  | 102.04  |  0    |  0     | 49     |   1.00 | 102.04  |   0.04 |    4199 |
    | 1rumbanl | 5000.00 | 5000.00 | 5000.00 |   0.00  | 166.66  |  83.33   |   83.33  |  83.33 | 916.63  | 999.96  | 60    | 60     | 60     |   1.00 | 999.96  |  -0.04 |       0 |
    | 6norm    | 5000.00 | 5000.00 | 5000.00 |   0.00  |   0.00  |   0.00   |  999.96  |  83.33 | 916.63  | 999.96  | 60    | 60     | 60     |   1.00 | 999.96  |  -0.04 |       0 |
# Anlage2
    | 4zumbanl |    0.00 |    0.00 | 4100.00 |   0.00  |   0.00  |   0.00   |   83.67  |   0.00 |   0.00  |  83.67  |  0    |  0     | 49     |   1.00 | 83.67   |  -0.33 |    4199 |
    | 5rumbanl | 4100.00 | 4100.00 | 4100.00 |  68.33  |  68.33  |  68.33   |   68.33  |  68.33 | 751.63  | 819.96  | 60    | 60     | 60     |   1.00 | 819.96  |  -0.04 |       0 |
    | 7norm    | 4100.00 | 4100.00 | 4100.00 |   0.00  |   0.00  |   0.00   |  819.96  |  68.33 | 751.63  | 819.96  | 60    | 60     | 60     |   1.00 | 819.96  |  -0.04 |       0 |
# ======================================================================================================
