# *****************************************************************************
#  Name             : ref_bw_storno_der_ruecklieferung_3.feature
#  Autor            : wane
#  Verantwortlich   : uo
#  Kontrolle        :
#  Funktion         : Einkauf: testet STORNO von Ruecklieferungen von Teilen
#                              mit Lieferantenbeistellung,
#                              Bewertungen stehen im Vordergrund und zwar die,
#                              die zu den Beistellabgaengen erzeugt wurden.
#
#  Beschreibung:
#     Im 1. Schritt (Umgebung 20) wird hier ein Szenario mit Ruecklieferung
#        und Storno der Ruecklieferung von den Einkaufsartikel mit Lieferantenbeistellung
#        durchgefuehrt.
#        -> siehe unten 'Ablauf im 1. Schritt'
#     Im 2. Schritt (Umgebung 21) wird das Szenario aus dem 1. Schritt wiederholt,
#        aber ohne Ruecklieferung und Storno der Ruecklieferung -> Teilschritte 13 und 20 werden ausgelassen.
#     Im 3. Schritt werden ausgewaehlte Bewertungen zu den Beistellabgeaengen
#        analysiert/geprueft.
#
#
# Ablauf im 1. Schritt:
# =====================
#
# @FALL-Beistellung
# Scenario: EK Rueklieferung + Storno von Artikel mit Beistellung; Testumgebung 20
#    1) Stammdaten anlegen:
#       * ein Artikel Art0 (0efall20) mit 4 Beistellteilen: Art1, Art2, Art3 und Art4 anlegen:
#         Art1 (1efall20)  -> Lieferantenbeistellung, 1 Stk.
#         Art2 (2efall20)  -> Lieferantenbeistellung, 1 Stk.
#         Art3 (3efall20)  -> Lieferantenbeistellung, 1 Stk.
#         Art4 (4efall20)  -> Lieferantenbeistellung, 1 Stk.
#    2) Bestellungen:
#       * Artikel mit Beistellung
#         Art0 = BE0, 100 Stk. zu 10 EURO
#       * Beistellteile bestellen (nicht alle wohl gemerkt)
#         Art1 = BE1, 100 Stk. zu 1 EURO
#         Art2 = BE2, 100 Stk. zu 2 EURO
#         Art4 = BE4, 100 Stk. zu 4 EURO
#    3) Art2 liefern: aus BE2
#         LS2_001   20 Stk
#         LS2_002   40 Stk
#         LS2_003   30 Stk
#         LS2_004   10 Stk
#    4) Art3 liefern: ohne Bestellung ohne Preis
#         LS3_001   20 Stk
#         LS3_002   40 Stk
#         LS3_003   30 Stk
#         LS3_004   10 Stk
#    5) Art4 einkaufen:
#         LS4_001  30 Stk + RE4_001a zu 4.10 EURO
#         LS4_002  30 Stk + RE4_002  zu 4.20 EURO
#         RE4_003  40 Stk mit Lagerbewegung zu 4.30 EURO
#    6) Prüfung: Bestand
#    7) Artikel mit Beistellteilen einkaufen
#         Art0 einkaufen 100 Stk: LS0_001 + RE0_001
#    8) Art1 (80 Stk) liefern: LS aus BE1
#         LS1_001 20 Stk
#         LS1_002 20 Stk
#         LS1_003 20 Stk
#         LS1_004 20 Stk
#    9) Art1 bezahlen:
#         LS1_001 -> RE1_001  zu 1.10 EURO
#         LS1_002 -> RE1_002  zu 1.20 EURO
#         LS1_003 -> RE1_003  zu 1.30 EURO
#   10) Art2 bezahlen:
#         LS2_001 -> RE2_001
#         LS2_002 -> RE2_002
#         LS2_003 -> RE2_003
#   11) Art3 bezahlen: (in umgekehrter Reihenfolge buchen)
#         LS3_004 -> RE3_004
#         LS3_003 -> RE3_003
#         LS3_002 -> RE3_002
#         LS3_001 -> RE3_001
#   12) Storno RE4_001a
#         RE4_001a -> RE4_STOR
#   13) Rücklieferung ("RETURN" for record "+20_0ls1") : 60 Stk.
#         0RLS Art0: -60 Stk.
#   14) Prüfung: Bestand
#   15) Art1 Rest liefern:
#         LS1_005 20 Stk
#   16) Art1 bezahlen:
#         LS1_005 -> RE1_005 zu 1.50 EURO
#         LS1_004 -> RE1_004 zu 1.40 EURO
#   17) Art2 bezahlen:
#         LS2_004 -> RE2_004
#   18) Kostenumlage auf RE4_002 (Art. '2efall20') 50 EURO:
#         SpedRE
#         Kostenumlage (55�)
#    19) LS4_001 (30 Stk) wieder bezahlen
#         LS4_001 -> RE4_001b
#    20) Storno RLS0: +60 Stk.
#         0RLS -> 0RLS_ST
#    21) Pruefung: Bestand
#
# *****************************************************************************
@persistent
Feature: STORNO von Ruecklieferungen(Beistellung)
Background: Test von Bewertungen, die beim STORNO von Ruecklieferungen entstehen
Given I set the fake date to "24.01.2002"

