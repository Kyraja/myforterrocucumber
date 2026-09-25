# *****************************************************************************
#  Name             : ref_op_projekt_1_umbu_wechsel_rein_0.feature
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : OPs umbuchen in "Zahlungseingang - Kundenwechsel", Umbuchen NICHT projektrein, Projektkostenrechnung aktiviert
#  Verwendung       : ref_op_projekt_1_umbu_wechsel_rein_0_cu
# *****************************************************************************
@persistent
Feature: ref_op_projekt_1_umbu_wechsel_rein_0.feature

Background:
Given I set the fake date to "31.12.2022"
# =============================================================================

Scenario: Zahlungseingang - Kundenwechsel, Vorbelegung der Sammlerdaten im Bezug auf Projekt testen

# ------------------------------------------------------------------------------------------------------------------------------
# ZV-Konfig ändern: Vorbelegung "Umbuchen der offenen Posten projektrein" prüfen und deaktivieren
# ------------------------------------------------------------------------------------------------------------------------------

Given I open an editor "ZVKonfig-Projektrein" from table "66:1" with command "UPDATE" for record "1"
Then field "umbuprojektrein" has value "nein"
And I set field "umbuprojektrein" to "nein"
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------------
# OP-Bearbeitung NEU, "Zahlungseingang - Kundenwechsel", Kopfelder vorbelegen
# ------------------------------------------------------------------------------------------------------------------------------

Given I open an editor "Test_KU_UMBU-1" from table "102:11" with command "NEW" for record ""

And I set fields
	| beleg        | UMBU-1 |
	| beldat       | 31.03.22 |
	| kbudat       | 31.03.22 |
	| gkonto       | 14603    |
	| opausgleich  | ja |
	| sebeleg      | Test KU UMBU-1 |
	| sform        |  |
	| wechseleinrauto | ja |
	| faell        | 30.04.22 |

# ------------------------------------------------------------------------------------------------------------------------------
# Sammelart "Nicht sammeln", OPs laden, ausgleichen beim Laden, Sammlerdaten aktualisieren, prüfen
# ------------------------------------------------------------------------------------------------------------------------------

And I set field "zasammelart" to "Nicht sammeln"
Then field "zagr" has value "1"

And I press button "opladen"

And I press button "sammlerdatenakt"

# Zeile 1
Then field "ebeleg" has value "Test KU UMBU-1" in row 1
Then field "tbeleg" has value "K11P---1" in row 1
Then field "konto" has value "K 11" in row 1
Then field "projekt" has value "" in row 1
Then field "sha" has value "Haben" in row 1
Then field "opzabetr" has value "1190.00" in row 1
Then field "skbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "1" in row 1
Then field "sammleroplnr" has value "1" in row 1
Then field "sammleropanzahl" has value "1" in row 1
Then field "sammlerkonto" has value "K 11" in row 1
Then field "sammlerprojekt" has value "" in row 1
Then field "sammlersh" has value "Haben" in row 1
Then field "sammlerbubetr" has value "1190.00" in row 1
Then field "sammlerskbetr" has value "0.00" in row 1

Then field "opgkolnr" has value "1" in row 1
Then field "ebeleggko" has value "" in row 1
Then field "projektgko" has value "" in row 1
Then field "opgkosh" has value "Soll" in row 1
Then field "opgkobubetr" has value "1190.00" in row 1

# Zeile 2
Then field "ebeleg" has value "Test KU UMBU-1" in row 2
Then field "tbeleg" has value "K11P---2" in row 2
Then field "konto" has value "K 11" in row 2
Then field "projekt" has value "" in row 2
Then field "sha" has value "Haben" in row 2
Then field "opzabetr" has value "1190.00" in row 2
Then field "skbetr" has value "0.00" in row 2

Then field "sammlerlnr" has value "2" in row 2
Then field "sammleroplnr" has value "1" in row 2
Then field "sammleropanzahl" has value "1" in row 2
Then field "sammlerkonto" has value "K 11" in row 2
Then field "sammlerprojekt" has value "" in row 2
Then field "sammlersh" has value "Haben" in row 2
Then field "sammlerbubetr" has value "1190.00" in row 2
Then field "sammlerskbetr" has value "0.00" in row 2

Then field "opgkolnr" has value "2" in row 2
Then field "ebeleggko" has value "" in row 2
Then field "projektgko" has value "" in row 2
Then field "opgkosh" has value "Soll" in row 2
Then field "opgkobubetr" has value "1190.00" in row 2

# Zeile 3
Then field "ebeleg" has value "Test KU UMBU-1" in row 3
Then field "tbeleg" has value "K11P11-1" in row 3
Then field "konto" has value "K 11" in row 3
Then field "projekt" has value "PROJ11" in row 3
Then field "sha" has value "Haben" in row 3
Then field "opzabetr" has value "1190.00" in row 3
Then field "skbetr" has value "0.00" in row 3

Then field "sammlerlnr" has value "3" in row 3
Then field "sammleroplnr" has value "1" in row 3
Then field "sammleropanzahl" has value "1" in row 3
Then field "sammlerkonto" has value "K 11" in row 3
Then field "sammlerprojekt" has value "PROJ11" in row 3
Then field "sammlersh" has value "Haben" in row 3
Then field "sammlerbubetr" has value "1190.00" in row 3
Then field "sammlerskbetr" has value "0.00" in row 3

Then field "opgkolnr" has value "3" in row 3
Then field "ebeleggko" has value "" in row 3
Then field "projektgko" has value "PROJ11" in row 3
Then field "opgkosh" has value "Soll" in row 3
Then field "opgkobubetr" has value "1190.00" in row 3

# Zeile 4
Then field "ebeleg" has value "Test KU UMBU-1" in row 4
Then field "tbeleg" has value "K11P11-2" in row 4
Then field "konto" has value "K 11" in row 4
Then field "projekt" has value "PROJ11" in row 4
Then field "sha" has value "Haben" in row 4
Then field "opzabetr" has value "1190.00" in row 4
Then field "skbetr" has value "0.00" in row 4

