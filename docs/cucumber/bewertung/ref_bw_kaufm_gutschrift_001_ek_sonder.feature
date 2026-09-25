# ************************************************************************************************
#  Name             : ref_bw_kaufm_gutschrift_001_ek_sonder.feature
#  Autor            : wane
#  Verantwortlich   : uo
#  Kontrolle        :
#  Funktion         : Testet kaufm. GS und ein einziges Mal die neue 'Wert'-GS ab SP 2101r8
#                     In dieser Datei ist nichts besonders mehr enthalten (3/2023).
#                     Diese Datei wurde früher, in Version 2019 erstellt, weil dort die 
#                     Sonderbehandlung der alten Abhilfe zur Wertgutschrift über Zusatzpos.
#                     in kfm. Gutschriften notwendig war und das hier getestet wurde.
#                    
#                     Wesentlich ist ab 3/23 lediglich noch, dass die Verantwortung im REWE-Bereich liegt,
#                     Ansonsten kann man davon ausgehen, dass die GPs auch in EVS-Tests vorkommen. 
# *************************************************************************************************
@persistent
Feature: kaufm. Gutschriften
Background: Test von kaufm. Gutschriften im Einkauf
Given I set the fake date to "07.01.2002"


@FALL-WertGS
Scenario: FALL-WertGS; EK BE_RE(mit LB)_RE(WGS)_RLS_KGS; mit Verbuchung

# eine Bestellung fuer Artikel anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# Inland-Lieferant
And I set field "lief" to "001fa2"
And I set field "num4" to "200-BE"
And I set field "kenn" to "FALL-WertGS,"
And I create a new row at the end of the table
And I set field "artex" to "0efall2" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "11.11" in row 1
And I save the current editor


# Rechnung mit WB anlegen + verbuchen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "200-RE1"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "200" in row 1
And I set field "preis" to "11.22" in row 1
And I set field "kenn" to "FALL-WertGS"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."


# Wert-GS anlegen + verbuchen
Given I open an editor "wertGS" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rechnung"
And I set field "num4" to "200-WGS"
And I set field "kenn" to "FALL-WertGS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# wenn diese Felder geoeffnet werden,
# dann gibt es Differenzen in Bewertungen bzw. bei den Bestandskonten
#Then field "kgspos" has value "nein" in row 0
And I press button "offueb" in row 1
Then field "pwert" is modifiable in row 1
Then table has values
    | art 		| mge 	| preis 	| remge | herkunft^kopf^such	|
    | EK1-FALL2	| -200 	| 11.22		| -200	| 						|
And I save the current editor

# Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."


# Ruecklieferung von 200 Stk. -> komplett
Given I open an editor "ruecklief-1" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+200-RE1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "200-RLS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK1-FALL2" in row 1
And I set field "mge" to "-200" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."


# Kaufm. GS zu Ruecklieferschein
Given I open an editor "KGS200" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-1"
And I set field "num4" to "200-KGS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
#Then field "kgspos" has value "ja" in row 0
Then the table has 1 rows
Then table has values
    | art 		| mge 	| preis 	| remge | herkunft^kopf^such	|
    | EK1-FALL2	| 0 	| 11.22 	| 0	    |       				|
And I save the current editor
And I close the current editor

# Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#####################################################################################################################################


@FALL-KGS
Scenario: FALL-KGS; BE-REmLB-RLS1-RLS2-RLS3-KGS1-KGS2-KGS3; mit Verbuchung

#  1)eine Bestellung fuer Artikel anlegen: 400-BE
#  2)Rechnung mit WB anlegen + verbuchen
#  3)Ruecklieferung_1 von 20 Stk. -> 400-RLS1
#  4)Ruecklieferung_2 von 30 Stk. -> 400-RLS2
#  5)Ruecklieferung_3 von 40 Stk. -> 400-RLS3
#  6)Kaufm. GS zu Ruecklieferschein_1, aber nicht verbuchen: 400-KGS1
#  7)Kaufm. GS zu Ruecklieferschein_2, aber nicht verbuchen: 400-KGS2
#  8)Kaufm. GS zu Ruecklieferschein_3, aber nicht verbuchen: 400-KGS3
#  9)400-KGS1 verbuchen 
# 10)400-KGS2 verbuchen
# 11)400-KGS3 verbuchen

# eine Bestellung fuer Artikel anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# Inland-Lieferant
And I set field "lief" to "001fa4"
And I set field "num4" to "400-BE"
And I set field "kenn" to "FALL-KGS,"
And I create a new row at the end of the table
And I set field "artex" to "0efall4" in row 1
And I set field "mge" to "400" in row 1
And I set field "preis" to "11.11" in row 1
And I save the current editor

# Rechnung mit WB anlegen + verbuchen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "400-RE1"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "400" in row 1
And I set field "preis" to "11.22" in row 1
And I set field "kenn" to "FALL-KGS"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ruecklieferung_1 von 20 Stk.
Given I open an editor "ruecklief-1" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+400-RE1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "400-RLS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK1-FALL4" in row 1
And I set field "mge" to "-20" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ruecklieferung_2 von 30 Stk.
Given I open an editor "ruecklief-2" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+400-RE1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "400-RLS2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK1-FALL4" in row 1
And I set field "mge" to "-30" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ruecklieferung_3 von 40 Stk.
Given I open an editor "ruecklief-3" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+400-RE1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "400-RLS3"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK1-FALL4" in row 1
And I set field "mge" to "-40" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."


# Kaufm. GS zu Ruecklieferschein_1, aber nicht verbuchen
Given I open an editor "KGS-1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-1"
And I set field "num4" to "400-KGS1"
And I set field "vom" to "."
And I set field "ueb" to "nein"
Then the table has 1 rows
Then table has values
  | art       | mge  | preis         | remge | herkunft^kopf^such    |
  | EK1-FALL4 | -20  | 11.22         | -20   | RLFALL4               |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."


# Kaufm. GS zu Ruecklieferschein_2, aber nicht verbuchen
Given I open an editor "KGS-2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-2"
And I set field "num4" to "400-KGS2"
And I set field "vom" to "."
And I set field "ueb" to "nein"
Then the table has 1 rows
Then table has values
  | art       | mge  | preis     | remge | herkunft^kopf^such    |
  | EK1-FALL4 | -30  | 11.22     | -30   | RLFALL4               |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Kaufm. GS zu Ruecklieferschein_3, aber nicht verbuchen
Given I open an editor "KGS-3" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-3"
And I set field "num4" to "400-KGS3"
And I set field "vom" to "."
And I set field "ueb" to "nein"
Then the table has 1 rows
Then table has values
  | art       | mge  | preis    | remge | herkunft^kopf^such    |
  | EK1-FALL4 | -40  | 11.22    | -40   | RLFALL4               |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# 400-KGS1 verbuchen -> ZP wurde aber Konto auf Vorschlagwert geaendert
Given I open an editor "KGS-1a" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS-1"
Then field "num4" has value "400-KGS1"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set field "ueb" to "ja"
And I save the current editor

# 400-KGS2 verbuchen
Given I open an editor "KGS-2a" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS-2"
Then field "num4" has value "400-KGS2"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set field "ueb" to "ja"
And I save the current editor

# 400-KGS3 verbuchen
Given I open an editor "KGS-3a" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS-3"
Then field "num4" has value "400-KGS3"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set field "ueb" to "ja"
And I save the current editor

# Nachbewerten + Materialkostenverbuchung
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
#
Given I create a CostEntriesSuggestion "mkv" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
#####################################################################################################################################

