#***************************************************************************
#
#  Name      : ausschreibung_aus_bv2.feature
#  Datum     : 05.04.17
#  Autor     : mibr
#  Verantw.  : teampss
#
#  Funktion  : Cucumber zum Test von Anfragen und Ausschreibungen aus Bestellvorschlaegen (Teil 2)
#              Wird ausgefuehrt nachdem Konfig swziffer gessetzt wurde (Artikelnummer in der Art {201})
#
#***************************************************************************
@persistent
Feature: Ausschreibung aus BV2
Background: Test von Ausschreibungen aus BV
Given I set the fake date to "02.01.1995"
Given I set saved value "REF_FILE" to "ausschreibung_aus_bv2.out"
Given I set saved value "Feldliste" to "sel, tlief, preisok, mgediff, artikel, tevposstatus, preis, zwaehr, proz, ttterm, tevkopf, anfrposgrp, verw, tevkopf^bsart, tevkopf^rechnung, lbedname, lgruppe, projekt^such"
Given I enable the flag 39

 # ---------------------------------------------------------------------------------------------
 Scenario: Suchwort mit fuehrenden Ziffern aktivieren
 # ---------------------------------------------------------------------------------------------
 Given I open an editor "Firma" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
 And I set field "swziffern" to "ja"
 And I save the current editor

# -----------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-027: Test mit Konfig Suchworte mit Ziffern (swziffer) - Ausschreibung erstellen (inkl. Textpositionen).
# --------------------------------------------------------------------------------------------
# Neue Ausschreibung mit mehreren Gruppen erstellen inkl. Textpositionen
Given I open an editor "AUS99" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I set fields
	| such | ANB.AUS99              |
	| name | ANB.AUS99 Bezeichnung  |
And I append rows
    | tlief | artikel | mge         | verw      |anfrposgrp |
    | 60301 | {80001} |   5         | für Elise | 1         | # Verwendung mit Umlaut
    | 60301 | {80002} |   4         |           | 2         |
    | 60301 |   TEXT  | !dontChange |           | 3         |
    | 60302 | {80001} |   5         |           | 1         |
    | 60302 |   TEXT  | !dontChange |           | 3         |
And I save the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS99V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS99"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
# Then table has values
#     | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
#     | Fremdbeschaffung |                  |              |
#     | Fremdbeschaffung |                  |              |
#     | Fremdbeschaffung |                  |              |
#     | Fremdbeschaffung |                  |              |
#     | Fremdbeschaffung |                  |              |
#     | Fremdbeschaffung |                  |              |
#     | Fremdbeschaffung |                  |              |
And I close the current editor


#--------------------------------------------------------------------------------------------
Scenario: TSQ-AUSS_AUS_BV-028: Ausschreibung anlegen fuer LFV - Suchworte mit Ziffern (swziffer)
#--------------------------------------------------------------------------------------------
# Ausschreibung fuer LFV anlegen, Zeile fuer neuen Lieferanten kopieren, Anfragen erzeugen, Ausschreibung ausgeben
# Lohnfertigungsvorschlaege fuer LF LFANB.ART4 laden und anfragen
Given I open an editor "LV_AENDERN" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I set fields
	| artikel | LFANB.ART4 |
And I press button "ladetab"
And I set field "anfragen" to "ja" in row 1
And I press button "manfragen" to open a subeditor for "AUS98"
# Ausschreibung aus BV bearbeiten und Anfrage fuer Lieferanten 60302 kopieren
And I set fields
	| such | ANB.AUS98              |
	| name | ANB.AUS98 Bezeichnung  |
	| lief | 60302                 |
And I set field "tlief" to "1" in row 1
And I press button "tkopieren" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Ausschreibung ausgeben
Given I open an editor "AUS98V" from table "(BiddingProcess):(BiddingProcess)" with command "VIEW" for record from editor "AUS98"
Then I fill template "EV_AUSS.ftl" and append it to output file "../../ausschreibung_aus_bv.out"
# Felder mit "Daechle" koennen nicht im Tamplate abgefragt werden
# Then table has values
#     | tevkopf^bsart    | tevkopf^rechnung | projekt^such |
#     | Fremdbeschaffung |                  |              |
#     | Fremdbeschaffung |                  |              |
#     | Fremdbeschaffung |                  |              |
#     | Fremdbeschaffung |                  |              |
#     | Fremdbeschaffung |                  |              |
#     | Fremdbeschaffung |                  |              |
#     | Fremdbeschaffung |                  |              |
And I close the current editor


 # ---------------------------------------------------------------------------------------------
 Scenario: Suchwort mit fuehrenden Ziffern wieder deaktivieren
 # ---------------------------------------------------------------------------------------------
 Given I open an editor "Firma" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
 And I set field "swziffern" to "nein"
 And I save the current editor

