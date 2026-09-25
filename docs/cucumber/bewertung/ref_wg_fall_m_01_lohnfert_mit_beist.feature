# *****************************************************************************
#  Name             : ref_wg_fall_m_01_lohnfert_mit_beist.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        :
#  Funktion         : Test der Lohnfertigung ohne Beistellung
#
#
#
# *****************************************************************************
@persistent
Feature: WG; Kontierungsfall M
Background: Test von Kontierungsfall 'M' -> besonders die Ersetzung der Konten
Given I set the fake date to "07.01.2002"

@FALL-LohnFertMitBeistellung
Scenario: Lohnfertigung ohne Beistellung; Testumgebung 10


# Artikel anpassen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "1vfall10"
And I delete row at position 4
Then the table has 5 rows
And I save the current editor
And I close the current editor


# VK-Auftrag über 1vfall101 "Bauteil 2"
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "100"
And I set field "kunde" to "001fa10"
And I set field "vom" to "."
And I set field "schlag" to "BEIST_"
And I create a new row at the end of the table
And I set field "artex" to "1vfall10" in row 1
And I set field "mge" to "15" in row 1
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

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Bestellvorschlag + Bestellung (fuer Art. 1001 + 1000)
Given I open an editor "bestellvorschlag-1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-1"
And I set field "num4" to "100-BE"
And I set field "lief" to "001fa10"
And I set field "preis" to "6" in row 1
And I set field "preis" to "7" in row 2
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
And I set field "kenn" to "FALL-LohnFertMitBeistellung"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-111" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01." until enddate "."


# Lohnfertigungsvorschlag + Bestellung (fuer Art. LOHN)
Given I open an editor "lohnfertigungsvorschlag-1" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "lohnfertigung-1"
And I set field "num4" to "100LO-BE"
# Ausland
And I set field "lief" to "004fa10"
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
And I set field "kenn" to "FALL-LohnFertMitBeistellung"
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
And I set field "preis" to "6,5" in row 1
And I set field "preis" to "7,1" in row 2
And I set field "kenn" to "FALL-LohnFertMitBeistellung"
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
And I set field "lief" to "001fa10"
And I set field "preis" to "107" in row 1
And I set field "kenn" to "FALL-LohnFertMitBeistellung"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEIST_001"
And I set fields
	| sofort	| 1		|
	| bzeit		| 0,5	|
	| mzeit		| 8,5	|
	| gut		| 1		|
	| flgksatz	| 5		|
	| fmgk		| 2		|
And I save the current editor

# Rueckmeldung auf letzten Arbeitsgang/ Betriebsauftrag abschliessen
Given I open an editor "rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEIST_002"
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
And I set field "num3" to "100-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-LohnFertMitBeistellung"
And I press button "offueb" in row 1
And I set field "preis" to "373" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################
