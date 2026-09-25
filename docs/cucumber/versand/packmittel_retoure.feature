# *****************************************************************************
#  Name             : packmittel_retoure.feature
#  Autor            : carue
#  Verantwortlich   : dago
#  Kontrolle        : carue
#  Funktion         : Packmittelberechnung bei Retoure testen
#
# *****************************************************************************
@persistent
Feature: packmittel_retoure.feature
Background:
Given I set the fake date to "02.01.1995"

Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "4"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I create a new row at the end of the table
And I set field "edinachraz" to "Rechnung" in row 1
And I set field "erlaubt" to "ja" in row 1
And I save the current editor
And I switch the current editor to editor "Kunde"
And I save the current editor
##################################################################################################################

@Verkauf
@Lieferschein
@Retoure
Scenario: 01 Lieferschein ohne Packmittel, Ruecklieferschein mit Packmitteln
Given I open an editor "Auftrag01" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "Radshop"
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "500" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "KLINGEL" in row 2
And I set field "mge" to "250" in row 2
Then the table has 2 rows
And I save the current editor

Given I open an editor "Lieferschein01a" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag01"
Then the table has 2 rows
And I set field "dfuesenden" to "NEIN"
And I set field "mge" to "200" in row 1
And I set field "mge" to "100" in row 2
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "Lieferschein01b" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Lieferschein01a"
Then the table has 2 rows
And I set field "dfuesenden" to "NEIN"
And I set field "mge" to "-100" in row 1
And I set field "mge" to "-50" in row 2
And pressing button "packvor" throws the exception "551"
And pressing button "verpplanbearb" throws the exception "551"
And pressing button "pastnrgen" throws the exception "551"
And I save the current editor


@Verkauf
@Lieferschein
@Retoure
Scenario: 02 Lieferschein mit Packmitteln, Ruecklieferschein mit Packmitteln
Given I open an editor "Auftrag02" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "500" in row 1
And I save the current editor

Given I open an editor "Lieferschein02a" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag02"
Then the table has 1 rows
And I set field "mge" to "200" in row 1
And I set field "packanw" to "501" in row 1
And I set field "fmenge" to "10" in row 1
And I press button "packvor"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "Lieferschein02b" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Lieferschein02a"
And I set field "mge" to "-100" in row 1
Then field "packanw" has value "501" in row 1
Then field "fmenge" has value "10" in row 1
And pressing button "packvor" throws the exception "551"
And pressing button "verpplanbearb" throws the exception "551"
And pressing button "pastnrgen" throws the exception "551"
And I set field "mge" to "-2" in row 2
And I set field "mge" to "-1" in row 3
And I delete row at position 5
And I delete row at position 4
And I save the current editor


@Verkauf
@Lieferschein
@Retoure
Scenario: 03 Lieferschein mit Packmitteln, Ruecklieferschein mit anderer Packanweisung
Given I open an editor "Auftrag03" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "500" in row 1
And I save the current editor

Given I open an editor "Lieferschein03a" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag03"
Then the table has 1 rows
And I set field "mge" to "200" in row 1
And I set field "packanw" to "501" in row 1
And I set field "fmenge" to "10" in row 1
And I press button "packvor"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "Lieferschein03b" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Lieferschein03a"
And I set field "mge" to "-100" in row 1
# AB die Felder Packanweisung und Fuellmenge sind im Ruecklieferschein schreibgeschuetzt
# And I set field "packanw" to "501" in row 1
# And I set field "fmenge" to "10" in row 1
And pressing button "packvor" throws the exception "551"
And pressing button "verpplanbearb" throws the exception "551"
And pressing button "pastnrgen" throws the exception "551"
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I delete row at position 2
And I save the current editor


@Verkauf
@RechnungmitLagerbewegung
@Retoure
Scenario: 04 Rechnung mit Lagerbewegung ohne Packmittel, Ruecklieferung mit Packmitteln
Given I open an editor "Auftrag04" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "500" in row 1
And I save the current editor

Given I open an editor "Rechnung04a" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "Auftrag04"
And I set fields
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |
Then the table has 1 rows
And I set field "mge" to "200" in row 1
And I save the current editor

Given I open an editor "Rechnung04b" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "Rechnung04a"
And I set field "mge" to "-100" in row 1
# AB die Felder Packanweisung und Fuellmenge sind im Ruecklieferschein schreibgeschuetzt
# And I set field "packanw" to "501" in row 1
# And I set field "fmenge" to "10" in row 1
And pressing button "packvor" throws the exception "551"
And pressing button "verpplanbearb" throws the exception "551"
And pressing button "pastnrgen" throws the exception "551"
And I save the current editor


