# *****************************************************************************
#  Name             : ref_bw_ketten_mit_kontierungswechsel_sonder.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : testet STORNO von EK-RE und MNB unter 'Sonder'-Bedingungen
#
#                    kurze Zusammenfassung von Bewertungsketten:
#                    ===========================================
#                     Testumgebung  1: Scenario: FALL-BW400; EK BE.ausland_LS.vorl_RE.inland_SRE                mit Verbuchung
#                     Testumgebung  2: Scenario: FALL-BW401; EK BE.ausland_LS.vorl_MNB_RE.inland_SRE            mit Verbuchung
#                     Testumgebung  3: Scenario: FALL-BW402; EK BE.ausland_LS.vorl_MNB_RE.inland_SRE_SMNB       mit Verbuchung
#                     Testumgebung  4: Scenario: FALL-BW403; EK BE.ausland_LS.unbew_MNB.vorl_RE.inland_SRE_SMNB mit Verbuchung
#                     Testumgebung  5: Scenario: FALL-BW404; EK BE.ausland_LS.unbew_RE.inland_SRE               mit Verbuchung
#                     * leer *
#                     Testumgebung 10: Scenario: FALL-BW420; EK BE_LS1.vorl_LS2.vorl_LS3.vorl_RE_SRE            mit Verbuchung
#                     Testumgebung 11: Scenario: FALL-BW421; EK BE_LS1.vorl_LS2.vorl_RE_LS3.vorl_SRE            mit Verbuchung
#                     Testumgebung 12+13: Scenario: FALL-WG_Wechsel; ...                                        mit Verbuchung
#
# *****************************************************************************

@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "07.01.2002"


@FALL-BW400
Scenario: FALL-BW400; EK BE.ausland_LS.vorl_RE.inland_SRE mit Verbuchung; Testumgebung 1

# Bestellung anlegen -> Ausland
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "004fa1"
And I set field "num4" to "400-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall1" in row 1
And I set field "mge" to "400" in row 1
And I set field "preis" to "21.21" in row 1
And I set field "kenn" to "FALL-BW400"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "400-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "400" in row 1
And I set field "kenn" to "FALL-BW400"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "400" in the Area "1"

# Rechnung anlegen -> doch Inland
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "400-RE"
And I set field "lief" to "001fa1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "230" in row 1
And I set field "preis" to "25" in row 1
And I set field "kenn" to "FALL-BW400"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "400" in the Area "1"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+400-RE"
And I set field "num4" to "400-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "400" in the Area "1"
#####################################################################################################################################

@FALL-BW401
Scenario: FALL-BW401; EK BE.ausland_LS.vorl_MNB_RE.inland_SRE mit Verbuchung; Testumgebung 2

# Bestellung anlegen -> Ausland
Given I open an editor "bestellung-401" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "004fa2"
And I set field "num4" to "401-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall2" in row 1
And I set field "mge" to "401" in row 1
And I set field "preis" to "21.21" in row 1
And I set field "kenn" to "FALL-BW401"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-401"
And I set field "num4" to "401-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "401" in row 1
And I set field "kenn" to "FALL-BW401"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "401" in the Area "2"

# Mengenneubewertung
Given I open an editor "mnb-401" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-401"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L401-LS;art=0efall2;buart=1;mge=401;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "401" in the Area "2"

# Rechnung anlegen -> doch Inland
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "401-RE"
And I set field "lief" to "001fa2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "230" in row 1
And I set field "preis" to "25" in row 1
And I set field "kenn" to "FALL-BW401"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "401" in the Area "2"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+401-RE"
And I set field "num4" to "401-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "401" in the Area "2"
#####################################################################################################################################

@FALL-BW402
Scenario: FALL-BW402; EK BE.ausland_LS.vorl_MNB_RE.inland_SRE_SMNB mit Verbuchung; Testumgebung 3

# Bestellung anlegen -> Ausland
Given I open an editor "bestellung-402" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "004fa3"
And I set field "num4" to "402-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall3" in row 1
And I set field "mge" to "402" in row 1
And I set field "preis" to "21.21" in row 1
And I set field "kenn" to "FALL-BW402"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-402"
And I set field "num4" to "402-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "402" in row 1
And I set field "kenn" to "FALL-BW402"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "402" in the Area "3"

