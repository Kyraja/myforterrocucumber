# *****************************************************************************
#  Name             : ref_bw_vrgstrgl_verkauf.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Test der Weitergabe der Vorgangssteueregel aus den VK-Vorgaengen in die Bewertung
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    @FALL-BW200:   -> Ausloeser: BW2-930
#                      1) hier ein Artikel mit mehreren Einkaefen geliefert/bezahlt
#                      2) Artikel wird ausgeliefert (LS Inland) und mit unterschiedlichen 
#                         T-RE (Inland/Ausland/EU), aber nicht komplett, bezahlt.
#                      3) EU-Teilrechnung wird storniert
#                      4) KM auf ein EK-LS
#                      5) Nachbewerten 
#
# *****************************************************************************

@persistent
Feature: VRGSTRGL in Verkauf
Background: Test von 
Given I set the fake date to "07.01.2002"


# @FALL-BW200  VK: Inland/EU/Ausland; Storno von EU-Rechnung
Scenario: Verkauf: Teilrechnungen; Inland/EU/Ausland; Testumgebung 1

# ========================== Einkauf ========================================
#
# Bestellungen anlegen
Given I create an PurchaseOrder for the Test Case "33" with Price "20.12" in the Area "1"
Given I create an PurchaseOrder for the Test Case "50" with Price "20.12" in the Area "1"
Given I create an PurchaseOrder for the Test Case "150" with Price "20.12" in the Area "1"

# Lieferscheine zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "33" in the Area "1"
Given I create a PurchasingPackingSlip for the Test Case "50" in the Area "1"
Given I create a PurchasingPackingSlip for the Test Case "150" in the Area "1"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "1"

# EK-Rechnungen mit Mengen 33/50/150 und anlegen
Given I create an invoice for the Test Case "33" with Quantity "33" per Price "63.00" to the PurchasingPackingSlip in the Area "1"
Given I create an invoice for the Test Case "50" with Quantity "50" per Price "65.00" to the PurchasingPackingSlip in the Area "1"
Given I create an invoice for the Test Case "150" with Quantity "150" per Price "67.00" to the PurchasingPackingSlip in the Area "1"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "1"

# ========================== Verkauf ========================================
#
# Verkaufslieferschein: 0efall1, 250 Stk
Given I open an editor "vk-ls" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "num3" to "200-LS"
And I set field "kunde" to "001fa1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BW200"
And I create a new row at the end of the table
And I set field "artikel" to "0efall1" in row 1
And I set field "mge" to "250" in row 1
And I set field "preis" to "53.33" in row 1
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "1" with Command Revalue

# VK-Teil-Rechnung1 (Ausland) aus LS generieren
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "vk-ls"
And I set field "num3" to "200-RE1"
And I set field "kunde" to "006fa1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "27" in row 1
And I set field "preis" to "75" in row 1
And I set field "kenn" to "FALL-BW200"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# VK-Teil-Rechnung2 (Inland) aus LS generieren
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "vk-ls"
And I set field "num3" to "200-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "33" in row 1
And I set field "preis" to "71" in row 1
And I set field "kenn" to "FALL-BW200"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# VK-Teil-Rechnung3 (EU) aus LS generieren
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "vk-ls"
And I set field "num3" to "200-RE3"
And I set field "kunde" to "002fa1"
And I set field "rechnustid" to "FR12345678"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BW200"
And I set field "mge" to "79" in row 1
And I set field "preis" to "86" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "1" with Command Revalue

# Storno Rechnung
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+200-RE1"
And I set field "num3" to "200-SRE1"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "1" with Command Revalue

# ========================== Einkauf ========================================
#
# Kostenumlage (110)
# zuerst die Frachtrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa1"
And I set field "num4" to "200km1"
And I set field "kenn" to "FALL-200"
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
And I set field "num135" to "200-KM1"
And I set field "pos" to "$,,kopf^nummer=200km1;art=FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=50-LS;artex=0efall1;mge=50;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "1" with Command Revalue


