# *****************************************************************************
#  Name             : steuerobjekte_ev_ruecklieferung_kaufmgutschrift2_004_gutschrift_ek.feature
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
Feature: steuerobjekte_ev_ruecklieferung_kaufmgutschrift2_004_gutschrift_ek.feature
Background: steuerliche Objekten in EK


Scenario: 1. Vorher: BE(0001be)-RE(1revor)-LS(1ls)-RLS(1rls); Nachher: KGS

# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "KGS-220" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "1rls"
And I set field "nummer" to "1gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
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
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 2. Vorher: BE(0002be)-LS(2ls)-RE(2re)-RLS(2rls); Nachher: KGS

# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "kgs2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "2rls"
And I set field "nummer" to "2gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
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
#####################################################################################################################################


Scenario: 3. BE(0003be)-LS(3ls)-RE(3re)-RLS(3rls)

# Kaufm. GS zum Ruecklieferschein
Given I open an editor "kgs3" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "3rls"
And I set field "nummer" to "3gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
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
Then field "fixvorgangskonto" has value "nein" in row 1
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
Then field "fixvorgangskonto" has value "nein" in row 1
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


Scenario: 4. Vorher: BE(0004be)-LS1(4a-ls)-LS2(4b-ls)-RLS(4a-rls)-RLS(4b-rls)-RE(4re); Nachher KGS aus RLS(4b-rls)

# Kaufm. GS zum Ruecklieferschein
Given I open an editor "kgs4" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "4b-rls"
And I set field "nummer" to "4gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
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
Then field "fixvorgangskonto" has value "nein" in row 1
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
#####################################################################################################################################


Scenario: 5. Vorher: BE(0005be)-LS1(5a-ls)-LS2(5b-ls)-RLS(5a-rls)-RLS(5b-rls)-RE(5re); Nachher WGS aus RE(5re)

# Wert-GS zur Rechnung
Given I open an editor "kgs5" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to "+5re"
And I set field "nummer" to "5gs"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I press button "offueb" in row 3
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
#
# --- Zeile 1 ---
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "1" in row 1
# Fehler
Then field "strgl" has value "ANDERE" in row 1
# Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57365" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "vstkonto" has value "" in row 1
Then field "tustart" has value "steuerpflichtig" in row 3
# Fehler
Then field "zstrgl" has value "ANDERE-1" in row 1
# Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "sktoustpos" has value "" in row 1
# Fehler
Then field "ekstustpos" has value "62" in row 1
# Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "10" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
#
# --- Zeile 3 ---
Then field "konto" has value "10000" in row 3
Then field "fixkonto" has value "nein" in row 3
Then field "ktostrgl" has value "EKIN-ALL" in row 3
Then field "psteuer" has value "1" in row 3
# Fehler
Then field "strgl" has value "ANDERE" in row 3
# Then field "strgl" has value "EKINSTPF-1" in row 3
Then field "fixstrgl" has value "nein" in row 3
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 3
Then field "skkonto" has value "57365" in row 3
Then field "estkonto" has value "14060" in row 3
Then field "vstkonto" has value "" in row 3
Then field "tustart" has value "steuerpflichtig" in row 3
# Fehler
Then field "zstrgl" has value "ANDERE-1" in row 3
# Then field "zstrgl" has value "EKINSTPF-1-1" in row 3
Then field "sktoustpos" has value "" in row 3
# Fehler
Then field "ekstustpos" has value "62" in row 3
# Then field "ekstustpos" has value "66" in row 3
Then field "vkstustpos" has value "" in row 3
#
#
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 6. Vorher: BE(0006be)(Konto fixiert)-RE(6revor)-LS(6ls)-RLS(6rls); Nachher: KGS aus RLS(6rls)


# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "KGS-220" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "6rls"
And I set field "nummer" to "6gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10002" in row 1
Then field "fixvorgangskonto" has value "ja" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "psteuer" has value "0" in row 1
# Fehler!!!
Then field "strgl" has value "EKAUSFREI-0" in row 1
# Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
# Fehler!!!
Then field "zstrgl" has value "EKAUSFREI-0-1" in row 1
# Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "ustva" has value "" in row 1
Then field "ustland" has value "DEUTSCHLAND" in row 1
Then field "skkonto" has value "57302" in row 1
Then field "estkonto" has value "" in row 1
Then field "vstkonto" has value "" in row 1
Then field "sktoustpos" has value "" in row 1
Then field "tustart" has value "steuerfrei" in row 1
# Fehler!!!
Then field "ekstustpos" has value "" in row 1
# Then field "ekstustpos" has value "66" in row 1
Then field "vkstustpos" has value "" in row 1
#
Then field "proz" has value "5" in row 1
Then field "zmart" is empty in row 1
Then field "skfaehig" has value "ja" in row 1
#
# verbuchen
And I set field "incoort" to "blabla"
And I set field "incoland" to "Hamburg"
And I set field "gart" to "58"


And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################

