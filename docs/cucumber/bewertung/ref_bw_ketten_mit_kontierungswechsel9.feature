# *****************************************************************************
#  Name             : ref_bw_ketten_mit_kontierungswechsel9.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        : 
#  Funktion         : testet STORNO von EK-RE und MNB;
#                     Faelle, wo es zu Kontierungswechsel kommen kann
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#                    Testumgebung  1: Scenario: FALL-BW121; EK BE_LS.vorl_MNB.direkt_SMNB_TRE1_TRE2_STRE1       mit Verbuchung
#                    Testumgebung  2: Scenario: FALL-BW123; EK BE_LS.vorl_MNB.direkt_SMNB_TRE1_TRE2_STRE1_STRE2 mit Verbuchung
#                    * leer *
#                    Testumgebung  9: Scenario: FALL-BW133; EK BE_LS.vorl_MNB.direkt_SMNB                       mit Verbuchung
#                    Testumgebung 10: Scenario: FALL-BW140; EK BE_LS.unbew_MNB.vorl_TRE1_TRE2_STRE1             mit Verbuchung
#                    Testumgebung 11: Scenario: FALL-BW145; EK BE_LS.unbew_MNB.vorl_TRE1_SMNB_TRE2_STRE2        mit Verbuchung
#                    Testumgebung 12: Scenario: FALL-BW148; EK BE_LS.unbew_MNB.vorl_SMNB                        mit Verbuchung
#                    Testumgebung 13: Scenario: FALL-BW160; EK BE_LS.unbew_TRE1_MNB_SMNB_TRE2                   mit Verbuchung
#                    Testumgebung 14: Scenario: FALL-BW164; EK BE_LS.unbew_TRE1_MNB_TRE2_SMNB_STRE2             mit Verbuchung
#                    Testumgebung 15: Scenario: FALL-BW166; EK BE_LS.unbew_TRE1_TRE2_MNB_STRE1_SMNB             mit Verbuchung
#
# *****************************************************************************

@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "07.01.2002"


@FALL-BW121
Scenario: FALL-BW121; EK BE_LS.vorl_MNB.direkt_SMNB_TRE1_TRE2_STRE1 mit Verbuchung; Testumgebung 1

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "121" with Price "121.12" in the Area "1"


# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "121" in the Area "1"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "121" in the Area "1"


# Mengenneubewertung
Given I open an editor "mnb-121" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-121"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L121-LS;art=0efall1;buart=1;mge=121;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "121" in the Area "1"

# Storno-Mengenneubewertung
Given I open an editor "mnb-121" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-121"
And I set field "such" to "SMNB-121"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "121" in the Area "1"

# Teil-Rechnung1 mit Menge 81 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "121" with Quantity "81" per Price "60.00" to the PurchasingPackingSlip in the Area "1"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "121" in the Area "1"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "121" with Quantity "40" per Price "" to the PurchasingPackingSlip in the Area "1"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "121" in the Area "1"

# Storno Teil-Rechnung 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+121-TRE1"
And I set field "num4" to "121-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "121" in the Area "1"
#####################################################################################################################################

@FALL-BW123
Scenario: FALL-BW123; EK BE_LS.vorl_MNB.direkt_SMNB_TRE1_TRE2_STRE1_STRE2 mit Verbuchung; Testumgebung 2

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "123" with Price "123.10" in the Area "2"


# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "123" in the Area "2"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "123" in the Area "2"

# Mengenneubewertung
Given I open an editor "mnb-123" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-123"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L123-LS;art=0efall2;buart=1;mge=123;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "123" in the Area "2"

# Storno-Mengenneubewertung
Given I open an editor "mnb-123" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-123"
And I set field "such" to "SMNB-123"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "123" in the Area "2"

# Teil-Rechnung1 mit Menge 83 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "123" with Quantity "83" per Price "60.00" to the PurchasingPackingSlip in the Area "2"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "123" in the Area "2"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "123" with Quantity "40" per Price "" to the PurchasingPackingSlip in the Area "2"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "123" in the Area "2"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+123-TRE1"
And I set field "num4" to "123-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "123" in the Area "2"

# Storno Teil-Rechnung2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+123-TRE2"
And I set field "num4" to "123-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "123" in the Area "2"
#####################################################################################################################################

@FALL-BW133
Scenario: FALL-BW133; EK BE_LS.vorl_MNB.direkt_SMNB mit Verbuchung; Testumgebung 9

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "133" with Price "133.10" in the Area "9"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "133" in the Area "9"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "133" in the Area "9"

# Mengenneubewertung
Given I open an editor "mnb-133" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-133"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L133-LS;art=0efall9;buart=1;mge=133;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "133" in the Area "9"

# Storno-Mengenneubewertung
Given I open an editor "mnb-133" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-133"
And I set field "such" to "SMNB-133"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "133" in the Area "9"
#####################################################################################################################################

@FALL-BW140
Scenario: FALL-BW140; EK BE_LS.unbew_MNB.vorl_TRE1_TRE2_STRE1 mit Verbuchung; Testumgebung 10

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "140" with Price "0.00" in the Area "10"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "140" in the Area "10"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "140" in the Area "10"

# Mengenneubewertung
Given I open an editor "mnb-140" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-140"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L140-LS;art=0efall10;buart=1;mge=140;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "33" in row 1
And I set field "nbewertet" to "vorl" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "140" in the Area "10"

