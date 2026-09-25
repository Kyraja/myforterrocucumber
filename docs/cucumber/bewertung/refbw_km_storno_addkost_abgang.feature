@persistent
Feature: BW2-1483 bei storno kostenuml. darf der preis von mpr-abgängen über add.kosten nicht geändert werden
Background:
Given I set the fake date to "10.01.2002"

Scenario: Storno KM wirkung auf MPR-/Planpreis-Abgänge

Given I set the fake date to "10.01.2002"

# Zusatzposition Transport zum umlegen
Given I open an editor "zusatzp_transport" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "nummer" to "1transp"
And I set field "such" to "transport"
And I set field "name" to "transportkosten"
And I save the current editor

# Rechnung für transport anlegen
Given I open an editor "rechnung-134" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "134-RE"
And I set field "lief" to "1"
And I set field "erfwaehr" to "eur"
And I set field "vom" to "."
And I set field "ueb" to "ja"
# And I set field "kenn" to "FALL-134"
And I create a new row at the end of the table
And I set field "artex" to "transport" in row 1
And I set field "pwert" to "134" in row 1
And I set field "kstelle" to "113" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# -------------------------------------------------------------------------------------------------------
# 2 Lieferscheinpositionen zur Aufnahme additiver Kosten
# -------------------------------------------------------------------------------------------------------
Given I open an editor "ls-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "num4" to "2ls"
And I set field "lief" to "1"
And I set field "erfwaehr" to "EUR"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1A-VM" in row !lastRow
And I set field "mge" to "5" in row !lastRow
And I set field "preis" to "30" in row !lastRow
And I set field "konto" to "10000" in row !lastRow
And I set field "platz" to "F2" in row !lastRow
# ...
And I create a new row at the end of the table
And I set field "artex" to "E1A-PO" in row !lastRow
And I set field "mge" to "20" in row !lastRow
And I set field "preis" to "2" in row !lastRow
And I set field "konto" to "10000" in row !lastRow
And I save the current editor



Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | E1A-VM      |
    | buart   | Abgang |
    | beleg   | abg-vm    |
    | beldat  | .         |
And I append rows
    | platz  | mge |
    | F2     |  5  |
And I save the current editor
And I close the current editor

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | E1A-PO |
    | buart   | Abgang |
    | beleg   | abg-po    |
    | beldat  | .         |
And I append rows
    | platz  | mge |
    | F1     |  20  |
And I save the current editor
And I close the current editor


# transportkosten nach den abgängen umlegen
Given I open an editor "kostenuml_aus_EK" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "1"
And I set field "such" to "KM1"
And I set field "pos" to "$,,@datei=4:2;kopf=+134-RE;artex=transport;@ablageart=abgelegt"
And I set field "umlagemeth" to "linear"
And I set field "fibuumbuch" to "ja"
And I create a new row at the end of the table	
And I set field "pos" to "$,,@datei=4:2;kopf=2ls;artex=E1A-VM;@ablageart=lebendig" in row !lastRow
And I create a new row at the end of the table	
And I set field "pos" to "$,,@datei=4:2;kopf=2ls;artex=E1A-PO;@ablageart=lebendig" in row !lastRow
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


Given I open an editor "StornoKostenumlage" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+1"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
