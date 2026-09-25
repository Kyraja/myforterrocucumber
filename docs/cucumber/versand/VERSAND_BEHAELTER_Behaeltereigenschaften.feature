@persistent
Feature: VERSAND_BEHAELTER_Behaeltereigenschaften.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Behaeltereigenschaften.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Eigenschaften von Behaeltern
#  ref				: ref_behaelter_eigenschaften_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Kopieren eines Behaelters leert Felder

Given I open an editor "behaelter1" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set fields
  | such  | behaelter1  |
  | kl    | L LIEFER1   |
  | packm | KLT         |
And I save the current editor

And I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "01" and Container "!behaelter1"

Given I open an editor "behaelter1" from table "(Container):(ContainerShell)" with command "COPY" for record from editor "behaelter1"
Then field "nummer" is empty
Then field "kl" is empty
Then field "such" is empty
Then field "exbehnum" is empty
Then field "behstatusaz" is empty
And I close the current editor


Scenario: 02 Gefuellter Behaelter kann nicht abgelegt werden, ablagef gesetzt und Schreibschutz bei abgelegtem Behaelter

And I create a Container "behaelter2_1" for packaging material "KLT"
And I create a Container "behaelter2_2" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "02" and Container "!behaelter2_1"

# Gefuellter Behaelter darf nicht abgelegt werden
Given I switch the current editor to editor "behaelter2_1"
Then field "ablagef" is not modifiable
And I close the current editor

Given I switch the current editor to editor "behaelter2_2" with command "UPDATE"
And I set field "ablagef" to "JA"
And I save the current editor

# In abgelegtem Behaelter sind die Kopffelder schreibgeschuetzt
Given I switch the current editor to editor "behaelter2_2" with command "UPDATE"
Then field "nummer" is not modifiable
Then field "such" is not modifiable
Then field "packm" is not modifiable
Then field "platz" is not modifiable
Then field "kl" is not modifiable
Then field "exbehnum" is not modifiable
Then the table has 0 rows
And I close the current editor


Scenario: 03 In das Feld packm koennen nur Packmittel eingetragen werden

Given I open an editor "behaelter3" from table "(Container):(ContainerShell)" with command "NEW" for record ""
# Fehler (aus Selektion, kann nicht geprueft werden): 8030 de     |Nur Behälter, Palette oder Container erlaubt.
# Fehler: 1361 de      |Ungültiger Feldwert
Then setting field "packm" to "EK1-BEDARF" throws the exception "1361"
And I close the current editor


Scenario: 04 Im einem leeren Behaelter ist behleer gesetzt

Given I create a Container "behaelter4" for packaging material "KLT"
Then field "behleer" from editor "behaelter4" in row 0 has value "ja"


Scenario: 05 Im durch LS erstellten und rueckgelieferten Behaelter ist behleer gesetzt

Given I open an editor "EK-Lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | ebeleg    | 05_EK-Lieferschein  |
  | lief      | LIEFER1             |
  | vom       | .                   |
  | ueb       | ja                  |
And I append rows
  | artikel     | mge   | exbehnum    | packm |
  | EK1-BEDARF  | 1     | behaelter5  | KLT   |
And I save the current editor

Given I open an editor "EK-Ruecklieferung" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EK-Lieferschein"
And I set fields
  | ebeleg  | Ruecklieferung_05  |
  | vom     | .                  |
  | ueb     | ja                 |
And I modify table
  | !row  | mge | behaelter   |
  | 1     | -1  | behaelter5  |
And I save the current editor

Given I open an editor "behaelter5" from table "(Container):(ContainerHead)" with command "VIEW" for record "behaelter5"
Then field "behstatusaz" has value "Rücklieferung"
Then field "behleer" has value "nein"
And I close the current editor


Scenario: 06 Im Behaelter koennen keine Zeilen eingefuegt werden

Given I create a Container "BEHLEER_6" for packaging material "KLT"
Given I create a Container "BEHGEFUELLT_6" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "07" and Container "!BEHGEFUELLT_6"

# Fehler: 294 de      |Es dürfen keine Zeilen ein- oder angefügt werden
And I switch the current editor to editor "BEHLEER_6" with command "UPDATE"
Then creating a new row at position 1 throws the exception "294"
And I close the current editor

And I switch the current editor to editor "BEHGEFUELLT_6" with command "UPDATE"
Then creating a new row at position 1 throws the exception "294"
And I close the current editor


Scenario: 07 Keine Diag beim Suchen einer Charge ueber die Objektauswahl eines Behaelters

# VERSAND-731
Given I create a Lot "CH_07" for Product "EK1-BEDARF_CH"
Given I create a Container "behaelter7" for packaging material "KLT"

Given I open an editor "Lagerbuchung08" for tip command "(Stockadjustment)" and arguments ""
And I set fields
  | artikel | EK1-BEDARF_CH |
  | buart   | Zugang        |
  | beleg   | 07_L          |
  | beldat  | .             |
And I append rows
  | mge | behaelter    | charge2 |
  | 10  | !behaelter7  | !CH_07  |
And I save the current editor

Given I open an editor "BehaelterSel" from table "(Container):(ContainerShell)" with command "VIEW" for record "$,,charge^such=CH_07;@maxtreffer=1;@bereich=(Yes);@maxtreffer=1;@bereich=(Yes)"
Then field "exnum" has value "CH_07" in row 1
And I close the current editor


Scenario: 08 Suchen einer Verwendung ueber die Objektauswahl eines Behaelters

Given I create a Container "behaelter8" for packaging material "KLT"

Given I open an editor "Lagerbuchung8" for tip command "(Stockadjustment)" and arguments ""
And I set fields
  | artikel   | EK1-AUFTRAG |
  | buart     | Zugang      |
  | beleg     | 8_L         |
  | beldat    | .           |
And I append rows
  | mge | behaelter   | verw        |
  | 10  | !behaelter8 | Verwendung8 |
And I save the current editor

Given I open an editor "BehaelterSel" from table "(Container):(ContainerShell)" with command "VIEW" for record "$,,verw==Verwendung8;@maxtreffer=1;@bereich=(Yes)"
Then field "verw" has value "Verwendung8" in row 1
And I close the current editor


Scenario: 09 Behaelter mit Inhalt kann nicht geloescht werden

Given I create a Container "behaelter9" for packaging material "KLT"
Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "9_L" and Container "!behaelter9"

# Fehler: 2752 de      |Behälter mit Inhalt kann nicht gelöscht werden.
Given I open an editor "Delete" from table "(Container):(ContainerShell)" with command "DELETE" for record "behaelter9"
Then saving the current editor throws the exception "2752"
And I close the current editor