# Mengenneubewertung
Given I open an editor "mnb-402" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-402"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L402-LS;art=0efall3;buart=1;mge=402;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "402" in the Area "3"

# Rechnung anlegen -> doch Inland
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "402-RE"
And I set field "lief" to "001fa3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "230" in row 1
And I set field "preis" to "25" in row 1
And I set field "kenn" to "FALL-BW402"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "402" in the Area "3"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+402-RE"
And I set field "num4" to "402-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "402" in the Area "3"

# Storno-Mengenneubewertung
Given I open an editor "mnb-402" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-402"
And I set field "such" to "SMNB-402"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "402" in the Area "3"
#####################################################################################################################################

@FALL-BW403
Scenario: FALL-BW403; EK BE.ausland_LS.unbew_MNB.vorl_RE.inland_SRE_SMNB mit Verbuchung; Testumgebung 4

# Bestellung anlegen -> Ausland
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "004fa4"
And I set field "num4" to "403-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall4" in row 1
And I set field "mge" to "403" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW403"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "403-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "403" in row 1
And I set field "kenn" to "FALL-BW403"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "403" in the Area "4"

# Mengenneubewertung
Given I open an editor "mnb-403" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-403"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,such=L403-LS;art=0efall4;buart=1;mge=403;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "77" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "403" in the Area "4"

# Rechnung anlegen -> doch Inland
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "403-RE"
And I set field "lief" to "001fa4"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "230" in row 1
And I set field "preis" to "25" in row 1
And I set field "kenn" to "FALL-BW403"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "403" in the Area "4"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+403-RE"
And I set field "num4" to "403-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "403" in the Area "4"

# Storno-Mengenneubewertung
Given I open an editor "mnb-403" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNB-403"
And I set field "such" to "SMNB-403"
And I save the current editor
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "403" in the Area "4"
#####################################################################################################################################

@FALL-BW404
Scenario: FALL-BW404; EK BE.ausland_LS.unbew_RE.inland_SRE mit Verbuchung; Testumgebung 5

# Bestellung anlegen -> Ausland
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "004fa5"
And I set field "num4" to "404-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall5" in row 1
And I set field "mge" to "404" in row 1
And I set field "preis" to "0.00" in row 1
And I set field "kenn" to "FALL-BW404"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "404-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "404" in row 1
And I set field "kenn" to "FALL-BW404"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "404" in the Area "5"

# Rechnung anlegen -> doch Inland
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "404-RE"
And I set field "lief" to "001fa5"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "230" in row 1
And I set field "preis" to "25" in row 1
And I set field "kenn" to "FALL-BW404"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "404" in the Area "5"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+404-RE"
And I set field "num4" to "404-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "404" in the Area "5"
#####################################################################################################################################

@FALL-BW420
Scenario: FALL-BW420; EK BE_LS1.vorl_LS2.vorl_LS3.vorl_RE_SRE mit Verbuchung; Testumgebung 10

# Bestellung anlegen
Given I open an editor "bestellung-10" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa10"
And I set field "num4" to "420-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall10" in row 1
And I set field "mge" to "300" in row 1
And I set field "preis" to "21.21" in row 1
And I set field "kenn" to "FALL-BW420"
And I save the current editor

# Lieferschein 1 zu Bestellung anlegen
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-10"
And I set field "num4" to "420-LS1"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "45" in row 1
And I set field "kenn" to "FALL-BW420"
And I save the current editor

# Lieferschein 2 zu Bestellung anlegen
Given I open an editor "lieferschein-3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-10"
And I set field "num4" to "420-LS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "125" in row 1
And I set field "kenn" to "FALL-BW420"
And I save the current editor

# Lieferschein 3 zu Bestellung anlegen
Given I open an editor "lieferschein-4" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-10"
And I set field "num4" to "420-LS3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "130" in row 1
And I set field "kenn" to "FALL-BW420"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "420" in the Area "10"

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-10"
And I set field "num4" to "420-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "300" in row 1
And I set field "preis" to "42" in row 1
And I set field "kenn" to "FALL-BW420"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "420" in the Area "10"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+420-RE"
And I set field "num4" to "420-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "420" in the Area "10"
#####################################################################################################################################

@FALL-BW421
Scenario: FALL-BW421; EK BE_LS1.vorl_LS2.vorl_RE_LS3.vorl_SRE mit Verbuchung; Testumgebung 11

