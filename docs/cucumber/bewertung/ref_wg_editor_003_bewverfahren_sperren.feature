# *****************************************************************************
#  Name             : ref_wg_editor_003_bewverfahren_sperren.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        :
#  Funktion         : Warengruppen und Bewertungsverfahren
#
#                    kurze Zusammenfassung:
#                      @FALL-WG_anlegen
#                          Versuch eine WG mit dem gesperren Bewertungsverfahren anzulegen
#                      @FALL-LIFO_FIFO
#                          Versuch das Bewertungsverfahren (LIFO bzw. FIFO) ohne Allein-Sperre zu aendern
#                      @FALL-WG_aendern
#                          Versuch eine WG mit einem gesperrten Verfahren zu editieren
#                    ==========================================================
#
# *****************************************************************************
@persistent
Feature: WG; Bewertungsverfahren
Background: Test von Sperren von Bewertungsverfahren
Given I set the fake date to "08.01.2002"


@FALL-WG_anlegen
Scenario: Versuch eine WG durch das Kopieren bzw. NEU mit dem gesperren Bewertungsverfahren neu anzulegen

Given I open an editor "wg" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "777"
And I set field "such" to "BLABLA1"
And I set field "namebspr" to "ein Versuch Wert"
# 712 de   |Bewertungsverfahren existiert nicht
Then setting field "ekbewverf" to "2" in row 0 throws the exception "712"
# 8480 de   |Bewertungsverfahren ist gesperrt.
Then setting field "ekbewverf" to "1" in row 0 throws the exception "8480"
And I set field "ekbewverf" to "6"
Then field "wgstd" has value "ja" in row 0
And I set field "bestausekso" to ""
Then field "wgstd" has value "nein" in row 0
# es wird nicht gespeichert
And I close the current editor

Given I open an editor "wg2" from table "(Company):(MaterialGroup)" with command "NEW" for record ""
And I set field "nummer" to "777"
And I set field "such" to "BLABLA2"
And I set field "namebspr" to "Versuch 2"
# 712 de   |Bewertungsverfahren existiert nicht
Then setting field "ekbewverf" to "2" in row 0 throws the exception "712"
# 8480 de   |Bewertungsverfahren ist gesperrt.
Then setting field "ekbewverf" to "1" in row 0 throws the exception "8480"
And I set field "ekbewverf" to "6"
Then field "wgstd" has value "nein" in row 0
Then saving the current editor throws the exception "Bitte Konto eintragen"
# es wird nicht gespeichert
And I close the current editor
#########################################################################################


@FALL-LIFO_FIFO
Scenario: Versuch Bewertungsverfahren LIFO/FIFO ohne Allein-Sperre zu aendern

Given I open an editor "wg" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "12001vl"
Then field "wgstd" has value "ja" in row 0
# LIFO
Then field "ekbewverf" has value "4" in row 0
Then field "ekbewverf" is not modifiable
# 203 de   |Eintrag ist schreibgeschuetzt
Then setting field "ekbewverf" to "6" in row 0 throws the exception "203"
# es wird nicht gespeichert
And I close the current editor


Given I open an editor "wg2" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "12002vf"
Then field "wgstd" has value "ja" in row 0
# FIFO
Then field "ekbewverf" has value "5" in row 0
Then field "ekbewverf" is not modifiable
# 203 de   |Eintrag ist schreibgeschuetzt
Then setting field "ekbewverf" to "6" in row 0 throws the exception "203"
# es wird nicht gespeichert
And I close the current editor
#########################################################################################


@FALL-WG_aendern
Scenario: Versuch eine WG mit einem gesperrten Verfahren zu editieren


Given I open an editor "wg" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "123456"
And I set field "such" to "KOPIE55"
Then field "wgstd" is not modifiable
Then field "wgstd" has value "nein" in row 0
Then field "ekbewverf" has value "1" in row 0
# das Verfahren 1 ist gesperrt -> Speichern muss unmoeglich sein
And saving the current editor throws the exception "8480"
And I set field "ekbewverf" to "3"
And I save the current editor
And I close the current editor
#########################################################################################

