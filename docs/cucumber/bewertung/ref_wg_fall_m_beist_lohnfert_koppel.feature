# *****************************************************************************
#  Name             : ref_wg_fall_m_beist_lohnfert_koppel.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        :
#  Funktion         : Warengruppe: Kontierungsfall 'M' in Bewertungen
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#                    @FALL-LohnFertOHNE
#                      Scenario: Lohnfertigung ohne Beistellung; Lohnfertigungsartikel LOHN
#                      Bewertungen von 531 bis 544
#                    @FALL-LohnFertMITKOPPEL
#                      Scenario: Lohnfertigung mit Beistellung und Koppelprodukt; Lohnf.-Artikel 'LOHN'; Koppel-Artikel 'KOPPEL'
#                      Bewertungen von 544 bis 563
#                    @FALL-LohnFertMitBeist,
#                      Scenario: Lohnfertigung mit Beistellung; Lohnfertigungsartikel 'LOHN3'
#                      Bewertungen von 563 bis 581
#
# *****************************************************************************
@persistent
Feature: WG; Kontierungsfall M
Background: Test von Kontierungsfall 'M' -> besonders die Ersetzung der Konten

@FALL-LohnFertOHNE
Scenario: Lohnfertigung ohne Beistellung; Lohnfertigungsartikel LOHN
# Bewertungen von 531 bis 544

# alles wegbuchen, was offen ist
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# VK-Auftrag über 301 mit Ktr 205100
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "100"
And I set field "kunde" to "1"
And I set field "vom" to "."
And I set field "schlag" to "OHNE_"
And I create a new row at the end of the table
And I set field "artex" to "301" in row 1
And I set field "mge" to "5" in row 1
And I set field "kstelle" to "205100" in row 1
And I set field "verw" to "205100" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

# Disposition starten
And I run Scheduling

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I set field "bisuch" to "OHNE_" in row 1
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
And I set field "num4" to "100-BE"
And I set field "lief" to "1"
And I save the current editor
And I close the current editor
And I switch the current editor to editor "bestellvorschlag-1"
And I close the current editor


# Lieferschein aus Bestellung "100-BE" -> Inland
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "100-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-OHNE"
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
And I set field "num4" to "100LO-BE"
# Ausland
And I set field "lief" to "60006"
And I set field "preis" to "99.5" in row 1
And I save the current editor
And I close the current editor
And I switch the current editor to editor "lohnfertigungsvorschlag-1"
And I close the current editor

# Lieferschein aus Bestellung "100LO-BE" (Lohnfertigung) -> Ausland
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lohnfertigung-1"
And I set field "num4" to "100LO-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-OHNE"
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Rechnung aus Lieferschein 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "100-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "17" in row 1
And I set field "preis" to "100" in row 2
And I set field "kenn" to "FALL-OHNE"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Rechnung aus Lieferschein 2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2"
And I set field "num4" to "100LO-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# Inland
And I set field "lief" to "1"
And I set field "preis" to "100" in row 1
And I set field "kenn" to "FALL-OHNE"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "OHNE_001"
And I set fields
	| sofort	| 1		|
	| bzeit		| 0,5	|
	| mzeit		| 8,5	|
	| gut		| 1		|
And I save the current editor

# Rueckmeldung auf letzten Arbeitsgang/ Betriebsauftrag abschliessen
Given I open an editor "rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "OHNE_002"
And I set fields
	| sofort	| 1		|
	| bzeit		| 0,5	|
	| mzeit		| 13	|
	| gut		| 1		|
And I save the current editor

# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "100-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-OHNE"
And I press button "offueb" in row 1
And I set field "preis" to "350" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-LohnFertMITKOPPEL
Scenario: Lohnfertigung mit Beistellung und Koppelprodukt; Lohnf.-Artikel 'LOHN'; Koppel-Artikel 'KOPPEL'
# Bewertungen von 545 bis 565


