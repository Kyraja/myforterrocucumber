# *****************************************************************************
#  Name             : ref_bw_add_kosten_02_mz.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        :
#  Funktion         : Test der add. Kosten, die auf Vorgaenge mit MZ umgelegt werden
#
#
#
#
# *****************************************************************************

@persistent
Feature: add.Kosten
Background: Test von add. Kosten in der Bewertung
Given I set the fake date to "07.01.2002"

@FALL-MZ250
Scenario: MZ im LS; KM (fuer Speditions-RE) auf LS; Testumgebung 25
# eine Bestellung fuer Artikel mit Beistellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# EU-Lieferant
And I set field "lief" to "001fa25"
And I set field "num4" to "250mz-BE"
And I set field "kenn" to "FALL-MZ250,"
And I create a new row at the end of the table
And I set field "artex" to "0efall25" in row 1
And I set field "mge" to "250" in row 1
And I set field "preis" to "3.33" in row 1
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "250mz-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-MZ Inl"
And I press button "mzsubm" to open a subeditor for "MZFertig" in row !lastRow
And I set field "zuomge" to "100" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "150" in row 2
And I save the current editor
And I close the current editor
And I switch the current editor to editor "lieferschein-1"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "250" in the Area "25" with Command Revalue

# VK-Rechnung (Ausland)
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "250-RE"
And I set field "kunde" to "006fa25"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "0efall25" in row 1
And I set field "mge" to "175" in row 1
And I set field "preis" to "25" in row 1
And I set field "kenn" to "FALL-MZ250,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "250" in the Area "25" with Command Revalue

# Kostenumlage (250)
# zuerst die Frachtrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa25"
And I set field "num4" to "250km1"
And I set field "kenn" to "FALL-MZ250,"
And I set field "such" to "KM250"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "FRACHT" in row 1
And I set field "pwert" to "250" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "250-KM1"
And I set field "pos" to "$,,kopf^nummer=250km1;art=FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=250mz-LS;artex=0efall25;mge=250;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "250" in the Area "25" with Command Revalue


# Rechnung fuer komplette Menge; Inland -> EU
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "250RE-EU"
And I set field "lief" to "003fa25"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "4" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "250" in the Area "25" with Command Revalue
#####################################################################################################################################

@FALL-MZ260
Scenario: MZ im LS; KM (fuer Speditions-RE) auf LS; Testumgebung 26

# eine Bestellung fuer Artikel mit Beistellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# EU-Lieferant
And I set field "lief" to "001fa26"
And I set field "num4" to "260mz-BE"
And I set field "kenn" to "FALL-MZ260,"
And I create a new row at the end of the table
And I set field "artex" to "0efall26" in row 1
And I set field "mge" to "260" in row 1
And I set field "preis" to "3.7" in row 1
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "261mz-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-MZ Inl"
And I set field "mge" to "110" in row 1
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "262mz-LS"
Then field "fakt" has value "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-MZ Inl,"
And I press button "mzsubm" to open a subeditor for "MZFertig" in row !lastRow
And I set field "zuomge" to "60" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "90" in row 2
And I save the current editor
And I close the current editor
And I switch the current editor to editor "lieferschein-2"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "260" in the Area "26" with Command Revalue

# Rechnung fuer komplette Menge; Inland
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "260RE-IN"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "4.1" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "260" in the Area "26" with Command Revalue

# VK-Rechnung (Ausland)
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "260-RE"
And I set field "kunde" to "006fa26"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "0efall26" in row 1
And I set field "mge" to "175" in row 1
And I set field "preis" to "26" in row 1
And I set field "kenn" to "FALL-MZ260,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "260" in the Area "26" with Command Revalue

# Kostenumlage (260�)
# zuerst die Frachtrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa26"
And I set field "num4" to "260km1"
And I set field "kenn" to "FALL-MZ260,"
And I set field "such" to "KM260"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "FRACHT" in row 1
And I set field "pwert" to "260" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "260-KM1"
And I set field "pos" to "$,,kopf^nummer=260km1;art=FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=260RE-IN;artex=0efall26;mge=260;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor

#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "260" in the Area "26" with Command Revalue

# Kostenumlage (110�)
# eine Versicherungsrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "003fa26"
And I set field "num4" to "260km2"
And I set field "kenn" to "FALL-MZ260,"
And I set field "such" to "KM260"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "VERS" in row 1
And I set field "pwert" to "110" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "260-KM2"
And I set field "pos" to "$,,kopf^nummer=260km2;art=VERS;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=261mz-LS;artex=0efall26;mge=110;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor

#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "260" in the Area "26" with Command Revalue
#####################################################################################################################################

@FALL-MZ270
Scenario: MZ im LS; KM (fuer Speditions-RE) auf LS; Testumgebung 27
# eine Bestellung fuer Artikel mit Beistellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# Inland-Lieferant
And I set field "lief" to "001fa27"
And I set field "num4" to "270mz-BE"
And I set field "kenn" to "FALL-MZ270,"
And I create a new row at the end of the table
And I set field "artex" to "0efall27" in row 1
And I set field "mge" to "270" in row 1
And I set field "preis" to "3.33" in row 1
And I save the current editor
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-11" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "270mz-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-MZ Inl"
And I set field "mge" to "270" in row 1
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "270" in the Area "27" with Command Revalue

# VK-Rechnung (Ausland)
Given I open an editor "vk-rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "270-RE"
And I set field "kunde" to "006fa27"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "0efall27" in row 1
And I set field "mge" to "175" in row 1
And I set field "preis" to "27" in row 1
And I set field "kenn" to "FALL-MZ270,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "270" in the Area "27" with Command Revalue

# Kostenumlage (270�)
# zuerst die Frachtrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa27"
And I set field "num4" to "270km1"
And I set field "kenn" to "FALL-MZ270,"
And I set field "such" to "KM270"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "FRACHT" in row 1
And I set field "pwert" to "270" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "270-KM1"
And I set field "pos" to "$,,kopf^nummer=270km1;art=FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=270mz-LS;artex=0efall27;mge=270;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "270" in the Area "27" with Command Revalue


#-----------------------------------------------------------------------------
#
# Verteilung ueber MZ ist in der Maske 'RE' moeglich -> hier aber nicht!!!!
# Rest bleibt auskommentiert
#
#-----------------------------------------------------------------------------
#
#
## Rechnung fuer komplette Menge; Inland -> EU
#Given I open an editor "ek-rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
#And I set field "beleg" to id from editor "lieferschein-11"
#And I set field "num4" to "270RE-EU"
##And I set field "lief" to "003fa27"
#And I set field "ueb" to "ja"
#And I set field "vom" to "."
#Then the table has 1 rows
#Then field "mge" has value "270" in row 1
#And I press button "mzsubm" to open a subeditor for "MZFertig2" in row !lastRow
##And I press button "mzsubm" to open a subeditor for "MZFertig" in row 1
#And I set field "zuomge" to "120" in row 1
#And I create a new row at the end of the table
#And I set field "zuomge" to "150" in row 2
#And I save the current editor
#And I close the current editor
#And I switch the current editor to editor "ek-rechnung"
#And I set field "preis" to "4.77" in row 1
#And I set field "intrarel" to "nein" in row 1
#And I respond with answer "Ja" to the dialog with id "4841"
#And I save the current editor
#And I close the current editor
#
##
## nachbewerten + Materialkostenverbuchung
#Given I create a CostEntriesSuggestion for the Test Case "270" in the Area "27" with Command Revalue
#####################################################################################################################################

