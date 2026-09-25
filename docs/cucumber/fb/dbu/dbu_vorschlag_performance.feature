# *****************************************************************************
#  Name           : steuerkonfig_performance.feature
#  Autor          : wane
#  Verantwortlich : wane
#  Kontrolle      :
#  Funktion       : Testet Dauerbuchungsvorschlaege auf Performance.
#
#
#  Beschreibung:
#  hier werden verschiedene Dauerbuchungsvorschlaege erzeugt,
#  aber nicht alle werden gespeichert.
#
#  Die Datei wird in einer Schleife ausgefuehrt:
#    siehe https://wiki.abasag.intra/x/Q4AABw
#    oder  https://abascloud.atlassian.net/wiki/x/QQCl4CU
#  Pro einen Durchlauf werden 8 DBVorschlaegen erzeugt, aber nur einer gebucht
#
# *****************************************************************************
#
Feature: Vorgangssteuer-KonfigurationPerformance
Background: Suche der VRGSTRGL uber Konfig.

Scenario: GJ 2001 + Nachbuchungsmonate 13,14 und 15 aus 2000 oeffnen

# Abschlussmaske oeffnen
Given I open an editor "Abschl" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set field "such" to "ALLESOFFEN2001"
#
And I press button "ekbbu" in row 1
And I press button "vkbbu" in row 1
And I press button "ekbbu" in row 4
And I press button "vkbbu" in row 4
#
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor
And I close the current editor
###############################################################################

Scenario Outline: Vorschlaege fuer einzelne DB-Regeln mit vielen Zeilen aufrufen

#
# Vorschlaege werden generell nicht gebucht
#
Given I open an editor "DBV1" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBVT<id>"
And I set field "selr" to "23000tag"
And I set field "selist" to "ja"
And I set field "selerstbd" to "1.1.99"
And I set field "selletztbd" to "22.03.01"
And I press button "selladen"
And I close the current editor


Given I open an editor "DBV1a" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBVT<id>"
And I set field "selr" to "23000tag"
And I set field "selist" to "ja"
And I set field "selerstbd" to "1.1.99"
And I set field "selletztbd" to "21.02.01"
And I press button "selladen"
And I close the current editor


Given I open an editor "DBV1" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBVT<id>"
And I set field "selr" to "23000tag"
And I set field "selist" to "ja"
And I set field "selerstbd" to "1.1.01"
And I set field "selletztbd" to "15.01.01"
And I press button "selladen"
And I close the current editor


Given I open an editor "DBV2" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBVQ<id>"
And I set field "selr" to "31000qr"
And I set field "selerstbd" to "1.1.99"
And I set field "selletztbd" to "31.05.01"
And I press button "selladen"
And I close the current editor


Given I open an editor "DBV3" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBWW<id>"
And I set field "selr" to "21000wr"
And I set field "selerstbd" to "1.1.99"
And I set field "selletztbd" to "31.05.01"
And I press button "selladen"
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################


#  Scenario Outline: Vorschlag fuer eine DB-Regeln mit vielen Zeilen aufrufen und verbuchen
#
#  Given I open an editor "DBV33" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
#  And I set field "such" to "DBVF<id>"
#  And I set field "selr" to "23000tag"
#  And I set field "selist" to "ja"
#  And I set field "selerstbd" to "1.1.00"
#  And I set field "selletztbd" to "25.03.0<id>"
#  And I press button "selladen"
#  #
#  And I press button "bucheschl" to open a subeditor for "Verbuchen" in row 0 with dialog "6932" and answer "Ja"
#
#  And I save the current editor
#  And I close the current editor
#
#  Examples:
#                | id   |
#  #LOOP 1 to 1  | #id# |
#                | 1    |
#  ###############################################################################


Scenario Outline: Vorschlaege fuer alle oder einzelne DB-Regeln, aber fuer die kleinen Perioden
#
# Vorschlaege werden generell nicht gebucht
#

Given I open an editor "DBV21" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBVA<id>"
And I set field "selerstbd" to "1.1.02"
And I set field "selletztbd" to "15.1.02"
And I press button "selladen"
#
And I close the current editor


Given I open an editor "DBV22" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBVB<id>"
And I set field "selerstbd" to "16.1.02"
And I set field "selletztbd" to "10.2.02"
And I press button "selladen"
#
And I close the current editor


Given I open an editor "DBV23" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBVC<id>"
And I set field "selr" to "21000wr"
And I set field "selist" to "ja"
And I set field "selerstbd" to "7.12.01"
And I set field "selletztbd" to "11.3.02"
And I press button "selladen"
#
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################


# Scenario: Vorschlaege fuer alle DB-Regeln -> eine grossse Tabelle
#
# #
# # Vorschlaege werden generell nicht gebucht
# #
# Given I open an editor "DBV2331" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
# And I set field "such" to "DBVAGGG1"
# # And I set field "selist" to "ja"
# And I set field "selerstbd" to "1.1.01"
# And I set field "selletztbd" to "17.2.01"
# And I press button "selladen"
# #
# And I close the current editor
# ###############################################################################


Scenario Outline: Vorschlag fuer kleine DB-Regeln fuer eine grossse Periode verbuchen

Given I open an editor "DBV_2671" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBVS33<id>"
And I set field "selr" to "230tag"
# gebuchten auch laden
And I set field "selist" to "ja"
And I set field "selerstbd" to "1.1.00"
And I set field "selletztbd" to "25.3.0<id>"
And I press button "selladen"
And I press button "bucheschl" to open a subeditor for "Verbuchen" in row 0 with dialog "6932" and answer "Ja"

And I save the current editor
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################


Scenario: Vorschlag fuer alle DB-Regeln fuer eine grossse Periode verbuchen -> grosse Tabelle

Given I open an editor "DBV_2671a" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBVS312"
And I set field "selerstbd" to "15.1.02"
And I set field "selletztbd" to "01.3.02"
And I press button "selladen"
And I press button "bucheschl" to open a subeditor for "Verbuchen" in row 0 with dialog "6932" and answer "Ja"

And I save the current editor
And I close the current editor
###############################################################################


