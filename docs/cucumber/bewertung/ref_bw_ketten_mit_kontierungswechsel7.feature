# *****************************************************************************
#  Name             : ref_bw_ketten_mit_kontierungswechsel7.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        : 
#  Funktion         : testet STORNO von EK-RE(Teil-RE) und MNB;
#                     Faelle, wo es zu Kontierungswechsel kommen kann
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#                    Testumgebung 20: Scenario: FALL-BW67b; EK BE_LS.vorl_TRE1_TRE2_MNB_SMNB mit Verbuchung
#                    Testumgebung 21: Scenario: FALL-BW68b; EK BE_LS.vorl_TRE1_TRE2_MNB_SMNB_STRE1 mit Verbuchung
#                    Testumgebung 22: Scenario: FALL-BW69b; EK BE_LS.vorl_TRE1_TRE2_MNB_SMNB_STRE1_STRE2 mit Verbuchung
#                    Testumgebung 23: Scenario: FALL-BW70b; EK BE_LS.vorl_TRE1_TRE2_MNB_SMNB_STRE1_STRE2_SLS mit Verbuchung
#                    Testumgebung 24: Scenario: FALL-BW71b; EK BE_LS.vorl_TRE1_TRE2_MNB_STRE1.fehler_SMNB_STRE1 mit Verbuchung
#                    * leer *
#                    Testumgebung 30: Scenario: FALL-BW77b; EK BE_LS.vorl_TRE1_MNB_TRE2_SMNB mit Verbuchung
#                    Testumgebung 31: Scenario: FALL-BW78b; EK BE_LS.vorl_TRE1_MNB_TRE2_SMNB_STRE1 mit Verbuchung
#                    Testumgebung 32: Scenario: FALL-BW79b; EK BE_LS.vorl_TRE1_MNB_TRE2_SMNB_STRE1_STRE2 mit Verbuchung
#                    Testumgebung 33: Scenario: FALL-BW81b; EK BE_LS.vorl_TRE1_MNB_TRE2_STRE1.fehler_SMNB mit Verbuchung
#                    Testumgebung 34: Scenario: FALL-BW82b; EK BE_LS.vorl_TRE1_MNB_TRE2_STRE1.fehler_SMNB_STRE2_STRE1 mit Verbuchung
#                    * leer *
#                    Testumgebung 36: Scenario: FALL-BW86b; EK BE_LS.vorl_TRE1_MNB_TRE2_STRE2_SMNB_STRE1 mit Verbuchung
#                    Testumgebung 37: Scenario: FALL-BW87b; EK BE_LS.vorl_TRE1_MNB_TRE2_STRE2_SMNB  mit Verbuchung
#                    Testumgebung 38: Scenario: FALL-BW88b; EK BE_LS.vorl_TRE1_MNB_TRE2_STRE2 mit Verbuchung
#
# *****************************************************************************

@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "07.01.2002"


@FALL-BW67b
Scenario: FALL-BW67b; EK BE_LS.vorl_TRE1_TRE2_MNB_SMNB mit Verbuchung; Testumgebung 20

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa20"
And I set field "num4" to "67b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall20" in row 1
And I set field "mge" to "67" in row 1
And I set field "preis" to "67.67" in row 1
And I set field "kenn" to "FALL-BW67b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "67b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "67" in row 1
And I set field "kenn" to "FALL-BW67b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "67" in the Area "20"

# Teil-Rechnung1 mit Menge 27 und Preis 20.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "67b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "27" in row 1
And I set field "preis" to "20" in row 1
And I set field "kenn" to "FALL-BW67b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "67" in the Area "20"

# Teil-Rechnung2 mit Menge 40
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "67b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW67b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "67" in the Area "20"

# Mengenneubewertung
Given I open an editor "mnb-67b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-67b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L67b-LS;art=0efall20;buart=1;mge=67;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "100" in row 1
And I set field "ntbewpr" to "111" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "67" in the Area "20"

# Storno-Mengenneubewertung
Given I open an editor "mnb-67" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-67b"
And I set field "such" to "SMNB-67b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "67" in the Area "20"
#####################################################################################################################################

@FALL-BW68b
Scenario: FALL-BW68b; EK BE_LS.vorl_TRE1_TRE2_MNB_SMNB_STRE1 mit Verbuchung; Testumgebung 21

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa21"
And I set field "num4" to "68b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall21" in row 1
And I set field "mge" to "68" in row 1
And I set field "preis" to "68.68" in row 1
And I set field "kenn" to "FALL-BW68b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "68b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "68" in row 1
And I set field "kenn" to "FALL-BW68b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "68" in the Area "21"