@FALL-Beistellung
Scenario: EK Rueklieferung + Storno von Artikel mit Beistellung; Testumgebung 20

# * ein Artikel Art0 mit 4 Beistellteilen: Art1, Art2, Art3 und Art4:
# Art1 -> Lieferantenbeistellung, 1 Stk.
# Art2 -> Lieferantenbeistellung, 1 Stk.
# Art3 -> Lieferantenbeistellung, 1 Stk.
# Art4 -> Lieferantenbeistellung, 1 Stk.
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "1efall20"
And I set field "such" to "ART1-FALL20"
And I set field "namebspr" to "Beistellartikel 1; FALL 20"
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "2efall20"
And I set field "such" to "ART2-FALL20"
And I set field "namebspr" to "Beistellartikel 2; FALL 20"
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "COPY" for record "0efall20"
And I set field "nummer" to "3efall20"
And I set field "such" to "ART3-FALL20"
And I set field "namebspr" to "Beistellartikel 3; FALL 20"
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "COPY" for record "0efall20"
And I set field "nummer" to "4efall20"
And I set field "such" to "ART4-FALL20"
And I set field "namebspr" to "Beistellartikel 4; FALL 20"
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "0efall20"
And I set field "such" to "ART0-FALL20"
And I create a new row at the end of the table
And I set field "elex" to "1efall20" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "bu" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "2efall20" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "bu" to "Lieferantenbeistellung" in row 2
And I create a new row at the end of the table
And I set field "elex" to "3efall20" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "bu" to "Lieferantenbeistellung" in row 3
And I create a new row at the end of the table
And I set field "elex" to "4efall20" in row 4
And I set field "anzahl" to "1" in row 4
And I set field "bu" to "Lieferantenbeistellung" in row 4
Then the table has 4 rows
And I save the current editor
And I close the current editor

#
# * Prüfung: Anfangbestand
# Art1 = 0
# Art2 = 0
# Art3 = 0
# Art4 = 0
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "0efall20"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "1efall20"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "2efall20"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "3efall20"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "4efall20"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor

#
# * Beistellteile bestellen (nicht alle wohl gemerkt)
# Art0 = BE0, 100 Stk.
# Art1 = BE1, 100 Stk.
# Art2 = BE2, 100 Stk.
# Art4 = BE4, 100 Stk.

Given I open an editor "bestellung-0" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa20"
And I set field "num4" to "20-BE0"
And I set field "kenn" to "FALL-Beistellung,"
And I create a new row at the end of the table
And I set field "artex" to "0efall20" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "10.00" in row 1
And I save the current editor

Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa20"
And I set field "num4" to "20-BE1"
And I set field "kenn" to "FALL-Beistellung,"
And I create a new row at the end of the table
And I set field "artex" to "1efall20" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1.00" in row 1
And I save the current editor

Given I open an editor "bestellung-2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa20"
And I set field "num4" to "20-BE2"
And I set field "kenn" to "FALL-Beistellung,"
And I create a new row at the end of the table
And I set field "artex" to "2efall20" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "2.00" in row 1
And I save the current editor

Given I open an editor "bestellung-4" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa20"
And I set field "num4" to "20-BE4"
And I set field "kenn" to "FALL-Beistellung,"
And I create a new row at the end of the table
And I set field "artex" to "4efall20" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "4.00" in row 1
And I save the current editor

