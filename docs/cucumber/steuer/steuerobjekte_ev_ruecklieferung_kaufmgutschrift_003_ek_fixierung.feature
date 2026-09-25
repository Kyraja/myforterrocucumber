# *****************************************************************************
#  Name             : steuerobjekte_ev_ruecklieferung_kaufmgutschrift_003_ek_fixierung.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Ueberwachung von steuerlichen Objekten bei
#                     Storno und Ruecklieferungen in Einkauf
#
#
#  Beschreibung: siehe REWE-3685
#          Scenario: 1EK: BE-LS-RE-(RLS aus LS)-(KGS aus RLS)
#          Scenario: 2EK: BE-LS-RE-(RLS aus LS)-(KGS aus RLS)
#          Scenario: 3EK: BE-LS-(RLS aus LS)-RE-(KGS aus RLS)
#          Scenario: 4EK: BE-LS1-LS2-(RE1 aus LS1)-(RE2 aus LS1)-(RLS1 aus LS1)-(KGS1 aus RLS1)
#          Scenario: 5EK: BE-LS-(RE1 aus LS)-(RE2 aus LS)-(RLS aus LS)-(KGS aus RLS)
#          Scenario: 6EK: BE-LS1-LS2-(RE aus LS2)-(RLS1 aus LS1)-(RLS2 aus LS2)-(KGS1 aus RLS2)-(Storno KGS1)
#
#
# *****************************************************************************

@persistent
Feature: steuerobjekte_ev_ruecklieferung_kaufmgutschrift_003_ek_fixierung.feature
Background: steuerliche Objekten in EK


Scenario: 1EK: BE-LS-RE-(RLS aus LS)-(KGS aus RLS)

Given I open an editor "bestellung-ek1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "1ek-be"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "3.50" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "kstelle" has value "" in row 1
Then field "fixkstelle" has value "nein" in row 1
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
And I save the current editor


# Bestellung beliefern
Given I open an editor "ls-1ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-ek1"
And I set field "nummer" to "1ek-ls"
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "kstelle" has value "" in row 1
Then field "fixkstelle" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# LS in Rechnung ueberfuehren
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-1ek"
And I set field "nummer" to "1ek-re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 50 Stk
Given I open an editor "rls-1ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-1ek"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "1ek-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
# Felder abfragen
Then field "konto" has value "10000" in row 1
Then field "fixkstelle" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
# Felder aendern
And I set field "mge" to "-50" in row 1
# Steuerregel tauschen
Then field "strgl" has value "EKINSTPF-1" in row 1
And I set field "strgl" to "EKINSTPF-2" in row 1
Then field "fixstrgl" has value "ja" in row 1
# Versuch Konto zu tauschen
Then field "konto" is not modifiable in row 1
And I save the current editor
And I close the current editor


# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "KGS-ek1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-1ek"
And I set field "nummer" to "1ek-gs"
And I set field "vom" to "."
# Felder abfragen
Then field "vrgstrglauskl2" is empty in row 0
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
#
# Versuch Konto zu tauschen
Then field "konto" is not modifiable in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 2EK: BE-LS-RE-(RLS aus LS)-(KGS aus RLS)

Given I open an editor "bestellung-ek2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "2ek-be"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "175" in row 1
And I set field "preis" to "3.50" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "kstelle" has value "" in row 1
Then field "fixkstelle" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
And I save the current editor


# Bestellung beliefern
Given I open an editor "ls-2ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-ek2"
And I set field "nummer" to "2ek-ls"
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "kstelle" has value "" in row 1
Then field "fixkstelle" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
# Konto tauschen
And I set field "konto" to "10000c" in row 1
Then field "fixkonto" has value "ja" in row 1
#
# Steuerregel tauschen
Then field "strgl" has value "EKINSTPF-1" in row 1
And I set field "strgl" to "EKINSTPF-2" in row 1
Then field "fixstrgl" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# LS in Rechnung ueberfuehren
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-2ek"
And I set field "nummer" to "2ek-re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "10000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
# Fixierungen rausnehmen
And I set field "fixkonto" to "nein" in row 1
And I set field "fixstrgl" to "nein" in row 1
Then field "konto" has value "10000" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 35 Stk
Given I open an editor "rls-2ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-2ek"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "2ek-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
# Felder abfragen
Then field "konto" has value "10000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "fixstrgl" has value "ja" in row 1
# Felder aendern
And I set field "mge" to "-35" in row 1
# Fixierungen rausnehmen
And I set field "fixstrgl" to "nein" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
# Versuch Konto zu tauschen
Then field "konto" is not modifiable in row 1
And I save the current editor
And I close the current editor


# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "KGS-ek2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-2ek"
And I set field "nummer" to "2ek-gs"
And I set field "vom" to "."
# Felder abfragen
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
#
# Versuch Konto zu tauschen
Then field "konto" is not modifiable in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 3EK: BE-LS-(RLS aus LS)-RE-(KGS aus RLS)


#
# 3ek-be ----------- 3ek-ls -- 3ek-rls ------------- 3ek-gs (bekommt das Konto aus RE)
# 133St. x4.52EUR    133St.    105St.                105St.
#                       \
#                        \---------- 3ek-re (Konto getauscht)
#                         \          133St.
#
#-- 1 -------------- 2 ------- 3 --- 4 ------------- 5 ------------> Zeitstrahl


Given I open an editor "bestellung-ek3" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "3ek-be"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "133" in row 1
And I set field "preis" to "4.52" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "kstelle" has value "" in row 1
Then field "fixkstelle" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
And I save the current editor


# Bestellung beliefern
Given I open an editor "ls-3ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-ek3"
And I set field "nummer" to "3ek-ls"
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
# Steuerregel tauschen
Then field "strgl" has value "EKINSTPF-1" in row 1
And I set field "strgl" to "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Ruecklieferung von 105 Stk
Given I open an editor "rls-3ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls-3ek"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "3ek-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
# Felder abfragen
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
# Felder aendern
And I set field "mge" to "-105" in row 1
#
And I save the current editor
And I close the current editor


# LS in Rechnung ueberfuehren
Given I open an editor "rechnung-3ek" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-3ek"
And I set field "nummer" to "3ek-re"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
# Konto tauschen
And I set field "mge" to "0" in row 1
And I set field "konto" to "10000c" in row 1
Then field "fixkonto" has value "ja" in row 1
And I press button "offueb" in row 1
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "vorgangskonto" has value "10000c" in row 1
Then field "fixvorgangskonto" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "KGS-ek3" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-3ek"
And I set field "nummer" to "3ek-gs"
And I set field "vom" to "."
# Felder abfragen
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
# vorgangskonto muss aus der RE kommen und nicht aus dem RLS
Then field "vorgangskonto" has value "10000c" in row 1
Then field "fixvorgangskonto" has value "ja" in row 1
#
# Versuch Konto zu tauschen
Then field "konto" is not modifiable in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 4EK: BE-LS1-LS2-(RE1 aus LS1)-(RE2 aus LS1)-(RLS1 aus LS1)-(KGS1 aus RLS1)

Given I open an editor "bestellung-ek4" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "4ek-be"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "500" in row 1
And I set field "preis" to "4.52" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "kstelle" has value "" in row 1
Then field "fixkstelle" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
And I save the current editor


# Bestellung beliefern - LS1
Given I open an editor "ls1-4ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-ek4"
And I set field "nummer" to "4ek-ls1"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "mge" to "300" in row 1
# Felder abfragen
Then field "ofmge" has value "200" in row 1
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Bestellung beliefern - LS2
Given I open an editor "ls2-4ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-ek4"
And I set field "nummer" to "4ek-ls2"
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "mge" has value "200" in row 1
Then field "ofmge" has value "0" in row 1
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
# Konto tauschen
And I set field "konto" to "06400" in row 1
Then field "fixkonto" has value "ja" in row 1
#
# Steuerregel tauschen
And I set field "strgl" to "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
# verbuchen
#And I set field "ueb" to "ja"
And I save the current editor


# LS1 zu Teil in Rechnung1 ueberfuehren
Given I open an editor "rechnung1-4ek" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls1-4ek"
And I set field "nummer" to "4ek-re1"
And I set field "tterm" to "."
And I set field "vom" to "."
And I set field "mge" to "170" in row 1
And I set field "preis" to "10" in row 1
# Felder abfragen
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# LS1 zu Teil in Rechnung2 ueberfuehren
Given I open an editor "rechnung2-4ek" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls1-4ek"
And I set field "nummer" to "4ek-re2"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "20" in row 1
# Felder abfragen
Then field "mge" has value "130" in row 1
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
# Konto tauschen
And I set field "konto" to "10000c" in row 1
Then field "fixkonto" has value "ja" in row 1
#
# Steuerregel tauschen
And I set field "strgl" to "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von LS1: 250 Stk -> mit 2 RE bezahlt!
Given I open an editor "rls-4ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls1-4ek"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "4ek-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
# Felder abfragen
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
# Felder aendern
And I set field "mge" to "-250" in row 1
#
And I save the current editor
And I close the current editor


