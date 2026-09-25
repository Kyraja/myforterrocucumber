# *****************************************************************************
#  Name             : ref_bw_add_kosten_05_umlagern.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        :
#  Funktion         : Test der add. Kosten bei Umlagerungen
#
#             Faelle:
#                * @FALL-490: Transportkosten bei Umlagerung
#                * @FALL-500: Transportkosten bei Umlagerung + add. Kosten auf OriginalZugang
#
#
# *****************************************************************************

@persistent
Feature: add.Kosten
Background: Test von add. Kosten in der Bewertung
Given I set the fake date to "07.02.2002"

# @FALL-490 add.Kosten bei Umlagerung
Scenario: 01 Artikel einkaufen; Testumgebung 49

# Artikel einkaufen
Given I open an editor "RechnungmLZu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 49zu     |
    | lief     | 001fa49  |
    | vom      | .        |
    | ebeleg   | Zugang49 |
    | ueb      | ja       |
    | fakt     | ja       |
And I append rows
    | artikel   | mge | preis |platz |
    | 0efall49  | 20  | 5.00  | F1   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "FALL-490" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Transportkosten bezahlen
Given I open an editor "RechnungmLUm" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 49um       |
    | bsart    | Umlagern   |
    | lief     | 004fa49    |
    | vom      | .          |
    | ebeleg   | Umlagern49 |
    | ueb      | ja         |
    | fakt     | ja         |
    | erfwaehr | EUR        |
And I append rows
    | artikel   | mge | preis | abplatz | platz |
    | 0efall49  | 20  |  1.00 | F1      | L3F1  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "FALL-490" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Ruecklieferung auf Original-Zugang
Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set field "nummer" to "49rueck"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-15" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "490" in the Area "49"

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "FALL-490" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Ruecklieferung stornieren
Given I open an editor "RueckStorno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung"
And I set field "nummer" to "49storno"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "490" in the Area "49"

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "FALL-490" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Storno von add. Kosten bei Umlagerung; Testumgebung 49
Given I open an editor "RueckStorno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RechnungmLUm"
And I set field "nummer" to "49umlsto"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "FALL-490" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

# @FALL-500 add.Kosten bei Umlagerung
Scenario: 02 Artikel einkaufen; Testumgebung 50

# Artikel einkaufen
Given I open an editor "RechnungmLZu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer   | 50zu     |
    | lief     | 001fa50  |
    | vom      | .        |
    | ebeleg   | Zugang50 |
    | ueb      | ja       |
    | fakt     | ja       |
And I append rows
    | artikel   | mge | preis |platz |
    | 0efall50  | 20  | 5.00  | F1   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "FALL-500" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Artikel umlagern in externe Lagergruppe
Given I open an editor "LSzuUml" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | nummer   | 50umlls    |
    | bsart    | Umlagern   |
    | lief     | 004fa50    |
    | vom      | .          |
    | ebeleg   | Umlagern50 |
    | ueb      | ja         |
    | erfwaehr | EUR        |
And I append rows
    | artikel   | mge | abplatz | platz |
    | 0efall50  | 20  | F1      | L3F1  |
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "FALL-500" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Transportkosten bezahlen
Given I open an editor "RechnungmLUm" from table "(Purchasing):(Invoice)" with command "NEW" for record from editor "LSzuUml"
And I set fields
    | nummer   | 50uml      |
    | vom      | .          |
    | ebeleg   | Umlagern50 |
    | ueb      | ja         |
    | erfwaehr | EUR        |
And I press button "offueb" in row 1
And I set field " preis" to "1.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "FALL-500" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Kostenumlage (2 Euro) auf Originalzugang
# zuerst die Versicherungsrechnung anlegen
Given I open an editor "versicherung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa50"
And I set field "num4" to "500km"
And I set field "kenn" to "FALL-500"
And I set field "such" to "KM500"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VERS" in row 1
And I set field "pwert" to "2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "500-KM"
And I set field "pos" to "$,,kopf^nummer=500km;art=VERS;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=50zu;artex=0efall50;mge=20;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "FALL-500" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Ruecklieferung auf Zugang
Given I open an editor "Ruecklieferung" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmLZu"
And I set field "nummer" to "50rueck"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-15" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "500" in the Area "50"

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "FALL-500" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Ruecklieferung stornieren
Given I open an editor "RueckStorno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferung"
And I set field "nummer" to "50storno"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "500" in the Area "50"

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "FALL-500" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Storno von add. Kosten bei Umlagerung; Testumgebung 50
Given I open an editor "RueckStorno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RechnungmLUm"
And I set field "nummer" to "50umlsto"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "FALL-500" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

