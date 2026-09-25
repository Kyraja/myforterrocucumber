# *****************************************************************************
#  Name             : ref_bw_ketten_mit_kontierungswechsel4.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        : 
#  Funktion         : testet STORNO von EK-RE und MNB;
#                     Faelle, wo es zu Kontierungswechsel kommen kann
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#                    Testumgebung 30: Scenario: FALL-BW40a; EK BE_LS.unbewert_MNB.vorl_SMNB          ohne Verbuchung
#                    Testumgebung 31: Scenario: FALL-BW40b; EK BE_LS.unbewert_MNB.vorl_SMNB          mit Verbuchung
#                    Testumgebung 32: Scenario: FALL-BW41a; EK BE_LS.unbewert_MNB.vorl_RE_SRE        ohne Verbuchung
#                    Testumgebung 33: Scenario: FALL-BW41b; EK BE_LS.unbewert_MNB.vorl_RE_SRE        mit Verbuchung
#                    Testumgebung 34: Scenario: FALL-BW42a; EK BE_LS.unbewert_MNB.vorl_RE_SMNB_SRE   ohne Verbuchung
#                    Testumgebung 35: Scenario: FALL-BW42b; EK BE_LS.unbewert_MNB.vorl_RE_SMNB_SRE   mit Verbuchung
#                    * leer *
#                    Testumgebung 40: Scenario: FALL-BW43a; EK BE_LS.unbewert_MNB.direkt_SMNB_RE     ohne Verbuchung
#                    Testumgebung 41: Scenario: FALL-BW43b; EK BE_LS.unbewert_MNB.direkt_SMNB_RE     mit Verbuchung
#                    Testumgebung 42: Scenario: FALL-BW44a; EK BE_LS.unbewert_MNB.direkt_SMNB_RE_SRE ohne Verbuchung
#                    Testumgebung 43: Scenario: FALL-BW44b; EK BE_LS.unbewert_MNB.direkt_SMNB_RE_SRE mit Verbuchung
#                    Testumgebung 44: Scenario: FALL-BW45a; EK BE_LS.unbewert_MNB.direkt_RE_SMNB_SRE ohne Verbuchung
#                    Testumgebung 45: Scenario: FALL-BW45b; EK BE_LS.unbewert_MNB.direkt_RE_SMNB_SRE mit Verbuchung
#                    Testumgebung 46: Scenario: FALL-BW46a; EK BE_LS.unbewert_MNB.direkt_SMNB        ohne Verbuchung
#                    Testumgebung 47: Scenario: FALL-BW46b; EK BE_LS.unbewert_MNB.direkt_SMNB        mit Verbuchung
#                    Testumgebung 48: Scenario: FALL-BW47a; EK BE_LS.unbewert_RE_SRE                 ohne Verbuchung
#                    Testumgebung 49: Scenario: FALL-BW47b; EK BE_LS.unbewert_RE_SRE                 mit Verbuchung
#                    Testumgebung 50: Scenario: FALL-BW48b; EK BE_LS.unbewert_RE_MNB_SMNB_SRE_SLS    mit Verbuchung
#
# *****************************************************************************

@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "07.01.2002"


@FALL-BW40a
Scenario: FALL-BW40a; EK BE_LS.unbewert_MNB.vorl_SMNB ohne Verbuchung; Testumgebung 30

# Bestellung anlegen
# Preis muss hier 0.00 sein!!!
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa30"
And I set field "num4" to "40a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall30" in row 1
And I set field "mge" to "40" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW40a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "40a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW40a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-40a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-40a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L40a-LS;art=0efall30;buart=1;mge=40;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "80" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-40" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-40a"
And I set field "such" to "SMNB-40a"
And I save the current editor
And I close the current editor
#####################################################################################################################################

@FALL-BW40b
Scenario: FALL-BW40b; EK  BE_LS.unbewert_MNB.vorl_SMNB mit Verbuchung; Testumgebung 31

# Bestellung anlegen
# Preis muss hier 0.00 sein!!!
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa31"
And I set field "num4" to "40b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall31" in row 1
And I set field "mge" to "40" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW40b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "40b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "40" in row 1
And I set field "kenn" to "FALL-BW40b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "40" in the Area "31"