Then field "sammlerlnr" has value "4" in row 4
Then field "sammleroplnr" has value "1" in row 4
Then field "sammleropanzahl" has value "1" in row 4
Then field "sammlerkonto" has value "K 11" in row 4
Then field "sammlerprojekt" has value "PROJ11" in row 4
Then field "sammlersh" has value "Haben" in row 4
Then field "sammlerbubetr" has value "1190.00" in row 4
Then field "sammlerskbetr" has value "0.00" in row 4

Then field "opgkolnr" has value "4" in row 4
Then field "ebeleggko" has value "" in row 4
Then field "projektgko" has value "PROJ11" in row 4
Then field "opgkosh" has value "Soll" in row 4
Then field "opgkobubetr" has value "1190.00" in row 4

# Zeile 5
Then field "ebeleg" has value "Test KU UMBU-1" in row 5
Then field "tbeleg" has value "K11P12-1" in row 5
Then field "konto" has value "K 11" in row 5
Then field "projekt" has value "PROJ12" in row 5
Then field "sha" has value "Haben" in row 5
Then field "opzabetr" has value "1190.00" in row 5
Then field "skbetr" has value "0.00" in row 5

Then field "sammlerlnr" has value "5" in row 5
Then field "sammleroplnr" has value "1" in row 5
Then field "sammleropanzahl" has value "1" in row 5
Then field "sammlerkonto" has value "K 11" in row 5
Then field "sammlerprojekt" has value "PROJ12" in row 5
Then field "sammlersh" has value "Haben" in row 5
Then field "sammlerbubetr" has value "1190.00" in row 5
Then field "sammlerskbetr" has value "0.00" in row 5

Then field "opgkolnr" has value "5" in row 5
Then field "ebeleggko" has value "" in row 5
Then field "projektgko" has value "PROJ12" in row 5
Then field "opgkosh" has value "Soll" in row 5
Then field "opgkobubetr" has value "1190.00" in row 5

# Zeile 6
Then field "ebeleg" has value "Test KU UMBU-1" in row 6
Then field "tbeleg" has value "K11P12-2" in row 6
Then field "konto" has value "K 11" in row 6
Then field "projekt" has value "PROJ12" in row 6
Then field "sha" has value "Haben" in row 6
Then field "opzabetr" has value "1190.00" in row 6
Then field "skbetr" has value "0.00" in row 6

Then field "sammlerlnr" has value "6" in row 6
Then field "sammleroplnr" has value "1" in row 6
Then field "sammleropanzahl" has value "1" in row 6
Then field "sammlerkonto" has value "K 11" in row 6
Then field "sammlerprojekt" has value "PROJ12" in row 6
Then field "sammlersh" has value "Haben" in row 6
Then field "sammlerbubetr" has value "1190.00" in row 6
Then field "sammlerskbetr" has value "0.00" in row 6

Then field "opgkolnr" has value "6" in row 6
Then field "ebeleggko" has value "" in row 6
Then field "projektgko" has value "PROJ12" in row 6
Then field "opgkosh" has value "Soll" in row 6
Then field "opgkobubetr" has value "1190.00" in row 6

# Zeile 7
Then field "ebeleg" has value "Test KU UMBU-1" in row 7
Then field "tbeleg" has value "K11P13-1" in row 7
Then field "konto" has value "K 11" in row 7
Then field "projekt" has value "PROJ13" in row 7
Then field "sha" has value "Haben" in row 7
Then field "opzabetr" has value "1190.00" in row 7
Then field "skbetr" has value "0.00" in row 7

Then field "sammlerlnr" has value "7" in row 7
Then field "sammleroplnr" has value "1" in row 7
Then field "sammleropanzahl" has value "1" in row 7
Then field "sammlerkonto" has value "K 11" in row 7
Then field "sammlerprojekt" has value "PROJ13" in row 7
Then field "sammlersh" has value "Haben" in row 7
Then field "sammlerbubetr" has value "1190.00" in row 7
Then field "sammlerskbetr" has value "0.00" in row 7

Then field "opgkolnr" has value "7" in row 7
Then field "ebeleggko" has value "" in row 7
Then field "projektgko" has value "PROJ13" in row 7
Then field "opgkosh" has value "Soll" in row 7
Then field "opgkobubetr" has value "1190.00" in row 7

# Zeile 8
Then field "ebeleg" has value "Test KU UMBU-1" in row 8
Then field "tbeleg" has value "K11P13-2" in row 8
Then field "konto" has value "K 11" in row 8
Then field "projekt" has value "PROJ13" in row 8
Then field "sha" has value "Haben" in row 8
Then field "opzabetr" has value "1190.00" in row 8
Then field "skbetr" has value "0.00" in row 8

Then field "sammlerlnr" has value "8" in row 8
Then field "sammleroplnr" has value "1" in row 8
Then field "sammleropanzahl" has value "1" in row 8
Then field "sammlerkonto" has value "K 11" in row 8
Then field "sammlerprojekt" has value "PROJ13" in row 8
Then field "sammlersh" has value "Haben" in row 8
Then field "sammlerbubetr" has value "1190.00" in row 8
Then field "sammlerskbetr" has value "0.00" in row 8

Then field "opgkolnr" has value "8" in row 8
Then field "ebeleggko" has value "" in row 8
Then field "projektgko" has value "PROJ13" in row 8
Then field "opgkosh" has value "Soll" in row 8
Then field "opgkobubetr" has value "1190.00" in row 8

# Zeile 9
Then field "ebeleg" has value "Test KU UMBU-1" in row 9
Then field "tbeleg" has value "K12P---1" in row 9
Then field "konto" has value "K 12" in row 9
Then field "projekt" has value "" in row 9
Then field "sha" has value "Haben" in row 9
Then field "opzabetr" has value "1190.00" in row 9
Then field "skbetr" has value "0.00" in row 9

