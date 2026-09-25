# *****************************************************************************
#  Name             : steuerobjekte_ev_ruecklieferung_kaufmgutschrift_001_ek.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Ueberwachung von steuerlichen Objekten bei
#                     Storno und Ruecklieferungen in Einkauf
#
#
#    Scenario: 1. BE-RE-LS-RLS-GS  -> STRGL in der Zeile der KGS geaendert; mit Vorkasse
#    Scenario: 2. BE-LS-RE-RLS-GS  -> ohne weitere Manipulationen
#    Scenario: 3. BE-LS-RE-RLS-GS  -> VRGSTRGL im KGS geaendert
#
#  In der EK Rechnung wird das Konto geaendert, dann muss das geaenderte Konto auch spaeter in der GS aus RLS stehen
#    Scenario: 4.  BE-LS-RE(Konto geaendert)-RLS-KGS(aus RLS);     Kette1 (siehe REWE-3643)
#    Scenario: 5.  BE-LS-RLS-RE(Konto geaendert)-KGS(aus RLS);     Kette2 (siehe REWE-3643)
#    Scenario: 6.  BE-RE(Konto geaendert)-LS-RLS-KGS(aus RLS);     Kette3 (siehe REWE-3643)
#
#  In der EK-Rechnung wird die Steuerregel geaendert, dann muss die geaenderte Steuerregel auch spaeter in der GS aus RLS stehen
#    Scenario: 7.  BE-LS-RE(STRGL geaendert)-RLS-KGS(aus RLS);     Kette4 (siehe REWE-3643)
#    Scenario: 8.  BE-LS-RLS-RE(STRGL geaendert)-KGS(aus RLS);     Kette5 (siehe REWE-3643)
#
#  In der Kontensteuerregel wird der Vorschlag f�r die Standardsteuerregel geaendert (nachdem die Rechnung gebucht war),
#  dann muss die Steuerregel aus der Rechnung auch spaeter in der GS aus RLS stehen
#    Scenario: 9.  BE-LS-RLS-RE-KSTRGL(Anpassung)-KGS(aus RLS);     Kette6 (siehe REWE-3643)
#    Scenario: 10. BE-LS-RE-RLS-KSTRGL(Anpassung)-KGS(aus RLS);     Kette7 (siehe REWE-3643)
#
#    Scenario: 11. BE-LS-KSTRGL(Anpassung)-RE-RLS-KGS(aus RLS);
#
# *****************************************************************************

@persistent
Feature: steuerobjekte_ev_ruecklieferung_kaufmgutschrift_001_ek.feature
Background: steuerliche Objekten in EK

Scenario: 1. BE-RE-LS-RLS-GS  -> STRGL in der Zeile der KGS geaendert; mit Vorkasse

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


# Bestellung in Rechnung ueberfuehren -> Vorkasse
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

# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "KGS-220" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-1"
And I set field "nummer" to "1gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I set field "strgl" to "6001" in row 1
# Felder erneut abfragen
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "2" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57315" in row 1
Then field "estkonto" has value "14010" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
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


# Felder in Rechnung nochmal kontrollieren
Given I open an editor "kontrolle" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1gs"
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "2" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57315" in row 1
Then field "estkonto" has value "14010" in row 1
Then field "vstkonto" has value "" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I close the current editor
#####################################################################################################################################


Scenario: 2. BE-LS-RE-RLS-GS

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


# LS berechnen
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

# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "kgs2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-2"
And I set field "nummer" to "2gs"
And I set field "vom" to "."
# Felder abfragen
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
Then field "proz" has value "10" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Felder in Rechnung nochmal kontrollieren
Given I open an editor "kontrolle" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2gs"
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
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
And I close the current editor
#####################################################################################################################################

Scenario: 3. BE-LS-RE-RLS-GS  -> VRGSTRGL im KGS geaendert

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


# LS berechnen
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

# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "kgs3" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-3"
And I set field "nummer" to "3gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
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
# VRGSTRGL aendern
And I set field "vrgstrgl" to "EKINSOFORT"
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSOFORT-1-84" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "84" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "zstrgl" has value "EKINSOFORT-1-84-1" in row 1
Then field "sktoustpos" has value "84" in row 1
Then field "ekstustpos" has value "67" in row 1
Then field "vkstustpos" has value "85" in row 1
#
Then field "proz" has value "10" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Felder in Rechnung nochmal kontrollieren
Given I open an editor "kontrolle" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+3gs"
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
Then field "strgl" has value "EKINSOFORT-1-84" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "84" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "zstrgl" has value "EKINSOFORT-1-84-1" in row 1
Then field "sktoustpos" has value "84" in row 1
Then field "ekstustpos" has value "67" in row 1
Then field "vkstustpos" has value "85" in row 1
#
Then field "proz" has value "10" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
And I close the current editor
#####################################################################################################################################


Scenario: 4. BE-LS-RE(Konto geaendert)-RLS-KGS(aus RLS); Kette1 (siehe REWE-3643)
#         In der EK Rechnung wird das Konto geaendert, dann muss das geaenderte Konto auch spaeter in der GS aus RLS stehen

Given I open an editor "bestellung4" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "0004be"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "3.76" in row 1
And I set field "platz" to "F3" in row 1
And I save the current editor

# Bestellung beliefern
Given I open an editor "ls-4" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung4"
And I set field "nummer" to "4ls"
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
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# LS berechnen
Given I open an editor "rechnung4" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-4"
And I set field "nummer" to "4re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
# Konto tauschen
And I set field "konto" to "10000c" in row 1
And I press button "offueb" in row 1
#
# Felder nochmal abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "10000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 27 Stk
Given I open an editor "rls-4" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-4"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "4rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-27" in row 1
And I save the current editor
And I close the current editor


# Kaufm. GS 4 zu Ruecklieferschein
Given I open an editor "kgs4" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-4"
And I set field "nummer" to "4gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
#
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "vorgangskonto" has value "10000c" in row 1
Then field "fixvorgangskonto" has value "ja" in row 1
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
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 5. BE-LS-RLS-RE(Konto geaendert)-KGS(aus RLS); Kette2 (siehe REWE-3643)
#            In der EK Rechnung wird das Konto geaendert, dann muss das geaenderte Konto auch spaeter in der GS aus RLS stehen


Given I open an editor "bestellung5" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "0005be"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "5.75" in row 1
And I set field "platz" to "F3" in row 1
And I save the current editor

# Bestellung beliefern
Given I open an editor "ls-5" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung5"
And I set field "nummer" to "5ls"
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
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Ruecklieferung von 19 Stk
Given I open an editor "rls-5" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-5"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "5rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-19" in row 1
And I save the current editor
And I close the current editor


# LS berechnen
Given I open an editor "rechnung5" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-5"
And I set field "nummer" to "5re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
# Konto tauschen
And I set field "mge" to "0" in row 1
And I set field "konto" to "10000c" in row 1
And I press button "offueb" in row 1
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "vorgangskonto" has value "10000c" in row 1
Then field "fixvorgangskonto" has value "ja" in row 1
#
# Felder nochmal abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "vorgangskonto" has value "10000c" in row 1
Then field "fixvorgangskonto" has value "ja" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Kaufm. GS 5 zu Ruecklieferschein
Given I open an editor "kgs5" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-5"
And I set field "nummer" to "5gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "vorgangskonto" has value "10000c" in row 1
Then field "fixvorgangskonto" has value "ja" in row 1
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
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 6. BE-RE(Konto geaendert)-LS-RLS-KGS(aus RLS); Kette3 (siehe REWE-3643)
#            In der EK Rechnung wird das Konto geaendert, dann muss das geaenderte Konto auch spaeter in der GS aus RLS stehen


Given I open an editor "bestellung6" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "0006be"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "60" in row 1
And I set field "preis" to "6.75" in row 1
And I set field "platz" to "F3" in row 1
And I save the current editor


# Bestellung bezahlen
Given I open an editor "rechnung6" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung6"
And I set field "nummer" to "6re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I set field "fakt" to "nein"
# Felder abfragen
Then field "fakt" has value "nein" in row 0
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
# Konto tauschen
And I set field "konto" to "10000c" in row 1
And I press button "offueb" in row 1
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000c" in row 1
Then field "fixvorgangskonto" has value "ja" in row 1
#
# Felder nochmal abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "vorgangskonto" has value "10000c" in row 1
Then field "fixvorgangskonto" has value "ja" in row 1
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
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Ruecklieferung von 23 Stk
Given I open an editor "rls-6" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-6"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "6rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-23" in row 1
And I save the current editor
And I close the current editor


