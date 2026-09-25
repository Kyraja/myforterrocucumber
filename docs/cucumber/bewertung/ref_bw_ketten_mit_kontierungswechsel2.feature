# *****************************************************************************
#  Name             : ref_bw_ketten_mit_kontierungswechsel2.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        : 
#  Funktion         : testet STORNO von EK-RE und MNB;
#                     Faelle, wo es zu Kontierungswechsel kommen kann
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#                    Testumgebung 10: Scenario: FALL-BW28a; EK BE_LS.vorl_MNB.direkt_RE_SMNB         ohne Verbuchung
#                    Testumgebung 11: Scenario: FALL-BW28b; EK BE_LS.vorl_MNB.direkt_RE_SMNB         mit Verbuchung
#                    Testumgebung 12: Scenario: FALL-BW31a; EK BE_LS.vorl_MNB.direkt_RE_SMNB_SRE_SLS ohne Verbuchung
#                    Testumgebung 13: Scenario: FALL-BW31b; EK BE_LS.vorl_MNB.direkt_RE_SMNB_SRE_SLS mit Verbuchung
#                    Testumgebung 14: Scenario: FALL-BW32a; EK BE_LS.vorl_MNB.direkt_RE_SRE          ohne Verbuchung
#                    Testumgebung 15: Scenario: FALL-BW32b; EK BE_LS.vorl_MNB.direkt_RE_SRE          mit Verbuchung
#                    Testumgebung 16: Scenario: FALL-BW34a; EK BE_LS.vorl_MNB.direkt_RE_SRE_SMNB_SLS ohne Verbuchung
#                    Testumgebung 17: Scenario: FALL-BW34b; EK BE_LS.vorl_MNB.direkt_RE_SRE_SMNB_SLS mit Verbuchung
#
# *****************************************************************************

@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "07.01.2002"


@FALL-BW28a
Scenario: FALL-BW28a; EK BE_LS.vorl_MNB.direkt_RE_SMNB ohne Verbuchung; Testumgebung 10

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa10"
And I set field "num4" to "28a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall10" in row 1
And I set field "mge" to "28" in row 1
And I set field "preis" to "28.28" in row 1
And I set field "kenn" to "FALL-BW28a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "28a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "28" in row 1
And I set field "kenn" to "FALL-BW28a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-28a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-28a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L28a-LS;art=0efall10;buart=1;mge=28;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "56" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "28a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "28" in row 1
And I set field "preis" to "28" in row 1
And I set field "kenn" to "FALL-BW28a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-28" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-28a"
And I set field "such" to "SMNB-28a"
And I save the current editor
And I close the current editor
#####################################################################################################################################

@FALL-BW28b
Scenario: FALL-BW28b; EK BE_LS.vorl_MNB.direkt_RE_SMNB mit Verbuchung; Testumgebung 11

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa11"
And I set field "num4" to "28b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall11" in row 1
And I set field "mge" to "28" in row 1
And I set field "preis" to "28.28" in row 1
And I set field "kenn" to "FALL-BW28b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "28b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "28" in row 1
And I set field "kenn" to "FALL-BW28b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "28" in the Area "11"

# Mengenneubewertung
Given I open an editor "mnb-28b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-28b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L28b-LS;art=0efall11;buart=1;mge=28;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "56" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "28" in the Area "11"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "28b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "28" in row 1
And I set field "preis" to "28" in row 1
And I set field "kenn" to "FALL-BW28b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "28" in the Area "11"

# Storno-Mengenneubewertung
Given I open an editor "mnb-28" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-28b"
And I set field "such" to "SMNB-28b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "28" in the Area "11"
#####################################################################################################################################

@FALL-BW31a
Scenario: FALL-BW31a; EK BE_LS.vorl_MNB.direkt_RE_SMNB_SRE_SLS ohne Verbuchung; Testumgebung 12

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa12"
And I set field "num4" to "31a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall12" in row 1
And I set field "mge" to "31" in row 1
And I set field "preis" to "31.31" in row 1
And I set field "kenn" to "FALL-BW31a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "31a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "31" in row 1
And I set field "kenn" to "FALL-BW31a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-31a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-31a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L31a-LS;art=0efall12;buart=1;mge=31;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "62" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "31a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "31" in row 1
And I set field "preis" to "31" in row 1
And I set field "kenn" to "FALL-BW31a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-31" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-31a"
And I set field "such" to "SMNB-31a"
And I save the current editor
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+31a-RE"
And I set field "num4" to "31a-STRE"
And I save the current editor

# Storno-Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "31a-LS"
And I set field "num4" to "31a-STLS"
And I save the current editor
#####################################################################################################################################