Then field "sammlerlnr" has value "9" in row 9
Then field "sammleroplnr" has value "1" in row 9
Then field "sammleropanzahl" has value "1" in row 9
Then field "sammlerkonto" has value "K 12" in row 9
Then field "sammlerprojekt" has value "" in row 9
Then field "sammlersh" has value "Haben" in row 9
Then field "sammlerbubetr" has value "1190.00" in row 9
Then field "sammlerskbetr" has value "0.00" in row 9

Then field "opgkolnr" has value "9" in row 9
Then field "ebeleggko" has value "" in row 9
Then field "projektgko" has value "" in row 9
Then field "opgkosh" has value "Soll" in row 9
Then field "opgkobubetr" has value "1190.00" in row 9

# Zeile 10
Then field "ebeleg" has value "Test KU UMBU-1" in row 10
Then field "tbeleg" has value "K12P---2" in row 10
Then field "konto" has value "K 12" in row 10
Then field "projekt" has value "" in row 10
Then field "sha" has value "Haben" in row 10
Then field "opzabetr" has value "1190.00" in row 10
Then field "skbetr" has value "0.00" in row 10

Then field "sammlerlnr" has value "10" in row 10
Then field "sammleroplnr" has value "1" in row 10
Then field "sammleropanzahl" has value "1" in row 10
Then field "sammlerkonto" has value "K 12" in row 10
Then field "sammlerprojekt" has value "" in row 10
Then field "sammlersh" has value "Haben" in row 10
Then field "sammlerbubetr" has value "1190.00" in row 10
Then field "sammlerskbetr" has value "0.00" in row 10

Then field "opgkolnr" has value "10" in row 10
Then field "ebeleggko" has value "" in row 10
Then field "projektgko" has value "" in row 10
Then field "opgkosh" has value "Soll" in row 10
Then field "opgkobubetr" has value "1190.00" in row 10

# Zeile 11
Then field "ebeleg" has value "Test KU UMBU-1" in row 11
Then field "tbeleg" has value "K12P11-1" in row 11
Then field "konto" has value "K 12" in row 11
Then field "projekt" has value "PROJ11" in row 11
Then field "sha" has value "Haben" in row 11
Then field "opzabetr" has value "1190.00" in row 11
Then field "skbetr" has value "0.00" in row 11

Then field "sammlerlnr" has value "11" in row 11
Then field "sammleroplnr" has value "1" in row 11
Then field "sammleropanzahl" has value "1" in row 11
Then field "sammlerkonto" has value "K 12" in row 11
Then field "sammlerprojekt" has value "PROJ11" in row 11
Then field "sammlersh" has value "Haben" in row 11
Then field "sammlerbubetr" has value "1190.00" in row 11
Then field "sammlerskbetr" has value "0.00" in row 11

Then field "opgkolnr" has value "11" in row 11
Then field "ebeleggko" has value "" in row 11
Then field "projektgko" has value "PROJ11" in row 11
Then field "opgkosh" has value "Soll" in row 11
Then field "opgkobubetr" has value "1190.00" in row 11

# Zeile 12
Then field "ebeleg" has value "Test KU UMBU-1" in row 12
Then field "tbeleg" has value "K12P11-2" in row 12
Then field "konto" has value "K 12" in row 12
Then field "projekt" has value "PROJ11" in row 12
Then field "sha" has value "Haben" in row 12
Then field "opzabetr" has value "1190.00" in row 12
Then field "skbetr" has value "0.00" in row 12

Then field "sammlerlnr" has value "12" in row 12
Then field "sammleroplnr" has value "1" in row 12
Then field "sammleropanzahl" has value "1" in row 12
Then field "sammlerkonto" has value "K 12" in row 12
Then field "sammlerprojekt" has value "PROJ11" in row 12
Then field "sammlersh" has value "Haben" in row 12
Then field "sammlerbubetr" has value "1190.00" in row 12
Then field "sammlerskbetr" has value "0.00" in row 12

Then field "opgkolnr" has value "12" in row 12
Then field "ebeleggko" has value "" in row 12
Then field "projektgko" has value "PROJ11" in row 12
Then field "opgkosh" has value "Soll" in row 12
Then field "opgkobubetr" has value "1190.00" in row 12

# Zeile 13
Then field "ebeleg" has value "Test KU UMBU-1" in row 13
Then field "tbeleg" has value "K12P12-1" in row 13
Then field "konto" has value "K 12" in row 13
Then field "projekt" has value "PROJ12" in row 13
Then field "sha" has value "Haben" in row 13
Then field "opzabetr" has value "1190.00" in row 13
Then field "skbetr" has value "0.00" in row 13

Then field "sammlerlnr" has value "13" in row 13
Then field "sammleroplnr" has value "1" in row 13
Then field "sammleropanzahl" has value "1" in row 13
Then field "sammlerkonto" has value "K 12" in row 13
Then field "sammlerprojekt" has value "PROJ12" in row 13
Then field "sammlersh" has value "Haben" in row 13
Then field "sammlerbubetr" has value "1190.00" in row 13
Then field "sammlerskbetr" has value "0.00" in row 13

Then field "opgkolnr" has value "13" in row 13
Then field "ebeleggko" has value "" in row 13
Then field "projektgko" has value "PROJ12" in row 13
Then field "opgkosh" has value "Soll" in row 13
Then field "opgkobubetr" has value "1190.00" in row 13

# Zeile 14
Then field "ebeleg" has value "Test KU UMBU-1" in row 14
Then field "tbeleg" has value "K12P12-2" in row 14
Then field "konto" has value "K 12" in row 14
Then field "projekt" has value "PROJ12" in row 14
Then field "sha" has value "Haben" in row 14
Then field "opzabetr" has value "1190.00" in row 14
Then field "skbetr" has value "0.00" in row 14

Then field "sammlerlnr" has value "14" in row 14
Then field "sammleroplnr" has value "1" in row 14
Then field "sammleropanzahl" has value "1" in row 14
Then field "sammlerkonto" has value "K 12" in row 14
Then field "sammlerprojekt" has value "PROJ12" in row 14
Then field "sammlersh" has value "Haben" in row 14
Then field "sammlerbubetr" has value "1190.00" in row 14
Then field "sammlerskbetr" has value "0.00" in row 14

