# *****************************************************************************
#  Name             : steuerobjekte_basis_brexit_003_offene_vorgaenge_lohnfert.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Test des Verhalten der steuerlichen Objekten in EK/VK bei EU-Austritt
#                     Hier werden Lohnfertigungsfaelle angefangen.
#                     Nordirland und Grossbritanien werden im steuerlichen Sinne noch 
#                     als EU-Mitglieder behandelt.
#
#
# *****************************************************************************
@persistent
Feature: VRGSTRGL in Verkauf
Background: Lohnfertigung und Brexit
Given I set the fake date to "26.01.2002"


@FALL-LohnFertMITKOPPEL
Scenario: Lohnfertigung mit Beistellung und Koppelprodukt; Lohnf.-Artikel 'LOHN'; Koppel-Artikel 'KOPPEL'

# VK-Auftrag ueber 499 mit Ktr 205100
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "200"
And I set field "kunde" to "BREXIT5"
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
And I set field "artikel" to "499"
And I press button "ladetab"
And I set field "bisuch" to "KOPPEL_" in row 1
And I set field "mfreig" to "ja" in row 1
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
And I set field "lief" to "BREXIT7"
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
# EU bzw. Irland
And I set field "lief" to "BREXIT5"
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
And I set field "intrarel" to "nein" in row 1
And I set field "preis" to "95" in row 2
And I set field "intrarel" to "nein" in row 2
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPPEL_001"
And I set fields
	| sofort	| 1	|
	| bzeit		| 0,5	|
	| mzeit		| 8,5	|
	| gut		| 1	|
And I save the current editor

# Rueckmeldung auf letzten Arbeitsgang/ Betriebsauftrag abschliessen
Given I open an editor "rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPPEL_002"
And I set fields
	| sofort	| 1	|
	| bzeit		| 0,5	|
	| mzeit		| 13	|
	| gut		| 1	|
And I save the current editor

# LS aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "200-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
######################################################################################################################################
