# *****************************************************************************
#  Name             : steuer_vrgstrgl_laenderabhaengig_004_storno_kgs.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbelegung der VRGSTRGL in Einkauf mit Beruecksichtigung
#                     von Laender/Regionen der Lieferanten
#
#
# *****************************************************************************
@persistent
Feature: steuer_vrgstrgl_laenderabhaengig_004_storno_kgs.feature
Background:


Scenario: Ruecklieferung Einkauf

Given I open an editor "ek-Bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "2011"
Then field "vrgstrgl" has value "EKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
And I set field "num4" to "200-BE"
And I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "platz" to "F3" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "11.11" in row 1
Then field "strgl" has value "EKEUSOFORT-1-W-89" in row 1
Then field "zstrgl" has value "EKEUSOFORT-1-W-89-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "steuer" has value "1" in row 1
And I save the current editor

# Rechnung mit WB anlegen + verbuchen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ek-Bestellung"
And I set field "num4" to "200-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
Then field "vrgstrgl" has value "EKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
And I set field "mge" to "200" in row 1
And I set field "preis" to "11.22" in row 1
Then field "strgl" has value "EKEUSOFORT-1-W-89" in row 1
Then field "zstrgl" has value "EKEUSOFORT-1-W-89-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "steuer" has value "1" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung von 200 Stk. -> komplett
Given I open an editor "ruecklief" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+200-RE"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "vrgstrgl" has value "EKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
And I set field "num4" to "200-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-200" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS zu Ruecklieferschein
Given I open an editor "KGS200" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief"
And I set field "num4" to "200-KGS"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
Then field "vrgstrgl" has value "EKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
#
Then field "strgl" has value "EKEUSOFORT-1-W-89" in row 1
Then field "zstrgl" has value "EKEUSOFORT-1-W-89-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "steuer" has value "1" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
###############################################################################

Scenario: Storno Einkauf

Given I open an editor "ek-Bestellung1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "2011"
Then field "vrgstrgl" has value "EKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
And I set field "num4" to "300-BE"
And I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "300" in row 1
And I set field "preis" to "11.11" in row 1
And I set field "platz" to "F3" in row 1
Then field "strgl" has value "EKEUSOFORT-1-W-89" in row 1
Then field "zstrgl" has value "EKEUSOFORT-1-W-89-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "steuer" has value "1" in row 1
And I save the current editor

# Rechnung mit WB anlegen + verbuchen
Given I open an editor "ek-lieferschein1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ek-Bestellung1"
And I set field "num4" to "300-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
Then field "vrgstrgl" has value "EKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
And I set field "mge" to "300" in row 1
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung mit WB anlegen + verbuchen
Given I open an editor "rechnung1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ek-lieferschein1"
And I set field "num4" to "300-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
Then field "vrgstrgl" has value "EKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
And I set field "mge" to "300" in row 1
And I set field "preis" to "10.55" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Given I open an editor "rechn-storno1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+300-RE"
Then I set field "nummer" to "300-SRE"
Then field "vrgstrgl" has value "EKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "lief-storno1" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "300-LS"
Then I set field "nummer" to "300-SLS"
Then field "vrgstrgl" has value "EKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
#
Then field "strgl" has value "EKEUSOFORT-1-W-89" in row 1
Then field "zstrgl" has value "EKEUSOFORT-1-W-89-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "steuer" has value "1" in row 1
And I save the current editor
And I close the current editor
###############################################################################

Scenario: Ruecklieferung Verkauf

Given I open an editor "vk-auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "2011"
Then field "vrgstrgl" has value "VKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
And I set field "num3" to "200-AU"
And I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "platz" to "F3" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "11.11" in row 1
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "steuer" has value "0" in row 1
And I save the current editor

# Rechnung mit WB anlegen + verbuchen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "vk-auftrag"
And I set field "num3" to "200-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
Then field "vrgstrgl" has value "VKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
And I set field "mge" to "200" in row 1
And I set field "preis" to "11.22" in row 1
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "steuer" has value "0" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung von 200 Stk. -> komplett
Given I open an editor "ruecklief" from table "(Sales):(Invoice)" with command "RETURN" for record "+200-RE"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "vrgstrgl" has value "VKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
And I set field "num3" to "200-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "201" in row 1
And I set field "mge" to "-200" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS zu Ruecklieferschein
Given I open an editor "KGS200" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief"
And I set field "num3" to "200-KGS"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
Then field "vrgstrgl" has value "VKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
#
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "steuer" has value "0" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
###############################################################################

Scenario: Storno Verkauf

Given I open an editor "vk-auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "2011"
Then field "vrgstrgl" has value "VKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
And I set field "num3" to "300-AU"
And I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "300" in row 1
And I set field "preis" to "11.11" in row 1
And I set field "platz" to "F3" in row 1
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "steuer" has value "0" in row 1
And I save the current editor

# Rechnung mit WB anlegen + verbuchen
Given I open an editor "vk-lieferschein1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "vk-auftrag1"
And I set field "num3" to "300-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
Then field "vrgstrgl" has value "VKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
And I set field "mge" to "300" in row 1
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung mit WB anlegen + verbuchen
Given I open an editor "rechnung1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "vk-lieferschein1"
And I set field "num3" to "300-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
Then field "vrgstrgl" has value "VKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
And I set field "mge" to "300" in row 1
And I set field "preis" to "10.55" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Given I open an editor "rechn-storno1" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+300-RE"
Then I set field "nummer" to "300-SRE"
Then field "vrgstrgl" has value "VKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
#
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "steuer" has value "0" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "lief-storno1" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "300-LS"
Then I set field "nummer" to "300-SLS"
Then field "vrgstrgl" has value "VKTOS" in row 0
Then field "staat" has value "ITALIEN" in row 0
Then field "region" has value "TOS" in row 0
Then field "staat2" has value "ITALIEN" in row 0
Then field "region2" has value "TOS" in row 0
Then field "vstaat" has value "ITALIEN" in row 0
Then field "rechnustid" has value "IT123456" in row 0
Then field "versustid" has value "IT123456" in row 0
#
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "steuer" has value "0" in row 1
And I save the current editor
And I close the current editor
###############################################################################

