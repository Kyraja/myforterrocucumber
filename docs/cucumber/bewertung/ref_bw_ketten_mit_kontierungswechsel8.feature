# *****************************************************************************
#  Name             : ref_bw_ketten_mit_kontierungswechsel8.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        : 
#  Funktion         : testet STORNO von EK-RE und MNB;
#                     Faelle, wo es zu Kontierungswechsel kommen kann
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#                    Testumgebung 40: Scenario: FALL-BW94b;  EK BE_LS.vorl_MNB.vorl_TRE1_TRE2_SMNB             mit Verbuchung
#                    Testumgebung 41: Scenario: FALL-BW95b;  EK BE_LS.vorl_MNB.vorl_TRE1_TRE2_SMNB_STRE1       mit Verbuchung
#                    Testumgebung 42: Scenario: FALL-BW100b; EK BE_LS.vorl_MNB.vorl_TRE1_TRE2_STRE1_STRE2_SMNB mit Verbuchung
#                    Testumgebung 43: Scenario: FALL-BW104b; EK BE_LS.vorl_MNB.vorl_TRE1_SMNB_TRE2             mit Verbuchung
#                    Testumgebung 44: Scenario: FALL-BW106b; EK BE_LS.vorl_MNB.vorl_TRE1_STRE1                 mit Verbuchung
#                    Testumgebung 45: Scenario: FALL-BW108b; EK BE_LS.vorl_MNB.vorl_TRE1_TRE2_SMNB_STRE1       mit Verbuchung
#
# *****************************************************************************
@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "07.01.2002"



# 



@FALL-BW94b
Scenario: FALL-BW94b; EK BE_LS.vorl_MNB.vorl_TRE1_TRE2_SMNB mit Verbuchung; Testumgebung 40

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa40"
And I set field "num4" to "94b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall40" in row 1
And I set field "mge" to "94" in row 1
And I set field "preis" to "94.94" in row 1
And I set field "kenn" to "FALL-BW94b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "94b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "94" in row 1
And I set field "kenn" to "FALL-BW94b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "94" in the Area "40"

# Mengenneubewertung
Given I open an editor "mnb-94b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-94b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L94b-LS;art=0efall40;buart=1;mge=94;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "94" in the Area "40"

# Teil-Rechnung1 mit Menge 54 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "94b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "54" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW94b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "94" in the Area "40"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "94b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW94b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "94" in the Area "40"

# Storno-Mengenneubewertung
Given I open an editor "mnb-94" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-94b"
And I set field "such" to "SMNB-94b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "94" in the Area "40"
#####################################################################################################################################

@FALL-BW95b
Scenario: FALL-BW95b; EK BE_LS.vorl_MNB.vorl_TRE1_TRE2_SMNB_STRE1 mit Verbuchung; Testumgebung 41

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa41"
And I set field "num4" to "95b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall41" in row 1
And I set field "mge" to "95" in row 1
And I set field "preis" to "95.95" in row 1
And I set field "kenn" to "FALL-BW95b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "95b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "95" in row 1
And I set field "kenn" to "FALL-BW95b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "95" in the Area "41"

# Mengenneubewertung
Given I open an editor "mnb-95b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-95b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L95b-LS;art=0efall41;buart=1;mge=95;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "111" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "95" in the Area "41"

# Teil-Rechnung1 mit Menge 55 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "95b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW95b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "95" in the Area "41"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "95b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW95b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "95" in the Area "41"

# Storno-Mengenneubewertung
Given I open an editor "mnb-95" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-95b"
And I set field "such" to "SMNB-95b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "95" in the Area "41"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+95b-TRE1"
And I set field "num4" to "95b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "95" in the Area "41"
#####################################################################################################################################

@FALL-BW100b
Scenario: FALL-BW100b; EK BE_LS.vorl_MNB.vorl_TRE1_TRE2_STRE1_STRE2_SMNB mit Verbuchung; Testumgebung 42

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa42"
And I set field "num4" to "100-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall42" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "100.10" in row 1
And I set field "kenn" to "FALL-BW100b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "100-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-BW100b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "100" in the Area "42"