@Verkauf
@RechnungmitLagerbewegung
@Retoure
Scenario: 05 Rechnung mit Lagerbewegung und Packmitteln, Ruecklieferung mit Packmitteln
Given I open an editor "Auftrag05" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "500" in row 1
And I save the current editor

Given I open an editor "Rechnung05a" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "Auftrag05"
Then field "dfuesenden" has value "ja"
Then the table has 1 rows
And pressing button "packvor" throws the exception ""
And I set fields
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |
And I set field "mge" to "200" in row 1
And I set field "packanw" to "501" in row 1
And I set field "fmenge" to "10" in row 1
And I save the current editor

Given I open an editor "RLS-05" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "Rechnung05a"
Then field "dfuesenden" has value "nein"
And I set fields
  | ueb    | ja     |
And I set field "mge" to "-100" in row 1
Then field "packanw" has value "501" in row 1
Then field "fmenge" has value "10" in row 1
And pressing button "packvor" throws the exception "551"
And pressing button "verpplanbearb" throws the exception "551"
And pressing button "pastnrgen" throws the exception "551"
And I save the current editor

# Kaufm. Gutschrift
Given I open an editor "KGS-05" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS-05"
Then field "dfuesenden" has value "ja"
And I set fields
  | ueb    | ja     |
  | tterm  | .      |
  | vom    | .      |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Storno Kaufm. Gutschrift
Given I open an editor "Storno-KGS05" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KGS-05"
Then field "dfuesenden" has value "nein"
And I save the current editor
# Stornierte KGS
Given I open an editor "VKStornierteKGS05" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS-05"
Then field "dfuesenden" has value "nein"
And I close the current editor

# Storno RLS
Given I open an editor "Storno-RLS05" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS-05"
Then field "dfuesenden" has value "nein"
And I save the current editor

# Storno Rechnung
Given I open an editor "Storno-RE05" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "Rechnung05a"
Then field "dfuesenden" has value "nein"
And I save the current editor


@Verkauf
@RechnungmitLagerbewegung
@Retoure
Scenario: 06 Rechnung mit Lagerbewegung und Packmitteln, Ruecklieferung mit anderer Packanweisung
Given I open an editor "Auftrag06" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "500" in row 1
And I save the current editor

Given I open an editor "Rechnung06a" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "Auftrag06"
Then the table has 1 rows
And pressing button "packvor" throws the exception ""
And I set fields
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |
And I set field "mge" to "200" in row 1
And I set field "packanw" to "501" in row 1
And I set field "fmenge" to "10" in row 1
And I save the current editor

Given I open an editor "Rechnung06b" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "Rechnung06a"
And I set field "mge" to "-100" in row 1
# AB die Felder Packanweisung und Fuellmenge sind im Ruecklieferschein schreibgeschuetzt
# And I set field "packanw" to "PACKA1" in row 1
Then field "fmenge" has value "10" in row 1
And pressing button "packvor" throws the exception "551"
And pressing button "verpplanbearb" throws the exception "551"
And pressing button "pastnrgen" throws the exception "551"
And I save the current editor


@Verkauf
@Rechnung
@Retoure
Scenario: VK 07 Rechnung mit EDI Angaben (dfuesenden, dfuedat) diese sollen nicht in den Ruecklieferschein uebernohmen werden.
Given I open an editor "VKRechnung07" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
  | kunde      | 1    |
  | such       | RE07 |
  | dfuesenden | true |
  | dfuedat    | -1	  |
  | ueb        | ja   |
  | tterm      | .    |
  | budat      | .    |
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "7" in row 1
And I save the current editor

Given I open an editor "Ruecklieferschein07" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRechnung07"
Then field "dfuesenden" has value "nein"
Then field "dfuedat" has value ""
And I set field "mge" to "-3" in row 1
And I save the current editor


@Verkauf
@Lieferschein
@Storno
Scenario: VK 08 Lieferschein mit EDI Angaben wird storniert.
Given I open an editor "VKLieferschein08" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | kunde      | 1    |
  | such       | LS08 |
  | dfuesenden | true |
  | dfuedat    | -2	  |
  | ueb        | ja   |
  | tterm      | .    |
  | budat      | .    |
  | ident      | 008  |
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "8" in row 1
And I save the current editor

