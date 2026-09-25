
# *****************************************************************************
#  Name             : ref_bw_ketten_mit_kontierungswechsel5.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        : 
#  Funktion         : testet STORNO von EK-RE und MNB;
#                     Faelle, wo es zu Kontierungswechsel kommen kann
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#                    Testumgebung 1: Scenario: FALL-BW49b; EK BE_RE.ohneLB_LS_SRE                         mit Verbuchung
#                    Testumgebung 2: Scenario: FALL-BW50b; EK BE_RE.ohneLB_LS_MNB_SRE.fehler              mit Verbuchung
#                    Testumgebung 3: Scenario: FALL-BW51b; EK BE_RE.ohneLB_LS_MNB_SRE.fehler_SMNB_SRE     mit Verbuchung
#                    Testumgebung 4: Scenario: FALL-BW52b; EK BE_RE.ohneLB_LS_MNB_SRE.fehler_SMNB_SRE_SLS mit Verbuchung
#                    Testumgebung 5: Scenario: FALL-BW53b; EK BE_RE.ohneLB_LS_MNB_SMNB_SRE                mit Verbuchung
#                    Testumgebung 6: Scenario: FALL-BW54b; EK BE_RE.ohneLB_LS_SLS                         mit Verbuchung
#
# *****************************************************************************

@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "07.01.2002"


@FALL-BW49b
Scenario: FALL-BW49b; EK BE_RE.ohneLB_LS_SRE mit Verbuchung; Testumgebung 1

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa1"
And I set field "num4" to "49b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall1" in row 1
And I set field "mge" to "49" in row 1
And I set field "preis" to "49.49" in row 1
And I set field "kenn" to "FALL-BW49b"
And I save the current editor

# Rechnung ohne Lagerbewegung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "49b-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "49" in row 1
And I set field "preis" to "49" in row 1
And I set field "kenn" to "FALL-BW49b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "49" in the Area "1"

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "49b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "49" in row 1
And I set field "kenn" to "FALL-BW49b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "49" in the Area "1"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+49b-RE"
And I set field "num4" to "49b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "49" in the Area "1"
#####################################################################################################################################

@FALL-BW50b
Scenario: FALL-BW50b; EK BE_RE.ohneLB_LS_MNB_SRE.fehler mit Verbuchung; Testumgebung 2

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa2"
And I set field "num4" to "50b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall2" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "50.50" in row 1
And I set field "kenn" to "FALL-BW50b"
And I save the current editor

# Rechnung ohne Lagerbewegung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "50b-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "preis" to "50" in row 1
And I set field "kenn" to "FALL-BW50b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "50" in the Area "2"

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "50b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "kenn" to "FALL-BW50b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "50" in the Area "2"

# Mengenneubewertung
Given I open an editor "mnb-50b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-50b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L50b-LS;art=0efall2;buart=1;mge=50;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "100" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "50" in the Area "2"

# Storno Rechnung -> Fehlerfall
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung" throws the exception "3335"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "50" in the Area "2"
#####################################################################################################################################

@FALL-BW51b
Scenario: FALL-BW51b; EK BE_RE.ohneLB_LS_MNB_SRE.fehler_SMNB_SRE mit Verbuchung; Testumgebung 3

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa3"
And I set field "num4" to "51b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall3" in row 1
And I set field "mge" to "51" in row 1
And I set field "preis" to "51.51" in row 1
And I set field "kenn" to "FALL-BW51b"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "51b-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "51" in row 1
And I set field "preis" to "51" in row 1
And I set field "kenn" to "FALL-BW51b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "51" in the Area "3"

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "51b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "51" in row 1
And I set field "kenn" to "FALL-BW51b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "51" in the Area "3"

# Mengenneubewertung
Given I open an editor "mnb-51b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-51b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L51b-LS;art=0efall3;buart=1;mge=51;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "102" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "51" in the Area "3"

# Storno Rechnung -> Fehlerfall
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung" throws the exception "3335"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "51" in the Area "3"

# Storno-Mengenneubewertung
Given I open an editor "mnb-51" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-51b"
And I set field "such" to "SMNB-51b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "51" in the Area "3"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+51b-RE"
And I set field "num4" to "51b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "51" in the Area "3"
#####################################################################################################################################

