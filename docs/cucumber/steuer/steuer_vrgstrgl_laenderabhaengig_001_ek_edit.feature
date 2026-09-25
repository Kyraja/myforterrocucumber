# *****************************************************************************
#  Name             : steuer_vrgstrgl_laenderabhaengig_001_ek_edit.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbelegung der VRGSTRGL in Einkauf mit Beruecksichtigung
#                     von Laender/Regionen der Lieferanten
#
#                    Hinweis: die Datei wird als Vorlage genutzt.
#
#
# *****************************************************************************
@persistent
Feature: steuer_vrgstrgl_laenderabhaengig_001_ek_edit.feature
Background:


Scenario: Rechnung1

Given I open an editor "ek-Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "10010"
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" has value "EKIN" in row 0
Then field "staat" has value "DEUTSCHLAND" in row 0
Then field "region" has value "RHEINLAND-PFALZ" in row 0
Then field "staat2" has value "DEUTSCHLAND" in row 0
Then field "region2" has value "RHEINLAND-PFALZ" in row 0
Then field "vstaat" has value "DEUTSCHLAND" in row 0
Then field "rechnustid" has value "DE123456" in row 0
Then field "versustid" has value "DE123456" in row 0
#
And I set field "vrgstrgl" to "EKIN"
# Jetzt wurde VRGSTRGL exta eingetragen -> kommt nicht aus dem PKonto
Then field "vrgstrglauskl2" has value "EKIN" in row 0
Then field "fixvrgstrgl" has value "ja" in row 0
Then field "rechnland" has value "DEUTSCHLAND" in row 0
Then field "rechnregion" has value "RHEINLAND-PFALZ" in row 0
#
And I set field "fixvrgstrgl" to "nein"
Then field "vrgstrglauskl2" has value "EKIN" in row 0
Then field "fixvrgstrgl" has value "nein" in row 0
#
# ...Lieferantenwechsel...
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
# ---
And I set field "vstaat" to "CHINA"
And I set field "rechnustid" to "IT123456"
Then field "vrgstrgl" has value "EKBLA3" in row 0
# ...Lieferantenwechsel...
And I set field "lief" to "60013"
Then field "vrgstrgl" has value "EKUSA" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "USA" in row 0
Then field "region" has value "HI" in row 0
Then field "staat2" has value "USA" in row 0
Then field "region2" has value "HI" in row 0
Then field "vstaat" has value "USA" in row 0
Then field "rechnustid" is empty in row 0
Then field "versustid" is empty in row 0
# ...Lieferantenwechsel...
And I set field "lief" to "840015"
Then field "vrgstrgl" has value "EKNY" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "USA" in row 0
Then field "region" has value "NY" in row 0
Then field "staat2" has value "USA" in row 0
Then field "region2" has value "NY" in row 0
Then field "vstaat" has value "USA" in row 0
Then field "rechnustid" is empty in row 0
Then field "versustid" is empty in row 0
# ...Lieferantenwechsel...
And I set field "lief" to "840020"
Then field "vrgstrgl" has value "EKUSA" in row 0
Then field "vrgstrglauskl2" has value "EKUSA" in row 0
Then field "staat" has value "USA" in row 0
Then field "region" has value "NY" in row 0
Then field "staat2" has value "USA" in row 0
Then field "region2" has value "NY" in row 0
Then field "vstaat" has value "USA" in row 0
Then field "rechnustid" is empty in row 0
Then field "versustid" is empty in row 0
#
And I set field "vrgstrgl" to "EKNY"
Then field "vrgstrglauskl2" has value "EKUSA" in row 0
Then field "fixvrgstrgl" has value "ja" in row 0
#
# Wir haben selbst VRSTRGL eingatragen -> nicht aua PKonto
And I set field "vrgstrgl" to "EKUSA"
Then field "vrgstrglauskl2" has value "EKUSA" in row 0
Then field "fixvrgstrgl" has value "ja" in row 0
#
And I set field "fixvrgstrgl" to "nein"
Then field "vrgstrgl" has value "EKUSA" in row 0
Then field "vrgstrglauskl2" has value "EKUSA" in row 0
Then field "fixvrgstrgl" has value "nein" in row 0
#
# ...Lieferantenwechsel...
And I set field "lief" to "2011"
Then field "vrgstrgl" has value "EKTOS" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
# ---
And I set field "rechnustid" to "FR123456"
Then field "vrgstrgl" has value "EKBLA4" in row 0
# ...Lieferantenwechsel...
And I set field "lief" to "2012"
Then field "vrgstrgl" has value "EKITAL" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "LOM" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "LOM" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123545" in row 0
Then field "versustid" has value "IT123545" in row 0
# ---
# ...Lieferantenwechsel + Regionwechsel...
And I set field "lief" to "840015"
Then field "vrgstrgl" has value "EKNY" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "staat" has value "USA" in row 0
Then field "region" has value "NY" in row 0
Then field "staat2" has value "USA" in row 0
Then field "region2" has value "NY" in row 0
Then field "vstaat" has value "USA" in row 0
Then field "rechnustid" is empty in row 0
Then field "rechnland" has value "USA" in row 0
Then field "rechnregion" has value "NY" in row 0
Then field "versustid" is empty in row 0
# ---
And I set field "region2" to "NM"
Then field "vrgstrgl" has value "EKUSA" in row 0
Then field "vrgstrglauskl2" is empty in row 0
# ---
And I set field "region" to "NM"
Then field "vrgstrgl" has value "EKUSA" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "rechnland" has value "USA" in row 0
# wird nur in RE funktionieren, deswegen auskommentiert
# Then field "rechnregion" has value "NM" in row 0
#
# ...Lieferantenwechsel...
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
And I set field "region2" to ""
Then field "vstaatregion" is empty in row 0
Then field "rechnregion" has value "BADEN-WUERTTEMBERG" in row 0
Then field "vrgstrgl" has value "EKIN" in row 0
#
# Datesatz wird nicht gespeichert
And I close the current editor
###############################################################################

