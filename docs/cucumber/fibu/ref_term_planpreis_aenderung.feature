# *****************************************************************************
#  Name             : kv_138_editor_plausichecks.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Hier wird die Planpreisumstellung getestet -> TERM
#
#      Beschreibung :
#             die Planpreis-Umstellung wird am 10.02.02 gemacht!!!
#             ====================================================
#             Verwendete Planpreise vor der Umstellung sind 1-stellig, nach der Umstellung 2-stellig
#         @FALL-VorUmstellung:
#             1) es werden 2 Artikel vor der Umstellung mit Planpreis (durch Bestandskorrektur)
#                bewertet -> 0efall1 + 0efall2
#             2) Art. "0efall1" wird verkauft
#             3) Art. "0efall3" ohne Bestand wird verkauft -> Abgang ohne Zugang
#        @FALL-NachUmstellung:
#             1) vor Umstellung bewertete Art. "0efall2" wird verkauft -> Preis aus dem Zugang, also alter Planpreis
#             2) Bestandskorrektur KORR003; Art. 0efall1
#             3) Bestandskorrektur KORR004; Art. 0efall3
#             4) Nachbewerten + Kostenverbuchung(alles)
#        @FALL-NachUmstellung2:
#             1) Bestandskorrektur KORR005; Art "0efall4";
#                Versuch mit dem Datum vor der Umstellung die Bestandskorrektur durchzufuehren -> trotz dem neuer Planpreis
#             2) Art. "0efall4" nach der Umstellung mit dem Buchungsdatum vor der Umstellung verkaufen
#
#
#             die Planstundensatz-Umstellung wird am 15.02.02 gemacht!!!
#             ==========================================================
#             Verwendete Planstundensaetze vor der Umstellung sind 3-stellig, nach der Umstellung 1-stellig
#        @FALL-PlStdSatz   -> vor der Umstellung
#             1) Given I set the fake date to "11.02.02"
#             2) Maschinengruppen 121 und 122 manipuliert bzw. die Stundensaetze eingetragen
#             3) VK-Auftrag ueber 0vfall1 "Bauteil 1"
#             4) Disposition starten
#             5) Fertigungsvorschlag anlegen und freigeben
#             6) Materialkostenverbuchung
#             7) Bestellvorschlag + Bestellung (fuer Art. 0efall1)
#             8) Lieferschein 1 aus Bestellung "210-BE" -> Inland
#             9) Nachbewerten + Kostenverbuchung(alles)
#            10) Rechnung aus Lieferschein 1
#            11) Nachbewerten + Kostenverbuchung(alles)
#            12) Rueckmeldung auf ersten Arbeitsgang
#            13) Rueckmeldung auf letzten Arbeitsgang/ Betriebsauftrag abschliessen
#            14) VK-Rechnung aus Auftrag
#            15) Nachbewerten + Kostenverbuchung(alles)
#        @FALL-PlStdSatz2   -> nach der Umstellung
#             1) Given I set the fake date to "16.02.02"
#             2) VK-Auftrag ueber 0vfall2 "Bauteil 1"
#             3) Disposition starten
#             4) Fertigungsvorschlag anlegen und freigeben
#             5) Materialkostenverbuchung
#             6) Bestellvorschlag + Bestellung (fuer Art. 0efall2)
#             7) Lieferschein 1 aus Bestellung "310-BE" -> Inland
#             8) Nachbewerten + Kostenverbuchung(alles)
#             9) Rechnung aus Lieferschein 1
#            10) Nachbewerten + Kostenverbuchung(alles)
#            11) Rueckmeldung auf ersten Arbeitsgang
#            12) Rueckmeldung auf letzten Arbeitsgang/ Betriebsauftrag abschliessen
#            13) VK-Rechnung aus Auftrag
#            14) Nachbewerten + Kostenverbuchung(alles)
#
# *****************************************************************************
@persistent
Feature: Planpreisumstellung
Background: Test der Planpreisumstellung

@FALL-VorUmstellung
Scenario: Planpreis vor der Umstellung verwenden
Given I set the fake date to "01.01.02"

