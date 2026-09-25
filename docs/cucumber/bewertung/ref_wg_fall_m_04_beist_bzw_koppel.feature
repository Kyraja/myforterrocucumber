# *****************************************************************************
#  Name             : ref_wg_fall_m_04_beist_bzw_koppel.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        :
#  Funktion         : WG; Kontierungsfall M
#
#
#
# *****************************************************************************
@persistent
Feature: WG; Kontierungsfall M
Background: Test von Kontierungsfall 'M' -> besonders die Ersetzung der Konten
Given I set the fake date to "07.01.2002"

@FALL-NurKoppel
# Einkaufsartikel mit Koppelprodukt einkaufen und verkaufen
Scenario: Einkauf mit Koppelprodukt; Testumgebung 40

# Artikel anpassen
Given I open an editor "artikel-40" from table "(Part):(Product)" with command "UPDATE" for record "1efall40"
And I create a new row at the end of the table
And I set field "elex" to "33fall40" in row 1
And I set field "anzahl" to "3" in row 1
And I set field "kompeig" to "Koppelprodukt" in row 1
And I set field "bu" to "Lieferantenbeistellung" in row 1
Then the table has 1 rows
And I save the current editor
And I close the current editor


# VK-Auftrag über 1vfall40 "Bauteil 2"
Given I open an editor "auftrag-40" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "400"
And I set field "kunde" to "001fa40"
And I set field "vom" to "."
And I set field "schlag" to "NUR_KOPPEL"
And I create a new row at the end of the table
And I set field "artex" to "1efall40" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "375" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

#Disposition starten
And I run Scheduling

# Bestellvorschlag + Bestellung
Given I open an editor "bestellvorschlag-40" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-40"
And I set field "num4" to "400-BE"
And I set field "lief" to "001fa40"
And I set field "preis" to "15" in row 1
And I save the current editor
And I close the current editor
And I switch the current editor to editor "bestellvorschlag-40"
And I close the current editor

# Lieferschein aus Bestellung "400-BE" -> Inland
Given I open an editor "lieferschein-40" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-40"
And I set field "num4" to "400-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-NurKoppel,"
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rechnung aus Lieferschein 1
Given I open an editor "rechnung-40" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-40"
And I set field "num4" to "400-RE"
# Ausland
And I set field "lief" to "004fa40"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "15,5" in row 1
And I set field "kenn" to "FALL-NurKoppel,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-40"
And I set field "num3" to "400-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-NurKoppel,"
And I press button "offueb" in row 1
And I set field "preis" to "373" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-NurKoppelOhnePlanpreis
Scenario: Einkauf mit Koppelprodukt(ohne Preis); Testumgebung 41
# Einkaufsartikel nur mit Koppelprodukt (ohne Preis am Anfang) einkaufen und verkaufen
# Logisch macht dieser Fall nicht viel Sinn -> ohne was zu geben, kriege ich was zusaetzlich zur bestellten Ware. Aber es ist moeglich!!!
#
# Hier wird der vorheriger Fall '@FALL-NurKoppel' haargenau wiederholt, nur der Koppelprodukt hat am Anfang kein Preis.
# Der Preis fuer 'Koppel' wird erst am Ende eingetragen.


# bei Koppel-Artikel den Planpreis entfernen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "33fall41"
And I set field "planpr1" to ""
And I save the current editor
And I close the current editor

# Artikel anpassen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "1efall41"
And I create a new row at the end of the table
And I set field "elex" to "33fall41" in row 1
And I set field "anzahl" to "3" in row 1
And I set field "kompeig" to "Koppelprodukt" in row 1
And I set field "bu" to "Lieferantenbeistellung" in row 1
Then the table has 1 rows
And I save the current editor
And I close the current editor


# VK-Auftrag �ber 1vfall41 "Bauteil 2"
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "410"
And I set field "kunde" to "001fa41"
And I set field "vom" to "."
And I set field "schlag" to "NUR_KOPPEL_OHNE_PREIS"
And I create a new row at the end of the table
And I set field "artex" to "1efall41" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "375" in row 1
And I set field "wtrterm" to "." in row 1
And I save the current editor
And I close the current editor

#Disposition starten
And I run Scheduling


# Bestellvorschlag + Bestellung; Inland
Given I open an editor "bestellvorschlag-1" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung-1"
And I set field "num4" to "410-BE"
And I set field "lief" to "001fa41"
And I set field "preis" to "15" in row 1
And I save the current editor
And I close the current editor
And I switch the current editor to editor "bestellvorschlag-1"
And I close the current editor

# Lieferschein aus Bestellung "410-BE" -> Inland
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "410-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-NurKoppelOhnePlanpreis,"
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Rechnung aus Lieferschein 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "410-RE"
# Ausland
And I set field "lief" to "004fa41"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "15,5" in row 1
And I set field "kenn" to "FALL-NurKoppelOhnePlanpreis,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "410-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-NurKoppelOhnePlanpreis,"
And I press button "offueb" in row 1
And I set field "preis" to "373" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# bei Koppel-Artikel den Planpreis eintragen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "33fall41"
And I set field "planpr1" to "3"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-BeistUndKoppel42
# Einkaufsartikel mit Lieferantenbeistellung + Koppelprodukt einkaufen und verkaufen
Scenario: Einkauf mit Beistellung und Koppelprodukt; Testumgebung 42