# Mengenneubewertung
Given I open an editor "mnb-100b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-100b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L100-LS;art=0efall42;buart=1;mge=100;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "33" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "100" in the Area "42"

# Teil-Rechnung1 mit Menge 60 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "100-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "60" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW100b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "100" in the Area "42"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "100-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW100b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "100" in the Area "42"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+100-TRE1"
And I set field "num4" to "100-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "100" in the Area "42"

# Storno Teil-Rechnung2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+100-TRE2"
And I set field "num4" to "100-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "100" in the Area "42"

# Storno-Mengenneubewertung
Given I open an editor "mnb-100" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-100b"
And I set field "such" to "SMNB-100b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "100" in the Area "42"
#####################################################################################################################################

@FALL-BW104b
Scenario: FALL-BW104b; EK BE_LS.vorl_MNB.vorl_TRE1_SMNB_TRE2 mit Verbuchung; Testumgebung 43

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa43"
And I set field "num4" to "104-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall43" in row 1
And I set field "mge" to "104" in row 1
And I set field "preis" to "104.14" in row 1
And I set field "kenn" to "FALL-BW104b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "104-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "104" in row 1
And I set field "kenn" to "FALL-BW104b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "104" in the Area "43"

# Mengenneubewertung
Given I open an editor "mnb-104b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-104b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L104-LS;art=0efall43;buart=1;mge=104;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "33" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "104" in the Area "43"

# Teil-Rechnung1 mit Menge 64 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "104-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "64" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW104b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "104" in the Area "43"

# Storno-Mengenneubewertung
Given I open an editor "mnb-104" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-104b"
And I set field "such" to "SMNB-104b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "104" in the Area "43"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "104-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW104b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "104" in the Area "43"
#####################################################################################################################################

@FALL-BW106b
Scenario: FALL-BW106b; EK BE_LS.vorl_MNB.vorl_TRE1_STRE1 mit Verbuchung; Testumgebung 44

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa44"
And I set field "num4" to "106-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall44" in row 1
And I set field "mge" to "106" in row 1
And I set field "preis" to "106.16" in row 1
And I set field "kenn" to "FALL-BW106b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "106-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "106" in row 1
And I set field "kenn" to "FALL-BW106b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "106" in the Area "44"

# Mengenneubewertung
Given I open an editor "mnb-106b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-106b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L106-LS;art=0efall44;buart=1;mge=106;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "33" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "106" in the Area "44"

# Teil-Rechnung1 mit Menge 66 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "106-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "66" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW106b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "106" in the Area "44"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+106-TRE1"
And I set field "num4" to "106-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "106" in the Area "44"
#####################################################################################################################################

@FALL-BW108b
Scenario: FALL-BW108b; EK BE_LS.vorl_MNB.vorl_TRE1_TRE2_SMNB_STRE1 mit Verbuchung; Testumgebung 45

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa45"
And I set field "num4" to "108b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall45" in row 1
And I set field "mge" to "108" in row 1
And I set field "preis" to "108.18" in row 1
And I set field "kenn" to "FALL-BW108b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "108-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "108" in row 1
And I set field "kenn" to "FALL-BW108b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "108" in the Area "45"

# Mengenneubewertung
Given I open an editor "mnb-108b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-108b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L108-LS;art=0efall45;buart=1;mge=108;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "8.88" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "108" in the Area "45"

# Storno-Mengenneubewertung
Given I open an editor "mnb-108" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-108b"
And I set field "such" to "SMNB-108b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "108" in the Area "45"

# Teil-Rechnung1 mit Menge 68 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "108-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "68" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW108b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "108" in the Area "45"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "108-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW108b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "108" in the Area "45"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+108-TRE1"
And I set field "num4" to "108-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "108" in the Area "45"
#####################################################################################################################################
