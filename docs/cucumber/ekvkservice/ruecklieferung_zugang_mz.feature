# *****************************************************************************
#  Name           : ruecklieferung_zugang_mz.feature
#  Autor          : as
#  Verantwortlich : teampss
#  Funktion       : Test der MZ-Generierung und -Zuordnung bei Ruecklieferung
#                   von Zugaengen.
#
# *****************************************************************************

@persistent
Feature: MZ-Generierung und -Zuordnung bei der Ruecklieferung von Zugaengen
Background:
Given I set the fake date to "02.01.1995"
Given I enable the flag 39

Scenario: Ruecklieferung EK-Lieferschein mit Umlagerungen 1

# Lagerplaetze anlegen
Given I open an editor "F100" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F100 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F101" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F101 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F102" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F102 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A100" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such   | A100             |
   | bsart  | Fremdbeschaffung |
   | dispoa | auftragsbezogen  |
   | lief   | 1                |
   | epr    | 100              |
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE100" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE100 |
And I append rows
   | artex | mge | preis | platz |
   | A100  | 100 | 100   | F100  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS100" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE100"
And I set fields
   | num4 | 1LS100 |
   | vom  | .      |
   | ueb  | ja     |
And I set field "mge" to "100" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge |
    | F100   | 50     |
    | F100   | 50     |
And I save the current editor
And I switch the current editor to editor "1LS100"
And I save the current editor

# Umbuchungen
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A100      |
    | buart   | Umbuchung |
    | beleg   | 1UM100    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge |
    | F100  | F101   | 70  |
    | F100  | F101   | 30  |
And I save the current editor

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A100      |
    | buart   | Umbuchung |
    | beleg   | 2UM100    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | verw   | verw2  |
    | F101  | F101   | 100 |        | 2UM100 |
And I save the current editor

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A100      |
    | buart   | Umbuchung |
    | beleg   | 3UM100    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | verw   | verw2  |
    | F101  | F101   | 100 | 2UM100 |        |
And I save the current editor

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A100      |
    | buart   | Umbuchung |
    | beleg   | 4UM100    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge |
    | F101  | F102   | 100 |
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "1LS100R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS100"
And I set fields
   | num4 | 1LS100R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-100" in row 1
And I set field "platz" to "F100" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "zuomge" to "-100" in row 1
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS100R"
And I set field "platz" to "F102" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "zuomge" to "-100" in row 1
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS100R"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I press button "burueckmzerg"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS100R"
And I save the current editor

Given I open an editor "1LS100R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS100R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS100R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Umlagerungen 2

# Lagerplaetze anlegen
Given I open an editor "F110" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F110 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F111" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F111 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F112" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F112 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F113" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F113 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A110" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such   | A110             |
   | bsart  | Fremdbeschaffung |
   | dispoa | auftragsbezogen  |
   | lief   | 1                |
   | epr    | 110              |
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE110" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE110 |
And I append rows
   | artex | mge | preis | platz |
   | A110  | 110 | 110   | F110  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS110" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE110"
And I set fields
   | num4 | 1LS110 |
   | vom  | .      |
   | ueb  | ja     |
And I set field "mge" to "110" in row 1
And I save the current editor

# Umbuchungen
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A110      |
    | buart   | Umbuchung |
    | beleg   | 1UM110    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge |
    | F110  | F111   | 15  |
And I save the current editor

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A110      |
    | buart   | Umbuchung |
    | beleg   | 2UM110    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge |
    | F111  | F112   | 3   |
    | F111  | F112   | 4   |
    | F111  | F112   | 5   |
And I save the current editor

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A110      |
    | buart   | Umbuchung |
    | beleg   | 3UM110    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge |
    | F112  | F111   | 6   |
And I save the current editor

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A110      |
    | buart   | Umbuchung |
    | beleg   | 4UM110    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge |
    | F111  | F113   | 7   |
And I save the current editor

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A110      |
    | buart   | Umbuchung |
    | beleg   | 5UM110    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge |
    | F113  | F112   | 4   |
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "1LS110R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS110"
And I set fields
   | num4 | 1LS110R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-30" in row 1
And I set field "platz" to "F112" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F110   | -5     |
    | F110   | -10    |
    | F111   | -2     |
    | F112   | -4     |
    | F112   | -6     |
    | F113   | -3     |
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F113   | -3     |
    | F112   | -6     |
    | F112   | -4     |
    | F111   | -2     |
    | F110   | -10    |
    | F110   | -5     |
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F110   | -5     |
    | F111   | -2     |
    | F110   | -10    |
    | F112   | -6     |
    | F113   | -3     |
    | F112   | -4     |
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F110   | -10    |
    | F112   | -4     |
    | F111   | -2     |
    | F113   | -3     |
    | F112   | -6     |
    | F110   | -5     |
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I save the current editor
And I switch the current editor to editor "1LS110R"
And I save the current editor

Given I open an editor "1LS110R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS110R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS110R"
And I close the current editor

Scenario: Teilruecklieferung EK-Lieferschein