# Bestandskorrektur KORR001
Given I open an editor "Bestandskorrektur1" for tip command "(SInventory)" and arguments ""
And I set fields
	| artikel	| 0efall1	|
	| beleg		| KORR001	|
	| beldat	| .			|
And I set field "platz" to "F1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor
And I close the current editor

# Bestandskorrektur KORR002
Given I open an editor "Bestandskorrektur2" for tip command "(SInventory)" and arguments ""
And I set fields
	| artikel	| 0efall2	|
	| beleg		| KORR002	|
	| beldat	| .			|
And I set field "platz" to "F1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor
And I close the current editor


# Art. "0efall1" vor der Umstellung verkaufen
# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "vk-rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "10-RE"
And I set field "kunde" to "001fa1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-VorUmstellung"
And I create a new row at the end of the table
And I set field "artikel" to "0efall1" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "233.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Art. "0efall3" vor der Umstellung verkaufen -> kein Bestand da
# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "vk-rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "20-RE"
And I set field "kunde" to "001fa3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-VorUmstellung"
And I create a new row at the end of the table
And I set field "artikel" to "0efall3" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "333.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################


@FALL-NachUmstellung
Scenario: Planpreis nach der Umstellung verwenden
Given I set the fake date to "11.02.02"


# Art. "0efall2" nach der Umstellung mit dem Preis vor der Umstellung verkaufen
# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "vk-rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "30-RE"
And I set field "kunde" to "001fa2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-NachUmstellung"
And I create a new row at the end of the table
And I set field "artikel" to "0efall2" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "133.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Bestandskorrektur KORR003
Given I open an editor "Bestandskorrektur1" for tip command "(SInventory)" and arguments ""
And I set fields
	| artikel	| 0efall1	|
	| beleg		| KORR003	|
	| beldat	| .			|
And I set field "platz" to "F1" in row 1
And I set field "mge" to "10" in row 1
And I modify table
	| mge	| !row			|
	| 0		| platz=='F1'	|
And I save the current editor


# Bestandskorrektur KORR004
# Bestand zu 0efall3 kommt erst jetzt
Given I open an editor "Bestandskorrektur1" for tip command "(SInventory)" and arguments ""
And I set fields
	| artikel	| 0efall3	|
	| beleg		| KORR004	|
	| beldat	| .			|
And I set field "platz" to "F1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################


@FALL-NachUmstellung2
Scenario: Planpreis nach der Umstellung verwenden, aber mit Buchungsdatum vor der Umstellung
Given I set the fake date to "11.02.02"

# Bestandskorrektur KORR005
# Versuch mit dem Datum vor der Umstellung die Bestandskorrektur durchzufuehren
Given I open an editor "Bestandskorrektur1" for tip command "(SInventory)" and arguments ""
And I set fields
	| artikel	| 0efall4	|
	| beleg		| KORR005	|
	| beldat	| 01.01.02	|
And I set field "platz" to "F1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

# Art. "0efall4" nach der Umstellung mit dem Buchungsdatum vor der Umstellung verkaufen
# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "vk-rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "40-RE"
And I set field "kunde" to "001fa4"
And I set field "ueb" to "ja"
And I set field "vom" to "01.01.02"
And I set field "budat" to "01.01.02"
And I set field "kenn" to "FALL-NachUmstellung2"
And I create a new row at the end of the table
And I set field "artikel" to "0efall4" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "133.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-PlStdSatz
Scenario: Planstundensatz-Umstellung; vor der Umstellung
Given I set the fake date to "11.02.02"

Given I open an editor "maschinengruppe" from table "(Capacity):(WorkCenter)" with command "UPDATE" for record "121"
# Stundensatz 1 eintragen -> 3-stellig
And I set field "fixkost" to "100.00"
And I set field "varkost" to "111.00"
Then field "plansatz" has value "211.00"
# Stundensatz 2 eintragen -> 1-stellig
And I set field "zfixkost" to "1.00"
And I set field "zvarkost" to "5.00"
Then field "zplansatz" has value "6.00"
And I save the current editor
And I close the current editor