# Mengenneubewertung
Given I open an editor "mnb-40b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-40b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L40b-LS;art=0efall31;buart=1;mge=40;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "80" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "40" in the Area "31"

# Storno-Mengenneubewertung
Given I open an editor "mnb-40" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-40b"
And I set field "such" to "SMNB-40b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "40" in the Area "31"
#####################################################################################################################################

@FALL-BW41a
Scenario: FALL-BW41a; EK BE_LS.unbewert_MNB.vorl_RE_SRE ohne Verbuchung; Testumgebung 32

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa32"
And I set field "num4" to "41a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall32" in row 1
And I set field "mge" to "41" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW41a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "41a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "41" in row 1
And I set field "kenn" to "FALL-BW41a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-41a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-41a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L41a-LS;art=0efall32;buart=1;mge=41;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "82" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "41a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "41" in row 1
And I set field "preis" to "41" in row 1
And I set field "kenn" to "FALL-BW41a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+41a-RE"
And I set field "num4" to "41a-STRE"
And I save the current editor
#####################################################################################################################################

@FALL-BW41b
Scenario: FALL-BW41b; EK BE_LS.unbewert_MNB.vorl_RE_SRE mit Verbuchung; Testumgebung 33

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa33"
And I set field "num4" to "41b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall33" in row 1
And I set field "mge" to "41" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW41b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "41b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "41" in row 1
And I set field "kenn" to "FALL-BW41b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "41" in the Area "33"

# Mengenneubewertung
Given I open an editor "mnb-41b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-41b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L41b-LS;art=0efall33;buart=1;mge=41;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "82" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "41" in the Area "33"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "41b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "41" in row 1
And I set field "preis" to "41" in row 1
And I set field "kenn" to "FALL-BW41b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "41" in the Area "33"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+41b-RE"
And I set field "num4" to "41b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "41" in the Area "33"
#####################################################################################################################################

@FALL-BW42a
Scenario: FALL-BW42a; EK BE_LS.unbewert_MNB.vorl_RE_SMNB_SRE ohne Verbuchung; Testumgebung 34

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa34"
And I set field "num4" to "42a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall34" in row 1
And I set field "mge" to "42" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW42a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "42a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "42" in row 1
And I set field "kenn" to "FALL-BW42a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-42a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-42a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L42a-LS;art=0efall34;buart=1;mge=42;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "84" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "42a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "42" in row 1
And I set field "preis" to "42" in row 1
And I set field "kenn" to "FALL-BW42a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-42" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-42a"
And I set field "such" to "SMNB-42a"
And I save the current editor
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+42a-RE"
And I set field "num4" to "42a-STRE"
And I save the current editor
#####################################################################################################################################

@FALL-BW42b
Scenario: FALL-BW42b; EK BE_LS.unbewert_MNB.vorl_RE_SMNB_SRE mit Verbuchung; Testumgebung 35

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa35"
And I set field "num4" to "42b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall35" in row 1
And I set field "mge" to "42" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW42b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "42b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "42" in row 1
And I set field "kenn" to "FALL-BW42b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "42" in the Area "35"

# Mengenneubewertung
Given I open an editor "mnb-42b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-42b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L42b-LS;art=0efall35;buart=1;mge=42;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "84" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "42" in the Area "35"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "42b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "42" in row 1
And I set field "preis" to "42" in row 1
And I set field "kenn" to "FALL-BW42b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "42" in the Area "35"

# Storno-Mengenneubewertung
# hier wird keine Bewertung erzeugt
Given I open an editor "mnb-42" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-42b"
And I set field "such" to "SMNB-42b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "42" in the Area "35"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+42b-RE"
And I set field "num4" to "42b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "42" in the Area "35"
#####################################################################################################################################

@FALL-BW43a
Scenario: FALL-BW43a; EK BE_LS.unbewert_MNB.direkt_SMNB_RE  ohne Verbuchung; Testumgebung 40

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa40"
And I set field "num4" to "43a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall40" in row 1
And I set field "mge" to "43" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW43a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "43a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "43" in row 1
And I set field "kenn" to "FALL-BW43a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-43a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-43a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L43a-LS;art=0efall40;buart=1;mge=43;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "86" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-43" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-43a"
And I set field "such" to "SMNB-43a"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "43a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "43" in row 1
And I set field "preis" to "43" in row 1
And I set field "kenn" to "FALL-BW43a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################

