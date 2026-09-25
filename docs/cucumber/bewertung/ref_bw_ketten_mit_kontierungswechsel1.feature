# *****************************************************************************
#  Name             : ref_bw_ketten_mit_kontierungswechsel1.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        : 
#  Funktion         : testet STORNO von EK-RE und MNB;
#                     Faelle, wo es zu Kontierungswechsel kommen kann
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#                    Testumgebung 1: Scenario: FALL-BW21a; EK BE_LS.vorl_MNB.vorl_RE_SRE_SMNB_SLS  ohne Verbuchung
#                    Testumgebung 2: Scenario: FALL-BW21b; EK BE_LS.vorl_MNB.vorl_RE_SRE_SMNB_SLS  mit Verbuchung
#                    Testumgebung 3: Scenario: FALL-BW25a; EK BE_LS.vorl_MNB.vorl_SMNB_RE_SRE      ohne Verbuchung
#                    Testumgebung 4: Scenario: FALL-BW25b; EK BE_LS.vorl_MNB.vorl_SMNB_RE_SRE      mit Verbuchung
#                    Testumgebung 5: Scenario: FALL-BW19a; EK BE_LS.vorl_MNB.vorl_RE_SRE           ohne Verbuchung
#                    Testumgebung 6: Scenario: FALL-BW19b; EK BE_LS.vorl_MNB.vorl_RE_SRE           mit Verbuchung
#
# *****************************************************************************

@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "07.01.2002"


@FALL-BW21a
Scenario: FALL-BW21a; EK BE_LS.vorl_MNB.vorl_RE_SRE_SMNB_SLS ohne Verbuchung; Testumgebung 1

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa1"
And I set field "num4" to "21a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall1" in row 1
And I set field "mge" to "21" in row 1
And I set field "preis" to "21.21" in row 1
And I set field "kenn" to "FALL-BW21a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "21a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "21" in row 1
And I set field "kenn" to "FALL-BW21a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-21a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-21a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L21a-LS;art=0efall1;buart=1;mge=21;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "40" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "21a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "21" in row 1
And I set field "preis" to "42" in row 1
And I set field "kenn" to "FALL-BW21a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+21a-RE"
And I set field "num4" to "21a-STRE"
And I save the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-21" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-21a"
And I set field "such" to "SMNB-21a"
And I save the current editor
And I close the current editor

# Storno-Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "21a-LS"
And I set field "num4" to "21a-STLS"
And I save the current editor
#####################################################################################################################################

@FALL-BW21b
Scenario: FALL-BW21b; EK BE_LS.vorl_MNB.vorl_RE_SRE_SMNB_SLS mit Verbuchung; Testumgebung 2

# Bestellung anlegen
Given I open an editor "bestellung-2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa2"
And I set field "num4" to "21b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall2" in row 1
And I set field "mge" to "21" in row 1
And I set field "preis" to "21.21" in row 1
And I set field "kenn" to "FALL-BW21b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2"
And I set field "num4" to "21b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "21" in row 1
And I set field "kenn" to "FALL-BW21b"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-BW21b"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
And I set field "vart" to "0efall2"
And I press button "kosvor"
And I respond with answer "JA" to the dialog with id "2324"
# 5567 ist nur das Fragewort Weiter?, JEDOCH SIND EIGENTLICH FOLGENDE FRAGEN INHALTLICH ENTSCHEIDEND, DIE HIER ANGEZEIGT WERDEN MUESSEN!
# Kostenbuchungen ab Startdatum %s erzeugen. oder...
# Kostenbuchungsvorschlag speichern und Startdatum auf den %s setzen.
And I respond with answer "yes" to the dialog with id "5567"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-21" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-21b" 
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L21b-LS;art=0efall2;buart=1;mge=21;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "40" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-BW21b"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
And I set field "vart" to "0efall2"
And I press button "kosvor"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2"
And I set field "num4" to "21b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "21" in row 1
And I set field "preis" to "42" in row 1
And I set field "kenn" to "FALL-BW21b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-BW21b"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
And I set field "vart" to "0efall2"
And I press button "kosvor"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+21b-RE"
And I set field "num4" to "21b-STRE"
And I save the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-21" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-21b"
And I set field "such" to "SMNB-21b" 
And I save the current editor
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-BW21b"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
And I set field "vart" to "0efall2"
And I press button "kosvor"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor

# Storno-Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "21b-LS"
And I set field "num4" to "21b-STLS"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-BW21b"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
And I set field "vart" to "0efall2"
And I press button "kosvor"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor
#####################################################################################################################################

@FALL-BW25a
Scenario: FALL-BW25a; EK BE_LS.vorl_MNB.vorl_SMNB_RE_SRE ohne Verbuchung; Testumgebung 3

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa3"
And I set field "num4" to "25a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall3" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "25.25" in row 1
And I set field "kenn" to "FALL-BW25a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "25a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "25" in row 1
And I set field "kenn" to "FALL-BW25a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-25a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-25a" 
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L25a-LS;art=0efall3;buart=1;mge=25;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "50" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-25" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-25a"
And I set field "such" to "SMNB-25a" 
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "25a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "25" in row 1
And I set field "preis" to "25" in row 1
And I set field "kenn" to "FALL-BW25a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+25a-RE"
And I set field "num4" to "25a-STRE"
And I save the current editor
#####################################################################################################################################

@FALL-BW25b
Scenario: FALL-BW25b; EK BE_LS.vorl_MNB.vorl_SMNB_RE_SRE mit Verbuchung; Testumgebung 4

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa4"
And I set field "num4" to "25b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall4" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "25.25" in row 1
And I set field "kenn" to "FALL-BW25b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "25b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "25" in row 1
And I set field "kenn" to "FALL-BW25b"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-BW25b"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
And I set field "vart" to "0efall4"
And I press button "kosvor"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-25b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-25b" 
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L25b-LS;art=0efall4;buart=1;mge=25;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "50" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-BW25b"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
And I set field "vart" to "0efall4"
And I press button "kosvor"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor

# Storno-Mengenneubewertung
Given I open an editor "mnb-25" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-25b"
And I set field "such" to "SMNB-25b" 
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "25b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "25" in row 1
And I set field "preis" to "25" in row 1
And I set field "kenn" to "FALL-BW25b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-BW25b"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
And I set field "vart" to "0efall4"
And I press button "kosvor"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+25b-RE"
And I set field "num4" to "25b-STRE"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-BW25b"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
And I set field "vart" to "0efall4"
And I press button "kosvor"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor
#####################################################################################################################################

@FALL-BW19a
Scenario: FALL-BW19a; EK BE_LS.vorl_MNB.vorl_RE_SRE ohne Verbuchung; Testumgebung 5

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa5"
And I set field "num4" to "19a-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall5" in row 1
And I set field "mge" to "19" in row 1
And I set field "preis" to "19.19" in row 1
And I set field "kenn" to "FALL-BW19a"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "19a-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "19" in row 1
And I set field "kenn" to "FALL-BW19a"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-19a" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-19a"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L19a-LS;art=0efall5;buart=1;mge=19;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "19a-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "19" in row 1
And I set field "preis" to "19" in row 1
And I set field "kenn" to "FALL-BW19a"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+19a-RE"
And I set field "num4" to "19a-STRE"
And I save the current editor
#####################################################################################################################################

@FALL-BW19b
Scenario: FALL-BW19b; EK BE_LS.vorl_MNB.vorl_RE_SRE mit Verbuchung; Testumgebung 6

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa6"
And I set field "num4" to "19b-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall6" in row 1
And I set field "mge" to "19" in row 1
And I set field "preis" to "19.19" in row 1
And I set field "kenn" to "FALL-BW19b"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "19b-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "19" in row 1
And I set field "kenn" to "FALL-BW19b"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-BW19b"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
And I set field "vart" to "0efall6"
And I press button "kosvor"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor

# Mengenneubewertung
Given I open an editor "mnb-19b" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-19b"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L19b-LS;art=0efall6;buart=1;mge=19;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "38" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-BW19b"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
And I set field "vart" to "0efall6"
And I press button "kosvor"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "19b-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "19" in row 1
And I set field "preis" to "19" in row 1
And I set field "kenn" to "FALL-BW19b"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-BW19b"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
And I set field "vart" to "0efall6"
And I press button "kosvor"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+19b-RE"
And I set field "num4" to "19b-STRE"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Materialkostenverbuchung
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-BW19b"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
And I set field "vart" to "0efall6"
And I press button "kosvor"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor
#####################################################################################################################################

