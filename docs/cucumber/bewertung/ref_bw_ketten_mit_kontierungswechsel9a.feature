# *****************************************************************************
#  Name             : ref_bw_ketten_mit_kontierungswechsel9a.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        : 
#  Funktion         : testet STORNO von EK-RE und MNB;
#                     Faelle, wo es zu Kontierungswechsel kommen kann
#
#   kurze Zusammenfassung von Bewertungsketten:
#   ===========================================
#   Testumgebung 25: Scenario: FALL-BW200; EK/VK BE_LS.vorl_TRE1_TRE2_VKRE.mitLB_PMNB_STRE1                             mit Verbuchung
#   Testumgebung 26: Scenario: FALL-BW208; EK/VK BE_LS.vorl_TRE1_TRE2_VKRE.mitLB_PMNB_SPMNB_STRE1                       mit Verbuchung
#   Testumgebung 27: Scenario: FALL-BW210; EK/VK BE_LS.vorl_TRE1_TRE2_VKRE.mitLB_PMNB_SPMNB_STRE1_STRE2_SVKRE.mitLB_SLS mit Verbuchung
#   * leer *
#   Testumgebung 30: Scenario: FALL-BW233; EK/VK BE_LS.vorl_TRE1_VKRE.mitLB_PMNB_TRE2_STRE2_SPMNB_STRE1                 mit Verbuchung
#   Testumgebung 31: Scenario: FALL-BW234; EK/VK BE_LS.vorl_TRE1_VKRE.mitLB_PMNB_TRE2_STRE2_SPMNB_STRE1                 mit Verbuchung
#   Testumgebung 32: Scenario: FALL-BW246; EK/VK BE_LS.vorl_TRE1_VKRE.mitLB_TRE2_PMNB_SPMNB_STRE2_STRE1                 mit Verbuchung
#   Testumgebung 33: Scenario: FALL-BW247; EK/VK BE_LS.vorl_TRE1_VKRE.mitLB_TRE2_PMNB_SPMNB_STRE2_STRE1                 mit Verbuchung
#   Testumgebung 34: Scenario: FALL-BW271; EK/VK BE_LS.vorl_VKRE.mitLB_PMNB_TRE1_STRE1_SPMNB                            mit Verbuchung
#   Testumgebung 35: Scenario: FALL-BW278; EK/VK BE_LS.vorl_VKRE.mitLB_PMNB_TRE1_TRE2_STRE1_STRE2_SPMNB                 mit Verbuchung
#   Testumgebung 36: Scenario: FALL-BW279; EK/VK BE_LS.vorl_VKRE.mitLB_PMNB_TRE1_TRE2_STRE1_STRE2_SPMNB                 mit Verbuchung
#
# *****************************************************************************

@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "07.01.2002"


@FALL-BW200
Scenario: FALL-BW200; EK/VK BE_LS.vorl_TRE1_TRE2_VKRE.mitLB_PMNB_STRE2.fehler mit Verbuchung; Testumgebung 25

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "200" with Price "200.12" in the Area "25"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "200" in the Area "25"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "25"

# Teil-Rechnung1 mit Menge 160 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "200" with Quantity "160" per Price "60.00" to the PurchasingPackingSlip in the Area "25"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "25"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "200" with Quantity "40" per Price "" to the PurchasingPackingSlip in the Area "25"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "25"

# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "vk-rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "200-RE"
And I set field "kunde" to "001fa25"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BW200"
And I create a new row at the end of the table
And I set field "artikel" to "0efall25" in row 1
And I set field "mge" to "180" in row 1
And I set field "preis" to "233.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "25" with Command Revalue

# Mengenneubewertung
Given I open an editor "mnb-200" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-200"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,artikel=0efall25;platz==F1;@datei=40;@gruppe=4;@ablage=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1

And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "25" with Command Revalue

# Storno Teil-Rechnung 2 -> Fehler
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung" throws the exception "3335"
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "25" with Command Revalue
#####################################################################################################################################

@FALL-BW208
Scenario: FALL-BW208; EK/VK BE_LS.vorl_TRE1_TRE2_VKRE.mitLB_PMNB_SPMNB_STRE1 mit Verbuchung; Testumgebung 26

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "208" with Price "208.12" in the Area "26"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "208" in the Area "26"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "208" in the Area "26"

# Teil-Rechnung1 mit Menge 168 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "208" with Quantity "168" per Price "60.00" to the PurchasingPackingSlip in the Area "26"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "208" in the Area "26"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "208" with Quantity "40" per Price "" to the PurchasingPackingSlip in the Area "26"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "208" in the Area "26"

# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "208-VRE"
And I set field "kunde" to "001fa26"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BW208"
And I create a new row at the end of the table
And I set field "artikel" to "0efall26" in row 1
And I set field "mge" to "180" in row 1
And I set field "preis" to "233.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "208" in the Area "26" with Command Revalue