# Artikel anpassen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "1efall42"
And I create a new row at the end of the table
And I set field "elex" to "2efall42" in row 1
And I set field "anzahl" to "2" in row 1
And I set field "bu" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "33fall42" in row 2
And I set field "anzahl" to "3" in row 2
And I set field "kompeig" to "Koppelprodukt" in row 2
And I set field "bu" to "Lieferantenbeistellung" in row 2
Then the table has 2 rows
And I save the current editor
And I close the current editor

# Beistellteil - '2efall42' - einkaufen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "420b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BeistUndKoppelGleich,"
# EU
And I set field "lief" to "003fa42"
And I set field "rechnustid" to "FR1234567"
#
And I create a new row at the end of the table
And I set field "artex" to "2efall42" in row 1
And I set field "mge" to "30" in row 1
And I set field "preis" to "3,1" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# VK-Auftrag �ber 1vfall42 "Bauteil 2"
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "420-AU"
And I set field "kunde" to "001fa42"
And I set field "vom" to "."
And I set field "schlag" to "BEIST_KOPP_"
And I create a new row at the end of the table
And I set field "artex" to "1efall42" in row 1
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
And I set field "num4" to "420-BE"
# Inland
And I set field "lief" to "001fa42"
And I set field "preis" to "15" in row 1
And I save the current editor
And I close the current editor
And I switch the current editor to editor "bestellvorschlag-1"
And I close the current editor

# Rechnung aus Lieferschein 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "420-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "15,5" in row 1
And I press button "offueb" in row 1
And I set field "kenn" to "FALL-BeistUndKoppel42,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Lieferschein aus Bestellung "420-BE"  Inland -> EU
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "420-LS"
# EU
And I set field "lief" to "003fa42"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "rechnustid" to "FR1234567"
And I set field "versustid" to "FR1234567"
And I set field "kenn" to "FALL-BeistUndKoppel42,"
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "420-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-BeistUndKoppel42,"
And I press button "offueb" in row 1
And I set field "preis" to "373" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-BeistUndKoppelGleich+addKosten
# Einkaufsartikel mit Lieferantenbeistellung + Koppelprodukt einkaufen und verkaufen
# Der Wert der Beistellung ist gleich dem Wert des Koppelprodukts
# VRGSTRGL aendert sich LS (Inland) -> RE (EU)
# am ENde kommen noch add. Kosten auf das Hauptartikel drauf
Scenario: Einkauf mit Beistellung und Koppelprodukt(gleicher Wert); Testumgebung 43

# Artikel anpassen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "1efall43"
And I create a new row at the end of the table
And I set field "elex" to "2efall43" in row 1
And I set field "anzahl" to "2" in row 1
And I set field "bu" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "33fall43" in row 2
And I set field "anzahl" to "3" in row 2
And I set field "kompeig" to "Koppelprodukt" in row 2
And I set field "bu" to "Lieferantenbeistellung" in row 2
Then the table has 2 rows
And I save the current editor
And I close the current editor

# Beistellteil - '2efall43' - einkaufen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "430b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BeistUndKoppelGleich,"
# EU
And I set field "lief" to "003fa43"
And I set field "rechnustid" to "FR1234567"
#
And I create a new row at the end of the table
And I set field "artex" to "2efall43" in row 1
And I set field "mge" to "30" in row 1
And I set field "preis" to "4.50" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# VK-Auftrag �ber 1vfall43 "Bauteil 2"
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "430-AU"
And I set field "kunde" to "001fa43"
And I set field "vom" to "."
And I set field "schlag" to "BEIST_KOPP_"
And I create a new row at the end of the table
And I set field "artex" to "1efall43" in row 1
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
And I set field "num4" to "430-BE"
# Inland
And I set field "lief" to "001fa43"
And I set field "preis" to "15" in row 1
And I save the current editor
And I close the current editor
And I switch the current editor to editor "bestellvorschlag-1"
And I close the current editor

# Lieferschein aus Bestellung "430-BE"  Inland
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "430-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BeistUndKoppelGleich,"
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Rechnung aus Lieferschein 1 -> (EU)
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "430-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BeistUndKoppelGleich,"
# EU
And I set field "lief" to "003fa43"
And I set field "rechnustid" to "FR1234567"
And I set field "versustid" to "FR1234567"
And I press button "offueb" in row 1
And I set field "preis" to "15,5" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "430-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-BeistUndKoppelGleich,"
And I press button "offueb" in row 1
And I set field "preis" to "373" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Kostenumlage (110��)
# zuerst die Frachtrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa43"
And I set field "num4" to "430km1"
And I set field "kenn" to "FALL-BeistUndKoppelGleich,"
And I set field "such" to "KM1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "FRACHT" in row 1
And I set field "pwert" to "110" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "430-KM1"
And I set field "pos" to "$,,kopf^nummer=430km1;art=FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=430b-RE;artex=2efall43;mge=30;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