# Kaufm. GS 1 zu Ruecklieferschein:  -> mit 2 RE bezahlt!!!
Given I open an editor "KGS-ek4" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-4ek"
And I set field "nummer" to "4ek-gs"
And I set field "vom" to "."
# Felder abfragen
Then the table has 2 rows
#
#   ----- Zeile 1 -----
Then field "mge" has value "-170" in row 1
Then field "preis" has value "10.00" in row 1
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
#
#
#   ----- Zeile 2 -----
Then field "mge" has value "-80" in row 2
Then field "preis" has value "20.00" in row 2
Then field "konto" has value "36301" in row 2
Then field "fixkonto" has value "nein" in row 2
Then field "vorgangskonto" has value "10000c" in row 2
Then field "fixvorgangskonto" has value "ja" in row 2
Then field "strgl" has value "EKINSTPF-2" in row 2
Then field "zstrgl" has value "EKINSTPF-2-1" in row 2
Then field "fixstrgl" has value "ja" in row 2
#
# Versuch Konto zu tauschen
Then field "konto" is not modifiable in row 1
Then field "konto" is not modifiable in row 2
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 5EK: BE-LS-(RE1 aus LS)-(RE2 aus LS)-(RLS aus LS)-(KGS aus RLS)

Given I open an editor "bestellung-ek5" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "5ek-be"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "400" in row 1
And I set field "preis" to "1.51" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "kstelle" has value "" in row 1
Then field "fixkstelle" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
#
# Konto tauschen
And I set field "konto" to "06400" in row 1
Then field "fixkonto" has value "ja" in row 1
#
# Steuerregel tauschen
And I set field "strgl" to "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
And I save the current editor


# Bestellung beliefern - LS1
Given I open an editor "ls1-5ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-ek5"
And I set field "nummer" to "5ek-ls1"
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "ofmge" has value "0" in row 1
Then field "konto" has value "06400" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# LS1 zu Teil in Rechnung1 ueberfuehren
Given I open an editor "rechnung1-5ek" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls1-5ek"
And I set field "nummer" to "5ek-re1"
And I set field "tterm" to "."
And I set field "vom" to "."
And I set field "mge" to "140" in row 1
And I set field "preis" to "11" in row 1
# Felder abfragen
Then field "konto" has value "06400" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
# Konto nochmal tauschen
And I set field "konto" to "10000c" in row 1
# STRGL nochmal tauschen
And I set field "strgl" to "EKINFREI-0" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# LS1 zu Teil in Rechnung2 ueberfuehren
Given I open an editor "rechnung2-5ek" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls1-5ek"
And I set field "nummer" to "5ek-re2"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "21" in row 1
# Felder abfragen
Then field "konto" has value "06400" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
# Konto tauschen
And I set field "fixkonto" to "nein" in row 1
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
#
# Steuerregel tauschen
And I set field "fixstrgl" to "nein" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von LS1: 300 Stk -> mit 2 RE bezahlt!
Given I open an editor "rls-5ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls1-5ek"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "5ek-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
# Felder abfragen
Then field "konto" has value "06400" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
# Felder aendern
And I set field "mge" to "-300" in row 1
#
And I save the current editor
And I close the current editor


