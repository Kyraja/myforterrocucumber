# *****************************************************************************
#  Name             : ref_wg_fall_m_03_beistellung_und_koppel.feature
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

@FALL-BeistellungUndKoppel
# Einkaufsartikel mit Lieferantenbeistellung + Koppelprodukt einkaufen und verkaufen
Scenario: Einkauf mit Beistellung und Koppelprodukt; Testumgebung 30

# Artikel anpassen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "1efall30"
And I create a new row at the end of the table
And I set field "elex" to "2efall30" in row 1
And I set field "anzahl" to "2" in row 1
And I set field "bu" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "33fall30" in row 2
And I set field "anzahl" to "3" in row 2
And I set field "kompeig" to "Koppelprodukt" in row 2
And I set field "bu" to "Lieferantenbeistellung" in row 2
Then the table has 2 rows
And I save the current editor
And I close the current editor


# VK-Auftrag über 1vfall30 "Bauteil 2"
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "300-AU"
And I set field "kunde" to "001fa30"
And I set field "vom" to "."
And I set field "schlag" to "BEIST_KOPP_"
And I create a new row at the end of the table
And I set field "artex" to "1efall30" in row 1
And I set field "mge" to "15" in row 1
And I set field "preis" to "375" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

#Disposition starten
And I run Scheduling

# Bestellvorschlag + Bestellung
Given I open an editor "bestellvorschlag-1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-1"
And I set field "num4" to "300-BE"
And I set field "lief" to "001fa30"
And I set field "preis" to "15" in row 1
And I set field "preis" to "3,1" in row 2
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
And I set field "kenn" to "FALL-BeistellungUndKoppel,"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor
And I close the current editor


# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-111" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01." until enddate "."

# Rechnung aus Lieferschein 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "300-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "15,5" in row 1
And I set field "kenn" to "FALL-BeistellungUndKoppel,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "300-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-BeistellungUndKoppel,"
And I press button "offueb" in row 1
And I set field "preis" to "373" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-KoppelOhnePreis
# Hier wird beim Koppel-Artikel der Planpreis geloescht -> erst am Ende kriegt er wieder den Planpreis
Scenario: Einkauf mit Beistellung und Koppelprodukt(ohne Planpreis); Testumgebung 31

# bei Koppel-Artikel Planpreis loeschen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "33fall31"
And I set field "planpr1" to ""
And I save the current editor
And I close the current editor

# Artikel anpassen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "1efall31"
And I create a new row at the end of the table
And I set field "elex" to "2efall31" in row 1
And I set field "anzahl" to "2" in row 1
And I set field "bu" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "33fall31" in row 2
And I set field "anzahl" to "3" in row 2
And I set field "kompeig" to "Koppelprodukt" in row 2
And I set field "bu" to "Lieferantenbeistellung" in row 2
Then the table has 2 rows
And I save the current editor
And I close the current editor


# VK-Auftrag über 1vfall31 "Bauteil 2"
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "310-AU"
And I set field "kunde" to "001fa31"
And I set field "vom" to "."
And I set field "schlag" to "BEIST_KOPP_"
And I create a new row at the end of the table
And I set field "artex" to "1efall31" in row 1
And I set field "mge" to "15" in row 1
And I set field "preis" to "375" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

#Disposition starten
And I run Scheduling


# Bestellvorschlag + Bestellung
Given I open an editor "bestellvorschlag-1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-1"
And I set field "num4" to "310-BE"
And I set field "lief" to "001fa31"
And I set field "preis" to "15" in row 1
And I set field "preis" to "3,1" in row 2
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
And I set field "kenn" to "FALL-KoppelOhnePreis,"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
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
And I set field "preis" to "15,5" in row 1
And I set field "kenn" to "FALL-KoppelOhnePreis,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "310-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-KoppelOhnePreis,"
And I press button "offueb" in row 1
And I set field "preis" to "373" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# beim Koppel-Artikel Planpreis eintragen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "33fall31"
And I set field "planpr1" to "5"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-MZ-LS
Scenario: FALL-MZ-LS; Beistellung, Koppel und MZ in LS; Testumgebung 32

# Artikel anpassen
Given I open an editor "artikel-32" from table "(Part):(Product)" with command "UPDATE" for record "1efall32"
And I create a new row at the end of the table
And I set field "elex" to "2efall32" in row 1
And I set field "anzahl" to "2" in row 1
And I set field "bu" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "33fall32" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "kompeig" to "Koppelprodukt" in row 2
And I set field "bu" to "Lieferantenbeistellung" in row 2
Then the table has 2 rows
And I save the current editor
And I close the current editor