Then field "opgkolnr" has value "14" in row 14
Then field "ebeleggko" has value "" in row 14
Then field "projektgko" has value "PROJ12" in row 14
Then field "opgkosh" has value "Soll" in row 14
Then field "opgkobubetr" has value "1190.00" in row 14

# Zeile 15
Then field "ebeleg" has value "Test KU UMBU-1" in row 15
Then field "tbeleg" has value "K12P13-1" in row 15
Then field "konto" has value "K 12" in row 15
Then field "projekt" has value "PROJ13" in row 15
Then field "sha" has value "Haben" in row 15
Then field "opzabetr" has value "1190.00" in row 15
Then field "skbetr" has value "0.00" in row 15

Then field "sammlerlnr" has value "15" in row 15
Then field "sammleroplnr" has value "1" in row 15
Then field "sammleropanzahl" has value "1" in row 15
Then field "sammlerkonto" has value "K 12" in row 15
Then field "sammlerprojekt" has value "PROJ13" in row 15
Then field "sammlersh" has value "Haben" in row 15
Then field "sammlerbubetr" has value "1190.00" in row 15
Then field "sammlerskbetr" has value "0.00" in row 15

Then field "opgkolnr" has value "15" in row 15
Then field "ebeleggko" has value "" in row 15
Then field "projektgko" has value "PROJ13" in row 15
Then field "opgkosh" has value "Soll" in row 15
Then field "opgkobubetr" has value "1190.00" in row 15

# Zeile 16
Then field "ebeleg" has value "Test KU UMBU-1" in row 16
Then field "tbeleg" has value "K12P13-2" in row 16
Then field "konto" has value "K 12" in row 16
Then field "projekt" has value "PROJ13" in row 16
Then field "sha" has value "Haben" in row 16
Then field "opzabetr" has value "1190.00" in row 16
Then field "skbetr" has value "0.00" in row 16

Then field "sammlerlnr" has value "16" in row 16
Then field "sammleroplnr" has value "1" in row 16
Then field "sammleropanzahl" has value "1" in row 16
Then field "sammlerkonto" has value "K 12" in row 16
Then field "sammlerprojekt" has value "PROJ13" in row 16
Then field "sammlersh" has value "Haben" in row 16
Then field "sammlerbubetr" has value "1190.00" in row 16
Then field "sammlerskbetr" has value "0.00" in row 16

Then field "opgkolnr" has value "16" in row 16
Then field "ebeleggko" has value "" in row 16
Then field "projektgko" has value "PROJ13" in row 16
Then field "opgkosh" has value "Soll" in row 16
Then field "opgkobubetr" has value "1190.00" in row 16

# ------------------------------------------------------------------------------------------------------------------------------
# Sammelart ändern: "Nicht sammeln" -> "Sammelbuchungen", Sammlerdaten aktualisieren, prüfen
# ------------------------------------------------------------------------------------------------------------------------------

And I set field "zasammelart" to "Sammelbuchungen"
Then field "zagr" has value "1000"

And I press button "sammlerdatenakt"

# Zeile 1
Then field "ebeleg" has value "Test KU UMBU-1" in row 1
Then field "tbeleg" has value "K11P---1" in row 1
Then field "konto" has value "K 11" in row 1
Then field "projekt" has value "" in row 1
Then field "sha" has value "Haben" in row 1
Then field "opzabetr" has value "1190.00" in row 1
Then field "skbetr" has value "0.00" in row 1
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "1" in row 1
Then field "sammleroplnr" has value "1" in row 1
Then field "sammleropanzahl" has value "8" in row 1
Then field "sammlerkonto" has value "K 11" in row 1
Then field "sammlerprojekt" has value "" in row 1
Then field "sammlersh" has value "Haben" in row 1
Then field "sammlerbubetr" has value "9520.00" in row 1
Then field "sammlerskbetr" has value "0.00" in row 1

Then field "opgkolnr" has value "1" in row 1
Then field "ebeleggko" has value "" in row 1
Then field "projektgko" has value "" in row 1
Then field "opgkosh" has value "Soll" in row 1
Then field "opgkobubetr" has value "9520.00" in row 1

# Zeile 2
Then field "ebeleg" has value "Test KU UMBU-1" in row 2
Then field "tbeleg" has value "K11P---2" in row 2
Then field "konto" has value "K 11" in row 2
Then field "projekt" has value "" in row 2
Then field "sha" has value "Haben" in row 2
Then field "opzabetr" has value "1190.00" in row 2
Then field "skbetr" has value "0.00" in row 2
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "1" in row 2
Then field "sammleroplnr" has value "2" in row 2
Then field "sammleropanzahl" has value "8" in row 2
Then field "sammlerkonto" has value "K 11" in row 2
Then field "sammlerprojekt" has value "" in row 2
Then field "sammlersh" has value "Haben" in row 2
Then field "sammlerbubetr" has value "9520.00" in row 2
Then field "sammlerskbetr" has value "0.00" in row 2

Then field "opgkolnr" has value "1" in row 2
Then field "ebeleggko" has value "" in row 2
Then field "projektgko" has value "" in row 2
Then field "opgkosh" has value "Soll" in row 2
Then field "opgkobubetr" has value "9520.00" in row 2

# Zeile 3
Then field "ebeleg" has value "Test KU UMBU-1" in row 3
Then field "tbeleg" has value "K11P11-1" in row 3
Then field "konto" has value "K 11" in row 3
Then field "projekt" has value "PROJ11" in row 3
Then field "sha" has value "Haben" in row 3
Then field "opzabetr" has value "1190.00" in row 3
Then field "skbetr" has value "0.00" in row 3
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "1" in row 3
Then field "sammleroplnr" has value "3" in row 3
Then field "sammleropanzahl" has value "8" in row 3
Then field "sammlerkonto" has value "K 11" in row 3
Then field "sammlerprojekt" has value "" in row 3
Then field "sammlersh" has value "Haben" in row 3
Then field "sammlerbubetr" has value "9520.00" in row 3
Then field "sammlerskbetr" has value "0.00" in row 3

