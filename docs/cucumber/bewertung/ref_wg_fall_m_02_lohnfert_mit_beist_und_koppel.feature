# *****************************************************************************
#  Name             : ref_wg_fall_m_beist_lohnfert_koppel.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Warengruppe: Kontierungsfall 'M' in Bewertungen
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#      ?              @FALL-LohnFertOHNE
#      ?                Scenario: Lohnfertigung ohne Beistellung; Lohnfertigungsartikel LOHN
#      ?                Bewertungen von 531 bis 544
#      ?              @FALL-LohnFertMITKOPPEL
#      ?                Scenario: Lohnfertigung mit Beistellung und Koppelprodukt; Lohnf.-Artikel 'LOHN'; Koppel-Artikel 'KOPPEL'
#      ?                Bewertungen von 544 bis 563
#      ?              @FALL-LohnFertMitBeist,
#      ?                Scenario: Lohnfertigung mit Beistellung; Lohnfertigungsartikel 'LOHN3'
#      ?                Bewertungen von 563 bis 581
#
# *****************************************************************************
@persistent
Feature: WG; Kontierungsfall M
Background: Test von Kontierungsfall 'M' -> besonders die Ersetzung der Konten
Given I set the fake date to "07.01.2002"

@FALL-LohnFertMITKOPPEL
Scenario: Lohnfertigung mit Beistellung und Koppelprodukt; Lohnf.-Artikel 'LOHN'; Koppel-Artikel 'KOPPEL'; Testumgebung 21

# VK-Auftrag über 1vfall21 "Bauteil 2"
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "210"
And I set field "kunde" to "001fa21"
And I set field "vom" to "."
And I set field "schlag" to "KOPPEL_"
And I create a new row at the end of the table
And I set field "artex" to "1vfall21" in row 1
And I set field "mge" to "15" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

#Disposition starten
And I run Scheduling

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I set field "bisuch" to "KOPPEL_" in row 1
And I press button "malle"
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-111" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01." until enddate "."

# Bestellvorschlag + Bestellung (fuer Art. 201 + 1000)
Given I open an editor "bestellvorschlag-1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-1"
And I set field "num4" to "210-BE"
And I set field "lief" to "001fa21"
And I set field "preis" to "6" in row 1
And I set field "preis" to "7" in row 2
And I save the current editor
And I close the current editor
And I switch the current editor to editor "bestellvorschlag-1"
And I close the current editor

# Lieferschein aus Bestellung "210-BE" -> Inland
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "210-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Lohnfertigungsvorschlag + Bestellung (fuer Art. LOHN)
Given I open an editor "lohnfertigungsvorschlag-1" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "lohnfertigung-1"
And I set field "num4" to "210LO-BE"
# Ausland
And I set field "lief" to "004fa21"
And I save the current editor
And I close the current editor
And I switch the current editor to editor "lohnfertigungsvorschlag-1"
And I close the current editor

# Lieferschein aus Bestellung "210LO-BE" (Lohnfertigung) -> Ausland
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lohnfertigung-1"
And I set field "num4" to "210LO-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rechnung aus Lieferschein 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "210-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "6,5" in row 1
And I set field "preis" to "7,1" in row 2
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rechnung aus Lieferschein 2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2"
And I set field "num4" to "210LO-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# Inland
And I set field "lief" to "001fa21"
And I set field "preis" to "107" in row 1
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPPEL_001"
And I set fields
	| sofort	| 1		|
	| bzeit		| 0,5	|
	| mzeit		| 8,5	|
	| gut		| 1		|
	| flgksatz	| 5		|
	| fmgk		| 2		|
And I save the current editor

# Rueckmeldung auf letzten Arbeitsgang/ Betriebsauftrag abschliessen
Given I open an editor "rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPPEL_002"
And I set fields
	| sofort	| 1		|
	| bzeit		| 0,5	|
	| mzeit		| 13	|
	| gut		| 1		|
	| flgksatz	| 5		|
	| fmgk		| 2		|
And I save the current editor

# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "210-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I press button "offueb" in row 1
And I set field "preis" to "373" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-LohnFertMITKOPPEL
Scenario: Lohnfertigung mit Beistellung und Koppelprodukt; Lohnf.-Artikel 'LOHN'; Koppel-Artikel 'KOPPEL'; Testumgebung 22

# VK-Auftrag über 001fa22 "Bauteil 2"
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "220"
And I set field "kunde" to "001fa22"
And I set field "vom" to "."
And I set field "schlag" to "KOPPEL_"
And I create a new row at the end of the table
And I set field "artex" to "1vfall22" in row 1
And I set field "mge" to "15" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

#Disposition starten
And I run Scheduling

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I set field "bisuch" to "KOPPEL_" in row 1
And I press button "malle"
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Bestellvorschlag + Bestellung (fuer Art. 201 + 1000)
Given I open an editor "bestellvorschlag-1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-1"
And I set field "num4" to "220-BE"
# Inland
And I set field "lief" to "001fa22"
And I set field "preis" to "6" in row 1
And I set field "preis" to "7" in row 2
And I save the current editor
And I close the current editor
And I switch the current editor to editor "bestellvorschlag-1"
And I close the current editor

# Lieferschein aus Bestellung "220-BE" -> Inland
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "220-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Lohnfertigungsvorschlag + Bestellung (fuer Art. LOHN)
Given I open an editor "lohnfertigungsvorschlag-1" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "lohnfertigung-1"
And I set field "num4" to "220LO-BE"
# Ausland
And I set field "lief" to "004fa22"
And I save the current editor
And I close the current editor
And I switch the current editor to editor "lohnfertigungsvorschlag-1"
And I close the current editor

# Lieferschein aus Bestellung "220LO-BE" (Lohnfertigung) -> Ausland
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lohnfertigung-1"
And I set field "num4" to "220LO-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Teil-Rechnung 1 aus Lieferschein 1; Inland
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "220-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "6,1" in row 1
And I set field "mge" to "5" in row 1
And I set field "preis" to "7,1" in row 2
And I set field "mge" to "5" in row 2
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Teil-Rechnung 2 aus Lieferschein 1; EU
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "220-RE2"
# EU-Lieferant
And I set field "lief" to "003fa22"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "6,2" in row 1
And I set field "mge" to "5" in row 1
And I set field "intrarel" to "nein" in row 1
And I set field "preis" to "7,2" in row 2
And I set field "mge" to "5" in row 2
And I set field "intrarel" to "nein" in row 2
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Teil-Rechnung 3 aus Lieferschein 1  -> Rest; Ausland
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "220-RE3"
# Ausland
And I set field "lief" to "004fa22"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "6,3" in row 1
And I set field "preis" to "7,3" in row 2
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rechnung aus Lieferschein 2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2"
And I set field "num4" to "220LO-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# Inland
And I set field "lief" to "001fa22"
And I set field "preis" to "107" in row 1
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPPEL_001"
And I set fields
	| sofort	| 1		|
	| bzeit		| 0,5	|
	| mzeit		| 8,5	|
	| gut		| 1		|
	| flgksatz	| 5		|
	| fmgk		| 2		|
And I save the current editor

# Rueckmeldung auf letzten Arbeitsgang/ Betriebsauftrag abschliessen
Given I open an editor "rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPPEL_002"
And I set fields
	| sofort	| 1		|
	| bzeit		| 0,5	|
	| mzeit		| 13	|
	| gut		| 1		|
	| flgksatz	| 5		|
	| fmgk		| 2		|
And I save the current editor

# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "220-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I press button "offueb" in row 1
And I set field "preis" to "373" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Storno Teil-Rechnung 3
Given I open an editor "rechnung-storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+220-RE3"
And I set field "num4" to "220-SRE3"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Teil-Rechnung 3 aus Lieferschein 1  -> Rest; Inland
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "220-RE4"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "6,9" in row 1
And I set field "preis" to "7,9" in row 2
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################