@FALL-BW31b
Scenario: FALL-BW31b; EK BE_LS.vorl_MNB.direkt_RE_SMNB_SRE_SLS mit Verbuchung; Testumgebung 13

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa13"
And I set field "num4" to "31b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall13" in row 1
And I set field "mge" to "31" in row 1
And I set field "preis" to "31.31" in row 1
And I set field "kenn" to "FALL-BW31b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "31b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "31" in row 1
And I set field "kenn" to "FALL-BW31b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "31" in the Area "13"

# Mengenneubewertung
Given I open an editor "mnb-31b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-31b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L31b-LS;art=0efall13;buart=1;mge=31;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "62" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "31" in the Area "13"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "31b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "31" in row 1
And I set field "preis" to "31" in row 1
And I set field "kenn" to "FALL-BW31b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "31" in the Area "13"

# Storno-Mengenneubewertung
Given I open an editor "mnb-31" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-31b"
And I set field "such" to "SMNB-31b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "31" in the Area "13"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+31b-RE"
And I set field "num4" to "31b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "31" in the Area "13"

# Storno-Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "31b-LS"
And I set field "num4" to "31b-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "31" in the Area "13"
#####################################################################################################################################

@FALL-BW32a
Scenario: FALL-BW32a; EK BE_LS.vorl_MNB.direkt_RE_SRE ohne Verbuchung; Testumgebung 14

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa14"
And I set field "num4" to "32a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall14" in row 1
And I set field "mge" to "32" in row 1
And I set field "preis" to "32.32" in row 1
And I set field "kenn" to "FALL-BW32a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "32a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "32" in row 1
And I set field "kenn" to "FALL-BW32a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-32a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-32a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L32a-LS;art=0efall14;buart=1;mge=32;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "64" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "32a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "32" in row 1
And I set field "preis" to "32" in row 1
And I set field "kenn" to "FALL-BW32a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+32a-RE"
And I set field "num4" to "32a-STRE"
And I save the current editor
#####################################################################################################################################

@FALL-BW32b
Scenario: FALL-BW32b; EK BE_LS.vorl_MNB.direkt_RE_SRE mit Verbuchung; Testumgebung 15

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa15"
And I set field "num4" to "32b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall15" in row 1
And I set field "mge" to "32" in row 1
And I set field "preis" to "32.32" in row 1
And I set field "kenn" to "FALL-BW32b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "32b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "32" in row 1
And I set field "kenn" to "FALL-BW32b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "32" in the Area "15"

# Mengenneubewertung
Given I open an editor "mnb-32b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-32b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L32b-LS;art=0efall15;buart=1;mge=32;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "64" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "32" in the Area "15"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "32b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "32" in row 1
And I set field "preis" to "32" in row 1
And I set field "kenn" to "FALL-BW32b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "32" in the Area "15"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+32b-RE"
And I set field "num4" to "32b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "32" in the Area "15"
#####################################################################################################################################

@FALL-BW34a
Scenario: FALL-BW34a; EK BE_LS.vorl_MNB.direkt_RE_SRE_SMNB_SLS ohne Verbuchung; Testumgebung 16

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa16"
And I set field "num4" to "34a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall16" in row 1
And I set field "mge" to "34" in row 1
And I set field "preis" to "34.34" in row 1
And I set field "kenn" to "FALL-BW34a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "34a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "34" in row 1
And I set field "kenn" to "FALL-BW34a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-34a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-34a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L34a-LS;art=0efall16;buart=1;mge=34;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "68" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "34a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "34" in row 1
And I set field "preis" to "34" in row 1
And I set field "kenn" to "FALL-BW34a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+34a-RE"
And I set field "num4" to "34a-STRE"
And I save the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-34" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-34a"
And I set field "such" to "SMNB-34a"
And I save the current editor
And I close the current editor

# Storno-Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "34a-LS"
And I set field "num4" to "34a-STLS"
And I save the current editor
#####################################################################################################################################

@FALL-BW34b
Scenario: FALL-BW34b; EK BE_LS.vorl_MNB.direkt_RE_SRE_SMNB_SLS mit Verbuchung; Testumgebung 17

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa17"
And I set field "num4" to "34b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall17" in row 1
And I set field "mge" to "34" in row 1
And I set field "preis" to "34.34" in row 1
And I set field "kenn" to "FALL-BW34b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "34b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "34" in row 1
And I set field "kenn" to "FALL-BW34b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "34" in the Area "17"

# Mengenneubewertung
Given I open an editor "mnb-34b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-34b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L34b-LS;art=0efall17;buart=1;mge=34;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "68" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "34" in the Area "17"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "34b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "34" in row 1
And I set field "preis" to "34" in row 1
And I set field "kenn" to "FALL-BW34b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "34" in the Area "17"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+34b-RE"
And I set field "num4" to "34b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "34" in the Area "17"

# Storno-Mengenneubewertung
Given I open an editor "mnb-34" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-34b"
And I set field "such" to "SMNB-34b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "34" in the Area "17"

# Storno-Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "34b-LS"
And I set field "num4" to "34b-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "34" in the Area "17"
#####################################################################################################################################