Then field "opgkolnr" has value "1" in row 3
Then field "ebeleggko" has value "" in row 3
Then field "projektgko" has value "" in row 3
Then field "opgkosh" has value "Soll" in row 3
Then field "opgkobubetr" has value "9520.00" in row 3

# Zeile 4
Then field "ebeleg" has value "Test KU UMBU-1" in row 4
Then field "tbeleg" has value "K11P11-2" in row 4
Then field "konto" has value "K 11" in row 4
Then field "projekt" has value "PROJ11" in row 4
Then field "sha" has value "Haben" in row 4
Then field "opzabetr" has value "1190.00" in row 4
Then field "skbetr" has value "0.00" in row 4
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "1" in row 4
Then field "sammleroplnr" has value "4" in row 4
Then field "sammleropanzahl" has value "8" in row 4
Then field "sammlerkonto" has value "K 11" in row 4
Then field "sammlerprojekt" has value "" in row 4
Then field "sammlersh" has value "Haben" in row 4
Then field "sammlerbubetr" has value "9520.00" in row 4
Then field "sammlerskbetr" has value "0.00" in row 4

Then field "opgkolnr" has value "1" in row 4
Then field "ebeleggko" has value "" in row 4
Then field "projektgko" has value "" in row 4
Then field "opgkosh" has value "Soll" in row 4
Then field "opgkobubetr" has value "9520.00" in row 4

# Zeile 5
Then field "ebeleg" has value "Test KU UMBU-1" in row 5
Then field "tbeleg" has value "K11P12-1" in row 5
Then field "konto" has value "K 11" in row 5
Then field "projekt" has value "PROJ12" in row 5
Then field "sha" has value "Haben" in row 5
Then field "opzabetr" has value "1190.00" in row 5
Then field "skbetr" has value "0.00" in row 5
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "1" in row 5
Then field "sammleroplnr" has value "5" in row 5
Then field "sammleropanzahl" has value "8" in row 5
Then field "sammlerkonto" has value "K 11" in row 5
Then field "sammlerprojekt" has value "" in row 5
Then field "sammlersh" has value "Haben" in row 5
Then field "sammlerbubetr" has value "9520.00" in row 5
Then field "sammlerskbetr" has value "0.00" in row 5

Then field "opgkolnr" has value "1" in row 5
Then field "ebeleggko" has value "" in row 5
Then field "projektgko" has value "" in row 5
Then field "opgkosh" has value "Soll" in row 5
Then field "opgkobubetr" has value "9520.00" in row 5

# Zeile 6
Then field "ebeleg" has value "Test KU UMBU-1" in row 6
Then field "tbeleg" has value "K11P12-2" in row 6
Then field "konto" has value "K 11" in row 6
Then field "projekt" has value "PROJ12" in row 6
Then field "sha" has value "Haben" in row 6
Then field "opzabetr" has value "1190.00" in row 6
Then field "skbetr" has value "0.00" in row 6
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "1" in row 6
Then field "sammleroplnr" has value "6" in row 6
Then field "sammleropanzahl" has value "8" in row 6
Then field "sammlerkonto" has value "K 11" in row 6
Then field "sammlerprojekt" has value "" in row 6
Then field "sammlersh" has value "Haben" in row 6
Then field "sammlerbubetr" has value "9520.00" in row 6
Then field "sammlerskbetr" has value "0.00" in row 6

Then field "opgkolnr" has value "1" in row 6
Then field "ebeleggko" has value "" in row 6
Then field "projektgko" has value "" in row 6
Then field "opgkosh" has value "Soll" in row 6
Then field "opgkobubetr" has value "9520.00" in row 6

# Zeile 7
Then field "ebeleg" has value "Test KU UMBU-1" in row 7
Then field "tbeleg" has value "K11P13-1" in row 7
Then field "konto" has value "K 11" in row 7
Then field "projekt" has value "PROJ13" in row 7
Then field "sha" has value "Haben" in row 7
Then field "opzabetr" has value "1190.00" in row 7
Then field "skbetr" has value "0.00" in row 7
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "1" in row 7
Then field "sammleroplnr" has value "7" in row 7
Then field "sammleropanzahl" has value "8" in row 7
Then field "sammlerkonto" has value "K 11" in row 7
Then field "sammlerprojekt" has value "" in row 7
Then field "sammlersh" has value "Haben" in row 7
Then field "sammlerbubetr" has value "9520.00" in row 7
Then field "sammlerskbetr" has value "0.00" in row 7

Then field "opgkolnr" has value "1" in row 7
Then field "ebeleggko" has value "" in row 7
Then field "projektgko" has value "" in row 7
Then field "opgkosh" has value "Soll" in row 7
Then field "opgkobubetr" has value "9520.00" in row 7

# Zeile 8
Then field "ebeleg" has value "Test KU UMBU-1" in row 8
Then field "tbeleg" has value "K11P13-2" in row 8
Then field "konto" has value "K 11" in row 8
Then field "projekt" has value "PROJ13" in row 8
Then field "sha" has value "Haben" in row 8
Then field "opzabetr" has value "1190.00" in row 8
Then field "skbetr" has value "0.00" in row 8
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "1" in row 8
Then field "sammleroplnr" has value "8" in row 8
Then field "sammleropanzahl" has value "8" in row 8
Then field "sammlerkonto" has value "K 11" in row 8
Then field "sammlerprojekt" has value "" in row 8
Then field "sammlersh" has value "Haben" in row 8
Then field "sammlerbubetr" has value "9520.00" in row 8
Then field "sammlerskbetr" has value "0.00" in row 8

Then field "opgkolnr" has value "1" in row 8
Then field "ebeleggko" has value "" in row 8
Then field "projektgko" has value "" in row 8
Then field "opgkosh" has value "Soll" in row 8
Then field "opgkobubetr" has value "9520.00" in row 8