# Beistellteile beschaffen; Inland
Given I open an editor "rechnung-32" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "320b-RE1"
And I set field "lief" to "001fa32"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-MZ-LS,"
And I create a new row at the end of the table
And I set field "artex" to "2efall32" in row 1
And I set field "mge" to "240" in row 1
And I set field "preis" to "3" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# VK-Auftrag über 1efall32 "Einkaufsteil 2"
Given I open an editor "auftrag-32" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "320-AU"
And I set field "kunde" to "001fa32"
And I set field "vom" to "."
And I set field "schlag" to "MZ-LS"
And I create a new row at the end of the table
And I set field "artex" to "1efall32" in row 1
And I set field "mge" to "120" in row 1
And I set field "preis" to "250" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

# Disposition starten
And I run Scheduling


# Bestellvorschlag + Bestellung
Given I open an editor "bestellvorschlag-32" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-32"
And I set field "num4" to "320-BE"
And I set field "lief" to "001fa32"
And I set field "kenn" to "FALL-MZ-LS,"
And I set field "preis" to "50" in row 1
Then field "artex" has value "EK2-FALL32" in row 1
And I save the current editor
And I switch the current editor to editor "bestellvorschlag-32"
And I close the current editor


# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-32" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-32"
And I set field "num4" to "320-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-MZ-LS,"
And I press button "offueb" in row 1
And I press button "mzsubm" to open a subeditor for "MZ-LS" in row 1
And I delete all rows
And I create a new row at the end of the table
And I set field "zuomge" to "70" in row 1
And I set field "ljtext1" to "CHARGE1_LS" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "50" in row 2
And I set field "ljtext1" to "CHARGE2_LS" in row 2
And I save the current editor
And I switch the current editor to editor "lieferschein-32"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rechnung anlegen
Given I open an editor "rechnung-32" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-32"
And I set field "num4" to "320-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-MZ-LS,"
And I set field "mge" to "120" in row 1
And I set field "preis" to "50,10" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# VK-Rechnung aus Auftrag; Ausland
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-32"
And I set field "num3" to "320-RE"
And I set field "fakt" to "ja"
And I set field "kunde" to "006fa32"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-MZ-LS,"
And I press button "offueb" in row 1
And I set field "preis" to "250,50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-MZ-LS-mit-STORNO
Scenario: FALL-MZ-LS; Beistellung, Koppel und MZ mit RE-STORNO; Testumgebung 33

# Artikel anpassen
Given I open an editor "artikel-33" from table "(Part):(Product)" with command "UPDATE" for record "1efall33"
And I create a new row at the end of the table
And I set field "elex" to "2efall33" in row 1
And I set field "anzahl" to "2" in row 1
And I set field "bu" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "33fall33" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "kompeig" to "Koppelprodukt" in row 2
And I set field "bu" to "Lieferantenbeistellung" in row 2
Then the table has 2 rows
And I save the current editor
And I close the current editor


# Beistellteile beschaffen; Inland
Given I open an editor "rechnung-33" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "330b-RE1"
And I set field "lief" to "001fa33"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-MZ-LS,"
And I create a new row at the end of the table
And I set field "artex" to "2efall33" in row 1
And I set field "mge" to "240" in row 1
And I set field "preis" to "3" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# VK-Auftrag über 1efall33 "Einkaufsteil 2"
Given I open an editor "auftrag-33" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "330-AU"
And I set field "kunde" to "001fa33"
And I set field "vom" to "."
And I set field "schlag" to "MZ-LS"
And I create a new row at the end of the table
And I set field "artex" to "1efall33" in row 1
And I set field "mge" to "120" in row 1
And I set field "preis" to "250" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

# Disposition starten
And I run Scheduling


# Bestellvorschlag + Bestellung
Given I open an editor "bestellvorschlag-33" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-33"
And I set field "num4" to "330-BE"
And I set field "lief" to "001fa33"
And I set field "kenn" to "FALL-MZ-LS,"
And I set field "preis" to "50" in row 1
Then field "artex" has value "EK2-FALL33" in row 1
And I save the current editor
And I switch the current editor to editor "bestellvorschlag-33"
And I close the current editor


# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-33" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-33"
And I set field "num4" to "330-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-MZ-LS,"
And I press button "offueb" in row 1
And I press button "mzsubm" to open a subeditor for "MZ-LS" in row 1
And I delete all rows
And I create a new row at the end of the table
And I set field "zuomge" to "40" in row 1
And I set field "ljtext1" to "CHARGE1_LS" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "30" in row 2
And I set field "ljtext1" to "CHARGE2_LS" in row 2
And I create a new row at the end of the table
And I set field "zuomge" to "50" in row 3
And I set field "ljtext1" to "CHARGE3_LS" in row 3
And I save the current editor
And I switch the current editor to editor "lieferschein-33"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Teil-Rechnung anlegen; EU
Given I open an editor "rechnung-33" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-33"
And I set field "num4" to "330-RE1"
And I set field "lief" to "003fa33"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-MZ-LS,"
And I set field "mge" to "60" in row 1
And I set field "preis" to "48" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Teil-Rechnung anlegen; Ausland
Given I open an editor "rechnung-33a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-33"
And I set field "num4" to "330-RE2"
And I set field "lief" to "004fa33"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "60" in row 1
And I set field "preis" to "51" in row 1
And I set field "kenn" to "FALL-MZ-LS,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Storno Rechnung
Given I open an editor "rechnung-storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+330-RE2"
And I set field "num4" to "330-SRE2"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# VK-Rechnung aus Auftrag; Ausland
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-33"
And I set field "num3" to "330-RE"
And I set field "fakt" to "ja"
And I set field "kunde" to "006fa33"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-MZ-LS,"
And I press button "offueb" in row 1
And I set field "preis" to "250,50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rest (stornierte Menge) von der Lieferung bezahlen
Given I open an editor "rechnung-33" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-33"
And I set field "num4" to "330RE2a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "60" in row 1
And I set field "kenn" to "FALL-MZ-LS,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-MZ-RE
Scenario: FALL-MZ-RE; Beistellung, Koppel und MZ in RE; Testumgebung 34

# Artikel anpassen
Given I open an editor "artikel-34" from table "(Part):(Product)" with command "UPDATE" for record "1efall34"
And I create a new row at the end of the table
And I set field "elex" to "2efall34" in row 1
And I set field "anzahl" to "2" in row 1
And I set field "bu" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "33fall34" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "kompeig" to "Koppelprodukt" in row 2
And I set field "bu" to "Lieferantenbeistellung" in row 2
Then the table has 2 rows
And I save the current editor
And I close the current editor


# Beistellteile beschaffen; Inland
Given I open an editor "rechnung-34" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "340b-RE"
And I set field "lief" to "001fa34"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-MZ-RE,"
And I create a new row at the end of the table
And I set field "artex" to "2efall34" in row 1
And I set field "mge" to "240" in row 1
And I set field "preis" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# VK-Auftrag über 1efall34 "Einkaufsteil 2"
Given I open an editor "auftrag-34" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "340-AU"
And I set field "kunde" to "001fa34"
And I set field "vom" to "."
And I set field "schlag" to "MZ-RE"
And I create a new row at the end of the table
And I set field "artex" to "1efall34" in row 1
And I set field "mge" to "120" in row 1
And I set field "preis" to "250" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

# Disposition starten
And I run Scheduling


# Bestellvorschlag + Bestellung
Given I open an editor "bestellvorschlag-34" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-34"
And I set field "num4" to "340-BE"
And I set field "lief" to "001fa34"
And I set field "kenn" to "FALL-MZ-RE,"
And I set field "preis" to "50" in row 1
Then field "artex" has value "EK2-FALL34" in row 1
And I save the current editor
And I switch the current editor to editor "bestellvorschlag-34"
And I close the current editor


# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-34" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-34"
And I set field "num4" to "340-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-MZ-RE,"
And I press button "offueb" in row 1
And I press button "mzsubm" to open a subeditor for "MZinRE" in row 1
And I delete all rows
And I create a new row at the end of the table
And I set field "zuomge" to "95" in row 1
And I set field "ljtext1" to "CHARGE1_RE" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "25" in row 2
And I set field "ljtext1" to "CHARGE2_RE" in row 2
Then the table has 2 rows
And I save the current editor
And I switch the current editor to editor "lieferschein-34"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# EK-Rechnung anlegen;
Given I open an editor "rechnung-34" from table "(Purchasing):(Invoice)" with command "COPY" for record "340-LS"
#And I set field "kenn" to "FALL-MZ-RE,"
#And I set field "beleg" to id from editor "lieferschein-34"
And I set field "num4" to "340-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "fakt" has value "nein"
Then the table has 1 rows
Then field "artex" has value "EK2-FALL34" in row 1
Then field "mge" has value "120" in row 1
And I set field "preis" to "50,10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# VK-Rechnung aus Auftrag; Ausland
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-34"
And I set field "num3" to "340-RE"
And I set field "fakt" to "ja"
And I set field "kunde" to "006fa34"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-MZ-RE,"
And I press button "offueb" in row 1
And I set field "preis" to "250,50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-BeistellungUndKoppelGleichwertig
# Einkaufsartikel mit Lieferantenbeistellung + Koppelprodukt einkaufen und verkaufen
# Dabei ist der Wert vom Koppelprodukt gleich dem Werte der Beistellung
# und die Beistellteile werden vorher (vor dispo) eingekauft -> wegen Preisstatus 'direkt'
Scenario: Einkauf mit Beistellung und Koppelprodukt; Testumgebung 35

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

# Beistellteil '2efall35' auf Vorrat einkaufen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "350a-RE"
And I set field "lief" to "001fa35"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "2efall35" in row 1
And I set field "mge" to "30" in row 1
And I set field "preis" to "3" in row 1
And I set field "kenn" to "FALL-BeistellungUndKoppelGleichwertig,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-111" with type of cost entry "Verbuchung Lagerbestand" for startdate "01.01." until enddate "."


#Disposition starten
And I run Scheduling


# Bestellvorschlag + Bestellung
Given I open an editor "bestellvorschlag-1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-1"
And I set field "num4" to "350-BE"
And I set field "lief" to "001fa35"
And I set field "preis" to "15" in row 1
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
And I set field "kenn" to "FALL-BeistellungUndKoppelGleichwertig,"
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rechnung aus Lieferschein 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "350-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "15,5" in row 1
And I set field "kenn" to "FALL-BeistellungUndKoppelGleichwertig,"
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
And I set field "kenn" to "FALL-BeistellungUndKoppelGleichwertig,"
And I press button "offueb" in row 1
And I set field "preis" to "373" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################


@FALL-BeistellungUndKoppelGleichwertig2
# Einkaufsartikel mit Lieferantenbeistellung + Koppelprodukt einkaufen und verkaufen
# Dabei ist der Wert vom Koppelprodukt gleich dem Werte der Beistellung
# und die Beistellteile sind am Anfang (vor dispo) noch nicht da -> wegen Preisstatus 'vorlaeufig'
Scenario: Einkauf mit Beistellung und Koppelprodukt; Testumgebung 36

# Artikel anpassen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "1efall36"
And I create a new row at the end of the table
And I set field "elex" to "2efall36" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "bu" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "33fall36" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "kompeig" to "Koppelprodukt" in row 2
And I set field "bu" to "Lieferantenbeistellung" in row 2
Then the table has 2 rows
And I save the current editor
And I close the current editor


# VK-Auftrag über 1vfall36 "Bauteil 2"
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "360-AU"
And I set field "kunde" to "001fa36"
And I set field "vom" to "."
And I set field "schlag" to "BEIST_KOPP_"
And I create a new row at the end of the table
And I set field "artex" to "1efall36" in row 1
And I set field "mge" to "15" in row 1
And I set field "preis" to "375" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

#Disposition starten
And I run Scheduling

# Bestellvorschlag + Bestellung
Given I open an editor "bestellvorschlag-1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-1"
And I set field "num4" to "360-BE"
And I set field "lief" to "001fa36"
And I set field "preis" to "15" in row 1
And I set field "preis" to "3,00" in row 2
And I save the current editor
And I close the current editor
And I switch the current editor to editor "bestellvorschlag-1"
And I close the current editor

# Lieferschein aus Bestellung "360-BE" -> Inland
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "360-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BeistellungUndKoppelGleichwertig2,"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rechnung aus Lieferschein 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "360-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "15,5" in row 1
And I set field "kenn" to "FALL-BeistellungUndKoppelGleichwertig2,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "360-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-BeistellungUndKoppelGleichwertig2,"
And I press button "offueb" in row 1
And I set field "preis" to "373" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################
