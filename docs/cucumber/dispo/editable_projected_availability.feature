@persistent
Feature: editable_projected_availability.feature

# **********************************************************************************
#  Name             : editable_projected_availability.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : bheim
#  Funktion         : Testet die editierbare Plankarte
#  ref              : ref_editable_projected_availability_cu
#  Stammdaten       : basis_stammdaten.feature
#
# **********************************************************************************
Background:
And I set the fake date to "4.10.2023"

Scenario: 01 Ein paar Bewegungsdaten

Given I open an editor "Bestell1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "LIEFER1"
And I append rows
    | artikel       | mge   |
    | EK1-AUFTRAG    | 100   |
And I save the current editor

Given I open an editor "Auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I append rows
    | artikel   | mge     | bsart             | wtterm |
    | EK1-AUFTRAG | 120   | Eigenfertigung    | +5     |
    | EK1-AUFTRAG | 150   | Fremdbeschaffung  | +15    |
    | BG-Variante |   2   | Fremdbeschaffung  | +10    |
    | BG-Variante |   2   | Fremdbeschaffung  | +20    |
    | BG-Variante |  12   | Fremdbeschaffung  | +30    |
And I save the current editor

Scenario: 02 Ein Blick auf die Plankarte und mal die Filterbutton gedrueckt, Danach Dispo

Given I open an editor "Auftrag1" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "UPDATE" for record ""
And I set field "Artikel" to "EK1-AUFTRAG"
And I press button "ladetab"
Then the table has 4 rows
Then table has values
    | bs  | mz | reserv |
    | E * |    |        |
    |     |    |        |
    |     |    | E *    |
    |     |    | E *    |
And pressing button "bufilter" in row 4 throws the exception "2409"
Then I press button "bufilter" in row 1
Then the table has 4 rows
And I close the current editor

And I run Scheduling

Scenario: 04 neu zuordnen ueber die bool-Felder

Given I open an editor "Ed_plan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "UPDATE" for record ""
And I set field "Artikel" to "EK1-AUFTRAG"
And I press button "ladetab"
Then the table has 5 rows
Then table has values
    | bs  | mz | reserv |
    | E * | *  | E *    |
    |     |    |        |
    | E * | *  | E *    |
    |     |    |        |
    | E * | *  | E *    |
And I set field "bzuordnen" to "true" in row 1
And I set field "rzuordnen" to "true" in row 5
And I press button "buzuordnen"
Then the table has 8 rows
And I close the current editor

Scenario: 05 neuzuordnen ueber Filter und Mengen verteilen.

Given I open an editor "Ed_plan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "UPDATE" for record ""
And I set field "Artikel" to "EK1-AUFTRAG"
And I press button "ladetab"
Then the table has 5 rows
And I press button "bufilter" in row 1
And I set field "neulzuomge" to "50" in row 1
Then field "verfuegmge" has value "50"
And I set field "neulzuomge" to "50" in row 5
And I press button "buzuordnen"
And I save the current editor

Scenario: 06 Stoepseln

Given I open an editor "Ed_plan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "UPDATE" for record ""
And I set field "Artikel" to "EK1-AUFTRAG"
And I press button "ladetab"
Then the table has 9 rows
And I set field "lzuomge" to "30" in row 3
And I set field "bis" to "+10" in row 3
And I save the current editor

Scenario: 07 Variante trennen, Bestaetigungsfrage

Given I open an editor "Ed_plan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "UPDATE" for record ""
And I set field "Artikel" to "BG-Variante"
And I press button "ladetab"
Then the table has 5 rows
And I set field "lzuomge" to "2" in row 3
And I respond with answer "Ja" to the dialog with id "6769"
And I set field "lzuomge" to "1" in row 3
And I respond with answer "Ja" to the dialog with id "4176"
And I set field "lzuomge" to "0" in row 1
Then the table has 9 rows
And I save the current editor

Scenario: 08 Keine Menge zuordnen in Trennzeilen
Given I open an editor "Ed_plan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "UPDATE" for record ""
And I set field "Artikel" to "EK1-AUFTRAG"
And I press button "ladetab"
Then the table has 10 rows
And setting field "lzuomge" to "0" in row 2 throws the exception "203"
And I close the current editor