# Bestellung anlegen
Given I open an editor "bestellung-11" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa11"
And I set field "num4" to "421-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall11" in row 1
And I set field "mge" to "300" in row 1
And I set field "preis" to "21.21" in row 1
And I set field "kenn" to "FALL-BW421"
And I save the current editor

# Lieferschein 1 zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-11"
And I set field "num4" to "421-LS1"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "45" in row 1
And I set field "kenn" to "FALL-BW421"
And I save the current editor

# Lieferschein 2 zu Bestellung anlegen
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-11"
And I set field "num4" to "421-LS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "125" in row 1
And I set field "kenn" to "FALL-BW421"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-11"
And I set field "num4" to "421-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "300" in row 1
And I set field "preis" to "42" in row 1
And I set field "kenn" to "FALL-BW421"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "421" in the Area "11"

# Lieferschein 3 zu Bestellung anlegen
Given I open an editor "lieferschein-3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-11"
And I set field "num4" to "421-LS3"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "130" in row 1
And I set field "kenn" to "FALL-BW421"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "421" in the Area "11"

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+421-RE"
And I set field "num4" to "421-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "421" in the Area "11"
#####################################################################################################################################

@FALL-WG_Wechsel
Scenario: FALL-WG_Wechsel; EK BE_LS1.vorl_WG.Wechsel_LS2.vorl_LS3.vorl_RE_SRE mit Verbuchung; Testumgebung 12 + 13
# Ablauf:
# Bestellung anlegen
# Lieferschein 1 zu Bestellung anlegen und gebucht
# Lieferschein 2 zu Bestellung anlegen
# Nachbewerten + Kostenverbuchung(alles)
# Warengruppe austauschen
# Lieferschein 2 zu Bestellung verbuchen
# Lieferschein 3 zu Bestellung anlegen + verbuchen
# Nachbewerten + Kostenverbuchung(alles)
# Rechnung anlegen + verbuchen
# Nachbewerten + Kostenverbuchung(alles)
# Storno Rechnung
# Nachbewerten + Kostenverbuchung(alles)
# Storno LS 3
# Nachbewerten + Kostenverbuchung(alles)
# Ruecklieferschein1 zu LS 1 anlegen
# Nachbewerten + Kostenverbuchung(alles)
# Storno RLS1
# Nachbewerten + Kostenverbuchung(alles)


# Bestellung anlegen
Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001fa12"
And I set field "num4" to "430-BE"
And I create a new row at the end of the table
And I set field "artex" to "0efall12" in row 1
And I set field "mge" to "300" in row 1
And I set field "preis" to "1.21" in row 1
And I set field "kenn" to "FALL-WG_Wechsel"
And I save the current editor

# Lieferschein 1 zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "num4" to "430-LS1"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "45" in row 1
And I set field "kenn" to "FALL-WG_Wechsel"
And I save the current editor

# Lieferschein 2 zu Bestellung anlegen
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "num4" to "430-LS2"
And I set field "ueb" to "nein"
And I set field "vom" to "."
And I set field "mge" to "125" in row 1
And I set field "kenn" to "FALL-WG_Wechsel"
And I save the current editor

#
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

#
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "0efall12"
And I set field "wgruppe" to "55FALL13"
And I save the current editor
And I close the current editor


# Lieferschein 2 zu Bestellung verbuchen
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "430-LS2"
And I set field "ueb" to "ja"
And I save the current editor
And I close the current editor

# Lieferschein 3 zu Bestellung anlegen
Given I open an editor "lieferschein-3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "num4" to "430-LS3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "130" in row 1
And I set field "kenn" to "FALL-WG_Wechsel"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "num4" to "430-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "300" in row 1
And I set field "preis" to "42" in row 1
And I set field "kenn" to "FALL-WG_Wechsel"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+430-RE"
And I set field "num4" to "430-STRE"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Storno LS 3
Given I open an editor "rechnung" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+430-LS3"
And I set field "num4" to "430-ST3"
And I save the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Ruecklieferschein1 anlegen
Given I open an editor "rls" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1"
And I set field "num4" to "430-RLS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-WG_Wechsel,"
And I set field "mge" to "-45" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Storno RLS1
Given I open an editor "rechnung" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+430-RLS1"
And I set field "num4" to "430-STOR"
And I save the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
###########################################################################################################################################