#
# * Art2 liefern: aus BE2
# LS2_001   20 Stk
# LS2_002   40 Stk
# LS2_003   30 Stk
# LS2_004   10 Stk
Given I open an editor "LS2_001" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2"
And I set field "num4" to "20_2ls1"
And I set field "such" to "LS2_001"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS2_002" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2"
And I set field "num4" to "20_2ls2"
And I set field "such" to "LS2_002"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS2_003" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2"
And I set field "num4" to "20_2ls3"
And I set field "such" to "LS2_003"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS2_004" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2"
And I set field "num4" to "20_2ls4"
And I set field "such" to "LS2_004"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I save the current editor
And I close the current editor
#
# * Art3 liefern: ohne Bestellung ohne Preis
# LS3_001   20 Stk
# LS3_002   40 Stk
# LS3_003   30 Stk
# LS3_004   10 Stk
Given I open an editor "LS3_001" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "num4" to "20_3ls1"
And I set field "such" to "LS3_001"
And I set field "lief" to "001fa20"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "3efall20" in row 1
And I set field "mge" to "20" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS3_002" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "num4" to "20_3ls2"
And I set field "such" to "LS3_002"
And I set field "lief" to "001fa20"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "3efall20" in row 1
And I set field "mge" to "40" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS3_003" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "num4" to "20_3ls3"
And I set field "such" to "LS3_003"
And I set field "lief" to "001fa20"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "3efall20" in row 1
And I set field "mge" to "30" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS3_004" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "num4" to "20_3ls4"
And I set field "such" to "LS3_004"
And I set field "lief" to "001fa20"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "3efall20" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor
And I close the current editor


# * Art4 einkaufen:
# LS4_001  30 Stk + RE4_001a
# LS4_002  30 Stk + RE4_002
# RE4_003  40 Stk mit Lagerbewegung
Given I open an editor "LS4_001" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-4"
And I set field "num4" to "20_4ls1"
And I set field "such" to "LS4_001"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I save the current editor
And I close the current editor
# Rechnung aus Lieferschein
Given I open an editor "RE4_001a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS4_001"
And I set field "num4" to "20_4re1"
And I set field "such" to "RE4_001a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "preis" has value "4.00" in row 1
And I set field "preis" to "4.10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "LS4_002" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-4"
And I set field "num4" to "20_4ls2"
And I set field "such" to "LS4_002"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I save the current editor
And I close the current editor
# Rechnung aus Lieferschein
Given I open an editor "RE4_002" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS4_002"
And I set field "num4" to "20_4re2"
And I set field "such" to "RE4_002"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "preis" has value "4.00" in row 1
And I set field "preis" to "4.20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Rechnung aus Lieferschein
Given I open an editor "RE4_003" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-4"
And I set field "num4" to "20_4re3"
And I set field "such" to "RE4_003"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "preis" has value "4.00" in row 1
And I set field "preis" to "4.30" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

#
# * Pruefung: Bestand
# Art0 = 0
# Art1 = 0
# Art2 = 100, vorl�ufig (geliefert nicht bezahlt)
# Art3 = 100, unbewertet (geliefert nicht bezahlt, ohne Preis)
# Art4 = 100, direkt (bezahlt)

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "0efall20"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "1efall20"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "2efall20"
Then field "bestand" has value "100" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "3efall20"
Then field "bestand" has value "100" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "4efall20"
Then field "bestand" has value "100" in row 0
And I save the current editor
And I close the current editor

#
# * Artikel mit Beistellteilen einkaufen
# Art0 einkaufen 100 Stk
Given I open an editor "LS0_001" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-0"
And I set field "num4" to "20_0ls1"
And I set field "such" to "LS0_001"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# Rechnung aus Lieferschein
Given I open an editor "RE0_001" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS0_001"
And I set field "num4" to "20_0re1"
And I set field "such" to "RE0_001"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

#
# * Art1 (80 Stk) bestellen: BE1
# Art1 liefern: LS1_001 20 Stk
# Art1 liefern: LS1_002 20 Stk
# Art1 liefern: LS1_003 20 Stk
# Art1 liefern: LS1_004 20 Stk
Given I open an editor "LS1_001" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "20_1ls1"
And I set field "such" to "LS1_001"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS1_002" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "20_1ls2"
And I set field "such" to "LS1_002"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS1_003" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "20_1ls3"
And I set field "such" to "LS1_003"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS1_004" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "20_1ls4"
And I set field "such" to "LS1_004"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

