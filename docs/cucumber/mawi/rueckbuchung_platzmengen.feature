# *****************************************************************************
#  Name             : rueckbuchung_platzmengen.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Platzmengen bei Rueckbuchung und Storno Rueckbuchung
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_platzmengen.feature
Background:
Given I set the fake date to "05.01.95"

Scenario Outline: 00 Artikel anlegen
Given I open an editor "<suchw>" from table "(Part):(Product)" with command "STORE" for record "<suchw>"

And I set fields
    | such      | <suchw>    |
    | namebspr  | <namebspr> |
    | zuplatz   | MLF01      |
    | abplatz   | MLF01      |

And I save the current editor

Examples: Artikel
| suchw   | namebspr |
| ZUGANG1 | Zugang 1 |
| ZUGANG2 | Zugang 2 |
| ZUGANG3 | Zugang 3 |
| ZUGANG4 | Zugang 4 |
| ZUGANG5 | Zugang 5 |
| ABGANG1 | Abgang 1 |
| ABGANG2 | Abgang 2 |
| ABGANG3 | Abgang 3 |

Scenario: Zugaenge buchen und Platzmengen pruefen
Given I open an editor "EKLieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | PUKY    |
    | nummer    | 1ls     |
    | vom       | .       |
    | ebeleg    | 01LS    |
    | ueb       | ja      |
And I append rows
    | artikel   | mge     | preis | platz |
    | ZUGANG1   | 10      | 10.00 | MLF01 |
    | ZUGANG2   | 10      | 11.00 | MLF01 |
    | ZUGANG3   | 10      | 12.00 | MLF01 |
    | ZUGANG4   | 10      | 13.00 | MLF01 |
    | ZUGANG5   | 10      | 14.00 | MLF01 |
And I save the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "ZUGANG1" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | 10     | 1    | 10     |
And I close the current editor

Given I query StorageQuantity for Product "ZUGANG2" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | 10     | 1    | 10     |
And I close the current editor

Given I query StorageQuantity for Product "ZUGANG3" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | 10     | 1    | 10     |
And I close the current editor

Given I query StorageQuantity for Product "ZUGANG4" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | 10     | 1    | 10     |
And I close the current editor

Given I query StorageQuantity for Product "ZUGANG5" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | 10     | 1    | 10     |
And I close the current editor

Scenario: Rueckbuchung auf Zugaenge
Given I open an editor "RLS1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EKLieferschein"
And I set fields
    | nummer    | 1rls    |
    | vom       | .       |
    | ebeleg    | 01RLS   |
    | ueb       | ja      |
And I modify table
    | !row               | mge |
    | artikel=='ZUGANG1' | -9  |
    | artikel=='ZUGANG2' | -10 |
And I save the current editor

# Platzmengen pruefen

Given I query StorageQuantity for Product "ZUGANG1" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | 1      | 1    | 1      |
And I close the current editor

Given I query StorageQuantity for Product "ZUGANG2" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

Scenario: Rueckbuchung auf Zugaenge stornieren
Given I open an editor "SRLS1" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS1"
And I set fields
    | nummer    | 1srls   |
And I save the current editor

# Platzmengen pruefen

Given I query StorageQuantity for Product "ZUGANG1" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    |  1     | 1    |  1     |
	|  9     | 1    |  9     |
And I close the current editor

Given I query StorageQuantity for Product "ZUGANG2" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | 10     | 1    | 10     |
And I close the current editor

Scenario: Abgang buchen - Bestand vorhanden
Given I open an editor "VKLieferschein1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP |
    | nummer    | 2ls     |
    | ueb       | ja      |
And I append rows
    | artikel   | mge     | preis | platz |
    | ZUGANG3   |  9      | 12.00 | MLF01 |
    | ZUGANG4   | 10      | 13.00 | MLF01 |
    | ZUGANG5   | 11      | 14.00 | MLF01 |
And I save the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "ZUGANG3" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | 1      | 1    | 1      |
And I close the current editor

Given I query StorageQuantity for Product "ZUGANG4" on StorageLocation "MLF01"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "ZUGANG5" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | -1     | 1    | -1     |
And I close the current editor

Scenario: Rueckbuchung auf Abgang - Bestand war vorhanden
Given I open an editor "RLS2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLieferschein1"
And I set fields
    | nummer    | 2rls    |
    | ueb       | ja      |
And I modify table
    | !row               | mge |
    | artikel=='ZUGANG3' | -5  |
    | artikel=='ZUGANG4' | -5  |
    | artikel=='ZUGANG5' | -5  |
And I save the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "ZUGANG3" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | 1      | 1    | 1      |
	| 5      | 1    | 5      |
And I close the current editor

Given I query StorageQuantity for Product "ZUGANG4" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | 5      | 1    | 5      |
And I close the current editor

Given I query StorageQuantity for Product "ZUGANG5" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | 4      | 1    | 4      |
And I close the current editor

Scenario: Rueckbuchung auf Abgang stornieren - Bestand war vorhanden
Given I open an editor "SRLS2" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS2"
And I set fields
    | nummer    | 2srls   |
And I save the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "ZUGANG3" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | 1      | 1    | 1      |
And I close the current editor

Given I query StorageQuantity for Product "ZUGANG4" on StorageLocation "MLF01"
Then StorageQuantity is zero

Given I query StorageQuantity for Product "ZUGANG5" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | -1     | 1    | -1     |
And I close the current editor

Scenario: Abgang buchen - Kein Bestand vorhanden
Given I open an editor "VKLieferschein2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP |
    | nummer    | 3ls     |
    | ueb       | ja      |
And I append rows
    | artikel   | mge     | preis | platz |
    | ABGANG1   | 20      | 12.00 | MLF01 |
    | ABGANG2   | 20      | 13.00 | MLF01 |
    | AbGANG3   | 20      | 14.00 | MLF01 |
And I save the current editor

# Platzmengen pruefen

Given I query StorageQuantity for Product "ABGANG1" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | -20    | 1    | -20    |
And I close the current editor

Given I query StorageQuantity for Product "ABGANG2" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | -20    | 1    | -20    |
And I close the current editor

Given I query StorageQuantity for Product "ABGANG3" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | -20    | 1    | -20    |
And I close the current editor

Scenario: Rueckbuchung auf Abgang - Negative Menge auf Platz
Given I open an editor "RLS3" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLieferschein2"
And I set fields
    | nummer    | 3rls    |
    | ueb       | ja      |
And I modify table
    | !row               | mge |
    | artikel=='ABGANG1' | -9  |
    | artikel=='ABGANG2' | -10 |
    | artikel=='ABGANG3' | -11 |
And I save the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "ABGANG1" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | -11    | 1    | -11    |
And I close the current editor

Given I query StorageQuantity for Product "ABGANG2" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | -10    | 1    | -10    |
And I close the current editor

Given I query StorageQuantity for Product "ABGANG3" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | -9     | 1    | -9     |
And I close the current editor

Scenario: Rueckbuchung auf Abgang stornieren - Bestand war vorhanden
Given I open an editor "SRLS3" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS3"
And I set fields
    | nummer    | 3srls   |
And I save the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "ABGANG1" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | -20    | 1    | -20    |
And I close the current editor

Given I query StorageQuantity for Product "ABGANG2" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | -20    | 1    | -20    |
And I close the current editor

Given I query StorageQuantity for Product "ABGANG3" on StorageLocation "MLF01"
Then StorageQuantities have values
    | gebmge | gebf | bewmge |
    | -20    | 1    | -20    |
And I close the current editor
