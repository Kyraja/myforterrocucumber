# *****************************************************************************
#  Name             : ref_bw_ketten_mit_kontierungswechsel6.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        : 
#  Funktion         : testet STORNO von EK-RE und MNB;
#                     Faelle, wo es zu Kontierungswechsel kommen kann
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#                    Testumgebung 10: Scenario: FALL-BW57b; EK BE_LS.vorl_TRE1_MNB_SMNB_STRE1                  mit Verbuchung
#                    Testumgebung 11: Scenario: FALL-BW59b; EK BE_LS.vorl_TRE1_MNB_SMNB_STRE1_SLS              mit Verbuchung
#                    Testumgebung 12: Scenario: FALL-BW60b; EK BE_LS.vorl_TRE1_MNB_STRE1.fehler                mit Verbuchung
#                    Testumgebung 13: Scenario: FALL-BW61b; EK BE_LS.vorl_TRE1_MNB_STRE1.fehler_SMNB_STRE1     mit Verbuchung
#                    Testumgebung 14: Scenario: FALL-BW62b; EK BE_LS.vorl_TRE1_MNB_STRE1.fehler_SMNB_STRE1_SLS mit Verbuchung
#                    Testumgebung 15: Scenario: FALL-BW63b; EK BE_LS.vorl_TRE1_STRE1_MNB                       mit Verbuchung
#                    Testumgebung 16: Scenario: FALL-BW64b; EK BE_LS.vorl_TRE1_STRE1_MNB_SMNB                  mit Verbuchung
#                    Testumgebung 17: Scenario: FALL-BW65b; EK BE_LS.vorl_TRE1_STRE1_MNB_SMNB_SLS              mit Verbuchung
#
# *****************************************************************************
@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "07.01.2002"


@FALL-BW57b
Scenario: FALL-BW57b; EK BE_LS.vorl_TRE1_MNB_SMNB_STRE1 mit Verbuchung; Testumgebung 10

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa10"
And I set field "num4" to "57b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall10" in row 1
And I set field "mge" to "57" in row 1
And I set field "preis" to "57.57" in row 1
And I set field "kenn" to "FALL-BW57b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "57b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "57" in row 1
And I set field "kenn" to "FALL-BW57b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "57" in the Area "10"

# Teil-Rechnung mit Menge 7 und Preis 37.17 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "57b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "7" in row 1
And I set field "preis" to "37.17" in row 1
And I set field "kenn" to "FALL-BW57b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "57" in the Area "10"

# Mengenneubewertung
Given I open an editor "mnb-57b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-57b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L57b-LS;art=0efall10;buart=1;mge=57;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "114" in row 1
And I set field "ntbewpr" to "111" in row 2
# And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "57" in the Area "10"

# Storno-Mengenneubewertung
Given I open an editor "mnb-57" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-57b"
And I set field "such" to "SMNB-57b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "57" in the Area "10"

# Storno Teil-Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+57b-TRE1"
And I set field "num4" to "57b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "57" in the Area "10"
#####################################################################################################################################

@FALL-BW59b
Scenario: FALL-BW59b; EK BE_LS.vorl_TRE1_MNB_SMNB_STRE1_SLS mit Verbuchung; Testumgebung 11

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa11"
And I set field "num4" to "59b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall11" in row 1
And I set field "mge" to "59" in row 1
And I set field "preis" to "59.59" in row 1
And I set field "kenn" to "FALL-BW59b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "59b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "59" in row 1
And I set field "kenn" to "FALL-BW59b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "59" in the Area "11"

# Teil-Rechnung mit Menge 19 und Preis 60.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "59b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "19" in row 1
And I set field "preis" to "60" in row 1
And I set field "kenn" to "FALL-BW59b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "59" in the Area "11"

# Mengenneubewertung
Given I open an editor "mnb-59b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-59b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L59b-LS;art=0efall11;buart=1;mge=59;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "118" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "59" in the Area "11"