# Lagerplaetze anlegen
Given I open an editor "F120" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F120 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F121" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F121 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A120" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such   | A120             |
   | bsart  | Fremdbeschaffung |
   | dispoa | auftragsbezogen  |
   | lief   | 1                |
   | epr    | 120              |
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE120" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE120 |
And I append rows
   | artex | mge | preis | platz |
   | A120  | 120 | 120   | F120  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS120" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE120"
And I set fields
   | num4 | 1LS120 |
   | vom  | .      |
   | ueb  | ja     |
And I set field "mge" to "120" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F120   | 40     |
    | F120   | 40     |
    | F120   | 40     |
And I save the current editor
And I switch the current editor to editor "1LS120"
And I save the current editor

# Umlagerung
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A120      |
    | buart   | Umbuchung |
    | beleg   | 1UM120    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge |
    | F120  | F121   | 60  |
And I save the current editor

# Ruecklieferschein 1 anlegen
Given I open an editor "1LS120R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS120"
And I set fields
   | num4 | 1LS120R |
   | vom  | .       |
And I set field "mge" to "-60" in row 1
And I set field "platz" to "F120" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F120   | -20    |
    | F120   | -20    |
    | F120   | -10    |
    | F120   | -10    |
And I press button "burueckmzzuord"
And I save the current editor
And I switch the current editor to editor "1LS120R"
And I save the current editor

# Ruecklieferschein 2 anlegen
Given I open an editor "2LS120R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS120"
And I set fields
   | num4 | 2LS120R |
   | vom  | .       |
And I set field "mge" to "-60" in row 1
And I set field "platz" to "F121" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F120   | -20    |
    | F120   | -20    |
    | F120   | -10    |
    | F120   | -10    |
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F121   | -20    |
    | F121   | -20    |
    | F121   | -10    |
    | F121   | -10    |
And I press button "burueckmzzuord"
And I save the current editor
And I switch the current editor to editor "2LS120R"
And I save the current editor

Given I open an editor "1LS120R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS120R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS120R"
And I close the current editor

Given I open an editor "2LS120R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "2LS120R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS120R"
And I close the current editor

Scenario: Teilruecklieferung EK-Lieferschein, Menge reduzieren

Given I open an editor "2LS120R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "2LS120R"
And I set field "mge" to "-30" in row 1
And I save the current editor

Given I open an editor "1LS120R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS120R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS120R"
And I close the current editor

Given I open an editor "2LS120R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "2LS120R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS120R"
And I close the current editor

Scenario: Teilruecklieferung EK-Lieferschein, Menge erhoehen, buchen

Given I open an editor "2LS120R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "2LS120R"
And I set field "ueb" to "ja"
And I set field "mge" to "-60" in row 1
And I save the current editor

Given I open an editor "1LS120R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS120R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS120R"
And I close the current editor

Given I open an editor "2LS120R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "2LS120R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS120R"
And I close the current editor

Scenario: Teilruecklieferung EK-Lieferschein, Teilruecklieferung stornieren

Given I open an editor "2LS120RS" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "2LS120R"
And I set field "num4" to "2LS120RS"
And I save the current editor

Given I open an editor "1LS120R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS120R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS120R"
And I close the current editor

Given I open an editor "2LS120R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "2LS120R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS120R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Verwendung und Projekt

# Projektkostenrechnung einschalten
Given I open an editor "config" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "projekt" to "ja"
And I save the current editor

# Projekt anlegen
Given I open an editor "projekt" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set field "such" to "PRO130"
And I save the current editor

# Lagerplaetze anlegen
Given I open an editor "F130" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F130 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F101" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F131 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F102" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F132 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A130" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such   | A130             |
   | bsart  | Fremdbeschaffung |
   | dispoa | auftragsbezogen  |
   | lief   | 1                |
   | epr    | 130              |
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE130" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE130 |
And I append rows
   | artex | mge | preis | platz |
   | A130  | 130 | 130   | F130  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS130" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE130"
And I set fields
   | num4 | 1LS130 |
   | vom  | .      |
   | ueb  | ja     |
And I set field "mge" to "130" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | verw      | projekt |
    | F130   | 10     |           |         |
    | F130   | 20     |           | PRO130  |
    | F130   | 30     | VERW130   |         |
    | F131   | 10     | VERW130   | PRO130  |
    | F131   | 20     | VERW130_1 |         |
    | F131   | 40     | VERW130_1 | PRO130  |
And I save the current editor
And I switch the current editor to editor "1LS130"
And I save the current editor

# Umbuchungen
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A130      |
    | buart   | Umbuchung |
    | beleg   | 1UM130    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | projekt | projekt2 |
    | F130  | F132   | 10  |         |          |
    | F130  | F132   | 20  | PRO130  | PRO130   |
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "1LS130R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS130"
And I set fields
   | num4 | 1LS130R |
   | vom  | .       |
And I set field "mge" to "-130" in row 1
And I set field "platz" to "F130" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I set field "zuomge" to "-10" in row 1
And I set field "zuomge" to "-20" in row 3
And I set field "zuomge" to "-30" in row 5
And I set field "zuomge" to "-20" in row 7
And I save the current editor
And I switch the current editor to editor "1LS130R"
And I save the current editor

# Ruecklieferschein 2 anlegen
Given I open an editor "2LS130R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS130"
And I set fields
   | num4 | 2LS130R |
   | vom  | .       |