#
# * ===== Bezahlen  =======
# Art1 :
# LS1_001 -> RE1_001
# LS1_002 -> RE1_002
# LS1_003 -> RE1_003
# Rechnung aus Lieferschein
Given I open an editor "RE1_001" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS1_001"
And I set field "num4" to "20_1re1"
And I set field "such" to "RE1_001"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "artikel" has value "ART1-FALL20" in row 1
Then field "mge" has value "20" in row 1
Then field "preis" has value "1.00" in row 1
And I set field "preis" to "1.10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "RE1_002" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS1_002"
And I set field "num4" to "20_1re2"
And I set field "such" to "RE1_002"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "artikel" has value "ART1-FALL20" in row 1
Then field "mge" has value "20" in row 1
Then field "preis" has value "1.00" in row 1
And I set field "preis" to "1.20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "RE1_003" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS1_003"
And I set field "num4" to "20_1re3"
And I set field "such" to "RE1_003"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "artikel" has value "ART1-FALL20" in row 1
Then field "mge" has value "20" in row 1
Then field "preis" has value "1.00" in row 1
And I set field "preis" to "1.30" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

#
# * Art2
# LS2_001 -> RE2_001
# LS2_002 -> RE2_002
# LS2_003 -> RE2_003
# Rechnung aus Lieferschein
Given I open an editor "RE2_001" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS2_001"
And I set field "num4" to "20_2re1"
And I set field "such" to "RE2_001"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "RE2_002" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS2_002"
And I set field "num4" to "20_2re2"
And I set field "such" to "RE2_002"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "RE2_003" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS2_003"
And I set field "num4" to "20_2re3"
And I set field "such" to "RE2_003"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

#
# * Art3 (in umgekehrter Reihenfolge buchen)
# LS3_004 -> RE3_004
Given I open an editor "RE3_004" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS3_004"
And I set field "num4" to "20_3re4"
And I set field "such" to "RE3_004"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# LS3_003 -> RE3_003
Given I open an editor "RE3_003" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS3_003"
And I set field "num4" to "20_3re3"
And I set field "such" to "RE3_003"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# LS3_002 -> RE3_002
Given I open an editor "RE3_002" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS3_002"
And I set field "num4" to "20_3re2"
And I set field "such" to "RE3_002"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# LS3_001 -> RE3_001
Given I open an editor "RE3_001" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS3_001"
And I set field "num4" to "20_3re1"
And I set field "such" to "RE3_001"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# * Storno RE4_001a
# RE4_001a -> RE4_STOR
Given I open an editor "teilre-storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+20_4re1"
Then I set field "nummer" to "20_4sre1"
Then field "bem" is modifiable
And I set field "schlag" to "Preis ist falsch"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# * Ruecklieferung: 60 Stk.
# 0RLS Art0: -60 Stk.
Given I open an editor "ruecklief-0" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+20_0ls1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "20_0rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "ART0-FALL20" in row 1
And I set field "mge" to "-60" in row 1
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# * Pruefung: Bestand
# Art1 = 40
# Art2 = 60
# Art3 = 60
# Art4 = 60
# Art0 = 40
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "0efall20"
Then field "bestand" has value "40" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "1efall20"
Then field "bestand" has value "40" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "2efall20"
Then field "bestand" has value "60" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "3efall20"
Then field "bestand" has value "60" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "4efall20"
Then field "bestand" has value "60" in row 0
And I save the current editor
And I close the current editor
#
# * Art1 Rest liefern:
# LS1_005 20 Stk
Given I open an editor "LS1_005" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "20_1ls5"
And I set field "such" to "LS1_005"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# LS1_005 -> RE1_005
Given I open an editor "RE1_005" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS1_005"
And I set field "num4" to "20_1re5"
And I set field "such" to "RE1_005"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "artikel" has value "ART1-FALL20" in row 1
Then field "mge" has value "20" in row 1
Then field "preis" has value "1.00" in row 1
And I set field "preis" to "1.50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# LS1_004 -> RE1_004
Given I open an editor "RE1_004" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS1_004"
And I set field "num4" to "20_1re4"
And I set field "such" to "RE1_004"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "artikel" has value "ART1-FALL20" in row 1
Then field "mge" has value "20" in row 1
Then field "preis" has value "1.00" in row 1
And I set field "preis" to "1.40" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# LS2_004 -> RE2_004
Given I open an editor "RE2_004" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS2_004"
And I set field "num4" to "20_2re4"
And I set field "such" to "RE2_004"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# * Kostenumlage auf RE4_002  50 EURO:
# SpedRE + KM
# Kostenumlage (110�)
# eine Versicherungsrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "003fa20"
And I set field "num4" to "20km"
And I set field "kenn" to "FALL-Beistellung;"
And I set field "such" to "KM20"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VERS" in row 1
And I set field "pwert" to "50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "20-KM"
And I set field "pos" to "$,,kopf^nummer=20km;art=VERS;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=20_2re4;artex=2efall20;mge=10;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# * LS4_001  30 Stk bezahlen
# LS4_001 -> RE4_001b
Given I open an editor "RE4_001b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS4_001"
And I set field "num4" to "20_2re4b"
And I set field "such" to "RE4_001b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# * Storno RLS0: +60 Stk.
# 0RLS -> 0RLS_ST
Given I open an editor "storno-rls" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "20_0rls"
Then I set field "nummer" to "20SRLS"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# * Pruefung: Bestand
# Art1 = 0
# Art2 = 0
# Art3 = 0
# Art4 = 0
# Art0 = 100
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "0efall20"
Then field "bestand" has value "100" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "1efall20"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "2efall20"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "3efall20"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "4efall20"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor
##############################################################################################################

