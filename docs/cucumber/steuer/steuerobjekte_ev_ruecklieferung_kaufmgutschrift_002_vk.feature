# *****************************************************************************
#  Name             : steuerobjekte_ev_ruecklieferung_kaufmgutschrift_002_vk.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Ueberwachung von steuerlichen Objekten bei
#                     Storno und Ruecklieferungen in Verkauf
#
#        Scenario: 1. Mit Vorkasse; AU-RE-LS-RLS-GS  -> STRGL in der Zeile der KGS geaendert
#        Scenario: 2. AU-LS-RE-RLS-GS  -> ohne weitere Manipulationen
#        Scenario: 3. AU-LS-RE-RLS-GS  -> VRGSTRGL im KGS geaendert
#        Scenario: 4. AU-LS-RE-RLS-GS  -> Konto im KGS geaendert
# *****************************************************************************

@persistent
Feature: steuerobjekte_ev_ruecklieferung_kaufmgutschrift_002_vk.feature
Background: steuerliche Objekten in VK

Scenario: 1. Mit Vorkasse; AU-RE-LS-RLS-GS  -> STRGL in der Zeile geaendert

Given I open an editor "auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "0001au"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "3.15" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "81" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47365" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "sktoustpos" has value "81" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "581" in row 1
#
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I set field "proz" to "5" in row 1
Then field "proz" has value "5" in row 1
And I save the current editor


# Auftrag in Rechnung ueberfuehren -> Vorkasse
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag1"
And I set field "nummer" to "1revor"
And I set field "tterm" to "."
And I set field "fakt" to "nein"
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "81" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47365" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "sktoustpos" has value "81" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "581" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Auftrag beliefern
Given I open an editor "ls-1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag1"
And I set field "nummer" to "1ls"
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "81" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47365" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "sktoustpos" has value "81" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "581" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor

# Ruecklieferung von 25 Stk
Given I open an editor "rls-1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "ls-1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "1rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "203" in row 1
And I set field "mge" to "-25" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "kgs1" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "rls-1"
And I set field "nummer" to "1gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "81" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47365" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "sktoustpos" has value "81" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "581" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I set field "strgl" to "5006" in row 1
# Felder erneut abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47300" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Felder in Rechnung/KGS nochmal kontrollieren
Given I open an editor "kontrolle" from table "(Sales):(Invoice)" with command "VIEW" for record "+1gs"
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47300" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I close the current editor
#####################################################################################################################################


Scenario: 2. AU-LS-RE-RLS-GS  -> ohne weitere Manipulationen

Given I open an editor "auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "0002au"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "3.15" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "81" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47365" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "sktoustpos" has value "81" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "581" in row 1
#
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I set field "proz" to "5" in row 1
Then field "proz" has value "5" in row 1
And I save the current editor

# Auftrag beliefern
Given I open an editor "ls-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag2"
And I set field "nummer" to "2ls"
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "81" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47365" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "sktoustpos" has value "81" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "581" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# LS bezahlen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-2"
And I set field "nummer" to "2re"
And I set field "tterm" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "81" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47365" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "sktoustpos" has value "81" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "581" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 25 Stk
Given I open an editor "rls-2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "ls-2"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "2rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "201" in row 1
And I set field "mge" to "-25" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "kgs2" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "rls-2"
And I set field "nummer" to "2gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "81" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47365" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "sktoustpos" has value "81" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "581" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Felder in Rechnung nochmal kontrollieren
Given I open an editor "kontrolle" from table "(Sales):(Invoice)" with command "VIEW" for record "+2gs"
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "81" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47365" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "sktoustpos" has value "81" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "581" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I close the current editor
#####################################################################################################################################


Scenario: 3. AU-LS-RE-RLS-GS -> VRGSTRGL im KGS geaendert

Given I open an editor "auftrag3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "10010"
And I set field "nummer" to "0003au"
And I set field "rechnustid" to "IT1234567"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "3.15" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKEUFREI" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "stdkto" has value "44000" in row 1
Then field "konto" has value "43150" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKEUFREI-0-41" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "41" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47301" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "sktoustpos" has value "41" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "0" in row 1
Then field "zmart" has value "Ware" in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I set field "proz" to "5" in row 1
Then field "proz" has value "5" in row 1
And I save the current editor