And I set field "mge" to "-50" in row 1
And I set field "platz" to "F130" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I set field "zuomge" to "-10" in row 1
And I set field "zuomge" to "-40" in row 2
And I save the current editor
And I switch the current editor to editor "2LS130R"
And I save the current editor

Given I open an editor "1LS130R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS130R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS130R"
And I close the current editor

Given I open an editor "2LS130R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "2LS130R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS130R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Verwendung und Projekt, Ruecklieferposition reduzieren

# Ruecklieferschein 1 Position reduzieren
Given I open an editor "1LS130R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "1LS130R"
And I set field "mge" to "-50" in row 1
And I save the current editor

Given I open an editor "1LS130R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS130R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS130R"
And I close the current editor

Given I open an editor "2LS130R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "2LS130R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS130R"
And I close the current editor

# Ruecklieferschein 3 anlegen
Given I open an editor "3LS130R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS130"
And I set fields
   | num4 | 3LS130R |
   | vom  | .       |
And I set field "mge" to "-30" in row 1
And I set field "platz" to "F130" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I set field "zuomge" to "-10" in row 1
And I set field "zuomge" to "-20" in row 2
And I save the current editor
And I switch the current editor to editor "3LS130R"
And I save the current editor

Given I open an editor "1LS130R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS130R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS130R"
And I close the current editor

Given I open an editor "2LS130R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "2LS130R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS130R"
And I close the current editor

Given I open an editor "3LS130R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "3LS130R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS130R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Verwendung und Projekt, Ruecklieferscheine buchen

Given I open an editor "1LS130R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "1LS130R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "2LS130R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "2LS130R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS130R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS130R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS130R"
And I close the current editor

Given I open an editor "2LS130R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "2LS130R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS130R"
And I close the current editor

Given I open an editor "3LS130R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "3LS130R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS130R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Verwendung und Projekt, Ruecklieferscheine buchen (Fortsetzung)

Given I open an editor "3LS130R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "3LS130R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS130R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS130R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS130R"
And I close the current editor

Given I open an editor "2LS130R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "2LS130R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS130R"
And I close the current editor

Given I open an editor "3LS130R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "3LS130R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS130R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Chargen

# Lagerplaetze anlegen
Given I open an editor "F140" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F140 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F141" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F141 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A140" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A140             |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | lief      | 1                |
   | epr       | 140              |
   | chimlager | ja               |
And I save the current editor

# Chargen anlegen
Given I open an editor "C140" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C140 |
   | exnum   | C140 |
   | artikel | A140 |
And I save the current editor

Given I open an editor "C141" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C141 |
   | exnum   | C141 |
   | artikel | A140 |
And I save the current editor

Given I open an editor "C142" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C142 |
   | exnum   | C142 |
   | artikel | A140 |
And I save the current editor

Given I open an editor "C143" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C143 |
   | exnum   | C143 |
   | artikel | A140 |
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE140" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE140 |
And I append rows
   | artex | mge | preis | platz |
   | A140  | 140 | 140   | F140  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS140" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE140"
And I set fields
   | num4 | 1LS140 |
   | vom  | .      |
   | ueb  | ja     |
And I set field "mge" to "140" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | charge |
    | F140   | 30     | C140   |
    | F140   | 40     | C141   |
    | F140   | 70     | C142   |
And I save the current editor
And I switch the current editor to editor "1LS140"
And I save the current editor

# Umbuchungen
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A140      |
    | buart   | Umbuchung |
    | beleg   | 1UM140    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | charge1 | charge2 |
    | F140  | F140   | 20  | C141    | C143    |
    | F140  | F141   | 20  | C142    | C142    |
    | F140  | F141   | 20  | C142    | C140    |
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "1LS140R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS140"
And I set fields
   | num4 | 1LS140R |
   | vom  | .       |
And I set field "mge" to "-140" in row 1
And I set field "platz" to "F140" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | platz | zuomge | charge |
    | F140  | -20    | C140   |
    | F140  | -20    | C141   |
    | F140  | -20    | C142   |
    | F141  | -20    | C142   |
    | F141  | -20    | C140   |
Then pressing button "burueckmzzuord" throws the exception "4068"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | platz | zuomge | charge |
    | F140  | -20    | C140   |
    | F140  | -20    | C141   |
    | F140  | -20    | C142   |
    | F141  | -20    | C142   |
    | F141  | -20    | C143   |
Then pressing button "burueckmzzuord" throws the exception "4068"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | platz | zuomge | charge |
    | F140  | -20    | C140   |
    | F140  | -20    | C141   |
    | F140  | -20    | C142   |
    | F141  | -20    | C142   |
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS140R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Chargen und 'Charge im Lager = nein'

# Lagerplaetze anlegen
Given I open an editor "F145" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F145 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F146" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F146 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A145" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A145             |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | lief      | 1                |
   | epr       | 145              |
   | chimlager | nein             |
And I save the current editor

# Chargen anlegen
Given I open an editor "C145" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C145 |
   | exnum   | C145 |
   | artikel | A145 |
And I save the current editor

Given I open an editor "C141" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C146 |
   | exnum   | C146 |
   | artikel | A145 |
And I save the current editor