@FALL-BeistOhneRLS
Scenario: EK Wiederholung ohne Ruecklieferschein und Storno; Testumgebung 21
#
# Hier wird das Szenario aus der Umgebung 20 wiederholt. Aber hier wird nix zurueckgeliefert 
# und als Folge gibt es auch kein Storno von der Ruecklieferung
# naehere Informationen siehe 'Scenario: EK Rueklieferung + Storno von Artikel mit Beistellung; Testumgebung 20'


# * ein Artikel Art0 mit 4 Beistellteilen: Art1, Art2, Art3 und Art4:
# Art1 -> Lieferantenbeistellung, 1 Stk.
# Art2 -> Lieferantenbeistellung, 1 Stk.
# Art3 -> Lieferantenbeistellung, 1 Stk.
# Art4 -> Lieferantenbeistellung, 1 Stk.
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "1efall21"
And I set field "such" to "ART1-FALL21"
And I set field "namebspr" to "Beistellartikel 1; FALL 21"
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "2efall21"
And I set field "such" to "ART2-FALL21"
And I set field "namebspr" to "Beistellartikel 2; FALL 21"
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "COPY" for record "0efall21"
And I set field "nummer" to "3efall21"
And I set field "such" to "ART3-FALL21"
And I set field "namebspr" to "Beistellartikel 3; FALL 21"
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "COPY" for record "0efall21"
And I set field "nummer" to "4efall21"
And I set field "such" to "ART4-FALL21"
And I set field "namebspr" to "Beistellartikel 4; FALL 21"
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "0efall21"
And I set field "such" to "ART0-FALL21"
And I create a new row at the end of the table
And I set field "elex" to "1efall21" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "bu" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "2efall21" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "bu" to "Lieferantenbeistellung" in row 2
And I create a new row at the end of the table
And I set field "elex" to "3efall21" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "bu" to "Lieferantenbeistellung" in row 3
And I create a new row at the end of the table
And I set field "elex" to "4efall21" in row 4
And I set field "anzahl" to "1" in row 4
And I set field "bu" to "Lieferantenbeistellung" in row 4
Then the table has 4 rows
And I save the current editor
And I close the current editor

#
# * Pruefung: Anfangbestand
# Art1 = 0
# Art2 = 0
# Art3 = 0
# Art4 = 0
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "0efall21"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "1efall21"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "2efall21"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "3efall21"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "4efall21"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor

#
# * Beistellteile bestellen (nicht alle wohl gemerkt)
# Art0 = BE10, 100 Stk.
# Art1 = BE11, 100 Stk.
# Art2 = BE12, 100 Stk.
# Art4 = BE14, 100 Stk.

Given I open an editor "bestellung-0" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa21"
And I set field "num4" to "21-BE10"
And I set field "kenn" to "FALL-BeistOhneRLS,"
And I create a new row at the end of the table
And I set field "artex" to "0efall21" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "10.00" in row 1
And I save the current editor

Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa21"
And I set field "num4" to "21-BE11"
And I set field "kenn" to "FALL-BeistOhneRLS,"
And I create a new row at the end of the table
And I set field "artex" to "1efall21" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1.00" in row 1
And I save the current editor

