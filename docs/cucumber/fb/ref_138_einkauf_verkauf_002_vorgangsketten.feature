# *****************************************************************************
#  Name             : ref_138_einkauf_verkauf_002_vorgangsketten.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : "evkvnum" in EK/VK: Editierbarkeit, Plausis, ...
#
# *****************************************************************************
@persistent
Feature: ref_138_einkauf_verkauf_002_vorgangsketten.feature
Background:

Scenario Outline: einfache Ketten in EK/VK

Given I open an editor "order<num>" from table "<db>" with command "NEW" for record ""
And I set field "<kulief>" to "<kuliefnum>"
And I set field "nummer" to "<nummer>au"
When I create a new row at the end of the table
And I set field "artex" to "<art1>" in row 1
And I set field "mge" to "<mge>" in row 1
And I set field "preis" to "3" in row 1
And I set field "platz" to "F3" in row 1
Then field "kvnum" is modifiable in row 1
Then field "kvnum" has value "" in row 1
And I set field "kvnum" to "test<num>" in row 1
When I create a new row at the end of the table
And I set field "artex" to "ANZ" in row 2
Then field "kvnum" is modifiable in row 2
Then field "kvnum" has value "" in row 2
When I create a new row at the end of the table
And I set field "artex" to "ANZ" in row 3
Then field "kvnum" is modifiable in row 3
Then field "kvnum" has value "" in row 3
And I set field "kvnum" to "anz<num>" in row 3
And I save the current editor

# Anzahlungsrechnung anlegen
Given I open an editor "anzahlungsrechnung<num>" from table "<db2>:(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "order<num>"
Then field "vorgang" has value "R" in row 0
And I set field "vorgang" to "Anzahlung"
Then field "vorgang" has value "A" in row 0
And I set field "nummer" to "<nummer>anz"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
#
Then field "kvnum" has value "<nummer>au" in row 1
And I set field "pwert" to "77" in row 1
Then field "kvnum" has value "anz<num>" in row 2
And I set field "pwert" to "22" in row 2
#
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Schlussrechnung anlegen
Given I open an editor "schlussrechnung<num>" from table "<db2>:(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "order<num>"
And I set field "nummer" to "<nummer>re"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I set field "gart" to "<gart>"
And I press button "offueb" in row 1
#
Then field "kvnum" has value "test<num>" in row 1
Then field "kvnum" has value "<nummer>au" in row 2
Then field "kvnum" has value "anz<num>" in row 3
#
And I respond with answer "Ja" to the dialog with id "<fehler>"
And I save the current editor

Examples: EK/VK
| num| db                          | db2         | kulief| kuliefnum| nummer| art1| mge| gart|fehler|
# Verkauf
| 1  | (Sales):(SalesOrder)        | (Sales)     | kunde | 001      | 10010 | V1  | 110|     |4841|
| 2  | (Sales):(SalesOrder)        | (Sales)     | kunde | 70002    | 10015 | V3  | 75 | 900 |4841|
# Einkauf
| 1  | (Purchasing):(PurchaseOrder)| (Purchasing)| lief  | 001      | 10010 | E1  | 110|     |4841|
| 2  | (Purchasing):(PurchaseOrder)| (Purchasing)| lief  | 10008    | 10010 | E3  | 140|     |4841|
########################################################################################################


Scenario Outline: lange Kette VK

Given I open an editor "order<num>" from table "<db>" with command "NEW" for record ""
And I set field "<kulief>" to "<kuliefnum>"
And I set field "nummer" to "<nummer>au"
When I create a new row at the end of the table
And I set field "artex" to "<art1>" in row 1
And I set field "mge" to "<mge>" in row 1
And I set field "preis" to "3" in row 1
And I set field "platz" to "F3" in row 1
Then field "kvnum" is modifiable in row 1
Then field "kvnum" has value "" in row 1
And I set field "kvnum" to "test<num>" in row 1
When I create a new row at the end of the table
And I set field "artex" to "ANZ" in row 2
Then field "kvnum" is modifiable in row 2
Then field "kvnum" has value "" in row 2
When I create a new row at the end of the table
And I set field "artex" to "ANZ" in row 3
Then field "kvnum" is modifiable in row 3
Then field "kvnum" has value "" in row 3
And I set field "kvnum" to "anz<num>" in row 3
And I save the current editor