# Mengenneubewertung
Given I open an editor "mnb-208" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-208"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,artikel=0efall26;platz==F1;@datei=40;@gruppe=4;@ablage=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "208" in the Area "26" with Command Revalue

# Storno-Mengenneubewertung
Given I open an editor "mnb-208" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-208"
And I set field "such" to "SMNB-208"
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "208" in the Area "26" with Command Revalue

# Storno Teil-Rechnung 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+208-TRE1"
And I set field "num4" to "208-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "208" in the Area "26" with Command Revalue
#####################################################################################################################################

@FALL-BW210
Scenario: FALL-BW210; EK/VK BE_LS.vorl_TRE1_TRE2_VKRE.mitLB_PMNB_SPMNB_STRE1_STRE2_SVKRE.mitLB_SLS mit Verbuchung; Testumgebung 27

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "210" with Price "210.12" in the Area "27"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "210" in the Area "27"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "210" in the Area "27"

# Teil-Rechnung1 mit Menge 170 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "210" with Quantity "170" per Price "60.00" to the PurchasingPackingSlip in the Area "27"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "210" in the Area "27"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "210" with Quantity "40" per Price "" to the PurchasingPackingSlip in the Area "27"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "210" in the Area "27"

# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "210-RE"
And I set field "kunde" to "001fa27"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BW210"
And I create a new row at the end of the table
And I set field "artikel" to "0efall27" in row 1
And I set field "mge" to "180" in row 1
And I set field "preis" to "233.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "210" in the Area "27" with Command Revalue

# Mengenneubewertung
Given I open an editor "mnb-210" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-210"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,artikel=0efall27;platz==F1;@datei=40;@gruppe=4;@ablage=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "210" in the Area "27" with Command Revalue

# Storno-Mengenneubewertung
Given I open an editor "mnb-210" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-210"
And I set field "such" to "SMNB-210"
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "210" in the Area "27" with Command Revalue

# Storno Teil-Rechnung 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+210-TRE1"
And I set field "num4" to "210-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "210" in the Area "27" with Command Revalue

# Storno Teil-Rechnung 2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+210-TRE2"
And I set field "num4" to "210-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "210" in the Area "27" with Command Revalue

# Storno VerkaufsRechnung
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+210-RE"
And I set field "num3" to "210-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "210" in the Area "27" with Command Revalue

# Storno-Lieferschein
Given I open an editor "slieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "210-LS"
And I set field "num4" to "210-STLS"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "210" in the Area "27" with Command Revalue
####################################################################################################################################

@FALL-BW233
Scenario: FALL-BW233; EK/VK BE_LS.vorl_TRE1_VKRE.mitLB_PMNB_TRE2_STRE2_SPMNB_STRE1 mit Verbuchung; Testumgebung 30

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "233" with Price "233.12" in the Area "30"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "233" in the Area "30"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "233" in the Area "30"

# Teil-Rechnung1 mit Menge 193 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "233" with Quantity "193" per Price "60.00" to the PurchasingPackingSlip in the Area "30"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "233" in the Area "30"

# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "233-RE"
And I set field "kunde" to "001fa30"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BW233"
And I create a new row at the end of the table
And I set field "artikel" to "0efall30" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "233.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "233" in the Area "30" with Command Revalue

# Mengenneubewertung
Given I open an editor "mnb-233" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-233"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,artikel=0efall30;platz==F1;@datei=40;@gruppe=4;@ablage=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "233" in the Area "30" with Command Revalue

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "233" with Quantity "40" per Price "" to the PurchasingPackingSlip in the Area "30"

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "233" in the Area "30" with Command Revalue

# Storno Teil-Rechnung 2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+233-TRE2"
And I set field "num4" to "233-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "233" in the Area "30" with Command Revalue

# Storno-Mengenneubewertung
Given I open an editor "mnb-233" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-233"
And I set field "such" to "SMNB-233"
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "233" in the Area "30" with Command Revalue

# Storno Teil-Rechnung 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+233-TRE1"
And I set field "num4" to "233-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "233" in the Area "30" with Command Revalue
#####################################################################################################################################

@FALL-BW234
Scenario: FALL-BW234; MNB betrifft beide Teilrechnungen; EK/VK BE_LS.vorl_TRE1_VKRE.mitLB_PMNB_TRE2_STRE2_SPMNB_STRE1 mit Verbuchung; Testumgebung 31
# Kopie von FALL-BW233; hier betrifft die MNB die beiden TeilRechnung bzw. Mengen aus Teilrechnungen aus Einkauf

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "234" with Price "234.12" in the Area "31"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "234" in the Area "31"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "234" in the Area "31"