# Zeile 9
Then field "ebeleg" has value "Test KU UMBU-1" in row 9
Then field "tbeleg" has value "K12P---1" in row 9
Then field "konto" has value "K 12" in row 9
Then field "projekt" has value "" in row 9
Then field "sha" has value "Haben" in row 9
Then field "opzabetr" has value "1190.00" in row 9
Then field "skbetr" has value "0.00" in row 9
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "2" in row 9
Then field "sammleroplnr" has value "1" in row 9
Then field "sammleropanzahl" has value "8" in row 9
Then field "sammlerkonto" has value "K 12" in row 9
Then field "sammlerprojekt" has value "" in row 9
Then field "sammlersh" has value "Haben" in row 9
Then field "sammlerbubetr" has value "9520.00" in row 9
Then field "sammlerskbetr" has value "0.00" in row 9

Then field "opgkolnr" has value "2" in row 9
Then field "ebeleggko" has value "" in row 9
Then field "projektgko" has value "" in row 9
Then field "opgkosh" has value "Soll" in row 9
Then field "opgkobubetr" has value "9520.00" in row 9

# Zeile 10
Then field "ebeleg" has value "Test KU UMBU-1" in row 10
Then field "tbeleg" has value "K12P---2" in row 10
Then field "konto" has value "K 12" in row 10
Then field "projekt" has value "" in row 10
Then field "sha" has value "Haben" in row 10
Then field "opzabetr" has value "1190.00" in row 10
Then field "skbetr" has value "0.00" in row 10
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "2" in row 10
Then field "sammleroplnr" has value "2" in row 10
Then field "sammleropanzahl" has value "8" in row 10
Then field "sammlerkonto" has value "K 12" in row 10
Then field "sammlerprojekt" has value "" in row 10
Then field "sammlersh" has value "Haben" in row 10
Then field "sammlerbubetr" has value "9520.00" in row 10
Then field "sammlerskbetr" has value "0.00" in row 10

Then field "opgkolnr" has value "2" in row 10
Then field "ebeleggko" has value "" in row 10
Then field "projektgko" has value "" in row 10
Then field "opgkosh" has value "Soll" in row 10
Then field "opgkobubetr" has value "9520.00" in row 10

# Zeile 11
Then field "ebeleg" has value "Test KU UMBU-1" in row 11
Then field "tbeleg" has value "K12P11-1" in row 11
Then field "konto" has value "K 12" in row 11
Then field "projekt" has value "PROJ11" in row 11
Then field "sha" has value "Haben" in row 11
Then field "opzabetr" has value "1190.00" in row 11
Then field "skbetr" has value "0.00" in row 11
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "2" in row 11
Then field "sammleroplnr" has value "3" in row 11
Then field "sammleropanzahl" has value "8" in row 11
Then field "sammlerkonto" has value "K 12" in row 11
Then field "sammlerprojekt" has value "" in row 11
Then field "sammlersh" has value "Haben" in row 11
Then field "sammlerbubetr" has value "9520.00" in row 11
Then field "sammlerskbetr" has value "0.00" in row 11

Then field "opgkolnr" has value "2" in row 11
Then field "ebeleggko" has value "" in row 11
Then field "projektgko" has value "" in row 11
Then field "opgkosh" has value "Soll" in row 11
Then field "opgkobubetr" has value "9520.00" in row 11

# Zeile 12
Then field "ebeleg" has value "Test KU UMBU-1" in row 12
Then field "tbeleg" has value "K12P11-2" in row 12
Then field "konto" has value "K 12" in row 12
Then field "projekt" has value "PROJ11" in row 12
Then field "sha" has value "Haben" in row 12
Then field "opzabetr" has value "1190.00" in row 12
Then field "skbetr" has value "0.00" in row 12
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "2" in row 12
Then field "sammleroplnr" has value "4" in row 12
Then field "sammleropanzahl" has value "8" in row 12
Then field "sammlerkonto" has value "K 12" in row 12
Then field "sammlerprojekt" has value "" in row 12
Then field "sammlersh" has value "Haben" in row 12
Then field "sammlerbubetr" has value "9520.00" in row 12
Then field "sammlerskbetr" has value "0.00" in row 12

Then field "opgkolnr" has value "2" in row 12
Then field "ebeleggko" has value "" in row 12
Then field "projektgko" has value "" in row 12
Then field "opgkosh" has value "Soll" in row 12
Then field "opgkobubetr" has value "9520.00" in row 12

# Zeile 13
Then field "ebeleg" has value "Test KU UMBU-1" in row 13
Then field "tbeleg" has value "K12P12-1" in row 13
Then field "konto" has value "K 12" in row 13
Then field "projekt" has value "PROJ12" in row 13
Then field "sha" has value "Haben" in row 13
Then field "opzabetr" has value "1190.00" in row 13
Then field "skbetr" has value "0.00" in row 13
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "2" in row 13
Then field "sammleroplnr" has value "5" in row 13
Then field "sammleropanzahl" has value "8" in row 13
Then field "sammlerkonto" has value "K 12" in row 13
Then field "sammlerprojekt" has value "" in row 13
Then field "sammlersh" has value "Haben" in row 13
Then field "sammlerbubetr" has value "9520.00" in row 13
Then field "sammlerskbetr" has value "0.00" in row 13

Then field "opgkolnr" has value "2" in row 13
Then field "ebeleggko" has value "" in row 13
Then field "projektgko" has value "" in row 13
Then field "opgkosh" has value "Soll" in row 13
Then field "opgkobubetr" has value "9520.00" in row 13