# Anzahlungsrechnung1 anlegen
Given I open an editor "anzahlungsrechnung<num>" from table "<db2>:(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "order<num>"
Then field "vorgang" has value "R" in row 0
And I set field "vorgang" to "Anzahlung"
Then field "vorgang" has value "A" in row 0
And I set field "nummer" to "<nummer>anz1"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
#
Then the table has 2 rows
Then field "kvnum" has value "<nummer>au" in row 1
And I set field "pwert" to "77" in row 1
And I delete row at position 2
#
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Anzahlungsrechnung2 anlegen
Given I open an editor "anzahlungsrechnung<num>" from table "<db2>:(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "order<num>"
Then field "vorgang" has value "K" in row 0
And I set field "vorgang" to "Anzahlung"
Then field "vorgang" has value "A" in row 0
And I set field "nummer" to "<nummer>anz2"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
#
Then the table has 2 rows
And I delete row at position 1
Then field "kvnum" has value "anz<num>" in row 1
And I set field "pwert" to "22" in row 1
#
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Anzahlungsrechnung3 anlegen
Given I open an editor "anzahlungsrechnung<num>" from table "<db2>:(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "order<num>"
Then field "vorgang" has value "K" in row 0
And I set field "vorgang" to "Anzahlung"
Then field "vorgang" has value "A" in row 0
And I set field "nummer" to "<nummer>anz3"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
#
Then field "kvnum" has value "<nummer>au" in row 1
And I set field "pwert" to "100" in row 1
Then field "kvnum" has value "anz<num>" in row 2
And I set field "pwert" to "33" in row 2
#
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Lieferschein
Given I open an editor "lieferschein" from table "<db2>:(PackingSlip)" with command "NEW" for record from editor "order<num>"
And I set field "nummer" to "<nummer>ls"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I save the current editor


# Versuch Schlussrechnung aus dem Auftrag anzulegen: -> ohne Artikelposition
Given I open an editor "schlussrechnung1" from table "<db2>:(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "order<num>"
And I set field "nummer" to "<nummer>re"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I set field "gart" to "<gart>"
Then the table has 4 rows
And I press button "offueb" in row 1
#
Then field "kvnum" has value "<nummer>au" in row 1
Then field "kvnum" has value "<nummer>au" in row 2
Then field "kvnum" has value "anz<num>" in row 3
Then field "kvnum" has value "anz<num>" in row 4
#
# der Editor wird nicht gespeichert!!!
And I close the current editor

# 
Given I open an editor "schlussrechnung2" from table "<db2>:(Invoice)" with command "NEW" for record from editor "lieferschein"
And I set field "nummer" to "<nummer>re"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I set field "gart" to "<gart>"
Then field "vorgang" has value "R" in row 0
Then the table has 5 rows
And I press button "offueb" in row 1
#
Then field "kvnum" has value "test<num>" in row 1
Then field "kvnum" has value "<nummer>au" in row 2
Then field "kvnum" has value "<nummer>au" in row 3
Then field "kvnum" has value "anz<num>" in row 4
Then field "kvnum" has value "anz<num>" in row 5
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Buchung pruefen
Given I open an editor "buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,@richtung=rückwärts;@maxtreffer=1"
Then field "kvnum" has value "310re" in row 1
#
Then field "konto" has value "44000" in row 2
Then field "kvnum" has value "test<num>" in row 2
Then field "ewhbetr" has value "330.00" in row 2
#
Then field "konto" has value "44000" in row 3
Then field "kvnum" has value "<nummer>au" in row 3
Then field "ewsbetr" has value "177.00" in row 3
#
Then field "konto" has value "44000" in row 4
Then field "kvnum" has value "anz<num>" in row 4
Then field "ewsbetr" has value "55.00" in row 4
And I close the current editor


# STORNO-Schlussrechnung
Given I open an editor "schlussrechnung2" from table "<db2>:(Invoice)" with command "REVERSAL" for record from editor "schlussrechnung2"
Then field "kvnum" has value "test<num>" in row 1
Then field "kvnum" has value "<nummer>au" in row 2
Then field "kvnum" has value "<nummer>au" in row 3
Then field "kvnum" has value "anz<num>" in row 4
Then field "kvnum" has value "anz<num>" in row 5
Then the table has 8 rows
And I save the current editor


Examples: VK
| num| db                          | db2         | kulief| kuliefnum| nummer| art1| mge| gart|fehler|
| 1  | (Sales):(SalesOrder)        | (Sales)     | kunde | 001      | 310   | V1  | 110|     |4841|
########################################################################################################
