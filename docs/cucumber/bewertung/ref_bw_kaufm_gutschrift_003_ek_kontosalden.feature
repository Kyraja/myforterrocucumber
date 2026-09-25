# *****************************************************************************
#  Name             : ref_bw_kaufm_gutschrift_003_ek_kontosalden.feature
#  Autor            : wane
#  Verantwortlich   : uo
#  Kontrolle        :
#  Funktion         : testet kaufm. GS
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#
# *****************************************************************************
@persistent
Feature: kaufm. Gutschriften
Background: Test von kaufm. Gutschriften im Einkauf
Given I set the fake date to "08.01.2002"


@FALL-220
Scenario: FALL-220; EK BE_LS_TRE1(gebucht)_TRE2(angelegt)_RLS_TRE2(gebucht)_KGS_(VK)RE1; mit Verbuchung; Testumgebung 20

# Bestellung anlegen -> Ausland
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa20"
And I set field "num4" to "220-BE"
And I set field "kenn" to "FALL-220"
And I set field "erfwaehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "0efall20" in row 1
And I set field "mge" to "220" in row 1
And I set field "preis" to "11.21" in row 1

And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "220-LS"
And I set field "kenn" to "FALL-220"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "220" in row 1

And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "220" in the Area "20"

# Rechnung 1 anlegen und bezahlen -> doch Inland
Given I open an editor "rechnung-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "220-RE1"
And I set field "kenn" to "FALL-220"
And I set field "lief" to "001fa20"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "90" in row 1
And I set field "preis" to "10.01" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "220" in the Area "20"

# Rechnung 2 anlegen, aber nicht buchen -> auch Inland
Given I open an editor "rechnung-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "220-RE2"
And I set field "lief" to "001fa20"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "130" in row 1
And I set field "preis" to "13.05" in row 1
And I set field "kenn" to "FALL-220"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "220" in the Area "20"

# Ruecklieferschein1 (-150 Stk.)
Given I open an editor "rls-220" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+220-LS"
And I set field "num4" to "220-RLS1"
And I set field "such" to "RLS220"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-150" in row 1
And I set field "kenn" to "FALL-220 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "220" in the Area "20"

# Kaufm. GS 1 zu Ruecklieferschein 1
Given I open an editor "KGS-220" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-220"
And I set field "num4" to "220-GS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 2 rows
Then table has values
    | art               | mge    | preis     | ofmge | herkunft^kopf^such |
    | EK1-FALL20        | -90    | 10.01     | 0     | RLFALL20           |
    | EK1-FALL20        | -60    | 13.05     | 0     | RLFALL20           |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "220" in the Area "20"

# VK-Rechnung; alles verkaufen, damit das Bestandskonto auf 0.00 geht
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "220-RE"
And I set field "kunde" to "006fa20"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-220"
And I create a new row at the end of the table
And I set field "artex" to "0efall20" in row 1
And I set field "mge" to "70" in row 1
And I set field "preis" to "75" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "220" in the Area "20"

# Bestaetigung, dass alles verkauft ist
Given I open an editor "artikel-220" from table "(Part):(Product)" with command "VIEW" for record "0efall20"
Then field "bestand" has value "0" in row 0
And I close the current editor


Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "1ifall20"
#  ACHTUNG: HIER MUSS SALDO 0.00 SEIN !!!
#           Hier wurde alles zurueckgeliefert und berechnet -> Menge 0, Wert 0.00
Then field "saldo" has value "0.00" in row 0
And I close the current editor
#####################################################################################################################################


@FALL-230
Scenario: FALL-230; EK BE_LS_TRE1_TRE2_RLS_KGS_(VK)RE1; mit Verbuchung; Testumgebung 21

# Bestellung anlegen -> Ausland
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa21"
And I set field "num4" to "230-BE"
And I set field "kenn" to "FALL-230"
And I set field "erfwaehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "0efall21" in row 1
And I set field "mge" to "230" in row 1
And I set field "preis" to "11.21" in row 1

And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "230-LS"
And I set field "kenn" to "FALL-230"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "230" in row 1

And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "230" in the Area "21"

# Rechnung 1 anlegen und bezahlen -> doch Inland
Given I open an editor "rechnung-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "230-RE1"
And I set field "kenn" to "FALL-230"
And I set field "lief" to "001fa21"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "preis" to "10.01" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "230" in the Area "21"

# Rechnung 2 anlegen, aber nicht buchen -> auch Inland
Given I open an editor "rechnung-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "230-RE2"
And I set field "lief" to "001fa21"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "130" in row 1
And I set field "preis" to "13.05" in row 1
And I set field "kenn" to "FALL-230"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein1 (-50 Stk.)
Given I open an editor "rls-230" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+230-LS"
And I set field "num4" to "230-RLS1"
And I set field "such" to "RLS230"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-50" in row 1
And I set field "kenn" to "FALL-230 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "230" in the Area "21"

# Kaufm. GS 1 zu Ruecklieferschein 1
Given I open an editor "KGS-230" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-230"
And I set field "num4" to "230-GS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
Then table has values
    | art               | mge    | preis     | ofmge | herkunft^kopf^such |
    | EK1-FALL21        | -50    | 10.01     | 0     | RLFALL21           |
# Das was zuerst verbucht wurde wird zuerst ueber KGS abgebaut.
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "230" in the Area "21"

# VK-Rechnung; alles verkaufen, damit das Bestandskonto auf 0.00 geht
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "230-RE"
And I set field "kunde" to "006fa21"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-230"
And I create a new row at the end of the table
And I set field "artex" to "0efall21" in row 1
And I set field "mge" to "180" in row 1
And I set field "preis" to "75" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "230" in the Area "21"

# Bestaetigung, dass alles verkauft ist
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "0efall21"
Then field "bestand" has value "0" in row 0
And I close the current editor


Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "1ifall21"
#  ACHTUNG: HIER MUSS SALDO 0.00 SEIN !!!
#           Hier wurde alles zurueckgeliefert und berechnet -> Menge 0, Wert 0.00
Then field "saldo" has value "0.00" in row 0
And I close the current editor
#####################################################################################################################################
