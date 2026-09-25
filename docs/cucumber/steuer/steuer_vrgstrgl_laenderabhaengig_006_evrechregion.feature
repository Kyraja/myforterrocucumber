# *****************************************************************************
#  Name             : steuer_vrgstrgl_laenderabhaengig_006_evrechregion.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbelegung der VRGSTRGL in EK/VK-Re mit Beruecksichtigung
#                     von Laender/Regionen der Lieferanten/Kunden
#
#
# *****************************************************************************
@persistent
Feature: ssteuer_vrgstrgl_laenderabhaengig_006_evrechregion.feature
Background:


Scenario: EK-Rechnung

Given I open an editor "ek-Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "40002"
Then field "vrgstrgl" has value "EKBAD" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "DEUTSCHLAND" in row 0
Then field "region" has value "BADEN-WUERTTEMBERG" in row 0
Then field "staat2" has value "DEUTSCHLAND" in row 0
Then field "region2" has value "BADEN-WUERTTEMBERG" in row 0
Then field "vstaat" has value "DEUTSCHLAND" in row 0
Then field "rechnustid" has value "DE123456" in row 0
Then field "versustid" has value "DE123456" in row 0
#
And I set field "region" to ""
Then field "vstaatregion" has value "BADEN-WUERTTEMBERG" in row 0
Then field "rechnregion" is empty in row 0
Then field "vrgstrgl" has value "EKIN" in row 0
#
# Datesatz wird nicht gespeichert
And I close the current editor
###############################################################################


Scenario: Rechnung1

Given I open an editor "verkauf" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "20587"
Then field "vrgstrgl" has value "VKBAD" in row 0
Then field "vrgstrglauskl2" has value "VKBAD" in row 0
Then field "staat" has value "DEUTSCHLAND" in row 0
Then field "region" has value "BADEN-WUERTTEMBERG" in row 0
Then field "staat2" has value "DEUTSCHLAND" in row 0
Then field "region2" has value "BADEN-WUERTTEMBERG" in row 0
Then field "vstaat" has value "DEUTSCHLAND" in row 0
Then field "rechnustid" has value "DE123456" in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" has value "BADEN-WUERTTEMBERG" in row 0
Then field "versustid" has value "DE123456" in row 0
#
And I set field "region" to ""
Then field "vstaatregion" has value "BADEN-WUERTTEMBERG" in row 0
Then field "rechnregion" is empty in row 0
Then field "vrgstrglauskl2" has value "VKBAD" in row 0
# VKBAD aus Kunde passt nicht mehr!!!
Then field "vrgstrgl" has value "" in row 0
# ---
#
# Datesatz wird nicht gespeichert
And I close the current editor
###############################################################################