Given I open an editor "C142" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C147 |
   | exnum   | C147 |
   | artikel | A145 |
And I save the current editor

Given I open an editor "C143" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C148 |
   | exnum   | C148 |
   | artikel | A145 |
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE145" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE145 |
And I append rows
   | artex | mge | preis | platz |
   | A145  | 145 | 145   | F145  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS145" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE145"
And I set fields
   | num4 | 1LS145 |
   | vom  | .      |
   | ueb  | ja     |
And I set field "mge" to "145" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | charge |
    | F145   | 30     | C145   |
    | F145   | 40     | C146   |
    | F145   | 75     | C147   |
And I save the current editor
And I switch the current editor to editor "1LS145"
And I save the current editor

# Umbuchungen
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A145      |
    | buart   | Umbuchung |
    | beleg   | 1UM145    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | charge1 | charge2 |
    | F145  | F145   | 20  | C146    | C148    |
    | F145  | F146   | 20  | C147    | C147    |
    | F145  | F146   | 20  | C147    | C145    |
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "1LS145R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS145"
And I set fields
   | num4 | 1LS145R |
   | vom  | .       |
And I set field "mge" to "-145" in row 1
And I set field "platz" to "F145" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | platz | zuomge |
    | F145  | -20    |
    | F145  | -20    |
    | F145  | -20    |
    | F146  | -20    |
    | F146  | -20    |
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | platz | zuomge | charge |
    | F145  | -20    | C145   |
    | F145  | -20    | C146   |
    | F145  | -20    | C147   |
    | F146  | -10    | C145   |
    | F146  | -20    | C146   |
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | platz | zuomge | charge |
    | F145  | -20    | C145   |
    | F145  | -20    | C146   |
    | F145  | -20    | C147   |
    | F146  | -20    |        |
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS145R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Aenderung der Verwendung

# Lagerplaetze anlegen
Given I open an editor "F150" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F150 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F151" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F151 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A150" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A150             |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | lief      | 1                |
   | epr       | 150              |
   | chimlager | ja               |
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE150" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE150 |
And I append rows
   | artex | mge | preis | platz |
   | A150  | 150 | 150   | F150  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS150" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE150"
And I set fields
   | num4 | 1LS150 |
   | vom  | .      |
   | ueb  | ja     |
And I set field "mge" to "150" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | verw |
    | F150   | 30     | V150 |
    | F150   | 50     | V151 |
    | F150   | 70     | V152 |
And I save the current editor
And I switch the current editor to editor "1LS150"
And I save the current editor

# Umbuchungen
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A150      |
    | buart   | Umbuchung |
    | beleg   | 1UM150    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | verw | verw2 |
    | F150  | F151   | 10  | V151 | V151  |
    | F151  | F150   | 10  | V151 | V151  |
And I save the current editor

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A150      |
    | buart   | Umbuchung |
    | beleg   | 1UM151    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | verw | verw2 |
    | F150  | F150   | 20  | V151 | V153  |
    | F150  | F151   | 1   | V152 | V152  |
    | F150  | F151   | 3   | V152 | V152  |
    | F150  | F151   | 6   | V152 | V152  |
    | F150  | F151   | 10  | V152 | V152  |
    | F150  | F151   | 20  | V152 | V150  |
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "1LS150R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS150"
And I set fields
   | num4 | 1LS150R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-150" in row 1
And I set field "platz" to "F150" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I set field "zuomge" to "-20" in row 2
And I set field "zuomge" to "-10" in row 5
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | platz | zuomge | verw |
    | F150  | -20    | V150 |
    | F150  | -20    | V151 |
    | F150  | -20    | V152 |
    | F151  | -20    | V152 |
    | F151  | -20    | V151 |
Then pressing button "burueckmzzuord" throws the exception "4068"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | platz | zuomge | verw |
    | F150  | -20    | V150 |
    | F150  | -20    | V151 |
    | F150  | -20    | V152 |
    | F151  | -20    | V152 |
    | F151  | -20    | V153 |
Then pressing button "burueckmzzuord" throws the exception "4068"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | platz | zuomge | verw |
    | F150  | -20    | V150 |
    | F150  | -20    | V151 |
    | F150  | -20    | V152 |
    | F151  | -20    | V152 |
    | F151  | -20    | V150 |
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I save the current editor
And I switch the current editor to editor "1LS150R"
And I save the current editor

Given I open an editor "1LS150R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS150R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS150R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit gebindepflichtigen Einheiten I

# Lagerplaetze anlegen
Given I open an editor "F160" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F160 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F161" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F161 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A160" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A160             |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | lief      | 1                |
   | epr       | 160              |
   | chimlager | ja               |
   | fvhe      | 2                |
   | vhe       | kg               |
   | gebvhe    | ja               |
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE160" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE160 |
And I append rows
   | artex | mge | he | preis | platz |
   | A160  | 160 | kg | 160   | F160  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS160" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE160"
And I set fields
   | num4 | 1LS160 |
   | vom  | .      |
   | ueb  | ja     |
And I set field "mge" to "160" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | einh  | verw |
    | F160   | 30     | kg    | V160 |
    | F160   | 30     | Stück | V161 |
    | F160   | 70     | kg    | V162 |