# Storno-Mengenneubewertung
Given I open an editor "mnb-59" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-59b"
And I set field "such" to "SMNB-59b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "59" in the Area "11"

# Storno Teil-Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+59b-TRE1"
And I set field "num4" to "59b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "59" in the Area "11"

# Storno-Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "59b-LS"
And I set field "num4" to "59b-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "59" in the Area "11"
#####################################################################################################################################

@FALL-BW60b
Scenario: FALL-BW60b; EK BE_LS.vorl_TRE1_MNB_STRE1.fehler mit Verbuchung; Testumgebung 12

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa12"
And I set field "num4" to "60b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall12" in row 1
And I set field "mge" to "60" in row 1
And I set field "preis" to "60.60" in row 1
And I set field "kenn" to "FALL-BW60b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "60b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "60" in row 1
And I set field "kenn" to "FALL-BW60b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "60" in the Area "12"

# Teil-Rechnung mit Menge 20 und Preis 15.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "60b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
And I set field "preis" to "15" in row 1
And I set field "kenn" to "FALL-BW60b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "60" in the Area "12"

# Mengenneubewertung
Given I open an editor "mnb-60b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-60b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L60b-LS;art=0efall12;buart=1;mge=60;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "120" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "60" in the Area "12"

# Storno Teil-Rechnung -> Fehlerfall
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung" throws the exception "3335"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "60" in the Area "12"
#####################################################################################################################################

@FALL-BW61b
Scenario: FALL-BW61b; EK BE_LS.vorl_TRE1_MNB_STRE1.fehler_SMNB_STRE1 mit Verbuchung; Testumgebung 13

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa13"
And I set field "num4" to "61b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall13" in row 1
And I set field "mge" to "61" in row 1
And I set field "preis" to "61.61" in row 1
And I set field "kenn" to "FALL-BW61b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "61b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "61" in row 1
And I set field "kenn" to "FALL-BW61b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "61" in the Area "13"

# Teil-Rechnung mit Menge 21 und Preis 20.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "61b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "21" in row 1
And I set field "preis" to "20" in row 1
And I set field "kenn" to "FALL-BW61b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "61" in the Area "13"

# Mengenneubewertung
Given I open an editor "mnb-61b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-61b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L61b-LS;art=0efall13;buart=1;mge=61;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "118" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "61" in the Area "13"

# Storno Teil-Rechnung -> Fehler
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung" throws the exception "3335"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "61" in the Area "13"

# Storno-Mengenneubewertung
Given I open an editor "mnb-61" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-61b"
And I set field "such" to "SMNB-61b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "61" in the Area "13"

# Storno Teil-Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+61b-TRE1"
And I set field "num4" to "61b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "61" in the Area "13"
#####################################################################################################################################

@FALL-BW62b
Scenario: FALL-BW62b; EK BE_LS.vorl_TRE1_MNB_STRE1.fehler_SMNB_STRE1_SLS mit Verbuchung; Testumgebung 14

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa14"
And I set field "num4" to "62b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall14" in row 1
And I set field "mge" to "62" in row 1
And I set field "preis" to "62.62" in row 1
And I set field "kenn" to "FALL-BW62b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "62b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "62" in row 1
And I set field "kenn" to "FALL-BW62b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "62" in the Area "14"

# Teil-Rechnung mit Menge 22 und Preis 20.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "62b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "22" in row 1
And I set field "preis" to "20" in row 1
And I set field "kenn" to "FALL-BW62b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "62" in the Area "14"

# Mengenneubewertung
Given I open an editor "mnb-62b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-62b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L62b-LS;art=0efall14;buart=1;mge=62;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38.38" in row 1
And I set field "ntbewpr" to "118" in row 2
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "62" in the Area "14"

# Storno Teil-Rechnung -> Fehler
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung" throws the exception "3335"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "62" in the Area "14"