# Kaufm. GS 6 zu Ruecklieferschein
Given I open an editor "kgs6" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-6"
And I set field "nummer" to "6gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
#
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000c" in row 1
Then field "fixvorgangskonto" has value "ja" in row 1
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
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 7. BE-LS-RE(STRGL geaendert)-RLS-KGS(aus RLS); Kette4 (siehe REWE-3643)
#            In der EK-Rechnung wird die Steuerregel geaendert, dann muss die geaenderte Steuerregel auch spaeter in der GS aus RLS stehen

Given I open an editor "bestellung7" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "0007be"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "70" in row 1
And I set field "preis" to "7.76" in row 1
And I set field "platz" to "F3" in row 1
And I save the current editor

# Bestellung beliefern
Given I open an editor "ls-7" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung7"
And I set field "nummer" to "7ls"
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
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# LS berechnen
Given I open an editor "rechnung7" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-7"
And I set field "nummer" to "7re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
# Konto tauschen
And I set field "strgl" to "6001" in row 1
And I press button "offueb" in row 1
#
# Felder nochmal abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "fixstrgl" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 37 Stk
Given I open an editor "rls-7" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-7"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "7rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-37" in row 1
And I save the current editor
And I close the current editor


# Kaufm. GS 7 zu Ruecklieferschein
Given I open an editor "kgs7" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-7"
And I set field "nummer" to "7gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "2" in row 1
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57315" in row 1
Then field "estkonto" has value "14010" in row 1
Then field "vstkonto" has value "" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 8. BE-LS-RLS-RE(STRGL geaendert)-KGS(aus RLS); Kette5 (siehe REWE-3643)
#            In der EK-Rechnung wird die Steuerregel geaendert, dann muss die geaenderte Steuerregel auch spaeter in der GS aus RLS stehen


#
#  0008be --------- 8ls ---- 8rls ------- 8gs
#  80St. x8.76EUR   80St.    38St.        38St.
#                      \
#                       \---------- 8re
#                        \          80St.
#
#- 1 -------------- 2 ------ 3 ---- 4 --- 5 -------> Zeitstrahl

# 1:
Given I open an editor "bestellung8" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "0008be"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "80" in row 1
And I set field "preis" to "8.76" in row 1
And I set field "platz" to "F3" in row 1
And I save the current editor


# 2: Bestellung beliefern
Given I open an editor "ls-8" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung8"
And I set field "nummer" to "8ls"
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
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# 3: Ruecklieferung von 38 Stk
Given I open an editor "rls-8" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-8"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "8rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-38" in row 1
And I save the current editor
And I close the current editor


# 4: LS berechnen
Given I open an editor "rechnung8" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-8"
And I set field "nummer" to "8re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
# Konto tauschen
And I set field "strgl" to "6001" in row 1
And I press button "offueb" in row 1
#
# Felder nochmal abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "fixstrgl" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# 5: Kaufm. GS 8 zu Ruecklieferschein
Given I open an editor "kgs8" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-8"
And I set field "nummer" to "8gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
#
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "2" in row 1
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57315" in row 1
Then field "estkonto" has value "14010" in row 1
Then field "vstkonto" has value "" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 9. BE-LS-RLS-RE-KSTRGL(Anpassung)-KGS(aus RLS); Kette6 (siehe REWE-3643)
#            In der Kontensteuerregel wird der Vorschlag f�r die Standardsteuerregel geaendert (nachdem die Rechnung gebucht war),
#            dann muss die Steuerregel aus der Rechnung auch spaeter in der GS aus RLS stehen

Given I open an editor "bestellung9" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "0009be"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "90" in row 1
And I set field "preis" to "9.00" in row 1
And I set field "platz" to "F3" in row 1
And I save the current editor

# Bestellung beliefern
Given I open an editor "ls-9" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung9"
And I set field "nummer" to "9ls"
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
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Ruecklieferung von 39 Stk
Given I open an editor "rls-9" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-9"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "9rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-39" in row 1
And I save the current editor
And I close the current editor