And I save the current editor
And I switch the current editor to editor "1LS160"
And I save the current editor

# Umbuchungen
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A160      |
    | buart   | Umbuchung |
    | beleg   | 1UM161    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | ze    | verw | verw2 |
    | F160  | F160   | 20  | Stück | V161 | V163  |
    | F160  | F161   | 1   | kg    | V162 | V162  |
    | F160  | F161   | 3   | kg    | V162 | V162  |
    | F160  | F161   | 6   | kg    | V162 | V162  |
    | F160  | F161   | 10  | kg    | V162 | V162  |
    | F160  | F161   | 20  | kg    | V162 | V160  |
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "1LS160R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS160"
And I set fields
   | num4 | 1LS160R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-160" in row 1
And I set field "platz" to "F160" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | platz | zuomge | einh  | verw |
    | F160  | -30    | kg    | V160 |
    | F160  | -30    | Stück | V161 |
    | F160  | -30    | kg    | V162 |
    | F161  | -20    | kg    | V162 |
    | F161  | -20    | kg    | V160 |
And I press button "burueckmzzuord"
Then setting field "einh" to "Stück" in row 1 throws the exception "203"
And I set field "einh" to "Stück" in row 2
Then setting field "einh" to "Stück" in row 4 throws the exception "203"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I save the current editor
And I switch the current editor to editor "1LS160R"
And I save the current editor

Given I open an editor "1LS160R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS160R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS160R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit unterschiedlichen Einheiten

# Lagerplaetze anlegen
Given I open an editor "F170" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F170 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F171" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F171 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A170" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A170             |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | lief      | 1                |
   | epr       | 170              |
   | chimlager | ja               |
   | fvhe      | 2                |
   | vhe       | kg               |
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE170" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE170 |
And I append rows
   | artex | mge | he | preis | platz |
   | A170  | 170 | kg | 170   | F170  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS170" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE170"
And I set fields
   | num4 | 1LS170 |
   | vom  | .      |
   | ueb  | ja     |
And I set field "mge" to "170" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | einh  | verw |
    | F170   | 30     | kg    | V170 |
    | F170   | 30     | Stück | V171 |
    | F170   | 80     | kg    | V172 |
And I save the current editor
And I switch the current editor to editor "1LS170"
And I save the current editor

# Umbuchungen
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A170      |
    | buart   | Umbuchung |
    | beleg   | 1UM171    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | ze    | verw | verw2 |
    | F170  | F170   | 20  | Stück | V171 | V173  |
    | F170  | F171   | 1   | kg    | V172 | V172  |
    | F170  | F171   | 3   | kg    | V172 | V172  |
    | F170  | F171   | 6   | kg    | V172 | V172  |
    | F170  | F171   | 10  | kg    | V172 | V172  |
    | F170  | F171   | 20  | kg    | V172 | V170  |
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "1LS170R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS170"
And I set fields
   | num4 | 1LS170R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-170" in row 1
And I set field "platz" to "F170" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I delete all rows
And I append rows
    | platz | zuomge | einh  | verw |
    | F170  | -30    | kg    | V170 |
    | F170  | -30    | Stück | V171 |
    | F170  | -40    | kg    | V172 |
    | F171  | -10    | Stück | V172 |
    | F171  | -10    | Stück | V170 |
And I press button "burueckmzzuord"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I save the current editor
And I switch the current editor to editor "1LS170R"
And I save the current editor

Given I open an editor "1LS170R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS170R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS170R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit gebindepflichtigen Einheiten II

# Lagerplaetze anlegen
Given I open an editor "F180" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F180 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F181" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F181 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A180" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A180             |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | lief      | 1                |
   | epr       | 180              |
   | chimlager | ja               |
   | fvhe      | 1                |
   | vhe       | Paar             |
   | fvhle     | 2                |
   | gebvhe    | ja               |
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE180" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE180 |
And I append rows
   | artex | mge | he   | preis | platz |
   | A180  | 180 | Paar | 180   | F180  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS180" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE180"
And I set fields
   | num4 | 1LS180 |
   | vom  | .      |
   | ueb  | ja     |
And I set field "mge" to "180" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | einh  |
    | F180   | 80     | Paar  |
    | F180   | 100    | Paar  |
And I save the current editor
And I switch the current editor to editor "1LS180"
And I save the current editor

# Umbuchungen
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A180      |
    | buart   | Umbuchung |
    | beleg   | 1UM180    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | ze    | ze2   |
    | F180  | F180   | 60  | Paar  | Stück |
    | F180  | F181   | 60  | Paar  | Paar  |
And I save the current editor

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A180      |
    | buart   | Umbuchung |
    | beleg   | 1UM181    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | ze    | ze2   |
    | F181  | F180   | 60  | Paar  | Stück |
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "1LS180R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS180"
And I set fields
   | num4 | 1LS180R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "he" to "Stück" in row 1
And I set field "mge" to "-360" in row 1
And I set field "platz" to "F180" in row 1
Then saving the current editor throws the exception "692"
And I set field "mge" to "-240" in row 1
And I save the current editor

Given I open an editor "1LS180R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS180R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS180R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit gebindepflichtigen Einheiten III

