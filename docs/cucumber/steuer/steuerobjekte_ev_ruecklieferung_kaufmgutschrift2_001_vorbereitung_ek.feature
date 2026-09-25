# *****************************************************************************
#  Name             : steuerobjekte_ev_ruecklieferung_kaufmgutschrift2_001_vorbereitung_ek.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Ueberwachung von steuerlichen Objekten bei
#                     Storno und Ruecklieferungen in Einkauf
#
#
#    Scenario: 1. BE(0001be)-RE(1revor)-LS(1ls)   -RLS(1rls)
#    Scenario: 2. BE(0002be)-LS(2ls)   -RE(2re)   -RLS(2rls)
#    Scenario: 3. BE(0003be)-LS(3ls)   -RE(3re)   -RLS(3rls)
#    Scenario: 4. BE(0004be)-LS1(4a-ls)-LS2(4b-ls)-RLS(4a-rls)-RLS(4b-rls)-RE(4re)
#    Scenario: 5. BE(0005be)-LS1(5a-ls)-LS2(5b-ls)-RLS(5a-rls)-RLS(5b-rls)-RE(5re)
#    Scenario: 6. BE(0006be)-RE(6revor)-LS(6ls)   -RLS(6rls)                          - Konto in BE fixiert
# *****************************************************************************

@persistent
Feature: steuerobjekte_ev_ruecklieferung_kaufmgutschrift2_001_vorbereitung_ek.feature
Background: steuerliche Objekten in EK

Scenario: 1. BE-RE-LS-RLS

Given I open an editor "bestellung1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "0001be"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "3.15" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I set field "proz" to "5" in row 1
Then field "proz" has value "5" in row 1
And I save the current editor


# Auftrag in Rechnung ueberfuehren -> Vorkasse
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung1"
And I set field "nummer" to "1revor"
And I set field "tterm" to "."
And I set field "vom" to "."
And I set field "fakt" to "nein"
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Bestellung beliefern
Given I open an editor "ls-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung1"
And I set field "nummer" to "1ls"
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "10000" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor

# Ruecklieferung von 25 Stk
Given I open an editor "rls-1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "1rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E3" in row 1
And I set field "mge" to "-25" in row 1
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 2. BE-LS-RE-RLS

Given I open an editor "bestellung2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "0002be"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "3.15" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "10000" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I set field "proz" to "10" in row 1
Then field "proz" has value "10" in row 1
And I save the current editor

# Bestellung beliefern
Given I open an editor "ls-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung2"
And I set field "nummer" to "2ls"
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "10000" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "10" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# LS bezahlen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-2"
And I set field "nummer" to "2re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "10000" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "10" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 25 Stk
Given I open an editor "rls-2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-2"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "2rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-25" in row 1
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 3. BE-LS-RE-RLS

Given I open an editor "bestellung3" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "10010"
And I set field "nummer" to "0003be"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "35" in row 1
And I set field "preis" to "4.00" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I set field "proz" to "10" in row 1
Then field "proz" has value "10" in row 1
And I save the current editor

# Bestellung beliefern
Given I open an editor "ls-3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung3"
And I set field "nummer" to "3ls"
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "10" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# LS bezahlen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-3"
And I set field "nummer" to "3re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "10" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 35 Stk
Given I open an editor "rls-3" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-3"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "3rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-35" in row 1
And I save the current editor
And I close the current editor
#####################################################################################################################################

Scenario: 4. BE-LS1-LS2-RLS1-RLS2-RE

Given I open an editor "bestellung4" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "10010"
And I set field "nummer" to "0004be"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "40" in row 1
And I set field "preis" to "4.00" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I set field "proz" to "10" in row 1
Then field "proz" has value "10" in row 1
And I save the current editor

# Bestellung teilbeliefern: 15 Stk
Given I open an editor "ls-4a" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung4"
And I set field "nummer" to "4a-ls"
And I set field "vom" to "."
And I set field "mge" to "15" in row 1
# Felder abfragen
Then field "mge" has value "15" in row 1
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "10" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Bestellung teilbeliefern: 25 Stk
Given I open an editor "ls-4b" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung4"
And I set field "nummer" to "4b-ls"
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "mge" has value "25" in row 1
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "10" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Ruecklieferung von 5 Stk
Given I open an editor "rls-4a" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-4a"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "4a-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-5" in row 1
And I save the current editor
And I close the current editor



# Ruecklieferung von 17 Stk
Given I open an editor "rls-4b" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-4b"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "4b-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-17" in row 1
And I save the current editor
And I close the current editor