# Teil-Rechnung1 mit Menge 28 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "68b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "28" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW68b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "68" in the Area "21"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "68b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "preis" to "68" in row 1
And I set field "kenn" to "FALL-BW68b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "68" in the Area "21"

# Mengenneubewertung
Given I open an editor "mnb-68b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-68b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L68b-LS;art=0efall21;buart=1;mge=68;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "118" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "68" in the Area "21"

# Storno-Mengenneubewertung
Given I open an editor "mnb-68" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-68b"
And I set field "such" to "SMNB-68b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "68" in the Area "21"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+68b-TRE1"
And I set field "num4" to "68b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "68" in the Area "21"
#####################################################################################################################################

@FALL-BW69b
Scenario: FALL-BW69b; EK BE_LS.vorl_TRE1_TRE2_MNB_SMNB_STRE1_STRE2 mit Verbuchung; Testumgebung 22

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa22"
And I set field "num4" to "69b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall22" in row 1
And I set field "mge" to "69" in row 1
And I set field "preis" to "69.69" in row 1
And I set field "kenn" to "FALL-BW69b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "69b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "69" in row 1
And I set field "kenn" to "FALL-BW69b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "69" in the Area "22"

# Teil-Rechnung1 mit Menge 28 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "69b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "28" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW69b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "69" in the Area "22"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "69b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW69b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "69" in the Area "22"

# Mengenneubewertung
Given I open an editor "mnb-69b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-69b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L69b-LS;art=0efall22;buart=1;mge=69;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "118" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "69" in the Area "22"

# Storno-Mengenneubewertung
Given I open an editor "mnb-69" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-69b"
And I set field "such" to "SMNB-69b"
And I save the current editor
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "69" in the Area "22"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+69b-TRE1"
And I set field "num4" to "69b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "69" in the Area "22"

# Storno Teil-Rechnung2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+69b-TRE2"
And I set field "num4" to "69b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "69" in the Area "22"
#####################################################################################################################################

@FALL-BW70b
Scenario: FALL-BW70b; EK BE_LS.vorl_TRE1_TRE2_MNB_SMNB_STRE1_STRE2_SLS mit Verbuchung; Testumgebung 23

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa23"
And I set field "num4" to "70b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall23" in row 1
And I set field "mge" to "70" in row 1
And I set field "preis" to "70.70" in row 1
And I set field "kenn" to "FALL-BW70b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "70b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "70" in row 1
And I set field "kenn" to "FALL-BW70b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "70" in the Area "23"

# Teil-Rechnung1 mit Menge 30 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "70b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW70b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "70" in the Area "23"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "70b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW70b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "70" in the Area "23"

# Mengenneubewertung
Given I open an editor "mnb-70b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-70b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L70b-LS;art=0efall23;buart=1;mge=70;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "118" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "70" in the Area "23"

# Storno-Mengenneubewertung
Given I open an editor "mnb-70" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-70b"
And I set field "such" to "SMNB-70b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "70" in the Area "23"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+70b-TRE1"
And I set field "num4" to "70b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "70" in the Area "23"

# Storno Teil-Rechnung2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+70b-TRE2"
And I set field "num4" to "70b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "70" in the Area "23"

# Storno-Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "70b-LS"
And I set field "num4" to "70b-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "70" in the Area "23"
#####################################################################################################################################

@FALL-BW71b
Scenario: FALL-BW71b; EK BE_LS.vorl_TRE1_TRE2_MNB_STRE1.fehler_SMNB_STRE1 mit Verbuchung; Testumgebung 24

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa24"
And I set field "num4" to "71b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall24" in row 1
And I set field "mge" to "71" in row 1
And I set field "preis" to "71.71" in row 1
And I set field "kenn" to "FALL-BW71b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "71b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "71" in row 1
And I set field "kenn" to "FALL-BW71b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "71" in the Area "24"

# Teil-Rechnung1 mit Menge 31 und Preis 60.00 anlegen
Given I open an editor "rechnung1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "71b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "31" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW71b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "71" in the Area "24"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "71b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW71b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "71" in the Area "24"

# Mengenneubewertung
Given I open an editor "mnb-71b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-71b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L71b-LS;art=0efall24;buart=1;mge=71;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "118" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "71" in the Area "24"

# Storno Teil-Rechnung1
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung1" throws the exception "3335"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "71" in the Area "24"

# Storno-Mengenneubewertung
Given I open an editor "mnb-71" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-71b"
And I set field "such" to "SMNB-71b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "71" in the Area "24"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+71b-TRE1"
And I set field "num4" to "71b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "71" in the Area "24"
#####################################################################################################################################