Given I open an editor "bestellung-2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa21"
And I set field "num4" to "21-BE12"
And I set field "kenn" to "FALL-BeistOhneRLS,"
And I create a new row at the end of the table
And I set field "artex" to "2efall21" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "2.00" in row 1
And I save the current editor

Given I open an editor "bestellung-4" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa21"
And I set field "num4" to "21-BE14"
And I set field "kenn" to "FALL-BeistOhneRLS,"
And I create a new row at the end of the table
And I set field "artex" to "4efall21" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "4.00" in row 1
And I save the current editor

#
# * Art2 liefern: aus BE12
# LS2_101   20 Stk
# LS2_102   40 Stk
# LS2_103   30 Stk
# LS2_104   10 Stk
Given I open an editor "LS2_101" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2"
And I set field "num4" to "21_2ls1"
And I set field "such" to "LS2_101"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS2_102" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2"
And I set field "num4" to "21_2ls2"
And I set field "such" to "LS2_102"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS2_103" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2"
And I set field "num4" to "21_2ls3"
And I set field "such" to "LS2_103"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS2_104" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2"
And I set field "num4" to "21_2ls4"
And I set field "such" to "LS2_104"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I save the current editor
And I close the current editor
#
# * Art3 liefern: ohne Bestellung ohne Preis
# LS3_101   20 Stk
# LS3_102   40 Stk
# LS3_103   30 Stk
# LS3_104   10 Stk
Given I open an editor "LS3_101" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "num4" to "21_3ls1"
And I set field "such" to "LS3_101"
And I set field "lief" to "001fa21"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "3efall21" in row 1
And I set field "mge" to "20" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS3_102" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "num4" to "21_3ls2"
And I set field "such" to "LS3_102"
And I set field "lief" to "001fa21"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "3efall21" in row 1
And I set field "mge" to "40" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS3_103" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "num4" to "21_3ls3"
And I set field "such" to "LS3_103"
And I set field "lief" to "001fa21"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "3efall21" in row 1
And I set field "mge" to "30" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS3_104" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "num4" to "21_3ls4"
And I set field "such" to "LS3_104"
And I set field "lief" to "001fa21"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "3efall21" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor
And I close the current editor

# * Art4 einkaufen:
# LS4_101  30 Stk + RE4_101a
# LS4_102  30 Stk + RE4_102
# RE4_103  40 Stk mit Lagerbewegung
Given I open an editor "LS4_101" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-4"
And I set field "num4" to "21_4ls1"
And I set field "such" to "LS4_101"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I save the current editor
And I close the current editor
# Rechnung aus Lieferschein
Given I open an editor "RE4_101a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS4_101"
And I set field "num4" to "21_4re1"
And I set field "such" to "RE4_101a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "preis" has value "4.00" in row 1
And I set field "preis" to "4.10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "LS4_102" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-4"
And I set field "num4" to "21_4ls2"
And I set field "such" to "LS4_102"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I save the current editor
And I close the current editor
# Rechnung aus Lieferschein
Given I open an editor "RE4_102" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS4_102"
And I set field "num4" to "21_4re2"
And I set field "such" to "RE4_102"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "preis" has value "4.00" in row 1
And I set field "preis" to "4.20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Rechnung aus Lieferschein
Given I open an editor "RE4_103" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-4"
And I set field "num4" to "21_4re3"
And I set field "such" to "RE4_103"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "preis" has value "4.00" in row 1
And I set field "preis" to "4.30" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

#
# * Pruefung: Bestand
# Art1 = 0
# Art2 = 100, vorl�ufig (geliefert nicht bezahlt)
# Art3 = 100, unbewertet (geliefert nicht bezahlt, ohne Preis)
# Art4 = 100, direkt (bezahlt)

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "0efall21"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "1efall21"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "2efall21"
Then field "bestand" has value "100" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "3efall21"
Then field "bestand" has value "100" in row 0
And I save the current editor
And I close the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "4efall21"
Then field "bestand" has value "100" in row 0
And I save the current editor
And I close the current editor

#
# * Artikel mit Beistellteilen einkaufen
# Art0 einkaufen 100 Stk
Given I open an editor "LS0_101" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-0"
And I set field "num4" to "21_0ls1"
And I set field "such" to "LS0_101"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# Rechnung aus Lieferschein
Given I open an editor "RE0_101" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS0_101"
And I set field "num4" to "21_0re1"
And I set field "such" to "RE0_101"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