# RE: LS berechnen
Given I open an editor "rechnung9" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-9"
And I set field "nummer" to "9re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Kontensteuerregel anpassen
Given I open an editor "kstrgl-9" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7004"
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 2
#
And I set field "strgl" to "EKINSTPF-2" in row 1
And I set field "strgl" to "EKINSTPF-1" in row 2
And I save the current editor


# Kaufm. GS 9 zu Ruecklieferschein
Given I open an editor "kgs9" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-9"
And I set field "nummer" to "9gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "psteuer" has value "1" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
#
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "vstkonto" has value "" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Kontensteuerregel in Ursprungzustand bringen
Given I open an editor "kstrgl-9" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7004"
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 2
#
And I set field "strgl" to "EKINSTPF-1" in row 1
And I set field "strgl" to "EKINSTPF-2" in row 2
And I save the current editor
#####################################################################################################################################


Scenario: 10. BE-LS-RE-RLS-KSTRGL(Anpassung)-KGS(aus RLS); Kette7 (siehe REWE-3643)
#             In der Kontensteuerregel wird der Vorschlag f�r die Standardsteuerregel geaendert (nachdem die Rechnung gebucht war),
#             dann muss die Steuerregel aus der Rechnung auch spaeter in der GS aus RLS stehen

Given I open an editor "bestellung10" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "0010be"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "90" in row 1
And I set field "preis" to "10.00" in row 1
And I set field "platz" to "F3" in row 1
And I save the current editor

# Bestellung beliefern
Given I open an editor "ls-10" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung10"
And I set field "nummer" to "10ls"
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
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# RE: LS berechnen
Given I open an editor "rechnung10" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-10"
And I set field "nummer" to "10re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 10 Stk
Given I open an editor "rls-10" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-10"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "10rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-10" in row 1
And I save the current editor
And I close the current editor


# Kontensteuerregel anpassen
Given I open an editor "kstrgl-10" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7004"
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 2
#
And I set field "strgl" to "EKINSTPF-2" in row 1
And I set field "strgl" to "EKINSTPF-1" in row 2
And I save the current editor


# Kaufm. GS 9 zu Ruecklieferschein
Given I open an editor "kgs10" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-10"
And I set field "nummer" to "10gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
#
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "psteuer" has value "1" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
#
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "vstkonto" has value "" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Kontensteuerregel in Ursprungzustand bringen
Given I open an editor "kstrgl-10b" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7004"
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 2
#
And I set field "strgl" to "EKINSTPF-1" in row 1
And I set field "strgl" to "EKINSTPF-2" in row 2
And I save the current editor
#####################################################################################################################################


Scenario: 11. BE-LS-KSTRGL(Anpassung)-RE-RLS-KGS(aus RLS)

Given I open an editor "bestellung11" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "0011be"
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "90" in row 1
And I set field "preis" to "10.00" in row 1
And I set field "platz" to "F3" in row 1
And I save the current editor

# Bestellung beliefern
Given I open an editor "ls-11" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung11"
And I set field "nummer" to "11ls"
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
Then field "proz" has value "0" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Kontensteuerregel anpassen
Given I open an editor "kstrgl-10" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7004"
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 2
#
And I set field "strgl" to "EKINSTPF-2" in row 1
And I set field "strgl" to "EKINSTPF-1" in row 2
And I save the current editor


# RE: LS berechnen
Given I open an editor "rechnung11" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-11"
And I set field "nummer" to "11re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 11 Stk
Given I open an editor "rls-11" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-11"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "11rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E1" in row 1
And I set field "mge" to "-11" in row 1
And I save the current editor
And I close the current editor


# Kaufm. GS 11 zu Ruecklieferschein
Given I open an editor "kgs11" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-11"
And I set field "nummer" to "11gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
#
# richtige Daten:
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "psteuer" has value "2" in row 1
Then field "skkonto" has value "57315" in row 1
Then field "estkonto" has value "14010" in row 1
#
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "vstkonto" has value "" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Kontensteuerregel in Ursprungzustand bringen
Given I open an editor "kstrgl-11b" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7004"
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 2
#
And I set field "strgl" to "EKINSTPF-1" in row 1
And I set field "strgl" to "EKINSTPF-2" in row 2
And I save the current editor
#####################################################################################################################################