# Teil-Rechnung1 mit Menge 100 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "140" with Quantity "100" per Price "60.00" to the PurchasingPackingSlip in the Area "10"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "140" in the Area "10"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "140" with Quantity "40" per Price "140.14" to the PurchasingPackingSlip in the Area "10"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "140" in the Area "10"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+140-TRE1"
And I set field "num4" to "140-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "140" in the Area "10"
#####################################################################################################################################

@FALL-BW145
Scenario: FALL-BW145; EK BE_LS.unbew_MNB.vorl_TRE1_SMNB_TRE2_STRE2 mit Verbuchung; Testumgebung 11

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "145" with Price "0.00" in the Area "11"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "145" in the Area "11"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "145" in the Area "11"

# Mengenneubewertung
Given I open an editor "mnb-145" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-145"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L145-LS;art=0efall11;buart=1;mge=145;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "33" in row 1
And I set field "nbewertet" to "vorl" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "145" in the Area "11"

# Teil-Rechnung1 mit Menge 105 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "145" with Quantity "105" per Price "60.00" to the PurchasingPackingSlip in the Area "11"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "145" in the Area "11"

# Storno-Mengenneubewertung
Given I open an editor "mnb-145" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-145"
And I set field "such" to "SMNB-145"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "145" in the Area "11"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "145" with Quantity "40" per Price "145.14" to the PurchasingPackingSlip in the Area "11"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "145" in the Area "11"

# Storno Teil-Rechnung2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+145-TRE2"
And I set field "num4" to "145-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "145" in the Area "11"
###################################################################################################################################

@FALL-BW148
Scenario: FALL-BW148; EK BE_LS.unbew_MNB.vorl_SMNB mit Verbuchung; Testumgebung 12

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "148" with Price "0.00" in the Area "12"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "148" in the Area "12"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "148" in the Area "12"

# Mengenneubewertung
Given I open an editor "mnb-148" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-148"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L148-LS;art=0efall12;buart=1;mge=148;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "33" in row 1
And I set field "nbewertet" to "vorl" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "148" in the Area "12"

# Storno-Mengenneubewertung
Given I open an editor "mnb-148" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-148"
And I set field "such" to "SMNB-148"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "148" in the Area "12"
#####################################################################################################################################

@FALL-BW160
Scenario: FALL-BW160; EK BE_LS.unbew_TRE1_MNB_SMNB_TRE2 mit Verbuchung; Testumgebung 13

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "160" with Price "0.00" in the Area "13"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "160" in the Area "13"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "160" in the Area "13"

# Teil-Rechnung1 mit Menge 120 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "160" with Quantity "120" per Price "60.00" to the PurchasingPackingSlip in the Area "13"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "160" in the Area "13"

# Mengenneubewertung
Given I open an editor "mnb-160" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-160"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L160-LS;art=0efall13;buart=1;mge=160;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "33" in row 1
And I set field "ntbewpr" to "55" in row 2
And I set field "nbewertet" to "vorl" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "160" in the Area "13"

# Storno-Mengenneubewertung
Given I open an editor "mnb-160" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-160"
And I set field "such" to "SMNB-160"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "160" in the Area "13"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "160" with Quantity "40" per Price "160.16" to the PurchasingPackingSlip in the Area "13"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "160" in the Area "13"
#####################################################################################################################################

@FALL-BW164
Scenario: FALL-BW164; EK BE_LS.unbew_TRE1_MNB_TRE2_SMNB_STRE2 mit Verbuchung; Testumgebung 14

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "164" with Price "0.00" in the Area "14"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "164" in the Area "14"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "164" in the Area "14"

# Teil-Rechnung1 mit Menge 124 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "164" with Quantity "124" per Price "60.00" to the PurchasingPackingSlip in the Area "14"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "164" in the Area "14"

# Mengenneubewertung
Given I open an editor "mnb-164" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-164"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L164-LS;art=0efall14;buart=1;mge=164;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "33" in row 1
And I set field "ntbewpr" to "55" in row 2
And I set field "nbewertet" to "vorl" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "164" in the Area "14"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "164" with Quantity "40" per Price "164.14" to the PurchasingPackingSlip in the Area "14"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "164" in the Area "14"

# Storno-Mengenneubewertung
Given I open an editor "mnb-164" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-164"
And I set field "such" to "SMNB-164"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "164" in the Area "14"

# Storno Teil-Rechnung2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+164-TRE2"
And I set field "num4" to "164-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "164" in the Area "14"
###################################################################################################################################

@FALL-BW166
Scenario: FALL-BW166; EK BE_LS.unbew_TRE1_TRE2_MNB_STRE2.fehler_SMNB_STRE1 mit Verbuchung; Testumgebung 15

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "166" with Price "0.00" in the Area "15"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "166" in the Area "15"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "166" in the Area "15"

# Teil-Rechnung1 mit Menge 126 und Preis 60.00 anlegen
Given I create an invoice for the Test Case "166" with Quantity "126" per Price "60.00" to the PurchasingPackingSlip in the Area "15"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "166" in the Area "15"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I create an invoice for the Test Case "166" with Quantity "40" per Price "166.14" to the PurchasingPackingSlip in the Area "15"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "166" in the Area "15"

# Mengenneubewertung
Given I open an editor "mnb-166" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-166"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L166-LS;art=0efall15;buart=1;mge=166;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "33" in row 1
And I set field "ntbewpr" to "55" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "166" in the Area "15"

# Storno Teil-Rechnung2
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung" throws the exception "3335"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "166" in the Area "15"

# Storno-Mengenneubewertung
Given I open an editor "mnb-166" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-166"
And I set field "such" to "SMNB-166"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "166" in the Area "15"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+166-TRE1"
And I set field "num4" to "166-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "166" in the Area "15"
###################################################################################################################################
