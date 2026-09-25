# *****************************************************************************
#  Name             : ref_bw_add_kosten_01_allg.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        :
#  Funktion         : Test der add. Kosten bei den Bewertungen
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    @FALL-CASE_110
#                       Scenario: add.Kosten; EK BE_LS_KM_MNB_RE_R-LS1_KM_R-LS2 mit Verbuchung; Testumgebung 1
#                    @FALL-CASE_120
#                       Scenario: add.Kosten; EK BE_LS_KM_MNB_R-LS_RE mit Verbuchung; Testumgebung 2
#                    @FALL-CASE_55
#                       Scenario: add.Kosten; EK BE_LS_TRE1_KM_R-LS_TRE2_MNB mit Verbuchung; Testumgebung 3
#                    @FALL-CASE_56
#                       Scenario: add.Kosten; EK BE_LS_TRE1_KM_R-LS_TRE2_S-RLS mit Verbuchung; Testumgebung 4
#
#   Ausloeser: BW2-580
#
#
#
# *****************************************************************************

@persistent
Feature: add.Kosten
Background: Test von add. Kosten in der Bewertung
Given I set the fake date to "07.01.2002"

@FALL-CASE_110
Scenario: add.Kosten; EK BE_LS_KM_MNB_RE_R-LS1_KM_R-LS2 mit Verbuchung; Testumgebung 1

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "110" with Price "3.95" in the Area "1"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "110" in the Area "1"
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "110" in the Area "1"

# Kostenumlage (110 Euro)
# zuerst die Frachtrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa1"
And I set field "num4" to "110km1"
And I set field "kenn" to "FALL-110"
And I set field "such" to "KM1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "FRACHT" in row 1
And I set field "pwert" to "110" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "110-KM1"
And I set field "pos" to "$,,kopf^nummer=110km1;art=FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=110-LS;artex=0efall1;mge=110;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "110" in the Area "1"

# Mengenneubewerten (110x2�)
Given I open an editor "mnb-110" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-110"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L110-LS;art=0efall1;buart=1;mge=110;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "2" in row 1
And I save the current editor
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "110" in the Area "1"

# Rechnung fuer komplette Menge
Given I create an invoice for the Test Case "110" with Quantity "110" per Price "4.00" to the PurchasingPackingSlip in the Area "1"
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "110" in the Area "1"

# Ruecklieferschein1 (-10 Stk.)
Given I open an editor "rls-110" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+110-LS"
And I set field "num4" to "110-RLS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-10" in row 1
And I set field "kenn" to "FALL-110 Ruecklieferschein"
And I save the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "110" in the Area "1"

# Kostenumlage (200�)
# zuerst die Versicherungsrechnung anlegen
Given I open an editor "versicherung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa1"
And I set field "num4" to "110km2"
And I set field "kenn" to "FALL-110"
And I set field "such" to "KM2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VERS" in row 1
And I set field "pwert" to "200" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml2" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "110-KM2"
And I set field "pos" to "$,,kopf^nummer=110km2;art=VERS;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=110-LS;artex=0efall1;mge=110;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "110" in the Area "1"

# Ruecklieferschein1 (-50 Stk.)
Given I open an editor "rls-110" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+110-LS"
And I set field "num4" to "110-RLS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-50" in row 1
And I set field "kenn" to "FALL-110 Ruecklieferschein"
And I save the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "110" in the Area "1"
#####################################################################################################################################

@FALL-CASE_120
Scenario: add.Kosten; EK BE_LS_KM_MNB_R-LS_RE mit Verbuchung; Testumgebung 2

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "120" with Price "3.90" in the Area "2"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "120" in the Area "2"
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "120" in the Area "2"

# Kostenumlage (110�)
# zuerst die Frachtrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa2"
And I set field "num4" to "120km1"
And I set field "kenn" to "FALL-120"
And I set field "such" to "KM1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "FRACHT" in row 1
And I set field "pwert" to "110" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "120-KM1"
And I set field "pos" to "$,,kopf^nummer=120km1;art=FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=120-LS;artex=0efall2;mge=120;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "120" in the Area "2"

# Mengenneubewerten (110x1�)
Given I open an editor "mnb-120" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-120"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L120-LS;art=0efall2;buart=1;mge=120;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "1" in row 1
And I save the current editor
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "120" in the Area "2"

# Ruecklieferschein1 (-30 Stk.)
Given I open an editor "rls-120" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "120-LS"
And I set field "num4" to "120-RLS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-120 Ruecklieferschein"
And I save the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "120" in the Area "2"

