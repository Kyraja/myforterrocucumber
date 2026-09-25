# *****************************************************************************
#  Name             : ref_bw_ketten_mit_kontierungswechsel3.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        : 
#  Funktion         : testet STORNO von EK-RE und MNB;
#                     Faelle, wo es zu Kontierungswechsel kommen kann
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#                    Testumgebung 20: Scenario: FALL-BW37a; EK BE_LS.vorl_MNB.direkt_SMNB_RE          ohne Verbuchung
#                    Testumgebung 21: Scenario: FALL-BW37b; EK BE_LS.vorl_MNB.direkt_RE_SRE_SMNB_SLS  mit Verbuchung
#                    Testumgebung 22: Scenario: FALL-BW38a; EK BE_LS.vorl_MNB.direkt_SMNB_RE_SRE      ohne Verbuchung
#                    Testumgebung 23: Scenario: FALL-BW38b; EK BE_LS.vorl_MNB.direkt_SMNB_RE_SRE      mit Verbuchung
#                    Testumgebung 24: Scenario: FALL-BW39a; EK BE_LS.vorl_MNB.direkt_SMNB_RE_SRE_SLS  ohne Verbuchung
#                    Testumgebung 25: Scenario: FALL-BW39b; EK BE_LS.vorl_MNB.direkt_SMNB_RE_SRE_SLS  mit Verbuchung
#
# *****************************************************************************

@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "07.01.2002"


@FALL-BW37a
Scenario: FALL-BW37a; EK BE_LS.vorl_MNB.direkt_SMNB_RE ohne Verbuchung; Testumgebung 20

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa20"
And I set field "num4" to "37a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall20" in row 1
And I set field "mge" to "37" in row 1
And I set field "preis" to "37.37" in row 1
And I set field "kenn" to "FALL-BW37a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "37a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "37" in row 1
And I set field "kenn" to "FALL-BW37a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-37a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-37a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L37a-LS;art=0efall20;buart=1;mge=37;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "74" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-37" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-37a"
And I set field "such" to "SMNB-37a"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "37a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "37" in row 1
And I set field "preis" to "37" in row 1
And I set field "kenn" to "FALL-BW37a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################

@FALL-BW37b
Scenario: FALL-BW37b; EK BE_LS.vorl_MNB.direkt_RE_SRE_SMNB_SLS mit Verbuchung; Testumgebung 21

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa21"
And I set field "num4" to "37b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall21" in row 1
And I set field "mge" to "37" in row 1
And I set field "preis" to "37.37" in row 1
And I set field "kenn" to "FALL-BW37b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "37b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "37" in row 1
And I set field "kenn" to "FALL-BW37b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "37" in the Area "21"

# Mengenneubewertung
Given I open an editor "mnb-37b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-37b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L37b-LS;art=0efall21;buart=1;mge=37;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "74" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "37" in the Area "21"

# Storno-Mengenneubewertung
Given I open an editor "mnb-37" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-37b"
And I set field "such" to "SMNB-37b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "37" in the Area "21"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "37b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "37" in row 1
And I set field "preis" to "37" in row 1
And I set field "kenn" to "FALL-BW37b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "37" in the Area "21"
#####################################################################################################################################

@FALL-BW38a
Scenario: FALL-BW38a; EK BE_LS.vorl_MNB.direkt_SMNB_RE_SRE ohne Verbuchung; Testumgebung 22

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa22"
And I set field "num4" to "38a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall22" in row 1
And I set field "mge" to "38" in row 1
And I set field "preis" to "38.38" in row 1
And I set field "kenn" to "FALL-BW38a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "38a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "38" in row 1
And I set field "kenn" to "FALL-BW38a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-38a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-38a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L38a-LS;art=0efall22;buart=1;mge=38;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "76" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-38" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-38a"
And I set field "such" to "SMNB-38a"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "38a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "38" in row 1
And I set field "preis" to "38" in row 1
And I set field "kenn" to "FALL-BW38a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+38a-RE"
And I set field "num4" to "38a-STRE"
And I save the current editor
#####################################################################################################################################

@FALL-BW38b
Scenario: FALL-BW38b; EK BE_LS.vorl_MNB.direkt_SMNB_RE_SRE mit Verbuchung; Testumgebung 23

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa23"
And I set field "num4" to "38b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall23" in row 1
And I set field "mge" to "38" in row 1
And I set field "preis" to "38.38" in row 1
And I set field "kenn" to "FALL-BW38b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "38b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "38" in row 1
And I set field "kenn" to "FALL-BW38b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "38" in the Area "23"

# Mengenneubewertung
Given I open an editor "mnb-38b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-38b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L38b-LS;art=0efall23;buart=1;mge=38;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "76" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "38" in the Area "23"

# Storno-Mengenneubewertung
Given I open an editor "mnb-38" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-38b"
And I set field "such" to "SMNB-38b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "38" in the Area "23"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "38b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "38" in row 1
And I set field "preis" to "38" in row 1
And I set field "kenn" to "FALL-BW38b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "38" in the Area "23"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+38b-RE"
And I set field "num4" to "38b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "38" in the Area "23"
#####################################################################################################################################

@FALL-BW39a
Scenario: FALL-BW39a; EK BE_LS.vorl_MNB.direkt_SMNB_RE_SRE_SLS ohne Verbuchung; Testumgebung 24

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa24"
And I set field "num4" to "39a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall24" in row 1
And I set field "mge" to "39" in row 1
And I set field "preis" to "39.39" in row 1
And I set field "kenn" to "FALL-BW39a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "39a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "39" in row 1
And I set field "kenn" to "FALL-BW39a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-39a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-39a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L39a-LS;art=0efall24;buart=1;mge=39;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "78" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-39" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-39a"
And I set field "such" to "SMNB-39a"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "39a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "39" in row 1
And I set field "preis" to "39" in row 1
And I set field "kenn" to "FALL-BW39a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+39a-RE"
And I set field "num4" to "39a-STRE"
And I save the current editor

# Storno-Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "39a-LS"
And I set field "num4" to "39a-STLS"
And I save the current editor
#####################################################################################################################################

@FALL-BW39b
Scenario: FALL-BW39b; EK BE_LS.vorl_MNB.direkt_SMNB_RE_SRE_SLS mit Verbuchung; Testumgebung 25

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa25"
And I set field "num4" to "39b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall25" in row 1
And I set field "mge" to "39" in row 1
And I set field "preis" to "39.39" in row 1
And I set field "kenn" to "FALL-BW39b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "39b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "39" in row 1
And I set field "kenn" to "FALL-BW39b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "39" in the Area "25"

# Mengenneubewertung
Given I open an editor "mnb-39b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-39b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L39b-LS;art=0efall25;buart=1;mge=39;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "78" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "39" in the Area "25"

# Storno-Mengenneubewertung
Given I open an editor "mnb-39" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-39b"
And I set field "such" to "SMNB-39b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "39" in the Area "25"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "39b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "39" in row 1
And I set field "preis" to "39" in row 1
And I set field "kenn" to "FALL-BW39b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "39" in the Area "25"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+39b-RE"
And I set field "num4" to "39b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "39" in the Area "25"

# Storno-Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "39b-LS"
And I set field "num4" to "39b-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "39" in the Area "25"
#####################################################################################################################################