# Lagerplaetze anlegen
Given I open an editor "F190" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F190 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F191" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F191 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A190" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A190             |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | lief      | 1                |
   | epr       | 190              |
   | chimlager | ja               |
   | fvhe      | 1                |
   | vhe       | Paar             |
   | fvhle     | 2                |
   | gebvhe    | ja               |
   | fehe      | 1                |
   | ehe       | Satz             |
   | fehle     | 4                |
   | gebehe    | ja               |
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE190" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE190 |
And I append rows
   | artex | mge | he    | preis | platz |
   | A190  | 190 | Stück | 190   | F190  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS190" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE190"
And I set fields
   | num4 | 1LS190 |
   | vom  | .      |
   | ueb  | ja     |
And I set field "mge" to "190" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | einh  |
    | F190   | 20     | Satz  |
    | F190   | 40     | Paar  |
    | F190   | 30     | Stück |
And I save the current editor
And I switch the current editor to editor "1LS190"
And I save the current editor

# Umbuchungen
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A190      |
    | buart   | Umbuchung |
    | beleg   | 1UM190    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | ze    | ze2   |
    | F190  | F191   | 10  | Satz  | Satz  |
    | F190  | F191   | 10  | Paar  | Paar  |
    | F190  | F191   | 10  | Stück | Stück |
And I save the current editor

# Umbuchungen
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A190      |
    | buart   | Umbuchung |
    | beleg   | 1UM190    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | ze    | ze2   |
    | F191  | F190   | 10  | Satz  | Stück |
    | F191  | F190   | 10  | Paar  | Satz  |
    | F191  | F190   | 10  | Stück | Paar  |
And I save the current editor

Scenario: Ruecklieferung EK-Lieferschein mit gebindepflichtigen Einheiten III - Ruecklieferschein 1

Given I open an editor "1LS190R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS190"
And I set fields
   | num4 | 1LS190R |
   | vom  | .       |
   | ueb  | nein    |
And I set field "mge" to "-190" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F190" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
And I set field "zuomge" to "-40" in row 2
And I set field "zuomge" to "-5" in row 4
And I set field "zuomge" to "-5" in row 6
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I save the current editor
And I switch the current editor to editor "1LS190R"
And I save the current editor

Given I open an editor "1LS190R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS190R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS190R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit gebindepflichtigen Einheiten III - Ruecklieferschein 2

Given I open an editor "2LS190R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS190"
And I set fields
   | num4 | 2LS190R |
   | vom  | .       |
   | ueb  | nein    |
And I set field "mge" to "-120" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F190" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
And I set field "zuomge" to "-10" in row 1
And I set field "zuomge" to "-30" in row 2
And I set field "zuomge" to "-20" in row 3
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I save the current editor
And I switch the current editor to editor "2LS190R"
And I save the current editor

Given I open an editor "1LS190R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS190R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS190R"
And I close the current editor

Given I open an editor "2LS190R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "2LS190R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS190R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit gebindepflichtigen Einheiten III - Ruecklieferschein 2 buchen

Given I open an editor "2LS190R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "2LS190R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS190R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS190R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS190R"
And I close the current editor

Given I open an editor "2LS190R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "2LS190R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS190R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit gebindepflichtigen Einheiten III - Ruecklieferschein 1 buchen

Given I open an editor "1LS190R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "1LS190R"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1LS190R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS190R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS190R"
And I close the current editor

Given I open an editor "2LS190R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "2LS190R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "2LS190R"
And I close the current editor

Scenario: Teilruecklieferung EK-Lieferschein II

# Lagerplaetze anlegen
Given I open an editor "F200" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F200 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F201" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F201 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A200" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such   | A200             |
   | bsart  | Fremdbeschaffung |
   | dispoa | auftragsbezogen  |
   | lief   | 1                |
   | epr    | 200              |
   | fvhe   | 2                |
   | vhe    | kg               |
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE200" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE200 |
And I append rows
   | artex | mge | he  | platz |
   | A200  | 400 | kg  | F200  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS200" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE200"
And I set fields
   | num4 | 1LS200 |
   | vom  | .      |
   | ueb  | ja     |
And I set field "mge" to "400" in row 1
And I save the current editor

# Umlagerung
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A200      |
    | buart   | Umbuchung |
    | beleg   | 1UM200    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | ze    |
    | F200  | F201   | 100 | Stück |
And I save the current editor

# Ruecklieferschein 1 anlegen
Given I open an editor "1LS200R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS200"
And I set fields
   | num4 | 1LS200R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-50" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F200" in row 1
And I save the current editor

# Ruecklieferschein 2 anlegen
Given I open an editor "2LS200R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS200"
And I set fields
   | num4 | 2LS200R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-50" in row 1
And I set field "he" to "Stück" in row 1
And I set field "platz" to "F201" in row 1
And I save the current editor

# Ruecklieferschein 3 anlegen
Given I open an editor "3LS200R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS200"
And I set fields
   | num4 | 3LS200R |
   | vom  | .       |
And I set field "mge" to "-100" in row 1
And I set field "he" to "Stück" in row 1
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "3LS200R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Aenderung der Verwendung, Storno Ruecklieferung