# Storno Lieferschein
Given I open an editor "StornoLieferschein08" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "VKLieferschein08"
Then field "dfuesenden" has value "nein"
Then field "dfuedat" has value "31.12.94"
Then field "ident" has value "008"
And I save the current editor

# Stornierter Lieferschein +LS08
Given I open an editor "VKStornierterLS08" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "VKLieferschein08"
Then field "dfuesenden" has value "nein"
Then field "dfuedat" has value "31.12.94"
And I close the current editor


Scenario: VK 09 Lieferschein mit EDI Angaben wird storniert.
Given I open an editor "VKLieferschein09" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | kunde      | 1    |
  | such       | LS09 |
  | dfuesenden | true |
  | dfuedat    | -2	  |
  | ueb        | ja   |
  | tterm      | .    |
  | budat      | .    |
# Feld "evident" bleibt leer -> Feld "dfuedat" wird im Storno-LS geleert
Then field "ident" has value ""
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "9" in row 1
And I save the current editor

# Storno Lieferschein
Given I open an editor "StornoLieferschein09" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "VKLieferschein09"
Then field "dfuesenden" has value "nein"
Then field "dfuedat" has value "31.12.94"
And I save the current editor

# Stornierter Lieferschein +LS09
Given I open an editor "VKStornierterLS09" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "VKLieferschein09"
Then field "dfuesenden" has value "nein"
Then field "dfuedat" has value "31.12.94"
And I close the current editor


#########  EINKAUF  ########

@Einkauf
@Lieferschein
@Retoure
Scenario: 07 Lieferschein ohne Packmittel, Ruecklieferschein mit Packmitteln
Given I open an editor "Bestellung07" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "500" in row 1
And I save the current editor

Given I open an editor "Lieferschein07a" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung07"
Then the table has 1 rows
And I set field "vom" to "."
And I set field "ebeleg" to "LS-07a"
And I set field "mge" to "200" in row 1
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "Lieferschein07b" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "Lieferschein07a"
And I set field "vom" to "."
And I set field "ebeleg" to "LS-07b Rueckgabe"
And I set field "mge" to "-100" in row 1
# AB die Felder Packanweisung und Fuellmenge sind im Ruecklieferschein schreibgeschuetzt
# And I set field "packanw" to "501" in row 1
# And I set field "fmenge" to "10" in row 1
And pressing button "packvor" throws the exception "551"
And pressing button "pastnrgen" throws the exception "551"
And I save the current editor


@Einkauf
@Lieferschein
@Retoure
Scenario: 08 Lieferschein mit Packmitteln, Ruecklieferschein mit Packmitteln
Given I open an editor "Bestellung08" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "500" in row 1
And I save the current editor

Given I open an editor "Lieferschein08a" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung08"
Then the table has 1 rows
And I set field "vom" to "."
And I set field "ebeleg" to "LS-08a"
And I set field "mge" to "200" in row 1
And I set field "packanw" to "501" in row 1
And I set field "fmenge" to "10" in row 1
And I press button "packvor"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "Lieferschein08b" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "Lieferschein08a"
And I set field "vom" to "."
And I set field "ebeleg" to "LS-08b Rueckgabe"
And I set field "mge" to "-100" in row 1
Then field "packanw" has value "501" in row 1
Then field "fmenge" has value "10" in row 1
And pressing button "packvor" throws the exception "551"
And pressing button "pastnrgen" throws the exception "551"
And I save the current editor


@Einkauf
@Lieferschein
@Retoure
Scenario: 09 Lieferschein mit Packmitteln, Ruecklieferschein mit anderer Packanweisung
Given I open an editor "Bestellung09" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "500" in row 1
And I save the current editor

Given I open an editor "Lieferschein09a" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung09"
Then the table has 1 rows
And I set field "vom" to "."
And I set field "ebeleg" to "LS-09a"
And I set field "mge" to "200" in row 1
And I set field "packanw" to "501" in row 1
And I set field "fmenge" to "10" in row 1
And I press button "packvor"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "Lieferschein09b" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "Lieferschein09a"
And I set field "vom" to "."
And I set field "ebeleg" to "LS-09b Rueckgabe"
And I set field "mge" to "-100" in row 1
# AB die Felder Packanweisung und Fuellmenge sind im Ruecklieferschein schreibgeschuetzt
# And I set field "packanw" to "PACKA1" in row 1
# And I set field "fmenge" to "10" in row 1
And pressing button "packvor" throws the exception "551"
And pressing button "pastnrgen" throws the exception "551"
And I save the current editor


