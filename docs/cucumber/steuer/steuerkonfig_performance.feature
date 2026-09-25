# *****************************************************************************
#  Name           : steuerkonfig_performance.feature
#  Autor          : wane
#  Verantwortlich : wane
#  Kontrolle      :
#  Funktion       : Testet Vorgangssteuer-Konfiguration bezueglich der Performance.
#
#
#  Beschreibung:
#  hier werden in EK-/VK-Vorgaengen (AU/BE, LS, RE) die 'Kern'-Suchen in
#  Vorgangssteuer-Konfiguration provoziert in dem man entweder:
#   * KU/LI aendert
#   * VRGSTRGL aendert
#   * Fixierung der VRGSTRGL im Vorgang aendert
#   * oder USTID des Rechnungstellers/-empfaengers aendert
#  Dabei handelt es sich um einen reinen Editiertest - es werden keine
#  Daten/Objekte gespeichert.
#
#  Die Datei wird in einer Schleife ausgefuehrt:
#    siehe https://wiki.abasag.intra/x/Q4AABw
#    oder  https://abascloud.atlassian.net/wiki/x/QQCl4CU
#  Pro einen Durchlauf werden ca. 420 Suchen ausgefuehrt
#
# *****************************************************************************
#
Feature: Vorgangssteuer-KonfigurationPerformance
Background: Suche der VRGSTRGL uber Konfig.

###############################################################################
#                                                                             #
# V E R K A U F                                                               #
#                                                                             #
###############################################################################

Scenario Outline: VK AU
Given I open an editor "AU" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001" in row 0
And I set field "such" to "AU<id>" in row 0
#
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "003" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10000" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10001" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10002" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10003" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "50006" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "50007" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "50008" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "70010" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "70011" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "70012" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "70013" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "5" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10008" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10009" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10010" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "50002" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "4" in row 0
And I set field "rechnustid" to "FR4123456" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "002" in row 0
And I set field "rechnustid" to "FR0023456" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "004" in row 0
And I set field "rechnustid" to "FR0043456" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "006" in row 0
And I set field "rechnustid" to "FR006123456" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "008" in row 0
And I set field "rechnustid" to "FR008336" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################

Scenario Outline: VK LS
Given I open an editor "LS" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "001" in row 0
And I set field "such" to "LS<id>" in row 0
#
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "003" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10000" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10001" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10002" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10003" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "50006" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "50007" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "50008" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "70010" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "70011" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "70012" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "70013" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "5" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10008" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10009" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10010" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "50002" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "4" in row 0
And I set field "rechnustid" to "FR4123456" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "002" in row 0
And I set field "rechnustid" to "FR0023456" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "004" in row 0
And I set field "rechnustid" to "FR0043456" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "006" in row 0
And I set field "rechnustid" to "FR006123456" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "008" in row 0
And I set field "rechnustid" to "FR008336" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################

Scenario Outline: VK RE
Given I open an editor "RE" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "001" in row 0
And I set field "such" to "LS<id>" in row 0
#
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "003" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10000" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10001" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10002" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10003" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "50006" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "50007" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "50008" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "70010" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "70011" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "70012" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "70013" in row 0
And I set field "vrgstrgl" to "VKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "5" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10008" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10009" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "10010" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "50002" in row 0
And I set field "vrgstrgl" to "VKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "4" in row 0
And I set field "rechnustid" to "FR4123456" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "002" in row 0
And I set field "rechnustid" to "FR0023456" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "004" in row 0
And I set field "rechnustid" to "FR0043456" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "006" in row 0
And I set field "rechnustid" to "FR006123456" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "kunde" to "008" in row 0
And I set field "rechnustid" to "FR008336" in row 0
And I set field "vrgstrgl" to "VKEUFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################

###############################################################################
#                                                                             #
# E I N K A U F                                                               #
#                                                                             #
###############################################################################

Scenario Outline: EK BE
Given I open an editor "BE" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001" in row 0
And I set field "such" to "BE<id>" in row 0
#
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "002" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "200" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60001" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60002" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60003" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60004" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60001" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60002" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60003" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60004" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60005" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60006" in row 0
And I set field "vrgstrgl" to "EKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60007" in row 0
And I set field "vrgstrgl" to "EKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "003" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "004" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "70009" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "003" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "004" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "70009" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################

Scenario Outline: EK LS
Given I open an editor "LS" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "001" in row 0
And I set field "such" to "LS<id>" in row 0
#
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "002" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "200" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60001" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60002" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60003" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60004" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60001" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60002" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60003" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60004" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60005" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60006" in row 0
And I set field "vrgstrgl" to "EKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60007" in row 0
And I set field "vrgstrgl" to "EKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "003" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "004" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "70009" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "003" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "004" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "70009" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################

Scenario Outline: EK RE
Given I open an editor "RE" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001" in row 0
And I set field "such" to "LS<id>" in row 0
#
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "002" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "200" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60001" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60002" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60003" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60004" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60001" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60002" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60003" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60004" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60005" in row 0
And I set field "vrgstrgl" to "EKIN<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60006" in row 0
And I set field "vrgstrgl" to "EKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "60007" in row 0
And I set field "vrgstrgl" to "EKAUSFREI<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "003" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "004" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "70009" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "003" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "004" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I set field "lief" to "70009" in row 0
And I set field "rechnustid" to "FR123456" in row 0
And I set field "vrgstrgl" to "EKEUSOFORT<id>"
Then field "fixvrgstrgl" has value "ja" in row 0
And I set field "fixvrgstrgl" to "nein" in row 0
#
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################