# Zeile 14
Then field "ebeleg" has value "Test KU UMBU-1" in row 14
Then field "tbeleg" has value "K12P12-2" in row 14
Then field "konto" has value "K 12" in row 14
Then field "projekt" has value "PROJ12" in row 14
Then field "sha" has value "Haben" in row 14
Then field "opzabetr" has value "1190.00" in row 14
Then field "skbetr" has value "0.00" in row 14
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "2" in row 14
Then field "sammleroplnr" has value "6" in row 14
Then field "sammleropanzahl" has value "8" in row 14
Then field "sammlerkonto" has value "K 12" in row 14
Then field "sammlerprojekt" has value "" in row 14
Then field "sammlersh" has value "Haben" in row 14
Then field "sammlerbubetr" has value "9520.00" in row 14
Then field "sammlerskbetr" has value "0.00" in row 14

Then field "opgkolnr" has value "2" in row 14
Then field "ebeleggko" has value "" in row 14
Then field "projektgko" has value "" in row 14
Then field "opgkosh" has value "Soll" in row 14
Then field "opgkobubetr" has value "9520.00" in row 14

# Zeile 15
Then field "ebeleg" has value "Test KU UMBU-1" in row 15
Then field "tbeleg" has value "K12P13-1" in row 15
Then field "konto" has value "K 12" in row 15
Then field "projekt" has value "PROJ13" in row 15
Then field "sha" has value "Haben" in row 15
Then field "opzabetr" has value "1190.00" in row 15
Then field "skbetr" has value "0.00" in row 15
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "2" in row 15
Then field "sammleroplnr" has value "7" in row 15
Then field "sammleropanzahl" has value "8" in row 15
Then field "sammlerkonto" has value "K 12" in row 15
Then field "sammlerprojekt" has value "" in row 15
Then field "sammlersh" has value "Haben" in row 15
Then field "sammlerbubetr" has value "9520.00" in row 15
Then field "sammlerskbetr" has value "0.00" in row 15

Then field "opgkolnr" has value "2" in row 15
Then field "ebeleggko" has value "" in row 15
Then field "projektgko" has value "" in row 15
Then field "opgkosh" has value "Soll" in row 15
Then field "opgkobubetr" has value "9520.00" in row 15

# Zeile 16
Then field "ebeleg" has value "Test KU UMBU-1" in row 16
Then field "tbeleg" has value "K12P13-2" in row 16
Then field "konto" has value "K 12" in row 16
Then field "projekt" has value "PROJ13" in row 16
Then field "sha" has value "Haben" in row 16
Then field "opzabetr" has value "1190.00" in row 16
Then field "skbetr" has value "0.00" in row 16
Then field "wechselnum" has value "" in row 1
Then field "wechselfaell" has value "" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1

Then field "sammlerlnr" has value "2" in row 16
Then field "sammleroplnr" has value "8" in row 16
Then field "sammleropanzahl" has value "8" in row 16
Then field "sammlerkonto" has value "K 12" in row 16
Then field "sammlerprojekt" has value "" in row 16
Then field "sammlersh" has value "Haben" in row 16
Then field "sammlerbubetr" has value "9520.00" in row 16
Then field "sammlerskbetr" has value "0.00" in row 16

Then field "opgkolnr" has value "2" in row 16
Then field "ebeleggko" has value "" in row 16
Then field "projektgko" has value "" in row 16
Then field "opgkosh" has value "Soll" in row 16
Then field "opgkobubetr" has value "9520.00" in row 16

# --- Wechselnummer in erster Zeile des Sammlers vorbelegen, Button "Wechsel zuordnen", Wechsel relevante Daten prüfen

And I set field "wechselnum" to "10001" in row 1
And I press button "wechselzuord" in row 1
#
Then field "wechselnum" has value "10001" in row 1
Then field "wechselfaell" has value "30.04.22" in row 1
Then field "kwechsel" has value "" in row 1
Then field "wechselbetr" has value "0.00" in row 1
Then field "wechselnum" has value "10001" in row 2
Then field "wechselfaell" has value "30.04.22" in row 2
Then field "kwechsel" has value "" in row 2
Then field "wechselbetr" has value "0.00" in row 2
Then field "wechselnum" has value "10001" in row 3
Then field "wechselfaell" has value "30.04.22" in row 3
Then field "kwechsel" has value "" in row 3
Then field "wechselbetr" has value "0.00" in row 3
Then field "wechselnum" has value "10001" in row 4
Then field "wechselfaell" has value "30.04.22" in row 4
Then field "kwechsel" has value "" in row 4
Then field "wechselbetr" has value "0.00" in row 4
Then field "wechselnum" has value "10001" in row 5
Then field "wechselfaell" has value "30.04.22" in row 5
Then field "kwechsel" has value "" in row 5
Then field "wechselbetr" has value "0.00" in row 5
Then field "wechselnum" has value "10001" in row 6
Then field "wechselfaell" has value "30.04.22" in row 6
Then field "kwechsel" has value "" in row 6
Then field "wechselbetr" has value "0.00" in row 6
Then field "wechselnum" has value "10001" in row 7
Then field "wechselfaell" has value "30.04.22" in row 7
Then field "kwechsel" has value "" in row 7
Then field "wechselbetr" has value "0.00" in row 7
Then field "wechselnum" has value "10001" in row 8
Then field "wechselfaell" has value "30.04.22" in row 8
Then field "kwechsel" has value "" in row 8
Then field "wechselbetr" has value "0.00" in row 8
#
And I set field "wechselnum" to "10002" in row 9
And I press button "wechselzuord" in row 9
#
Then field "wechselnum" has value "10002" in row 9
Then field "wechselfaell" has value "30.04.22" in row 9
Then field "kwechsel" has value "" in row 9
Then field "wechselbetr" has value "0.00" in row 9
Then field "wechselnum" has value "10002" in row 10
Then field "wechselfaell" has value "30.04.22" in row 10
Then field "kwechsel" has value "" in row 10
Then field "wechselbetr" has value "0.00" in row 10
Then field "wechselnum" has value "10002" in row 11
Then field "wechselfaell" has value "30.04.22" in row 11
Then field "kwechsel" has value "" in row 11
Then field "wechselbetr" has value "0.00" in row 11
Then field "wechselnum" has value "10002" in row 12
Then field "wechselfaell" has value "30.04.22" in row 12
Then field "kwechsel" has value "" in row 12
Then field "wechselbetr" has value "0.00" in row 12
Then field "wechselnum" has value "10002" in row 13
Then field "wechselfaell" has value "30.04.22" in row 13
Then field "kwechsel" has value "" in row 13
Then field "wechselbetr" has value "0.00" in row 13
Then field "wechselnum" has value "10002" in row 14
Then field "wechselfaell" has value "30.04.22" in row 14
Then field "kwechsel" has value "" in row 14
Then field "wechselbetr" has value "0.00" in row 14
Then field "wechselnum" has value "10002" in row 15
Then field "wechselfaell" has value "30.04.22" in row 15
Then field "kwechsel" has value "" in row 15
Then field "wechselbetr" has value "0.00" in row 15
Then field "wechselnum" has value "10002" in row 16
Then field "wechselfaell" has value "30.04.22" in row 16
Then field "kwechsel" has value "" in row 16
Then field "wechselbetr" has value "0.00" in row 16