@FALL-BW43b
Scenario: FALL-BW43b; EK BE_LS.unbewert_MNB.direkt_SMNB_RE mit Verbuchung; Testumgebung 41

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa41"
And I set field "num4" to "43b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall41" in row 1
And I set field "mge" to "43" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW43b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "43b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "43" in row 1
And I set field "kenn" to "FALL-BW43b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "43" in the Area "41"

# Mengenneubewertung
Given I open an editor "mnb-43b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-43b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L43b-LS;art=0efall41;buart=1;mge=43;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "86" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "43" in the Area "41"

# Storno-Mengenneubewertung
Given I open an editor "mnb-43" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-43b"
And I set field "such" to "SMNB-43b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "43" in the Area "41"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "43b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "43" in row 1
And I set field "preis" to "43" in row 1
And I set field "kenn" to "FALL-BW43b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "43" in the Area "41"
#####################################################################################################################################

@FALL-BW44a
Scenario: FALL-BW44a; EK BE_LS.unbewert_MNB.direkt_SMNB_RE_SRE ohne Verbuchung; Testumgebung 42

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa42"
And I set field "num4" to "44a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall42" in row 1
And I set field "mge" to "44" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW44a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "44a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "44" in row 1
And I set field "kenn" to "FALL-BW44a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-44a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-44a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L44a-LS;art=0efall42;buart=1;mge=44;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "88" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-44" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-44a"
And I set field "such" to "SMNB-44a"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "44a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "44" in row 1
And I set field "preis" to "44" in row 1
And I set field "kenn" to "FALL-BW44a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+44a-RE"
And I set field "num4" to "44a-STRE"
And I save the current editor
#####################################################################################################################################

@FALL-BW44b
Scenario: FALL-BW44b; EK BE_LS.unbewert_MNB.direkt_SMNB_RE_SRE mit Verbuchung; Testumgebung 43

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa43"
And I set field "num4" to "44b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall43" in row 1
And I set field "mge" to "44" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW44b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "44b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "44" in row 1
And I set field "kenn" to "FALL-BW44b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "44" in the Area "43"

# Mengenneubewertung
Given I open an editor "mnb-44b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-44b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L44b-LS;art=0efall43;buart=1;mge=44;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "88" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "44" in the Area "43"

# Storno-Mengenneubewertung
Given I open an editor "mnb-44" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-44b"
And I set field "such" to "SMNB-44b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "44" in the Area "43"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "44b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "44" in row 1
And I set field "preis" to "44" in row 1
And I set field "kenn" to "FALL-BW44b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "44" in the Area "43"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+44b-RE"
And I set field "num4" to "44b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "44" in the Area "43"
#####################################################################################################################################

@FALL-BW45a
Scenario: FALL-BW45a; EK BE_LS.unbewert_MNB.direkt_RE_SMNB_SRE ohne Verbuchung; Testumgebung 44

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa44"
And I set field "num4" to "45a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall44" in row 1
And I set field "mge" to "45" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW45a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "45a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "45" in row 1
And I set field "kenn" to "FALL-BW45a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-45a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-45a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L45a-LS;art=0efall44;buart=1;mge=45;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "90" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "45a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "45" in row 1
And I set field "preis" to "45" in row 1
And I set field "kenn" to "FALL-BW45a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-45" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-45a"
And I set field "such" to "SMNB-45a"
And I save the current editor
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+45a-RE"
And I set field "num4" to "45a-STRE"
And I save the current editor
#####################################################################################################################################

@FALL-BW45b
Scenario: FALL-BW45b; EK BE_LS.unbewert_MNB.direkt_RE_SMNB_SRE mit Verbuchung; Testumgebung 45

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa45"
And I set field "num4" to "45b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall45" in row 1
And I set field "mge" to "45" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW45b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "45b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "45" in row 1
And I set field "kenn" to "FALL-BW45b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "45" in the Area "45"