# BE berechnen
Given I open an editor "rechnung4" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-4b"
And I set field "beleg" to id from editor "ls-4a"
And I set field "nummer" to "4re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
#
# --- Zeile 1
Then field "mge" has value "25" in row 1
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "10" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
# --- Zeile 3
Then field "mge" has value "15" in row 3
Then field "konto" has value "36301" in row 3
Then field "fixkonto" has value "nein" in row 3
Then field "ktostrgl" has value "EKIN-ALL" in row 3
Then field "psteuer" has value "1" in row 3
Then field "strgl" has value "EKINSTPF-1" in row 3
Then field "fixstrgl" has value "nein" in row 3
Then field "ustva" has value "" in row 3
Then field "ustland" has value "DEUTSCHLAND" in row 3
Then field "skkonto" has value "57365" in row 3
Then field "estkonto" has value "14060" in row 3
Then field "vstkonto" has value "" in row 3
Then field "zstrgl" has value "EKINSTPF-1-1" in row 3
Then field "sktoustpos" has value "" in row 3
Then field "ekstustpos" has value "66" in row 3
Then field "vkstustpos" has value "" in row 3
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################


Scenario: 5. BE-LS1-LS2-RLS1-RLS2-RE

Given I open an editor "bestellung5" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "10010"
And I set field "nummer" to "0005be"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "40" in row 1
And I set field "preis" to "4.00" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I set field "proz" to "10" in row 1
Then field "proz" has value "10" in row 1
And I save the current editor

# Bestellung teilbeliefern: 15 Stk
Given I open an editor "ls-5a" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung5"
And I set field "nummer" to "5a-ls"
And I set field "vom" to "."
And I set field "mge" to "15" in row 1
# Felder abfragen
Then field "mge" has value "15" in row 1
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "10" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Bestellung teilbeliefern: 25 Stk
Given I open an editor "ls-5b" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung5"
And I set field "nummer" to "5b-ls"
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "mge" has value "25" in row 1
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "10" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Ruecklieferung von 5 Stk
Given I open an editor "rls-5a" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-5a"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "5a-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-5" in row 1
And I save the current editor
And I close the current editor



# Ruecklieferung von 17 Stk
Given I open an editor "rls-5b" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-5b"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "5b-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-17" in row 1
And I save the current editor
And I close the current editor


# BE berechnen
Given I open an editor "rechnung5" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-5b"
And I set field "beleg" to id from editor "ls-5a"
And I set field "nummer" to "5re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
#
# --- Zeile 1
Then field "mge" has value "25" in row 1
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "10" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
# --- Zeile 3
Then field "mge" has value "15" in row 3
Then field "konto" has value "36301" in row 3
Then field "fixkonto" has value "nein" in row 3
Then field "ktostrgl" has value "EKIN-ALL" in row 3
Then field "psteuer" has value "1" in row 3
Then field "strgl" has value "EKINSTPF-1" in row 3
Then field "fixstrgl" has value "nein" in row 3
Then field "ustva" has value "" in row 3
Then field "ustland" has value "DEUTSCHLAND" in row 3
Then field "skkonto" has value "57365" in row 3
Then field "estkonto" has value "14060" in row 3
Then field "vstkonto" has value "" in row 3
Then field "zstrgl" has value "EKINSTPF-1-1" in row 3
Then field "sktoustpos" has value "" in row 3
Then field "ekstustpos" has value "66" in row 3
Then field "vkstustpos" has value "" in row 3
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################

Scenario: 6. BE-RE-LS-RLS

Given I open an editor "bestellung6" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "840015"
And I set field "nummer" to "0006be"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "5.00" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKAUSFREI" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "EKAUSFREI-0" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57302" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKAUSFREI-0-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I set field "proz" to "5" in row 1
Then field "proz" has value "5" in row 1
And I set field "konto" to "10002" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "EKAUSFREI-0" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
And I save the current editor


# Bestellung in Rechnung ueberfuehren -> Vorkasse
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung6"
And I set field "nummer" to "6revor"
And I set field "tterm" to "."
And I set field "vom" to "."
And I set field "fakt" to "nein"
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKAUSFREI" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10002" in row 1
Then field "fixvorgangskonto" has value "ja" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "EKAUSFREI-0" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57302" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKAUSFREI-0-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Bestellung beliefern
Given I open an editor "ls-6" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung6"
And I set field "nummer" to "6ls"
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "10002" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "ktostrgl" has value "EKAUSFREI-0" in row 1
Then field "psteuer" has value "0" in row 1
Then field "strgl" has value "EKAUSFREI-0" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57302" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKAUSFREI-0-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor

# Ruecklieferung von 25 Stk
Given I open an editor "rls-6" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-6"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "6rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E3" in row 1
And I set field "mge" to "-25" in row 1
And I save the current editor
And I close the current editor
#####################################################################################################################################

