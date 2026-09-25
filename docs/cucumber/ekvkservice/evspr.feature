#***************************************************************************
#
#  Name      : evspr.feature
#  Datum     : 03.03.2021
#  Autor     : dago
#  Verantw.  : teampss
#
#  Funktion  : Test des neuen Feldes fuer Korrespondenzsprachen
#              in Einkaufs-/Verkaufsvorgaengen.
#              (ehemals EVSPR.LAD)
#
#***************************************************************************
#
@persistent
Feature: Korrespondenzsprachen pruefen
Background:
Given I set the fake date to "02.01.1995"

# ========================================= Verkauf =========================================

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-001: Chance
#--------------------------------------------------------------------------------------------

Scenario: Chance oeffnen, unterschiedliche Kunden eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "CH700101" from table "(Sales):(Opportunity)" with command "UPDATE" for record "700101"
And I set fields
	| kunde     | 10202    |
	| kl2       | 10203    |
	| warenempf | 10204    |
And I save the current editor

# Korrespondenzsprache-Felder pruefen
Given I open an editor "CH700101" from table "(Sales):(Opportunity)" with command "VIEW" for record "700101"
Then field "spra" has value "Englisch"
Then field "kunde^spra" has value "Englisch"
Then field "kunde2^spr" has value "F"
Then field "kunde3^spra" has value "Spanisch"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-002: Webauftrag
#--------------------------------------------------------------------------------------------

Scenario: Webauftrag oeffnen, unterschiedliche Kunden eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "WEB100102" from table "(Sales):(WebOrder)" with command "UPDATE" for record "100102"
And I set fields
	| kunde     | 10202 |
	| kl2       | 10203 |
	| warenempf | 10204 |
And I save the current editor

Given I open an editor "WEB100102" from table "(Sales):(WebOrder)" with command "VIEW" for record "100102"
Then field "spra" has value "Englisch"
Then field "kunde^spra" has value "Englisch"
Then field "kunde2^spr" has value "F"
Then field "kunde3^spra" has value "Spanisch"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-003: Angebot
#--------------------------------------------------------------------------------------------

Scenario:  Angebot oeffnen, unterschiedliche Kunden eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "ANG100103" from table "(Sales):(Quotation)" with command "UPDATE" for record "100103"
And I set fields
	| kunde     | 10202 |
	| kl2       | 10203 |
	| warenempf | 10204 |
And I save the current editor

Given I open an editor "ANG100103" from table "(Sales):(Quotation)" with command "VIEW" for record "100103"
Then field "spra" has value "Englisch"
Then field "kunde^spra" has value "Englisch"
Then field "kunde2^spr" has value "F"
Then field "kunde3^spra" has value "Spanisch"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-004: Rahmenauftrag
#--------------------------------------------------------------------------------------------

Scenario: Rahmenauftrag oeffnen, unterschiedliche Kunden eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "RA100104" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "100104"
And I set fields
	| kunde     | 10202 |
	| kl2       | 10203 |
	| warenempf | 10204 |
And I save the current editor

Given I open an editor "RA100104" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "100104"
Then field "spra" has value "Englisch"
Then field "kunde^spra" has value "Englisch"
Then field "kunde2^spr" has value "F"
Then field "kunde3^spra" has value "Spanisch"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-005: Auftrag
#--------------------------------------------------------------------------------------------

Scenario: Auftrag oeffnen, unterschiedliche Kunden eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "AU200101" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "200101"
And I set fields
	| kunde     | 10202 |
	| kl2       | 10203 |
	| warenempf | 10204 |
And I save the current editor

Given I open an editor "AU200101" from table "(Sales):(SalesOrder)" with command "VIEW" for record "200101"
Then field "spra" has value "Englisch"
Then field "kunde^spra" has value "Englisch"
Then field "kunde2^spr" has value "F"
Then field "kunde3^spra" has value "Spanisch"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-006: Lieferschein
#--------------------------------------------------------------------------------------------

Scenario: Lieferschein oeffnen, unterschiedliche Kunden eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "LS300101" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "300101"
And I set fields
	| kunde     | 10202 |
	| kl2       | 10203 |
	| warenempf | 10204 |
And I save the current editor

Given I open an editor "LS300101" from table "(Sales):(PackingSlip)" with command "VIEW" for record "300101"
Then field "spra" has value "Spanisch"
Then field "kunde^spra" has value "Englisch"
Then field "kunde2^spr" has value "F"
Then field "kunde3^spra" has value "Spanisch"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-007: Rechnung
#--------------------------------------------------------------------------------------------

Scenario: Rechnung oeffnen, unterschiedliche Kunden eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "RE400101" from table "(Sales):(Invoice)" with command "UPDATE" for record "400101"
And I set fields
	| kunde     | 10202 |
	| kl2       | 10203 |
	| warenempf | 10204 |
And I save the current editor

Given I open an editor "RE400101" from table "(Sales):(Invoice)" with command "VIEW" for record "400101"
Then field "spr" has value "F"
Then field "kunde^spra" has value "Englisch"
Then field "kunde2^spr" has value "F"
Then field "kunde3^spra" has value "Spanisch"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-008: Reparaturauftrag
#--------------------------------------------------------------------------------------------

Scenario: Reparaturauftrag oeffnen, unterschiedliche Kunden eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "RAU200102" from table "(Sales):(RepairOrder)" with command "UPDATE" for record "200102"
And I set fields
	| kunde     | 10202 |
	| kl2       | 10203 |
	| warenempf | 10204 |