#
# * Art1 (80 Stk) bestellen: BE11
# Art1 liefern: LS1_101 20 Stk
# Art1 liefern: LS1_102 20 Stk
# Art1 liefern: LS1_103 20 Stk
# Art1 liefern: LS1_104 20 Stk
Given I open an editor "LS1_101" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "21_1ls1"
And I set field "such" to "LS1_101"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS1_102" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "21_1ls2"
And I set field "such" to "LS1_102"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS1_103" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "21_1ls3"
And I set field "such" to "LS1_103"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "LS1_104" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "21_1ls4"
And I set field "such" to "LS1_104"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

#
# * ===== Bezahlen  =======
# Art1 : 
# LS1_101 -> RE1_101
# LS1_102 -> RE1_102
# LS1_103 -> RE1_103
# Rechnung aus Lieferschein
Given I open an editor "RE1_101" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS1_101"
And I set field "num4" to "21_1re1"
And I set field "such" to "RE1_101"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "artikel" has value "ART1-FALL21" in row 1
Then field "mge" has value "20" in row 1
Then field "preis" has value "1.00" in row 1
And I set field "preis" to "1.10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "RE1_102" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS1_102"
And I set field "num4" to "21_1re2"
And I set field "such" to "RE1_102"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "artikel" has value "ART1-FALL21" in row 1
Then field "mge" has value "20" in row 1
Then field "preis" has value "1.00" in row 1
And I set field "preis" to "1.20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "RE1_103" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS1_103"
And I set field "num4" to "21_1re3"
And I set field "such" to "RE1_103"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "artikel" has value "ART1-FALL21" in row 1
Then field "mge" has value "20" in row 1
Then field "preis" has value "1.00" in row 1
And I set field "preis" to "1.30" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

#
# * Art2
# LS2_101 -> RE2_101
# LS2_102 -> RE2_102
# LS2_103 -> RE2_103
# Rechnung aus Lieferschein
Given I open an editor "RE2_101" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS2_101"
And I set field "num4" to "21_2re1"
And I set field "such" to "RE2_101"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "RE2_102" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS2_102"
And I set field "num4" to "21_2re2"
And I set field "such" to "RE2_102"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "RE2_103" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS2_103"
And I set field "num4" to "21_2re3"
And I set field "such" to "RE2_103"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

#
# * Art3 (in umgekehrter Reihenfolge buchen)
# LS3_104 -> RE3_104
Given I open an editor "RE3_104" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS3_104"
And I set field "num4" to "21_3re4"
And I set field "such" to "RE3_104"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# LS3_103 -> RE3_103
Given I open an editor "RE3_103" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS3_103"
And I set field "num4" to "21_3re3"
And I set field "such" to "RE3_103"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# LS3_102 -> RE3_102
Given I open an editor "RE3_102" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS3_102"
And I set field "num4" to "21_3re2"
And I set field "such" to "RE3_102"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# LS3_101 -> RE3_101
Given I open an editor "RE3_101" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS3_101"
And I set field "num4" to "21_3re1"
And I set field "such" to "RE3_101"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# * Storno RE4_101a
# RE4_101a -> RE4_STOR
Given I open an editor "teilre-storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+21_4re1"
Then I set field "nummer" to "21_4sre1"
Then field "bem" is modifiable
And I set field "schlag" to "Preis ist falsch"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# * Pruefung: Bestand
# Art1 = -20
# Art2 = 0
# Art3 = 0
# Art4 = 0
# Art0 = 100
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "0efall21"
Then field "bestand" has value "100" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "1efall21"
Then field "bestand" has value "-20" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "2efall21"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "3efall21"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "4efall21"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor
#
# * Art1 Rest liefern:
# LS1_105 21 Stk
Given I open an editor "LS1_105" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "21_1ls5"
And I set field "such" to "LS1_105"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# LS1_105 -> RE1_105
Given I open an editor "RE1_105" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS1_105"
And I set field "num4" to "21_1re5"
And I set field "such" to "RE1_105"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "artikel" has value "ART1-FALL21" in row 1
Then field "mge" has value "20" in row 1
Then field "preis" has value "1.00" in row 1
And I set field "preis" to "1.50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# LS1_104 -> RE1_104
Given I open an editor "RE1_104" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS1_104"
And I set field "num4" to "21_1re4"
And I set field "such" to "RE1_104"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
Then field "artikel" has value "ART1-FALL21" in row 1
Then field "mge" has value "20" in row 1
Then field "preis" has value "1.00" in row 1
And I set field "preis" to "1.40" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# LS2_104 -> RE2_104
Given I open an editor "RE2_104" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS2_104"
And I set field "num4" to "21_2re4"
And I set field "such" to "RE2_104"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# * Kostenumlage auf RE4_102  50 EURO:
# SpedRE + KM
# Kostenumlage (110�)
# eine Versicherungsrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "003fa21"
And I set field "num4" to "21km"
And I set field "kenn" to "FALL-Beistellung;"
And I set field "such" to "KM21"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VERS" in row 1
And I set field "pwert" to "50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "21-KM"
And I set field "pos" to "$,,kopf^nummer=21km;art=VERS;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=21_2re4;artex=2efall21;mge=10;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# * LS4_101  30 Stk bezahlen
# LS4_101 -> RE4_101b
Given I open an editor "RE4_101b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS4_101"
And I set field "num4" to "21_2re4b"
And I set field "such" to "RE4_101b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#
# * Pruefung: Bestand
# Art1 = 0
# Art2 = 0
# Art3 = 0
# Art4 = 0
# Art0 = 100
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "0efall21"
Then field "bestand" has value "100" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "1efall21"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "2efall21"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "3efall21"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor
#
Given I open an editor "artikel" from table "(Part):(Product)" with command "VIEW" for record "4efall21"
Then field "bestand" has value "0" in row 0
And I save the current editor
And I close the current editor
###################################################################################################################