@FALL-BW77b
Scenario: FALL-BW77b; EK BE_LS.vorl_TRE1_MNB_TRE2_SMNB mit Verbuchung; Testumgebung 30

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa30"
And I set field "num4" to "77b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall30" in row 1
And I set field "mge" to "77" in row 1
And I set field "preis" to "77.77" in row 1
And I set field "kenn" to "FALL-BW77b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "77b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "77" in row 1
And I set field "kenn" to "FALL-BW77b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "77" in the Area "30"

# Teil-Rechnung1 mit Menge 37 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "77b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "37" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW77b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "77" in the Area "30"

# Mengenneubewertung
Given I open an editor "mnb-77b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-77b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L77b-LS;art=0efall30;buart=1;mge=77;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "111" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "77" in the Area "30"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "77b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW77b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "77" in the Area "30"

# Storno-Mengenneubewertung
Given I open an editor "mnb-77" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-77b"
And I set field "such" to "SMNB-77b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "77" in the Area "30"
#####################################################################################################################################

@FALL-BW78b
Scenario: FALL-BW78b; EK BE_LS.vorl_TRE1_MNB_TRE2_SMNB_STRE1 mit Verbuchung; Testumgebung 31

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa31"
And I set field "num4" to "78b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall31" in row 1
And I set field "mge" to "78" in row 1
And I set field "preis" to "78.78" in row 1
And I set field "kenn" to "FALL-BW78b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "78b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "78" in row 1
And I set field "kenn" to "FALL-BW78b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "78" in the Area "31"

# Teil-Rechnung1 mit Menge 38 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "78b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "38" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW78b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "78" in the Area "31"

# Mengenneubewertung
Given I open an editor "mnb-78b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-78b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L78b-LS;art=0efall31;buart=1;mge=78;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "111" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "78" in the Area "31"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "78b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW78b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "78" in the Area "31"

# Storno-Mengenneubewertung
Given I open an editor "mnb-78" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-78b"
And I set field "such" to "SMNB-78b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "78" in the Area "31"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+78b-TRE1"
And I set field "num4" to "78b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "78" in the Area "31"
#####################################################################################################################################

@FALL-BW79b
Scenario: FALL-BW79b; EK BE_LS.vorl_TRE1_MNB_TRE2_SMNB_STRE1_STRE2 mit Verbuchung; Testumgebung 32

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa32"
And I set field "num4" to "79b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall32" in row 1
And I set field "mge" to "79" in row 1
And I set field "preis" to "79.79" in row 1
And I set field "kenn" to "FALL-BW79b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "79b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "79" in row 1
And I set field "kenn" to "FALL-BW79b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "79" in the Area "32"

# Teil-Rechnung1 mit Menge 39 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "79b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "39" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW79b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "79" in the Area "32"

# Mengenneubewertung
Given I open an editor "mnb-79b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-79b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L79b-LS;art=0efall32;buart=1;mge=79;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "111" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "79" in the Area "32"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "79b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW79b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "79" in the Area "32"

# Storno-Mengenneubewertung
Given I open an editor "mnb-79" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-79b"
And I set field "such" to "SMNB-79b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "79" in the Area "32"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+79b-TRE1"
And I set field "num4" to "79b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "79" in the Area "32"

# Storno Teil-Rechnung2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+79b-TRE2"
And I set field "num4" to "79b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "79" in the Area "32"
#####################################################################################################################################

@FALL-BW81b
Scenario: FALL-BW81b; EK BE_LS.vorl_TRE1_MNB_TRE2_STRE1.fehler_SMNB mit Verbuchung; Testumgebung 33

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa33"
And I set field "num4" to "81b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall33" in row 1
And I set field "mge" to "81" in row 1
And I set field "preis" to "81.81" in row 1
And I set field "kenn" to "FALL-BW81b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "81b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "81" in row 1
And I set field "kenn" to "FALL-BW81b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "81" in the Area "33"

# Teil-Rechnung1 mit Menge 41 und Preis 60.00 anlegen
Given I open an editor "rechnung1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "81b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "41" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW81b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "81" in the Area "33"

# Mengenneubewertung
Given I open an editor "mnb-81b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-81b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L81b-LS;art=0efall33;buart=1;mge=81;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "111" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "81" in the Area "33"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "81b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW81b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "81" in the Area "33"

# Storno Teil-Rechnung1
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung1" throws the exception "3335"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "81" in the Area "33"

# Storno-Mengenneubewertung
Given I open an editor "mnb-81" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-81b"
And I set field "such" to "SMNB-81b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "81" in the Area "33"
#####################################################################################################################################