Given I open an editor "maschinengruppe" from table "(Capacity):(WorkCenter)" with command "UPDATE" for record "122"
# Stundensatz 1 eintragen -> 3-stellig
And I set field "fixkost" to "200.00"
And I set field "varkost" to "222.00"
Then field "plansatz" has value "422.00"
# Stundensatz 2 eintragen -> 1-stellig
And I set field "zfixkost" to "3.00"
And I set field "zvarkost" to "1.00"
Then field "zplansatz" has value "4.00"
And I save the current editor
And I close the current editor


# VK-Auftrag ueber 0vfall1 "Bauteil 1"
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "210"
And I set field "kunde" to "001fa1"
And I set field "vom" to "."
And I set field "schlag" to "PlStdSatz_"
And I create a new row at the end of the table
And I set field "artex" to "0vfall1" in row 1
And I set field "mge" to "15" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

#Disposition starten
And I run Scheduling

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "0vfall1"
And I press button "ladetab"
And I set field "bisuch" to "PlStdSatz_" in row 1
And I press button "malle"
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-111" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01." until enddate "."

# Bestellvorschlag + Bestellung (fuer Art. 0efall1)
Given I open an editor "bestellvorschlag-1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "0efall1"
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-1"
And I set field "num4" to "210-BE"
And I set field "lief" to "001fa1"
And I set field "kenn" to "PlStdSatz,"
And I set field "preis" to "30" in row 1
Then field "artex" has value "EK1-FALL1" in row 1
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
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PlStdSatz_001"
And I set fields
	| sofort	| 1		|
	| bzeit		| 0,5	|
	| mzeit		| 8,5	|
	| gut		| 1		|
	| flgksatz	| 5		|
	| fmgk		| 2		|
And I save the current editor

# Rueckmeldung auf letzten Arbeitsgang/ Betriebsauftrag abschliessen
Given I open an editor "rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PlStdSatz_002"
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
And I set field "kenn" to "FALL-PlStdSatz"
And I press button "offueb" in row 1
And I set field "preis" to "373" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################


@FALL-PlStdSatz2
Scenario: Planstundensatz-Umstellung; nach der Umstellung
Given I set the fake date to "16.02.02"

# VK-Auftrag ueber 0vfall2 "Bauteil 1"
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "310"
And I set field "kunde" to "001fa2"
And I set field "vom" to "."
And I set field "schlag" to "PlStdSatz2_"
And I create a new row at the end of the table
And I set field "artex" to "0vfall2" in row 1
And I set field "mge" to "15" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

#Disposition starten
And I run Scheduling

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "0vfall2"
And I press button "ladetab"
And I set field "bisuch" to "PlStdSatz2_" in row 1
And I press button "malle"
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-111" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01." until enddate "."

# Bestellvorschlag + Bestellung (fuer Art. 0efall2)
Given I open an editor "bestellvorschlag-1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "0efall2"
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-1"
And I set field "num4" to "310-BE"
And I set field "lief" to "001fa2"
And I set field "kenn" to "PlStdSatz2,"
And I set field "preis" to "30" in row 1
Then field "artex" has value "EK1-FALL2" in row 1
And I save the current editor
And I close the current editor
And I switch the current editor to editor "bestellvorschlag-1"
And I close the current editor

# Lieferschein aus Bestellung "310-BE" -> Inland
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "310-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."

And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rechnung aus Lieferschein 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "310-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PlStdSatz2_001"
And I set fields
	| sofort	| 1		|
	| bzeit		| 0,5	|
	| mzeit		| 8,5	|
	| gut		| 1		|
	| flgksatz	| 5		|
	| fmgk		| 2		|
And I save the current editor

# Rueckmeldung auf letzten Arbeitsgang/ Betriebsauftrag abschliessen
Given I open an editor "rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PlStdSatz2_002"
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
And I set field "num3" to "310-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-PlStdSatz2"
And I press button "offueb" in row 1
And I set field "preis" to "373" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################