# Kaufm. GS 1 zu Ruecklieferschein:  -> mit 2 RE bezahlt!!!
Given I open an editor "KGS-ek5" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-5ek"
And I set field "nummer" to "5ek-gs"
And I set field "vom" to "."
# Felder abfragen
Then the table has 2 rows
#
#   ----- Zeile 1 -----
Then field "mge" has value "-140" in row 1
Then field "preis" has value "11.00" in row 1
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "vorgangskonto" has value "10000c" in row 1
Then field "fixvorgangskonto" has value "ja" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "strgl" has value "EKINFREI-0" in row 1
Then field "zstrgl" has value "EKINFREI-0-1" in row 1
#
#   ----- Zeile 2 -----
Then field "mge" has value "-160" in row 2
Then field "konto" has value "36301" in row 2
Then field "vorgangskonto" has value "10000" in row 2
Then field "fixkonto" has value "nein" in row 2
Then field "strgl" has value "EKINSTPF-1" in row 2
Then field "zstrgl" has value "EKINSTPF-1-1" in row 2
Then field "fixstrgl" has value "nein" in row 2
Then field "preis" has value "21.00" in row 2
#
# Aenderbarkeit von Konto
Then field "konto" is not modifiable in row 1
Then field "konto" is not modifiable in row 2
# Aenderbarkeit von STRGL
Then field "strgl" is modifiable in row 1
Then field "strgl" is modifiable in row 2
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 6EK: BE-LS1-LS2-(RE aus LS2)-(RLS1 aus LS1)-(RLS2 aus LS2)-(KGS1 aus RLS2)-(Storno KGS1)

Given I open an editor "bestellung-ek6" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "nummer" to "6ek-be"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "13.51" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "kstelle" has value "" in row 1
Then field "fixkstelle" has value "nein" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
#
# Konto tauschen
And I set field "konto" to "06400" in row 1
Then field "fixkonto" has value "ja" in row 1
#
# Steuerregel tauschen
And I set field "strgl" to "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
And I save the current editor


# Bestellung beliefern - LS1
Given I open an editor "ls1-6ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-ek6"
And I set field "nummer" to "6ek-ls1"
And I set field "vom" to "."
And I set field "mge" to "350" in row 1
# Felder abfragen
Then field "ofmge" has value "650" in row 1
Then field "konto" has value "06400" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Bestellung beliefern - LS2
Given I open an editor "ls2-6ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-ek6"
And I set field "nummer" to "6ek-ls2"
And I set field "vom" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "mge" has value "650" in row 1
Then field "ofmge" has value "0" in row 1
Then field "konto" has value "06400" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# LS2 in Rechnung2 ueberfuehren
Given I open an editor "rechnung2-5ek" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls2-6ek"
And I set field "nummer" to "6ek-re2"
And I set field "tterm" to "."
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "21" in row 1
# Felder abfragen
Then field "mge" has value "650" in row 1
Then field "konto" has value "06400" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
# Konto tauschen
And I set field "fixkonto" to "nein" in row 1
Then field "konto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
#
# Steuerregel noch mal tauschen
And I set field "strgl" to "EKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "EKINFREI-0-1" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von LS1: 200 Stk von 350
Given I open an editor "rls1-6ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls1-6ek"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "6ek-rls1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
# Felder abfragen
Then field "konto" has value "06400" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
# Felder aendern
And I set field "mge" to "-200" in row 1
#
And I save the current editor
And I close the current editor


# Ruecklieferung von LS2: 300 Stk von 650
Given I open an editor "rls2-6ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ls2-6ek"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "6ek-rls2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
# Felder abfragen
Then field "konto" has value "06400" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "strgl" has value "EKINSTPF-2" in row 1
Then field "zstrgl" has value "EKINSTPF-2-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
# Felder aendern
And I set field "mge" to "-300" in row 1
#
And I save the current editor
And I close the current editor


# Kaufm. GS2 zu RLS2
Given I open an editor "KGS-ek6" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls2-6ek"
And I set field "nummer" to "6ek-gs"
And I set field "vom" to "."
# Felder abfragen
Then the table has 1 rows
Then field "ktostrgl" has value "EKIN-ALL" in row 1
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "EKINFREI-0" in row 1
Then field "zstrgl" has value "EKINFREI-0-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
And I set field "strgl" to "EKINSTPF-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
#
# Aenderbarkeit von Konto
Then field "konto" is not modifiable in row 1
# Aenderbarkeit von STRGL
Then field "strgl" is modifiable in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


Given I open an editor "teilre5storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+6ek-gs"
And I set field "nummer" to "6ek-stor"
Then field "partnervorgang" is not empty in row 0
Then field "mge" has value "300" in row 1
Then field "strgl" has value "EKINSTPF-1" in row 1
Then field "zstrgl" has value "EKINSTPF-1-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "fixkonto" has value "nein" in row 1
And I save the current editor
And I close the current editor
#####################################################################################################################################

