# *****************************************************************************
#  Name             : steuer_vrgstrgl_laenderabhaengig_002_vk_edit.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbelegung der VRGSTRGL in Verkauf mit Beruecksichtigung
#                     von Laender/Regionen der Kunden
#
#
#                    Hinweis: die Datei wird als Vorlage genutzt.
#
#
# *****************************************************************************
@persistent
Feature: steuer_vrgstrgl_laenderabhaengig_002_vk_edit.feature
Background:



Scenario: Rechnung1

Given I open an editor "verkauf" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "050"
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "DEUTSCHLAND" in row 0
Then field "region" has value "BREMEN" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "DE123456" in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" has value "BREMEN" in row 0
Then field "versustid" has value "DE123456" in row 0
# ---
And I set field "vstaat" to "CHINA"
And I set field "rechnustid" to "IT123456"
Then field "vrgstrgl" has value "VKBLA1" in row 0
# ...Kundenwechsel...
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
# ...Kundenwechsel...
And I set field "kunde" to "40001"
Then field "vrgstrgl" has value "VKMEX" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "USA" in row 0
Then field "region" has value "HI" in row 0
Then field "staat2" has value "MEXIKO" in row 0
Then field "region2" has value "TAB" in row 0
Then field "vstaat" has value "MEXIKO" in row 0
Then field "rechnustid" is empty in row 0
Then field "rechnland" has value "USA" in row 0
Then field "rechnregion" has value "HI" in row 0
Then field "versustid" is empty in row 0
# ...Kundenwechsel...
And I set field "kunde" to "40002"
Then field "vrgstrgl" has value "VKNY" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "USA" in row 0
Then field "region" has value "NY" in row 0
Then field "staat2" has value "USA" in row 0
Then field "region2" has value "NY" in row 0
Then field "vstaat" has value "USA" in row 0
Then field "rechnustid" is empty in row 0
Then field "versustid" is empty in row 0
# ...Kundenwechsel...
And I set field "kunde" to "2011"
Then field "vrgstrgl" has value "VKTOS" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
# ...Kundenwechsel...
And I set field "kunde" to "70008"
Then field "vrgstrgl" has value "VKITAL" in row 0
Then field "vrgstrglauskl2" has value "VKITAL" in row 0
Then field "fixvrgstrgl" has value "nein" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
#
# wir haben VRGSTRGL selbst eingetragen -> nicht aus PKonto
And I set field "vrgstrgl" to "VKITAL"
Then field "vrgstrglauskl2" has value "VKITAL" in row 0
Then field "rechnland" has value "ITALIEN" in row 0
Then field "rechnregion" has value "TOS" in row 0
Then field "fixvrgstrgl" has value "ja" in row 0
#
# wir haben VRGSTRGL selbst eingetragen -> nicht aus PKonto
And I set field "vrgstrgl" to "VKTOS"
Then field "vrgstrglauskl2" has value "VKITAL" in row 0
Then field "fixvrgstrgl" has value "ja" in row 0
Then field "rechnland" has value "ITALIEN" in row 0
Then field "rechnregion" has value "TOS" in row 0
#
# Fixierung entfernen
And I set field "fixvrgstrgl" to "nein"
Then field "vrgstrgl" has value "VKITAL" in row 0
Then field "vrgstrglauskl2" has value "VKITAL" in row 0
Then field "fixvrgstrgl" has value "nein" in row 0
# ...Kundenwechsel...
And I set field "kunde" to "2012"
Then field "vrgstrgl" has value "VKITAL" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "LOM" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "LOM" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123545" in row 0
Then field "rechnland" has value "ITALIEN" in row 0
Then field "rechnregion" has value "LOM" in row 0
Then field "versustid" has value "IT123545" in row 0
#
# ...Kundenwechsel...
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
# hier wird sich nix aendern, weil VRGSTRGL aus dem Kunde kommt
And I set field "region" to ""
And I set field "region2" to ""
And I set field "rechnustid" to ""
And I set field "versustid" to ""
Then field "vstaatregion" is empty in row 0
Then field "vrgstrglauskl2" has value "VKBAD" in row 0
# VKBAD aus Kunde passt nicht mehr!!!
Then field "vrgstrgl" has value "" in row 0
#
# ...Kundenwechsel...
And I set field "kunde" to "2011"
Then field "vrgstrgl" has value "VKTOS" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
#
And I set field "region2" to ""
Then field "vstaatregion" is empty in row 0
# hier bleibt VKTOS, weil in Konfig nur RE-Empfaenger-Region konfiguriert ist
Then field "vrgstrgl" has value "VKTOS" in row 0
# Datesatz wird nicht gespeichert
And I close the current editor
###############################################################################