And I respond with answer "Ja" to the dialog with id "588"
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------------
# OP-Bearbeitung editor "Test_KU_UMBU-1" zeigen, Wechsel relevante Felder prüfen
# Folgende wurden erst beim Seichern des Vorgangs vorbelegt: kwechsel, wechselbetrag, ebeleggko
# ------------------------------------------------------------------------------------------------------------------------------

Given I open an editor "View-Test_KU_UMBU-1" from table "102:11" with command "VIEW" for record "+X20220331-UMBU-1"

Then field "wechselnum" has value "10001" in row 1
Then field "wechselfaell" has value "30.04.22" in row 1
Then field "kwechsel" has value "1" in row 1
Then field "wechselbetr" has value "9520.00" in row 1
Then field "ebeleggko" has value "10001" in row 1
Then field "wechselnum" has value "10001" in row 2
Then field "wechselfaell" has value "30.04.22" in row 2
Then field "kwechsel" has value "1" in row 2
Then field "wechselbetr" has value "0.00" in row 2
Then field "ebeleggko" has value "10001" in row 2
Then field "wechselnum" has value "10001" in row 3
Then field "wechselfaell" has value "30.04.22" in row 3
Then field "kwechsel" has value "1" in row 3
Then field "wechselbetr" has value "0.00" in row 3
Then field "ebeleggko" has value "10001" in row 3
Then field "wechselnum" has value "10001" in row 4
Then field "wechselfaell" has value "30.04.22" in row 4
Then field "kwechsel" has value "1" in row 4
Then field "wechselbetr" has value "0.00" in row 4
Then field "ebeleggko" has value "10001" in row 4
Then field "wechselnum" has value "10001" in row 5
Then field "wechselfaell" has value "30.04.22" in row 5
Then field "kwechsel" has value "1" in row 5
Then field "wechselbetr" has value "0.00" in row 5
Then field "ebeleggko" has value "10001" in row 5
Then field "wechselnum" has value "10001" in row 6
Then field "wechselfaell" has value "30.04.22" in row 6
Then field "kwechsel" has value "1" in row 6
Then field "wechselbetr" has value "0.00" in row 6
Then field "ebeleggko" has value "10001" in row 6
Then field "wechselnum" has value "10001" in row 7
Then field "wechselfaell" has value "30.04.22" in row 7
Then field "kwechsel" has value "1" in row 7
Then field "wechselbetr" has value "0.00" in row 7
Then field "ebeleggko" has value "10001" in row 7
Then field "wechselnum" has value "10001" in row 8
Then field "wechselfaell" has value "30.04.22" in row 8
Then field "kwechsel" has value "1" in row 8
Then field "wechselbetr" has value "0.00" in row 8
Then field "ebeleggko" has value "10001" in row 8
#
Then field "wechselnum" has value "10002" in row 9
Then field "wechselfaell" has value "30.04.22" in row 9
Then field "kwechsel" has value "2" in row 9
Then field "wechselbetr" has value "9520.00" in row 9
Then field "ebeleggko" has value "10002" in row 9
Then field "wechselnum" has value "10002" in row 10
Then field "wechselfaell" has value "30.04.22" in row 10
Then field "kwechsel" has value "2" in row 10
Then field "wechselbetr" has value "0.00" in row 10
Then field "ebeleggko" has value "10002" in row 10
Then field "wechselnum" has value "10002" in row 11
Then field "wechselfaell" has value "30.04.22" in row 11
Then field "kwechsel" has value "2" in row 11
Then field "wechselbetr" has value "0.00" in row 11
Then field "ebeleggko" has value "10002" in row 11
Then field "wechselnum" has value "10002" in row 12
Then field "wechselfaell" has value "30.04.22" in row 12
Then field "kwechsel" has value "2" in row 12
Then field "wechselbetr" has value "0.00" in row 12
Then field "ebeleggko" has value "10002" in row 12
Then field "wechselnum" has value "10002" in row 13
Then field "wechselfaell" has value "30.04.22" in row 13
Then field "kwechsel" has value "2" in row 13
Then field "wechselbetr" has value "0.00" in row 13
Then field "ebeleggko" has value "10002" in row 13
Then field "wechselnum" has value "10002" in row 14
Then field "wechselfaell" has value "30.04.22" in row 14
Then field "kwechsel" has value "2" in row 14
Then field "wechselbetr" has value "0.00" in row 14
Then field "ebeleggko" has value "10002" in row 14
Then field "wechselnum" has value "10002" in row 15
Then field "wechselfaell" has value "30.04.22" in row 15
Then field "kwechsel" has value "2" in row 15
Then field "wechselbetr" has value "0.00" in row 15
Then field "ebeleggko" has value "10002" in row 15
Then field "wechselnum" has value "10002" in row 16
Then field "wechselfaell" has value "30.04.22" in row 16
Then field "kwechsel" has value "2" in row 16
Then field "wechselbetr" has value "0.00" in row 16
Then field "ebeleggko" has value "10002" in row 16