# Auftrag beliefern
Given I open an editor "ls-3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag3"
And I set field "nummer" to "3ls"
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKEUFREI" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "stdkto" has value "44000" in row 1
Then field "konto" has value "43150" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKEUFREI-0-41" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "41" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47301" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "sktoustpos" has value "41" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" has value "Ware" in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# LS bezahlen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-3"
And I set field "nummer" to "3re"
And I set field "tterm" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKEUFREI" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "stdkto" has value "44000" in row 1
Then field "konto" has value "43150" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKEUFREI-0-41" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "41" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47301" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "sktoustpos" has value "41" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" has value "Ware" in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 25 Stk
Given I open an editor "rls-3" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "ls-3"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "3rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "201" in row 1
And I set field "mge" to "-25" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "kgs3" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "rls-3"
And I set field "nummer" to "3gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrgl" has value "VKEUFREI" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "stdkto" has value "44000" in row 1
Then field "konto" has value "43150" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKEUFREI-0-41" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "41" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47301" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "sktoustpos" has value "41" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" has value "Ware" in row 1
Then field "skfaehig" has value "ja" in row 1
# VRGSTRGL aendern
And I set field "vrgstrgl" to "VKEUDREIECK"
# Felder abfragen
Then field "vrgstrgl" has value "VKEUDREIECK" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "stdkto" has value "44000" in row 1
Then field "konto" has value "41300" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKEUFREI-0-DREIECK" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKEUFREI-0-DREIECK" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "42" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47301" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKEUFREI-0-DREIECK-1" in row 1
Then field "sktoustpos" has value "42" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" has value "Dreiecksgeschäft" in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Felder in Rechnung nochmal kontrollieren
Given I open an editor "kontrolle" from table "(Sales):(Invoice)" with command "VIEW" for record "+3gs"
# Felder abfragen
Then field "vrgstrgl" has value "VKEUDREIECK" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "stdkto" has value "44000" in row 1
Then field "konto" has value "41300" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKEUFREI-0-DREIECK" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKEUFREI-0-DREIECK" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "42" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47301" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKEUFREI-0-DREIECK-1" in row 1
Then field "sktoustpos" has value "42" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" has value "Dreiecksgeschäft" in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I close the current editor
#####################################################################################################################################


Scenario: 4. AU-LS-RE-RLS-GS  -> Konto im KGS geaendert

Given I open an editor "auftrag4" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "10010"
And I set field "nummer" to "0004au"
And I set field "rechnustid" to "IT1234567"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "3.15" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKEUFREI" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "stdkto" has value "44000" in row 1
Then field "konto" has value "43150" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKEUFREI-0-41" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "41" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47301" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "sktoustpos" has value "41" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "0" in row 1
Then field "zmart" has value "Ware" in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I set field "proz" to "5" in row 1
Then field "proz" has value "5" in row 1
And I save the current editor

# Auftrag beliefern
Given I open an editor "ls-4" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag4"
And I set field "nummer" to "4ls"
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKEUFREI" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "stdkto" has value "44000" in row 1
Then field "konto" has value "43150" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKEUFREI-0-41" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "41" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47301" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "sktoustpos" has value "41" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" has value "Ware" in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# LS bezahlen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-4"
And I set field "nummer" to "4re"
And I set field "tterm" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKEUFREI" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "stdkto" has value "44000" in row 1
Then field "konto" has value "43150" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKEUFREI-0-41" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "41" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47301" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "sktoustpos" has value "41" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" has value "Ware" in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 25 Stk
Given I open an editor "rls-4" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "ls-4"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "4rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "201" in row 1
And I set field "mge" to "-25" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "kgs4" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "rls-4"
And I set field "nummer" to "4gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrgl" has value "VKEUFREI" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "stdkto" has value "44000" in row 1
Then field "konto" has value "43150" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "VKEUFREI-0-41" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "41" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47301" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "sktoustpos" has value "41" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" has value "Ware" in row 1
Then field "skfaehig" has value "ja" in row 1
# Konto aendern
And I set field "konto" to "43100" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKEUFREI" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "stdkto" has value "44000" in row 1
Then field "konto" has value "43100" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "ktostrgl" has value "VKEUFREI-0-41" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "41" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47301" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "sktoustpos" has value "41" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" has value "Ware" in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Felder in Rechnung nochmal kontrollieren
Given I open an editor "kontrolle4" from table "(Sales):(Invoice)" with command "VIEW" for record "+4gs"
# Felder abfragen
Then field "vrgstrgl" has value "VKEUFREI" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "stdkto" has value "44000" in row 1
Then field "konto" has value "43100" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "ktostrgl" has value "VKEUFREI-0-41" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "VKEUFREI-0-W-41" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "41" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "47301" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "VKEUFREI-0-W-41-1" in row 1
Then field "sktoustpos" has value "41" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" has value "Ware" in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I close the current editor
#####################################################################################################################################