@FALL-Ueberwachung
Scenario: EK Rueklieferung + Storno von Artikel mit Beistellung; Ueberwachen; Testumgebung keine (bzw. 20 und 21)
#
# Beschreibung:
# =============
# In der Umgebung 20 wurde ein Szenario mit Ruecklieferung und Storno der Ruecklieferung realisiert.
# In der Umgebung 21 wurde der gleichen Szenario wie Umgebung 20 abgespielt, 
# nur Ruecklieferung und Storno der Ruecklieferung wurden ausgelassen.
# das Ergebnis bzw. der Endzustand der beiden Szenarien muss vergleichbar gleich sein!!!

# die Pruefung hier basiert sich auf den letzte lebendigen Bewertungen 
# zu den Artikel "ART1-FALL20" und "ART1-FALL21".
# Sie werden analysiert/verglichen:
#
#       Sie MUESSEN in grossen und ganzen GLEICH sein!!!
#
#
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=1efall20;@richtung=rückwärts;@maxtreffer=1"
Then field "nachfolger" is empty
Then field "gebuchtervorg" is not empty
Then field "beistellabgang" is not empty
Then field "artikel" has value "ART1-FALL20" in row 0
Then field "buart" has value "Abgang" in row 0
Then field "mge" has value "100" in row 0
Then field "bewpr" has value "1.3000" in row 0
Then table has values
	| tbewpr	| bewertet	| addkosten	| kart		| tmge	|
	| 1.1000	| direkt	| 0.0000	| Entnahme	| 20	|
	| 1.2000	| direkt	| 0.0000	| Entnahme	| 20	|
	| 1.3000	| direkt	| 0.0000	| Entnahme	| 20	|
	| 1.4000	| direkt	| 0.0000	| Entnahme	| 20	|
	| 1.5000	| direkt	| 0.0000	| Entnahme	| 20	|
And I close the current editor

Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=1efall21;@richtung=rückwärts;@maxtreffer=1"
Then field "nachfolger" is empty
Then field "gebuchtervorg" is not empty
Then field "beistellabgang" is not empty
Then field "artikel" has value "ART1-FALL21" in row 0
Then field "buart" has value "Abgang" in row 0
Then field "mge" has value "100" in row 0
Then field "bewpr" has value "1.3000" in row 0
Then table has values
	| tbewpr	| bewertet	| addkosten	| kart		| tmge	|
	| 1.1000	| direkt	| 0.0000	| Entnahme	| 20	|
	| 1.2000	| direkt	| 0.0000	| Entnahme	| 20	|
	| 1.3000	| direkt	| 0.0000	| Entnahme	| 20	|
	| 1.4000	| direkt	| 0.0000	| Entnahme	| 20	|
	| 1.5000	| direkt	| 0.0000	| Entnahme	| 20	|
And I close the current editor