Scenario: 09 Keine Zeilen loeschen
Given I open an editor "Ed_plan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "UPDATE" for record ""
And I set field "Artikel" to "EK1-AUFTRAG"
And I press button "ladetab"
Then the table has 10 rows
Then deleting the row at position 1 throws the exception "3885"
Then deleting the row at position 2 throws the exception "3885"
Then deleting the row at position 3 throws the exception "3885"
Then deleting the row at position 4 throws the exception "3885"
Then deleting the row at position 4 throws the exception "3885"
Then deleting the row at position 5 throws the exception "3885"
Then deleting the row at position 6 throws the exception "3885"
Then deleting the row at position 7 throws the exception "3885"
Then deleting the row at position 8 throws the exception "3885"
Then deleting the row at position 9 throws the exception "3885"
Then deleting the row at position 10 throws the exception "3885"
And I close the current editor


Scenario: 10 Variante trennen und Autragsbezogene Beschaffung zuordnen

# Variante trennen
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==BG-Variante;mge==12;gruppe=2"
And I respond with answer "Ja" to the dialog with id "396"
And I set field "mge" to "0" in row 1
And I save the current editor

# Eine auftragsbezogene Beschaffung anlegen
Given I open an editor "bestellung-var" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "730-VAR"
And I create a new row at the end of the table
And I set field "artex" to "BG-Variante" in row 1
And I set field "mge" to "12" in row 1
And I set field "preis" to "730" in row 1
And I set field "verw" to "200001_5" in row 1
And I save the current editor

# Variantenbezogener Bedarf und auftragsbezogene Beschaffung zuordnen
Given I open an editor "Ed_plan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "UPDATE" for record ""
And I set field "Artikel" to "BG-Variante"
And I press button "ladetab"
Then the table has 10 rows
And I set field "bzuordnen" to "ja" in row 1
And I set field "rzuordnen" to "ja" in row 10
And I press button "buzuordnen"
And I save the current editor

And I run Scheduling

# Nach dem Dispolauf sind beide immer noch zugeordnet
Given I open an editor "Ed_plan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "UPDATE" for record ""
And I set field "Artikel" to "BG-Variante"
And I press button "ladetab"
Then the table has 5 rows
And I close the current editor

# Lieferschein mit Teillieferung zu Bestellung anlegen und buchen
Given I open an editor "lieferschein-730" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-var"
And I set field "num4" to "730-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "6" in row 1
And I save the current editor

And I run Scheduling

# Nach dem Dispolauf sind der Lagerbestand und der Rest der Bestelleung immer noch zugeordnet
Given I open an editor "Ed_plan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "UPDATE" for record ""
And I set field "Artikel" to "BG-Variante"
And I press button "ladetab"
Then the table has 7 rows
Then table has values
    | bs  | mz | reserv | lzuomge |
    | L * | *  | E *    |   6     |
    |     |    |        |         |
    | E * | *  | E *    |   6     |
    |     |    |        |         |
    | E * | *  | E *    |   2     |
    |     |    |        |         |
    |     |    | E *    |   2     |
And I close the current editor

Scenario: 11 Bedarfsmenge in AU reduzieren und vor dem Dispolauf die Plankarte ändern -> diag

Given I open an editor "Auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "nummer" to "45932178"
And I append rows
    | artikel     | mge     | bsart             |
    | EK1-AUFTRAG | 20      | Fremdbeschaffung  |
And I save the current editor

And I run Scheduling

Given I open an editor "Auftrag2" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "45932178"
And I modify table
  | !row  | mge  |
  |  1    |  15  |
And I save the current editor
And I close the current editor

# Nach dem Dispolauf ist die zuomge > als die Bedarfsmenge -> diag wenn sie auf die Bedarfsmenge gesetzt wird
Given I open an editor "Ed_plan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "UPDATE" for record ""
And I set field "Artikel" to "EK1-AUFTRAG"
And I press button "ladetab"
And I set field "lzuomge" to "15" in row 1
And I press button "buzuordnen"
And I save the current editor
And I close the current editor