@FALL-BW82b
Scenario: FALL-BW82b; EK BE_LS.vorl_TRE1_MNB_TRE2_STRE1.fehler_SMNB_STRE2_STRE1 mit Verbuchung; Testumgebung 34

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa34"
And I set field "num4" to "82b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall34" in row 1
And I set field "mge" to "82" in row 1
And I set field "preis" to "82.82" in row 1
And I set field "kenn" to "FALL-BW82b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "82b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "82" in row 1
And I set field "kenn" to "FALL-BW82b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "82" in the Area "34"

# Teil-Rechnung1 mit Menge 42 und Preis 60.00 anlegen
Given I open an editor "rechnung1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "82b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "42" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW82b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "82" in the Area "34"

# Mengenneubewertung
Given I open an editor "mnb-82b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-82b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L82b-LS;art=0efall34;buart=1;mge=82;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "111" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "82" in the Area "34"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "82b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW82b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "82" in the Area "34"

# Storno Teil-Rechnung1 -> Fehler
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung1" throws the exception "3335"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "82" in the Area "34"

# Storno-Mengenneubewertung
Given I open an editor "mnb-82" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-82b"
And I set field "such" to "SMNB-82b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "82" in the Area "34"

# Storno Teil-Rechnung2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+82b-TRE2"
And I set field "num4" to "82b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "82" in the Area "34"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+82b-TRE1"
And I set field "num4" to "82b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "82" in the Area "34"
#####################################################################################################################################

@FALL-BW86b
Scenario: FALL-BW86b; EK BE_LS.vorl_TRE1_MNB_TRE2_STRE2_SMNB_STRE1 mit Verbuchung; Testumgebung 36

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa36"
And I set field "num4" to "86b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall36" in row 1
And I set field "mge" to "86" in row 1
And I set field "preis" to "86.86" in row 1
And I set field "kenn" to "FALL-BW86b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "86b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "86" in row 1
And I set field "kenn" to "FALL-BW86b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "86" in the Area "36"

# Teil-Rechnung1 mit Menge 46 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "86b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "46" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW86b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "86" in the Area "36"

# Mengenneubewertung
Given I open an editor "mnb-86b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-86b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L86b-LS;art=0efall36;buart=1;mge=86;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "111" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "86" in the Area "36"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "86b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW86b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "86" in the Area "36"

# Storno Teil-Rechnung2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+86b-TRE2"
And I set field "num4" to "86b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "86" in the Area "36"

# Storno-Mengenneubewertung
Given I open an editor "mnb-86" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-86b"
And I set field "such" to "SMNB-86b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "86" in the Area "36"

# Storno Teil-Rechnung1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+86b-TRE1"
And I set field "num4" to "86b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "86" in the Area "36"
#####################################################################################################################################

@FALL-BW87b
Scenario: FALL-BW87b; EK BE_LS.vorl_TRE1_MNB_TRE2_STRE2_SMNB  mit Verbuchung; Testumgebung 37

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa37"
And I set field "num4" to "87b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall37" in row 1
And I set field "mge" to "87" in row 1
And I set field "preis" to "87.87" in row 1
And I set field "kenn" to "FALL-BW87b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "87b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "87" in row 1
And I set field "kenn" to "FALL-BW87b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "87" in the Area "37"

# Teil-Rechnung1 mit Menge 47 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "87b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "47" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW87b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "87" in the Area "37"

# Mengenneubewertung
Given I open an editor "mnb-87b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-87b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L87b-LS;art=0efall37;buart=1;mge=87;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "111" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "87" in the Area "37"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "87b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW87b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "87" in the Area "37"

# Storno Teil-Rechnung2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+87b-TRE2"
And I set field "num4" to "87b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "87" in the Area "37"

# Storno-Mengenneubewertung
Given I open an editor "mnb-87" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-87b"
And I set field "such" to "SMNB-87b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "87" in the Area "37"
#####################################################################################################################################

@FALL-BW88b
Scenario: FALL-BW88b; EK BE_LS.vorl_TRE1_MNB_TRE2_STRE2 mit Verbuchung; Testumgebung 38

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa38"
And I set field "num4" to "88b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall38" in row 1
And I set field "mge" to "88" in row 1
And I set field "preis" to "88.88" in row 1
And I set field "kenn" to "FALL-BW88b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "88b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "88" in row 1
And I set field "kenn" to "FALL-BW88b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "88" in the Area "38"

# Teil-Rechnung1 mit Menge 48 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "88b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "48" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW88b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "88" in the Area "38"

# Mengenneubewertung
Given I open an editor "mnb-88b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-88b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L88b-LS;art=0efall38;buart=1;mge=88;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "111" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "88" in the Area "38"

# Teil-Rechnung2 mit Menge 40 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "88b-TRE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW88b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "88" in the Area "38"

# Storno Teil-Rechnung2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+88b-TRE2"
And I set field "num4" to "88b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "88" in the Area "38"
#####################################################################################################################################