# Lagerplaetze anlegen
Given I open an editor "F210" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F210 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F211" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F211 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A210" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A210             |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | lief      | 1                |
   | epr       | 210              |
   | chimlager | ja               |
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE210" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE210 |
And I append rows
   | artex | mge | preis | platz |
   | A210  | 210 | 210   | F210  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS210" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE210"
And I set fields
   | num4 | 1LS210 |
   | vom  | .      |
   | ueb  | ja     |
And I set field "mge" to "210" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | verw |
    | F210   | 210    | V210 |
And I save the current editor
And I switch the current editor to editor "1LS210"
And I save the current editor

# Umbuchungen
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A210      |
    | buart   | Umbuchung |
    | beleg   | 1UM210    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | verw | verw2 |
    | F210  | F210   | 100 | V210 | V211  |
    | F210  | F211   | 110 | V210 | V210  |
And I save the current editor

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A210      |
    | buart   | Umbuchung |
    | beleg   | 1UM211    |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | verw | verw2 |
    | F211  | F210   | 110 | V210 | V211  |
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "1LS210R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS210"
And I set fields
   | num4 | 1LS210R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-210" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | verw |
    | F210   | -210   | V211 |
And I save the current editor
And I switch the current editor to editor "1LS210R"
And I save the current editor

Given I open an editor "1LS210R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS210R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS210R"
And I close the current editor

# Ruecklieferschein stornieren
Given I open an editor "1LS210RS" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS210R"
And I set field "num4" to "1LS210RS"
And I save the current editor

Given I open an editor "1LS210R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS210R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS210R"
And I close the current editor

Given I open an editor "1LS210RS" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS210RS"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS210RS"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Umlagerungen ueber SQRELOCATION

# Lagerplaetze anlegen
Given I open an editor "F220" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F220 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F221" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F221 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F222" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F222 |
   | lager | L1   |
And I save the current editor

Given I open an editor "F223" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F223 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A220" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such   | A220             |
   | bsart  | Fremdbeschaffung |
   | dispoa | auftragsbezogen  |
   | lief   | 1                |
   | epr    | 220              |
   | fvhe   | 2                |
   | vhe    | kg               |
And I save the current editor

# Artikel anlegen
Given I open an editor "A220" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such   | A221             |
   | bsart  | Fremdbeschaffung |
   | dispoa | auftragsbezogen  |
   | lief   | 1                |
   | epr    | 221              |
   | fvhe   | 2                |
   | vhe    | kg               |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS220" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | num4 | 1LS220 |
   | lief | 1      |
   | vom  | .      |
   | ueb  | ja     |
And I append rows
   | artex | mge | preis | platz |
   | A220  | 10  | 220   | F220  |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge |
    | F220   | 5      |
    | F220   | 3      |
    | F220   | 2      |
And I save the current editor
And I switch the current editor to editor "1LS220"
And I save the current editor

# Umlagerungen
Given I set the fake date to "03.01.1995"
Given I open an editor "Lbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A220        |
    | beleg   | SQRELOCATIO |
    | buart   | Umbuchung   |
    | beldat  | .           |
And I append rows
    | platz | platz2 | mge |
    | F220  | F221   | 10  |
And I save the current editor

Given I open an editor "Lbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A220                   |
    | beleg   | SQRELOCATIO            |
    | buart   | Umbuchung              |
    | beldat  | .                      |
    | orig    | $,,ebeleg=1LS220;mge=5 |
And I append rows
    | platz | platz2 | mge |
    | F221  | F222   | 5   |
And I save the current editor

Given I open an editor "Lbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A220                   |
    | beleg   | SQRELOCATIO            |
    | buart   | Umbuchung              |
    | beldat  | .                      |
    | orig    | $,,ebeleg=1LS220;mge=3 |
And I append rows
    | platz | platz2 | mge |
    | F221  | F223   | 1   |
And I save the current editor

Given I open an editor "Lbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A220                   |
    | beleg   | SQRELOCATIO            |
    | buart   | Umbuchung              |
    | beldat  | .                      |
    | orig    | $,,ebeleg=1LS220;mge=5 |
And I append rows
    | platz | platz2 | mge |
    | F222  | F223   | 5   |
And I save the current editor

# Ruecklieferschein anlegen
Given I open an editor "1LS220R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS220"
And I set fields
   | num4 | 1LS220R |
   | vom  | .       |
And I set field "mge" to "-10" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
And I set field "zuomge" to "-5" in row 1
And I set field "zuomge" to "-2" in row 3
And I set field "zuomge" to "-1" in row 5
And I set field "zuomge" to "-2" in row 7
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I save the current editor
And I switch the current editor to editor "1LS220R"
And I save the current editor

# Ruecklieferschein buchen
Given I open an editor "1LS220R" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS220R"
And I set field "ueb" to "true"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I save the current editor
And I switch the current editor to editor "1LS220R"
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE221" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE221 |
And I append rows
   | artex | mge | preis | platz |
   | A221  | 10  | 221   | F220  |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS221" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE221"
And I set fields
   | num4 | 1LS221 |
   | vom  | .      |
   | ueb  | ja     |
And I set field "mge" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge |
    | F220   | 5      |
    | F220   | 3      |
    | F220   | 2      |
And I save the current editor
And I switch the current editor to editor "1LS221"
And I save the current editor

