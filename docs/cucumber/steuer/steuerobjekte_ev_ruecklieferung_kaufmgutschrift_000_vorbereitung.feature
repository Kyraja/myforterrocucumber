# *****************************************************************************
#  Name             : steuerobjekte_ev_ruecklieferung_kaufmgutschrift_000_vorbereitung.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Ueberwachung von steuerlichen Objekten bei
#                     Storno und Ruecklieferungen in Einkauf:
#                     -  Stammdaten anlegen
#
#
# *****************************************************************************

@persistent
Feature: steuerobjekte_ev_ruecklieferung_kaufmgutschrift_000_vorbereitung.feature
Background: steuerliche Objekten in EK

Scenario: 1. Konten kopieren

Given I open an editor "konto1" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10000c"
And I set field "namebspr" to "Kopie von 10000; Roh- und Hilfsstoffe"
And I save the current editor
And I close the current editor

Given I open an editor "konto2" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "44000c"
And I set field "namebspr" to "Kopie von 44000; Erloese 19% Umsatzsteuer"
And I save the current editor
And I close the current editor


Given I open an editor "konto3" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "44000c2"
And I set field "namebspr" to "Kopie2 von 44000; Erloese 19% Umsatzsteuer"
And I save the current editor
And I close the current editor
#####################################################################################################################################