# Teil-Rechnung1 mit Menge 193 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "234" with Quantity "193" per Price "60.00" to the PurchasingPackingSlip in the Area "31"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "234" in the Area "31"

# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "234-RE"
And I set field "kunde" to "001fa31"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BW234"
And I create a new row at the end of the table
And I set field "artikel" to "0efall31" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "234.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "234" in the Area "31" with Command Revalue

# Mengenneubewertung
Given I open an editor "mnb-234" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-234"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,artikel=0efall31;platz==F1;@datei=40;@gruppe=4;@ablage=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "234" in the Area "31" with Command Revalue

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "234" with Quantity "40" per Price "" to the PurchasingPackingSlip in the Area "31"

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "234" in the Area "31" with Command Revalue

# Storno Teil-Rechnung 2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+234-TRE2"
And I set field "num4" to "234-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "234" in the Area "31" with Command Revalue

# Storno-Mengenneubewertung
Given I open an editor "mnb-234" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-234"
And I set field "such" to "SMNB-234"
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "234" in the Area "31" with Command Revalue

# Storno Teil-Rechnung 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+234-TRE1"
And I set field "num4" to "234-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "234" in the Area "31" with Command Revalue
##################################################################################################################################

@FALL-BW246
Scenario: FALL-BW246; EK/VK BE_LS.vorl_TRE1_VKRE.mitLB_TRE2_PMNB_SPMNB_STRE2_STRE1 mit Verbuchung; Testumgebung 32

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "246" with Price "246.12" in the Area "32"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "246" in the Area "32"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "246" in the Area "32"

# Teil-Rechnung1 mit Menge 206 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "246" with Quantity "206" per Price "60.00" to the PurchasingPackingSlip in the Area "32"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "246" in the Area "32"

# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "246-RE"
And I set field "kunde" to "001fa32"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BW246"
And I create a new row at the end of the table
And I set field "artikel" to "0efall32" in row 1
And I set field "mge" to "215" in row 1
And I set field "preis" to "270.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "246" in the Area "32" with Command Revalue

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "246" with Quantity "40" per Price "" to the PurchasingPackingSlip in the Area "32"

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "246" in the Area "32" with Command Revalue

# Mengenneubewertung
Given I open an editor "mnb-246" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-246"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,artikel=0efall32;platz==F1;@datei=40;@gruppe=4;@ablage=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "246" in the Area "32" with Command Revalue

# Storno-Mengenneubewertung
Given I open an editor "mnb-246" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-246"
And I set field "such" to "SMNB-246"
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "246" in the Area "32" with Command Revalue

# Storno Teil-Rechnung 2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+246-TRE2"
And I set field "num4" to "246-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "246" in the Area "32" with Command Revalue

# Storno Teil-Rechnung 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+246-TRE1"
And I set field "num4" to "246-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "246" in the Area "32" with Command Revalue
#####################################################################################################################################

@FALL-BW247
Scenario: FALL-BW247; MNB betrifft beide Teilrechnungen; EK/VK BE_LS.vorl_TRE1_VKRE.mitLB_TRE2_PMNB_SPMNB_STRE2_STRE1 mit Verbuchung; Testumgebung 33
# Kopie von @FALL-BW246; hier betrifft die MNB die beiden TeilRechnung bzw. Mengen aus Teilrechnungen aus Einkauf


# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "247" with Price "247.12" in the Area "33"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "247" in the Area "33"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "247" in the Area "33"

# Teil-Rechnung1 mit Menge 206 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "247" with Quantity "207" per Price "60.00" to the PurchasingPackingSlip in the Area "33"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "247" in the Area "33"

# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "247-RE"
And I set field "kunde" to "001fa33"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BW247"
And I create a new row at the end of the table
And I set field "artikel" to "0efall33" in row 1
And I set field "mge" to "23" in row 1
And I set field "preis" to "270.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "247" in the Area "33" with Command Revalue

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "247" with Quantity "40" per Price "" to the PurchasingPackingSlip in the Area "33"

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "247" in the Area "33" with Command Revalue

# Mengenneubewertung
Given I open an editor "mnb-247" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-247"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,artikel=0efall33;platz==F1;@datei=40;@gruppe=4;@ablage=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "247" in the Area "33" with Command Revalue

# Storno-Mengenneubewertung
Given I open an editor "mnb-247" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-247"
And I set field "such" to "SMNB-247"
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "247" in the Area "33" with Command Revalue

# Storno Teil-Rechnung 2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+247-TRE2"
And I set field "num4" to "247-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "247" in the Area "33" with Command Revalue

# Storno Teil-Rechnung 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+247-TRE1"
And I set field "num4" to "247-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "247" in the Area "33" with Command Revalue
##################################################################################################################################