@FALL-BW52b
Scenario: FALL-BW52b; EK BE_RE.ohneLB_LS_MNB_SRE.fehler_SMNB_SRE_SLS mit Verbuchung; Testumgebung 4

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa4"
And I set field "num4" to "52b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall4" in row 1
And I set field "mge" to "52" in row 1
And I set field "preis" to "52.52" in row 1
And I set field "kenn" to "FALL-BW52b"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "52b-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "52" in row 1
And I set field "preis" to "52" in row 1
And I set field "kenn" to "FALL-BW52b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "52" in the Area "4"

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "52b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "52" in row 1
And I set field "kenn" to "FALL-BW52b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "52" in the Area "4"

# Mengenneubewertung
Given I open an editor "mnb-52b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-52b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L52b-LS;art=0efall4;buart=1;mge=52;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "104" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "52" in the Area "4"

# Storno-Mengenneubewertung
Given I open an editor "mnb-52" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-52b"
And I set field "such" to "SMNB-52b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "52" in the Area "4"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+52b-RE"
And I set field "num4" to "52b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "52" in the Area "4"

# Storno-Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+52b-LS"
And I set field "num4" to "52b-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "52" in the Area "4"
#####################################################################################################################################

@FALL-BW53b
Scenario: FALL-BW53b; EK BE_RE.ohneLB_LS_MNB_SMNB_SRE mit Verbuchung; Testumgebung 5

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa5"
And I set field "num4" to "53b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall5" in row 1
And I set field "mge" to "53" in row 1
And I set field "preis" to "53.53" in row 1
And I set field "kenn" to "FALL-BW53b"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "53b-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "53" in row 1
And I set field "preis" to "53" in row 1
And I set field "kenn" to "FALL-BW53b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "53" in the Area "5"

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "53b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "53" in row 1
And I set field "kenn" to "FALL-BW53b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "53" in the Area "5"

# Mengenneubewertung
Given I open an editor "mnb-53b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-53b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L53b-LS;art=0efall5;buart=1;mge=53;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "106" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "53" in the Area "5"

# Storno-Mengenneubewertung
Given I open an editor "mnb-53" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-53b"
And I set field "such" to "SMNB-53b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "53" in the Area "5"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+53b-RE"
And I set field "num4" to "53b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "53" in the Area "5"
#####################################################################################################################################

@FALL-BW54b
Scenario: FALL-BW54b; EK BE_RE.ohneLB_LS_SLS mit Verbuchung; Testumgebung 6
# Storno-Lieferschein bei Rechnung aus Bestellung erlaubt. Rechnung muss noch behandelt werden.

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa6"
And I set field "num4" to "54b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall6" in row 1
And I set field "mge" to "54" in row 1
And I set field "preis" to "54.54" in row 1
And I set field "kenn" to "FALL-BW54b"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "54b-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "54" in row 1
And I set field "preis" to "54" in row 1
And I set field "kenn" to "FALL-BW54b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "54" in the Area "6"

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "54b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "54" in row 1
And I set field "kenn" to "FALL-BW54b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "54" in the Area "6"

# Storno-Lieferschein
# Given opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-1" throws the exception "9312"
Given I open an editor "storno54" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+54b-LS"
And I set field "num4" to "54b-SLS"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "54" in the Area "6"


# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "54b-L2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "54" in row 1
And I set field "kenn" to "FALL-BW54b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "54" in the Area "6"

# Rechnung anlegen -> muss scheitern
Given opening an editor from table "(Purchasing):(Invoice)" with command "NEW" for record from editor "lieferschein-2" throws the exception "40"
And I close the current editor

# Storno-Lieferschein
Given I open an editor "storno54" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+54b-L2"
And I set field "num4" to "54b-SL2"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "54" in the Area "6"

# # TODO: Gutschrift fuer die Rechnung '54b-RE'
# Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# And I set field "beleg" to id from editor "rechnung"
# And I set field "num4" to "54b-GS"
# And I set field "vom" to "."
# And I save the current editor

#####################################################################################################################################