# Storno-Mengenneubewertung
Given I open an editor "mnb-62" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-62b"
And I set field "such" to "SMNB-62b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "62" in the Area "14"

# Storno Teil-Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+62b-TRE1"
And I set field "num4" to "62b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "62" in the Area "14"

# Storno-Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "62b-LS"
And I set field "num4" to "62b-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "62" in the Area "14"
#####################################################################################################################################

@FALL-BW63b
Scenario: FALL-BW63b; EK BE_LS.vorl_TRE1_STRE1_MNB mit Verbuchung; Testumgebung 15

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa15"
And I set field "num4" to "63b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall15" in row 1
And I set field "mge" to "63" in row 1
And I set field "preis" to "63.63" in row 1
And I set field "kenn" to "FALL-BW63b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "63b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "63" in row 1
And I set field "kenn" to "FALL-BW63b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "63" in the Area "15"

# Teil-Rechnung mit Menge 23 und Preis 20.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "63b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "23" in row 1
And I set field "preis" to "20" in row 1
And I set field "kenn" to "FALL-BW63b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "63" in the Area "15"

# Storno Teil-Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+63b-TRE1"
And I set field "num4" to "63b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "63" in the Area "15"

# Mengenneubewertung
Given I open an editor "mnb-63b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-63b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L63b-LS;art=0efall15;buart=1;mge=63;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "111" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "63" in the Area "15"
#####################################################################################################################################

@FALL-BW64b
Scenario: FALL-BW64b; EK BE_LS.vorl_TRE1_STRE1_MNB_SMNB mit Verbuchung; Testumgebung 16

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa16"
And I set field "num4" to "64b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall16" in row 1
And I set field "mge" to "64" in row 1
And I set field "preis" to "64.64" in row 1
And I set field "kenn" to "FALL-BW64b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "64b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "64" in row 1
And I set field "kenn" to "FALL-BW64b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "64" in the Area "16"

# Teil-Rechnung mit Menge 24 und Preis 20.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "64b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "24" in row 1
And I set field "preis" to "20" in row 1
And I set field "kenn" to "FALL-BW64b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "64" in the Area "16"

# Storno Teil-Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+64b-TRE1"
And I set field "num4" to "64b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "64" in the Area "16"

# Mengenneubewertung
Given I open an editor "mnb-64b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-64b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L64b-LS;art=0efall16;buart=1;mge=64;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "111" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "64" in the Area "16"

# Storno-Mengenneubewertung
Given I open an editor "mnb-64" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-64b"
And I set field "such" to "SMNB-64b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "64" in the Area "16"
#####################################################################################################################################

@FALL-BW65b
Scenario: FALL-BW65b; EK BE_LS.vorl_TRE1_STRE1_MNB_SMNB_SLS mit Verbuchung; Testumgebung 17

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa17"
And I set field "num4" to "65b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall17" in row 1
And I set field "mge" to "65" in row 1
And I set field "preis" to "65.65" in row 1
And I set field "kenn" to "FALL-BW65b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "65b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "65" in row 1
And I set field "kenn" to "FALL-BW65b"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "65" in the Area "17"

# Teil-Rechnung mit Menge 25 und Preis 20.00 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "65b-TRE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "25" in row 1
And I set field "preis" to "20" in row 1
And I set field "kenn" to "FALL-BW65b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "65" in the Area "17"

# Storno Teil-Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+65b-TRE1"
And I set field "num4" to "65b-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "65" in the Area "17"

# Mengenneubewertung
Given I open an editor "mnb-65b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-65b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L65b-LS;art=0efall17;buart=1;mge=65;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "111" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "65" in the Area "17"

# Storno-Mengenneubewertung
Given I open an editor "mnb-65" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-65b"
And I set field "such" to "SMNB-65b"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "65" in the Area "17"

# Storno-Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "65b-LS"
And I set field "num4" to "65b-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "65" in the Area "17"
#####################################################################################################################################