And I save the current editor

Given I open an editor "RAU200102" from table "(Sales):(RepairOrder)" with command "VIEW" for record "200102"
Then field "spra" has value "Englisch"
Then field "kunde^spra" has value "Englisch"
Then field "kunde2^spr" has value "F"
Then field "kunde3^spra" has value "Spanisch"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-009: Serviceangebot
#--------------------------------------------------------------------------------------------

Scenario: Serviceangebot oeffnen, unterschiedliche Kunden eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "SANG100106" from table "(Sales):(ServiceQuotation)" with command "UPDATE" for record "100106"
And I set fields
	| kunde     | 10202 |
	| kl2       | 10203 |
	| warenempf | 10204 |
And I save the current editor

Given I open an editor "SANG100106" from table "(Sales):(ServiceQuotation)" with command "VIEW" for record "100106"
Then field "spra" has value "Englisch"
Then field "kunde^spra" has value "Englisch"
Then field "kunde2^spr" has value "F"
Then field "kunde3^spra" has value "Spanisch"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-010: Serviceauftrag
#--------------------------------------------------------------------------------------------

Scenario:  Serviceauftrag oeffnen, unterschiedliche Kunden eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "SAU200103" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record "200103"
And I set fields
	| kunde     | 10202 |
	| kl2       | 10203 |
	| warenempf | 10204 |
And I save the current editor

Given I open an editor "SAU200103" from table "(Sales):(ServiceOrder)" with command "VIEW" for record "200103"
Then field "spra" has value "Englisch"
Then field "kunde^spra" has value "Englisch"
Then field "kunde2^spr" has value "F"
Then field "kunde3^spra" has value "Spanisch"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-011: Lieferschein aus Auftrag
#--------------------------------------------------------------------------------------------

Scenario: Auftrag oeffnen, Lieferschein erzeugen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "LS200101" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "200101"
And I set field "mge" to "1" in row 1
And I save the current editor

Given I open an editor "LS200101" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS200101"
Then field "spra" has value "Spanisch"
Then field "kunde^spra" has value "Englisch"
Then field "kunde2^spr" has value "F"
Then field "kunde3^spra" has value "Spanisch"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-012: Rechnung aus Auftrag
#--------------------------------------------------------------------------------------------

Scenario: Auftrag oeffnen, Rechnung erzeugen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "RE200101" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "200101"
And I set field "mge" to "1" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE200101" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE200101"
Then field "spr" has value "F"
Then field "kunde^spra" has value "Englisch"
Then field "kunde2^spr" has value "F"
Then field "kunde3^spra" has value "Spanisch"
And I close the current editor

# ========================================= Einkauf =========================================

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-013: Anfrage
#--------------------------------------------------------------------------------------------

Scenario: Anfrage oeffnen, unterschiedliche Lieferanten eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "ANF500101" from table "(Purchasing):(Request)" with command "UPDATE" for record "500101"
And I set fields
	| lief | 60402 |
	| kl2  | 60403 |
And I save the current editor

Given I open an editor "ANF500101" from table "(Purchasing):(Request)" with command "VIEW" for record "500101"
Then field "spra" has value "Englisch"
Then field "lief^spra" has value "Englisch"
Then field "lief2^spr" has value "F"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-014: Rahmenauftrag
#--------------------------------------------------------------------------------------------

Scenario: Rahmenauftrag oeffnen, unterschiedliche Lieferanten eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "RA500102" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "500102"
And I set fields
	| lief | 60402 |
	| kl2  | 60403 |
And I save the current editor

Given I open an editor "RA500102" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "500102"
Then field "spra" has value "Englisch"
Then field "lief^spra" has value "Englisch"
Then field "lief2^spr" has value "F"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-015: Bestellung
#--------------------------------------------------------------------------------------------

Scenario: Bestellung oeffnen, unterschiedliche Lieferanten eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "BE600101" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "600101"
And I set fields
	| lief | 60402 |
	| kl2  | 60403 |
And I save the current editor

Given I open an editor "BE600101" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "600101"
Then field "spra" has value "Englisch"
Then field "lief^spra" has value "Englisch"
Then field "lief2^spr" has value "F"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-016: Lieferschein
#--------------------------------------------------------------------------------------------

Scenario: Lieferschein oeffnen, unterschiedliche Lieferanten eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "LS600102" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "600102"
And I set fields
	| lief | 60402 |
	| kl2  | 60403 |
And I save the current editor

Given I open an editor "LS600102" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "600102"
Then field "spra" has value "Englisch"
Then field "lief^spra" has value "Englisch"
Then field "lief2^spr" has value "F"
And I close the current editor

#--------------------------------------------------------------------------------------------
# TSQ-EVSPR-017: Rechnung
#--------------------------------------------------------------------------------------------

Scenario: Rechnung oeffnen, unterschiedliche Lieferanten eintragen, Inhalt des Sprachfeldes ausgeben
Given I open an editor "RE600103" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "600103"
And I set fields
	| lief | 60402 |
	| kl2  | 60403 |
And I save the current editor

Given I open an editor "RE600103" from table "(Purchasing):(Invoice)" with command "VIEW" for record "600103"
Then field "spr" has value "F"
Then field "lief^spra" has value "Englisch"
Then field "lief2^spr" has value "F"
And I close the current editor