# VK-Auftrag über 499 mit Ktr 205100
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "200"
And I set field "kunde" to "1"
And I set field "vom" to "."
And I set field "schlag" to "KOPPEL_"
And I create a new row at the end of the table
And I set field "artex" to "499" in row 1
And I set field "mge" to "7" in row 1
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
And I set field "num4" to "200-BE"
And I set field "lief" to "1"
And I save the current editor
And I close the current editor
And I switch the current editor to editor "bestellvorschlag-1"
And I close the current editor

# Lieferschein aus Bestellung "200-BE" -> Inland
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "200-LS"
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
And I set field "num4" to "200LO-BE"
# Ausland
And I set field "lief" to "60006"
And I save the current editor
And I close the current editor
And I switch the current editor to editor "lohnfertigungsvorschlag-1"
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Lieferschein aus Bestellung "200LO-BE" (Lohnfertigung) -> Ausland
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lohnfertigung-1"
And I set field "num4" to "200LO-LS"
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
And I set field "num4" to "200-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "16" in row 1
And I set field "preis" to "95" in row 2
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rechnung aus Lieferschein 2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2"
And I set field "num4" to "200LO-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# Inland
And I set field "lief" to "1"
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
And I save the current editor

# Rueckmeldung auf letzten Arbeitsgang/ Betriebsauftrag abschliessen
Given I open an editor "rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPPEL_002"
And I set fields
	| sofort	| 1		|
	| bzeit		| 0,5	|
	| mzeit		| 13	|
	| gut		| 1		|
And I save the current editor

# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "200-RE"
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
######################################################################################################################################


@FALL-LohnFertMitBeist,
Scenario: Lohnfertigung mit Beistellung; Lohnfertigungsartikel 'LOHN3'
# Bewertungen von 566 bis 583

# VK-Auftrag über 699 mit Ktr 205100
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "300"
And I set field "kunde" to "1"
And I set field "vom" to "."
And I set field "schlag" to "BEIST_"
And I create a new row at the end of the table
And I set field "artex" to "699" in row 1
And I set field "mge" to "119" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

#Disposition starten
And I run Scheduling


# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I set field "bisuch" to "BEIST_" in row 1
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
And I set field "num4" to "300-BE"
And I set field "lief" to "1"
And I save the current editor
And I close the current editor
And I switch the current editor to editor "bestellvorschlag-1"
And I close the current editor

# Lieferschein aus Bestellung "300-BE" -> Inland
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "300-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-LohnFertMitBeist,"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Lohnfertigungsvorschlag + Bestellung (fuer Art. LOHN3)
Given I open an editor "lohnfertigungsvorschlag-1" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "lohnfertigung-1"
And I set field "num4" to "300LO-BE"
# Ausland
And I set field "lief" to "60006"
And I save the current editor
And I close the current editor
And I switch the current editor to editor "lohnfertigungsvorschlag-1"
And I close the current editor

# Lieferschein aus Bestellung "300LO-BE" (Lohnfertigung) -> Ausland
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lohnfertigung-1"
And I set field "num4" to "300LO-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-LohnFertMitBeist,"
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rechnung aus Lieferschein 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "300-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "19.19" in row 1
And I set field "kenn" to "FALL-LohnFertMitBeist,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rechnung aus Lieferschein 2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2"
And I set field "num4" to "300LO-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# Inland
And I set field "lief" to "1"
And I set field "preis" to "107" in row 1
And I set field "kenn" to "FALL-LohnFertMitBeist,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEIST_001"
And I set fields
	| sofort	| 1		|
	| bzeit		| 0,7	|
	| mzeit		| 8,7	|
	| gut		| 1		|
And I save the current editor
And I close the current editor

# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEIST_000"
And I set fields
	| sofort	| 1		|
	| bzeit		| 0,5	|
	| mzeit		| 13	|
	| gut		| 1		|
	| lgr		| 1		|
And I save the current editor
And I close the current editor

# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "300-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-LohnFertMitBeist,"
And I press button "offueb" in row 1
And I set field "preis" to "711" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
######################################################################################################################################