# Umlagerungen
Given I set the fake date to "04.01.1995"
Given I open an editor "Lbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A221        |
    | beleg   | SQRELOCATIO |
    | buart   | Umbuchung   |
    | beldat  | .           |
And I append rows
    | platz | platz2 | mge |
    | F220  | F221   | 10  |
And I save the current editor

Given I open an editor "Lbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A221                   |
    | beleg   | SQRELOCATIO            |
    | buart   | Umbuchung              |
    | beldat  | .                      |
    | orig    | $,,ebeleg=1LS221;mge=5 |
And I append rows
    | platz | platz2 | mge |
    | F221  | F222   | 5   |
And I save the current editor

Given I open an editor "Lbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A221                   |
    | beleg   | SQRELOCATIO            |
    | buart   | Umbuchung              |
    | beldat  | .                      |
    | orig    | $,,ebeleg=1LS221;mge=3 |
And I append rows
    | platz | platz2 | mge |
    | F221  | F223   | 1   |
And I save the current editor

Given I open an editor "Lbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | A221                   |
    | beleg   | SQRELOCATIO            |
    | buart   | Umbuchung              |
    | beldat  | .                      |
    | orig    | $,,ebeleg=1LS221;mge=5 |
And I append rows
    | platz | platz2 | mge |
    | F222  | F223   | 5   |
And I save the current editor

# Ruecklieferschein anlegen und buchen
Given I open an editor "1LS221R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS221"
And I set fields
   | num4 | 1LS221R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-10" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
And I set field "zuomge" to "-5" in row 1
And I set field "zuomge" to "-2" in row 3
And I set field "zuomge" to "-1" in row 5
And I set field "zuomge" to "-2" in row 7
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I save the current editor
And I switch the current editor to editor "1LS221R"
And I save the current editor

# Ruecklieferschein anzeigen
Given I open an editor "1LS221R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS221R"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS221R"
And I close the current editor

Scenario: Ruecklieferung EK-Lieferschein mit Angabe einer Charge in der Position bei Charge im Lager = false

# Lagerplaetze anlegen
Given I open an editor "F230" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F230 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A230" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A230             |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | lief      | 1                |
   | epr       | 100              |
   | chimlager | nein             |
And I save the current editor

# Chargen anlegen
Given I open an editor "C230" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C230 |
   | exnum   | C230 |
   | artikel | A230 |
And I save the current editor

Given I open an editor "C230" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C231 |
   | exnum   | C231 |
   | artikel | A230 |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS230" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | num4 | 1LS230 |
   | lief | 1      |
   | vom  | .      |
   | ueb  | ja     |
And I append rows
   | artex | mge | preis | platz |
   | A230  | 4   | 230   | F230  |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge | charge |
    | F230   | 2      | C230   |
    | F230   | 2      | C231   |
And I save the current editor
And I switch the current editor to editor "1LS230"
And I save the current editor

# Ruecklieferschein anlegen und buchen
Given I open an editor "1LS230R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS230"
And I set fields
   | num4 | 1LS230R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-1" in row 1
And I set field "charge" to "C231" in row 1
And I save the current editor

# Ruecklieferschein ausgeben
Given I open an editor "1LS230R" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS230R"
Then I fill template "EV_VORG_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then I fill template "EV_RUECK_MZ.ftl" and append it to output file "ruecklieferung_zugang_mz.out"
And I close the current editor
And I switch the current editor to editor "1LS230R"
And I close the current editor

Scenario: Teilruecklieferung EK-Lieferschein mit Beistellung

# Lagerplaetze anlegen
Given I open an editor "F240" from table "(Location):(Location)" with command "NEW" for record ""
And I set fields
   | such  | F240 |
   | lager | L1   |
And I save the current editor

# Artikel anlegen
Given I open an editor "A240" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | A240                    |
   | namebspr | Artikel mit Beistellung |
   | lief     | 1                       |
   | epr      | 100                     |
   | bsart    | Fremdbeschaffung        |
   | dispoa   | bedarfsbezogen          |
And I save the current editor

Given I open an editor "B240" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | B240                    |
   | namebspr | Beistellartikel         |
   | lief     | 1                       |
   | epr      | 100                     |
   | bsart    | Fremdbeschaffung        |
   | dispoa   | bedarfsbezogen          |
   | abplatz  | F240                    |
   | zuplatz  | F240                    |
And I save the current editor

# Beistellung im Artikel eintragen
Given I open an editor "A240" from table "(Part):(Product)" with command "UPDATE" for record from editor "A240"
And I append rows
   | elex  | elanzahl | bua                    |
   | B240  | 2        | Lieferantenbeistellung |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "1LS240" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | num4 | 1LS240 |
   | lief | 1      |
   | vom  | .      |
   | ueb  | ja     |
And I append rows
   | artex | mge | platz |
   | A240  | 2   | F240  |
And I save the current editor

# Ruecklieferschein anlegen und buchen
Given I open an editor "1LS240R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS240"
And I set fields
   | num4 | 1LS240R |
   | vom  | .       |
   | ueb  | ja      |
And I set field "mge" to "-1" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
And I set field "zuomge" to "-1" in row 1
And I save the current editor
And I switch the current editor to editor "1LS240R"
And I save the current editor