# Mengenneubewertung
Given I open an editor "mnb-45b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-45b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L45b-LS;art=0efall45;buart=1;mge=45;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "90" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "45" in the Area "45"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "45b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "45" in row 1
And I set field "preis" to "45" in row 1
And I set field "kenn" to "FALL-BW45b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "45" in the Area "45"

# Storno-Mengenneubewertung
Given I open an editor "mnb-45" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-45b"
And I set field "such" to "SMNB-45b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "45" in the Area "45"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+45b-RE"
And I set field "num4" to "45b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "45" in the Area "45"
#####################################################################################################################################

@FALL-BW46a
Scenario: FALL-BW46a; EK BE_LS.unbewert_MNB.direkt_SMNB ohne Verbuchung; Testumgebung 46

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa46"
And I set field "num4" to "46a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall46" in row 1
And I set field "mge" to "46" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW46a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "46a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "46" in row 1
And I set field "kenn" to "FALL-BW46a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-46a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-46a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L46a-LS;art=0efall46;buart=1;mge=46;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "92" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-46" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-46a"
And I set field "such" to "SMNB-46a"
And I save the current editor
And I close the current editor
#####################################################################################################################################

@FALL-BW46b
Scenario: FALL-BW46b; EK BE_LS.unbewert_MNB.direkt_SMNB mit Verbuchung; Testumgebung 47

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa47"
And I set field "num4" to "46b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall47" in row 1
And I set field "mge" to "46" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW46b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "46b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "46" in row 1
And I set field "kenn" to "FALL-BW46b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "46" in the Area "47"

# Mengenneubewertung
Given I open an editor "mnb-46b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-46b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L46b-LS;art=0efall47;buart=1;mge=46;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "92" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "46" in the Area "47"

# Storno-Mengenneubewertung
Given I open an editor "mnb-46" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-46b"
And I set field "such" to "SMNB-46b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "46" in the Area "47"
#####################################################################################################################################

@FALL-BW47a
Scenario: FALL-BW47a; EK BE_LS.unbewert_RE_SRE ohne Verbuchung; Testumgebung 48

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa48"
And I set field "num4" to "47a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall48" in row 1
And I set field "mge" to "47" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW47a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "47a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "47" in row 1
And I set field "kenn" to "FALL-BW47a"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "47a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "47" in row 1
And I set field "preis" to "47" in row 1
And I set field "kenn" to "FALL-BW47a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+47a-RE"
And I set field "num4" to "47a-STRE"
And I save the current editor
#####################################################################################################################################

@FALL-BW47b
Scenario: FALL-BW47b; EK BE_LS.unbewert_RE_SRE mit Verbuchung; Testumgebung 49

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa49"
And I set field "num4" to "47b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall49" in row 1
And I set field "mge" to "47" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW47b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "47b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "47" in row 1
And I set field "kenn" to "FALL-BW47b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "47" in the Area "49"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "47b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "47" in row 1
And I set field "preis" to "47" in row 1
And I set field "kenn" to "FALL-BW47b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "47" in the Area "49"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+47b-RE"
And I set field "num4" to "47b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "47" in the Area "49"
#####################################################################################################################################

@FALL-BW48b
Scenario: FALL-BW48b; EK BE_LS.unbewert_RE_MNB_SMNB_SRE_SLS mit Verbuchung; Testumgebung 50

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa50"
And I set field "num4" to "48b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall50" in row 1
And I set field "mge" to "48" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW48b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "48b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "48" in row 1
And I set field "kenn" to "FALL-BW48b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "48" in the Area "50"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "48b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "48" in row 1
And I set field "preis" to "48" in row 1
And I set field "kenn" to "FALL-BW48b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "48" in the Area "50"

# Mengenneubewertung
Given I open an editor "mnb-48b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-48b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L48b-LS;art=0efall50;buart=1;mge=48;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "96" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "48" in the Area "50"

# Storno-Mengenneubewertung
Given I open an editor "mnb-48" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-48b"
And I set field "such" to "SMNB-48b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "48" in the Area "50"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+48b-RE"
And I set field "num4" to "48b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "48" in the Area "50"

# Storno-Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "48b-LS"
And I set field "num4" to "48b-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "48" in the Area "50"
#####################################################################################################################################
