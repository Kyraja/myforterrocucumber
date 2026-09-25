# *****************************************************************************
#  Name             : ref_bw_add_kosten_03_beistellung.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        :
#  Funktion         : Test der add. Kosten, die auf Vorgaenge mit MZ umgelegt werden
#
#
#
#
# *****************************************************************************

@persistent
Feature: add.Kosten
Background: Test von add. Kosten in der Bewertung
Given I set the fake date to "07.01.2002"


@FALL-Beistellung;KoppelUndKM

Scenario: Einkauf mit Beistellung und Koppelprodukt + KM auf RE; Testumgebung 35

# Artikel anpassen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "1efall35"
And I create a new row at the end of the table
And I set field "elex" to "2efall35" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "bu" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "33fall35" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "kompeig" to "Koppelprodukt" in row 2
And I set field "bu" to "Lieferantenbeistellung" in row 2
Then the table has 2 rows
And I save the current editor
And I close the current editor


# Beistellteil '2efall35' auf Vorrat einkaufen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "350a-RE"
And I set field "lief" to "001fa35"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "2efall35" in row 1
And I set field "mge" to "350" in row 1
And I set field "preis" to "3,30" in row 1
And I set field "kenn" to "FALL-Beistellung;KoppelUndKM,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# VK-Auftrag über 1vfall35 "Bauteil 2"
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "350-AU"
And I set field "kunde" to "001fa35"
And I set field "vom" to "."
And I set field "schlag" to "BEIST_KOPP_"
And I create a new row at the end of the table
And I set field "artex" to "1efall35" in row 1
And I set field "mge" to "15" in row 1
And I set field "preis" to "375" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


#Disposition starten
And I run Scheduling

# Bestellvorschlag + Bestellung
Given I open an editor "bestellvorschlag-1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-1"
And I set field "num4" to "350-BE"
And I set field "lief" to "001fa35"
And I set field "preis" to "17" in row 1
And I save the current editor
And I close the current editor
And I switch the current editor to editor "bestellvorschlag-1"
And I close the current editor

# Lieferschein aus Bestellung "350-BE" -> Inland
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "350-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-Beistellung;KoppelUndKM,"
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor
#

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-111" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01." until enddate "."

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-111" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01." until enddate "."

# Rechnung aus Lieferschein 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "350-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "17,5" in row 1
And I set field "kenn" to "FALL-Beistellung;KoppelUndKM,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "350-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-Beistellung;KoppelUndKM,"
And I press button "offueb" in row 1
And I set field "preis" to "373" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Kostenumlage (110�)
# eine Versicherungsrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "003fa35"
And I set field "num4" to "350km2"
And I set field "kenn" to "FALL-Beistellung;KoppelUndKM,"
And I set field "such" to "KM350"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VERS" in row 1
And I set field "pwert" to "110" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "350-KM2"
And I set field "pos" to "$,,kopf^nummer=350km2;art=VERS;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=350-RE;artex=1efall35;mge=15;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
####################################################################################################################################