# Rechnung fuer komplette Menge
# durch Ruecklieferung sind nur 90 moeglich
Given I create an invoice for the Test Case "120" with Quantity "90" per Price "4.00" to the PurchasingPackingSlip in the Area "2"
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "120" in the Area "2"
#####################################################################################################################################

@FALL-CASE_55
Scenario: add.Kosten; EK BE_LS_TRE1_KM_R-LS_TRE2_MNB mit Verbuchung; Testumgebung 3

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "55" with Price "22" in the Area "3"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "55" in the Area "3"
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "55" in the Area "3"

# Teil-Rechnung1 fuer 5 Stk
Given I create an invoice for the Test Case "55" with Quantity "5" per Price "21.00" to the PurchasingPackingSlip in the Area "3"
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "55" in the Area "3"

# Kostenumlage (30�)
# zuerst die Frachtrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa3"
And I set field "num4" to "55km1"
And I set field "kenn" to "FALL-55"
And I set field "such" to "KM1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "FRACHT" in row 1
And I set field "pwert" to "30" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen -> auf Lieferschein
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "55-KM1"
And I set field "pos" to "$,,kopf^nummer=55km1;art=FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=55-LS;artex=0efall3;mge=55;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "55" in the Area "3"

# Ruecklieferschein1 (-40 Stk.)
Given I open an editor "rls-55" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "55-LS"
And I set field "num4" to "55-RLS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-55 Ruecklieferschein"
And I save the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "55" in the Area "3"

# Teil-Rechnung2 fuer 10 Stk
# nur 10 Stk sind moeglich: 55 (geliefert) - 40 (zurueck geliefert) - 5 (Teil-Rechnung1)
Given I create an invoice for the Test Case "55" with Quantity "10" per Price "23.00" to the PurchasingPackingSlip in the Area "3"
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "55" in the Area "3"

# Mengenneubewerten (10x0.1� + 5x0.1�)
Given I open an editor "mnb-55" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-55"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L55-LS;art=0efall3;buart=1;mge=55;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
Then the table has 2 rows
# Zeile 1
Then field "tmge" has value "10" in row 1
Then field "tbewpr" has value "25.0000" in row 1
Then field "ntbewpr" has value "25.0000" in row 1
Then field "bewertet" has value "direkt" in row 1
And I set field "ntbewpr" to "0.10" in row 1
# Zeile 2
Then field "tmge" has value "5" in row 2
Then field "tbewpr" has value "23.0000" in row 2
Then field "ntbewpr" has value "23.0000" in row 2
Then field "bewertet" has value "direkt" in row 2
And I set field "ntbewpr" to "0.10" in row 2
And I save the current editor
And I close the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "55" in the Area "3"
#####################################################################################################################################

@FALL-CASE_56
Scenario: add.Kosten; EK BE_LS_TRE1_KM_R-LS_TRE2_S-RLS mit Verbuchung; Testumgebung 4

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "56" with Price "22" in the Area "4"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "56" in the Area "4"
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "56" in the Area "4"

# Teil-Rechnung1 fuer 20 Stk
Given I create an invoice for the Test Case "56" with Quantity "20" per Price "21.00" to the PurchasingPackingSlip in the Area "4"
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "56" in the Area "4"

# Kostenumlage (30�)
# zuerst die Frachtrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa4"
And I set field "num4" to "56km1"
And I set field "kenn" to "FALL-56"
And I set field "such" to "KM1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "FRACHT" in row 1
And I set field "pwert" to "30" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "56-KM1"
And I set field "pos" to "$,,kopf^nummer=56km1;art=FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=56-LS;artex=0efall4;mge=56;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "56" in the Area "4"

# Ruecklieferschein1 (-30 Stk.)
Given I open an editor "rls-56" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "56-LS"
And I set field "num4" to "56-RLS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-56 Ruecklieferschein"
And I save the current editor
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "56" in the Area "4"

# Teil-Rechnung2 fuer 6 Stk: 56(geliefert) - 30(zurueckgeliefet) - 20(Teil-Rechnung1)
Given I create an invoice for the Test Case "56" with Quantity "6" per Price "25.00" to the PurchasingPackingSlip in the Area "4"
# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "56" in the Area "4"

# Storno Rücklieferschein
Given I open an editor "storno-RLS" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "rls-56"
And I set field "num4" to "56-SRLS"
And I save the current editor