@Einkauf
@RechnungmitLagerbewegung
@Retoure
Scenario: 10 Rechnung mit Lagerbewegung ohne Packmittel, Ruecklieferung mit Packmitteln
Given I open an editor "Bestellung10" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "500" in row 1
And I save the current editor

Given I open an editor "Rechnung10a" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "Bestellung10"
Then the table has 1 rows
And I set field "fakt" to "JA"
And I set field "vom" to "."
And I set field "ebeleg" to "RE-10a"
And I set field "mge" to "200" in row 1
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I save the current editor


@Einkauf
@RechnungmitLagerbewegung
@Retoure
Scenario: 11 Rechnung mit Lagerbewegung und Packmitteln, Ruecklieferung mit Packmitteln
Given I open an editor "Bestellung11" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "500" in row 1
And I save the current editor

Given I open an editor "Rechnung11a" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "Bestellung11"
Then the table has 1 rows
And I set field "fakt" to "JA"
And I set field "vom" to "."
And I set field "ebeleg" to "RE-11a"
And I set fields
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |
And I set field "mge" to "200" in row 1
And I set field "packanw" to "501" in row 1
And I set field "fmenge" to "10" in row 1
And I save the current editor

Given I open an editor "Rechnung11b" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "Rechnung11a"
And I set field "vom" to "."
And I set field "ebeleg" to "RE-11b Rueckgabe"
And I set field "mge" to "-100" in row 1
Then field "packanw" has value "501" in row 1
Then field "fmenge" has value "10" in row 1
And pressing button "packvor" throws the exception "551"
And pressing button "pastnrgen" throws the exception "551"
And I save the current editor


@Einkauf
@RechnungmitLagerbewegung
@Retoure
Scenario: 12 Rechnung mit Lagerbewegung und Packmitteln, Ruecklieferung mit anderer Packanweisung
Given I open an editor "Bestellung12" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "500" in row 1
And I save the current editor

Given I open an editor "Rechnung12a" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "Bestellung12"
Then the table has 1 rows
And I set field "fakt" to "JA"
And I set field "vom" to "."
And I set field "ebeleg" to "RE-12a"
And pressing button "packvor" throws the exception ""
And I set fields
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |
And I set field "mge" to "200" in row 1
And I set field "packanw" to "501" in row 1
And I set field "fmenge" to "10" in row 1
And I save the current editor

Given I open an editor "Rechnung12b" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "Rechnung12a"
And I set field "vom" to "."
And I set field "ebeleg" to "RE-12b Rueckgabe"
And I set field "mge" to "-100" in row 1
# Die Felder Packanweisung und Fuellmenge sind im Ruecklieferschein schreibgeschuetzt
Then field "packanw" is not modifiable in row 1
Then field "fmenge" is not modifiable in row 1
And pressing button "packvor" throws the exception "551"
And pressing button "pastnrgen" throws the exception "551"
And I save the current editor

@Verkauf
@Auftrag
@Lieferschein
@Storno
Scenario: 13 Auftrag mit Artikel (mit einer Packanweisung), Lieferschein, Lieferschein stornieren

Given I open an editor "FAHRRAD" from table "(Part):(Product)" with command "STORE" for record "FAHRRAD"
And I set field "packanwstdla" to "501"
And I set field "packanwstdversand" to "501"
And I save the current editor

Given I open an editor "Auftrag13" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | Radshop |
    | such  | AU013   |
    | tterm | .       |
    | vom   | .       |
And I create a new row at the end of the table
And I set field "artikel" to "FAHRRAD" in row 1
And I set field "mge" to "300" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "Fahrrad" in row 2
And I set field "mge" to "250" in row 2
And I save the current editor

# Lieferschein aus Auftrag
Given I open an editor "Lieferschein13" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag13"
And I set field "mge" to "400" in row 1
And I set field "fmenge" to "100" in row 1
And I press button "offueb" in row 1
Then field "mge" has value "0" in row 2
Then field "ofmge" has value "150" in row 2
And I press button "packvor"
And I set field "ueb" to "ja"
Then the table has 5 rows
And I save the current editor

# Storno LS13 - Position mit leerer Menge wird nicht uebernommen
Given I open an editor "Lieferschein13_Storno" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "Lieferschein13"
Then the table has 4 rows
And I save the current editor