@FALL-BW271
Scenario: FALL-BW271; EK/VK BE_LS.vorl_VKRE.mitLB_PMNB_TRE1_STRE1_SPMNB mit Verbuchung; Testumgebung 34

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "271" with Price "271.12" in the Area "34"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "271" in the Area "34"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "271" in the Area "34"

# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "271-RE"
And I set field "kunde" to "001fa34"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BW271"
And I create a new row at the end of the table
And I set field "artikel" to "0efall34" in row 1
And I set field "mge" to "250" in row 1
And I set field "preis" to "370.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "271" in the Area "34" with Command Revalue

# Mengenneubewertung
Given I open an editor "mnb-271" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-271"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,artikel=0efall34;platz==F1;@datei=40;@gruppe=4;@ablage=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "271" in the Area "34" with Command Revalue

# Teil-Rechnung1 mit Menge 231 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "271" with Quantity "231" per Price "60.00" to the PurchasingPackingSlip in the Area "34"

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "271" in the Area "34" with Command Revalue

# Storno Teil-Rechnung 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+271-TRE1"
And I set field "num4" to "271-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "271" in the Area "34" with Command Revalue

# Storno-Mengenneubewertung
Given I open an editor "mnb-271" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-271"
And I set field "such" to "SMNB-271"
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "271" in the Area "34" with Command Revalue
#####################################################################################################################################

@FALL-BW278
Scenario: FALL-BW278; EK/VK BE_LS.vorl_VKRE.mitLB_PMNB_TRE1_TRE2_STRE1_STRE2_SPMNB mit Verbuchung; Testumgebung 35

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "278" with Price "278.12" in the Area "35"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "278" in the Area "35"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "278" in the Area "35"

# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "278-RE"
And I set field "kunde" to "001fa35"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BW278"
And I create a new row at the end of the table
And I set field "artikel" to "0efall35" in row 1
And I set field "mge" to "250" in row 1
And I set field "preis" to "333.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "278" in the Area "35" with Command Revalue

# Mengenneubewertung
Given I open an editor "mnb-278" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-278"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,artikel=0efall35;platz==F1;@datei=40;@gruppe=4;@ablage=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "278" in the Area "35" with Command Revalue

# Teil-Rechnung1 mit Menge 238 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "278" with Quantity "238" per Price "60.00" to the PurchasingPackingSlip in the Area "35"

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "278" in the Area "35" with Command Revalue

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "278" with Quantity "40" per Price "" to the PurchasingPackingSlip in the Area "35"

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "278" in the Area "35" with Command Revalue

# Storno Teil-Rechnung 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+278-TRE1"
And I set field "num4" to "278-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "278" in the Area "35" with Command Revalue

# Storno Teil-Rechnung 2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+278-TRE2"
And I set field "num4" to "278-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "278" in the Area "35" with Command Revalue

# Storno-Mengenneubewertung
Given I open an editor "mnb-278" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-278"
And I set field "such" to "SMNB-278"
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "278" in the Area "35" with Command Revalue
#####################################################################################################################################

@FALL-BW279
Scenario: FALL-BW279; EK/VK BE_LS.vorl_VKRE.mitLB_PMNB_TRE1_TRE2_STRE1_STRE2_SPMNB mit Verbuchung; Testumgebung 36
# Kopie von @FALL-BW279; hier betrifft die MNB die beiden TeilRechnung bzw. Mengen aus Teilrechnungen aus Einkauf


# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "279" with Price "279.12" in the Area "36"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "279" in the Area "36"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "279" in the Area "36"

# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "279-RE"
And I set field "kunde" to "001fa36"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BW279"
And I create a new row at the end of the table
And I set field "artikel" to "0efall36" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "333.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "279" in the Area "36" with Command Revalue

# Mengenneubewertung
Given I open an editor "mnb-279" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-279"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,artikel=0efall36;platz==F1;@datei=40;@gruppe=4;@ablage=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "279" in the Area "36" with Command Revalue

# Teil-Rechnung1 mit Menge 239 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "279" with Quantity "239" per Price "60.00" to the PurchasingPackingSlip in the Area "36"

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "279" in the Area "36" with Command Revalue

# Schluss-Rechnung mit Restmenge (Menge 40) anlegen
Given I create final invoice for testcase "279" per price "" to PurchasingPackingSlip in area "36"

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "279" in the Area "36" with Command Revalue

# Storno Teil-Rechnung 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+279-TRE1"
And I set field "num4" to "279-STRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "279" in the Area "36" with Command Revalue

# Storno der Schluss-Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+279-LRE"
And I set field "num4" to "279-SLRE"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "279" in the Area "36" with Command Revalue

# Storno-Mengenneubewertung
Given I open an editor "mnb-279" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-279"
And I set field "such" to "SMNB-279"
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "279" in the Area "36" with Command Revalue
#####################################################################################################################################
